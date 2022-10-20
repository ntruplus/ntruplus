#ifndef NTT_H
#define NTT_H

#include <stdint.h>
#include "params.h"

extern int16_t zetas[1151];
extern int16_t zetas_inv[1151];

void ntt(int16_t poly[NTRUPLUS_N]);
void invntt(int16_t poly[NTRUPLUS_N]);

void ntt_pack(int16_t b[768], const int16_t a[768]);
void ntt_unpack(int16_t b[768], const int16_t a[768]);

void basemul(int16_t r[2], const int16_t a[2], const int16_t b[2], int16_t zeta);
int baseinv(int16_t r[2], const int16_t a[2], int16_t zeta);

#endif