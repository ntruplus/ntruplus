/*
 * References:
 *
 * [KCP26] Jonghyun Kim, Haehyun Cho, and Jong Hwan Park,
 * "Accelerating NTRU+ Key Generation via Hierarchical Batch Inversion",
 * Cryptology ePrint Archive, Paper 2026/1191, 2026.
 * https://eprint.iacr.org/2026/1191
 * Montgomery polynomial arithmetic and eight-group hierarchical inversion.
 * GitHub source: https://github.com/yoswuk/hierarchical_batch_inversion
 * Commit: d8050fa096365a00607a249c0066ff904dad81f3.
 *
 * [SUPERCOP] SUPERCOP 20261018,
 * crypto_kem/ntruplus768/avx2-opt/invntt_crepmod3.s.
 * https://bench.cr.yp.to/supercop/supercop-20261018.tar.xz
 * Inverse-NTT normalization folded into the final radix-3 twiddles.
 */

#include <stddef.h>
#include <stdint.h>
#include "api.h"
#include "params.h"
#include "poly.h"
#include "util.h"

#define NTRUPLUS_R     -147 //R = 2^16 mod q
#define NTRUPLUS_RSQ    867 //(R^2) mod q
#define NTRUPLUS_QINV 12929 //(q)^(-1) mod (2^16)

#define NTRUPLUS_OMEGA        -886 //(omega * R) mod q
#define NTRUPLUS_ZMINUSZ5INV -1665 //(z - z^5)^(-1) * R mod q
                                   //where z = zeta^((n/d)/6)

#define NTRUPLUS_ZETAMUL_IDX (NTRUPLUS_N/(2*NTRUPLUS_D))

#define NTRUPLUS_NINV_SCALED 1679 //(n/d)^(-1) * R^2 mod q

#define NTRUPLUS_RADIX2_START (16*NTRUPLUS_D)
#define NTRUPLUS_RADIX3_END   (NTRUPLUS_N/6)

// zetas: Montgomery-form twiddle factors
// zetas[1] is unscaled.
static const int16_t zetas[NTRUPLUS_N/NTRUPLUS_D] = {
     -147,  -722,  -682,  -248,  -708,   682,     1,  -722,
     -723,  -257, -1124,  -867,  -256,  1484,  1262, -1590,
     1611,   222,  1164, -1346,  1716, -1521,  -357,   395,
     -455,   639,   502,   655,  -699,   541,    95, -1577,
    -1241,   550,   -44,    39,  -820,  -216,  -121,  -757,
     -348,   937,   893,   387,  -603,  1713, -1105,  1058,
     1449,   837,   901,  1637,  -569, -1617, -1530,  1199,
       50,  -830,  -625,     4,   176,  -156,  1257, -1507,
     -380,  -606,  1293,   661,  1428, -1580,  -565,  -992,
      548,  -800,    64,  -371,   961,   641,    87,   630,
      675,  -834,   205,    54, -1081,  1351,  1413, -1331,
    -1673, -1267, -1558,   281, -1464,  -588,  1015,   436,
      223,  1138, -1059,  -397,  -183,  1655,   559, -1674,
      277,   933,  1723,   437, -1514,   242,  1640,   432,
    -1583,   696,   774,  1671,   927,   514,   512,   489,
      297,   601,  1473,  1130,  1322,   871,   760,  1212,
     -312,  -352,   443,   943,     8,  1250,  -100,  1660,
      -31,  1206, -1341, -1247,   444,   235,  1364, -1209,
      361,   230,   673,   582,  1409,  1501,  1401,   251,
     1022, -1063,  1053,  1188,   417, -1391,   -27, -1626,
     1685,  -315,  1408, -1248,   400,   274, -1543,    32,
    -1550,  1531, -1367,  -124,  1458,  1379,  -940, -1681,
       22,  1709,  -275,  1108,   354, -1728,  -968,   858,
     1221,  -218,   294,  -732, -1095,   892,  1588,  -779
};

// zetas_inv_scaled[i] = fqmul(NTRUPLUS_NINV_SCALED, zetas[i+2]).
static const int16_t zetas_inv_scaled[4] = {
    -18, 622, 326, 18
};

