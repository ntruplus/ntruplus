#ifndef NTT_H
#define NTT_H

#include <stdint.h>
#include "params.h"

extern int16_t zetas[575];
extern int16_t zetas_inv[575];

void ntt(int16_t poly[NTRUPLUS_N]);
void invntt(int16_t poly[NTRUPLUS_N]);

void ntt_pack(int16_t b[NTRUPLUS_N], const int16_t a[NTRUPLUS_N]);
void ntt_unpack(int16_t b[NTRUPLUS_N], const int16_t a[NTRUPLUS_N]);

#endif