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

/*************************************************
* Name:        poly_basemul
*
* Description: Multiplication of two polynomials in the NTT domain.
*
* Arguments:   - poly *r:       pointer to the output polynomial
*              - const poly *a: pointer to the first input polynomial;
*                               coefficients must lie in (-2q,2q)
*              - const poly *b: pointer to the second input polynomial;
*                               coefficients must lie in (-2q,2q)
*
* Returns:     none. Output coefficients lie in (-3q/2,3q/2) and are
*              reduced by poly_tobytes before serialization.
**************************************************/
NTRUPLUS_ASM_START(poly_basemul)

dst       .req x0
src1      .req x1
src2      .req x2
zetas_ptr .req x3
counter   .req x8

NTRUPLUS_ASM_LOAD_ADDRESS(zetas_ptr, consts_base, 0)
ld1 {v0.8h}, [zetas_ptr]

NTRUPLUS_ASM_LOAD_ADDRESS(zetas_ptr, zetas, ZETAS_MUL_OFFSET)

mov counter, #1536

NTRUPLUS_ASM_LOCAL(looptop_pair):
ldp q1, q2, [zetas_ptr], #64

NTRUPLUS_ASM_LOCAL(looptop):
/* Read both inputs before storing either output half. */
ld1 { v4.8h -  v7.8h}, [src1], #64
ld1 {v16.8h - v19.8h}, [src2], #64

/*
 * Barrett multiplication: Algorithm 10 of [BHK+21].
 * v20 = zeta*b1, v21 = zeta*b2, v22 = zeta*b3, with no R factor.
 * |Barrett product| <= 2085; |corrected accumulator| <= 304437252.
 */
mul v20.8h, v17.8h, v1.8h
mul v21.8h, v18.8h, v1.8h
mul v22.8h, v19.8h, v1.8h

sqrdmulh v27.8h, v17.8h, v2.8h
sqrdmulh v28.8h, v18.8h, v2.8h
sqrdmulh v29.8h, v19.8h, v2.8h

mls v20.8h, v27.8h, v0.h[0]
mls v21.8h, v28.8h, v0.h[0]
mls v22.8h, v29.8h, v0.h[0]

/* Accumulate all four outputs before reducing. */
smull  v23.4s, v4.4h, v16.4h
smull2 v24.4s, v4.8h, v16.8h
smull  v25.4s, v4.4h, v17.4h
smull2 v26.4s, v4.8h, v17.8h
smull  v27.4s, v4.4h, v18.4h
smull2 v28.4s, v4.8h, v18.8h
smull  v29.4s, v4.4h, v19.4h
smull2 v30.4s, v4.8h, v19.8h

smlal  v23.4s, v5.4h, v22.4h
smlal2 v24.4s, v5.8h, v22.8h
smlal  v25.4s, v5.4h, v16.4h
smlal2 v26.4s, v5.8h, v16.8h
smlal  v27.4s, v5.4h, v17.4h
smlal2 v28.4s, v5.8h, v17.8h
smlal  v29.4s, v5.4h, v18.4h
smlal2 v30.4s, v5.8h, v18.8h

smlal  v23.4s, v6.4h, v21.4h
smlal2 v24.4s, v6.8h, v21.8h
smlal  v25.4s, v6.4h, v22.4h
smlal2 v26.4s, v6.8h, v22.8h
smlal  v27.4s, v6.4h, v16.4h
smlal2 v28.4s, v6.8h, v16.8h
smlal  v29.4s, v6.4h, v17.4h
smlal2 v30.4s, v6.8h, v17.8h

smlal  v23.4s, v7.4h, v20.4h
smlal2 v24.4s, v7.8h, v20.8h
smlal  v25.4s, v7.4h, v21.4h
smlal2 v26.4s, v7.8h, v21.8h
smlal  v27.4s, v7.4h, v22.4h
smlal2 v28.4s, v7.8h, v22.8h
smlal  v29.4s, v7.4h, v16.4h
smlal2 v30.4s, v7.8h, v16.8h

