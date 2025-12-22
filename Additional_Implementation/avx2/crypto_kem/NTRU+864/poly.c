#include <immintrin.h>

#include "params.h"
#include "poly.h"
#include "consts.h"

static inline __m256i fqmul_avx2(__m256i a, __m256i b, __m256i B,  __m256i q)
{
    __m256i l, h, r;

    l  = _mm256_mullo_epi16(a, B);
    h  = _mm256_mulhi_epi16(a, b);
    l  = _mm256_mulhi_epi16(l, q);
    r = _mm256_sub_epi16(h, l);

    return r;
}

static inline __m256i fqsqr_avx2(__m256i a,  __m256i q, __m256i qinv)
{
    __m256i l, h, r;
    __m256i A;

    A = _mm256_mullo_epi16(a, qinv);
    l  = _mm256_mullo_epi16(a, A);
    h  = _mm256_mulhi_epi16(a, a);
    l  = _mm256_mulhi_epi16(l, q);
    r = _mm256_sub_epi16(h, l);

    return r;
}

static inline __m256i fqinv_avx2(__m256i r)
{
    const __m256i qinv     = _mm256_load_si256((const __m256i *)_16xqinv);
    const __m256i q        = _mm256_load_si256((const __m256i *)_16xq);
    const __m256i Rinvqinv = _mm256_load_si256((const __m256i *)_16xRinvqinv);
    const __m256i Rinv     = _mm256_load_si256((const __m256i *)_16xRinv);

    __m256i T1, T2;
    __m256i t1, t2, t3;

    T1  = _mm256_mullo_epi16(r, qinv);
    t1 = fqsqr_avx2(r, q, qinv);   // 10 
    
    T2 = _mm256_mullo_epi16(t1, qinv);
    t2 = fqsqr_avx2(t1, q, qinv);      // 100 
    t2 = fqsqr_avx2(t2, q, qinv);      // 1000 
    t3 = fqsqr_avx2(t2, q, qinv);      // 10000 
    t1 = fqmul_avx2(t2, t1, T2, q);    // 1010 

    T2 = _mm256_mullo_epi16(t1, qinv);
    t2 = fqmul_avx2(t3, t1, T2, q);    // 11010 
    t2 = fqsqr_avx2(t2, q, qinv);      // 110100 
    t2 = fqmul_avx2(t2, r, T1, q);     // 110101 
    t1 = fqmul_avx2(t2, t1, T2, q);    // 111111

    t2 = fqsqr_avx2(t2, q, qinv);      // 1101010
    t2 = fqsqr_avx2(t2, q, qinv);      // 11010100 
    t2 = fqsqr_avx2(t2, q, qinv);      // 110101000 
    t2 = fqsqr_avx2(t2, q, qinv);      // 1101010000 
    t2 = fqsqr_avx2(t2, q, qinv);      // 11010100000
    t2 = fqsqr_avx2(t2, q, qinv);      // 110101000000 

    T2 = _mm256_mullo_epi16(t2, qinv);
    t2 = fqmul_avx2(t1, t2, T2, q);    // 110101111111 

    t2 = fqmul_avx2(t2, Rinv, Rinvqinv, q);

    return t2;
}

static inline int poly_fqinv_batch(__m256i *restrict r)
{
    const __m256i qinv = _mm256_load_si256((const __m256i *)_16xqinv);
    const __m256i q    = _mm256_load_si256((const __m256i *)_16xq);
    const __m256i z    = _mm256_setzero_si256();

    __m256i t[18];
    __m256i R[18];

    __m256i inv;

    t[0] = r[0];

    for (size_t i = 1; i < 18; i++) {
        __m256i ri = r[i];
        __m256i Bi = _mm256_mullo_epi16(ri, qinv);
        R[i] = Bi;
        t[i] = fqmul_avx2(t[i-1], ri, Bi, q);
    }

    __m256i mask_zero = _mm256_cmpeq_epi16(t[17], z);
    if (!_mm256_testz_si256(mask_zero, mask_zero)) return 1;

    inv = fqinv_avx2(t[17]);

    for (size_t i = 17; i > 0; i--) {
        __m256i ti  = t[i - 1];
        __m256i ri  = r[i];
        __m256i INV = _mm256_mullo_epi16(inv, qinv);

        __m256i l0 = _mm256_mulhi_epi16(_mm256_mullo_epi16(ti, INV), q);
        __m256i l1 = _mm256_mulhi_epi16(_mm256_mullo_epi16(inv, R[i]), q);
        __m256i h0 = _mm256_mulhi_epi16(ti, inv);
        __m256i h1 = _mm256_mulhi_epi16(inv, ri);

        r[i] = _mm256_sub_epi16(h0, l0);
        inv  = _mm256_sub_epi16(h1, l1);
    }

    r[0] = inv;

    return 0;
}

