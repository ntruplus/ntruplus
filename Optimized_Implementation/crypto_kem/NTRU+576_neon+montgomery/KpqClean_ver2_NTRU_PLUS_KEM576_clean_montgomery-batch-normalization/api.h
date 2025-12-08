#ifndef API_H
#define API_H

#include "params.h"

#define CRYPTO_SECRETKEYBYTES  NTRUPLUS_SECRETKEYBYTES
#define CRYPTO_PUBLICKEYBYTES  NTRUPLUS_PUBLICKEYBYTES
#define CRYPTO_CIPHERTEXTBYTES NTRUPLUS_CIPHERTEXTBYTES
#define CRYPTO_BYTES           NTRUPLUS_SSBYTES

#define NTRUPLUS_NAMESPACE(s) kpqclean_ntruplus576_opt_##s

#define crypto_kem_keypair NTRUPLUS_NAMESPACE(crypto_kem_keypair)
#define crypto_kem_enc NTRUPLUS_NAMESPACE(crypto_kem_enc)
#define crypto_kem_dec NTRUPLUS_NAMESPACE(crypto_kem_dec)

int crypto_kem_keypair(unsigned char *pk,
                       unsigned char *sk);

int crypto_kem_enc(unsigned char *ct,
                   unsigned char *ss,
                   const unsigned char *pk);

int crypto_kem_dec(unsigned char *ss,
                   const unsigned char *ct,
                   const unsigned char *sk);

#endif