/*************************************************
* Name:        barrett_reduce
*
* Description: Barrett reduction modulo q.
*
* Arguments:   - int16_t a: input coefficient
*
* Returns:     a modulo q in [-1729,1729].
**************************************************/
static inline int16_t barrett_reduce(int16_t a)
{
    const int16_t v = ((1<<26) + NTRUPLUS_Q/2) / NTRUPLUS_Q;

    int16_t t = ((int32_t)v * a + (1<<25)) >> 26;
    return a - t * NTRUPLUS_Q;
}

/*************************************************
* Name:        montgomery_reduce
*
* Description: Montgomery reduction with R = 2^16.
*
* Arguments:   - int32_t a: |a| <= INT32_MAX - q*2^15
*
* Returns:     a/R modulo q as int16_t. Inputs in
*              [-q*2^15,q*2^15) yield a result in (-q,q).
**************************************************/
static inline int16_t montgomery_reduce(int32_t a)
{
    int16_t t = (int16_t)a * NTRUPLUS_QINV;
    t = (a - (int32_t)t * NTRUPLUS_Q) >> 16;
    return t;
}

/*************************************************
* Name:        fqmul
*
* Description: Montgomery multiplication modulo q.
*
* Arguments:   - int16_t a: first factor
*              - int16_t b: second factor
*
* Returns:     a*b/R modulo q as int16_t.
**************************************************/
static inline int16_t fqmul(int16_t a, int16_t b)
{
    return montgomery_reduce((int32_t)a*b);
}

/*************************************************
* Name:        poly_tobytes
*
* Description: Serialization of a polynomial
*
* Arguments:   - uint8_t *r: pointer to output byte array
*              (needs space for NTRUPLUS_POLYBYTES bytes)
*              - const poly *a: pointer to input polynomial
*
* Returns:     none.
**************************************************/
void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a)
{
    for (size_t i = 0; i < NTRUPLUS_N/2; i++)
    {
        int16_t t0, t1;

        t0 = a->coeffs[2*i];
        t0 += (t0 >> 15) & NTRUPLUS_Q;
        t1 = a->coeffs[2*i+1];
        t1 += (t1 >> 15) & NTRUPLUS_Q;

        r[3*i]   = t0;
        r[3*i+1] = (t0 >> 8) | (t1 << 4);
        r[3*i+2] = (t1 >> 4);
    }
}

/*************************************************
* Name:        poly_frombytes
*
* Description: De-serialization of a polynomial;
*              inverse of poly_tobytes. Returns 1 for non-canonical coefficients.
*              Clears the output polynomial on failure.
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *a: pointer to input byte array
*              (of NTRUPLUS_POLYBYTES bytes)
*
* Returns:     NTRUPLUS_SUCCESS for canonical input; NTRUPLUS_FAILURE otherwise.
**************************************************/
int poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES])
{
    uint32_t fail = 0;

    for (size_t i = 0; i < NTRUPLUS_N/2; i++)
    {
        const uint16_t t0 = ((a[3*i+0] >> 0) | ((uint16_t)a[3*i+1] << 8)) & 0xFFF;
        const uint16_t t1 = ((a[3*i+1] >> 4) | ((uint16_t)a[3*i+2] << 4)) & 0xFFF;

        r->coeffs[2*i]   = t0;
        r->coeffs[2*i+1] = t1;

        fail |= (uint32_t)(NTRUPLUS_Q - 1) - t0;
        fail |= (uint32_t)(NTRUPLUS_Q - 1) - t1;
    }

    fail >>= 31;
    ntruplus_declassify(&fail, sizeof fail);
    if (fail)
        poly_clear(r);

    return fail;
}

/*************************************************
* Name:        poly_cbd1
*
* Description: Sample a polynomial deterministically from a random,
*              with output polynomial close to centered binomial distribution
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *buf: pointer to input random
*              (of length NTRUPLUS_N/4 bytes)
*
* Returns:     none.
**************************************************/
void poly_cbd1(poly *r, const uint8_t buf[NTRUPLUS_N/4])
{
    for (size_t i = 0; i < NTRUPLUS_N/8; i++)
    {
        uint8_t t0 = buf[i];
        uint8_t t1 = buf[i+NTRUPLUS_N/8];

        for (size_t j = 0; j < 8; j++)
        {
            r->coeffs[8*i+j] = (t0 & 0x1) - (t1 & 0x1);

            t0 >>= 1;
            t1 >>= 1;
        }
    }
}

