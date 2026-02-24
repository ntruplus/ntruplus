#include <immintrin.h>

#include "params.h"
#include "poly.h"
#include "consts.h"

#define NTRUPLUS_QINV 12929

#define NTRUPLUS_RINV -682
#define NTRUPLUS_RINV_QINV 29782

static inline __m256i fqmul(__m256i a, __m256i b, __m256i b_qinv, __m256i q)
{
    __m256i lo = _mm256_mullo_epi16(a, b_qinv);
    __m256i hi = _mm256_mulhi_epi16(a, b);
    lo = _mm256_mulhi_epi16(lo, q);
    return _mm256_sub_epi16(hi, lo);
}

static inline __m256i fqmul_neg(__m256i a, __m256i b, __m256i b_qinv, __m256i q)
{
    __m256i lo = _mm256_mullo_epi16(a, b_qinv);
    __m256i hi = _mm256_mulhi_epi16(a, b);
    lo = _mm256_mulhi_epi16(lo, q);
    return _mm256_sub_epi16(lo, hi);
}

static inline __m256i fqsqr(__m256i a,  __m256i q, __m256i qinv)
{
    __m256i a_qinv = _mm256_mullo_epi16(a, qinv);
    __m256i lo = _mm256_mullo_epi16(a, a_qinv);
    __m256i hi = _mm256_mulhi_epi16(a, a);
    lo = _mm256_mulhi_epi16(lo, q);
    return _mm256_sub_epi16(hi, lo);
}

static inline __m256i fqinv(__m256i r)
{
    const __m256i qinv     = _mm256_set1_epi16(NTRUPLUS_QINV);
    const __m256i q        = _mm256_set1_epi16(NTRUPLUS_Q);
    const __m256i Rinvqinv = _mm256_set1_epi16(NTRUPLUS_RINV_QINV);
    const __m256i Rinv     = _mm256_set1_epi16(NTRUPLUS_RINV);

    __m256i T1, T2;
    __m256i t1, t2, t3;

    T1  = _mm256_mullo_epi16(r, qinv);
    t1 = fqsqr(r, q, qinv);     // 10
   
    T2 = _mm256_mullo_epi16(t1, qinv);
    t2 = fqsqr(t1, q, qinv);    // 100
    t2 = fqsqr(t2, q, qinv);    // 1000
    t3 = fqsqr(t2, q, qinv);    // 10000
    t1 = fqmul(t2, t1, T2, q);  // 1010

    T2 = _mm256_mullo_epi16(t1, qinv);
    t2 = fqmul(t3, t1, T2, q);  // 11010
    t2 = fqsqr(t2, q, qinv);    // 110100
    t2 = fqmul(t2, r, T1, q);   // 110101
    t1 = fqmul(t2, t1, T2, q);  // 111111

    t2 = fqsqr(t2, q, qinv);    // 1101010
    t2 = fqsqr(t2, q, qinv);    // 11010100
    t2 = fqsqr(t2, q, qinv);    // 110101000
    t2 = fqsqr(t2, q, qinv);    // 1101010000
    t2 = fqsqr(t2, q, qinv);    // 11010100000
    t2 = fqsqr(t2, q, qinv);    // 110101000000

    T2 = _mm256_mullo_epi16(t2, qinv);
    t2 = fqmul(t1, t2, T2, q);  // 110101111111

    t2 = fqmul(t2, Rinv, Rinvqinv, q);

    return t2;
}