static inline void poly_baseinv_2(poly *r, const __m256i den[18])
{
    const __m256i qinv = _mm256_load_si256((const __m256i *)_16xqinv);
    const __m256i q    = _mm256_load_si256((const __m256i *)_16xq);

    for (size_t i = 0; i < 18; i++) {
        __m256i r0 = _mm256_load_si256((const __m256i *)&r->coeffs[48*i +  0]);
        __m256i r1 = _mm256_load_si256((const __m256i *)&r->coeffs[48*i + 16]);
        __m256i r2 = _mm256_load_si256((const __m256i *)&r->coeffs[48*i + 32]);

        __m256i t = den[i];
        __m256i T = _mm256_mullo_epi16(t, qinv);

        r0 = fqmul_avx2(r0, t, T, q);
        r1 = fqmul_avx2(r1, t, T, q);
        r2 = fqmul_avx2(r2, t, T, q);

        _mm256_store_si256((__m256i *)&r->coeffs[48*i +  0], r0);
        _mm256_store_si256((__m256i *)&r->coeffs[48*i + 16], r1);
        _mm256_store_si256((__m256i *)&r->coeffs[48*i + 32], r2);
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
    const __m256i ymm0 = _mm256_set1_epi8((char)0x55);
    const __m256i ymm1 = _mm256_set1_epi8((char)0xff);
    const __m256i ymm2 = _mm256_set1_epi8((char)0x01);
    const __m256i mask1 = _mm256_set1_epi16((int16_t)0x00ff);
    const __m256i mask2 = _mm256_set1_epi16((int16_t)0xff00);
          __m256i ymmf = _mm256_set1_epi8((char)0xff);

    __m256i ymm3, ymm4, ymm5, ymm6, ymm7, ymm8, ymm9, ymma, ymmb, ymmc, ymmd, ymme;
    __m256i t0, t1, t2, t3;
    __m256i a0, a1, a2, a3, a4, a5, a6, a7;

    ymm7 = _mm256_load_si256((const __m256i *)&a->coeffs[608 +  0]);
    ymm8 = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 64]);
    ymm9 = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 128]);
    ymma = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 192]);    
    ymmb = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 16]);
    ymmc = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 80]);
    ymmd = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 144]);
    ymme = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 208]);

    ymm3 = _mm256_packs_epi16(ymm7, ymm8);      
    ymm4 = _mm256_packs_epi16(ymm9, ymma);
    ymm5 = _mm256_packs_epi16(ymmb, ymmc);
    ymm6 = _mm256_packs_epi16(ymmd, ymme);

    ymm7 = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 32]);
    ymm8 = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 96]);
    ymm9 = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 160]);
    ymma = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 224]);
    ymmb = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 48]);
    ymmc = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 112]);
    ymmd = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 176]);
    ymme = _mm256_load_si256((const __m256i *)&a->coeffs[608 + 240]);

    ymm7 = _mm256_packs_epi16(ymm7, ymm8);
    ymm8 = _mm256_packs_epi16(ymm9, ymma);
    ymm9 = _mm256_packs_epi16(ymmb, ymmc);
    ymma = _mm256_packs_epi16(ymmd, ymme);

    ymmb = _mm256_permute2x128_si256(ymm3, ymm4, 0x20);
    ymmc = _mm256_permute2x128_si256(ymm3, ymm4, 0x31);
    ymmd = _mm256_permute2x128_si256(ymm5, ymm6, 0x20);
    ymme = _mm256_permute2x128_si256(ymm5, ymm6, 0x31);
    ymm3 = _mm256_permute2x128_si256(ymm7, ymm8, 0x20);
    ymm4 = _mm256_permute2x128_si256(ymm7, ymm8, 0x31);
    ymm5 = _mm256_permute2x128_si256(ymm9, ymma, 0x20);
    ymm6 = _mm256_permute2x128_si256(ymm9, ymma, 0x31);

    ymm7 = _mm256_slli_epi64(ymm3, 32);
    ymm8 = _mm256_srli_epi64(ymmb, 32);
    ymm9 = _mm256_slli_epi64(ymm4, 32);
    ymma = _mm256_srli_epi64(ymmc, 32);

    ymm7 = _mm256_blend_epi32(ymmb, ymm7, 0xaa);
    ymm8 = _mm256_blend_epi32(ymm3, ymm8, 0x55);
    ymm9 = _mm256_blend_epi32(ymmc, ymm9, 0xaa);
    ymma = _mm256_blend_epi32(ymm4, ymma, 0x55);

    ymmb = _mm256_slli_epi64(ymm5, 32);
    ymmc = _mm256_srli_epi64(ymmd, 32);
    ymm3 = _mm256_slli_epi64(ymm6, 32);
    ymm4 = _mm256_srli_epi64(ymme, 32);

    ymmb = _mm256_blend_epi32(ymmd, ymmb, 0xaa);
    ymmc = _mm256_blend_epi32(ymm5, ymmc, 0x55);
    ymmd = _mm256_blend_epi32(ymme, ymm3, 0xaa);
    ymme = _mm256_blend_epi32(ymm6, ymm4, 0x55);

    ymm3 = _mm256_slli_epi32(ymmb, 16);
    ymm4 = _mm256_srli_epi32(ymm7, 16);
    ymm5 = _mm256_slli_epi32(ymmc, 16);
    ymm6 = _mm256_srli_epi32(ymm8, 16);

    ymm3 = _mm256_blend_epi16(ymm7, ymm3, 0xaa);
    ymm4 = _mm256_blend_epi16(ymmb, ymm4, 0x55);
    ymm5 = _mm256_blend_epi16(ymm8, ymm5, 0xaa);
    ymm6 = _mm256_blend_epi16(ymmc, ymm6, 0x55);

    ymm7 = _mm256_slli_epi32(ymmd, 16);
    ymm8 = _mm256_srli_epi32(ymm9, 16);
    ymmb = _mm256_slli_epi32(ymme, 16);
    ymmc = _mm256_srli_epi32(ymma, 16);

    ymm7 = _mm256_blend_epi16(ymm9, ymm7, 0xaa);
    ymm8 = _mm256_blend_epi16(ymmd, ymm8, 0x55);
    ymm9 = _mm256_blend_epi16(ymma, ymmb, 0xaa);
    ymma = _mm256_blend_epi16(ymme, ymmc, 0x55);

    ymmb = _mm256_and_si256(ymm3, mask1);
    ymmc = _mm256_slli_epi16(ymm7, 8);
    ymm3 = _mm256_srli_epi16(ymm3, 8);
    ymm7 = _mm256_and_si256(ymm7, mask2);

    ymmd = _mm256_and_si256(ymm4, mask1);
    ymme = _mm256_slli_epi16(ymm8, 8);
    ymm4 = _mm256_srli_epi16(ymm4, 8);
    ymm8 = _mm256_and_si256(ymm8, mask2);

    a0 = _mm256_xor_si256(ymmb, ymmc);
    a1 = _mm256_xor_si256(ymm3, ymm7);
    a2 = _mm256_xor_si256(ymmd, ymme);
    a3 = _mm256_xor_si256(ymm4, ymm8);

    t0 = _mm256_and_si256(ymm5, mask1);
    t2 = _mm256_slli_epi16(ymm9, 8);
    ymm5 = _mm256_srli_epi16(ymm5, 8);
    ymm9 = _mm256_and_si256(ymm9, mask2);

    t1 = _mm256_and_si256(ymm6, mask1);
    t3 = _mm256_slli_epi16(ymma, 8);
    ymm6 = _mm256_srli_epi16(ymm6, 8);
    ymma = _mm256_and_si256(ymma, mask2);

    a4 = _mm256_xor_si256(t0, t2);
    a5 = _mm256_xor_si256(ymm5, ymm9);
    a6 = _mm256_xor_si256(t1, t3);        
    a7 = _mm256_xor_si256(ymm6, ymma);

    ymm7 = a0;
    ymm8 = a1;
    ymm9 = a2;
    ymma = a3;
    ymmb = a4;
    ymmc = a5;
    ymmd = a6;
    ymme = a7;

    ymm3 = _mm256_add_epi8(ymm7, ymm2);
    ymm4 = _mm256_add_epi8(ymm8, ymm2);
    ymm5 = _mm256_add_epi8(ymm9, ymm2);
    ymm6 = _mm256_add_epi8(ymma, ymm2);
    ymm7 = _mm256_add_epi8(ymmb, ymm2);
    ymm8 = _mm256_add_epi8(ymmc, ymm2);
    ymm9 = _mm256_add_epi8(ymmd, ymm2);
    ymma = _mm256_add_epi8(ymme, ymm2);

    ymm5 = _mm256_slli_epi16(ymm5, 2);
    ymm6 = _mm256_slli_epi16(ymm6, 2);
    ymm7 = _mm256_slli_epi16(ymm7, 4);
    ymm8 = _mm256_slli_epi16(ymm8, 4);
    ymm9 = _mm256_slli_epi16(ymm9, 6);
    ymma = _mm256_slli_epi16(ymma, 6);

    ymm5 = _mm256_xor_si256(ymm3, ymm5);
    ymm6 = _mm256_xor_si256(ymm4, ymm6);
    ymm7 = _mm256_xor_si256(ymm7, ymm9);
    ymm8 = _mm256_xor_si256(ymm8, ymma);

    ymm3 = _mm256_xor_si256(ymm5, ymm7);
    ymm4 = _mm256_xor_si256(ymm6, ymm8);

    ymm5 = _mm256_loadu_si256((const __m256i *)&buf[76]);
    ymm6 = _mm256_loadu_si256((const __m256i *)&buf[76 + NTRUPLUS_N / 8]);

    ymm7 = _mm256_srli_epi16(ymm6, 1);

    ymm6 = _mm256_and_si256(ymm6, ymm0);
    ymm7 = _mm256_and_si256(ymm7, ymm0);

    ymm3 = _mm256_add_epi8(ymm3, ymm6);
    ymm4 = _mm256_add_epi8(ymm4, ymm7);

    //handling error
    ymm6 = _mm256_srli_epi16(ymm3, 1);
    ymm7 = _mm256_srli_epi16(ymm4, 1);

    ymm6 = _mm256_xor_si256(ymm3, ymm6);
    ymm7 = _mm256_xor_si256(ymm4, ymm7);

    ymm6 = _mm256_and_si256(ymm6, ymm7);
    ymmf = _mm256_and_si256(ymmf, ymm6);

    //extract bits
    ymm3 = _mm256_and_si256(ymm3, ymm0);
    ymm4 = _mm256_and_si256(ymm4, ymm0);
    ymm4 = _mm256_slli_epi16(ymm4, 1);

    ymm3 = _mm256_xor_si256(ymm3, ymm4);
    ymm3 = _mm256_xor_si256(ymm3, ymm1);
    
    ymm3 = _mm256_xor_si256(ymm3, ymm5);

    _mm256_storeu_si256((__m256i *)&msg[76], ymm3);


    for (size_t i = 0; i < NTRUPLUS_N / 256; i++) 
    {
        ymm7 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i +  0]);
        ymm8 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 64]);
        ymm9 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 128]);
        ymma = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 192]);    
        ymmb = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 16]);
        ymmc = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 80]);
        ymmd = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 144]);
        ymme = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 208]);

        ymm3 = _mm256_packs_epi16(ymm7, ymm8);      
        ymm4 = _mm256_packs_epi16(ymm9, ymma);
        ymm5 = _mm256_packs_epi16(ymmb, ymmc);
        ymm6 = _mm256_packs_epi16(ymmd, ymme);

        ymm7 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 32]);
        ymm8 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 96]);
        ymm9 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 160]);
        ymma = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 224]);
        ymmb = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 48]);
        ymmc = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 112]);
        ymmd = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 176]);
        ymme = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 240]);

        ymm7 = _mm256_packs_epi16(ymm7, ymm8);
        ymm8 = _mm256_packs_epi16(ymm9, ymma);
        ymm9 = _mm256_packs_epi16(ymmb, ymmc);
        ymma = _mm256_packs_epi16(ymmd, ymme);

        ymmb = _mm256_permute2x128_si256(ymm3, ymm4, 0x20);
        ymmc = _mm256_permute2x128_si256(ymm3, ymm4, 0x31);
        ymmd = _mm256_permute2x128_si256(ymm5, ymm6, 0x20);
        ymme = _mm256_permute2x128_si256(ymm5, ymm6, 0x31);
        ymm3 = _mm256_permute2x128_si256(ymm7, ymm8, 0x20);
        ymm4 = _mm256_permute2x128_si256(ymm7, ymm8, 0x31);
        ymm5 = _mm256_permute2x128_si256(ymm9, ymma, 0x20);
        ymm6 = _mm256_permute2x128_si256(ymm9, ymma, 0x31);

        ymm7 = _mm256_slli_epi64(ymm3, 32);
        ymm8 = _mm256_srli_epi64(ymmb, 32);
        ymm9 = _mm256_slli_epi64(ymm4, 32);
        ymma = _mm256_srli_epi64(ymmc, 32);

        ymm7 = _mm256_blend_epi32(ymmb, ymm7, 0xaa);
        ymm8 = _mm256_blend_epi32(ymm3, ymm8, 0x55);
        ymm9 = _mm256_blend_epi32(ymmc, ymm9, 0xaa);
        ymma = _mm256_blend_epi32(ymm4, ymma, 0x55);

        ymmb = _mm256_slli_epi64(ymm5, 32);
        ymmc = _mm256_srli_epi64(ymmd, 32);
        ymm3 = _mm256_slli_epi64(ymm6, 32);
        ymm4 = _mm256_srli_epi64(ymme, 32);

        ymmb = _mm256_blend_epi32(ymmd, ymmb, 0xaa);
        ymmc = _mm256_blend_epi32(ymm5, ymmc, 0x55);
        ymmd = _mm256_blend_epi32(ymme, ymm3, 0xaa);
        ymme = _mm256_blend_epi32(ymm6, ymm4, 0x55);

        ymm3 = _mm256_slli_epi32(ymmb, 16);
        ymm4 = _mm256_srli_epi32(ymm7, 16);
        ymm5 = _mm256_slli_epi32(ymmc, 16);
        ymm6 = _mm256_srli_epi32(ymm8, 16);

        ymm3 = _mm256_blend_epi16(ymm7, ymm3, 0xaa);
        ymm4 = _mm256_blend_epi16(ymmb, ymm4, 0x55);
        ymm5 = _mm256_blend_epi16(ymm8, ymm5, 0xaa);
        ymm6 = _mm256_blend_epi16(ymmc, ymm6, 0x55);

        ymm7 = _mm256_slli_epi32(ymmd, 16);
        ymm8 = _mm256_srli_epi32(ymm9, 16);
        ymmb = _mm256_slli_epi32(ymme, 16);
        ymmc = _mm256_srli_epi32(ymma, 16);

        ymm7 = _mm256_blend_epi16(ymm9, ymm7, 0xaa);
        ymm8 = _mm256_blend_epi16(ymmd, ymm8, 0x55);
        ymm9 = _mm256_blend_epi16(ymma, ymmb, 0xaa);
        ymma = _mm256_blend_epi16(ymme, ymmc, 0x55);

        ymmb = _mm256_and_si256(ymm3, mask1);
        ymmc = _mm256_slli_epi16(ymm7, 8);
        ymm3 = _mm256_srli_epi16(ymm3, 8);
        ymm7 = _mm256_and_si256(ymm7, mask2);

        ymmd = _mm256_and_si256(ymm4, mask1);
        ymme = _mm256_slli_epi16(ymm8, 8);
        ymm4 = _mm256_srli_epi16(ymm4, 8);
        ymm8 = _mm256_and_si256(ymm8, mask2);

        a0 = _mm256_xor_si256(ymmb, ymmc);
        a1 = _mm256_xor_si256(ymm3, ymm7);
        a2 = _mm256_xor_si256(ymmd, ymme);
        a3 = _mm256_xor_si256(ymm4, ymm8);

        t0 = _mm256_and_si256(ymm5, mask1);
        t2 = _mm256_slli_epi16(ymm9, 8);
        ymm5 = _mm256_srli_epi16(ymm5, 8);
        ymm9 = _mm256_and_si256(ymm9, mask2);

        t1 = _mm256_and_si256(ymm6, mask1);
        t3 = _mm256_slli_epi16(ymma, 8);
        ymm6 = _mm256_srli_epi16(ymm6, 8);
        ymma = _mm256_and_si256(ymma, mask2);

        a4 = _mm256_xor_si256(t0, t2);
        a5 = _mm256_xor_si256(ymm5, ymm9);
        a6 = _mm256_xor_si256(t1, t3);        
        a7 = _mm256_xor_si256(ymm6, ymma);

        ymm7 = a0;
        ymm8 = a1;
        ymm9 = a2;
        ymma = a3;
        ymmb = a4;
        ymmc = a5;
        ymmd = a6;
        ymme = a7;

        ymm3 = _mm256_add_epi8(ymm7, ymm2);
        ymm4 = _mm256_add_epi8(ymm8, ymm2);
        ymm5 = _mm256_add_epi8(ymm9, ymm2);
        ymm6 = _mm256_add_epi8(ymma, ymm2);
        ymm7 = _mm256_add_epi8(ymmb, ymm2);
        ymm8 = _mm256_add_epi8(ymmc, ymm2);
        ymm9 = _mm256_add_epi8(ymmd, ymm2);
        ymma = _mm256_add_epi8(ymme, ymm2);

        ymm5 = _mm256_slli_epi16(ymm5, 2);
        ymm6 = _mm256_slli_epi16(ymm6, 2);
        ymm7 = _mm256_slli_epi16(ymm7, 4);
        ymm8 = _mm256_slli_epi16(ymm8, 4);
        ymm9 = _mm256_slli_epi16(ymm9, 6);
        ymma = _mm256_slli_epi16(ymma, 6);

        ymm5 = _mm256_xor_si256(ymm3, ymm5);
        ymm6 = _mm256_xor_si256(ymm4, ymm6);
        ymm7 = _mm256_xor_si256(ymm7, ymm9);
        ymm8 = _mm256_xor_si256(ymm8, ymma);

        ymm3 = _mm256_xor_si256(ymm5, ymm7);
        ymm4 = _mm256_xor_si256(ymm6, ymm8);

        ymm5 = _mm256_loadu_si256((const __m256i *)&buf[32*i]);
        ymm6 = _mm256_loadu_si256((const __m256i *)&buf[32*i + NTRUPLUS_N / 8]);

        ymm7 = _mm256_srli_epi16(ymm6, 1);

        ymm6 = _mm256_and_si256(ymm6, ymm0);
        ymm7 = _mm256_and_si256(ymm7, ymm0);

        ymm3 = _mm256_add_epi8(ymm3, ymm6);
        ymm4 = _mm256_add_epi8(ymm4, ymm7);

        //handling error
        ymm6 = _mm256_srli_epi16(ymm3, 1);
        ymm7 = _mm256_srli_epi16(ymm4, 1);

        ymm6 = _mm256_xor_si256(ymm3, ymm6);
        ymm7 = _mm256_xor_si256(ymm4, ymm7);

        ymm6 = _mm256_and_si256(ymm6, ymm7);
        ymmf = _mm256_and_si256(ymmf, ymm6);

        //extract bits
        ymm3 = _mm256_and_si256(ymm3, ymm0);
        ymm4 = _mm256_and_si256(ymm4, ymm0);
        ymm4 = _mm256_slli_epi16(ymm4, 1);

        ymm3 = _mm256_xor_si256(ymm3, ymm4);
        ymm3 = _mm256_xor_si256(ymm3, ymm1);
        
        ymm3 = _mm256_xor_si256(ymm3, ymm5);

        _mm256_storeu_si256((__m256i *)&msg[32*i], ymm3);
    }

    ymmf = _mm256_xor_si256(ymmf, ymm1);
    ymmf = _mm256_and_si256(ymmf, ymm0);

    return !_mm256_testz_si256(ymmf, ymmf);
}
