#ifndef PKE_H
#define PKE_H

#include "poly.h"

int cpa_pke_keygen(poly *hhat,
                   poly *fhat,
                   const unsigned char *coins);

void cpa_pke_encrypt(poly *chat,
                     const poly *hhat,
                     const unsigned char *msg,
                     const unsigned char *coins);

void cpa_pke_decrypt(unsigned char *msg,
                     const poly *chat,
                     const poly *fhat);

#endif
