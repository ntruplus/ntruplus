#ifndef REDUCE_H
#define REDUCE_H

#include <stdint.h>

#define NTRUPLUS_NAMESPACE(s) kpqclean_ntruplus576_neon_##s

#define QINV 12929 // q^(-1) mod 2^16

#define montgomery_reduce NTRUPLUS_NAMESPACE(montgomery_reduce)
int16_t montgomery_reduce(int32_t a);

#define barrett_reduce NTRUPLUS_NAMESPACE(barrett_reduce)
int16_t barrett_reduce(int16_t a);

#endif