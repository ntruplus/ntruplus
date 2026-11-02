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

#define NTRUPLUS_NINV_SCALED  -33 //(n/d)^(-1) * R^2 mod q
#define NTRUPLUS_2NINV_SCALED -66 //2 * (n/d)^(-1) * R^2 mod q

#define NTRUPLUS_RADIX2_START (8*NTRUPLUS_D)
#define NTRUPLUS_RADIX3_END   (16*NTRUPLUS_D)

// zetas: Montgomery-form twiddle factors
// zetas[1] is unscaled.
static const int16_t zetas[NTRUPLUS_N/NTRUPLUS_D] = {
     -147,  -722, -1265,   708,   460,  1265,  -467,   727,
      556,  1307,  -773,  -161,  1200, -1612,   570,  1529,
     1135,  -556,  1120,   298,  -822, -1556,   -93,  1463,
      532,  -377,  -909,    58,  -392,  -450,  1722,  1236,
     -486,  -491, -1569, -1078,    36,  1289, -1443,  1628,
     1664,  -725,  -952,    99, -1020,   353,  -599,  1119,
      592,   839,  1622,   652,  1244,  -783, -1085,  -726,
      566,  -284, -1369, -1292,   268,  -391,   781,  -172,
       96, -1172,   211,   737,   473,  -445,  -234,   264,
    -1536,  1467,  -676, -1542,  -170,   635,  -705, -1332,
     -658,   831, -1712,  1311,  1488,  -881,  1087, -1315,
     1245,   -75,   791,    -6,  -875,  -697,   -70, -1162,
      287,  -767,  -945,  1598,  -882,  1261,   206,   654,
    -1421,   -81,   716, -1251,   838, -1300,  1035,  -104,
      966,  -558,   -61, -1704,   404,  -899,   862, -1593,
    -1460,   -37,  1266,   965, -1584, -1404,  -265,  -942,
      905,  1195,  -619,   787,   118,   576,   286, -1475,
     -194,   928,  1229, -1032,  1608,  1111, -1669,   642,
    -1323,   163,   309,   981,  -557,  -258,   232, -1680,
    -1657, -1233,   144,  1699,   311, -1060,   578,  1298,
     -403,  1607,  1074,  -148,   447, -1568,  1142,  -402,
    -1412,  -623,   855,   365,   -98,  -244,   407,  1225,
      416,   683,  -105,  1714, -1019,  1061,  1163,   638,
      798,  1493,  -351,   396,  -542,    -9,  1616,  -139,
     -987,  -482,   889,   238, -1513,   466, -1089,  -101,
      849,  -426,  1589,  1487,   671,  1459,  -776,   255,
    -1014,  1144,   472, -1153,  -325,  1519,   -26, -1123,
      324,  1230,  1547,  -593,  -428,  1192,  1072, -1564,
      688,  -333,  1023, -1686,   841,   824,   -71,  1587,
      522,  -323,  1148,   389,  1231,   384,  1343,   169,
      628, -1329, -1056,  -936,    24,  -293,  1523,  -300,
    -1654,   891,  -962,   -67,   179, -1177,   844,  -509,
    -1677, -1565,  -549, -1508,  1191,  -280,   -43,   669,
     -746,   753,   770, -1046,  1711,  1438,   690,  1083,
     1062,  1727,  -883,   553,  1670,    66,   825,  -133,
    -1586,   637,  -680,  -917,   644,  -372, -1193, -1136
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
        const size_t step = NTRUPLUS_RADIX3_END;

        for (size_t start = 0; start < NTRUPLUS_N; start += 3*step)
        {
            const int16_t zeta1 = zetas[k--];
            const int16_t zeta0 = zetas[k--];

            for (size_t i = start; i < start+step; i++)
            {
                const int16_t t0 = fqmul(NTRUPLUS_OMEGA, a[i+step] - a[i]);
                const int16_t t1 = fqmul(zeta0, a[i+2*step] - a[i] + t0);
                const int16_t t2 = fqmul(zeta1, a[i+2*step] - a[i+step] - t0);

                a[i]        = barrett_reduce(a[i] + a[i+step] + a[i+2*step]);
                a[i+step]   = t1;
                a[i+2*step] = t2;
            }
        }
    }

    {
        const size_t step = NTRUPLUS_N/6;

        for (size_t start = 0; start < NTRUPLUS_N; start += 3*step)
        {
            const int16_t zeta1 = zetas[k--];
            const int16_t zeta0 = zetas[k--];

            for (size_t i = start; i < start+step; i++)
            {
                const int16_t t0 = fqmul(NTRUPLUS_OMEGA, a[i+step] - a[i]);
                const int16_t t1 = fqmul(zeta0, a[i+2*step] - a[i] + t0);
                const int16_t t2 = fqmul(zeta1, a[i+2*step] - a[i+step] - t0);

                a[i]        = a[i] + a[i+step] + a[i+2*step];
                a[i+step]   = t1;
                a[i+2*step] = t2;
            }
        }
    }

    for (size_t i = 0; i < NTRUPLUS_N/2; i++)
    {
        const int16_t t0 = a[i] + a[i+NTRUPLUS_N/2];
        const int16_t t1 = fqmul(NTRUPLUS_ZMINUSZ5INV, a[i] - a[i+NTRUPLUS_N/2]);

        a[i]              = fqmul(NTRUPLUS_NINV_SCALED, t0 - t1);
        a[i+NTRUPLUS_N/2] = fqmul(NTRUPLUS_2NINV_SCALED, t1);
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
* Description: Apply centered reduction modulo q and then modulo 3.
*
* Arguments:   - poly *r: input/output in [-(q-1),q-1]
*
* Returns:     none.
**************************************************/
void poly_crepmod3(poly *r)
{
    const int16_t v = ((1 << 15) + 3/2) / 3;

    for (size_t i = 0; i < NTRUPLUS_N; i++)
    {
        int16_t t0 = r->coeffs[i];
        int16_t t1;

        t0 += (t0 >> 15) & NTRUPLUS_Q;
        t0 -= (NTRUPLUS_Q+1)/2;
        t0 += (t0 >> 15) & NTRUPLUS_Q;
        t0 -= (NTRUPLUS_Q-1)/2;

        t1 = ((int32_t)v*t0 + (1 << 14)) >> 15;
        t1 *= 3;

        r->coeffs[i] = t0 - t1;
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
