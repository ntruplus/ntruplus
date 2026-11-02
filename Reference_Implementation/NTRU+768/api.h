#ifndef API_H
#define API_H

#include "params.h"

#if defined(__MINGW32__) || defined(__MINGW64__)
#define NTRUPLUS_INTERNAL
#define NTRUPLUS_EXTERNAL __declspec(dllexport)
#define NTRUPLUS_SYSV __attribute__((sysv_abi))
#else
#define NTRUPLUS_INTERNAL __attribute__((visibility("hidden")))
#define NTRUPLUS_EXTERNAL __attribute__((visibility("default")))
#define NTRUPLUS_SYSV
#endif

#define CRYPTO_SECRETKEYBYTES  NTRUPLUS_SECRETKEYBYTES
#define CRYPTO_PUBLICKEYBYTES  NTRUPLUS_PUBLICKEYBYTES
#define CRYPTO_CIPHERTEXTBYTES NTRUPLUS_CIPHERTEXTBYTES
#define CRYPTO_BYTES           NTRUPLUS_SSBYTES

#define CRYPTO_ALGNAME NTRUPLUS_ALGNAME

enum {
    NTRUPLUS_SUCCESS = 0,
    NTRUPLUS_FAILURE = 1
};

/* Returns NTRUPLUS_SUCCESS. */
NTRUPLUS_EXTERNAL int crypto_kem_keypair(unsigned char *pk,
                                         unsigned char *sk);

/* Returns NTRUPLUS_SUCCESS or NTRUPLUS_FAILURE. */
NTRUPLUS_EXTERNAL int crypto_kem_enc(unsigned char *ct,
                                     unsigned char *ss,
                                     const unsigned char *pk);

/* Returns NTRUPLUS_SUCCESS or NTRUPLUS_FAILURE. */
NTRUPLUS_EXTERNAL int crypto_kem_dec(unsigned char *ss,
                                     const unsigned char *ct,
                                     const unsigned char *sk);

#endif
