#include <stddef.h>
#include <stdint.h>
#include "params.h"
#include "rng.h"
#include "symmetric.h"
#include "verify.h"
#include "indcpa.h"

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
  size_t i;

  indcpa_keypair(pk,sk);
  for(i = 0; i < NTRUPLUS_INDCPA_PUBLICKEYBYTES; i++)
    sk[i+NTRUPLUS_INDCPA_SECRETKEYBYTES] = pk[i];  
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
  size_t i;
  uint8_t buf[352] ={0}; //key || coin
  uint8_t msg[NTRUPLUS_SYMBYTES] = {0};

  randombytes(msg, 32);
  hash_h(buf, msg);
  indcpa_enc(ct, msg, pk, buf+NTRUPLUS_SSBYTES);
  for (i = 0; i < NTRUPLUS_SSBYTES; i++)
    ss[i] = buf[i];
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
* Returns 0.
*
* On failure, ss will contain a pseudo-random value.
**************************************************/
int crypto_kem_dec(unsigned char *ss,
                   const unsigned char *ct,
                   const unsigned char *sk)
{
  size_t i;
  uint8_t msg[NTRUPLUS_SYMBYTES] = {0};
  uint8_t buf[352] ={0}; //key || coin
  uint8_t cmp[NTRUPLUS_CIPHERTEXTBYTES];
  int8_t fail;

  indcpa_dec(msg, ct, sk);

  hash_h(buf, msg);

  indcpa_enc(cmp, msg, sk+NTRUPLUS_INDCPA_SECRETKEYBYTES, buf+NTRUPLUS_SSBYTES);

  fail = verify(ct, cmp, NTRUPLUS_CIPHERTEXTBYTES);

  for(i = 0; i < NTRUPLUS_SSBYTES; i++)
    ss[i] = buf[i] & ~fail;
  return fail;
}
