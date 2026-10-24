/*
 * References:
 *
 * [BHK+21] Hanno Becker, Vincent Hwang, Matthias J. Kannwischer,
 * Bo-Yin Yang, and Shang-Yi Yang,
 * "Neon NTT: Faster Dilithium, Kyber, and Saber
 * on Cortex-A72 and Apple M1", IACR Transactions on Cryptographic
 * Hardware and Embedded Systems, 2022(1), pp. 221-244.
 * https://doi.org/10.46586/tches.v2022.i1.221-244
 * Algorithms 10, 12, and 14 are used in the product blocks below.
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

    adr zetas_ptr, zetas_pretwist

    ld1 {v0.8h}, [zetas_ptr], #16

    mov counter, #1728

_looptop_pretwist:
    ld1 {v1.8h, v2.8h}, [zetas_ptr], #32

    /* Read both inputs before storing the output block. */
    ld1 { v4.8h -  v6.8h}, [src1], #48
    ld1 {v16.8h - v18.8h}, [src2], #48

    /*
     * Barrett multiplication: Algorithm 10 of [BHK+21].
     * v19 = zeta*b1, v20 = zeta*b2, with no R factor.
     * |pre-twist| <= 2074; |corrected accumulator| <= 256647683.
     */
    mul v19.8h, v17.8h, v1.8h
    mul v20.8h, v18.8h, v1.8h

    sqrdmulh v27.8h, v17.8h, v2.8h
    sqrdmulh v28.8h, v18.8h, v2.8h

    mls v19.8h, v27.8h, v0.h[0]
    mls v20.8h, v28.8h, v0.h[0]

    /* Accumulate three products for each output coefficient. */
    smull  v21.4s, v4.4h, v16.4h  //a0*b0
    smull2 v22.4s, v4.8h, v16.8h  //a0*b0
    smull  v23.4s, v4.4h, v17.4h  //a0*b1
    smull2 v24.4s, v4.8h, v17.8h  //a0*b1
    smull  v25.4s, v4.4h, v18.4h  //a0*b2
    smull2 v26.4s, v4.8h, v18.8h  //a0*b2

    smlal  v21.4s, v5.4h, v20.4h  //a1*(zeta*b2)
    smlal2 v22.4s, v5.8h, v20.8h  //a1*(zeta*b2)
    smlal  v23.4s, v5.4h, v16.4h  //a1*b0
    smlal2 v24.4s, v5.8h, v16.8h  //a1*b0
    smlal  v25.4s, v5.4h, v17.4h  //a1*b1
    smlal2 v26.4s, v5.8h, v17.8h  //a1*b1

    smlal  v21.4s, v6.4h, v19.4h  //a2*(zeta*b1)
    smlal2 v22.4s, v6.8h, v19.8h  //a2*(zeta*b1)
    smlal  v23.4s, v6.4h, v20.4h  //a2*(zeta*b2)
    smlal2 v24.4s, v6.8h, v20.8h  //a2*(zeta*b2)
    smlal  v25.4s, v6.4h, v16.4h  //a2*b0
    smlal2 v26.4s, v6.8h, v16.8h  //a2*b0

    /* Montgomery reduction: Algorithm 14 of [BHK+21], once per output. */
    uzp1 v27.8h, v21.8h, v22.8h
    uzp1 v28.8h, v23.8h, v24.8h
    uzp1 v29.8h, v25.8h, v26.8h

    mul v27.8h, v27.8h, v0.h[2]
    mul v28.8h, v28.8h, v0.h[2]
    mul v29.8h, v29.8h, v0.h[2]

    smlal  v21.4s, v27.4h, v0.h[0]
    smlal2 v22.4s, v27.8h, v0.h[0]
    smlal  v23.4s, v28.4h, v0.h[0]
    smlal2 v24.4s, v28.8h, v0.h[0]
    smlal  v25.4s, v29.4h, v0.h[0]
    smlal2 v26.4s, v29.8h, v0.h[0]

    uzp2 v4.8h, v21.8h, v22.8h
    uzp2 v5.8h, v23.8h, v24.8h
    uzp2 v6.8h, v25.8h, v26.8h

    /* Barrett multiplication by R: Algorithm 10 of [BHK+21]. */
    mul v16.8h, v4.8h, v0.h[3]
    mul v17.8h, v5.8h, v0.h[3]
    mul v18.8h, v6.8h, v0.h[3]

    sqrdmulh v4.8h, v4.8h, v0.h[4]
    sqrdmulh v5.8h, v5.8h, v0.h[4]
    sqrdmulh v6.8h, v6.8h, v0.h[4]

    mls v16.8h, v4.8h, v0.h[0]
    mls v17.8h, v5.8h, v0.h[0]
    mls v18.8h, v6.8h, v0.h[0]

    st1 {v16.8h - v18.8h}, [dst], #48

    subs counter, counter, #48
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

    adr zetas_ptr, zetas_pretwist

    ld1 {v0.8h}, [zetas_ptr], #16

    mov counter, #1728

