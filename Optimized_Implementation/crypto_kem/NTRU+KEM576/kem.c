#include <stddef.h>
#include <stdint.h>
#include "api.h"
#include "params.h"
#include "symmetric.h"
#include "poly.h"
#include "fips202.h"
#include "randombytes.h"

/*************************************************
* Name:        verify
*
* Description: Compare two arrays for equality in constant time.
*
* Arguments:   const uint8_t *a: pointer to first byte array
*              const uint8_t *b: pointer to second byte array
*              size_t len:       length of the byte arrays
*
* Returns 0 if the byte arrays are equal, 1 otherwise
**************************************************/
static inline int verify(const uint8_t *a, const uint8_t *b, size_t len)
{
	size_t i;
	uint8_t r = 0;
	
	for(i=0;i<len;i++)
		r |= a[i] ^ b[i];
	
	return (-(uint64_t)r) >> 63;
}

/*************************************************
* Name:        crypto_kem_keypair
*
* Description: Generates public and private key
*              for CCA-secure NTRU+ key encapsulation mechanism
*
* Arguments:   - unsigned char *pk: pointer to output public key
*                (an already allocated array of CRYPTO_PUBLICKEYBYTES bytes)
*              - unsigned char *sk: pointer to output private key
*                (an already allocated array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/
int crypto_kem_keypair(unsigned char *pk, unsigned char *sk)
{
	uint8_t buf[NTRUPLUS_N / 4] = {0};
	
	poly f, finv;
	poly g;
	poly h, hinv;

	do {
		randombytes(buf, 32);
		shake256(buf, NTRUPLUS_N / 4, buf, 32);
		
		poly_cbd1(&f, buf);
		poly_triple(&f, &f);
		f.coeffs[0] += 1;
		poly_ntt(&f, &f);
	} while(poly_baseinv(&finv, &f));

	do {
		randombytes(buf, 32);
		shake256(buf, NTRUPLUS_N / 4, buf, 32);

		poly_cbd1(&g, buf); 
		poly_triple(&g, &g);
		poly_ntt(&g, &g);
		poly_basemul(&h, &g, &finv);
	} while(poly_baseinv(&hinv, &h));
	
	//pk
	poly_tobytes(pk, &h);
	
	//sk
	poly_tobytes(sk, &f);
	poly_tobytes(sk + NTRUPLUS_POLYBYTES, &hinv);	
	hash_f(sk + 2 * NTRUPLUS_POLYBYTES, pk); 
	
	return 0;
}

/*************************************************
* Name:        crypto_kem_enc
*
* Description: Generates cipher text and shared
*              secret for given public key
*
* Arguments:   - unsigned char *ct: pointer to output cipher text
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - unsigned char *ss: pointer to output shared secret
*                (an already allocated array of CRYPTO_BYTES bytes)
*              - const unsigned char *pk: pointer to input public key
*                (an already allocated array of CRYPTO_PUBLICKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/
int crypto_kem_enc(unsigned char *ct,
                   unsigned char *ss,
                   const unsigned char *pk)
{
    uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES] = {0};
    uint8_t buf1[NTRUPLUS_SYMBYTES + NTRUPLUS_N / 4] = {0};
    uint8_t buf2[NTRUPLUS_POLYBYTES] = {0};
	
	poly c, h, r, m;
	
	randombytes(msg, NTRUPLUS_N / 8);
	hash_f(msg + NTRUPLUS_N / 8, pk);
	hash_h_kem(buf1, msg);
	
	poly_cbd1(&r, buf1 + NTRUPLUS_SYMBYTES);
	poly_ntt(&r, &r);
	
	poly_tobytes(buf2, &r);
	hash_g(buf2, buf2);
	poly_sotp(&m, msg, buf2);  
	poly_ntt(&m, &m);
	
	poly_frombytes(&h, pk);
	poly_basemul_add(&c, &h, &r, &m);
	poly_tobytes(ct, &c);
	
	for (int i = 0; i < NTRUPLUS_SSBYTES; i++)
	{
		ss[i] = buf1[i];
	}
	
	return 0;
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
    uint8_t msg[NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES] = {0};
    uint8_t buf1[NTRUPLUS_POLYBYTES] = {0};
    uint8_t buf2[NTRUPLUS_POLYBYTES] = {0};
    uint8_t buf3[NTRUPLUS_POLYBYTES + NTRUPLUS_SYMBYTES]= {0};
	
	int8_t fail;
	
	poly c, f, hinv;
	poly r1, r2;
	poly m1, m2;
	
	poly_frombytes(&c, ct);
	poly_frombytes(&f, sk);
	poly_frombytes(&hinv, sk + NTRUPLUS_POLYBYTES);
	
	poly_basemul(&m1, &c, &f);
	poly_invntt(&m1, &m1);
	poly_crepmod3(&m1, &m1);
	
	poly_ntt(&m2, &m1);
	poly_sub(&c, &c, &m2);
	poly_basemul(&r2, &c, &hinv);

	poly_tobytes(buf1, &r2);
	hash_g(buf2, buf1);
	fail = poly_sotp_inv(msg, &m1, buf2);
	
	for (int i = 0; i < NTRUPLUS_SYMBYTES; i++)
	{
		msg[i + NTRUPLUS_N / 8] = sk[i + 2 * NTRUPLUS_POLYBYTES]; 
	}
	
	hash_h_kem(buf3, msg);
	
	poly_cbd1(&r1, buf3 + NTRUPLUS_SSBYTES);
	poly_ntt(&r1, &r1);
	poly_tobytes(buf2, &r1);
	
	fail |= verify(buf1, buf2, NTRUPLUS_POLYBYTES);
	
	for(int i = 0; i < NTRUPLUS_SSBYTES; i++)
	{
		ss[i] = buf3[i] & ~(-fail);
	}
	
	return fail;
}
