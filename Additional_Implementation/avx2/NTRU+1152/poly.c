/*
 * References:
 *
 * [Sei18] Gregor Seiler,
 * "Faster AVX2 optimized NTT multiplication for Ring-LWE lattice cryptography",
 * Cryptology ePrint Archive, Paper 2018/039, 2018.
 * https://eprint.iacr.org/2018/039
 *
 * [KCP26] Jonghyun Kim, Haehyun Cho, and Jong Hwan Park,
 * "Accelerating NTRU+ Key Generation via Hierarchical Batch Inversion",
 * Cryptology ePrint Archive, Paper 2026/1191, 2026.
 * https://eprint.iacr.org/2026/1191
 */

#include "util.h"
#include <immintrin.h>

#include "params.h"
#include "poly.h"
#include "consts.h"

#define NTRUPLUS_QINV 12929
#define NTRUPLUS_AVX2_BLOCKS (NTRUPLUS_N / (16 * NTRUPLUS_D))

/* Signed Montgomery multiplication [Sei18]. */
static inline __m256i fqmul(__m256i a, __m256i b, __m256i q, __m256i qinv)
{
    __m256i B  = _mm256_mullo_epi16(b, qinv);
    __m256i lo = _mm256_mullo_epi16(a, B);
    __m256i hi = _mm256_mulhi_epi16(a, b);
    lo         = _mm256_mulhi_epi16(lo, q);
    return _mm256_sub_epi16(hi, lo);
}

/* Signed Montgomery multiplication with a precomputed factor [Sei18]. */
static inline __m256i fqmul_precomp(__m256i a, __m256i b, __m256i B, __m256i q)
{
    __m256i lo = _mm256_mullo_epi16(a, B);
    __m256i hi = _mm256_mulhi_epi16(a, b);
    lo         = _mm256_mulhi_epi16(lo, q);
    return _mm256_sub_epi16(hi, lo);
}

static inline __m256i fqmul_precomp_neg(__m256i a, __m256i b, __m256i B, __m256i q)
{
    __m256i lo = _mm256_mullo_epi16(a, B);
    __m256i hi = _mm256_mulhi_epi16(a, b);
    lo         = _mm256_mulhi_epi16(lo, q);
    return _mm256_sub_epi16(lo, hi);
}

/*************************************************
* Name:        fqinv
*
* Description: Computes SIMD multiplicative inverses in Z_q.
*              The exponent q-2 = 3455 is evaluated using a shortest
*              addition chain of length 15 (OEIS A003313).
*
* Arguments:   - __m256i a: input lanes with |a| < q
*
* Returns:     lane-wise multiplicative inverses of a
**************************************************/
static inline __m256i fqinv(__m256i a)
{
    const __m256i qinv = _mm256_set1_epi16(NTRUPLUS_QINV);
    const __m256i q    = _mm256_set1_epi16(NTRUPLUS_Q);

    __m256i t0, t1, T;

    t0 = fqmul(a, a, q, qinv);        //10
    t0 = _mm256_slli_epi16(t0, 4);    //16^1720 = R^-2 mod q
    t0 = fqmul(t0, t0, q, qinv);      //100
    t0 = fqmul(t0, t0, q, qinv);      //1000
    t0 = fqmul(t0, t0, q, qinv);      //10000

    T  = _mm256_mullo_epi16(t0, qinv);
    t1 = fqmul_precomp(a, t0, T, q);  //10001
    t0 = fqmul_precomp(t0, t0, T, q); //100000

    t0 = fqmul(t0, t0, q, qinv);      //1000000
    t0 = fqmul(t0, t0, q, qinv);      //10000000

    T  = _mm256_mullo_epi16(t0, qinv);
    t1 = fqmul_precomp(t1, t0, T, q); //10010001
    t0 = fqmul_precomp(t1, t0, T, q); //100010001

    T  = _mm256_mullo_epi16(t0, qinv);
    t1 = fqmul_precomp(t1, t0, T, q); //110100010
    t1 = fqmul_precomp(t1, t0, T, q); //1010110011

    T  = _mm256_mullo_epi16(t1, qinv);
    t0 = fqmul_precomp(t1, t1, T, q); //10101100110
    t0 = fqmul(t0, t0, q, qinv);      //101011001100
    t0 = fqmul_precomp(t0, t1, T, q); //110101111111

    return t0;
}

