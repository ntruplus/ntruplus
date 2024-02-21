#ifndef API_H
#define API_H

#include "params.h"

#define CRYPTO_SECRETKEYBYTES  NTRUPLUS_SECRETKEYBYTES
#define CRYPTO_PUBLICKEYBYTES  NTRUPLUS_PUBLICKEYBYTES
#define CRYPTO_CIPHERTEXTBYTES NTRUPLUS_CIPHERTEXTBYTES
#define CRYPTO_MAXPLAINTEXT    NTRUPLUS_MAXPLAINTEXT
#define CRYPTO_BYTES           NTRUPLUS_SYMBYTES

#define CRYPTO_ALGNAME "NTRU+PKE768"

int crypto_encrypt_keypair(unsigned char *pk,
                           unsigned char *sk);

int crypto_encrypt(unsigned char *c,
                   unsigned long long *clen,
                   const unsigned char *m,
                   unsigned long long mlen,
                   const unsigned char *pk);

int crypto_encrypt_open(unsigned char *m,
                        unsigned long long *mlen,
                        const unsigned char *c,
                        unsigned long long clen,
                        const unsigned char *sk);

#endif
