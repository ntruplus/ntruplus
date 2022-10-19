#ifndef PARAMS_H
#define PARAMS_H

#define NTRUPLUS_N 1152
#define NTRUPLUS_Q 3457

#define NTRUPLUS_SYMBYTES 32   /* size in bytes of hashes, and seeds */
#define NTRUPLUS_SSBYTES  32   /* size in bytes of shared key */

#define NTRUPLUS_POLYBYTES		1728

#define NTRUPLUS_INDCPA_MSGBYTES       NTRUPLUS_SYMBYTES
#define NTRUPLUS_INDCPA_PUBLICKEYBYTES NTRUPLUS_POLYBYTES
#define NTRUPLUS_INDCPA_SECRETKEYBYTES NTRUPLUS_POLYBYTES
#define NTRUPLUS_INDCPA_BYTES          NTRUPLUS_POLYBYTES

#define NTRUPLUS_PUBLICKEYBYTES  NTRUPLUS_INDCPA_PUBLICKEYBYTES
#define NTRUPLUS_SECRETKEYBYTES  (NTRUPLUS_INDCPA_SECRETKEYBYTES + NTRUPLUS_INDCPA_PUBLICKEYBYTES)
#define NTRUPLUS_CIPHERTEXTBYTES  NTRUPLUS_INDCPA_BYTES

#endif
