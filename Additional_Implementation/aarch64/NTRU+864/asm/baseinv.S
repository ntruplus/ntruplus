#include "asm.h"

/*
 * References:
 *
 * [BHK+21] Hanno Becker, Vincent Hwang, Matthias J. Kannwischer,
 * Bo-Yin Yang, and Shang-Yi Yang,
 * "Neon NTT: Faster Dilithium, Kyber, and Saber
 * on Cortex-A72 and Apple M1", IACR Transactions on Cryptographic
 * Hardware and Embedded Systems, 2022(1), pp. 221-244.
 * https://doi.org/10.46586/tches.v2022.i1.221-244
 * Barrett multiplication (Algorithm 10) and accumulated Montgomery
 * reduction (Algorithm 14) are used below.
 */

.macro load_address dst, sym, offset=0
#ifdef __APPLE__
adrp \dst, _\sym+\offset@PAGE
add \dst, \dst, _\sym+\offset@PAGEOFF
#else
adrp \dst, \sym+\offset
add \dst, \dst, :lo12:\sym+\offset
#endif
.endm

/*************************************************
* Name:        poly_baseinv_1
*
* Description: Computes the base-inverse numerators and their denominators.
*              The denominators are batch-inverted and applied by
*              poly_baseinv_2.
*
* Arguments:   - poly *r:        pointer to the numerator output polynomial
*              - int16x8_t *den: pointer to the denominator output vectors
*              - const poly *a:  pointer to the input polynomial;
*                                coefficients must lie in [-q+1,q-1]
*
* Returns:     none. Numerators and denominators lie in (-q,q), with
*              factors R^-1 and R^-2 respectively, where R = 2^16.
**************************************************/
NTRUPLUS_ASM_START(poly_baseinv_1)

dst       .req x0
den       .req x1
src       .req x2
zetas_ptr .req x3
counter   .req x8

load_address zetas_ptr, NTRUPLUS_NAMESPACE(consts_base)
ld1 {v0.8h}, [zetas_ptr]

load_address zetas_ptr, NTRUPLUS_NAMESPACE(zetas), ZETAS_MUL_OFFSET

mov counter, #1728

NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair):
ldp q1, q2, [zetas_ptr], #64

NTRUPLUS_ASM_LOCAL(looptop_baseinv_1):
ld1 {v3.8h - v5.8h}, [src], #48

/*
 * Barrett multiplication: Algorithm 10 of [BHK+21].
 * t0 = zeta*a1, t1 = zeta*a2; |t0|,|t1| <= 1904.
 */
mul v6.8h, v4.8h, v1.8h
mul v7.8h, v5.8h, v1.8h

sqrdmulh v22.8h, v4.8h, v2.8h
sqrdmulh v23.8h, v5.8h, v2.8h

mls v6.8h, v22.8h, v0.h[0]
mls v7.8h, v23.8h, v0.h[0]

/*
 * Widened products: Algorithm 14 of [BHK+21].
 * |num0|,|num1| <= 2011; |num2| <= 2093.
 * Corrected wide accumulators have magnitude <= 137166848.
 */
smull  v16.4s, v3.4h, v3.4h //a0*a0
smull2 v17.4s, v3.8h, v3.8h //a0*a0
smull  v18.4s, v5.4h, v7.4h //a2*t1
smull2 v19.4s, v5.8h, v7.8h //a2*t1
smull  v20.4s, v4.4h, v4.4h //a1*a1
smull2 v21.4s, v4.8h, v4.8h //a1*a1

smlsl  v16.4s, v4.4h, v7.4h //-a1*t1
smlsl2 v17.4s, v4.8h, v7.8h //-a1*t1
smlsl  v18.4s, v3.4h, v4.4h //-a0*a1
smlsl2 v19.4s, v3.8h, v4.8h //-a0*a1
smlsl  v20.4s, v3.4h, v5.4h //-a0*a2
smlsl2 v21.4s, v3.8h, v5.8h //-a0*a2

uzp1 v22.8h, v16.8h, v17.8h
uzp1 v23.8h, v18.8h, v19.8h
uzp1 v24.8h, v20.8h, v21.8h

mul v22.8h, v22.8h, v0.h[2]
mul v23.8h, v23.8h, v0.h[2]
mul v24.8h, v24.8h, v0.h[2]

smlal  v16.4s, v22.4h, v0.h[0]
smlal2 v17.4s, v22.8h, v0.h[0]
smlal  v18.4s, v23.4h, v0.h[0]
smlal2 v19.4s, v23.8h, v0.h[0]
smlal  v20.4s, v24.4h, v0.h[0]
smlal2 v21.4s, v24.8h, v0.h[0]

uzp2 v25.8h, v16.8h, v17.8h //num0
uzp2 v26.8h, v18.8h, v19.8h //num1
uzp2 v27.8h, v20.8h, v21.8h //num2

/* Algorithm 14 of [BHK+21]: det in the original R^-2 scale. */
smull  v16.4s, v25.4h, v3.4h //num0*a0
smull2 v17.4s, v25.8h, v3.8h //num0*a0

smlal  v16.4s, v26.4h, v7.4h //num1*t1
smlal2 v17.4s, v26.8h, v7.8h //num1*t1
smlal  v16.4s, v27.4h, v6.4h //num2*t0
smlal2 v17.4s, v27.8h, v6.8h //num2*t0

uzp1 v22.8h, v16.8h, v17.8h

mul v22.8h, v22.8h, v0.h[2]

smlal  v16.4s, v22.4h, v0.h[0]
smlal2 v17.4s, v22.8h, v0.h[0]

uzp2 v28.8h, v16.8h, v17.8h //det

st1 {v28.8h}, [den], #16

st1 {v25.8h - v27.8h}, [dst], #48
subs counter, counter, #48
/* The public counter selects the +zeta/-zeta block order. */
tbz counter, #4, NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair_check)

/* Negate zeta and its Barrett factor to reuse them for the next -zeta block. */
neg v1.8h, v1.8h
neg v2.8h, v2.8h
b NTRUPLUS_ASM_LOCAL(looptop_baseinv_1)

NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair_check):
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair)

.unreq dst
.unreq den
.unreq src
.unreq zetas_ptr
.unreq counter

ret
NTRUPLUS_ASM_END(poly_baseinv_1)


NTRUPLUS_ASM_GNU_STACK
