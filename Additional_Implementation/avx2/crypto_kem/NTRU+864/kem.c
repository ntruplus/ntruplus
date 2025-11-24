#include <stddef.h>
#include <stdint.h>
#include "api.h"
#include "params.h"
#include "symmetric.h"
#include "poly.h"
#include "Keccak_avx2/fips202.h"
#include "randombytes.h"

/*************************************************
* Name:        verify
*
* Description: Compares two byte arrays for equality in constant time.
*
* Arguments:   - const uint8_t *a: first byte array
*              - const uint8_t *b: second byte array
*              - size_t len:      length of the arrays
*
* Returns 0 if the arrays are equal, 1 otherwise.
**************************************************/
static inline int verify(const uint8_t *a, const uint8_t *b, size_t len)
{
    uint8_t acc = 0;

    for (size_t i = 0; i < len; i++)
        acc |= (uint8_t)(a[i] ^ b[i]);

    return (-(uint64_t)acc) >> 63;
}

/*************************************************
* Name:        genf_derand
*
* Description: Deterministically generates a secret polynomial f and its
*              multiplicative inverse finv in the NTT domain.
*
* Arguments:   - poly *f:     output polynomial f (NTT domain)
*              - poly *finv:  output multiplicative inverse of f
*                              in the NTT domain
*              - const uint8_t *coins: 32-byte deterministic seed
*
* Returns 0 on success; non-zero if f is not invertible in the NTT domain.
**************************************************/
static inline int genf_derand(poly *f, poly *finv, const uint8_t *coins)
{
    uint8_t buf[NTRUPLUS_N / 4];

    shake256(buf, sizeof buf, coins, 32);

    poly_cbd1(f, buf);
    poly_triple(f, f);
    f->coeffs[0] += 1;

    poly_ntt(f, f);

    return poly_baseinv(finv, f);
}

/*************************************************
* Name:        geng_derand
*
* Description: Deterministically generates a secret polynomial g and its
*              multiplicative inverse ginv in the NTT domain.
*
* Arguments:   - poly *g:      output polynomial g (NTT domain)
*              - poly *ginv:   output multiplicative inverse of g
*                               in the NTT domain
*              - const uint8_t *coins: 32-byte deterministic seed
*
* Returns 0 on success; non-zero if g is not invertible in the NTT domain.
**************************************************/
static inline int geng_derand(poly *g, poly *ginv, const uint8_t *coins)
{
    uint8_t buf[NTRUPLUS_N / 4];

    shake256(buf, sizeof buf, coins, 32);

    poly_cbd1(g, buf);
    poly_triple(g, g);

    poly_ntt(g, g);

    return poly_baseinv(ginv, g);
}

/*************************************************
* Name:        crypto_kem_keypair_derand
*
* Description: Computes the deterministic public and secret key pair from
*              the secret polynomials f and g and their multiplicative
*              inverses finv and ginv in the NTT domain.
*
* Arguments:   - uint8_t *pk:   output public key
*              - uint8_t *sk:   output secret key
*              - const poly *f:     secret polynomial f (NTT domain)
*              - const poly *finv:  multiplicative inverse of f (NTT domain)
*              - const poly *g:     secret polynomial g (NTT domain)
*              - const poly *ginv:  multiplicative inverse of g (NTT domain)
*
* Returns:     void
**************************************************/
static inline void crypto_kem_keypair_derand(uint8_t *pk, uint8_t *sk,
                                             const poly *f,  const poly *finv,
                                             const poly *g,  const poly *ginv)
{
    poly h, hinv, f2;

    poly_basemul(&h, g, finv);
    poly_basemul(&hinv, f, ginv);

    poly_ntt_pack(&h,&h);
    poly_ntt_pack(&f2,f);  
    poly_ntt_pack(&hinv,&hinv);

    poly_tobytes(pk, &h);
    poly_tobytes(sk, &f2);
    poly_tobytes(sk + NTRUPLUS_POLYBYTES, &hinv);
    hash_f(sk + 2 * NTRUPLUS_POLYBYTES, pk);
}

/*************************************************
* Name:        crypto_kem_keypair
*
* Description: Generates an NTRU+ public/secret key pair for the
*              CCA-secure key encapsulation mechanism. Secret
*              polynomials f and g and their NTT-domain inverses
*              are sampled internally using fresh randomness.
*
* Arguments:   - uint8_t *pk: output public key
*                (array of CRYPTO_PUBLICKEYBYTES bytes)
*              - uint8_t *sk: output secret key
*                (array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 on success.
**************************************************/
int crypto_kem_keypair(uint8_t *pk, uint8_t *sk)
{
    uint8_t coins[NTRUPLUS_SYMBYTES];

    poly f, finv;
    poly g, ginv;

    do {
        randombytes(coins, sizeof coins);
    } while (genf_derand(&f, &finv, coins));

    do {
        randombytes(coins, sizeof coins);
    } while (geng_derand(&g, &ginv, coins));

    crypto_kem_keypair_derand(pk, sk, &f, &finv, &g, &ginv);
    return 0;
}