/* Montgomery reduction, once per output. */
uzp1 v16.8h, v23.8h, v24.8h
uzp1 v17.8h, v25.8h, v26.8h
uzp1 v18.8h, v27.8h, v28.8h
uzp1 v19.8h, v29.8h, v30.8h

mul v16.8h, v16.8h, v0.h[2]
mul v17.8h, v17.8h, v0.h[2]
mul v18.8h, v18.8h, v0.h[2]
mul v19.8h, v19.8h, v0.h[2]

smlal  v23.4s, v16.4h, v0.h[0]
smlal2 v24.4s, v16.8h, v0.h[0]
smlal  v25.4s, v17.4h, v0.h[0]
smlal2 v26.4s, v17.8h, v0.h[0]
smlal  v27.4s, v18.4h, v0.h[0]
smlal2 v28.4s, v18.8h, v0.h[0]
smlal  v29.4s, v19.4h, v0.h[0]
smlal2 v30.4s, v19.8h, v0.h[0]

uzp2 v4.8h, v23.8h, v24.8h
uzp2 v5.8h, v25.8h, v26.8h
uzp2 v6.8h, v27.8h, v28.8h
uzp2 v7.8h, v29.8h, v30.8h

/* Barrett multiplication by R. */
mul v16.8h, v4.8h, v0.h[3]
mul v17.8h, v5.8h, v0.h[3]
mul v18.8h, v6.8h, v0.h[3]
mul v19.8h, v7.8h, v0.h[3]

sqrdmulh v4.8h, v4.8h, v0.h[4]
sqrdmulh v5.8h, v5.8h, v0.h[4]
sqrdmulh v6.8h, v6.8h, v0.h[4]
sqrdmulh v7.8h, v7.8h, v0.h[4]

mls v16.8h, v4.8h, v0.h[0]
mls v17.8h, v5.8h, v0.h[0]
mls v18.8h, v6.8h, v0.h[0]
mls v19.8h, v7.8h, v0.h[0]

st1 {v16.8h - v19.8h}, [dst], #64

subs counter, counter, #64
/* The public counter selects the +zeta/-zeta block order. */
tbz counter, #6, NTRUPLUS_ASM_LOCAL(looptop_pair_check)

/* Negate zeta and its Barrett factor to reuse them for the next -zeta block. */
neg v1.8h, v1.8h
neg v2.8h, v2.8h
b NTRUPLUS_ASM_LOCAL(looptop)

NTRUPLUS_ASM_LOCAL(looptop_pair_check):
b.ne NTRUPLUS_ASM_LOCAL(looptop_pair)

.unreq dst
.unreq src1
.unreq src2
.unreq zetas_ptr
.unreq counter

ret
NTRUPLUS_ASM_END(poly_basemul)


/*************************************************
* Name:        poly_basemul_scaled
*
* Description: Multiplication of two polynomials in the NTT domain while
*              retaining the R^-1 representation for poly_invntt_scaled.
*
* Arguments:   - poly *r:       pointer to the output polynomial
*              - const poly *a: pointer to the first input polynomial;
*                               coefficients must lie in [-q+1,q-1]
*              - const poly *b: pointer to the second input polynomial;
*                               coefficients must lie in [-q+1,q-1]
*
* Returns:     none. Output coefficients lie in [-q+1,q-1] in the
*              R^-1 representation.
**************************************************/
NTRUPLUS_ASM_START(poly_basemul_scaled)

dst       .req x0
src1      .req x1
src2      .req x2
zetas_ptr .req x3
counter   .req x8

NTRUPLUS_ASM_LOAD_ADDRESS(zetas_ptr, consts_base, 0)
ld1 {v0.8h}, [zetas_ptr]

NTRUPLUS_ASM_LOAD_ADDRESS(zetas_ptr, zetas, ZETAS_MUL_OFFSET)

mov counter, #1536

NTRUPLUS_ASM_LOCAL(looptop_scaled_pair):
ldp q1, q2, [zetas_ptr], #64

