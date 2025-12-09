#ifndef NTT_H
#define NTT_H

#include <stdint.h>
#include "params.h"

extern const uint32_t zetas[288];

void ntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N]);
void invntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N]);

int baseinv_1(int16_t r[6], int16_t det[2], const int16_t a[6], uint32_t zeta);
void fqinv_batch(int16_t *r);
int baseinv_2(int16_t r[6], int16_t det[2]);

void basemul(int16_t r[3], const int16_t a[3], const int16_t b[3], uint32_t zeta);
void basemul_add(int16_t r[3], const int16_t a[3], const int16_t b[3], const int16_t c[3], uint32_t zeta);

#endif