/*************************************************
* Name:        poly_cbd1_triple
*
* Description: Sample CBD1 coefficients and multiply them by three.
*
* Arguments:   - poly *r: output polynomial
*              - const uint8_t *buf: input randomness
*
* Returns:     none.
**************************************************/
void poly_cbd1_triple(poly *r, const uint8_t buf[NTRUPLUS_N/4])
{
    for (size_t i = 0; i < NTRUPLUS_N/8; i++)
    {
        uint8_t t0 = buf[i];
        uint8_t t1 = buf[i+NTRUPLUS_N/8];

        for (size_t j = 0; j < 8; j++)
        {
            r->coeffs[8*i+j] = 3*((t0 & 0x1) - (t1 & 0x1));

            t0 >>= 1;
            t1 >>= 1;
        }
    }
}

/*************************************************
* Name:        poly_sotp_encode
*
* Description: Encode a message using SOTP and input randomness.
*
* Arguments:   - poly *r: output polynomial
*              - const uint8_t *msg: input message
*              - const uint8_t *buf: input randomness
*
* Returns:     none.
**************************************************/
void poly_sotp_encode(poly *r, const uint8_t msg[NTRUPLUS_N/8], const uint8_t buf[NTRUPLUS_N/4])
{
    for (size_t i = 0; i < NTRUPLUS_N/8; i++)
    {
        uint8_t t0 = buf[i] ^ msg[i];
        uint8_t t1 = buf[i+NTRUPLUS_N/8];

        for (size_t j = 0; j < 8; j++)
        {
            r->coeffs[8*i+j] = (t0 & 0x1) - (t1 & 0x1);

            t0 >>= 1;
            t1 >>= 1;
        }
    }
}

/*************************************************
* Name:        poly_sotp_decode
*
* Description: Decode SOTP and clear the message on failure.
*
* Arguments:   - uint8_t *msg: output message
*              - const poly *a: input polynomial
*              - const uint8_t *buf: input randomness
*
* Returns:     NTRUPLUS_SUCCESS on success; NTRUPLUS_FAILURE otherwise.
**************************************************/
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N/8], const poly *a, const uint8_t buf[NTRUPLUS_N/4])
{
    uint32_t fail = 0;
    volatile uint8_t mask;

    for (size_t i = 0; i < NTRUPLUS_N/8; i++)
    {
        uint8_t t0 = buf[i+NTRUPLUS_N/8];
        uint8_t t1 = 0;

        for (size_t j = 0; j < 8; j++)
        {
            uint16_t t2 = t0 & 0x1;

            t2   += a->coeffs[8*i+j];
            fail |= t2;
            t1   ^= (uint8_t)(t2 << j);

            t0 >>= 1;
        }

        msg[i] = t1 ^ buf[i];
    }

    fail >>= 1;
    fail = (-fail) >> 31;

    mask = (uint8_t)(fail - 1);

    for (size_t i = 0; i < NTRUPLUS_N/8; i++)
        msg[i] &= mask;

    return fail;
}

