#ifndef NTT_H
#define NTT_H

#include <stdint.h>
#include <arm_neon.h>
#include "params.h"

#define NTRUPLUS_NAMESPACE(s) kpqclean_ntruplus576_neon_##s

#define zetas NTRUPLUS_NAMESPACE(zetas)
extern const int16_t zetas[144];

#define ntt NTRUPLUS_NAMESPACE(ntt)
void ntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N]);

#define invntt NTRUPLUS_NAMESPACE(invntt)
void invntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N]);

#define baseinv NTRUPLUS_NAMESPACE(baseinv)
int baseinv(int16_t r[4], const int16_t a[4], int16_t zeta);

#define basemul NTRUPLUS_NAMESPACE(basemul)
void basemul(int16_t r[4], const int16_t a[4], const int16_t b[4], int16_t zeta);

#define basemul_add NTRUPLUS_NAMESPACE(basemul_add)
void basemul_add(int16_t r[4], const int16_t a[4], const int16_t b[4], const int16_t c[4], int16_t zeta);

#define basemul_vec8 NTRUPLUS_NAMESPACE(basemul_vec8)
void basemul_vec8(int16_t *r, const int16_t *a, const int16_t *b, int16_t zeta);

#define basemul_add_vec8 NTRUPLUS_NAMESPACE(basemul_add_vec8)
void basemul_add_vec8(int16_t *r, const int16_t *a, const int16_t *b, const int16_t *c, int16_t zeta);

#define montgomery_reduce_vec4_opt NTRUPLUS_NAMESPACE(montgomery_reduce_vec4_opt)
int16x4_t montgomery_reduce_vec4_opt(int32x4_t a);

#endif
