#ifndef NTT_H
#define NTT_H

#include <stdint.h>
#include "params.h"

#define NTRUPLUS_NAMESPACE(s) kpqclean_ntruplus576_opt_##s

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

#define fq_batchinv NTRUPLUS_NAMESPACE(fq_batchinv)
void fq_batchinv(int16_t *r, const int16_t *a, int n);

#define baseinv_calc_t_values NTRUPLUS_NAMESPACE(baseinv_calc_t_values)
int baseinv_calc_t_values(int16_t t_values[3], int16_t *t3_out, const int16_t a[4], int16_t zeta);

#define baseinv_apply_inv NTRUPLUS_NAMESPACE(baseinv_apply_inv)
void baseinv_apply_inv(int16_t r[4], const int16_t a[4], const int16_t t_values[3], int16_t t3_inv);

#endif