/*************************************************
* Name:        poly_ntt
*
* Description: Compute the forward NTT in R_q.
*              Input coefficients are in [-4,4]; output is in [-1728,1728].
*
* Arguments:   - poly *r: input/output polynomial
*
* Returns:     none.
**************************************************/
void poly_ntt(poly *r)
{
    int16_t *a = r->coeffs;
    size_t   k = 1;

    {
        const int16_t zeta = zetas[k++];

        for (size_t i = 0; i < NTRUPLUS_N/2; i++)
        {
            const int16_t t = zeta*a[i+NTRUPLUS_N/2];

            a[i+NTRUPLUS_N/2] = a[i] - t + a[i+NTRUPLUS_N/2];
            a[i]              = a[i] + t;
        }
    }

    for (size_t step = NTRUPLUS_N/6; step >= NTRUPLUS_RADIX3_END; step = step/3)
    {
        for (size_t start = 0; start < NTRUPLUS_N; start += 3*step)
        {
            const int16_t zeta0 = zetas[k++];
            const int16_t zeta1 = zetas[k++];

            for (size_t i = start; i < start+step; i++)
            {
                const int16_t t0 = fqmul(zeta0, a[i+step]);
                const int16_t t1 = fqmul(zeta1, a[i+2*step]);
                const int16_t t2 = fqmul(NTRUPLUS_OMEGA, t0 - t1);

                a[i+2*step] = a[i] - t0 - t2;
                a[i+step]   = a[i] - t1 + t2;
                a[i]        = a[i] + t0 + t1;
            }
        }
    }

    for (size_t step = NTRUPLUS_RADIX2_START; step >= NTRUPLUS_D; step >>= 1)
    {
        for (size_t start = 0; start < NTRUPLUS_N; start += (step << 1))
        {
            const int16_t zeta = zetas[k++];

            for (size_t i = start; i < start+step; i++)
            {
                const int16_t t = fqmul(zeta, a[i+step]);

                a[i+step] = a[i] - t;
                a[i]      = a[i] + t;
            }
        }
    }

    for (size_t i = 0; i < NTRUPLUS_N; i++)
        a[i] = barrett_reduce(a[i]);
}

/*************************************************
* Name:        poly_invntt_scaled
*
* Description: Compute the inverse NTT to ordinary coefficients.
*              Input is R^-1-scaled; input and output coefficients are in (-q,q).
*
* Arguments:   - poly *r: input/output polynomial
*
* Returns:     none.
**************************************************/
void poly_invntt_scaled(poly *r)
{
    int16_t *a = r->coeffs;
    size_t k = NTRUPLUS_N/NTRUPLUS_D - 1;

    for (size_t step = NTRUPLUS_D; step <= 2*NTRUPLUS_D; step <<= 1)
    {
        for (size_t start = 0; start < NTRUPLUS_N; start += (step << 1))
        {
            const int16_t zeta = zetas[k--];

            for (size_t i = start; i < start+step; i++)
            {
                const int16_t t = a[i+step];

                a[i+step] = fqmul(zeta, t - a[i]);
                a[i]      = a[i] + t;
            }
        }
    }

    {
        const size_t step = 4*NTRUPLUS_D;

        for (size_t start = 0; start < NTRUPLUS_N; start += (step << 1))
        {
            const int16_t zeta = zetas[k--];

            for (size_t i = start; i < start+step; i++)
            {
                const int16_t t = a[i+step];

                a[i+step] = fqmul(zeta, t - a[i]);
                a[i]      = barrett_reduce(a[i] + t);
            }
        }
    }

    {
        const size_t step = 8*NTRUPLUS_D;

        for (size_t start = 0; start < NTRUPLUS_N; start += (step << 1))
        {
            const int16_t zeta = zetas[k--];

            for (size_t i = start; i < start+step; i++)
            {
                const int16_t t = a[i+step];

                a[i+step] = fqmul(zeta, t - a[i]);
                a[i]      = a[i] + t;
            }
        }
    }

    {
        const size_t step = NTRUPLUS_RADIX2_START;

        for (size_t start = 0; start < NTRUPLUS_N; start += (step << 1))
        {
            const int16_t zeta = zetas[k--];

            for (size_t i = start; i < start+step; i++)
            {
                const int16_t t = a[i+step];

                a[i+step] = fqmul(zeta, t - a[i]);
                a[i]      = a[i] + t; //|r[i]| <= 9828
            }
        }
    }

    {
        const size_t step = NTRUPLUS_N/6;
        k = 4;

        for (size_t start = 0; start < NTRUPLUS_N; start += 3*step)
        {
            const int16_t zeta1 = zetas_inv_scaled[--k];
            const int16_t zeta0 = zetas_inv_scaled[--k];

            for (size_t i = start; i < start+step; i++)
            {
                const int16_t t0 = fqmul(NTRUPLUS_OMEGA, a[i+step] - a[i]);
                const int16_t t1 = fqmul(zeta0, a[i+2*step] - a[i] + t0);
                const int16_t t2 = fqmul(zeta1, a[i+2*step] - a[i+step] - t0);

                //|a+b+c| <= 29484 < 2^15.
                a[i]        = fqmul(NTRUPLUS_NINV_SCALED, a[i] + a[i+step] + a[i+2*step]);
                a[i+step]   = t1;
                a[i+2*step] = t2;
            }
        }
    }

    // Preserve the output range expected by poly_crepmod3.
    for (size_t i = 0; i < NTRUPLUS_N/2; i++)
    {
        const int16_t t0 = a[i] + a[i+NTRUPLUS_N/2];
        const int16_t t1 = fqmul(NTRUPLUS_ZMINUSZ5INV, a[i] - a[i+NTRUPLUS_N/2]);

        a[i]              = barrett_reduce(t0 - t1);
        a[i+NTRUPLUS_N/2] = barrett_reduce(t1 + t1);
    }
}

