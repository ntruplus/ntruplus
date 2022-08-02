#ifndef AUX_H
#define AUX_H

#include "poly.h"

void psi_1_n(poly *a, const unsigned char *buf);
void psi_1_n_lambda(poly *a, const unsigned char *buf);

void G(poly *e, const unsigned char *msg);
void G_inv(unsigned char *msg, poly *e);
void H(unsigned char *buf, const unsigned char *msg);

void G_internal(poly *a, const unsigned char *msg, const unsigned char *buf);
void G_inv_internal(unsigned char *msg, const poly *a, const unsigned char *buf);

#endif