static inline int poly_fqinv_batch(__m256i *restrict r)
{
    const int chunk = NTRUPLUS_N / 192;
    const int off0 = 0 * chunk;
    const int off1 = 1 * chunk;
    const int off2 = 2 * chunk;

    const __m256i qinv = _mm256_set1_epi16(NTRUPLUS_QINV);
    const __m256i q    = _mm256_set1_epi16(NTRUPLUS_Q);
    const __m256i z    = _mm256_setzero_si256();

    __m256i t[NTRUPLUS_N / 64];
    __m256i R[NTRUPLUS_N / 64];

    t[off0] = r[off0];
    t[off1] = r[off1];
    t[off2] = r[off2];

    for (size_t i = 1; i < chunk; i++) 
    {
        R[off0 + i] = _mm256_mullo_epi16(r[off0 + i], qinv);
        R[off1 + i] = _mm256_mullo_epi16(r[off1 + i], qinv);
        R[off2 + i] = _mm256_mullo_epi16(r[off2 + i], qinv);

        t[off0 + i] = fqmul(t[off0 + i - 1], r[off0 + i], R[off0 + i], q);
        t[off1 + i] = fqmul(t[off1 + i - 1], r[off1 + i], R[off1 + i], q);
        t[off2 + i] = fqmul(t[off2 + i - 1], r[off2 + i], R[off2 + i], q);
    }

    __m256i mask_zero0 = _mm256_cmpeq_epi16(t[off0 + chunk - 1], z);
    __m256i mask_zero1 = _mm256_cmpeq_epi16(t[off1 + chunk - 1], z);
    __m256i mask_zero2 = _mm256_cmpeq_epi16(t[off2 + chunk - 1], z);

    __m256i mask_zero = _mm256_or_si256(mask_zero0, _mm256_or_si256(mask_zero1, mask_zero2));
    if (!_mm256_testz_si256(mask_zero, mask_zero)) return 1;

    __m256i x0 = t[off0 + chunk - 1];
    __m256i x1 = t[off1 + chunk - 1];
    __m256i x2 = t[off2 + chunk - 1];

    __m256i X1 = _mm256_mullo_epi16(x1, qinv);
    __m256i X2 = _mm256_mullo_epi16(x2, qinv);

    __m256i t2[3];
    t2[0] = x0;
    t2[1] = fqmul(t2[0], x1, X1, q);
    t2[2] = fqmul(t2[1], x2, X2, q);

    __m256i inv = fqinv(t2[2]);
    __m256i INV = _mm256_mullo_epi16(inv, qinv);
    __m256i inv2 = fqmul(t2[1], inv, INV, q);
    inv = fqmul(inv, x2, X2, q);

    INV = _mm256_mullo_epi16(inv, qinv);
    __m256i inv1 = fqmul(t2[0], inv, INV, q);
    inv = fqmul(inv, x1, X1, q);
    __m256i inv0 = inv;

    for (size_t i = chunk - 1; i > 0; i--)
    {
        __m256i INV0 = _mm256_mullo_epi16(inv0, qinv);
        __m256i INV1 = _mm256_mullo_epi16(inv1, qinv);
        __m256i INV2 = _mm256_mullo_epi16(inv2, qinv);

        __m256i tmp0 = r[off0 + i];
        __m256i tmp1 = r[off1 + i];
        __m256i tmp2 = r[off2 + i];

        r[off0 + i] = fqmul(t[off0 + i - 1], inv0, INV0, q);
        r[off1 + i] = fqmul(t[off1 + i - 1], inv1, INV1, q);
        r[off2 + i] = fqmul(t[off2 + i - 1], inv2, INV2, q);

        inv0 = fqmul(inv0, tmp0, R[off0 + i], q);
        inv1 = fqmul(inv1, tmp1, R[off1 + i], q);
        inv2 = fqmul(inv2, tmp2, R[off2 + i], q);
    }

    r[off0] = inv0;
    r[off1] = inv1;
    r[off2] = inv2;

    return 0;
}

