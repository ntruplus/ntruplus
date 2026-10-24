#include "consts.h"

/* References are listed in ntt.S. */

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
.global poly_basemul
.global _poly_basemul
poly_basemul:
_poly_basemul:

    dst       .req x0
    src1      .req x1
    src2      .req x2
    zetas_ptr .req x3
    counter   .req x8

    load_address zetas_ptr, consts_base

    ld1 {v0.8h}, [zetas_ptr]

    load_address zetas_ptr, zetas, ZETAS_MUL_OFFSET

    mov counter, #1536

_looptop_pair:
    ldp q1, q2, [zetas_ptr], #64

_looptop:
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

    /* Accumulate four products for each of output coefficients 0 and 1. */
    smull  v23.4s, v4.4h, v16.4h  //a0*b0
    smull2 v24.4s, v4.8h, v16.8h  //a0*b0
    smull  v25.4s, v4.4h, v17.4h  //a0*b1
    smull2 v26.4s, v4.8h, v17.8h  //a0*b1

    smlal  v23.4s, v5.4h, v22.4h  //a1*(zeta*b3)
    smlal2 v24.4s, v5.8h, v22.8h  //a1*(zeta*b3)
    smlal  v25.4s, v5.4h, v16.4h  //a1*b0
    smlal2 v26.4s, v5.8h, v16.8h  //a1*b0

    smlal  v23.4s, v6.4h, v21.4h  //a2*(zeta*b2)
    smlal2 v24.4s, v6.8h, v21.8h  //a2*(zeta*b2)
    smlal  v25.4s, v6.4h, v22.4h  //a2*(zeta*b3)
    smlal2 v26.4s, v6.8h, v22.8h  //a2*(zeta*b3)

    smlal  v23.4s, v7.4h, v20.4h  //a3*(zeta*b1)
    smlal2 v24.4s, v7.8h, v20.8h  //a3*(zeta*b1)
    smlal  v25.4s, v7.4h, v21.4h  //a3*(zeta*b2)
    smlal2 v26.4s, v7.8h, v21.8h  //a3*(zeta*b2)

    /* Montgomery reduction: Algorithm 14 of [BHK+21], once per output. */
    uzp1 v27.8h, v23.8h, v24.8h
    uzp1 v28.8h, v25.8h, v26.8h

    mul v27.8h, v27.8h, v0.h[2]
    mul v28.8h, v28.8h, v0.h[2]

    smlal  v23.4s, v27.4h, v0.h[0]
    smlal2 v24.4s, v27.8h, v0.h[0]
    smlal  v25.4s, v28.4h, v0.h[0]
    smlal2 v26.4s, v28.8h, v0.h[0]

    uzp2 v29.8h, v23.8h, v24.8h
    uzp2 v30.8h, v25.8h, v26.8h

    /* Barrett multiplication by R: Algorithm 10 of [BHK+21]. */
    mul v27.8h, v29.8h, v0.h[3]
    mul v28.8h, v30.8h, v0.h[3]

    sqrdmulh v29.8h, v29.8h, v0.h[4]
    sqrdmulh v30.8h, v30.8h, v0.h[4]

    mls v27.8h, v29.8h, v0.h[0]
    mls v28.8h, v30.8h, v0.h[0]

    st1 {v27.8h, v28.8h}, [dst], #32

    /* Accumulate four products for each of output coefficients 2 and 3. */
    smull  v23.4s, v4.4h, v18.4h  //a0*b2
    smull2 v24.4s, v4.8h, v18.8h  //a0*b2
    smull  v25.4s, v4.4h, v19.4h  //a0*b3
    smull2 v26.4s, v4.8h, v19.8h  //a0*b3

    smlal  v23.4s, v5.4h, v17.4h  //a1*b1
    smlal2 v24.4s, v5.8h, v17.8h  //a1*b1
    smlal  v25.4s, v5.4h, v18.4h  //a1*b2
    smlal2 v26.4s, v5.8h, v18.8h  //a1*b2

    smlal  v23.4s, v6.4h, v16.4h  //a2*b0
    smlal2 v24.4s, v6.8h, v16.8h  //a2*b0
    smlal  v25.4s, v6.4h, v17.4h  //a2*b1
    smlal2 v26.4s, v6.8h, v17.8h  //a2*b1

    smlal  v23.4s, v7.4h, v22.4h  //a3*(zeta*b3)
    smlal2 v24.4s, v7.8h, v22.8h  //a3*(zeta*b3)
    smlal  v25.4s, v7.4h, v16.4h  //a3*b0
    smlal2 v26.4s, v7.8h, v16.8h  //a3*b0

    /* Montgomery reduction: Algorithm 14 of [BHK+21], once per output. */
    uzp1 v27.8h, v23.8h, v24.8h
    uzp1 v28.8h, v25.8h, v26.8h

    mul v27.8h, v27.8h, v0.h[2]
    mul v28.8h, v28.8h, v0.h[2]

    smlal  v23.4s, v27.4h, v0.h[0]
    smlal2 v24.4s, v27.8h, v0.h[0]
    smlal  v25.4s, v28.4h, v0.h[0]
    smlal2 v26.4s, v28.8h, v0.h[0]

    uzp2 v29.8h, v23.8h, v24.8h
    uzp2 v30.8h, v25.8h, v26.8h

    /* Barrett multiplication by R: Algorithm 10 of [BHK+21]. */
    mul v27.8h, v29.8h, v0.h[3]
    mul v28.8h, v30.8h, v0.h[3]

    sqrdmulh v29.8h, v29.8h, v0.h[4]
    sqrdmulh v30.8h, v30.8h, v0.h[4]

    mls v27.8h, v29.8h, v0.h[0]
    mls v28.8h, v30.8h, v0.h[0]

    st1 {v27.8h, v28.8h}, [dst], #32

    subs counter, counter, #64
    /* The public counter selects the +zeta/-zeta block order. */
    tbz counter, #6, _looptop_pair_check

    /* Negate zeta and its Barrett factor to reuse them for the next -zeta block. */
    neg v1.8h, v1.8h
    neg v2.8h, v2.8h
    b _looptop

