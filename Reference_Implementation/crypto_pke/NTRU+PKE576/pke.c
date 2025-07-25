#include <stddef.h>
#include <stdint.h>
#include "api.h"
#include "params.h"
#include "symmetric.h"
#include "poly.h"
#include "verify.h"
#include "fips202.h"
#include "randombytes.h"

/*************************************************
* Name:        crypto_encrypt_keypair
*
* Description: Generates public and private key for NTRU+PKE
*
* Arguments:   - unsigned char *pk: pointer to output public key
*                (an already allocated array of CRYPTO_PUBLICKEYBYTES bytes)
*              - unsigned char *sk: pointer to output private key
*                (an already allocated array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/
int crypto_encrypt_keypair(unsigned char *pk, unsigned char *sk)
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
* Name:        crypto_encrypt
*
* Description: Generates ciphertext for given plaintext and public key
*
* Arguments:   - unsigned char *c: pointer to output ciphertext
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - unsigned long long *clen: pointer to byte length of output ciphertext
*              - const unsigned char *m: pointer to input plaintext
*                (an already allocated array of CRYPTO_MAXPLAINTEXT bytes)
*              - unsigned long long mlen: byte length of input plaintext
*              - const unsigned char *pk: pointer to input public key
*                (an already allocated array of CRYPTO_PUBLICKEYBYTES bytes)
*
* Returns 0 (success) or 1 (failure)
**************************************************/
int crypto_encrypt(unsigned char *c,
                   unsigned long long *clen,
                   const unsigned char *m,
                   unsigned long long mlen,
                   const unsigned char *pk)
{
    uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES] = {0};
    uint8_t buf1[NTRUPLUS_SYMBYTES + NTRUPLUS_N / 4] = {0};
    uint8_t buf2[NTRUPLUS_POLYBYTES] = {0};

    poly p_c, p_h, p_r, p_m;

    int8_t fail;
    int32_t sub;    
    int32_t sign1, sign2;

    //length check
    fail = ((NTRUPLUS_MAXPLAINTEXT- mlen) >> 63);
   
    for(int i = 0; i < NTRUPLUS_MAXPLAINTEXT; i++)
    {
        sub = i - mlen;
        sign1 = sub >> 31;
        sign2 = (-sub) >> 31;

        msg[i] = ((m[i] & sign1) | ~(sign1 | sign2)) & ~(-fail);
    }

    sub = mlen - NTRUPLUS_MAXPLAINTEXT;
    sign1 = (sub | -sub) >> 31;
    msg[NTRUPLUS_MAXPLAINTEXT] = ~sign1;
   
    randombytes(msg + NTRUPLUS_N/8 - NTRUPLUS_RANDOMBYTES, NTRUPLUS_RANDOMBYTES);
    hash_f(msg + NTRUPLUS_N/8, pk);
    hash_h_pke(buf1, msg);

    poly_cbd1(&p_r, buf1);
    poly_ntt(&p_r, &p_r);
    
    poly_tobytes(buf2, &p_r);
    hash_g(buf2, buf2);

    poly_sotp(&p_m, msg, buf2);  
    poly_ntt(&p_m, &p_m);

    poly_frombytes(&p_h, pk);
	poly_basemul_add(&p_c, &p_h, &p_r, &p_m);
    poly_tobytes(c, &p_c);

    *clen = NTRUPLUS_CIPHERTEXTBYTES;

    return fail;
}
/*************************************************
* Name:        crypto_encrypt_open
*
* Description: Decrypts given ciphertext and private key
*
* Arguments:   - unsigned char *m: pointer to output plaintext
*                (an already allocated array of CRYPTO_MAXPLAINTEXT bytes)
*              - unsigned long long *mlen: pointer to byte length of output plaintext
*              - const unsigned char *c: pointer to input ciphertext
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - unsigned long long clen: byte length of input ciphertext
*              - const unsigned char *sk: pointer to input private key
*                (an already allocated array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success) or 1 (failure)
*
* On failure, m will contain zeros.
**************************************************/
int crypto_encrypt_open(unsigned char *m,
                        unsigned long long *mlen,
                        const unsigned char *c,
                        unsigned long long clen,
                        const unsigned char *sk)
{
    uint8_t msg[NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES] = {0};
    uint8_t buf1[NTRUPLUS_POLYBYTES] = {0};
    uint8_t buf2[NTRUPLUS_POLYBYTES] = {0};
    uint8_t buf3[NTRUPLUS_POLYBYTES + NTRUPLUS_SYMBYTES]= {0};

    int8_t fail;

    poly p_c, p_f, p_hinv;
    poly p_r1, p_r2;
    poly p_m1, p_m2;
    poly p_t1;

    int32_t sub;    
    int32_t sign;

    int32_t foundff = 0;
    int32_t ff = 0;
    int32_t zero = 0;

    fail = (clen != NTRUPLUS_CIPHERTEXTBYTES);
    *mlen = 0;

    poly_frombytes(&p_c, c);
    poly_frombytes(&p_f, sk);
    poly_frombytes(&p_hinv, sk + NTRUPLUS_POLYBYTES);

    poly_basemul(&p_t1, &p_c, &p_f);
    poly_invntt(&p_t1, &p_t1);
    poly_crepmod3(&p_m1, &p_t1);
    
    poly_ntt(&p_m2, &p_m1);
    poly_sub(&p_c, &p_c, &p_m2);
    poly_basemul(&p_r2, &p_c, &p_hinv);
    poly_tobytes(buf1, &p_r2);

    hash_g(buf2, buf1);
    fail = poly_sotp_inv(msg, &p_m1, buf2);

    for(int i = 0; i < NTRUPLUS_SYMBYTES; i++)
    {
        msg[i + NTRUPLUS_N/8] = sk[i + 2 * NTRUPLUS_POLYBYTES]; 
    }  

    hash_h_pke(buf3, msg);

    poly_cbd1(&p_r1, buf3);
    poly_ntt(&p_r1, &p_r1);
    poly_tobytes(buf2, &p_r1);
   
    fail |= verify(buf1, buf2, NTRUPLUS_POLYBYTES); 

    for(int i = NTRUPLUS_MAXPLAINTEXT; i >= 0; i--)
    {
        ff = msg[i] == 0xff;
        zero = msg[i] == 0x00;

        fail |= (~foundff) & !(zero || ff);
        *mlen |= (~foundff) & (-ff) & i;
        foundff |= -ff;
    }

    for(int i = 0; i < NTRUPLUS_MAXPLAINTEXT; i++)
    {
        sub = i - *mlen;
        sign = sub >> 31;

        m[i] = (msg[i] & sign) & ~(-fail);
    }

    return fail;
}