/*************************************************
* Name:        fqinv
*
* Description: Compute the field inverse using Fermat's little theorem.
*
* Arguments:   - int16_t a: input with |a| < q
*
* Returns:     a^-1 modulo q; zero maps to zero.
**************************************************/
static inline int16_t fqinv(int16_t a)
{
    int16_t t0, t1;

    t0 = fqmul(a, a); //10

    t0 = (int16_t)((uint16_t)t0 << 4); //16^1720=R^-2 mod q

    t0 = fqmul(t0, t0); //100
    t0 = fqmul(t0, t0); //1000
    t0 = fqmul(t0, t0); //10000
    t1 = fqmul(t0, a);  //10001

    t0 = fqmul(t0, t0); //100000
    t0 = fqmul(t0, t0); //1000000
    t0 = fqmul(t0, t0); //10000000
    t1 = fqmul(t0, t1); //10010001

    t0 = fqmul(t1, t0); //100010001
    t1 = fqmul(t0, t1); //110100010
    t1 = fqmul(t1, t0); //1010110011
    t0 = fqmul(t1, t1); //10101100110
    t0 = fqmul(t0, t0); //101011001100
    t0 = fqmul(t0, t1); //110101111111

    return t0;
}

/*************************************************
* Name:        fqinv_batch
*
* Description: Invert field elements using eight prefix chains.
*              If any input is zero, all outputs are zero.
*
* Arguments:   - int16_t *r: N/D input elements, overwritten by their inverses
*
* Returns:     none.
**************************************************/
static inline void fqinv_batch(int16_t *r)
{
    const int chunk = NTRUPLUS_N/(8*NTRUPLUS_D);

    int16_t pc[NTRUPLUS_N/NTRUPLUS_D-1];
    int16_t *p  = pc;
    int16_t *ri = r+8;

    //product_chain - level 0
    p[0] = fqmul(r[0], ri[0]);
    p[1] = fqmul(r[1], ri[1]);
    p[2] = fqmul(r[2], ri[2]);
    p[3] = fqmul(r[3], ri[3]);
    p[4] = fqmul(r[4], ri[4]);
    p[5] = fqmul(r[5], ri[5]);
    p[6] = fqmul(r[6], ri[6]);
    p[7] = fqmul(r[7], ri[7]);

    for (int i = 2; i < chunk; i++)
    {
        const int16_t *prev = p;

        p += 8;
        ri += 8;

        p[0] = fqmul(prev[0], ri[0]);
        p[1] = fqmul(prev[1], ri[1]);
        p[2] = fqmul(prev[2], ri[2]);
        p[3] = fqmul(prev[3], ri[3]);
        p[4] = fqmul(prev[4], ri[4]);
        p[5] = fqmul(prev[5], ri[5]);
        p[6] = fqmul(prev[6], ri[6]);
        p[7] = fqmul(prev[7], ri[7]);
    }

    //product_chain - level 1
    int16_t *tree = p+8;

    tree[0] = fqmul(p[0], p[1]);
    tree[1] = fqmul(p[2], p[3]);
    tree[2] = fqmul(p[4], p[5]);
    tree[3] = fqmul(p[6], p[7]);

    //product_chain - level 2
    tree[4] = fqmul(tree[0], tree[1]);
    tree[5] = fqmul(tree[2], tree[3]);

    //product_chain - level 3
    tree[6] = fqmul(tree[4], tree[5]);

    //fqinv
    tree[6] = fqinv(tree[6]);

    //recover_inv - level 3
    tree[5] = fqmul(tree[5], tree[6]);
    tree[4] = fqmul(tree[4], tree[6]);

    //recover_inv - level 2
    tree[0] = fqmul(tree[0], tree[5]);
    tree[1] = fqmul(tree[1], tree[5]);
    tree[2] = fqmul(tree[2], tree[4]);
    tree[3] = fqmul(tree[3], tree[4]);

    //recover_inv - level 1
    p[0] = fqmul(p[0], tree[1]);
    p[1] = fqmul(p[1], tree[1]);
    p[2] = fqmul(p[2], tree[0]);
    p[3] = fqmul(p[3], tree[0]);

    p[4] = fqmul(tree[3], p[4]);
    p[5] = fqmul(tree[3], p[5]);
    p[6] = fqmul(tree[2], p[6]);
    p[7] = fqmul(tree[2], p[7]);

    //recover_inv - level 0
    int16_t *acc = p;

    for (int i = chunk - 1; i > 1; i--)
    {
        p -= 8;

        tree[0] = ri[0];
        tree[1] = ri[1];
        tree[2] = ri[2];
        tree[3] = ri[3];

        ri[0] = fqmul(p[0], acc[1]);
        ri[1] = fqmul(p[1], acc[0]);
        ri[2] = fqmul(p[2], acc[3]);
        ri[3] = fqmul(p[3], acc[2]);

        acc[1] = fqmul(acc[1], tree[0]);
        acc[0] = fqmul(acc[0], tree[1]);
        acc[3] = fqmul(acc[3], tree[2]);
        acc[2] = fqmul(acc[2], tree[3]);

        tree[0] = ri[4];
        tree[1] = ri[5];
        tree[2] = ri[6];
        tree[3] = ri[7];

        ri[4] = fqmul(p[4], acc[5]);
        ri[5] = fqmul(p[5], acc[4]);
        ri[6] = fqmul(p[6], acc[7]);
        ri[7] = fqmul(p[7], acc[6]);

        acc[5] = fqmul(acc[5], tree[0]);
        acc[4] = fqmul(acc[4], tree[1]);
        acc[7] = fqmul(acc[7], tree[2]);
        acc[6] = fqmul(acc[6], tree[3]);

        ri -= 8;
    }

    tree[0] = ri[0];
    tree[1] = ri[1];
    tree[2] = ri[2];
    tree[3] = ri[3];

    ri[0] = fqmul(r[0], acc[1]);
    ri[1] = fqmul(r[1], acc[0]);
    ri[2] = fqmul(r[2], acc[3]);
    ri[3] = fqmul(r[3], acc[2]);

    r[0] = fqmul(acc[1], tree[0]);
    r[1] = fqmul(acc[0], tree[1]);
    r[2] = fqmul(acc[3], tree[2]);
    r[3] = fqmul(acc[2], tree[3]);

    tree[0] = ri[4];
    tree[1] = ri[5];
    tree[2] = ri[6];
    tree[3] = ri[7];

    ri[4] = fqmul(r[4], acc[5]);
    ri[5] = fqmul(r[5], acc[4]);
    ri[6] = fqmul(r[6], acc[7]);
    ri[7] = fqmul(r[7], acc[6]);

    r[4] = fqmul(acc[5], tree[0]);
    r[5] = fqmul(acc[4], tree[1]);
    r[6] = fqmul(acc[7], tree[2]);
    r[7] = fqmul(acc[6], tree[3]);

    i16_clear(pc, NTRUPLUS_N/NTRUPLUS_D-1);
}

