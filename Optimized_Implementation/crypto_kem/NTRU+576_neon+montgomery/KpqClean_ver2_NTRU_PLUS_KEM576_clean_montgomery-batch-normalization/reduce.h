#ifndef REDUCE_H
#define REDUCE_H

#include <stdint.h>
#include "params.h"

#define NTRUPLUS_NAMESPACE(s) kpqclean_ntruplus576_opt_##s
#define QINV 12929 // q^(-1) mod 2^16

#define montgomery_reduce NTRUPLUS_NAMESPACE(montgomery_reduce)
static inline int16_t montgomery_reduce(int32_t a)
{
    int16_t t;
    t = (int16_t)a * QINV;
    t = (a - (int32_t)t * NTRUPLUS_Q) >> 16;
    return t;
}

#define barrett_reduce NTRUPLUS_NAMESPACE(barrett_reduce)
static inline int16_t barrett_reduce(int16_t a)
{
    int16_t t;
    const int16_t v = ((1 << 26) + NTRUPLUS_Q / 2) / NTRUPLUS_Q;

    t = ((int32_t)v * a + (1 << 25)) >> 26;
    t *= NTRUPLUS_Q;
    return a - t;
}

#endif
