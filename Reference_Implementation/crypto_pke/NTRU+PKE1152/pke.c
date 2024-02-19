#include <stddef.h>
#include <stdint.h>
#include "pke.h"
#include "params.h"
#include "symmetric.h"
#include "poly.h"
#include "verify.h"
#include "aes256ctr.h"
#include "randombytes.h"

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
int crypto_encrypt_keypair(unsigned char *pk, unsigned char *sk)
{
    uint8_t buf[NTRUPLUS_N/2];
 
    poly f, finv;
    poly g;
    poly h, hinv;

    int r;

    do {
        randombytes(buf, 32);
        aes256ctr_prf(buf, NTRUPLUS_N/2, buf, n);

        poly_cbd1(&f, buf);
        poly_triple(&f);
        f.coeffs[0] += 1;
        poly_ntt(&f,&f);
        r = poly_baseinv(&finv, &f);

        poly_cbd1(&g, buf + NTRUPLUS_N/4); 
        poly_triple(&g);
        poly_ntt(&g,&g);

        poly_basemul(&h,&g,&finv);
        r |= poly_baseinv(&hinv,&h);
    } while(r);

    //pk
    poly_reduce(&h);
    poly_tobytes(pk, &h);

    //sk
    poly_reduce(&f);  
    poly_tobytes(sk, &f);

    poly_reduce(&hinv);
    poly_tobytes(sk+NTRUPLUS_POLYBYTES, &hinv);

    hash_f(sk + 2*NTRUPLUS_POLYBYTES, pk); 
        
    return 0;
}
/*************************************************
* Name:        crypto_encrypt
*
* Description: Generates cipher text for given public key
*
* Arguments:   - unsigned char *c: pointer to output cipher text
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - const unsigned char *pk: pointer to input public key
*                (an already allocated array of CRYPTO_PUBLICKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/
int crypto_encrypt(unsigned char *c,
                   unsigned long long *clen,
                   const unsigned char *m,
                   unsigned long long mlen,
                   const unsigned char *pk)
{
    uint8_t msg[NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES] = {0};
    uint8_t buf1[NTRUPLUS_SYMBYTES + NTRUPLUS_N/4];
    uint8_t buf2[NTRUPLUS_POLYBYTES];

    poly p_c, p_h, p_r, p_m;

    int8_t fail;

    //length check
    fail = -((NTRUPLUS_N/8 - NTRUPLUS_RANDOMBYTES - 1 - mlen) >> 63);

    msg[NTRUPLUS_N/8 - NTRUPLUS_RANDOMBYTES - mlen-1] = 0x01;

    for (int i = 0; i < (int)mlen; i++)
    {
        msg[i + NTRUPLUS_N/8 - NTRUPLUS_RANDOMBYTES - mlen] = m[i] & ~(-fail);
    }

    randombytes(msg + NTRUPLUS_N/8 - NTRUPLUS_RANDOMBYTES, NTRUPLUS_RANDOMBYTES);

    hash_f(msg + NTRUPLUS_N/8, pk);
    hash_h_pke(buf1, msg);

    poly_cbd1(&p_r, buf1);
    poly_ntt(&p_r,&p_r);
    poly_reduce(&p_r);
    
    poly_tobytes(buf2, &p_r);
    hash_g(buf2, buf2);

    poly_sotp(&p_m, msg, buf2);  
    poly_ntt(&p_m,&p_m);

    poly_frombytes(&p_h, pk);
    poly_basemul(&p_c, &p_h, &p_r);
    poly_add(&p_c, &p_c, &p_m);
    poly_reduce(&p_c);
    poly_tobytes(c, &p_c);

    *clen = NTRUPLUS_CIPHERTEXTBYTES;

    return fail;
}

/*************************************************
* Name:        crypto_encrypt_open
*
* Description: Generates shared secret for given
*              cipher text and private key
*
* Arguments:   - unsigned char *m: pointer to output plain text
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
               - unsigned char *ss: pointer to output shared secret
*                (an already allocated array of CRYPTO_BYTES bytes)
*              - const unsigned char *c: pointer to input cipher text
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - const unsigned char *sk: pointer to input private key
*                (an already allocated array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0.
*
* On failure, ss will contain a pseudo-random value.
**************************************************/
int crypto_encrypt_open(unsigned char *m,
                        unsigned long long *mlen,
                        const unsigned char *c,
                        unsigned long long clen,
                        const unsigned char *sk)
{
    uint8_t msg[NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES];
    uint8_t buf1[NTRUPLUS_POLYBYTES];
    uint8_t buf2[NTRUPLUS_POLYBYTES];
    uint8_t buf3[NTRUPLUS_POLYBYTES + NTRUPLUS_SYMBYTES]= {0};

    int8_t fail;

    poly p_c, p_f, p_hinv;
    poly p_r1, p_r2;
    poly p_m1, p_m2;
    poly p_t1;

    int i, j;

    if(clen != NTRUPLUS_CIPHERTEXTBYTES) return 1;
    poly_frombytes(&p_c, c);
    poly_frombytes(&p_f, sk);
    poly_frombytes(&p_hinv, sk + NTRUPLUS_POLYBYTES);

    poly_basemul(&p_t1, &p_c, &p_f);
    poly_invntt(&p_t1,&p_t1);
    poly_crepmod3(&p_m1, &p_t1);
    
    poly_ntt(&p_m2,&p_m1);
    poly_sub(&p_c,&p_c,&p_m2);
    poly_basemul(&p_r2, &p_c, &p_hinv);
    poly_reduce(&p_r2);
    poly_tobytes(buf1, &p_r2);

    hash_g(buf2, buf1);
    fail = poly_sotp_inv(msg, &p_m1, buf2);

    for (i = 0; i < NTRUPLUS_SYMBYTES; i++)
    {
        msg[i + NTRUPLUS_N/8] = sk[i + 2*NTRUPLUS_POLYBYTES]; 
    }  

    hash_h_pke(buf3, msg);

    poly_cbd1(&p_r1,buf3);
    poly_ntt(&p_r1,&p_r1);
    poly_reduce(&p_r1);
    poly_tobytes(buf2, &p_r1);
   
    fail |= verify(buf1, buf2, NTRUPLUS_POLYBYTES); 

    for (i = 0; i < NTRUPLUS_N/8 - NTRUPLUS_RANDOMBYTES; i++)
    {
        if(msg[i] == 0x00) continue;
        else if(msg[i] == 0x01)
        {
            *mlen = NTRUPLUS_N/8 - NTRUPLUS_RANDOMBYTES - i - 1;
            j = i+1;
            break;
        }
    }

    if(i == NTRUPLUS_N/8 - NTRUPLUS_RANDOMBYTES) return 1;

    for (i = 0; i < (int)*mlen; i++)
    {
        m[i] = msg[i+j] & ~(-fail);
    }

    return fail;
}