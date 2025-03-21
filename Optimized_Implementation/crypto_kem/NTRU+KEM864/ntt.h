#ifndef NTT_H
#define NTT_H

#include <stdint.h>
#include "params.h"

extern const int16_t zetas[288];
extern const int32_t zetas_plant[288];

void ntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N]);
void invntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N]);

int  baseinv(int16_t r[6], const int16_t a[6], int32_t zeta);
void basemul(int16_t r[3], const int16_t a[3], const int16_t b[3], int16_t zeta);
void basemul_add(int16_t r[3], const int16_t a[3], const int16_t b[3], const int16_t c[3], int16_t zeta);

#endif
