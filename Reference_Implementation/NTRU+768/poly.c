#include <stddef.h>
#include <stdint.h>
#include "api.h"
#include "params.h"
#include "poly.h"
#include "util.h"

#define NTRUPLUS_R     -147 //R = 2^16 mod q
#define NTRUPLUS_RSQ    867 //(R^2) mod q
#define NTRUPLUS_QINV 12929 //(q)^(-1) mod (2^16)

#define NTRUPLUS_RINV -682 //(R)^(-1) mod q

#define NTRUPLUS_OMEGA        -886 //(omega * R) mod q
#define NTRUPLUS_ZMINUSZ5INV -1665 //(z - z^5)^(-1) * R mod q
                                   //where z = zeta^((n/d)/6)

#define NTRUPLUS_ZETAMUL_IDX (NTRUPLUS_N/(2*NTRUPLUS_D))

#define NTRUPLUS_NINV  -811  //(n/d)^(-1) * R mod q
#define NTRUPLUS_2NINV -1622 //2 * (n/d)^(-1) * R mod q

#define NTRUPLUS_RADIX2_START (16*NTRUPLUS_D)
#define NTRUPLUS_RADIX3_END   (NTRUPLUS_N/6)

// zetas: Montgomery-form twiddle factors
static const int16_t zetas[NTRUPLUS_N/NTRUPLUS_D] = {
     -147, -1033,  -682,  -248,  -708,   682,     1,  -722,
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
    uint8_t tmp[NTRUPLUS_N/4];

    for (size_t i = 0; i < NTRUPLUS_N/8; i++)
        tmp[i] = buf[i] ^ msg[i];

    for (size_t i = NTRUPLUS_N/8; i < NTRUPLUS_N/4; i++)
        tmp[i] = buf[i];

    poly_cbd1(r, tmp);
    u8_clear(tmp, sizeof tmp);
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
*              Input coefficients are in (-q,q); output is in [-1728,1728].
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
            const int16_t t = fqmul(zeta, a[i+NTRUPLUS_N/2]);

            a[i+NTRUPLUS_N/2] = barrett_reduce(a[i] + a[i+NTRUPLUS_N/2] - t);
            a[i]              = barrett_reduce(a[i] + t);
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

                a[i+2*step] = barrett_reduce(a[i] - t0 - t2);
                a[i+step]   = barrett_reduce(a[i] - t1 + t2);
                a[i]        = barrett_reduce(a[i] + t0 + t1);
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

                a[i+step] = barrett_reduce(a[i] - t);
                a[i]      = barrett_reduce(a[i] + t);
            }
        }
    }
}

