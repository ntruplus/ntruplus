#ifndef POLY_H
#define POLY_H

#include <stdint.h>
#include "params.h"

/*
 * Elements of R_q = Z_q[X]/(X^n - X^n/2 + 1). Represents polynomial
 * coeffs[0] + X*coeffs[1] + X^2*xoeffs[2] + ... + X^{n-1}*coeffs[n-1]
 */
typedef struct{
  int16_t coeffs[NTRUPLUS_N];
} poly __attribute__((aligned(32)));

void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a);
void poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES]);

void poly_ntt(poly *r, const poly *a);
void poly_invntt(poly *r, const poly *a);
void poly_basemul(poly *r, const poly *a, const poly *b);
int poly_baseinv(poly *r, const poly *a);

void poly_reduce(poly *r);

void poly_add(poly *r, const poly *a, const poly *b);
void poly_sub(poly *c, const poly *a, const poly *b);
void poly_triple(poly *r);
void poly_crepmod3(poly *b, const poly *a);

void poly_reduce(poly *a);
void poly_freeze(poly *a);

void poly_cbd1(poly *a, const unsigned char *buf);

void poly_sotp(poly *e, const unsigned char *msg, const unsigned char *buf);
void poly_sotp_inv(unsigned char *msg, const poly *e, const unsigned char *buf);

#endif