/*************************************************
* Name:        baseinv_1
*
* Description: Compute the quartic inverse numerator and denominator.
*              r and a must not overlap.
*
* Arguments:   r: numerator; den: denominator; a: factor; zeta: root times R.
*
* Returns:     NTRUPLUS_FAILURE for a zero denominator; NTRUPLUS_SUCCESS otherwise.
**************************************************/
static inline int baseinv_1(int16_t r[NTRUPLUS_D], int16_t den[1], const int16_t a[NTRUPLUS_D], const int16_t zeta)
{
    int16_t t0, t1, t2;

    t0 = montgomery_reduce(a[2]*a[2] - 2*a[1]*a[3]);
    t1 = montgomery_reduce(a[3]*a[3]);
    t0 = montgomery_reduce(a[0]*a[0] + t0*zeta);
    t1 = montgomery_reduce(a[1]*a[1] + t1*zeta - 2*a[0]*a[2]);
    t2 = montgomery_reduce(t1*zeta);

    den[0] = montgomery_reduce(t0*t0 - t1*t2);

    int fail = (den[0] == 0);
    ntruplus_declassify(&fail, sizeof fail);

    if (fail)
        return NTRUPLUS_FAILURE;

    r[0] = montgomery_reduce(a[0]*t0 + a[2]*t2);
    r[1] = montgomery_reduce(a[3]*t2 + a[1]*t0);
    r[2] = montgomery_reduce(a[2]*t0 + a[0]*t1);
    r[3] = montgomery_reduce(a[1]*t1 + a[3]*t0);

    return NTRUPLUS_SUCCESS;
}