_looptop_pretwist_scale:
    ld1 {v1.8h, v2.8h}, [zetas_ptr], #32

    /* Read both inputs before storing the output block. */
    ld1 { v4.8h -  v6.8h}, [src1], #48
    ld1 {v16.8h - v18.8h}, [src2], #48

    /*
     * Barrett multiplication: Algorithm 10 of [BHK+21].
     * v19 = zeta*b1, v20 = zeta*b2, with no R factor.
     * |pre-twist| <= 1904; |corrected accumulator| <= 149110784.
     */
    mul v19.8h, v17.8h, v1.8h
    mul v20.8h, v18.8h, v1.8h

    sqrdmulh v27.8h, v17.8h, v2.8h
    sqrdmulh v28.8h, v18.8h, v2.8h

    mls v19.8h, v27.8h, v0.h[0]
    mls v20.8h, v28.8h, v0.h[0]

    /* Accumulate three products for each output coefficient. */
    smull  v21.4s, v4.4h, v16.4h  //a0*b0
    smull2 v22.4s, v4.8h, v16.8h  //a0*b0
    smull  v23.4s, v4.4h, v17.4h  //a0*b1
    smull2 v24.4s, v4.8h, v17.8h  //a0*b1
    smull  v25.4s, v4.4h, v18.4h  //a0*b2
    smull2 v26.4s, v4.8h, v18.8h  //a0*b2

    smlal  v21.4s, v5.4h, v20.4h  //a1*(zeta*b2)
    smlal2 v22.4s, v5.8h, v20.8h  //a1*(zeta*b2)
    smlal  v23.4s, v5.4h, v16.4h  //a1*b0
    smlal2 v24.4s, v5.8h, v16.8h  //a1*b0
    smlal  v25.4s, v5.4h, v17.4h  //a1*b1
    smlal2 v26.4s, v5.8h, v17.8h  //a1*b1

    smlal  v21.4s, v6.4h, v19.4h  //a2*(zeta*b1)
    smlal2 v22.4s, v6.8h, v19.8h  //a2*(zeta*b1)
    smlal  v23.4s, v6.4h, v20.4h  //a2*(zeta*b2)
    smlal2 v24.4s, v6.8h, v20.8h  //a2*(zeta*b2)
    smlal  v25.4s, v6.4h, v16.4h  //a2*b0
    smlal2 v26.4s, v6.8h, v16.8h  //a2*b0

    /* Montgomery reduction: Algorithm 14 of [BHK+21], once per output. */
    uzp1 v27.8h, v21.8h, v22.8h
    uzp1 v28.8h, v23.8h, v24.8h
    uzp1 v29.8h, v25.8h, v26.8h

    mul v27.8h, v27.8h, v0.h[2]
    mul v28.8h, v28.8h, v0.h[2]
    mul v29.8h, v29.8h, v0.h[2]

    smlal  v21.4s, v27.4h, v0.h[0]
    smlal2 v22.4s, v27.8h, v0.h[0]
    smlal  v23.4s, v28.4h, v0.h[0]
    smlal2 v24.4s, v28.8h, v0.h[0]
    smlal  v25.4s, v29.4h, v0.h[0]
    smlal2 v26.4s, v29.8h, v0.h[0]

    uzp2 v4.8h, v21.8h, v22.8h
    uzp2 v5.8h, v23.8h, v24.8h
    uzp2 v6.8h, v25.8h, v26.8h

    st1 {v4.8h - v6.8h}, [dst], #48

    subs counter, counter, #48
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
* Returns:     none. Output coefficients lie in (-q,q) and are reduced by
*              poly_tobytes before serialization.
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

    adr zetas_ptr, zetas_pretwist

    ld1 {v0.8h}, [zetas_ptr], #16

    mov counter, #1728