/*************************************************
* Name:        crypto_kem_enc_derand
*
* Description: Deterministically performs NTRU+ KEM encapsulation using
*              the public key pk and the supplied randomness coins,
*              producing a ciphertext ct and shared secret ss.
*
* Arguments:   - uint8_t *ct:      output ciphertext
*              - uint8_t *ss:      output shared secret
*              - const uint8_t *pk:    input public key
*              - const uint8_t *coins: input randomness for
*                                      deterministic encapsulation
*
* Returns 0 on success.
**************************************************/
static inline int crypto_kem_enc_derand(uint8_t *ct, uint8_t *ss,
                                        const uint8_t *pk,
                                        const uint8_t *coins)
{
    uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES] = {0};
    uint8_t buf1[NTRUPLUS_SYMBYTES + NTRUPLUS_N / 4] = {0};
    uint8_t buf2[NTRUPLUS_POLYBYTES] = {0};

    poly c, h, r, m, r2;


    for (size_t i = 0; i < NTRUPLUS_N / 8; i++)
        msg[i] = coins[i];

    hash_f(msg + NTRUPLUS_N / 8, pk);
    hash_h(buf1, msg);

    poly_cbd1(&r, buf1 + NTRUPLUS_SYMBYTES);
    poly_ntt(&r, &r);
    poly_ntt_pack(&r2, &r);
    
    poly_tobytes(buf2, &r2);
    hash_g(buf2, buf2);

    poly_sotp_encode(&m, msg, buf2);  
    poly_ntt(&m, &m);

    poly_frombytes(&h, pk);
    poly_ntt_unpack(&h,&h);
    poly_basemul(&c, &h, &r);
    poly_add(&c, &c, &m);
    poly_ntt_pack(&c, &c);
    poly_tobytes(ct, &c);

    for (size_t i = 0; i < NTRUPLUS_SSBYTES; i++)
        ss[i] = buf1[i];

    return 0;    
}

/*************************************************
* Name:        crypto_kem_enc
*
* Description: Generates an NTRU+ KEM ciphertext ct and shared secret ss
*              using the public key pk. Fresh randomness is internally
*              sampled and used for encapsulation.
*
* Arguments:   - uint8_t *ct: output ciphertext
*                (array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - uint8_t *ss: output shared secret
*                (array of CRYPTO_BYTES bytes)
*              - const uint8_t *pk: input public key
*                (array of CRYPTO_PUBLICKEYBYTES bytes)
*
* Returns 0 on success.
**************************************************/
int crypto_kem_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk)
{
    uint8_t coins[NTRUPLUS_N / 8];

    randombytes(coins, sizeof coins);
    return crypto_kem_enc_derand(ct, ss, pk, coins);
}

/*************************************************
* Name:        crypto_kem_dec
*
* Description: Generates shared secret for given
*              cipher text and private key
*
* Arguments:   - unsigned char *ss: pointer to output shared secret
*                (an already allocated array of CRYPTO_BYTES bytes)
*              - const unsigned char *ct: pointer to input cipher text
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - const unsigned char *sk: pointer to input private key
*                (an already allocated array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success) or 1 (failure)
*
* On failure, ss will contain zero values.
**************************************************/
int crypto_kem_dec(unsigned char *ss,
                   const unsigned char *ct,
                   const unsigned char *sk)
{
	uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES] = {0};
	uint8_t buf1[NTRUPLUS_POLYBYTES] = {0};
	uint8_t buf2[NTRUPLUS_POLYBYTES] = {0};
	uint8_t buf3[NTRUPLUS_POLYBYTES+NTRUPLUS_SYMBYTES] = {0};

    int8_t fail;

    poly c, f, hinv;
    poly r1, r2;
    poly m1, m2;
    poly t1;

    poly_frombytes(&c, ct);
    poly_frombytes(&f, sk);
    poly_frombytes(&hinv, sk + NTRUPLUS_POLYBYTES);

    poly_ntt_unpack(&c, &c);
    poly_ntt_unpack(&f, &f);
    poly_ntt_unpack(&hinv, &hinv);

    poly_basemul(&t1, &c, &f);
    poly_invntt(&t1, &t1);
    poly_crepmod3(&m1, &t1);
    
    poly_ntt(&m2, &m1);
    poly_sub(&c, &c, &m2);
    poly_basemul(&r2, &c, &hinv);
    poly_ntt_pack(&r2, &r2);
    poly_tobytes(buf1, &r2);

    hash_g(buf2, buf1);
    fail = poly_sotp_decode(msg, &m1, buf2);

	for (int i = 0; i < NTRUPLUS_SYMBYTES; i++)
		msg[i + NTRUPLUS_N / 8] = sk[i + 2 * NTRUPLUS_POLYBYTES]; 

    hash_h(buf3, msg);

    poly_cbd1(&r1, buf3 + NTRUPLUS_SSBYTES);
    poly_ntt(&r1, &r1);
    poly_ntt_pack(&r1, &r1);
    poly_tobytes(buf2, &r1);
    
    fail |= verify(buf1, buf2, NTRUPLUS_POLYBYTES);

	for(int i = 0; i < NTRUPLUS_SSBYTES; i++)
		ss[i] = buf3[i] & ~(-fail);

    return fail;
}