/*************************************************
* Name:        baseinv_2
*
* Description: Scale the quartic numerator and negate odd coefficients.
*
* Arguments:   r: numerator in/out; den: inverted denominator.
*
* Returns:     none.
**************************************************/
static inline void baseinv_2(int16_t r[NTRUPLUS_D], const int16_t den)
{
    r[0] =  montgomery_reduce(r[0]*den);
    r[1] = -montgomery_reduce(r[1]*den);
    r[2] =  montgomery_reduce(r[2]*den);
    r[3] = -montgomery_reduce(r[3]*den);
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Invert a polynomial in the NTT domain and clear r on failure.
*              r and a must not overlap.
*
* Arguments:   - poly *r: output inverse
*              - const poly *a: input polynomial
*
* Returns:     NTRUPLUS_SUCCESS on success; NTRUPLUS_FAILURE otherwise.
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
    int16_t den[NTRUPLUS_N/NTRUPLUS_D];

    for (size_t i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); i++)
    {
        const size_t  i0   = 2*NTRUPLUS_D*i;
        const size_t  i1   = i0+NTRUPLUS_D;
        const int16_t zeta = zetas[NTRUPLUS_ZETAMUL_IDX+i];

        if (baseinv_1(r->coeffs+i0, den+2*i,   a->coeffs+i0,  zeta) ||
            baseinv_1(r->coeffs+i1, den+2*i+1, a->coeffs+i1, -zeta))
        {
            poly_clear(r);
            i16_clear(den, NTRUPLUS_N/NTRUPLUS_D);
            return NTRUPLUS_FAILURE;
        }
    }

    fqinv_batch(den);
    for (size_t i = 0; i < NTRUPLUS_N/NTRUPLUS_D; i++)
        baseinv_2(r->coeffs+NTRUPLUS_D*i, den[i]);

    i16_clear(den, NTRUPLUS_N/NTRUPLUS_D);
    return NTRUPLUS_SUCCESS;
}

/*************************************************
* Name:        basemul_raw
*
* Description: Multiply modulo X^4-zeta, returning coefficients scaled by R^-1.
*
* Arguments:   r: output; a, b: factors; zeta: root times R.
*
* Returns:     none.
**************************************************/
static inline void basemul_raw(int16_t r[NTRUPLUS_D], const int16_t a[NTRUPLUS_D], const int16_t b[NTRUPLUS_D], const int16_t zeta)
{
    int16_t c0, c1, c2, c3;

    c0 = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]);
    c1 = montgomery_reduce(a[2]*b[3] + a[3]*b[2]);
    c2 = montgomery_reduce(a[3]*b[3]);

    c0 = montgomery_reduce(c0*zeta + a[0]*b[0]);
    c1 = montgomery_reduce(c1*zeta + a[0]*b[1] + a[1]*b[0]);
    c2 = montgomery_reduce(c2*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]);
    c3 = montgomery_reduce(a[0]*b[3] + a[1]*b[2] + a[2]*b[1] + a[3]*b[0]);

    r[0] = c0;
    r[1] = c1;
    r[2] = c2;
    r[3] = c3;
}

