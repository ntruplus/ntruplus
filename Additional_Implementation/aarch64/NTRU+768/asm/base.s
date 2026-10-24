/*
 * References:
 *
 * [BHK+21] Hanno Becker, Vincent Hwang, Matthias J. Kannwischer,
 * Bo-Yin Yang, and Shang-Yi Yang,
 * "Neon NTT: Faster Dilithium, Kyber, and Saber
 * on Cortex-A72 and Apple M1", IACR Transactions on Cryptographic
 * Hardware and Embedded Systems, 2022(1), pp. 221-244.
 * https://doi.org/10.46586/tches.v2022.i1.221-244
 * Algorithms 10 and 14 are used in the product blocks below.
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
.global poly_basemul
.global _poly_basemul
poly_basemul:
_poly_basemul:

    dst       .req x0
    src1      .req x1
    src2      .req x2
    zetas_ptr .req x3
    counter   .req x8

    adr zetas_ptr, zetas_mul

    ld1 {v0.8h}, [zetas_ptr], #16

    mov counter, #1536

_looptop_pretwist:
    ld1 {v1.8h, v2.8h}, [zetas_ptr], #32

    /* Read both inputs before storing either output half. */
    ld1 { v4.8h -  v7.8h}, [src1], #64
    ld1 {v16.8h - v19.8h}, [src2], #64

    /*
     * Barrett multiplication: Algorithm 10 of [BHK+21].
     * v20 = zeta*b1, v21 = zeta*b2, v22 = zeta*b3, with no R factor.
     * |pre-twist| <= 2085; |corrected accumulator| <= 304437252.
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
    b.ne _looptop_pretwist

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

    adr zetas_ptr, zetas_mul

    ld1 {v0.8h}, [zetas_ptr], #16

    mov counter, #1536

_looptop_pretwist_scale:
    ld1 {v1.8h, v2.8h}, [zetas_ptr], #32

    /* Read both inputs before storing either output half. */
    ld1 { v4.8h -  v7.8h}, [src1], #64
    ld1 {v16.8h - v19.8h}, [src2], #64

    /*
     * Barrett multiplication: Algorithm 10 of [BHK+21].
     * v20 = zeta*b1, v21 = zeta*b2, v22 = zeta*b3, with no R factor.
     * |pre-twist| <= 1899; |corrected accumulator| <= 161054720.
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
    b.ne _looptop_pretwist_scale

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

    adr zetas_ptr, zetas_mul

    ld1 {v0.8h}, [zetas_ptr], #16

    mov counter, #1536

_looptop_pretwist_add:
    ld1 {v1.8h, v2.8h}, [zetas_ptr], #32

    /* Read both inputs before storing either output half. */
    ld1 { v4.8h -  v7.8h}, [src1], #64
    ld1 {v16.8h - v19.8h}, [src2], #64

    /*
     * Barrett multiplication: Algorithm 10 of [BHK+21].
     * v20 = zeta*b1, v21 = zeta*b2, v22 = zeta*b3, with no R factor.
     * |pre-twist| <= 2085; |corrected accumulator| <= 304437252.
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
    b.ne _looptop_pretwist_add

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

    adr zetas_ptr, zetas_mul

    ld1 {v0.8h}, [zetas_ptr], #16

    mov counter, #1536

_looptop_baseinv_1:
    ld1 {v1.8h, v2.8h}, [zetas_ptr], #32

    ld1 {v3.8h - v6.8h}, [src], #64

    /*
     * Barrett pre-twist: Algorithm 10 of [BHK+21].
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
    b.ne _looptop_baseinv_1

    .unreq dst
    .unreq den
    .unreq src
    .unreq zetas_ptr
    .unreq counter
    ret

/*
 * Barrett twiddles: Algorithm 10 of [BHK+21].
 * After the common constants, each block contains centered zeta followed
 * by round(2^15*zeta/q). Base multiplication and inversion share them.
 */