NTRUPLUS_ASM_LOCAL(looptop_scaled):
/* Read both inputs before storing either output half. */
ld1 { v4.8h -  v7.8h}, [src1], #64
ld1 {v16.8h - v19.8h}, [src2], #64

/*
 * Barrett multiplication: Algorithm 10 of [BHK+21].
 * v20 = zeta*b1, v21 = zeta*b2, v22 = zeta*b3, with no R factor.
 * |Barrett product| <= 1899; |corrected accumulator| <= 161054720.
 */
mul v20.8h, v17.8h, v1.8h
mul v21.8h, v18.8h, v1.8h
mul v22.8h, v19.8h, v1.8h

sqrdmulh v27.8h, v17.8h, v2.8h
sqrdmulh v28.8h, v18.8h, v2.8h
sqrdmulh v29.8h, v19.8h, v2.8h

mls v20.8h, v27.8h, v0.h[0]
mls v21.8h, v28.8h, v0.h[0]
mls v22.8h, v29.8h, v0.h[0]

/* Accumulate all four outputs before reducing. */
smull  v23.4s, v4.4h, v16.4h
smull2 v24.4s, v4.8h, v16.8h
smull  v25.4s, v4.4h, v17.4h
smull2 v26.4s, v4.8h, v17.8h
smull  v27.4s, v4.4h, v18.4h
smull2 v28.4s, v4.8h, v18.8h
smull  v29.4s, v4.4h, v19.4h
smull2 v30.4s, v4.8h, v19.8h

smlal  v23.4s, v5.4h, v22.4h
smlal2 v24.4s, v5.8h, v22.8h
smlal  v25.4s, v5.4h, v16.4h
smlal2 v26.4s, v5.8h, v16.8h
smlal  v27.4s, v5.4h, v17.4h
smlal2 v28.4s, v5.8h, v17.8h
smlal  v29.4s, v5.4h, v18.4h
smlal2 v30.4s, v5.8h, v18.8h

smlal  v23.4s, v6.4h, v21.4h
smlal2 v24.4s, v6.8h, v21.8h
smlal  v25.4s, v6.4h, v22.4h
smlal2 v26.4s, v6.8h, v22.8h
smlal  v27.4s, v6.4h, v16.4h
smlal2 v28.4s, v6.8h, v16.8h
smlal  v29.4s, v6.4h, v17.4h
smlal2 v30.4s, v6.8h, v17.8h

smlal  v23.4s, v7.4h, v20.4h
smlal2 v24.4s, v7.8h, v20.8h
smlal  v25.4s, v7.4h, v21.4h
smlal2 v26.4s, v7.8h, v21.8h
smlal  v27.4s, v7.4h, v22.4h
smlal2 v28.4s, v7.8h, v22.8h
smlal  v29.4s, v7.4h, v16.4h
smlal2 v30.4s, v7.8h, v16.8h

/* Montgomery reduction, once per output. */
uzp1 v16.8h, v23.8h, v24.8h
uzp1 v17.8h, v25.8h, v26.8h
uzp1 v18.8h, v27.8h, v28.8h
uzp1 v19.8h, v29.8h, v30.8h

mul v16.8h, v16.8h, v0.h[2]
mul v17.8h, v17.8h, v0.h[2]
mul v18.8h, v18.8h, v0.h[2]
mul v19.8h, v19.8h, v0.h[2]

smlal  v23.4s, v16.4h, v0.h[0]
smlal2 v24.4s, v16.8h, v0.h[0]
smlal  v25.4s, v17.4h, v0.h[0]
smlal2 v26.4s, v17.8h, v0.h[0]
smlal  v27.4s, v18.4h, v0.h[0]
smlal2 v28.4s, v18.8h, v0.h[0]
smlal  v29.4s, v19.4h, v0.h[0]
smlal2 v30.4s, v19.8h, v0.h[0]

uzp2 v4.8h, v23.8h, v24.8h
uzp2 v5.8h, v25.8h, v26.8h
uzp2 v6.8h, v27.8h, v28.8h
uzp2 v7.8h, v29.8h, v30.8h

st1 {v4.8h - v7.8h}, [dst], #64