_looptop_pretwist_add:
    ld1 {v1.8h, v2.8h}, [zetas_ptr], #32

    /* Read both inputs before storing the output block. */
    ld1 { v4.8h -  v6.8h}, [src1], #48
    ld1 {v16.8h - v18.8h}, [src2], #48

    /*
     * Barrett multiplication: Algorithm 10 of [BHK+21].
     * v19 = zeta*b1, v20 = zeta*b2, with no R factor.
     * |pre-twist| <= 2074; |corrected accumulator| <= 256647683.
     */
    mul v19.8h, v17.8h, v1.8h
    mul v20.8h, v18.8h, v1.8h

    sqrdmulh v27.8h, v17.8h, v2.8h
    sqrdmulh v28.8h, v18.8h, v2.8h

    mls v19.8h, v27.8h, v0.h[0]
    mls v20.8h, v28.8h, v0.h[0]

    /* Accumulate three products for each output coefficient. */
    smull  v21.4s, v4.4h, v16.4h  //a0*b0
    smull2 v22.4s, v4.8h, v16.8h  //a0*b0
    smull  v23.4s, v4.4h, v17.4h  //a0*b1
    smull2 v24.4s, v4.8h, v17.8h  //a0*b1
    smull  v25.4s, v4.4h, v18.4h  //a0*b2
    smull2 v26.4s, v4.8h, v18.8h  //a0*b2

    smlal  v21.4s, v5.4h, v20.4h  //a1*(zeta*b2)
    smlal2 v22.4s, v5.8h, v20.8h  //a1*(zeta*b2)
    smlal  v23.4s, v5.4h, v16.4h  //a1*b0
    smlal2 v24.4s, v5.8h, v16.8h  //a1*b0
    smlal  v25.4s, v5.4h, v17.4h  //a1*b1
    smlal2 v26.4s, v5.8h, v17.8h  //a1*b1

    smlal  v21.4s, v6.4h, v19.4h  //a2*(zeta*b1)
    smlal2 v22.4s, v6.8h, v19.8h  //a2*(zeta*b1)
    smlal  v23.4s, v6.4h, v20.4h  //a2*(zeta*b2)
    smlal2 v24.4s, v6.8h, v20.8h  //a2*(zeta*b2)
    smlal  v25.4s, v6.4h, v16.4h  //a2*b0
    smlal2 v26.4s, v6.8h, v16.8h  //a2*b0

    /* Montgomery reduction: Algorithm 14 of [BHK+21], once per output. */
    uzp1 v27.8h, v21.8h, v22.8h
    uzp1 v28.8h, v23.8h, v24.8h
    uzp1 v29.8h, v25.8h, v26.8h

    mul v27.8h, v27.8h, v0.h[2]
    mul v28.8h, v28.8h, v0.h[2]
    mul v29.8h, v29.8h, v0.h[2]

    smlal  v21.4s, v27.4h, v0.h[0]
    smlal2 v22.4s, v27.8h, v0.h[0]
    smlal  v23.4s, v28.4h, v0.h[0]
    smlal2 v24.4s, v28.8h, v0.h[0]
    smlal  v25.4s, v29.4h, v0.h[0]
    smlal2 v26.4s, v29.8h, v0.h[0]

    uzp2 v4.8h, v21.8h, v22.8h
    uzp2 v5.8h, v23.8h, v24.8h
    uzp2 v6.8h, v25.8h, v26.8h

    /* Barrett multiplication by R: Algorithm 10 of [BHK+21]. */
    mul v16.8h, v4.8h, v0.h[3]
    mul v17.8h, v5.8h, v0.h[3]
    mul v18.8h, v6.8h, v0.h[3]

    sqrdmulh v4.8h, v4.8h, v0.h[4]
    sqrdmulh v5.8h, v5.8h, v0.h[4]
    sqrdmulh v6.8h, v6.8h, v0.h[4]

    mls v16.8h, v4.8h, v0.h[0]
    mls v17.8h, v5.8h, v0.h[0]
    mls v18.8h, v6.8h, v0.h[0]

    ld1 {v4.8h - v6.8h}, [src3], #48

    add v16.8h, v16.8h, v4.8h
    add v17.8h, v17.8h, v5.8h
    add v18.8h, v18.8h, v6.8h

    /* Barrett reduction after adding c. */
    sqrdmulh v4.8h, v16.8h, v0.h[1]
    sqrdmulh v5.8h, v17.8h, v0.h[1]
    sqrdmulh v6.8h, v18.8h, v0.h[1]

    mls v16.8h, v4.8h, v0.h[0]
    mls v17.8h, v5.8h, v0.h[0]
    mls v18.8h, v6.8h, v0.h[0]

    st1 {v16.8h - v18.8h}, [dst], #48

    subs counter, counter, #48
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
*              - const poly *a:  pointer to the input polynomial
*
* Returns:     none.
**************************************************/
.global poly_baseinv_1
.global _poly_baseinv_1
poly_baseinv_1:
_poly_baseinv_1:
    stp  d8,  d9, [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]

    dst       .req x0
    den       .req x1
    src       .req x2
    zetas_ptr .req x3
    counter   .req x8

    adr zetas_ptr, zetas_mul

    ld1 {v0.8h}, [zetas_ptr], #16

    mov counter, #1728