.align 4
zetas_mul:
    .hword 0x0d81, 0x4bd4, 0xcd7f, 0xff6d, 0xfa8f, 0xf9dd, 0xc5d5, 0x3281
    .hword 0x0016, 0x06ad, 0xfeed, 0x0454, 0x0162, 0xf940, 0xfc38, 0x035a
    .hword 0x00d1, 0x3f47, 0xf5d1, 0x2906, 0x0d1b, 0xc005, 0xdc29, 0x1fc5
    .hword 0xffea, 0xf953, 0x0113, 0xfbac, 0xfe9e, 0x06c0, 0x03c8, 0xfca6
    .hword 0xff2f, 0xc0b9, 0x0a2f, 0xd6fa, 0xf2e5, 0x3ffb, 0x23d7, 0xe03b
    .hword 0x04c5, 0xff26, 0x0126, 0xfd24, 0xfbb9, 0x037c, 0x0634, 0xfcf5
    .hword 0x2d36, 0xf7ee, 0x0ae3, 0xe4e6, 0xd775, 0x2107, 0x3acc, 0xe328
    .hword 0xfb3b, 0x00da, 0xfeda, 0x02dc, 0x0447, 0xfc84, 0xf9cc, 0x030b
    .hword 0xd2ca, 0x0812, 0xf51d, 0x1b1a, 0x288b, 0xdef9, 0xc534, 0x1cd8
    .hword 0x03fe, 0xfbd9, 0x041d, 0x04a4, 0x01a1, 0xfa91, 0xffe5, 0xf9a6
    .hword 0x25d7, 0xd8a4, 0x26fd, 0x2bfd, 0x0f71, 0xcc7f, 0xff00, 0xc3cc
    .hword 0xfc02, 0x0427, 0xfbe3, 0xfb5c, 0xfe5f, 0x056f, 0x001b, 0x065a
    .hword 0xda29, 0x275c, 0xd903, 0xd403, 0xf08f, 0x3381, 0x0100, 0x3c34
    .hword 0x0581, 0x05dd, 0x0579, 0x00fb, 0x02a1, 0x0246, 0x00e6, 0xfe97
    .hword 0x342c, 0x3794, 0x33e0, 0x094b, 0x18eb, 0x158d, 0x0884, 0xf2a2
    .hword 0xfa7f, 0xfa23, 0xfa87, 0xff05, 0xfd5f, 0xfdba, 0xff1a, 0x0169
    .hword 0xcbd4, 0xc86c, 0xcc20, 0xf6b5, 0xe715, 0xea73, 0xf77c, 0x0d5e
    .hword 0xf9f2, 0x05fb, 0xfaa9, 0xff84, 0x05b2, 0x0563, 0xfc54, 0xf96f
    .hword 0xc69c, 0x38b0, 0xcd63, 0xfb69, 0x35fc, 0x330f, 0xdd32, 0xc1c2
    .hword 0x060e, 0xfa05, 0x0557, 0x007c, 0xfa4e, 0xfa9d, 0x03ac, 0x0691
    .hword 0x3964, 0xc750, 0x329d, 0x0497, 0xca04, 0xccf1, 0x22ce, 0x3e3e
    .hword 0x0190, 0x0112, 0xf9f9, 0x0020, 0x0580, 0xfb20, 0xfec5, 0xf96b
    .hword 0x0ecf, 0x0a25, 0xc6de, 0x012f, 0x3422, 0xd1cb, 0xf456, 0xc19c
    .hword 0xfe70, 0xfeee, 0x0607, 0xffe0, 0xfa80, 0x04e0, 0x013b, 0x0695
    .hword 0xf131, 0xf5db, 0x3922, 0xfed1, 0xcbde, 0x2e35, 0x0baa, 0x3e64
    .hword 0xfd0d, 0xfaf1, 0x031b, 0x0277, 0x006c, 0xfe66, 0xfaba, 0x0684
    .hword 0xe40c, 0xd00d, 0x1d70, 0x175d, 0x0400, 0xf0d2, 0xce04, 0x3dc3
    .hword 0x02f3, 0x050f, 0xfce5, 0xfd89, 0xff94, 0x019a, 0x0546, 0xf97c
    .hword 0x1bf4, 0x2ff3, 0xe290, 0xe8a3, 0xfc00, 0x0f2e, 0x31fc, 0xc23d
    .hword 0x051e, 0xfc14, 0x038e, 0xfb02, 0xfc68, 0x05a4, 0x0469, 0xfd03
    .hword 0x3081, 0xdad3, 0x21b2, 0xd0ae, 0xddf0, 0x3577, 0x29cd, 0xe3ad
    .hword 0xfae2, 0x03ec, 0xfc72, 0x04fe, 0x0398, 0xfa5c, 0xfb97, 0x02fd
    .hword 0xcf7f, 0x252d, 0xde4e, 0x2f52, 0x2210, 0xca89, 0xd633, 0x1c53
    .hword 0xfa5a, 0x01f0, 0x0316, 0x02ca, 0x012f, 0xff42, 0x0576, 0xfbc6
    .hword 0xca76, 0x125d, 0x1d40, 0x1a70, 0x0b38, 0xf8f7, 0x33c3, 0xd7f0
    .hword 0x05a6, 0xfe10, 0xfcea, 0xfd36, 0xfed1, 0x00be, 0xfa8a, 0x043a
    .hword 0x358a, 0xeda3, 0xe2c0, 0xe590, 0xf4c8, 0x0709, 0xcc3d, 0x2810
    .hword 0xfd1a, 0xff80, 0xfbb8, 0x0640, 0x04ec, 0xff52, 0x05ff, 0xfafe
    .hword 0xe487, 0xfb43, 0xd76b, 0x3b3e, 0x2ea7, 0xf98f, 0x38d6, 0xd088
    .hword 0x02e6, 0x0080, 0x0448, 0xf9c0, 0xfb14, 0x00ae, 0xfa01, 0x0502
    .hword 0x1b79, 0x04bd, 0x2895, 0xc4c2, 0xd159, 0x0671, 0xc72a, 0x2f78
    .hword 0xfb68, 0xfdef, 0x0368, 0x0593, 0x0232, 0xfeab, 0xff91, 0xfc65
    .hword 0xd475, 0xec6a, 0x2049, 0x34d6, 0x14cf, 0xf360, 0xfbe4, 0xddd3
    .hword 0x0498, 0x0211, 0xfc98, 0xfa6d, 0xfdce, 0x0155, 0x006f, 0x039b
    .hword 0x2b8b, 0x1396, 0xdfb7, 0xcb2a, 0xeb31, 0x0ca0, 0x041c, 0x222d
    .hword 0x019f, 0x0019, 0xfffe, 0x0588, 0x004e, 0x0058, 0xfc31, 0xfbb4
    .hword 0x0f5e, 0x00ed, 0xffed, 0x346e, 0x02e3, 0x0342, 0xdbe6, 0xd745
    .hword 0xfe61, 0xffe7, 0x0002, 0xfa78, 0xffb2, 0xffa8, 0x03cf, 0x044c
    .hword 0xf0a2, 0xff13, 0x0013, 0xcb92, 0xfd1d, 0xfcbe, 0x241a, 0x28bb
