#include <stddef.h>
#include <stdint.h>
#include "kem.h"
#include "params.h"
#include "rng.h"
#include "symmetric.h"
#include "poly.h"
#include "verify.h"
#include "verify.h"
#include "crypto_stream.h"

static const unsigned char n[16] = {0};
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
    uint8_t buf[NTRUPLUS_N];
    poly f ,g, finv, ginv, h, hinv;
    int r;

    do {
        r = 0;
        randombytes(buf, 32);
        crypto_stream(buf, NTRUPLUS_N, n, buf);

        poly_cbd1(&f, buf); //f
        poly_triple(&f);
        f.coeffs[0] += 1;
        poly_ntt(&f);
        r = poly_baseinv(&finv, &f); //finv

        poly_cbd1(&g, buf + NTRUPLUS_N/4); //g 
        poly_triple(&g);
        poly_ntt(&g);
        r = poly_baseinv(&ginv, &g); //ginv

    } while(r);

    //sk
    poly_freeze(&f);  
    poly_tobytes(sk, &f);

    poly_basemul(&hinv, &f, &ginv); // hinv = fg^-1
    poly_freeze(&hinv);
    poly_tobytes(sk+NTRUPLUS_POLYBYTES, &hinv);

    //pk
    poly_basemul(&h, &g, &finv); // h = gf^-1
    poly_freeze(&h);
    poly_tobytes(pk, &h);
    
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
    poly c, h, r, m;
    uint8_t msg[NTRUPLUS_SYMBYTES];
    uint8_t buf1[144 + NTRUPLUS_SYMBYTES];
    uint8_t buf2[NTRUPLUS_POLYBYTES];
    uint8_t buf3[144];

    randombytes(msg, NTRUPLUS_SYMBYTES);

    hash_h(buf1, msg);
    poly_cbd1(&r, buf1 + NTRUPLUS_SYMBYTES);
    poly_ntt(&r);
    poly_freeze(&r);

    poly_tobytes(buf2, &r);
    hash_g(buf3, buf2);


    poly_sotp(&m, msg, buf3);
   
    poly_ntt(&m);

    poly_frombytes(&h, pk);
    poly_basemul(&c, &h, &r);
    poly_add(&c, &c, &m);
    poly_freeze(&c);
    poly_tobytes(ct, &c);

    for (int i = 0; i < NTRUPLUS_SSBYTES; i++)
    {
        ss[i] = buf1[i];
    }
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
* Returns 0.
*
* On failure, ss will contain a pseudo-random value.
**************************************************/
int crypto_kem_dec(unsigned char *ss,
                   const unsigned char *ct,
                   const unsigned char *sk)
{
    uint8_t buf1[NTRUPLUS_POLYBYTES];
    uint8_t buf2[NTRUPLUS_POLYBYTES + NTRUPLUS_SYMBYTES]= {0};
    uint8_t buf3[NTRUPLUS_POLYBYTES];
    uint8_t msg[NTRUPLUS_SYMBYTES];
    int8_t fail;

    poly c, f, hinv, r1, r2, t1, m;
    poly m2;
	uint8_t t = 0;
    poly_frombytes(&c, ct);
    poly_frombytes(&f, sk);
    poly_frombytes(&hinv, sk + NTRUPLUS_POLYBYTES);
    poly_basemul(&t1, &c, &f);
    poly_invntt(&t1);
    poly_crepmod3(&m, &t1);

    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        m2.coeffs[i] = m.coeffs[i];
    }
      
    poly_ntt(&m);
    poly_sub(&c,&c,&m);
    poly_freeze(&c);
    poly_basemul(&r2, &c, &hinv);
    poly_freeze(&r2);
    poly_tobytes(buf1, &r2);
    hash_g(buf3, buf1);

    poly_sotp_inv(msg, &m2, buf3);


    hash_h(buf2, msg);

    poly_cbd1(&r1,buf2 + NTRUPLUS_SSBYTES);
    poly_ntt(&r1);
    poly_freeze(&r1);
    poly_tobytes(buf3, &r1);


	t = 0;
	for(int i = 0; i < NTRUPLUS_N; ++i)
	{
		t |= buf1[i] ^ buf3[i];
	}

	fail = (uint16_t)t;
	fail = (-fail) >> 31;
	for(int i = 0; i < NTRUPLUS_SSBYTES; ++i)
	{
		ss[i] = buf2[i] & ~fail;
	}

    return fail;
}