_looptop_pair_check:
    b.ne _looptop_pair

    .unreq dst
    .unreq src1
    .unreq src2
    .unreq zetas_ptr
    .unreq counter

    ret


/*************************************************
* Name:        poly_basemul_scale
*
* Description: Multiplication of two polynomials in the NTT domain while
*              retaining the R^-1 representation for poly_invntt_scale.
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
.global poly_basemul_scale
.global _poly_basemul_scale
poly_basemul_scale:
_poly_basemul_scale:

    dst       .req x0
    src1      .req x1
    src2      .req x2
    zetas_ptr .req x3
    counter   .req x8

    load_address zetas_ptr, consts_base

    ld1 {v0.8h}, [zetas_ptr]

    load_address zetas_ptr, zetas, ZETAS_MUL_OFFSET

    mov counter, #1536

_looptop_scale_pair:
    ldp q1, q2, [zetas_ptr], #64

_looptop_scale:
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

    /* Accumulate four products for each of output coefficients 0 and 1. */
    smull  v23.4s, v4.4h, v16.4h  //a0*b0
    smull2 v24.4s, v4.8h, v16.8h  //a0*b0
    smull  v25.4s, v4.4h, v17.4h  //a0*b1
    smull2 v26.4s, v4.8h, v17.8h  //a0*b1

    smlal  v23.4s, v5.4h, v22.4h  //a1*(zeta*b3)
    smlal2 v24.4s, v5.8h, v22.8h  //a1*(zeta*b3)
    smlal  v25.4s, v5.4h, v16.4h  //a1*b0
    smlal2 v26.4s, v5.8h, v16.8h  //a1*b0

    smlal  v23.4s, v6.4h, v21.4h  //a2*(zeta*b2)
    smlal2 v24.4s, v6.8h, v21.8h  //a2*(zeta*b2)
    smlal  v25.4s, v6.4h, v22.4h  //a2*(zeta*b3)
    smlal2 v26.4s, v6.8h, v22.8h  //a2*(zeta*b3)

    smlal  v23.4s, v7.4h, v20.4h  //a3*(zeta*b1)
    smlal2 v24.4s, v7.8h, v20.8h  //a3*(zeta*b1)
    smlal  v25.4s, v7.4h, v21.4h  //a3*(zeta*b2)
    smlal2 v26.4s, v7.8h, v21.8h  //a3*(zeta*b2)

    /* Montgomery reduction: Algorithm 14 of [BHK+21], once per output. */
    uzp1 v27.8h, v23.8h, v24.8h
    uzp1 v28.8h, v25.8h, v26.8h

    mul v27.8h, v27.8h, v0.h[2]
    mul v28.8h, v28.8h, v0.h[2]

    smlal  v23.4s, v27.4h, v0.h[0]
    smlal2 v24.4s, v27.8h, v0.h[0]
    smlal  v25.4s, v28.4h, v0.h[0]
    smlal2 v26.4s, v28.8h, v0.h[0]

    uzp2 v29.8h, v23.8h, v24.8h
    uzp2 v30.8h, v25.8h, v26.8h

    st1 {v29.8h, v30.8h}, [dst], #32

    /* Accumulate four products for each of output coefficients 2 and 3. */
    smull  v23.4s, v4.4h, v18.4h  //a0*b2
    smull2 v24.4s, v4.8h, v18.8h  //a0*b2
    smull  v25.4s, v4.4h, v19.4h  //a0*b3
    smull2 v26.4s, v4.8h, v19.8h  //a0*b3

    smlal  v23.4s, v5.4h, v17.4h  //a1*b1
    smlal2 v24.4s, v5.8h, v17.8h  //a1*b1
    smlal  v25.4s, v5.4h, v18.4h  //a1*b2
    smlal2 v26.4s, v5.8h, v18.8h  //a1*b2

    smlal  v23.4s, v6.4h, v16.4h  //a2*b0
    smlal2 v24.4s, v6.8h, v16.8h  //a2*b0
    smlal  v25.4s, v6.4h, v17.4h  //a2*b1
    smlal2 v26.4s, v6.8h, v17.8h  //a2*b1

    smlal  v23.4s, v7.4h, v22.4h  //a3*(zeta*b3)
    smlal2 v24.4s, v7.8h, v22.8h  //a3*(zeta*b3)
    smlal  v25.4s, v7.4h, v16.4h  //a3*b0
    smlal2 v26.4s, v7.8h, v16.8h  //a3*b0

    /* Montgomery reduction: Algorithm 14 of [BHK+21], once per output. */
    uzp1 v27.8h, v23.8h, v24.8h
    uzp1 v28.8h, v25.8h, v26.8h

    mul v27.8h, v27.8h, v0.h[2]
    mul v28.8h, v28.8h, v0.h[2]

    smlal  v23.4s, v27.4h, v0.h[0]
    smlal2 v24.4s, v27.8h, v0.h[0]
    smlal  v25.4s, v28.4h, v0.h[0]
    smlal2 v26.4s, v28.8h, v0.h[0]

    uzp2 v29.8h, v23.8h, v24.8h
    uzp2 v30.8h, v25.8h, v26.8h

    st1 {v29.8h, v30.8h}, [dst], #32

    subs counter, counter, #64
    /* The public counter selects the +zeta/-zeta block order. */
    tbz counter, #6, _looptop_scale_pair_check

    /* Negate zeta and its Barrett factor to reuse them for the next -zeta block. */
    neg v1.8h, v1.8h
    neg v2.8h, v2.8h
    b _looptop_scale

