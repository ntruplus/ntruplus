#ifndef SOTP_H
#define SOTP_H

#include "poly.h"

void sotp_internal(poly *a, const unsigned char *msg, const unsigned char *buf);
void sotp_inv_internal(unsigned char *msg, const poly *a, const unsigned char *buf);

#endif