static inline void poly_baseinv_2(poly *r, const __m256i den[18])
{
    const __m256i qinv = _mm256_load_si256((const __m256i *)_16xqinv);
    const __m256i q    = _mm256_load_si256((const __m256i *)_16xq);

    for (size_t i = 0; i < 18; i++) {
        __m256i r0 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i +  0]);
        __m256i r1 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i + 16]);
        __m256i r2 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i + 32]);
        __m256i r3 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i + 48]);

        __m256i t = den[i];
        __m256i T = _mm256_mullo_epi16(t, qinv);

        r0 = fqmul(r0, t, T, q);
        r1 = fqmul_neg(r1, t, T, q);
        r2 = fqmul(r2, t, T, q);
        r3 = fqmul_neg(r3, t, T, q);

        _mm256_store_si256((__m256i *)&r->coeffs[64*i +  0], r0);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 16], r1);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 32], r2);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 48], r3);
    }
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inversion of polynomial in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to input polynomial
* 
* Returns:     integer
**************************************************/
int  poly_baseinv(poly *r, const poly *a)
{
    __m256i den[18];

    poly_baseinv_1(r, den, a);

    if(poly_fqinv_batch(den))
    {
        for (size_t j = 0; j < NTRUPLUS_N; ++j)
            r->coeffs[j] = 0;
        return 1;
    }

    poly_baseinv_2(r, den);

    return 0;
}