/*************************************************
* Name:        poly_basemul_raw
*
* Description: Multiply NTT-domain polynomials with R^-1-scaled output.
*
* Arguments:   - poly *r: output; may alias a or b
*              - const poly *a: first factor
*              - const poly *b: second factor
*
* Returns:     none.
**************************************************/
static inline void poly_basemul_raw(poly *r, const poly *a, const poly *b)
{
    for (size_t i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); i++)
    {
        const size_t  i0   = 2*NTRUPLUS_D*i;
        const size_t  i1   = i0+NTRUPLUS_D;
        const int16_t zeta = zetas[NTRUPLUS_ZETAMUL_IDX+i];

        basemul_raw(r->coeffs+i0, a->coeffs+i0, b->coeffs+i0,  zeta);
        basemul_raw(r->coeffs+i1, a->coeffs+i1, b->coeffs+i1, -zeta);
    }
}

/*************************************************
* Name:        poly_basemul_scaled
*
* Description: Multiply NTT-domain polynomials with R^-1-scaled output.
*
* Arguments:   - poly *r: output; may alias a or b
*              - const poly *a: first factor
*              - const poly *b: second factor
*
* Returns:     none.
**************************************************/
void poly_basemul_scaled(poly *r, const poly *a, const poly *b)
{
    poly_basemul_raw(r, a, b);
}

/*************************************************
* Name:        poly_basemul
*
* Description: Multiply two NTT-domain polynomials in ordinary coefficient scale.
*
* Arguments:   - poly *r: output polynomial
*              - const poly *a: first factor
*              - const poly *b: second factor
*
* Returns:     none.
**************************************************/
void poly_basemul(poly *r, const poly *a, const poly *b)
{
    poly_basemul_raw(r, a, b);

    for (size_t i = 0; i < NTRUPLUS_N; i++)
        r->coeffs[i] = fqmul(r->coeffs[i], NTRUPLUS_RSQ);
}

/*************************************************
* Name:        poly_basemul_add
*
* Description: Compute a*b+c in the NTT domain; r must not alias c.
*
* Arguments:   - poly *r: output polynomial
*              - const poly *a: first factor
*              - const poly *b: second factor
*              - const poly *c: added polynomial
*
* Returns:     none.
**************************************************/
void poly_basemul_add(poly *r, const poly *a, const poly *b, const poly *c)
{
    poly_basemul_raw(r, a, b);

    for (size_t i = 0; i < NTRUPLUS_N; i++)
        r->coeffs[i] = montgomery_reduce(c->coeffs[i]*NTRUPLUS_R + r->coeffs[i]*NTRUPLUS_RSQ);
}

/*************************************************
* Name:        poly_sub
*
* Description: Subtract two polynomials; no modular reduction is performed
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const poly *a: pointer to first input polynomial
*              - const poly *b: pointer to second input polynomial
*
* Returns:     none.
**************************************************/
void poly_sub(poly *r, const poly *a, const poly *b)
{
    for (size_t i = 0; i < NTRUPLUS_N; i++)
        r->coeffs[i] = a->coeffs[i] - b->coeffs[i];
}

/*************************************************
* Name:        poly_crepmod3
*
* Description: Apply centered reduction modulo 3.
*
* Arguments:   - poly *r: input in [-1728,1728], output in {-1,0,1}
*
* Returns:     none.
**************************************************/
void poly_crepmod3(poly *r)
{
    const int16_t v = ((1 << 15) + 3/2) / 3;

    for (size_t i = 0; i < NTRUPLUS_N; i++)
    {
        const int16_t t0 = r->coeffs[i];
        const int16_t t1 = ((int32_t)v*t0 + (1 << 14)) >> 15;

        r->coeffs[i] = t0 - 3*t1;
    }
}

/*************************************************
* Name:        poly_clear
*
* Description: Clear all polynomial coefficients through volatile stores.
*
* Arguments:   - poly *r: polynomial to clear
*
* Returns:     none.
**************************************************/
void poly_clear(poly *r)
{
    i16_clear(r->coeffs, NTRUPLUS_N);
}
