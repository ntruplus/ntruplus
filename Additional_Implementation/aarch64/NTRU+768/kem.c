#include "util.h"
#include <stddef.h>
#include <stdint.h>
#include "api.h"
#include "params.h"
#include "symmetric.h"
#include "poly.h"
#include "randombytes.h"

#ifdef SUPPORTS_SHAKE256_ASM
#include "CE/fips202.h"
#else
#include "NO_CE/fips202.h"
#endif

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
*              - uint8_t *buf: workspace of NTRUPLUS_N/4 bytes
*              - const uint8_t *coins: 32-byte deterministic seed
*
* Returns 0 on success; non-zero if f is not invertible in the NTT domain.
**************************************************/
static inline int genf_derand(poly *f, poly *finv,
                              uint8_t        buf[NTRUPLUS_N / 4],
                              const uint8_t *coins)
{
	shake256(buf, NTRUPLUS_N / 4, coins, 32);

	poly_cbd1_triple(f, buf);
	f->coeffs[0] += 1;

	poly_ntt(f);

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
*              - uint8_t *buf: workspace of NTRUPLUS_N/4 bytes
*              - const uint8_t *coins: 32-byte deterministic seed
*
* Returns 0 on success; non-zero if g is not invertible in the NTT domain.
**************************************************/
static inline int geng_derand(poly *g, poly *ginv,
                              uint8_t        buf[NTRUPLUS_N / 4],
                              const uint8_t *coins)
{
	shake256(buf, NTRUPLUS_N / 4, coins, 32);

	poly_cbd1_triple(g, buf);

	poly_ntt(g);

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
                                             const poly *f, const poly *finv,
                                             const poly *g, const poly *ginv)
{
	poly h;

	poly_basemul(&h, g, finv);
	poly_tobytes(pk, &h);

	poly_basemul(&h, f, ginv);
	poly_tobytes(sk, f);
	poly_tobytes(sk + NTRUPLUS_POLYBYTES, &h);
	hash_f(sk + 2 * NTRUPLUS_POLYBYTES, pk);

	u8_clear(&h, sizeof h);
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
int crypto_kem_keypair(unsigned char *pk, unsigned char *sk)
{
	uint8_t coins[NTRUPLUS_SYMBYTES];
	uint8_t buf[NTRUPLUS_N / 4];
	int     r;

	poly f, finv;
	poly g, ginv;

	do
	{
		randombytes(coins, sizeof coins);
		r = genf_derand(&f, &finv, buf, coins);
		ntruplus_declassify(&r, sizeof r);
	} while (r);

	do
	{
		randombytes(coins, sizeof coins);
		r = geng_derand(&g, &ginv, buf, coins);
		ntruplus_declassify(&r, sizeof r);
	} while (r);

	crypto_kem_keypair_derand(pk, sk, &f, &finv, &g, &ginv);

	u8_clear(coins, sizeof coins);
	u8_clear(buf, sizeof buf);
	u8_clear(&f, sizeof f);
	u8_clear(&finv, sizeof finv);
	u8_clear(&g, sizeof g);
	u8_clear(&ginv, sizeof ginv);

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
* Returns 0 on success. If pk contains a non-canonical coefficient, ct and ss
* are set to all zero bytes and 1 is returned.
**************************************************/
static inline int crypto_kem_enc_derand(uint8_t *ct, uint8_t *ss,
                                        const uint8_t *pk,
                                        const uint8_t *coins)
{
	uint8_t msg[HASH_H_INBYTES];
	uint8_t buf[HASH_H_OUTBYTES];

	poly c, h, r, m;

	int fail = poly_frombytes(&h, pk);
	ntruplus_declassify(&fail, sizeof fail);

	if (fail)
	{
		for (size_t i = 0; i < NTRUPLUS_CIPHERTEXTBYTES; i++)
			ct[i] = 0;
		u8_clear(ss, NTRUPLUS_SSBYTES);

		return 1;
	}

	for (size_t i = 0; i < NTRUPLUS_N / 8; i++)
		msg[i] = coins[i];

	hash_f(msg + NTRUPLUS_N / 8, pk);
	hash_h(buf, msg);

	poly_cbd1(&r, buf + NTRUPLUS_SYMBYTES);
	poly_ntt(&r);

	poly_tobytes(ct, &r);
	hash_g(ct, ct);
	poly_sotp_encode(&m, msg, ct);
	poly_ntt(&m);

	poly_basemul_add(&c, &h, &r, &m);
	poly_tobytes(ct, &c);

	for (size_t i = 0; i < NTRUPLUS_SSBYTES; i++)
		ss[i] = buf[i];

	u8_clear(msg, sizeof msg);
	u8_clear(buf, sizeof buf);
	u8_clear(&r, sizeof r);
	u8_clear(&m, sizeof m);

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
* Returns 0 on success. If pk contains a non-canonical coefficient, ct and ss
* are set to all zero bytes and 1 is returned.
**************************************************/
int crypto_kem_enc(unsigned char *ct, unsigned char *ss,
                   const unsigned char *pk)
{
	uint8_t coins[NTRUPLUS_N / 8];
	int     ret;

	randombytes(coins, sizeof coins);
	ret = crypto_kem_enc_derand(ct, ss, pk, coins);
	u8_clear(coins, sizeof coins);
	return ret;
}

/*************************************************
* Name:        crypto_kem_dec
*
* Description: Performs NTRU+ KEM decapsulation. Given a ciphertext ct
*              and a secret key sk, computes the shared secret ss. If
*              decapsulation fails, ss is set to all zero bytes.
*
* Arguments:   - uint8_t *ss:  output shared secret
*                (array of CRYPTO_BYTES bytes)
*              - const uint8_t *ct: input ciphertext
*                (array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - const uint8_t *sk: input secret key
*                (array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 on success, 1 on failure.
**************************************************/
int crypto_kem_dec(unsigned char *ss, const unsigned char *ct,
                   const unsigned char *sk)
{
	uint8_t msg[HASH_H_INBYTES];
	uint8_t buf0[HASH_G_INBYTES];
	uint8_t buf1[HASH_G_INBYTES];
	uint8_t buf2[HASH_H_OUTBYTES];

	int8_t fail = 1;

	poly c, f, hinv, m;

	int r  = poly_frombytes(&c, ct);
	r     |= poly_frombytes(&f, sk);
	r     |= poly_frombytes(&hinv, sk + NTRUPLUS_POLYBYTES);
	ntruplus_declassify(&r, sizeof r);

	if (r)
	{
		u8_clear(ss, NTRUPLUS_SSBYTES);

		goto cleanup;
	}

	poly_basemul_scale(&m, &c, &f);
	poly_invntt_scale(&m);
	poly_crepmod3(&m);

	f = m;
	poly_ntt(&f);
	poly_sub(&c, &c, &f);
	poly_basemul(&f, &c, &hinv);

	poly_tobytes(buf0, &f);
	hash_g(buf1, buf0);
	fail = poly_sotp_decode(msg, &m, buf1);

	for (size_t i = 0; i < HASH_F_OUTBYTES; i++)
		msg[i + NTRUPLUS_N / 8] = sk[i + 2 * NTRUPLUS_POLYBYTES];

	hash_h(buf2, msg);

	poly_cbd1(&f, buf2 + NTRUPLUS_SSBYTES);
	poly_ntt(&f);
	poly_tobytes(buf1, &f);

	fail |= verify(buf0, buf1, NTRUPLUS_POLYBYTES);

	for (size_t i = 0; i < NTRUPLUS_SSBYTES; i++)
		ss[i] = buf2[i] & ~(-fail);

cleanup:
	u8_clear(msg, sizeof msg);
	u8_clear(buf0, sizeof buf0);
	u8_clear(buf1, sizeof buf1);
	u8_clear(buf2, sizeof buf2);
	u8_clear(&c, sizeof c);
	u8_clear(&f, sizeof f);
	u8_clear(&hinv, sizeof hinv);
	u8_clear(&m, sizeof m);

	return fail;
}