/*************************************************
* Name:        poly_invntt
*
* Description: Compute the inverse NTT to ordinary coefficients.
*              Input is in ordinary NTT-domain scale.
*
* Arguments:   - poly *r: input/output polynomial
*
* Returns:     none.
**************************************************/
void poly_invntt(poly *r)
{
    int16_t *a = r->coeffs;
    size_t   k = NTRUPLUS_N/NTRUPLUS_D-1;

    for (size_t step = NTRUPLUS_D; step <= NTRUPLUS_RADIX2_START; step <<= 1)
    {
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

    for (size_t step = NTRUPLUS_RADIX3_END; step <= NTRUPLUS_N/6; step = 3*step)
    {
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

    for (size_t i = 0; i < NTRUPLUS_N/2; i++)
    {
        const int16_t t0 = barrett_reduce(a[i] + a[i+NTRUPLUS_N/2]);
        const int16_t t1 = fqmul(NTRUPLUS_ZMINUSZ5INV, a[i] - a[i+NTRUPLUS_N/2]);

        a[i]              = fqmul(NTRUPLUS_NINV, t0 - t1);
        a[i+NTRUPLUS_N/2] = fqmul(NTRUPLUS_2NINV, t1);
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

    t0 = fqmul(a, a);   //10
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

    return fqmul(NTRUPLUS_RINV, t0);
}

/*************************************************
* Name:        baseinv
*
* Description: Inversion of a polynomial in Zq[X]/(X^4 - zeta), used as
*              a building block for inversion of elements in R_q in the
*              NTT domain.
*              Output must not overlap the input.
*
* Arguments:   - int16_t r[4]: pointer to the output polynomial
*              - const int16_t a[4]: pointer to the input polynomial
*              - const int16_t zeta: parameter defining X^4 - zeta
*
* Returns:     0 if a is invertible, 1 otherwise.
**************************************************/
static inline int baseinv(int16_t r[NTRUPLUS_D], const int16_t a[NTRUPLUS_D], const int16_t zeta)
{
    int16_t t0, t1, t2, t3;

    t0 = montgomery_reduce(a[2]*a[2] - 2*a[1]*a[3]);           //R^-1
    t1 = montgomery_reduce(a[3]*a[3]);                         //R^-1
    t0 = montgomery_reduce(a[0]*a[0] + t0*zeta);               //R^-1
    t1 = montgomery_reduce(a[1]*a[1] + t1*zeta - 2*a[0]*a[2]); //R^-1
    t2 = montgomery_reduce(t1*zeta);                           //R^-1

    t3 = montgomery_reduce(t0*t0 - t1*t2); //R^-3

    if (t3 == 0) return NTRUPLUS_FAILURE;

    r[0] = montgomery_reduce(a[0]*t0 + a[2]*t2); //R^-2
    r[1] = montgomery_reduce(a[3]*t2 + a[1]*t0); //R^-2
    r[2] = montgomery_reduce(a[2]*t0 + a[0]*t1); //R^-2
    r[3] = montgomery_reduce(a[1]*t1 + a[3]*t0); //R^-2

    t3 = fqinv(t3); //R^5

    r[0] =  montgomery_reduce(r[0]*t3); //R^0
    r[1] = -montgomery_reduce(r[1]*t3); //R^0
    r[2] =  montgomery_reduce(r[2]*t3); //R^0
    r[3] = -montgomery_reduce(r[3]*t3); //R^0

    return NTRUPLUS_SUCCESS;
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
    for (size_t i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); ++i)
    {
        const size_t  i0   = 2*NTRUPLUS_D*i;
        const size_t  i1   = i0+NTRUPLUS_D;
        const int16_t zeta = zetas[NTRUPLUS_ZETAMUL_IDX+i];

        if (baseinv(r->coeffs+i0, a->coeffs+i0,  zeta))
        {
            poly_clear(r);

            return NTRUPLUS_FAILURE;
        }

        if (baseinv(r->coeffs+i1, a->coeffs+i1, -zeta))
        {
            poly_clear(r);

            return NTRUPLUS_FAILURE;
        }
    }

    return NTRUPLUS_SUCCESS;
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^4 - zeta),
*              used for multiplication of elements in R_q in the NTT domain.
*              Output must not overlap the inputs.
*
* Arguments:   - int16_t r[4]: pointer to the output polynomial
*              - const int16_t a[4]: pointer to the first factor
*              - const int16_t b[4]: pointer to the second factor
*              - const int16_t zeta: parameter defining X^4 - zeta
*
* Returns:     none.
**************************************************/
static inline void basemul(int16_t r[NTRUPLUS_D], const int16_t a[NTRUPLUS_D], const int16_t b[NTRUPLUS_D], const int16_t zeta)
{
    int16_t t0 = montgomery_reduce(a[1]*b[3]+a[2]*b[2]+a[3]*b[1]); //R^-1
    int16_t t1 = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);           //R^-1
    int16_t t2 = montgomery_reduce(a[3]*b[3]);                     //R^-1

    int16_t c0 = montgomery_reduce(t0*zeta+a[0]*b[0]);                       //R^-1
    int16_t c1 = montgomery_reduce(t1*zeta+a[0]*b[1]+a[1]*b[0]);             //R^-1
    int16_t c2 = montgomery_reduce(t2*zeta+a[0]*b[2]+a[1]*b[1]+a[2]*b[0]);   //R^-1
    int16_t c3 = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]); //R^-1

    r[0] = montgomery_reduce(c0*NTRUPLUS_RSQ); //R^0
    r[1] = montgomery_reduce(c1*NTRUPLUS_RSQ); //R^0
    r[2] = montgomery_reduce(c2*NTRUPLUS_RSQ); //R^0
    r[3] = montgomery_reduce(c3*NTRUPLUS_RSQ); //R^0
}

/*************************************************
* Name:        poly_basemul
*
* Description: Multiply two NTT-domain polynomials in ordinary coefficient scale.
*              Output must not overlap the inputs.
*
* Arguments:   - poly *r: output polynomial
*              - const poly *a: first factor
*              - const poly *b: second factor
*
* Returns:     none.
**************************************************/
void poly_basemul(poly *r, const poly *a, const poly *b)
{
    for (size_t i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); i++)
    {
        const size_t  i0   = 2*NTRUPLUS_D*i;
        const size_t  i1   = i0+NTRUPLUS_D;
        const int16_t zeta = zetas[NTRUPLUS_ZETAMUL_IDX+i];

        basemul(r->coeffs+i0, a->coeffs+i0, b->coeffs+i0,  zeta);
        basemul(r->coeffs+i1, a->coeffs+i1, b->coeffs+i1, -zeta);
    }
}

/*************************************************
* Name:        poly_add
*
* Description: Add two polynomials and reduce coefficients modulo q.
*
* Arguments:   - poly *r: output polynomial
*              - const poly *a: first input polynomial
*              - const poly *b: second input polynomial
*
* Returns:     none.
**************************************************/
void poly_add(poly *r, const poly *a, const poly *b)
{
    for (size_t i = 0; i < NTRUPLUS_N; i++)
        r->coeffs[i] = barrett_reduce(a->coeffs[i] + b->coeffs[i]);
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
* Name:        poly_triple
*
* Description: Multiply polynomial coefficients by three without modular reduction.
*
* Arguments:   - poly *r: input/output polynomial
*
* Returns:     none.
**************************************************/
void poly_triple(poly *r)
{
    for (int i = 0; i < NTRUPLUS_N; ++i)
        r->coeffs[i] *= 3;
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
