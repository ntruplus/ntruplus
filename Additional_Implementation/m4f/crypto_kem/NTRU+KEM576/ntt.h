#ifndef NTT_H
#define NTT_H

#include <stdint.h>
#include "params.h"

extern const int16_t zetas[144];

void ntt(int16_t r[NTRUPLUS_N]);
void invntt(int16_t r[NTRUPLUS_N]);

#endif