subs counter, counter, #64
/* The public counter selects the +zeta/-zeta block order. */
tbz counter, #6, NTRUPLUS_ASM_LOCAL(looptop_scaled_pair_check)

/* Negate zeta and its Barrett factor to reuse them for the next -zeta block. */
neg v1.8h, v1.8h
neg v2.8h, v2.8h
b NTRUPLUS_ASM_LOCAL(looptop_scaled)

NTRUPLUS_ASM_LOCAL(looptop_scaled_pair_check):
b.ne NTRUPLUS_ASM_LOCAL(looptop_scaled_pair)

.unreq dst
.unreq src1
.unreq src2
.unreq zetas_ptr
.unreq counter

ret
NTRUPLUS_ASM_END(poly_basemul_scaled)


/*************************************************
* Name:        poly_basemul_add
*
* Description: Multiplication of two polynomials in the NTT domain followed
*              by addition of a third polynomial.
*
* Arguments:   - poly *r:       pointer to the output polynomial
*              - const poly *a: pointer to the first multiplicand;
*                               coefficients must lie in (-2q,2q)
*              - const poly *b: pointer to the second multiplicand;
*                               coefficients must lie in (-2q,2q)
*              - const poly *c: pointer to the polynomial to add;
*                               coefficients must lie in [-q+1,q-1]
*
* Returns:     none. Output coefficients lie in (-5q/2,5q/2) and are
*              reduced by poly_tobytes before serialization.
**************************************************/
NTRUPLUS_ASM_START(poly_basemul_add)

dst       .req x0
src1      .req x1
src2      .req x2
src3      .req x3
zetas_ptr .req x4
counter   .req x8

NTRUPLUS_ASM_LOAD_ADDRESS(zetas_ptr, consts_base, 0)
ld1 {v0.8h}, [zetas_ptr]

NTRUPLUS_ASM_LOAD_ADDRESS(zetas_ptr, zetas, ZETAS_MUL_OFFSET)

mov counter, #1536

NTRUPLUS_ASM_LOCAL(looptop_add_pair):
ldp q1, q2, [zetas_ptr], #64

NTRUPLUS_ASM_LOCAL(looptop_add):
/* Read both inputs before storing either output half. */
ld1 { v4.8h -  v7.8h}, [src1], #64
ld1 {v16.8h - v19.8h}, [src2], #64

/*
 * Barrett multiplication: Algorithm 10 of [BHK+21].
 * v20 = zeta*b1, v21 = zeta*b2, v22 = zeta*b3, with no R factor.
 * |Barrett product| <= 2085; |corrected accumulator| <= 304437252.
 */
mul v20.8h, v17.8h, v1.8h
mul v21.8h, v18.8h, v1.8h
mul v22.8h, v19.8h, v1.8h

sqrdmulh v27.8h, v17.8h, v2.8h
sqrdmulh v28.8h, v18.8h, v2.8h
sqrdmulh v29.8h, v19.8h, v2.8h

mls v20.8h, v27.8h, v0.h[0]
mls v21.8h, v28.8h, v0.h[0]
mls v22.8h, v29.8h, v0.h[0]

/* Accumulate all four outputs before reducing. */
smull  v23.4s, v4.4h, v16.4h
smull2 v24.4s, v4.8h, v16.8h
smull  v25.4s, v4.4h, v17.4h
smull2 v26.4s, v4.8h, v17.8h
smull  v27.4s, v4.4h, v18.4h
smull2 v28.4s, v4.8h, v18.8h
smull  v29.4s, v4.4h, v19.4h
smull2 v30.4s, v4.8h, v19.8h

smlal  v23.4s, v5.4h, v22.4h
smlal2 v24.4s, v5.8h, v22.8h
smlal  v25.4s, v5.4h, v16.4h
smlal2 v26.4s, v5.8h, v16.8h
smlal  v27.4s, v5.4h, v17.4h
smlal2 v28.4s, v5.8h, v17.8h
smlal  v29.4s, v5.4h, v18.4h
smlal2 v30.4s, v5.8h, v18.8h

