#ifndef PARAMS_H
#define PARAMS_H

#define NTRUPLUS_ALGNAME "NTRU+864"

#define NTRUPLUS_NAMESPACE(s) ntruplus864_aarch64_##s

#define NTRUPLUS_N 864
#define NTRUPLUS_Q 3457
#define NTRUPLUS_D 3

#define NTRUPLUS_SYMBYTES  32   /* size in bytes of hashes, and seeds */
#define NTRUPLUS_SSBYTES   32   /* size in bytes of shared key */
#define NTRUPLUS_POLYBYTES 1296

#define NTRUPLUS_PUBLICKEYBYTES  NTRUPLUS_POLYBYTES
#define NTRUPLUS_SECRETKEYBYTES  ((NTRUPLUS_POLYBYTES << 1) + NTRUPLUS_SYMBYTES)
#define NTRUPLUS_CIPHERTEXTBYTES  NTRUPLUS_POLYBYTES

/* Byte offset of the first base-operation factor pair in zetas. */
#define ZETAS_MUL_OFFSET 112
/* Byte offset of the last regular forward block for reverse traversal. */
#define ZETAS_INV_START 1168

#endif
