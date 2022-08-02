#ifndef PARAMS_H
#define PARAMS_H

#define N 768
#define Q 3457
#define LOGQ 12
#define ROOT_OF_UNITY 5

#define SEEDBYTES 32
#define SHAREDKEYBYTES 32
#define MSGBYTES (N/4)
#define PUBLICKEYBYTES (LOGQ*N/8)
#define SECRETKEYBYTES (LOGQ*N/8 + PUBLICKEYBYTES)
#define CIPHERTEXTBYTES (LOGQ*N/8)

#endif