/*************************************************
* Name:        fqinv_batch
*
* Description: Inverts SIMD field elements through six strided prefix chains.
*              Reuses the prefix tail for the product tree and recovery.
*
* Reference:   J. Kim, H. Cho, and J. H. Park, "Accelerating NTRU+ Key
*              Generation via Hierarchical Batch Inversion," IACR ePrint
*              2026/1191, https://eprint.iacr.org/2026/1191.
*
* Arguments:   - __m256i *r: input/output array of SIMD field elements
*
* Returns:     1 if an input is zero; otherwise 0
**************************************************/
static inline int fqinv_batch(__m256i *restrict r)
{
    const int chunk = NTRUPLUS_AVX2_BLOCKS/6;

    const __m256i qinv = _mm256_set1_epi16(NTRUPLUS_QINV);
    const __m256i q    = _mm256_set1_epi16(NTRUPLUS_Q);

    __m256i pc[NTRUPLUS_AVX2_BLOCKS-1];
    __m256i *p  = pc;
    __m256i *ri = r+6;

    //product_chain - level 0
    p[0] = fqmul(r[0], ri[0], q, qinv);
    p[1] = fqmul(r[1], ri[1], q, qinv);
    p[2] = fqmul(r[2], ri[2], q, qinv);
    p[3] = fqmul(r[3], ri[3], q, qinv);
    p[4] = fqmul(r[4], ri[4], q, qinv);
    p[5] = fqmul(r[5], ri[5], q, qinv);

    for (int i = 2; i < chunk; i++)
    {
        const __m256i *prev = p;
        p                  += 6;
        ri                 += 6;

        p[0] = fqmul(prev[0], ri[0], q, qinv);
        p[1] = fqmul(prev[1], ri[1], q, qinv);
        p[2] = fqmul(prev[2], ri[2], q, qinv);
        p[3] = fqmul(prev[3], ri[3], q, qinv);
        p[4] = fqmul(prev[4], ri[4], q, qinv);
        p[5] = fqmul(prev[5], ri[5], q, qinv);
    }

    //product_chain - level 1
    __m256i *tree = p+6;

    tree[0] = fqmul(p[0], p[1], q, qinv);
    tree[1] = fqmul(p[2], p[3], q, qinv);
    tree[2] = fqmul(p[4], p[5], q, qinv);

    //product_chain - level 2
    tree[3] = fqmul(tree[0], tree[1], q, qinv);
    tree[4] = fqmul(tree[3], tree[2], q, qinv);

    //check_zero
    const __m256i z         = _mm256_setzero_si256();
    const __m256i mask_zero = _mm256_cmpeq_epi16(tree[4], z);
    volatile int aggregate  = !_mm256_testz_si256(mask_zero, mask_zero);
    int fail                = aggregate;
    ntruplus_declassify(&fail, sizeof fail);

    if (fail)
    {
        u8_clear(pc, sizeof pc);
        return 1;
    }

    //fqinv
    tree[4] = fqinv(tree[4]);

    //recover_inv - level 2
    {
        const __m256i T0 = _mm256_mullo_epi16(tree[4], qinv);
        const __m256i t  = fqmul_precomp(tree[2], tree[4], T0, q);
        tree[2]          = fqmul_precomp(tree[3], tree[4], T0, q);

        const __m256i T1 = _mm256_mullo_epi16(t, qinv);
        tree[3]          = fqmul_precomp(tree[1], t, T1, q);
        tree[1]          = fqmul_precomp(tree[0], t, T1, q);
        tree[0]          = tree[3];
    }

    //recover_inv - level 1
    {
        const __m256i T0 = _mm256_mullo_epi16(tree[0], qinv);
        const __m256i T1 = _mm256_mullo_epi16(tree[1], qinv);
        const __m256i T2 = _mm256_mullo_epi16(tree[2], qinv);

        p[0] = fqmul_precomp(p[0], tree[0], T0, q);
        p[1] = fqmul_precomp(p[1], tree[0], T0, q);
        p[2] = fqmul_precomp(p[2], tree[1], T1, q);
        p[3] = fqmul_precomp(p[3], tree[1], T1, q);
        p[4] = fqmul_precomp(p[4], tree[2], T2, q);
        p[5] = fqmul_precomp(p[5], tree[2], T2, q);
    }

    //recover_inv - level 0
    //acc[k^1] is the inverse of chain k.
    __m256i *acc = p;

    for (int i = chunk - 1; i > 1; i--)
    {
        p -= 6;

        tree[0] = ri[0];
        tree[1] = ri[1];
        tree[2] = ri[2];

        {
            const __m256i T0 = _mm256_mullo_epi16(acc[1], qinv);
            const __m256i T1 = _mm256_mullo_epi16(acc[0], qinv);
            const __m256i T2 = _mm256_mullo_epi16(acc[3], qinv);

            ri[0] = fqmul_precomp(p[0], acc[1], T0, q);
            ri[1] = fqmul_precomp(p[1], acc[0], T1, q);
            ri[2] = fqmul_precomp(p[2], acc[3], T2, q);

            acc[1] = fqmul_precomp(tree[0], acc[1], T0, q);
            acc[0] = fqmul_precomp(tree[1], acc[0], T1, q);
            acc[3] = fqmul_precomp(tree[2], acc[3], T2, q);
        }

        tree[0] = ri[3];
        tree[1] = ri[4];
        tree[2] = ri[5];

        {
            const __m256i T0 = _mm256_mullo_epi16(acc[2], qinv);
            const __m256i T1 = _mm256_mullo_epi16(acc[5], qinv);
            const __m256i T2 = _mm256_mullo_epi16(acc[4], qinv);

            ri[3] = fqmul_precomp(p[3], acc[2], T0, q);
            ri[4] = fqmul_precomp(p[4], acc[5], T1, q);
            ri[5] = fqmul_precomp(p[5], acc[4], T2, q);

            acc[2] = fqmul_precomp(tree[0], acc[2], T0, q);
            acc[5] = fqmul_precomp(tree[1], acc[5], T1, q);
            acc[4] = fqmul_precomp(tree[2], acc[4], T2, q);
        }

        ri -= 6;
    }

    tree[0] = ri[0];
    tree[1] = ri[1];
    tree[2] = ri[2];

    {
        const __m256i T0 = _mm256_mullo_epi16(acc[1], qinv);
        const __m256i T1 = _mm256_mullo_epi16(acc[0], qinv);
        const __m256i T2 = _mm256_mullo_epi16(acc[3], qinv);

        ri[0] = fqmul_precomp(r[0], acc[1], T0, q);
        ri[1] = fqmul_precomp(r[1], acc[0], T1, q);
        ri[2] = fqmul_precomp(r[2], acc[3], T2, q);

        r[0] = fqmul_precomp(tree[0], acc[1], T0, q);
        r[1] = fqmul_precomp(tree[1], acc[0], T1, q);
        r[2] = fqmul_precomp(tree[2], acc[3], T2, q);
    }

    tree[0] = ri[3];
    tree[1] = ri[4];
    tree[2] = ri[5];

    {
        const __m256i T0 = _mm256_mullo_epi16(acc[2], qinv);
        const __m256i T1 = _mm256_mullo_epi16(acc[5], qinv);
        const __m256i T2 = _mm256_mullo_epi16(acc[4], qinv);

        ri[3] = fqmul_precomp(r[3], acc[2], T0, q);
        ri[4] = fqmul_precomp(r[4], acc[5], T1, q);
        ri[5] = fqmul_precomp(r[5], acc[4], T2, q);

        r[3] = fqmul_precomp(tree[0], acc[2], T0, q);
        r[4] = fqmul_precomp(tree[1], acc[5], T1, q);
        r[5] = fqmul_precomp(tree[2], acc[4], T2, q);
    }

    //clear
    u8_clear(pc, sizeof pc);
    return 0;
}

