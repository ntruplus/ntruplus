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
    uint8_t buf[NTRUPLUS_N/2];
 
    poly f, finv;
    poly g, ginv;
    poly h, hinv;

    int r;

    do {
        r = 0;
        randombytes(buf, 32);
        crypto_stream(buf, NTRUPLUS_N/2, n, buf);

        printf("buf  : ");
        for(int i=0; i<NTRUPLUS_N/2; i++) printf("%02X", buf[i]);
        printf("\n");

        poly_cbd1(&f, buf);
        poly_triple(&f,&f);
        f.coeffs[0] += 1;
        poly_ntt(&f,&f);
        r = poly_baseinv(&finv, &f);
        for (int i = 0; i < NTRUPLUS_N; i++)
        {
            printf("%d ", finv.coeffs[i]);
        }
        printf("\n");

        printf("r : %d\n", r);
        poly_cbd1(&g, buf + NTRUPLUS_N/4);



        poly_triple(&g,&g);
        poly_ntt(&g,&g);
        poly_freeze(&g);


        r |= poly_baseinv(&ginv, &g);

     //   poly_freeze(&ginv);
        for (int i = 0; i < NTRUPLUS_N; i++)
        {
            if(i%16 == 0) printf("\n");
            printf("%d ", ginv.coeffs[i]);
        }
        printf("\n");
        printf("r : %d\n", r);

    } while(r);

    //pk
    poly_basemul(&h, &g, &finv);
    poly_freeze(&h);
    poly_ntt_pack(&h,&h);
    poly_tobytes(pk, &h);
    
    //sk
    poly_basemul(&hinv, &f, &ginv);
    poly_freeze(&hinv);
    poly_ntt_pack(&hinv,&hinv);
    poly_tobytes(sk+NTRUPLUS_POLYBYTES, &hinv);

    poly_freeze(&f);  
    poly_ntt_pack(&f,&f);
    poly_tobytes(sk, &f);

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
    uint8_t msg[NTRUPLUS_N/8];
    uint8_t buf1[NTRUPLUS_SYMBYTES + NTRUPLUS_N/4];
    uint8_t buf2[NTRUPLUS_POLYBYTES];

    poly c, h, r, m, r2;

    poly_frombytes(&h, pk);
    poly_ntt_unpack(&h,&h);

    randombytes(msg, NTRUPLUS_N/8);
    hash_h(buf1, msg);

    poly_cbd1(&r, buf1 + NTRUPLUS_SYMBYTES);
    poly_ntt(&r,&r);
    poly_freeze(&r);
    poly_ntt_pack(&r2,&r);
    
    poly_tobytes(buf2, &r2);
    hash_g(buf2, buf2);

    poly_sotp(&m, msg, buf2);  
    poly_ntt(&m,&m);

    poly_basemul(&c, &h, &r);
    poly_add(&c, &c, &m);
    poly_freeze(&c);
    poly_ntt_pack(&c,&c);
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
    uint8_t msg[NTRUPLUS_N/8];
    uint8_t buf1[NTRUPLUS_POLYBYTES];
    uint8_t buf2[NTRUPLUS_POLYBYTES];
    uint8_t buf3[NTRUPLUS_POLYBYTES + NTRUPLUS_SYMBYTES]= {0};

    int8_t fail;

    poly c, f, hinv;
    poly r1, r2;
    poly m1, m2;
    poly t1;

    poly_frombytes(&c, ct);
    poly_frombytes(&f, sk);
    poly_frombytes(&hinv, sk + NTRUPLUS_POLYBYTES);

    poly_ntt_unpack(&c,&c);
    poly_ntt_unpack(&f,&f);
    poly_ntt_unpack(&hinv,&hinv);

    poly_basemul(&t1, &c, &f);
    poly_invntt(&t1,&t1);
    poly_crepmod3(&m1, &t1);
    
    poly_ntt(&m2,&m1);
    poly_sub(&c,&c,&m2);
    poly_basemul(&r2, &c, &hinv);
    poly_freeze(&r2);
    poly_ntt_pack(&r2,&r2);
    poly_tobytes(buf1, &r2);

    hash_g(buf2, buf1);
    poly_sotp_inv(msg, &m1, buf2);

    hash_h(buf3, msg);
    poly_cbd1(&r1,buf3 + NTRUPLUS_SSBYTES);
    poly_ntt(&r1,&r1);
    poly_freeze(&r1);
    poly_ntt_pack(&r1,&r1);
    poly_tobytes(buf2, &r1);

    fail = verify(buf1, buf2, NTRUPLUS_POLYBYTES);

	for(int i = 0; i < NTRUPLUS_SSBYTES; ++i)
	{
		ss[i] = buf3[i] & ~fail;
	}

    return fail;
}