_looptop_baseinv_1:
    #load
    ld1 {v1.8h, v2.8h}, [zetas_ptr], #32

    #load
    ld1 {v3.8h, v4.8h, v5.8h}, [src], #48
    ld1 {v6.8h, v7.8h, v8.8h}, [src], #48

    /*
     * Montgomery products:
     *   Algorithm 12 of [BHK+21]: a1*a2 and a2*a2.
     *   Algorithm 14 of [BHK+21]: accumulated products.
     */

    mul     v24.8h, v4.8h, v5.8h  //a1*a2
    sqdmulh  v9.8h, v4.8h, v5.8h  //a1*a2
    mul     v25.8h, v7.8h, v8.8h  //a1*a2
    sqdmulh v11.8h, v7.8h, v8.8h  //a1*a2

    mul     v26.8h, v5.8h, v5.8h  //a2*a2
    sqdmulh v13.8h, v5.8h, v5.8h  //a2*a2
    mul     v27.8h, v8.8h, v8.8h  //a2*a2
    sqdmulh v15.8h, v8.8h, v8.8h  //a2*a2

    smull  v17.4s, v4.4h, v4.4h  //a1*a1
    smull2 v18.4s, v4.8h, v4.8h  //a1*a1
    smull  v19.4s, v7.4h, v7.4h  //a1*a1
    smull2 v20.4s, v7.8h, v7.8h  //a1*a1

    smlsl  v17.4s, v3.4h, v5.4h  //-a0*a2
    smlsl2 v18.4s, v3.8h, v5.8h  //-a0*a2
    smlsl  v19.4s, v6.4h, v8.4h  //-a0*a2
    smlsl2 v20.4s, v6.8h, v8.8h  //-a0*a2

    uzp1 v28.8h, v17.8h, v18.8h
    uzp1 v29.8h, v19.8h, v20.8h

    mul v24.8h, v24.8h, v0.h[7]  //r[0]
    mul v25.8h, v25.8h, v0.h[7]  //r[0]
    mul v26.8h, v26.8h, v0.h[7]  //r[1]
    mul v27.8h, v27.8h, v0.h[7]  //r[1]
    mul v28.8h, v28.8h, v0.h[2]  //r[2]
    mul v29.8h, v29.8h, v0.h[2]  //r[2]

    sqdmulh v24.8h, v24.8h, v0.h[0]
    sqdmulh v25.8h, v25.8h, v0.h[0]
    sqdmulh v26.8h, v26.8h, v0.h[0]
    sqdmulh v27.8h, v27.8h, v0.h[0]
    smlal   v17.4s, v28.4h, v0.h[0]
    smlal2  v18.4s, v28.8h, v0.h[0]
    smlal   v19.4s, v29.4h, v0.h[0]
    smlal2  v20.4s, v29.8h, v0.h[0]

    shsub v24.8h,  v9.8h, v24.8h
    shsub v25.8h, v11.8h, v25.8h
    shsub v26.8h, v13.8h, v26.8h
    shsub v27.8h, v15.8h, v27.8h
    uzp2  v28.8h, v17.8h, v18.8h
    uzp2  v29.8h, v19.8h, v20.8h

    smull   v9.4s, v3.4h, v3.4h  //a0*a0
    smull2 v10.4s, v3.8h, v3.8h  //a0*a0
    smull  v11.4s, v6.4h, v6.4h  //a0*a0
    smull2 v12.4s, v6.8h, v6.8h  //a0*a0

    smlal   v9.4s, v24.4h, v2.4h  //-r[0]*zeta
    smlal2 v10.4s, v24.8h, v2.8h  //-r[0]*zeta
    smlal  v11.4s, v25.4h, v1.4h  //-r[0]*zeta
    smlal2 v12.4s, v25.8h, v1.8h  //-r[0]*zeta

    smull  v13.4s, v26.4h, v1.4h  //r[1]*zeta
    smull2 v14.4s, v26.8h, v1.8h  //r[1]*zeta
    smull  v15.4s, v27.4h, v2.4h  //r[1]*zeta
    smull2 v16.4s, v27.8h, v2.8h  //r[1]*zeta

    smlsl  v13.4s, v3.4h, v4.4h  //-a0*a1
    smlsl2 v14.4s, v3.8h, v4.8h  //-a0*a1
    smlsl  v15.4s, v6.4h, v7.4h  //-a0*a1
    smlsl2 v16.4s, v6.8h, v7.8h  //-a0*a1

    uzp1 v24.8h,  v9.8h, v10.8h
    uzp1 v25.8h, v11.8h, v12.8h
    uzp1 v26.8h, v13.8h, v14.8h
    uzp1 v27.8h, v15.8h, v16.8h

    mul v24.8h, v24.8h, v0.h[2]
    mul v25.8h, v25.8h, v0.h[2]
    mul v26.8h, v26.8h, v0.h[2]
    mul v27.8h, v27.8h, v0.h[2]

    smlal   v9.4s, v24.4h, v0.h[0]
    smlal2 v10.4s, v24.8h, v0.h[0]
    smlal  v11.4s, v25.4h, v0.h[0]
    smlal2 v12.4s, v25.8h, v0.h[0]
    smlal  v13.4s, v26.4h, v0.h[0]
    smlal2 v14.4s, v26.8h, v0.h[0]
    smlal  v15.4s, v27.4h, v0.h[0]
    smlal2 v16.4s, v27.8h, v0.h[0]

    uzp2 v24.8h,  v9.8h, v10.8h  //r[0]
    uzp2 v25.8h, v11.8h, v12.8h  //r[0]
    uzp2 v26.8h, v13.8h, v14.8h  //r[1]
    uzp2 v27.8h, v15.8h, v16.8h  //r[1]

    smull   v9.4s, v28.4h, v4.4h  //r[2]*a1
    smull2 v10.4s, v28.8h, v4.8h  //r[2]*a1
    smull  v11.4s, v29.4h, v7.4h  //r[2]*a1
    smull2 v12.4s, v29.8h, v7.8h  //r[2]*a1

    smlal   v9.4s, v26.4h, v5.4h  //r[1]*a2
    smlal2 v10.4s, v26.8h, v5.8h  //r[1]*a2
    smlal  v11.4s, v27.4h, v8.4h  //r[1]*a2
    smlal2 v12.4s, v27.8h, v8.8h  //r[1]*a2

    uzp1 v30.8h,  v9.8h, v10.8h
    uzp1 v31.8h, v11.8h, v12.8h

    mul v30.8h, v30.8h, v0.h[2]
    mul v31.8h, v31.8h, v0.h[2]

    smlal   v9.4s, v30.4h, v0.h[0]
    smlal2 v10.4s, v30.8h, v0.h[0]
    smlal  v11.4s, v31.4h, v0.h[0]
    smlal2 v12.4s, v31.8h, v0.h[0]

    uzp2 v30.8h,  v9.8h, v10.8h
    uzp2 v31.8h, v11.8h, v12.8h

    smull   v9.4s, v30.4h, v1.4h  //det*zeta
    smull2 v10.4s, v30.8h, v1.8h  //det*zeta
    smull  v11.4s, v31.4h, v2.4h  //det*zeta
    smull2 v12.4s, v31.8h, v2.8h  //det*zeta

    smlal   v9.4s, v24.4h, v3.4h  //r[0]*a[0]
    smlal2 v10.4s, v24.8h, v3.8h  //r[0]*a[0]
    smlal  v11.4s, v25.4h, v6.4h  //r[0]*a[0]
    smlal2 v12.4s, v25.8h, v6.8h  //r[0]*a[0]

    uzp1 v13.8h,  v9.8h, v10.8h
    uzp1 v14.8h, v11.8h, v12.8h

    mul v13.8h, v13.8h, v0.h[2]
    mul v14.8h, v14.8h, v0.h[2]

    smlal   v9.4s, v13.4h, v0.h[0]
    smlal2 v10.4s, v13.8h, v0.h[0]
    smlal  v11.4s, v14.4h, v0.h[0]
    smlal2 v12.4s, v14.8h, v0.h[0]

    uzp2 v30.8h,  v9.8h, v10.8h
    uzp2 v31.8h, v11.8h, v12.8h

    st1 {v30.8h - v31.8h}, [den], #32

    st1 {v24.8h}, [dst], #16
    st1 {v26.8h}, [dst], #16
    st1 {v28.8h}, [dst], #16
    st1 {v25.8h}, [dst], #16
    st1 {v27.8h}, [dst], #16
    st1 {v29.8h}, [dst], #16

    subs counter, counter, #96
    b.ne _looptop_baseinv_1

    .unreq dst
    .unreq den
    .unreq src
    .unreq zetas_ptr
    .unreq counter

    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp  d8,  d9, [sp], #64
    ret