NTRUPLUS_INTERNAL NTRUPLUS_SYSV
extern void poly_baseinv_1(poly *r, __m256i den[12], const poly *a);

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

        r0 = fqmul_precomp(r0, t, T, q);
        r1 = fqmul_precomp_neg(r1, t, T, q);
        r2 = fqmul_precomp(r2, t, T, q);
        r3 = fqmul_precomp_neg(r3, t, T, q);

        _mm256_store_si256((__m256i *)&r->coeffs[64*i +  0], r0);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 16], r1);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 32], r2);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 48], r3);
    }
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inversion of polynomial in NTT domain. poly_baseinv_1 exposes
*              all base denominators, fqinv_batch inverts them hierarchically,
*              and poly_baseinv_2 applies the inverses to complete each base
*              inverse.
*
* Reference:   J. Kim, H. Cho, and J. H. Park, "Accelerating NTRU+ Key
*              Generation via Hierarchical Batch Inversion," IACR ePrint
*              2026/1191, https://eprint.iacr.org/2026/1191.
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const poly *a: pointer to input polynomial
*
* Returns:     integer
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
    __m256i den[18];

    poly_baseinv_1(r, den, a);

    const int fail = fqinv_batch(den);

    if (fail)
    {
        poly_clear(r);
    }
    else
    {
        poly_baseinv_2(r, den);
    }

    volatile __m256i *vden = den;

    for (size_t i = 0; i < sizeof den / sizeof den[0]; i++)
        vden[i] = _mm256_setzero_si256();

    return fail;
}
