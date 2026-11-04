#ifndef POLY_H
#define POLY_H

#include <immintrin.h>
#include <stdint.h>

#include "params.h"
#include "util.h"
#include "api.h"

#define poly_tobytes        NTRUPLUS_NAMESPACE(poly_tobytes)
#define poly_frombytes      NTRUPLUS_NAMESPACE(poly_frombytes)
#define poly_cbd1           NTRUPLUS_NAMESPACE(poly_cbd1)
#define poly_cbd1_triple    NTRUPLUS_NAMESPACE(poly_cbd1_triple)
#define poly_sotp_encode    NTRUPLUS_NAMESPACE(poly_sotp_encode)
#define poly_sotp_decode    NTRUPLUS_NAMESPACE(poly_sotp_decode)
#define poly_ntt            NTRUPLUS_NAMESPACE(poly_ntt)
#define poly_invntt_scale   NTRUPLUS_NAMESPACE(poly_invntt_scale)
#define poly_basemul        NTRUPLUS_NAMESPACE(poly_basemul)
#define poly_basemul_add    NTRUPLUS_NAMESPACE(poly_basemul_add)
#define poly_basemul_scaled NTRUPLUS_NAMESPACE(poly_basemul_scaled)
#define poly_baseinv        NTRUPLUS_NAMESPACE(poly_baseinv)
#define poly_sub            NTRUPLUS_NAMESPACE(poly_sub)
#define poly_crepmod3       NTRUPLUS_NAMESPACE(poly_crepmod3)
#define poly_baseinv_1      NTRUPLUS_NAMESPACE(poly_baseinv_1)
#define poly_frombytes_raw  NTRUPLUS_NAMESPACE(poly_frombytes_raw)
#define poly_ntt_pack       NTRUPLUS_NAMESPACE(poly_ntt_pack)
#define poly_ntt_unpack     NTRUPLUS_NAMESPACE(poly_ntt_unpack)
#define poly_tobytes_raw    NTRUPLUS_NAMESPACE(poly_tobytes_raw)

/*
 * Elements of R_q = Z_q[X]/(X^n - X^n/2 + 1). Represents polynomial
 * coeffs[0] + X*coeffs[1] + X^2*xoeffs[2] + ... + X^{n-1}*coeffs[n-1]
 */
typedef struct{
	int16_t coeffs[NTRUPLUS_N];
} poly __attribute__((aligned(32)));

static inline void poly_clear(poly *r)
{
    u8_clear(r, sizeof *r);
}

NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
int poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES]);

NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_cbd1(poly *r, const uint8_t buf[NTRUPLUS_N/4]);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_cbd1_triple(poly *r, const uint8_t buf[NTRUPLUS_N/4]);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_sotp_encode(poly *r, const uint8_t msg[NTRUPLUS_N/8],
                      const uint8_t buf[NTRUPLUS_N/4]);
NTRUPLUS_INTERNAL
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N/8], const poly *a,
                     const uint8_t buf[NTRUPLUS_N/4]);

NTRUPLUS_INTERNAL NTRUPLUS_SYSV void poly_ntt(poly *r);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV void poly_invntt_scale(poly *r);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_basemul(poly *r, const poly *a, const poly *b);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_basemul_add(poly *r, const poly *a, const poly *b, const poly *c);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_basemul_scaled(poly *r, const poly *a, const poly *b);

NTRUPLUS_INTERNAL int poly_baseinv(poly *r, const poly *a);

NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_sub(poly *c, const poly *a, const poly *b);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV void poly_crepmod3(poly *r);

#endif