.align 4
zetas_mul:
    .hword 0x0d81, 0x0009, 0xcd7f, 0xff6d, 0xfa8f, 0xf9dd, 0xc5d5, 0x3281
    .hword 0xfad5, 0x00a3, 0x0135, 0x03d5, 0xfdd3, 0xfefe, 0x00e8, 0xf970
    .hword 0x052b, 0xff5d, 0xfecb, 0xfc2b, 0x022d, 0x0102, 0xff18, 0x0690
    .hword 0xf987, 0xfb2f, 0x0090, 0x06a3, 0x0137, 0xfbdc, 0x0242, 0x0512
    .hword 0x0679, 0x04d1, 0xff70, 0xf95d, 0xfec9, 0x0424, 0xfdbe, 0xfaee
    .hword 0xfe6d, 0x0647, 0x0432, 0xff6c, 0x01bf, 0xf9e0, 0x0476, 0xfe6e
    .hword 0x0193, 0xf9b9, 0xfbce, 0x0094, 0xfe41, 0x0620, 0xfb8a, 0x0192
    .hword 0xfa7c, 0xfd91, 0x0357, 0x016d, 0xff9e, 0xff0c, 0x0197, 0x04c9
    .hword 0x0584, 0x026f, 0xfca9, 0xfe93, 0x0062, 0x00f4, 0xfe69, 0xfb37
    .hword 0x01a0, 0x02ab, 0xff97, 0x06b2, 0xfc05, 0x0425, 0x048b, 0x027e
    .hword 0xfe60, 0xfd55, 0x0069, 0xf94e, 0x03fb, 0xfbdb, 0xfb75, 0xfd82
    .hword 0x031e, 0x05d5, 0xfea1, 0x018c, 0xfde2, 0xfff7, 0x0650, 0xff75
    .hword 0xfce2, 0xfa2b, 0x015f, 0xfe74, 0x021e, 0x0009, 0xf9b0, 0x008b
    .hword 0xfc25, 0xfe1e, 0x0379, 0x00ee, 0xfa17, 0x01d2, 0xfbbf, 0xff9b
    .hword 0x03db, 0x01e2, 0xfc87, 0xff12, 0x05e9, 0xfe2e, 0x0441, 0x0065
    .hword 0x0351, 0xfe56, 0x0635, 0x05cf, 0x029f, 0x05b3, 0xfcf8, 0x00ff
    .hword 0xfcaf, 0x01aa, 0xf9cb, 0xfa31, 0xfd61, 0xfa4d, 0x0308, 0xff01
    .hword 0xfc0a, 0x0478, 0x01d8, 0xfb7f, 0xfebb, 0x05ef, 0xffe6, 0xfb9d
    .hword 0x03f6, 0xfb88, 0xfe28, 0x0481, 0x0145, 0xfa11, 0x001a, 0x0463
    .hword 0x0144, 0x04ce, 0x060b, 0xfdaf, 0xfe54, 0x04a8, 0x0430, 0xf9e4
    .hword 0xfebc, 0xfb32, 0xf9f5, 0x0251, 0x01ac, 0xfb58, 0xfbd0, 0x061c
    .hword 0x02b0, 0xfeb3, 0x03ff, 0xf96a, 0x0349, 0x0338, 0xffb9, 0x0633
    .hword 0xfd50, 0x014d, 0xfc01, 0x0696, 0xfcb7, 0xfcc8, 0x0047, 0xf9cd
    .hword 0x020a, 0xfebd, 0x047c, 0x0185, 0x04cf, 0x0180, 0x053f, 0x00a9
    .hword 0xfdf6, 0x0143, 0xfb84, 0xfe7b, 0xfb31, 0xfe80, 0xfac1, 0xff57
    .hword 0x0274, 0xfacf, 0xfbe0, 0xfc58, 0x0018, 0xfedb, 0x05f3, 0xfed4
    .hword 0xfd8c, 0x0531, 0x0420, 0x03a8, 0xffe8, 0x0125, 0xfa0d, 0x012c
    .hword 0xf98a, 0x037b, 0xfc3e, 0xffbd, 0x00b3, 0xfb67, 0x034c, 0xfe03
    .hword 0x0676, 0xfc85, 0x03c2, 0x0043, 0xff4d, 0x0499, 0xfcb4, 0x01fd
    .hword 0xf973, 0xf9e3, 0xfddb, 0xfa1c, 0x04a7, 0xfee8, 0xffd5, 0x029d
    .hword 0x068d, 0x061d, 0x0225, 0x05e4, 0xfb59, 0x0118, 0x002b, 0xfd63
    .hword 0xfd16, 0x02f1, 0x0302, 0xfbea, 0x06af, 0x059e, 0x02b2, 0x043b
    .hword 0x02ea, 0xfd0f, 0xfcfe, 0x0416, 0xf951, 0xfa62, 0xfd4e, 0xfbc5
    .hword 0x0426, 0x06bf, 0xfc8d, 0x0229, 0x0686, 0x0042, 0x0339, 0xff7b
    .hword 0xfbda, 0xf941, 0x0373, 0xfdd7, 0xf97a, 0xffbe, 0xfcc7, 0x0085
    .hword 0xf9ce, 0x027d, 0xfd58, 0xfc6b, 0x0284, 0xfe8c, 0xfb57, 0xfb90
    .hword 0x0632, 0xfd83, 0x02a8, 0x0395, 0xfd7c, 0x0174, 0x04a9, 0x0470


