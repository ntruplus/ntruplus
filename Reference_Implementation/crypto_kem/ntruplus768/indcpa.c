#include "indcpa.h"
#include "poly.h"
#include "rng.h"
#include "crypto_stream.h"

static const unsigned char n[16] = {0};

/*************************************************
* Name:        indcpa_keypair
*
* Description: Generates public and private key for the CPA-secure
*              public-key encryption scheme underlying NTRUPLUS
*
* Arguments:   - uint8_t *pk: pointer to output public key
*                             (of length NTRUPLUS_INDCPA_PUBLICKEYBYTES bytes)
*              - uint8_t *sk: pointer to output private key
                              (of length NTRUPLUS_INDCPA_SECRETKEYBYTES bytes)
**************************************************/
void indcpa_keypair(uint8_t pk[NTRUPLUS_INDCPA_PUBLICKEYBYTES],
                    uint8_t sk[NTRUPLUS_INDCPA_SECRETKEYBYTES])
{
    uint8_t buf[NTRUPLUS_N];
    poly t1, t2, t3;

    do {
        randombytes(buf, 32);
        crypto_stream(buf, NTRUPLUS_N, n, buf);

        //f
        poly_cbd1(&t1, buf);
        poly_triple(&t1, &t1);
        t1.coeffs[0] += 1;
        poly_ntt(&t1);

    } while(poly_baseinv(&t3, &t1));

    poly_freeze(&t1);
    poly_tobytes(sk, &t1);

    //g
    poly_cbd1(&t2, buf + NTRUPLUS_N/4);
    poly_triple(&t2, &t2);
    poly_ntt(&t2);

    //h
    poly_basemul(&t3, &t3, &t2);
    poly_freeze(&t3);
    poly_tobytes(pk, &t3);
}


/*************************************************
* Name:        indcpa_enc
*
* Description: Encryption function of the CPA-secure
*              public-key encryption scheme underlying NTRUPLUS.
*
* Arguments:   - uint8_t *c:           pointer to output ciphertext
*                                      (of length NTRUPLUS_INDCPA_BYTES bytes)
*              - const uint8_t *m:     pointer to input message
*                                      (of length NTRUPLUS_INDCPA_MSGBYTES bytes)
*              - const uint8_t *pk:    pointer to input public key
*                                      (of length NTRUPLUS_INDCPA_PUBLICKEYBYTES)
*              - const uint8_t *coins: pointer to input random coins
*                                      used as seed (of length NTRUPLUS_SYMBYTES)
*                                      to deterministically generate all
*                                      randomness
**************************************************/
void indcpa_enc(uint8_t c[NTRUPLUS_INDCPA_BYTES],
                const uint8_t m[NTRUPLUS_INDCPA_MSGBYTES],
                const uint8_t pk[NTRUPLUS_INDCPA_PUBLICKEYBYTES],
                const uint8_t coins[NTRUPLUS_SYMBYTES])
{
    poly t1, t2;

    poly_frombytes(&t1, pk);

    poly_cbd1(&t2, coins);   
    poly_ntt(&t2);

    poly_basemul(&t1, &t1, &t2);
    poly_reduce(&t1);
    
    poly_cbd1_m1(&t2, coins + NTRUPLUS_N/4);

    for (int i = 0; i < 512; i++)
    {
        if(i%16 == 0) printf("\n");
        printf("%4d ", t2.coeffs[i]);
    }


    poly_sotp(&t2, m);

    poly_ntt(&t2);
    
    poly_add(&t1, &t1, &t2);

    poly_freeze(&t1);
    poly_tobytes(c, &t1);    
}

/*************************************************
* Name:        indcpa_dec
*
* Description: Decryption function of the CPA-secure
*              public-key encryption scheme underlying NTRUPLUS.
*
* Arguments:   - uint8_t *m:        pointer to output decrypted message
*                                   (of length NTRUPLUS_INDCPA_MSGBYTES)
*              - const uint8_t *c:  pointer to input ciphertext
*                                   (of length NTRUPLUS_INDCPA_BYTES)
*              - const uint8_t *sk: pointer to input secret key
*                                   (of length NTRUPLUS_INDCPA_SECRETKEYBYTES)
**************************************************/
void indcpa_dec(uint8_t m[NTRUPLUS_INDCPA_MSGBYTES],
                const uint8_t c[NTRUPLUS_INDCPA_BYTES],
                const uint8_t sk[NTRUPLUS_INDCPA_SECRETKEYBYTES])
{
    poly t1, t2;

    poly_frombytes(&t1, c);
    poly_frombytes(&t2, sk);

    poly_basemul(&t1, &t1, &t2);
    poly_reduce(&t1);
    poly_invntt(&t1);
    poly_crepmod3(&t1, &t1);

    poly_sotp_inv(m, &t1);
}