smlal  v23.4s, v6.4h, v21.4h
smlal2 v24.4s, v6.8h, v21.8h
smlal  v25.4s, v6.4h, v22.4h
smlal2 v26.4s, v6.8h, v22.8h
smlal  v27.4s, v6.4h, v16.4h
smlal2 v28.4s, v6.8h, v16.8h
smlal  v29.4s, v6.4h, v17.4h
smlal2 v30.4s, v6.8h, v17.8h

smlal  v23.4s, v7.4h, v20.4h
smlal2 v24.4s, v7.8h, v20.8h
smlal  v25.4s, v7.4h, v21.4h
smlal2 v26.4s, v7.8h, v21.8h
smlal  v27.4s, v7.4h, v22.4h
smlal2 v28.4s, v7.8h, v22.8h
smlal  v29.4s, v7.4h, v16.4h
smlal2 v30.4s, v7.8h, v16.8h

/* Montgomery reduction, once per output. */
uzp1 v16.8h, v23.8h, v24.8h
uzp1 v17.8h, v25.8h, v26.8h
uzp1 v18.8h, v27.8h, v28.8h
uzp1 v19.8h, v29.8h, v30.8h

mul v16.8h, v16.8h, v0.h[2]
mul v17.8h, v17.8h, v0.h[2]
mul v18.8h, v18.8h, v0.h[2]
mul v19.8h, v19.8h, v0.h[2]

smlal  v23.4s, v16.4h, v0.h[0]
smlal2 v24.4s, v16.8h, v0.h[0]
smlal  v25.4s, v17.4h, v0.h[0]
smlal2 v26.4s, v17.8h, v0.h[0]
smlal  v27.4s, v18.4h, v0.h[0]
smlal2 v28.4s, v18.8h, v0.h[0]
smlal  v29.4s, v19.4h, v0.h[0]
smlal2 v30.4s, v19.8h, v0.h[0]

uzp2 v4.8h, v23.8h, v24.8h
uzp2 v5.8h, v25.8h, v26.8h
uzp2 v6.8h, v27.8h, v28.8h
uzp2 v7.8h, v29.8h, v30.8h

/* Barrett multiplication by R. */
mul v16.8h, v4.8h, v0.h[3]
mul v17.8h, v5.8h, v0.h[3]
mul v18.8h, v6.8h, v0.h[3]
mul v19.8h, v7.8h, v0.h[3]

sqrdmulh v4.8h, v4.8h, v0.h[4]
sqrdmulh v5.8h, v5.8h, v0.h[4]
sqrdmulh v6.8h, v6.8h, v0.h[4]
sqrdmulh v7.8h, v7.8h, v0.h[4]

mls v16.8h, v4.8h, v0.h[0]
mls v17.8h, v5.8h, v0.h[0]
mls v18.8h, v6.8h, v0.h[0]
mls v19.8h, v7.8h, v0.h[0]

ld1 {v4.8h - v7.8h}, [src3], #64

add v16.8h, v16.8h, v4.8h
add v17.8h, v17.8h, v5.8h
add v18.8h, v18.8h, v6.8h
add v19.8h, v19.8h, v7.8h

st1 {v16.8h - v19.8h}, [dst], #64

subs counter, counter, #64
/* The public counter selects the +zeta/-zeta block order. */
tbz counter, #6, NTRUPLUS_ASM_LOCAL(looptop_add_pair_check)

/* Negate zeta and its Barrett factor to reuse them for the next -zeta block. */
neg v1.8h, v1.8h
neg v2.8h, v2.8h
b NTRUPLUS_ASM_LOCAL(looptop_add)

NTRUPLUS_ASM_LOCAL(looptop_add_pair_check):
b.ne NTRUPLUS_ASM_LOCAL(looptop_add_pair)

.unreq dst
.unreq src1
.unreq src2
.unreq src3
.unreq zetas_ptr
.unreq counter

ret
NTRUPLUS_ASM_END(poly_basemul_add)


NTRUPLUS_ASM_GNU_STACK