/*
 * Barrett twiddles: Algorithm 10 of [BHK+21].
 * The twiddle entries of zetas_mul contain zeta*R, with R = 2^16.
 * After the common constants, each block contains centered zeta followed
 * by round(2^15*zeta/q), in the same lane order as zetas_mul.
 */
.align 4
zetas_pretwist:
    .hword 0x0d81, 0x0009, 0xcd7f, 0xff6d, 0xfa8f, 0xf9dd, 0xc5d5, 0x3281
    .hword 0x0009, 0xfde2, 0x008b, 0x0650, 0xfe74, 0xfea1, 0x031e, 0x05d5
    .hword 0x0055, 0xebef, 0x0526, 0x3bd6, 0xf156, 0xf301, 0x1d8c, 0x3748
    .hword 0xfff7, 0x021e, 0xff75, 0xf9b0, 0x018c, 0x015f, 0xfce2, 0xfa2b
    .hword 0xffab, 0x1411, 0xfada, 0xc42a, 0x0eaa, 0x0cff, 0xe274, 0xc8b8
    .hword 0xfe93, 0x0357, 0xfa7c, 0xfd91, 0xfb37, 0x0197, 0xff9e, 0xff0c
    .hword 0xf27c, 0x1fa8, 0xcbb8, 0xe8ef, 0xd2a5, 0x0f12, 0xfc5f, 0xf6f7
    .hword 0x016d, 0xfca9, 0x0584, 0x026f, 0x04c9, 0xfe69, 0x0062, 0x00f4
    .hword 0x0d84, 0xe058, 0x3448, 0x1711, 0x2d5b, 0xf0ee, 0x03a1, 0x0909
    .hword 0xf94e, 0xff97, 0x01a0, 0x02ab, 0xfd82, 0x048b, 0xfc05, 0x0425
    .hword 0xc089, 0xfc1d, 0x0f67, 0x194a, 0xe861, 0x2b10, 0xda45, 0x2749
    .hword 0x06b2, 0x0069, 0xfe60, 0xfd55, 0x027e, 0xfb75, 0x03fb, 0xfbdb
    .hword 0x3f77, 0x03e3, 0xf099, 0xe6b6, 0x179f, 0xd4f0, 0x25bb, 0xd8b7
    .hword 0xfa11, 0xfebb, 0x0463, 0xffe6, 0x0481, 0x01d8, 0xfc0a, 0x0478
    .hword 0xc7c2, 0xf3f7, 0x2995, 0xff0a, 0x2ab1, 0x117a, 0xda75, 0x2a5c
    .hword 0x05ef, 0x0145, 0xfb9d, 0x001a, 0xfb7f, 0xfe28, 0x03f6, 0xfb88
    .hword 0x383e, 0x0c09, 0xd66b, 0x00f6, 0xd54f, 0xee86, 0x258b, 0xd5a4
    .hword 0xff12, 0x0379, 0xfc25, 0xfe1e, 0x0065, 0xfbbf, 0xfa17, 0x01d2
    .hword 0xf730, 0x20eb, 0xdb74, 0xee27, 0x03bd, 0xd7ae, 0xc7fb, 0x1141
    .hword 0x00ee, 0xfc87, 0x03db, 0x01e2, 0xff9b, 0x0441, 0x05e9, 0xfe2e
    .hword 0x08d0, 0xdf15, 0x248c, 0x11d9, 0xfc43, 0x2852, 0x3805, 0xeebf
    .hword 0xfa31, 0x0635, 0x0351, 0xfe56, 0xff01, 0xfcf8, 0x029f, 0x05b3
    .hword 0xc8f1, 0x3ad6, 0x1f6f, 0xf03a, 0xf68f, 0xe344, 0x18d8, 0x3605
    .hword 0x05cf, 0xf9cb, 0xfcaf, 0x01aa, 0x00ff, 0x0308, 0xfd61, 0xfa4d
    .hword 0x370f, 0xc52a, 0xe091, 0x0fc6, 0x0971, 0x1cbc, 0xe728, 0xc9fb
    .hword 0xfc2b, 0x0135, 0xfad5, 0x00a3, 0x0690, 0x00e8, 0xfdd3, 0xfefe
    .hword 0xdbad, 0x0b71, 0xcf04, 0x0609, 0x3e34, 0x0897, 0xeb60, 0xf672
    .hword 0x03d5, 0xfecb, 0x052b, 0xff5d, 0xf970, 0xff18, 0x022d, 0x0102
    .hword 0x2453, 0xf48f, 0x30fc, 0xf9f7, 0xc1cc, 0xf769, 0x14a0, 0x098e
    .hword 0xf95d, 0x0090, 0xf987, 0xfb2f, 0xfaee, 0x0242, 0x0137, 0xfbdc
    .hword 0xc118, 0x0555, 0xc2a6, 0xd259, 0xcff1, 0x1567, 0x0b84, 0xd8c1
    .hword 0x06a3, 0xff70, 0x0679, 0x04d1, 0x0512, 0xfdbe, 0xfec9, 0x0424
    .hword 0x3ee8, 0xfaab, 0x3d5a, 0x2da7, 0x300f, 0xea99, 0xf47c, 0x273f
    .hword 0x0094, 0x0432, 0xfe6d, 0x0647, 0x0192, 0x0476, 0x01bf, 0xf9e0
    .hword 0x057b, 0x27c4, 0xf114, 0x3b80, 0x0ee2, 0x2a49, 0x108d, 0xc5f1
    .hword 0xff6c, 0xfbce, 0x0193, 0xf9b9, 0xfe6e, 0xfb8a, 0xfe41, 0x0620
    .hword 0xfa85, 0xd83c, 0x0eec, 0xc480, 0xf11e, 0xd5b7, 0xef73, 0x3a0f
    .hword 0x0118, 0x04a7, 0xfd63, 0xffd5, 0x05e4, 0xfddb, 0xf973, 0xf9e3
    .hword 0x0a5e, 0x2c19, 0xe73b, 0xfe68, 0x37d6, 0xebac, 0xc1e8, 0xc60e
    .hword 0xfee8, 0xfb59, 0x029d, 0x002b, 0xfa1c, 0x0225, 0x068d, 0x061d
    .hword 0xf5a2, 0xd3e7, 0x18c5, 0x0198, 0xc82a, 0x1454, 0x3e18, 0x39f2
    .hword 0x03a8, 0xfbe0, 0x0274, 0xfacf, 0x012c, 0x05f3, 0x0018, 0xfedb
    .hword 0x22a8, 0xd8e6, 0x1741, 0xcecb, 0x0b1c, 0x3864, 0x00e3, 0xf527
    .hword 0xfc58, 0x0420, 0xfd8c, 0x0531, 0xfed4, 0xfa0d, 0xffe8, 0x0125
    .hword 0xdd58, 0x271a, 0xe8bf, 0x3135, 0xf4e4, 0xc79c, 0xff1d, 0x0ad9
    .hword 0x0043, 0xfc3e, 0xf98a, 0x037b, 0x01fd, 0x034c, 0x00b3, 0xfb67
    .hword 0x027b, 0xdc61, 0xc2c2, 0x20fe, 0x12d9, 0x1f40, 0x06a1, 0xd46c
    .hword 0xffbd, 0x03c2, 0x0676, 0xfc85, 0xfe03, 0xfcb4, 0xff4d, 0x0499
    .hword 0xfd85, 0x239f, 0x3d3e, 0xdf02, 0xed27, 0xe0c0, 0xf95f, 0x2b94
    .hword 0x0174, 0x0284, 0x0470, 0xfb57, 0x0395, 0xfd58, 0xf9ce, 0x027d
    .hword 0x0dc6, 0x17d8, 0x2a10, 0xd3d4, 0x21f4, 0xe6d2, 0xc547, 0x1796
    .hword 0xfe8c, 0xfd7c, 0xfb90, 0x04a9, 0xfc6b, 0x02a8, 0x0632, 0xfd83
    .hword 0xf23a, 0xe828, 0xd5f0, 0x2c2c, 0xde0c, 0x192e, 0x3ab9, 0xe86a
    .hword 0x0416, 0x0302, 0xfd16, 0x02f1, 0xfbc5, 0x02b2, 0x06af, 0x059e
    .hword 0x26bb, 0x1c83, 0xe461, 0x1be1, 0xd7e7, 0x198c, 0x3f5a, 0x353e
    .hword 0xfbea, 0xfcfe, 0x02ea, 0xfd0f, 0x043b, 0xfd4e, 0xf951, 0xfa62
    .hword 0xd945, 0xe37d, 0x1b9f, 0xe41f, 0x2819, 0xe674, 0xc0a6, 0xcac2
    .hword 0xfdd7, 0xfc8d, 0x0426, 0x06bf, 0x0085, 0x0339, 0x0686, 0x0042
    .hword 0xeb86, 0xdf4e, 0x2752, 0x3ff2, 0x04ed, 0x1e8c, 0x3dd5, 0x0272
    .hword 0x0229, 0x0373, 0xfbda, 0xf941, 0xff7b, 0xfcc7, 0xf97a, 0xffbe
    .hword 0x147a, 0x20b2, 0xd8ae, 0xc00e, 0xfb13, 0xe174, 0xc22b, 0xfd8e
    .hword 0x0251, 0x060b, 0x0144, 0x04ce, 0x061c, 0x0430, 0xfe54, 0x04a8
    .hword 0x15f5, 0x3948, 0x0bff, 0x2d8b, 0x39e9, 0x27b1, 0xf027, 0x2c23
    .hword 0xfdaf, 0xf9f5, 0xfebc, 0xfb32, 0xf9e4, 0xfbd0, 0x01ac, 0xfb58
    .hword 0xea0b, 0xc6b8, 0xf401, 0xd275, 0xc617, 0xd84f, 0x0fd9, 0xd3dd
    .hword 0x0696, 0x03ff, 0x02b0, 0xfeb3, 0xf9cd, 0xffb9, 0x0349, 0x0338
    .hword 0x3e6d, 0x25e1, 0x1979, 0xf3ac, 0xc53d, 0xfd5f, 0x1f24, 0x1e82
    .hword 0xf96a, 0xfc01, 0xfd50, 0x014d, 0x0633, 0x0047, 0xfcb7, 0xfcc8
    .hword 0xc193, 0xda1f, 0xe687, 0x0c54, 0x3ac3, 0x02a1, 0xe0dc, 0xe17e
    .hword 0xfe7b, 0x047c, 0x020a, 0xfebd, 0xff57, 0x053f, 0x04cf, 0x0180
    .hword 0xf199, 0x2a82, 0x1354, 0xf40a, 0xf9be, 0x31ba, 0x2d94, 0x0e38
    .hword 0x0185, 0xfb84, 0xfdf6, 0x0143, 0x00a9, 0xfac1, 0xfb31, 0xfe80
    .hword 0x0e67, 0xd57e, 0xecac, 0x0bf6, 0x0642, 0xce46, 0xd26c, 0xf1c8