_looptop_scale_pair_check:
    b.ne _looptop_scale_pair

    .unreq dst
    .unreq src1
    .unreq src2
    .unreq zetas_ptr
    .unreq counter

    ret


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
.global poly_basemul_add
.global _poly_basemul_add
poly_basemul_add:
_poly_basemul_add:

    dst       .req x0
    src1      .req x1
    src2      .req x2
    src3      .req x3
    zetas_ptr .req x4
    counter   .req x8

    load_address zetas_ptr, consts_base

    ld1 {v0.8h}, [zetas_ptr]

    load_address zetas_ptr, zetas, ZETAS_MUL_OFFSET

    mov counter, #1536

_looptop_add_pair:
    ldp q1, q2, [zetas_ptr], #64

_looptop_add:
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

    /* Accumulate four products for each of output coefficients 0 and 1. */
    smull  v23.4s, v4.4h, v16.4h  //a0*b0
    smull2 v24.4s, v4.8h, v16.8h  //a0*b0
    smull  v25.4s, v4.4h, v17.4h  //a0*b1
    smull2 v26.4s, v4.8h, v17.8h  //a0*b1

    smlal  v23.4s, v5.4h, v22.4h  //a1*(zeta*b3)
    smlal2 v24.4s, v5.8h, v22.8h  //a1*(zeta*b3)
    smlal  v25.4s, v5.4h, v16.4h  //a1*b0
    smlal2 v26.4s, v5.8h, v16.8h  //a1*b0

    smlal  v23.4s, v6.4h, v21.4h  //a2*(zeta*b2)
    smlal2 v24.4s, v6.8h, v21.8h  //a2*(zeta*b2)
    smlal  v25.4s, v6.4h, v22.4h  //a2*(zeta*b3)
    smlal2 v26.4s, v6.8h, v22.8h  //a2*(zeta*b3)

    smlal  v23.4s, v7.4h, v20.4h  //a3*(zeta*b1)
    smlal2 v24.4s, v7.8h, v20.8h  //a3*(zeta*b1)
    smlal  v25.4s, v7.4h, v21.4h  //a3*(zeta*b2)
    smlal2 v26.4s, v7.8h, v21.8h  //a3*(zeta*b2)

    /* Montgomery reduction: Algorithm 14 of [BHK+21], once per output. */
    uzp1 v27.8h, v23.8h, v24.8h
    uzp1 v28.8h, v25.8h, v26.8h

    mul v27.8h, v27.8h, v0.h[2]
    mul v28.8h, v28.8h, v0.h[2]

    smlal  v23.4s, v27.4h, v0.h[0]
    smlal2 v24.4s, v27.8h, v0.h[0]
    smlal  v25.4s, v28.4h, v0.h[0]
    smlal2 v26.4s, v28.8h, v0.h[0]

    uzp2 v29.8h, v23.8h, v24.8h
    uzp2 v30.8h, v25.8h, v26.8h

    /* Barrett multiplication by R: Algorithm 10 of [BHK+21]. */
    mul v27.8h, v29.8h, v0.h[3]
    mul v28.8h, v30.8h, v0.h[3]

    sqrdmulh v29.8h, v29.8h, v0.h[4]
    sqrdmulh v30.8h, v30.8h, v0.h[4]

    mls v27.8h, v29.8h, v0.h[0]
    mls v28.8h, v30.8h, v0.h[0]

    ld1 {v29.8h, v30.8h}, [src3], #32

    add v27.8h, v27.8h, v29.8h
    add v28.8h, v28.8h, v30.8h

    st1 {v27.8h, v28.8h}, [dst], #32

    /* Accumulate four products for each of output coefficients 2 and 3. */
    smull  v23.4s, v4.4h, v18.4h  //a0*b2
    smull2 v24.4s, v4.8h, v18.8h  //a0*b2
    smull  v25.4s, v4.4h, v19.4h  //a0*b3
    smull2 v26.4s, v4.8h, v19.8h  //a0*b3

    smlal  v23.4s, v5.4h, v17.4h  //a1*b1
    smlal2 v24.4s, v5.8h, v17.8h  //a1*b1
    smlal  v25.4s, v5.4h, v18.4h  //a1*b2
    smlal2 v26.4s, v5.8h, v18.8h  //a1*b2

    smlal  v23.4s, v6.4h, v16.4h  //a2*b0
    smlal2 v24.4s, v6.8h, v16.8h  //a2*b0
    smlal  v25.4s, v6.4h, v17.4h  //a2*b1
    smlal2 v26.4s, v6.8h, v17.8h  //a2*b1

    smlal  v23.4s, v7.4h, v22.4h  //a3*(zeta*b3)
    smlal2 v24.4s, v7.8h, v22.8h  //a3*(zeta*b3)
    smlal  v25.4s, v7.4h, v16.4h  //a3*b0
    smlal2 v26.4s, v7.8h, v16.8h  //a3*b0

    /* Montgomery reduction: Algorithm 14 of [BHK+21], once per output. */
    uzp1 v27.8h, v23.8h, v24.8h
    uzp1 v28.8h, v25.8h, v26.8h

    mul v27.8h, v27.8h, v0.h[2]
    mul v28.8h, v28.8h, v0.h[2]

    smlal  v23.4s, v27.4h, v0.h[0]
    smlal2 v24.4s, v27.8h, v0.h[0]
    smlal  v25.4s, v28.4h, v0.h[0]
    smlal2 v26.4s, v28.8h, v0.h[0]

    uzp2 v29.8h, v23.8h, v24.8h
    uzp2 v30.8h, v25.8h, v26.8h

    /* Barrett multiplication by R: Algorithm 10 of [BHK+21]. */
    mul v27.8h, v29.8h, v0.h[3]
    mul v28.8h, v30.8h, v0.h[3]

    sqrdmulh v29.8h, v29.8h, v0.h[4]
    sqrdmulh v30.8h, v30.8h, v0.h[4]

    mls v27.8h, v29.8h, v0.h[0]
    mls v28.8h, v30.8h, v0.h[0]

    ld1 {v29.8h, v30.8h}, [src3], #32

    add v27.8h, v27.8h, v29.8h
    add v28.8h, v28.8h, v30.8h

    st1 {v27.8h, v28.8h}, [dst], #32

    subs counter, counter, #64
    /* The public counter selects the +zeta/-zeta block order. */
    tbz counter, #6, _looptop_add_pair_check

    /* Negate zeta and its Barrett factor to reuse them for the next -zeta block. */
    neg v1.8h, v1.8h
    neg v2.8h, v2.8h
    b _looptop_add

