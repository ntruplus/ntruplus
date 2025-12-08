#ifndef POLY_H
#define POLY_H

#include <stdint.h>
#include "params.h"

#define NTRUPLUS_NAMESPACE(s) kpqclean_ntruplus576_neon_##s

typedef struct {
    int16_t coeffs[NTRUPLUS_N];
} poly;

#define poly_tobytes NTRUPLUS_NAMESPACE(poly_tobytes)
void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a);

#define poly_frombytes NTRUPLUS_NAMESPACE(poly_frombytes)
void poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES]);

#define poly_cbd1 NTRUPLUS_NAMESPACE(poly_cbd1)
void poly_cbd1(poly *r, const uint8_t buf[NTRUPLUS_N/4]);

#define poly_sotp NTRUPLUS_NAMESPACE(poly_sotp)
void poly_sotp(poly *r, const uint8_t *msg, const uint8_t *buf);

#define poly_sotp_inv NTRUPLUS_NAMESPACE(poly_sotp_inv)
int poly_sotp_inv(uint8_t *msg, const poly *a, const uint8_t *buf);

#define poly_ntt NTRUPLUS_NAMESPACE(poly_ntt)
void poly_ntt(poly *r, const poly *a);

#define poly_invntt NTRUPLUS_NAMESPACE(poly_invntt)
void poly_invntt(poly *r, const poly *a);

#define poly_baseinv NTRUPLUS_NAMESPACE(poly_baseinv)
int poly_baseinv(poly *r, const poly *a);

#define poly_basemul NTRUPLUS_NAMESPACE(poly_basemul)
void poly_basemul(poly *r, const poly *a, const poly *b);

#define poly_basemul_add NTRUPLUS_NAMESPACE(poly_basemul_add)
void poly_basemul_add(poly *r, const poly *a, const poly *b, const poly *c);

#define poly_sub NTRUPLUS_NAMESPACE(poly_sub)
void poly_sub(poly *r, const poly *a, const poly *b);

#define poly_triple NTRUPLUS_NAMESPACE(poly_triple)
void poly_triple(poly *r, const poly *a);

#define poly_crepmod3 NTRUPLUS_NAMESPACE(poly_crepmod3)
void poly_crepmod3(poly *r, const poly *a);

#endif