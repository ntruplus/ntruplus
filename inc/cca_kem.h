#ifndef KEM_H
#define KEM_H

#include "params.h"

int cca_kem_keygen(unsigned char *pk, unsigned char *sk);
int cca_kem_encap(unsigned char *c,
                   unsigned char *k,
                   const unsigned char *pk);
int cca_kem_decap(unsigned char *k,
                   const unsigned char *c,
                   const unsigned char *sk);

#endif