_looptop_add_pair_check:
    b.ne _looptop_add_pair

    .unreq dst
    .unreq src1
    .unreq src2
    .unreq src3
    .unreq zetas_ptr
    .unreq counter

    ret


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
*              factors R^-2 and R^-3 respectively, where R = 2^16.
**************************************************/

.global poly_baseinv_1
.global _poly_baseinv_1
poly_baseinv_1:
_poly_baseinv_1:
    dst       .req x0
    den       .req x1
    src       .req x2
    zetas_ptr .req x3
    counter   .req x8

    load_address zetas_ptr, consts_base

    ld1 {v0.8h}, [zetas_ptr]

    load_address zetas_ptr, zetas, ZETAS_MUL_OFFSET

    mov counter, #1536

_looptop_baseinv_1_pair:
    ldp q1, q2, [zetas_ptr], #64

_looptop_baseinv_1:
    ld1 {v3.8h - v6.8h}, [src], #64

    /*
     * Barrett multiplication: Algorithm 10 of [BHK+21].
     * Accumulated Montgomery products: Algorithm 14 of [BHK+21].
     * t0 = a2*zeta, t1 = a3*zeta (mod q).
     * |t0|,|t1| <= 1899; |corrected accumulator| <= 155670271.
     */
    sqrdmulh v17.8h, v5.8h, v2.8h
    sqrdmulh v18.8h, v6.8h, v2.8h

    mul  v7.8h, v5.8h, v1.8h
    mul v16.8h, v6.8h, v1.8h

    mls  v7.8h, v17.8h, v0.h[0]
    mls v16.8h, v18.8h, v0.h[0]

    //s0 = (a0*a0 + a2*t0 - 2*a1*t1)/R (mod q)
    //s1 = (a1*a1 + a3*t1 - 2*a0*a2)/R (mod q)
    smull  v17.4s, v3.4h, v3.4h  //a0*a0
    smull2 v18.4s, v3.8h, v3.8h  //a0*a0
    smull  v19.4s, v4.4h, v4.4h  //a1*a1
    smull2 v20.4s, v4.8h, v4.8h  //a1*a1

    smlal  v17.4s, v5.4h,  v7.4h  //a2*t0
    smlal2 v18.4s, v5.8h,  v7.8h  //a2*t0
    smlal  v19.4s, v6.4h, v16.4h  //a3*t1
    smlal2 v20.4s, v6.8h, v16.8h  //a3*t1

    sqdmlsl  v17.4s, v4.4h, v16.4h  //-2*a1*t1
    sqdmlsl2 v18.4s, v4.8h, v16.8h  //-2*a1*t1
    sqdmlsl  v19.4s, v3.4h,  v5.4h  //-2*a0*a2
    sqdmlsl2 v20.4s, v3.8h,  v5.8h  //-2*a0*a2

    uzp1 v21.8h, v17.8h, v18.8h
    uzp1 v22.8h, v19.8h, v20.8h

    mul v21.8h, v21.8h, v0.h[2]
    mul v22.8h, v22.8h, v0.h[2]

    smlal  v17.4s, v21.4h, v0.h[0]
    smlal2 v18.4s, v21.8h, v0.h[0]
    smlal  v19.4s, v22.4h, v0.h[0]
    smlal2 v20.4s, v22.8h, v0.h[0]

    uzp2 v23.8h, v17.8h, v18.8h
    uzp2 v24.8h, v19.8h, v20.8h

    //s2 = s1*zeta (mod q)
    sqrdmulh v21.8h, v24.8h, v2.8h

    mul v25.8h, v24.8h, v1.8h

    mls v25.8h, v21.8h, v0.h[0]

    //det = (s0*s0 - s1*s2)/R (mod q)
    smull  v17.4s, v23.4h, v23.4h
    smull2 v18.4s, v23.8h, v23.8h

    smlsl  v17.4s, v24.4h, v25.4h
    smlsl2 v18.4s, v24.8h, v25.8h

    uzp1 v21.8h, v17.8h, v18.8h

    mul v21.8h, v21.8h, v0.h[2]

    smlal  v17.4s, v21.4h, v0.h[0]
    smlal2 v18.4s, v21.8h, v0.h[0]

    uzp2 v27.8h, v17.8h, v18.8h
    str q27, [den], #16

    smull  v17.4s, v3.4h, v23.4h  //a0*s0
    smull2 v18.4s, v3.8h, v23.8h  //a0*s0
    smull  v19.4s, v6.4h, v25.4h  //a3*s2
    smull2 v20.4s, v6.8h, v25.8h  //a3*s2

    smlal  v17.4s, v5.4h, v25.4h  //a2*s2
    smlal2 v18.4s, v5.8h, v25.8h  //a2*s2
    smlal  v19.4s, v4.4h, v23.4h  //a1*s0
    smlal2 v20.4s, v4.8h, v23.8h  //a1*s0

    uzp1 v21.8h, v17.8h, v18.8h
    uzp1 v22.8h, v19.8h, v20.8h

    mul v21.8h, v21.8h, v0.h[2]
    mul v22.8h, v22.8h, v0.h[2]

    smlal  v17.4s, v21.4h, v0.h[0]
    smlal2 v18.4s, v21.8h, v0.h[0]
    smlal  v19.4s, v22.4h, v0.h[0]
    smlal2 v20.4s, v22.8h, v0.h[0]

    uzp2 v27.8h, v17.8h, v18.8h
    uzp2 v28.8h, v19.8h, v20.8h
    st1 {v27.8h, v28.8h}, [dst], #32

    smull  v17.4s, v5.4h, v23.4h  //a2*s0
    smull2 v18.4s, v5.8h, v23.8h  //a2*s0
    smull  v19.4s, v4.4h, v24.4h  //a1*s1
    smull2 v20.4s, v4.8h, v24.8h  //a1*s1

    smlal  v17.4s, v3.4h, v24.4h  //a0*s1
    smlal2 v18.4s, v3.8h, v24.8h  //a0*s1
    smlal  v19.4s, v6.4h, v23.4h  //a3*s0
    smlal2 v20.4s, v6.8h, v23.8h  //a3*s0

    uzp1 v21.8h, v17.8h, v18.8h
    uzp1 v22.8h, v19.8h, v20.8h

    mul v21.8h, v21.8h, v0.h[2]
    mul v22.8h, v22.8h, v0.h[2]

    smlal  v17.4s, v21.4h, v0.h[0]
    smlal2 v18.4s, v21.8h, v0.h[0]
    smlal  v19.4s, v22.4h, v0.h[0]
    smlal2 v20.4s, v22.8h, v0.h[0]

    uzp2 v27.8h, v17.8h, v18.8h
    uzp2 v28.8h, v19.8h, v20.8h
    st1 {v27.8h, v28.8h}, [dst], #32

    subs counter, counter, #64
    /* The public counter selects the +zeta/-zeta block order. */
    tbz counter, #6, _looptop_baseinv_1_pair_check

    /* Negate zeta and its Barrett factor to reuse them for the next -zeta block. */
    neg v1.8h, v1.8h
    neg v2.8h, v2.8h
    b _looptop_baseinv_1

_looptop_baseinv_1_pair_check:
    b.ne _looptop_baseinv_1_pair

    .unreq dst
    .unreq den
    .unreq src
    .unreq zetas_ptr
    .unreq counter
    ret