/*************************************************
* Name:        poly_sotp_decode
*
* Description: Decode a message deterministically using SOTP_INV and a random
*
* Arguments:   - uint8_t *msg: pointer to output message
*              - const poly *a: pointer to iput polynomial
*              - const uint8_t *buf: pointer to input random
*
* Returns 0 (success) or 1 (failure)
**************************************************/
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N/8], const poly *a, const uint8_t buf[NTRUPLUS_N/4])
{
    const __m256i mask55 = _mm256_set1_epi8((char)0x55);
    const __m256i maskff = _mm256_set1_epi8((char)0xff);
    const __m256i mask01 = _mm256_set1_epi8((char)0x01);
    const __m256i mask_lo = _mm256_set1_epi16((int16_t)0x00ff);
    const __m256i mask_hi = _mm256_set1_epi16((int16_t)0xff00);
          __m256i fail_mask = _mm256_set1_epi8((char)0xff);

    {
        const size_t tail = NTRUPLUS_N / 8 - 32;
        const int16_t *tcoeffs = a->coeffs + 8 * tail;
        const uint8_t *tbuf_lo = buf + tail;
        const uint8_t *tbuf_hi = buf + tail + NTRUPLUS_N / 8;
        uint8_t *tmsg = msg + tail;

        __m256i a0 = _mm256_load_si256((const __m256i *)(tcoeffs +   0));
        __m256i a1 = _mm256_load_si256((const __m256i *)(tcoeffs +  64));
        __m256i a2 = _mm256_load_si256((const __m256i *)(tcoeffs + 128));
        __m256i a3 = _mm256_load_si256((const __m256i *)(tcoeffs + 192));
        __m256i a4 = _mm256_load_si256((const __m256i *)(tcoeffs +  16));
        __m256i a5 = _mm256_load_si256((const __m256i *)(tcoeffs +  80));
        __m256i a6 = _mm256_load_si256((const __m256i *)(tcoeffs + 144));
        __m256i a7 = _mm256_load_si256((const __m256i *)(tcoeffs + 208));

        __m256i b0 = _mm256_packs_epi16(a0, a1);
        __m256i b1 = _mm256_packs_epi16(a2, a3);
        __m256i b2 = _mm256_packs_epi16(a4, a5);
        __m256i b3 = _mm256_packs_epi16(a6, a7);

        a0 = _mm256_load_si256((const __m256i *)(tcoeffs +  32));
        a1 = _mm256_load_si256((const __m256i *)(tcoeffs +  96));
        a2 = _mm256_load_si256((const __m256i *)(tcoeffs + 160));
        a3 = _mm256_load_si256((const __m256i *)(tcoeffs + 224));
        a4 = _mm256_load_si256((const __m256i *)(tcoeffs +  48));
        a5 = _mm256_load_si256((const __m256i *)(tcoeffs + 112));
        a6 = _mm256_load_si256((const __m256i *)(tcoeffs + 176));
        a7 = _mm256_load_si256((const __m256i *)(tcoeffs + 240));

        __m256i b4 = _mm256_packs_epi16(a0, a1);
        __m256i b5 = _mm256_packs_epi16(a2, a3);
        __m256i b6 = _mm256_packs_epi16(a4, a5);
        __m256i b7 = _mm256_packs_epi16(a6, a7);

        a0 = _mm256_permute2x128_si256(b0, b1, 0x20);
        a1 = _mm256_permute2x128_si256(b0, b1, 0x31);
        a2 = _mm256_permute2x128_si256(b2, b3, 0x20);
        a3 = _mm256_permute2x128_si256(b2, b3, 0x31);
        a4 = _mm256_permute2x128_si256(b4, b5, 0x20);
        a5 = _mm256_permute2x128_si256(b4, b5, 0x31);
        a6 = _mm256_permute2x128_si256(b6, b7, 0x20);
        a7 = _mm256_permute2x128_si256(b6, b7, 0x31);

        b0 = _mm256_slli_epi64(a4, 32);
        b1 = _mm256_srli_epi64(a0, 32);
        b2 = _mm256_slli_epi64(a5, 32);
        b3 = _mm256_srli_epi64(a1, 32);

        b0 = _mm256_blend_epi32(a0, b0, 0xaa);
        b1 = _mm256_blend_epi32(a4, b1, 0x55);
        b2 = _mm256_blend_epi32(a1, b2, 0xaa);
        b3 = _mm256_blend_epi32(a5, b3, 0x55);

        b4 = _mm256_slli_epi64(a6, 32);
        b5 = _mm256_srli_epi64(a2, 32);
        b6 = _mm256_slli_epi64(a7, 32);
        b7 = _mm256_srli_epi64(a3, 32);

        b4 = _mm256_blend_epi32(a2, b4, 0xaa);
        b5 = _mm256_blend_epi32(a6, b5, 0x55);
        b6 = _mm256_blend_epi32(a3, b6, 0xaa);
        b7 = _mm256_blend_epi32(a7, b7, 0x55);

        a0 = _mm256_slli_epi32(b4, 16);
        a1 = _mm256_srli_epi32(b0, 16);
        a2 = _mm256_slli_epi32(b5, 16);
        a3 = _mm256_srli_epi32(b1, 16);

        a0 = _mm256_blend_epi16(b0, a0, 0xaa);
        a1 = _mm256_blend_epi16(b4, a1, 0x55);
        a2 = _mm256_blend_epi16(b1, a2, 0xaa);
        a3 = _mm256_blend_epi16(b5, a3, 0x55);

        a4 = _mm256_slli_epi32(b6, 16);
        a5 = _mm256_srli_epi32(b2, 16);
        a6 = _mm256_slli_epi32(b7, 16);
        a7 = _mm256_srli_epi32(b3, 16);

        a4 = _mm256_blend_epi16(b2, a4, 0xaa);
        a5 = _mm256_blend_epi16(b6, a5, 0x55);
        a6 = _mm256_blend_epi16(b3, a6, 0xaa);
        a7 = _mm256_blend_epi16(b7, a7, 0x55);

        __m256i t0 = _mm256_and_si256(a0, mask_lo);
        __m256i t1 = _mm256_slli_epi16(a4, 8);
        __m256i t2 = _mm256_srli_epi16(a0, 8);
        __m256i t3 = _mm256_and_si256(a4, mask_hi);

        b0 = _mm256_xor_si256(t0, t1);
        b1 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a1, mask_lo);
        t1 = _mm256_slli_epi16(a5, 8);
        t2 = _mm256_srli_epi16(a1, 8);
        t3 = _mm256_and_si256(a5, mask_hi);

        b2 = _mm256_xor_si256(t0, t1);
        b3 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a2, mask_lo);
        t1 = _mm256_slli_epi16(a6, 8);
        t2 = _mm256_srli_epi16(a2, 8);
        t3 = _mm256_and_si256(a6, mask_hi);

        b4 = _mm256_xor_si256(t0, t1);
        b5 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a3, mask_lo);
        t1 = _mm256_slli_epi16(a7, 8);
        t2 = _mm256_srli_epi16(a3, 8);
        t3 = _mm256_and_si256(a7, mask_hi);

        b6 = _mm256_xor_si256(t0, t1);
        b7 = _mm256_xor_si256(t2, t3);

        b0 = _mm256_add_epi8(b0, mask01);
        b1 = _mm256_add_epi8(b1, mask01);
        b2 = _mm256_add_epi8(b2, mask01);
        b3 = _mm256_add_epi8(b3, mask01);
        b4 = _mm256_add_epi8(b4, mask01);
        b5 = _mm256_add_epi8(b5, mask01);
        b6 = _mm256_add_epi8(b6, mask01);
        b7 = _mm256_add_epi8(b7, mask01);

        b2 = _mm256_slli_epi16(b2, 2);
        b3 = _mm256_slli_epi16(b3, 2);
        b4 = _mm256_slli_epi16(b4, 4);
        b5 = _mm256_slli_epi16(b5, 4);
        b6 = _mm256_slli_epi16(b6, 6);
        b7 = _mm256_slli_epi16(b7, 6);

        a0 = _mm256_xor_si256(b0, b2);
        a1 = _mm256_xor_si256(b1, b3);
        a2 = _mm256_xor_si256(b4, b6);
        a3 = _mm256_xor_si256(b5, b7);

        a0 = _mm256_xor_si256(a0, a2);
        a1 = _mm256_xor_si256(a1, a3);

        a2 = _mm256_loadu_si256((const __m256i *)tbuf_hi);
        a3 = _mm256_srli_epi16(a2, 1);

        a2 = _mm256_and_si256(a2, mask55);
        a3 = _mm256_and_si256(a3, mask55);

        a0 = _mm256_add_epi8(a0, a2);
        a1 = _mm256_add_epi8(a1, a3);

        //handling error
        a2 = _mm256_srli_epi16(a0, 1);
        a3 = _mm256_srli_epi16(a1, 1);

        a2 = _mm256_xor_si256(a0, a2);
        a3 = _mm256_xor_si256(a1, a3);

        a2 = _mm256_and_si256(a2, a3);
        fail_mask = _mm256_and_si256(fail_mask, a2);

        //extract bits
        a0 = _mm256_and_si256(a0, mask55);
        a1 = _mm256_and_si256(a1, mask55);
        a1 = _mm256_slli_epi16(a1, 1);

        a0 = _mm256_xor_si256(a0, a1);
        a0 = _mm256_xor_si256(a0, maskff);

        a1 = _mm256_loadu_si256((const __m256i *)tbuf_lo);

        a0 = _mm256_xor_si256(a0, a1);

        _mm256_storeu_si256((__m256i *)tmsg, a0);
    }

    const int16_t *coeffs = a->coeffs;
    const uint8_t *buf_lo = buf;
    const uint8_t *buf_hi = buf + NTRUPLUS_N / 8;
    uint8_t *msgp = msg;

    for (size_t i = 0; i < NTRUPLUS_N / 256; i++)
    {
        __m256i a0 = _mm256_load_si256((const __m256i *)(coeffs +   0));
        __m256i a1 = _mm256_load_si256((const __m256i *)(coeffs +  64));
        __m256i a2 = _mm256_load_si256((const __m256i *)(coeffs + 128));
        __m256i a3 = _mm256_load_si256((const __m256i *)(coeffs + 192));
        __m256i a4 = _mm256_load_si256((const __m256i *)(coeffs +  16));
        __m256i a5 = _mm256_load_si256((const __m256i *)(coeffs +  80));
        __m256i a6 = _mm256_load_si256((const __m256i *)(coeffs + 144));
        __m256i a7 = _mm256_load_si256((const __m256i *)(coeffs + 208));

        __m256i b0 = _mm256_packs_epi16(a0, a1);
        __m256i b1 = _mm256_packs_epi16(a2, a3);
        __m256i b2 = _mm256_packs_epi16(a4, a5);
        __m256i b3 = _mm256_packs_epi16(a6, a7);

        a0 = _mm256_load_si256((const __m256i *)(coeffs +  32));
        a1 = _mm256_load_si256((const __m256i *)(coeffs +  96));
        a2 = _mm256_load_si256((const __m256i *)(coeffs + 160));
        a3 = _mm256_load_si256((const __m256i *)(coeffs + 224));
        a4 = _mm256_load_si256((const __m256i *)(coeffs +  48));
        a5 = _mm256_load_si256((const __m256i *)(coeffs + 112));
        a6 = _mm256_load_si256((const __m256i *)(coeffs + 176));
        a7 = _mm256_load_si256((const __m256i *)(coeffs + 240));

        __m256i b4 = _mm256_packs_epi16(a0, a1);
        __m256i b5 = _mm256_packs_epi16(a2, a3);
        __m256i b6 = _mm256_packs_epi16(a4, a5);
        __m256i b7 = _mm256_packs_epi16(a6, a7);

        a0 = _mm256_permute2x128_si256(b0, b1, 0x20);
        a1 = _mm256_permute2x128_si256(b0, b1, 0x31);
        a2 = _mm256_permute2x128_si256(b2, b3, 0x20);
        a3 = _mm256_permute2x128_si256(b2, b3, 0x31);
        a4 = _mm256_permute2x128_si256(b4, b5, 0x20);
        a5 = _mm256_permute2x128_si256(b4, b5, 0x31);
        a6 = _mm256_permute2x128_si256(b6, b7, 0x20);
        a7 = _mm256_permute2x128_si256(b6, b7, 0x31);

        b0 = _mm256_slli_epi64(a4, 32);
        b1 = _mm256_srli_epi64(a0, 32);
        b2 = _mm256_slli_epi64(a5, 32);
        b3 = _mm256_srli_epi64(a1, 32);

        b0 = _mm256_blend_epi32(a0, b0, 0xaa);
        b1 = _mm256_blend_epi32(a4, b1, 0x55);
        b2 = _mm256_blend_epi32(a1, b2, 0xaa);
        b3 = _mm256_blend_epi32(a5, b3, 0x55);

        b4 = _mm256_slli_epi64(a6, 32);
        b5 = _mm256_srli_epi64(a2, 32);
        b6 = _mm256_slli_epi64(a7, 32);
        b7 = _mm256_srli_epi64(a3, 32);

        b4 = _mm256_blend_epi32(a2, b4, 0xaa);
        b5 = _mm256_blend_epi32(a6, b5, 0x55);
        b6 = _mm256_blend_epi32(a3, b6, 0xaa);
        b7 = _mm256_blend_epi32(a7, b7, 0x55);

        a0 = _mm256_slli_epi32(b4, 16);
        a1 = _mm256_srli_epi32(b0, 16);
        a2 = _mm256_slli_epi32(b5, 16);
        a3 = _mm256_srli_epi32(b1, 16);

        a0 = _mm256_blend_epi16(b0, a0, 0xaa);
        a1 = _mm256_blend_epi16(b4, a1, 0x55);
        a2 = _mm256_blend_epi16(b1, a2, 0xaa);
        a3 = _mm256_blend_epi16(b5, a3, 0x55);

        a4 = _mm256_slli_epi32(b6, 16);
        a5 = _mm256_srli_epi32(b2, 16);
        a6 = _mm256_slli_epi32(b7, 16);
        a7 = _mm256_srli_epi32(b3, 16);

        a4 = _mm256_blend_epi16(b2, a4, 0xaa);
        a5 = _mm256_blend_epi16(b6, a5, 0x55);
        a6 = _mm256_blend_epi16(b3, a6, 0xaa);
        a7 = _mm256_blend_epi16(b7, a7, 0x55);

        __m256i t0 = _mm256_and_si256(a0, mask_lo);
        __m256i t1 = _mm256_slli_epi16(a4, 8);
        __m256i t2 = _mm256_srli_epi16(a0, 8);
        __m256i t3 = _mm256_and_si256(a4, mask_hi);

        b0 = _mm256_xor_si256(t0, t1);
        b1 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a1, mask_lo);
        t1 = _mm256_slli_epi16(a5, 8);
        t2 = _mm256_srli_epi16(a1, 8);
        t3 = _mm256_and_si256(a5, mask_hi);

        b2 = _mm256_xor_si256(t0, t1);
        b3 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a2, mask_lo);
        t1 = _mm256_slli_epi16(a6, 8);
        t2 = _mm256_srli_epi16(a2, 8);
        t3 = _mm256_and_si256(a6, mask_hi);

        b4 = _mm256_xor_si256(t0, t1);
        b5 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a3, mask_lo);
        t1 = _mm256_slli_epi16(a7, 8);
        t2 = _mm256_srli_epi16(a3, 8);
        t3 = _mm256_and_si256(a7, mask_hi);

        b6 = _mm256_xor_si256(t0, t1);
        b7 = _mm256_xor_si256(t2, t3);

        b0 = _mm256_add_epi8(b0, mask01);
        b1 = _mm256_add_epi8(b1, mask01);
        b2 = _mm256_add_epi8(b2, mask01);
        b3 = _mm256_add_epi8(b3, mask01);
        b4 = _mm256_add_epi8(b4, mask01);
        b5 = _mm256_add_epi8(b5, mask01);
        b6 = _mm256_add_epi8(b6, mask01);
        b7 = _mm256_add_epi8(b7, mask01);

        b2 = _mm256_slli_epi16(b2, 2);
        b3 = _mm256_slli_epi16(b3, 2);
        b4 = _mm256_slli_epi16(b4, 4);
        b5 = _mm256_slli_epi16(b5, 4);
        b6 = _mm256_slli_epi16(b6, 6);
        b7 = _mm256_slli_epi16(b7, 6);

        a0 = _mm256_xor_si256(b0, b2);
        a1 = _mm256_xor_si256(b1, b3);
        a2 = _mm256_xor_si256(b4, b6);
        a3 = _mm256_xor_si256(b5, b7);

        a0 = _mm256_xor_si256(a0, a2);
        a1 = _mm256_xor_si256(a1, a3);

        a2 = _mm256_loadu_si256((const __m256i *)buf_hi);
        a3 = _mm256_srli_epi16(a2, 1);

        a2 = _mm256_and_si256(a2, mask55);
        a3 = _mm256_and_si256(a3, mask55);

        a0 = _mm256_add_epi8(a0, a2);
        a1 = _mm256_add_epi8(a1, a3);

        //handling error
        a2 = _mm256_srli_epi16(a0, 1);
        a3 = _mm256_srli_epi16(a1, 1);

        a2 = _mm256_xor_si256(a0, a2);
        a3 = _mm256_xor_si256(a1, a3);

        a2 = _mm256_and_si256(a2, a3);
        fail_mask = _mm256_and_si256(fail_mask, a2);

        //extract bits
        a0 = _mm256_and_si256(a0, mask55);
        a1 = _mm256_and_si256(a1, mask55);
        a1 = _mm256_slli_epi16(a1, 1);

        a0 = _mm256_xor_si256(a0, a1);
        a0 = _mm256_xor_si256(a0, maskff);

        a1 = _mm256_loadu_si256((const __m256i *)buf_lo);

        a0 = _mm256_xor_si256(a0, a1);

        _mm256_storeu_si256((__m256i *)msgp, a0);

        coeffs += 256;
        buf_lo += 32;
        buf_hi += 32;
        msgp   += 32;
    }

    fail_mask = _mm256_xor_si256(fail_mask, maskff);
    fail_mask = _mm256_and_si256(fail_mask, mask55);

    int fail = !_mm256_testz_si256(fail_mask, fail_mask);
    __m256i m = _mm256_set1_epi8((uint8_t)(fail - 1)); // fail=0 -> 0xFF, fail=1 -> 0x00

    for (size_t i = 0; i + 32 <= NTRUPLUS_N / 8; i += 32)
    {
        __m256i x = _mm256_loadu_si256((const __m256i *)(msg + i));
        x = _mm256_and_si256(x, m);
        _mm256_storeu_si256((__m256i *)(msg + i), x);
    }

    return fail;
}
