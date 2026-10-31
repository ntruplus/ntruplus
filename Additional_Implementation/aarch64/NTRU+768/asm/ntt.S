#include "consts.h"

/*
 * References:
 *
 * [BHK+21] Hanno Becker, Vincent Hwang, Matthias J. Kannwischer,
 * Bo-Yin Yang, and Shang-Yi Yang,
 * "Neon NTT: Faster Dilithium, Kyber, and Saber
 * on Cortex-A72 and Apple M1", IACR Transactions on Cryptographic
 * Hardware and Embedded Systems, 2022(1), pp. 221-244.
 * https://doi.org/10.46586/tches.v2022.i1.221-244
 * Algorithms 10 and 14 are used below.
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
* Name:        poly_ntt
*
* Description: Transforms a polynomial from coefficient representation to
*              the incomplete NTT representation.
*
* Reference:   Algorithm 10 of [BHK+21].
*
* Arguments:   - poly *r: pointer to the input/output polynomial;
*                         input coefficients must lie in [-3,4]
*
* Returns:     none. Output coefficients lie in [-q+1,q-1].
**************************************************/
.global poly_ntt
.global _poly_ntt
poly_ntt:
_poly_ntt:

    dst       .req x0
    src       .req x1
    zetas_ptr .req x2
    counter   .req x8

    mov src, dst
    load_address zetas_ptr, zetas

    ld1 {v0.8h - v3.8h}, [zetas_ptr], #64

    mov counter, #128

_looptop_012:

    # v0-v3: constants; v4-v7/v16-v23: coefficients; v24-v29: temporaries.
    # Input range: [-3,4].
    #level 0
    ldr q18, [src, #6*128]
    ldr q19, [src, #7*128]
    ldr q20, [src, #8*128]
    ldr q21, [src, #9*128]
    ldr q22, [src, #10*128]
    ldr q23, [src, #11*128]

    # The raw -722 products fit in signed 16 bits.
    mul v24.8h, v18.8h, v0.h[4]
    mul v25.8h, v19.8h, v0.h[4]
    mul v26.8h, v20.8h, v0.h[4]
    mul v27.8h, v21.8h, v0.h[4]
    mul v28.8h, v22.8h, v0.h[4]
    mul v29.8h, v23.8h, v0.h[4]

    #update 1
    sub v18.8h, v18.8h, v24.8h
    sub v19.8h, v19.8h, v25.8h
    sub v20.8h, v20.8h, v26.8h
    sub v21.8h, v21.8h, v27.8h
    sub v22.8h, v22.8h, v28.8h
    sub v23.8h, v23.8h, v29.8h

    #load 2
    ldr  q4, [src, #0*128]
    ldr  q5, [src, #1*128]
    ldr  q6, [src, #2*128]
    ldr  q7, [src, #3*128]
    ldr q16, [src, #4*128]
    ldr q17, [src, #5*128]

    #update 2
    add v18.8h, v18.8h,  v4.8h
    add v19.8h, v19.8h,  v5.8h
    add v20.8h, v20.8h,  v6.8h
    add v21.8h, v21.8h,  v7.8h
    add v22.8h, v22.8h, v16.8h
    add v23.8h, v23.8h, v17.8h

    add  v4.8h,  v4.8h, v24.8h
    add  v5.8h,  v5.8h, v25.8h
    add  v6.8h,  v6.8h, v26.8h
    add  v7.8h,  v7.8h, v27.8h
    add v16.8h, v16.8h, v28.8h
    add v17.8h, v17.8h, v29.8h

    # Range after level 0: [-2891,2896].
    #level 1
    #mul 1
    mul v24.8h,  v6.8h, v0.h[6]
    mul v25.8h,  v7.8h, v0.h[6]
    mul v26.8h, v16.8h, v1.h[0]
    mul v27.8h, v17.8h, v1.h[0]

    sqrdmulh  v6.8h,  v6.8h, v0.h[7]
    sqrdmulh  v7.8h,  v7.8h, v0.h[7]
    sqrdmulh v16.8h, v16.8h, v1.h[1]
    sqrdmulh v17.8h, v17.8h, v1.h[1]

    mls v24.8h,  v6.8h, v0.h[0]  //t1
    mls v25.8h,  v7.8h, v0.h[0]  //t1
    mls v26.8h, v16.8h, v0.h[0]  //t2
    mls v27.8h, v17.8h, v0.h[0]  //t2

    sub v6.8h, v24.8h, v26.8h
    sub v7.8h, v25.8h, v27.8h

    #mul 2
    mul v28.8h, v6.8h, v0.h[2]
    mul v29.8h, v7.8h, v0.h[2]

    sqrdmulh v6.8h, v6.8h, v0.h[3]
    sqrdmulh v7.8h, v7.8h, v0.h[3]

    mls v28.8h, v6.8h, v0.h[0]  //t3
    mls v29.8h, v7.8h, v0.h[0]  //t3

    #update
    sub v16.8h, v4.8h, v24.8h  //r[i] - t1
    sub v17.8h, v5.8h, v25.8h  //r[i] - t1

    sub v6.8h, v4.8h, v26.8h  //r[i] - t2
    sub v7.8h, v5.8h, v27.8h  //r[i] - t2

    add v4.8h, v4.8h, v24.8h  //r[i] + t1
    add v5.8h, v5.8h, v25.8h  //r[i] + t1

    sub v16.8h, v16.8h, v28.8h  //r[i] - t1 - t3
    sub v17.8h, v17.8h, v29.8h  //r[i] - t1 - t3

    add v6.8h, v6.8h, v28.8h  //r[i] - t2 + t3
    add v7.8h, v7.8h, v29.8h  //r[i] - t2 + t3

    add v4.8h, v4.8h, v26.8h  //r[i] + t1 + t2
    add v5.8h, v5.8h, v27.8h  //r[i] + t1 + t2

    #mul 1
    mul v24.8h, v20.8h, v1.h[2]
    mul v25.8h, v21.8h, v1.h[2]
    mul v26.8h, v22.8h, v1.h[4]
    mul v27.8h, v23.8h, v1.h[4]

    sqrdmulh v20.8h, v20.8h, v1.h[3]
    sqrdmulh v21.8h, v21.8h, v1.h[3]
    sqrdmulh v22.8h, v22.8h, v1.h[5]
    sqrdmulh v23.8h, v23.8h, v1.h[5]

    mls v24.8h, v20.8h, v0.h[0]  //t1
    mls v25.8h, v21.8h, v0.h[0]  //t1
    mls v26.8h, v22.8h, v0.h[0]  //t2
    mls v27.8h, v23.8h, v0.h[0]  //t2

    sub v20.8h, v24.8h, v26.8h
    sub v21.8h, v25.8h, v27.8h

    #mul 2
    mul v28.8h, v20.8h, v0.h[2]
    mul v29.8h, v21.8h, v0.h[2]

    sqrdmulh v20.8h, v20.8h, v0.h[3]
    sqrdmulh v21.8h, v21.8h, v0.h[3]

    mls v28.8h, v20.8h, v0.h[0]  //t3
    mls v29.8h, v21.8h, v0.h[0]  //t3

    #update
    sub v22.8h, v18.8h, v24.8h  //r[i] - t1
    sub v23.8h, v19.8h, v25.8h  //r[i] - t1

    sub v20.8h, v18.8h, v26.8h  //r[i] - t2
    sub v21.8h, v19.8h, v27.8h  //r[i] - t2

    add v18.8h, v18.8h, v24.8h  //r[i] + t1
    add v19.8h, v19.8h, v25.8h  //r[i] + t1

    sub v22.8h, v22.8h, v28.8h  //r[i] - t1 - t3
    sub v23.8h, v23.8h, v29.8h  //r[i] - t1 - t3

    add v20.8h, v20.8h, v28.8h  //r[i] - t2 + t3
    add v21.8h, v21.8h, v29.8h  //r[i] - t2 + t3

    add v18.8h, v18.8h, v26.8h  //r[i] + t1 + t2
    add v19.8h, v19.8h, v27.8h  //r[i] + t1 + t2

    # Range after level 1: [-6406,6418].
    # Radix-3 intermediate ranges: t1-t2 in [-3503,3491], t3 in [-1767,1767].
    #level 2
    #mul 1
    mul v24.8h,  v5.8h, v1.h[6]
    mul v25.8h,  v7.8h, v2.h[0]
    mul v26.8h, v17.8h, v2.h[2]

    sqrdmulh  v5.8h,  v5.8h, v1.h[7]
    sqrdmulh  v7.8h,  v7.8h, v2.h[1]
    sqrdmulh v17.8h, v17.8h, v2.h[3]

    mls v24.8h,  v5.8h, v0.h[0]  //t1
    mls v25.8h,  v7.8h, v0.h[0]  //t1
    mls v26.8h, v17.8h, v0.h[0]  //t1

    mul v27.8h, v19.8h, v2.h[4]
    mul v28.8h, v21.8h, v2.h[6]
    mul v29.8h, v23.8h, v3.h[0]

    sqrdmulh v19.8h, v19.8h, v2.h[5]
    sqrdmulh v21.8h, v21.8h, v2.h[7]
    sqrdmulh v23.8h, v23.8h, v3.h[1]

    mls v27.8h, v19.8h, v0.h[0]  //t2
    mls v28.8h, v21.8h, v0.h[0]  //t2
    mls v29.8h, v23.8h, v0.h[0]  //t2

    #update
    sub  v5.8h,  v4.8h, v24.8h
    sub  v7.8h,  v6.8h, v25.8h
    sub v17.8h, v16.8h, v26.8h
    sub v19.8h, v18.8h, v27.8h
    sub v21.8h, v20.8h, v28.8h
    sub v23.8h, v22.8h, v29.8h

    add  v4.8h,  v4.8h, v24.8h
    add  v6.8h,  v6.8h, v25.8h
    add v16.8h, v16.8h, v26.8h
    add v18.8h, v18.8h, v27.8h
    add v20.8h, v20.8h, v28.8h
    add v22.8h, v22.8h, v29.8h

    # Range after level 2: [-8415,8417].
    str  q4, [dst, #0*128]
    str  q5, [dst, #1*128]
    str  q6, [dst, #2*128]
    str  q7, [dst, #3*128]
    str q16, [dst, #4*128]
    str q17, [dst, #5*128]
    str q18, [dst, #6*128]
    str q19, [dst, #7*128]
    str q20, [dst, #8*128]
    str q21, [dst, #9*128]
    str q22, [dst, #10*128]
    str q23, [dst, #11*128]

    add src, src, #16
    add dst, dst, #16
    subs counter, counter, #16
    b.ne _looptop_012

    sub src, src, #128
    sub dst, dst, #128

    mov counter, #1536

_looptop_3456:

    # v0-v3: constants; v4-v7/v16-v19: coefficients; v20-v31: temporaries.
    #zeta
    ld1 {v0.8h - v3.8h}, [zetas_ptr], #64

    #load
    ldr  q4, [dst, #0*16]
    ldr  q5, [dst, #1*16]
    ldr  q6, [dst, #2*16]
    ldr  q7, [dst, #3*16]
    ldr q16, [dst, #4*16]
    ldr q17, [dst, #5*16]
    ldr q18, [dst, #6*16]
    ldr q19, [dst, #7*16]

    #level 3
    #mul
    mul v20.8h, v16.8h, v0.h[2]
    mul v21.8h, v17.8h, v0.h[2]
    mul v22.8h, v18.8h, v0.h[2]
    mul v23.8h, v19.8h, v0.h[2]

    sqrdmulh v16.8h, v16.8h, v0.h[3]
    sqrdmulh v17.8h, v17.8h, v0.h[3]
    sqrdmulh v18.8h, v18.8h, v0.h[3]
    sqrdmulh v19.8h, v19.8h, v0.h[3]

    mls v20.8h, v16.8h, v0.h[0]
    mls v21.8h, v17.8h, v0.h[0]
    mls v22.8h, v18.8h, v0.h[0]
    mls v23.8h, v19.8h, v0.h[0]

    #update
    sub v16.8h, v4.8h, v20.8h
    sub v17.8h, v5.8h, v21.8h
    sub v18.8h, v6.8h, v22.8h
    sub v19.8h, v7.8h, v23.8h

    add v4.8h, v4.8h, v20.8h
    add v5.8h, v5.8h, v21.8h
    add v6.8h, v6.8h, v22.8h
    add v7.8h, v7.8h, v23.8h

    # Range after level 3: [-10346,10497].
    #level 4
    #mul
    mul v20.8h,  v6.8h, v0.h[4]
    mul v21.8h,  v7.8h, v0.h[4]
    mul v22.8h, v18.8h, v0.h[6]
    mul v23.8h, v19.8h, v0.h[6]

    sqrdmulh  v6.8h,  v6.8h, v0.h[5]
    sqrdmulh  v7.8h,  v7.8h, v0.h[5]
    sqrdmulh v18.8h, v18.8h, v0.h[7]
    sqrdmulh v19.8h, v19.8h, v0.h[7]

    mls v20.8h,  v6.8h, v0.h[0]
    mls v21.8h,  v7.8h, v0.h[0]
    mls v22.8h, v18.8h, v0.h[0]
    mls v23.8h, v19.8h, v0.h[0]

    #update
    sub  v6.8h,  v4.8h, v20.8h
    sub  v7.8h,  v5.8h, v21.8h
    sub v18.8h, v16.8h, v22.8h
    sub v19.8h, v17.8h, v23.8h

    add  v4.8h,  v4.8h, v20.8h
    add  v5.8h,  v5.8h, v21.8h
    add v16.8h, v16.8h, v22.8h
    add v17.8h, v17.8h, v23.8h

    # Range after level 4: [-12452,12680].
    #level 5
    #mul
    mul v20.8h,  v5.8h, v1.h[0]
    mul v21.8h,  v7.8h, v1.h[2]
    mul v22.8h, v17.8h, v1.h[4]
    mul v23.8h, v19.8h, v1.h[6]

    sqrdmulh  v5.8h,  v5.8h, v1.h[1]
    sqrdmulh  v7.8h,  v7.8h, v1.h[3]
    sqrdmulh v17.8h, v17.8h, v1.h[5]
    sqrdmulh v19.8h, v19.8h, v1.h[7]

    mls v20.8h,  v5.8h, v0.h[0]
    mls v21.8h,  v7.8h, v0.h[0]
    mls v22.8h, v17.8h, v0.h[0]
    mls v23.8h, v19.8h, v0.h[0]

    #update
    sub  v5.8h,  v4.8h, v20.8h
    sub  v7.8h,  v6.8h, v21.8h
    sub v17.8h, v16.8h, v22.8h
    sub v19.8h, v18.8h, v23.8h

    add  v4.8h,  v4.8h, v20.8h
    add  v6.8h,  v6.8h, v21.8h
    add v16.8h, v16.8h, v22.8h
    add v18.8h, v18.8h, v23.8h

    # Range after level 5: [-14604,14789].
    #shuffle
    trn1 v20.2d, v4.2d, v16.2d
    trn2 v21.2d, v4.2d, v16.2d
    trn1 v22.2d, v5.2d, v17.2d
    trn2 v23.2d, v5.2d, v17.2d
    trn1 v24.2d, v6.2d, v18.2d
    trn2 v25.2d, v6.2d, v18.2d
    trn1 v26.2d, v7.2d, v19.2d
    trn2 v27.2d, v7.2d, v19.2d

    trn1 v28.4s, v20.4s, v24.4s
    trn2 v29.4s, v20.4s, v24.4s
    trn1 v30.4s, v21.4s, v25.4s
    trn2 v31.4s, v21.4s, v25.4s
    trn1 v24.4s, v22.4s, v26.4s
    trn2 v25.4s, v22.4s, v26.4s
    trn1 v26.4s, v23.4s, v27.4s
    trn2 v27.4s, v23.4s, v27.4s

    trn1  v4.8h, v28.8h, v24.8h
    trn2  v5.8h, v28.8h, v24.8h
    trn1  v6.8h, v29.8h, v25.8h
    trn2  v7.8h, v29.8h, v25.8h
    trn1 v16.8h, v30.8h, v26.8h
    trn2 v17.8h, v30.8h, v26.8h
    trn1 v18.8h, v31.8h, v27.8h
    trn2 v19.8h, v31.8h, v27.8h

    #level 6
    #mul
    mul v20.8h, v16.8h, v2.8h
    mul v21.8h, v17.8h, v2.8h
    mul v22.8h, v18.8h, v2.8h
    mul v23.8h, v19.8h, v2.8h

    sqrdmulh v16.8h, v16.8h, v3.8h
    sqrdmulh v17.8h, v17.8h, v3.8h
    sqrdmulh v18.8h, v18.8h, v3.8h
    sqrdmulh v19.8h, v19.8h, v3.8h

    mls v20.8h, v16.8h, v0.h[0]
    mls v21.8h, v17.8h, v0.h[0]
    mls v22.8h, v18.8h, v0.h[0]
    mls v23.8h, v19.8h, v0.h[0]

    #update
    sub v16.8h, v4.8h, v20.8h
    sub v17.8h, v5.8h, v21.8h
    sub v18.8h, v6.8h, v22.8h
    sub v19.8h, v7.8h, v23.8h

    add v4.8h, v4.8h, v20.8h
    add v5.8h, v5.8h, v21.8h
    add v6.8h, v6.8h, v22.8h
    add v7.8h, v7.8h, v23.8h

    # Range after level 6: [-16979,17204].
    #Barrett reduction
    sqrdmulh v20.8h, v16.8h, v0.h[1]
    sqrdmulh v21.8h, v17.8h, v0.h[1]
    sqrdmulh v22.8h, v18.8h, v0.h[1]
    sqrdmulh v23.8h, v19.8h, v0.h[1]

    mls v16.8h, v20.8h, v0.h[0]
    mls v17.8h, v21.8h, v0.h[0]
    mls v18.8h, v22.8h, v0.h[0]
    mls v19.8h, v23.8h, v0.h[0]

    sqrdmulh v24.8h, v4.8h, v0.h[1]
    sqrdmulh v25.8h, v5.8h, v0.h[1]
    sqrdmulh v26.8h, v6.8h, v0.h[1]
    sqrdmulh v27.8h, v7.8h, v0.h[1]

    mls v4.8h, v24.8h, v0.h[0]
    mls v5.8h, v25.8h, v0.h[0]
    mls v6.8h, v26.8h, v0.h[0]
    mls v7.8h, v27.8h, v0.h[0]

    # Range after R=2^15 Barrett reduction: [-2556,2555].
    #store
    st1 { v4.8h -  v7.8h}, [dst], #64
    st1 {v16.8h - v19.8h}, [dst], #64

    subs counter, counter, #128
    b.ne _looptop_3456

    .unreq dst
    .unreq src
    .unreq zetas_ptr
    .unreq counter


    ret

/*************************************************
* Name:        poly_invntt_scale
*
* Description: Transforms a polynomial from the incomplete NTT
*              representation to coefficient representation and applies
*              the inverse NTT scaling factor.
*
* Reference:   Algorithm 10 of [BHK+21].
*
* Arguments:   - poly *r: pointer to the input/output polynomial;
*                         input coefficients must lie in [-q+1,q-1]
*                         in the R^-1 representation
*
* Returns:     none. Output coefficients lie in [-q+1,q-1].
**************************************************/
.global poly_invntt_scale
.global _poly_invntt_scale
poly_invntt_scale:
_poly_invntt_scale:

    dst       .req x0
    src       .req x1
    zetas_ptr .req x2
    counter   .req x8

    mov src, dst
    load_address zetas_ptr, zetas, ZETAS_INV_START

    mov counter, #1536

    load_address x9, consts_reverse
    ldr q23, [x9]

_looptop_6543:

    # v0-v3: arithmetic constants; other caller-saved vectors hold data, temporaries and mask.
    #zetas
    ldp q0, q1, [zetas_ptr], #-64
    ldp q2, q3, [zetas_ptr, #96]
    tbl v2.16b, {v2.16b}, v23.16b
    tbl v3.16b, {v3.16b}, v23.16b

    #load
    ld1 { v4.8h -  v7.8h}, [src], #64
    ld1 {v16.8h - v19.8h}, [src], #64

    # Input range: [-3456,3456].
    #level 6
    #update
    sub v24.8h, v16.8h, v4.8h
    sub v21.8h, v17.8h, v5.8h
    sub v22.8h, v18.8h, v6.8h
    sub v20.8h, v19.8h, v7.8h

    add v4.8h, v4.8h, v16.8h
    add v5.8h, v5.8h, v17.8h
    add v6.8h, v6.8h, v18.8h
    add v7.8h, v7.8h, v19.8h

    #mul
    mul v16.8h, v24.8h, v2.8h
    mul v17.8h, v21.8h, v2.8h
    mul v18.8h, v22.8h, v2.8h
    mul v19.8h, v20.8h, v2.8h

    sqrdmulh v24.8h, v24.8h, v3.8h
    sqrdmulh v21.8h, v21.8h, v3.8h
    sqrdmulh v22.8h, v22.8h, v3.8h
    sqrdmulh v20.8h, v20.8h, v3.8h

    mls v16.8h, v24.8h, v0.h[0]
    mls v17.8h, v21.8h, v0.h[0]
    mls v18.8h, v22.8h, v0.h[0]
    mls v19.8h, v20.8h, v0.h[0]

    #shuffle
    trn1 v24.2d, v4.2d, v16.2d
    trn2 v21.2d, v4.2d, v16.2d
    trn1 v22.2d, v5.2d, v17.2d
    trn2 v20.2d, v5.2d, v17.2d
    trn1  v4.2d, v6.2d, v18.2d
    trn2 v25.2d, v6.2d, v18.2d
    trn1 v26.2d, v7.2d, v19.2d
    trn2 v27.2d, v7.2d, v19.2d

    trn1 v28.4s, v24.4s,  v4.4s
    trn2 v29.4s, v24.4s,  v4.4s
    trn1 v30.4s, v21.4s, v25.4s
    trn2 v31.4s, v21.4s, v25.4s
    trn1 v16.4s, v22.4s, v26.4s
    trn2 v17.4s, v22.4s, v26.4s
    trn1 v18.4s, v20.4s, v27.4s
    trn2 v19.4s, v20.4s, v27.4s

    trn1  v4.8h, v28.8h, v16.8h
    trn2  v5.8h, v28.8h, v16.8h
    trn1  v6.8h, v29.8h, v17.8h
    trn2  v7.8h, v29.8h, v17.8h
    trn1 v16.8h, v30.8h, v18.8h
    trn2 v17.8h, v30.8h, v18.8h
    trn1 v18.8h, v31.8h, v19.8h
    trn2 v19.8h, v31.8h, v19.8h

    # Range after level 6: [-6912,6912].
    #level 5
    #update
    sub v24.8h,  v5.8h,  v4.8h
    sub v21.8h,  v7.8h,  v6.8h
    sub v22.8h, v17.8h, v16.8h
    sub v20.8h, v19.8h, v18.8h

    add  v4.8h,  v5.8h,  v4.8h
    add  v6.8h,  v7.8h,  v6.8h
    add v16.8h, v17.8h, v16.8h
    add v18.8h, v19.8h, v18.8h

    #mul
    mul  v5.8h, v24.8h, v1.h[6]
    mul  v7.8h, v21.8h, v1.h[4]
    mul v17.8h, v22.8h, v1.h[2]
    mul v19.8h, v20.8h, v1.h[0]

    sqrdmulh v24.8h, v24.8h, v1.h[7]
    sqrdmulh v21.8h, v21.8h, v1.h[5]
    sqrdmulh v22.8h, v22.8h, v1.h[3]
    sqrdmulh v20.8h, v20.8h, v1.h[1]

    mls  v5.8h, v24.8h, v0.h[0]
    mls  v7.8h, v21.8h, v0.h[0]
    mls v17.8h, v22.8h, v0.h[0]
    mls v19.8h, v20.8h, v0.h[0]

    # Range after level 5: [-13824,13824].
    #level 4
    #update
    sub v24.8h,  v6.8h,  v4.8h
    sub v21.8h,  v7.8h,  v5.8h
    sub v22.8h, v18.8h, v16.8h
    sub v20.8h, v19.8h, v17.8h

    add  v4.8h,  v6.8h,  v4.8h
    add  v5.8h,  v7.8h,  v5.8h
    add v16.8h, v18.8h, v16.8h
    add v17.8h, v19.8h, v17.8h

    #mul
    mul  v6.8h, v24.8h, v0.h[6]
    mul  v7.8h, v21.8h, v0.h[6]
    mul v18.8h, v22.8h, v0.h[4]
    mul v19.8h, v20.8h, v0.h[4]

    sqrdmulh v24.8h, v24.8h, v0.h[7]
    sqrdmulh v21.8h, v21.8h, v0.h[7]
    sqrdmulh v22.8h, v22.8h, v0.h[5]
    sqrdmulh v20.8h, v20.8h, v0.h[5]

    mls  v6.8h, v24.8h, v0.h[0]
    mls  v7.8h, v21.8h, v0.h[0]
    mls v18.8h, v22.8h, v0.h[0]
    mls v19.8h, v20.8h, v0.h[0]

    # Range before Barrett reduction: [-27648,27648].
    #Barrett reduction
    sqrdmulh v20.8h,  v4.8h, v0.h[1]
    sqrdmulh v21.8h,  v5.8h, v0.h[1]
    sqrdmulh v22.8h, v16.8h, v0.h[1]
    sqrdmulh v24.8h, v17.8h, v0.h[1]

    mls  v4.8h, v20.8h, v0.h[0]
    mls  v5.8h, v21.8h, v0.h[0]
    mls v16.8h, v22.8h, v0.h[0]
    mls v17.8h, v24.8h, v0.h[0]

    # Range after level 4: [-3161,3161].
    #level 3
    #update
    sub v24.8h, v16.8h, v4.8h
    sub v21.8h, v17.8h, v5.8h
    sub v22.8h, v18.8h, v6.8h
    sub v20.8h, v19.8h, v7.8h

    add v4.8h, v16.8h, v4.8h
    add v5.8h, v17.8h, v5.8h
    add v6.8h, v18.8h, v6.8h
    add v7.8h, v19.8h, v7.8h

    #mul
    mul v16.8h, v24.8h, v0.h[2]
    mul v17.8h, v21.8h, v0.h[2]
    mul v18.8h, v22.8h, v0.h[2]
    mul v19.8h, v20.8h, v0.h[2]

    sqrdmulh v24.8h, v24.8h, v0.h[3]
    sqrdmulh v21.8h, v21.8h, v0.h[3]
    sqrdmulh v22.8h, v22.8h, v0.h[3]
    sqrdmulh v20.8h, v20.8h, v0.h[3]

    mls v16.8h, v24.8h, v0.h[0]
    mls v17.8h, v21.8h, v0.h[0]
    mls v18.8h, v22.8h, v0.h[0]
    mls v19.8h, v20.8h, v0.h[0]

    #store
    st1 { v4.8h -  v7.8h}, [dst], #64
    st1 {v16.8h - v19.8h}, [dst], #64

    # Range after level 3: [-6214,6214].
    subs counter, counter, #128
    b.ne _looptop_6543

    sub dst, dst, #1536

    ld1 {v0.8h - v3.8h}, [zetas_ptr], #64

    load_address x9, consts_inv
    ldr q4, [x9]
    # Patch only header pairs unused by subsequent inverse butterflies.
    ins v0.s[2], v4.s[0]
    ins v3.s[1], v4.s[1]
    ins v3.s[2], v4.s[2]

    mov counter, #128

_looptop_210:

    # v0-v3: constants; coefficients and temporaries reuse caller-saved vectors.
    #load
    ldr  q4, [dst, #0*128]
    ldr q29, [dst, #1*128]
    ldr  q5, [dst, #2*128]
    ldr q28, [dst, #3*128]
    ldr q16, [dst, #4*128]
    ldr q17, [dst, #5*128]
    ldr q18, [dst, #6*128]
    ldr q19, [dst, #7*128]
    ldr q20, [dst, #8*128]
    ldr q21, [dst, #9*128]
    ldr q22, [dst, #10*128]
    ldr q23, [dst, #11*128]

    #level 2
    #update 1
    sub v24.8h, v29.8h,  v4.8h
    sub v25.8h, v28.8h,  v5.8h
    sub v26.8h, v17.8h, v16.8h
    sub v27.8h, v19.8h, v18.8h
    sub  v7.8h, v21.8h, v20.8h
    sub  v6.8h, v23.8h, v22.8h

    add  v4.8h,  v4.8h, v29.8h
    add v29.8h,  v5.8h, v28.8h
    add v16.8h, v16.8h, v17.8h
    add v18.8h, v18.8h, v19.8h
    add v20.8h, v20.8h, v21.8h
    add v22.8h, v22.8h, v23.8h

    #mul 1
    mul  v5.8h, v24.8h, v3.h[0]
    mul v28.8h, v25.8h, v2.h[6]
    mul v17.8h, v26.8h, v2.h[4]
    mul v19.8h, v27.8h, v2.h[2]
    mul v21.8h,  v7.8h, v2.h[0]
    mul v23.8h,  v6.8h, v1.h[6]

    sqrdmulh v24.8h, v24.8h, v3.h[1]
    sqrdmulh v25.8h, v25.8h, v2.h[7]
    sqrdmulh v26.8h, v26.8h, v2.h[5]
    sqrdmulh v27.8h, v27.8h, v2.h[3]
    sqrdmulh  v7.8h,  v7.8h, v2.h[1]
    sqrdmulh  v6.8h,  v6.8h, v1.h[7]

    mls  v5.8h, v24.8h, v0.h[0]
    mls v28.8h, v25.8h, v0.h[0]
    mls v17.8h, v26.8h, v0.h[0]
    mls v19.8h, v27.8h, v0.h[0]
    mls v21.8h,  v7.8h, v0.h[0]
    mls v23.8h,  v6.8h, v0.h[0]

    # Range before Barrett reduction: [-12428,12428].
    #Barrett reduction
    sqrdmulh  v6.8h,  v4.8h, v0.h[1]
    sqrdmulh  v7.8h, v29.8h, v0.h[1]
    sqrdmulh v24.8h, v16.8h, v0.h[1]

    mls  v4.8h,  v6.8h, v0.h[0]
    mls v29.8h,  v7.8h, v0.h[0]
    mls v16.8h, v24.8h, v0.h[0]

    sqrdmulh  v6.8h, v18.8h, v0.h[1]
    sqrdmulh  v7.8h, v20.8h, v0.h[1]
    sqrdmulh v24.8h, v22.8h, v0.h[1]

    mls v18.8h,  v6.8h, v0.h[0]
    mls v20.8h,  v7.8h, v0.h[0]
    mls v22.8h, v24.8h, v0.h[0]

    # Range after level 2: [-2365,2365].
    #level 1
    #update 1
    sub v24.8h, v29.8h, v4.8h  //r[i + step] - r[i]
    sub  v7.8h, v28.8h, v5.8h  //r[i + step] - r[i]

    #mul 1
    mul v26.8h, v24.8h, v0.h[2]
    mul  v6.8h,  v7.8h, v0.h[2]

    sqrdmulh v24.8h, v24.8h, v0.h[3]
    sqrdmulh  v7.8h,  v7.8h, v0.h[3]

    mls v26.8h, v24.8h, v0.h[0]  //t1
    mls  v6.8h,  v7.8h, v0.h[0]  //t1

    #update 2
    sub v24.8h, v16.8h, v29.8h  //r[i + 2*step] - r[i + step]
    sub v25.8h, v17.8h, v28.8h  //r[i + 2*step] - r[i + step]

    sub v27.8h, v16.8h, v4.8h  //r[i + 2*step] - r[i]
    sub  v7.8h, v17.8h, v5.8h  //r[i + 2*step] - r[i]

    add v4.8h, v4.8h, v29.8h  //r[i] + r[i + step]
    add v5.8h, v5.8h, v28.8h  //r[i] + r[i + step]

    sub v24.8h, v24.8h, v26.8h  //r[i + 2*step] - r[i + step] - t1
    sub v25.8h, v25.8h,  v6.8h  //r[i + 2*step] - r[i + step] - t1

    add v26.8h, v27.8h, v26.8h  //r[i + 2*step] - r[i] + t1
    add v27.8h,  v7.8h,  v6.8h  //r[i + 2*step] - r[i] + t1

    add v4.8h, v4.8h, v16.8h  //r[i] + r[i + step] + r[i + 2*step]
    add v5.8h, v5.8h, v17.8h  //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul v16.8h, v24.8h, v1.h[4]  //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v17.8h, v25.8h, v1.h[4]  //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul  v6.8h, v26.8h, v1.h[2]  //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul  v7.8h, v27.8h, v1.h[2]  //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v24.8h, v24.8h, v1.h[5]
    sqrdmulh v25.8h, v25.8h, v1.h[5]
    sqrdmulh v26.8h, v26.8h, v1.h[3]
    sqrdmulh v27.8h, v27.8h, v1.h[3]

    mls v16.8h, v24.8h, v0.h[0]
    mls v17.8h, v25.8h, v0.h[0]
    mls  v6.8h, v26.8h, v0.h[0]
    mls  v7.8h, v27.8h, v0.h[0]

    #update 1
    sub v27.8h, v20.8h, v18.8h  //r[i + step] - r[i]
    sub v26.8h, v21.8h, v19.8h  //r[i + step] - r[i]

    #mul 1
    mul v24.8h, v27.8h, v0.h[2]
    mul v25.8h, v26.8h, v0.h[2]

    sqrdmulh v27.8h, v27.8h, v0.h[3]
    sqrdmulh v26.8h, v26.8h, v0.h[3]

    mls v24.8h, v27.8h, v0.h[0]  //t1
    mls v25.8h, v26.8h, v0.h[0]  //t1

    #update 2
    sub v29.8h, v22.8h, v20.8h  //r[i + 2*step] - r[i + step]
    sub v28.8h, v23.8h, v21.8h  //r[i + 2*step] - r[i + step]

    sub v27.8h, v22.8h, v18.8h  //r[i + 2*step] - r[i]
    sub v26.8h, v23.8h, v19.8h  //r[i + 2*step] - r[i]

    add v18.8h, v18.8h, v20.8h  //r[i] + r[i + step]
    add v19.8h, v19.8h, v21.8h  //r[i] + r[i + step]

    sub v29.8h, v29.8h, v24.8h  //r[i + 2*step] - r[i + step] - t1
    sub v28.8h, v28.8h, v25.8h  //r[i + 2*step] - r[i + step] - t1

    add v27.8h, v27.8h, v24.8h  //r[i + 2*step] - r[i] + t1
    add v26.8h, v26.8h, v25.8h  //r[i + 2*step] - r[i] + t1

    add v18.8h, v18.8h, v22.8h  //r[i] + r[i + step] + r[i + 2*step]
    add v19.8h, v19.8h, v23.8h  //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul v22.8h, v29.8h, v1.h[0]  //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v23.8h, v28.8h, v1.h[0]  //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v20.8h, v27.8h, v0.h[6]  //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v21.8h, v26.8h, v0.h[6]  //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v29.8h, v29.8h, v1.h[1]
    sqrdmulh v28.8h, v28.8h, v1.h[1]
    sqrdmulh v27.8h, v27.8h, v0.h[7]
    sqrdmulh v26.8h, v26.8h, v0.h[7]

    mls v22.8h, v29.8h, v0.h[0]
    mls v23.8h, v28.8h, v0.h[0]
    mls v20.8h, v27.8h, v0.h[0]
    mls v21.8h, v26.8h, v0.h[0]

    # Range after level 1: [-6564,6564].
    #level 0
    #update 1
    sub v24.8h,  v4.8h, v18.8h
    sub v25.8h,  v5.8h, v19.8h
    sub v26.8h,  v6.8h, v20.8h
    sub v27.8h,  v7.8h, v21.8h
    sub v28.8h, v16.8h, v22.8h
    sub v29.8h, v17.8h, v23.8h

    add  v4.8h,  v4.8h, v18.8h  //t1
    add  v5.8h,  v5.8h, v19.8h  //t1
    add  v6.8h,  v6.8h, v20.8h  //t1
    add  v7.8h,  v7.8h, v21.8h  //t1
    add v16.8h, v16.8h, v22.8h  //t1
    add v18.8h, v17.8h, v23.8h  //t1

    #mul 1
    mul v30.8h, v24.8h, v0.h[4]
    mul v31.8h, v25.8h, v0.h[4]
    mul v17.8h, v26.8h, v0.h[4]

    sqrdmulh v24.8h, v24.8h, v0.h[5]
    sqrdmulh v25.8h, v25.8h, v0.h[5]
    sqrdmulh v26.8h, v26.8h, v0.h[5]

    mls v30.8h, v24.8h, v0.h[0]  //t2
    mls v31.8h, v25.8h, v0.h[0]  //t2
    mls v17.8h, v26.8h, v0.h[0]  //t2

    mul v21.8h, v27.8h, v0.h[4]
    mul v20.8h, v28.8h, v0.h[4]
    mul v19.8h, v29.8h, v0.h[4]

    sqrdmulh v27.8h, v27.8h, v0.h[5]
    sqrdmulh v28.8h, v28.8h, v0.h[5]
    sqrdmulh v29.8h, v29.8h, v0.h[5]

    mls v21.8h, v27.8h, v0.h[0]  //t2
    mls v20.8h, v28.8h, v0.h[0]  //t2
    mls v19.8h, v29.8h, v0.h[0]  //t2

    #update 2
    sub v24.8h,  v4.8h, v30.8h  //t1 - t2
    sub v25.8h,  v5.8h, v31.8h  //t1 - t2
    sub v26.8h,  v6.8h, v17.8h  //t1 - t2
    sub v27.8h,  v7.8h, v21.8h  //t1 - t2
    sub v28.8h, v16.8h, v20.8h  //t1 - t2
    sub v29.8h, v18.8h, v19.8h  //t1 - t2

    #mul 2
    mul v4.8h, v24.8h, v3.h[2]
    mul v5.8h, v25.8h, v3.h[2]
    mul v6.8h, v26.8h, v3.h[2]

    sqrdmulh v24.8h, v24.8h, v3.h[3]
    sqrdmulh v25.8h, v25.8h, v3.h[3]
    sqrdmulh v26.8h, v26.8h, v3.h[3]

    mls v4.8h, v24.8h, v0.h[0]
    mls v5.8h, v25.8h, v0.h[0]
    mls v6.8h, v26.8h, v0.h[0]

    mul  v7.8h, v27.8h, v3.h[2]
    mul v16.8h, v28.8h, v3.h[2]
    mul v18.8h, v29.8h, v3.h[2]

    sqrdmulh v27.8h, v27.8h, v3.h[3]
    sqrdmulh v28.8h, v28.8h, v3.h[3]
    sqrdmulh v29.8h, v29.8h, v3.h[3]

    mls  v7.8h, v27.8h, v0.h[0]
    mls v16.8h, v28.8h, v0.h[0]
    mls v18.8h, v29.8h, v0.h[0]

    mul v22.8h, v30.8h, v3.h[4]
    mul v23.8h, v31.8h, v3.h[4]
    mul v24.8h, v17.8h, v3.h[4]

    sqrdmulh v30.8h, v30.8h, v3.h[5]
    sqrdmulh v31.8h, v31.8h, v3.h[5]
    sqrdmulh v17.8h, v17.8h, v3.h[5]

    mls v22.8h, v30.8h, v0.h[0]
    mls v23.8h, v31.8h, v0.h[0]
    mls v24.8h, v17.8h, v0.h[0]

    mul v17.8h, v21.8h, v3.h[4]
    mul v25.8h, v20.8h, v3.h[4]
    mul v26.8h, v19.8h, v3.h[4]

    sqrdmulh v21.8h, v21.8h, v3.h[5]
    sqrdmulh v20.8h, v20.8h, v3.h[5]
    sqrdmulh v19.8h, v19.8h, v3.h[5]

    mls v17.8h, v21.8h, v0.h[0]
    mls v25.8h, v20.8h, v0.h[0]
    mls v26.8h, v19.8h, v0.h[0]

    # Range after level 0: [-2135,2135].
    #store
    str  q4, [dst, #0*128]
    str  q5, [dst, #1*128]
    str  q6, [dst, #2*128]
    str  q7, [dst, #3*128]
    str q16, [dst, #4*128]
    str q18, [dst, #5*128]
    str q22, [dst, #6*128]
    str q23, [dst, #7*128]
    str q24, [dst, #8*128]
    str q17, [dst, #9*128]
    str q25, [dst, #10*128]
    str q26, [dst, #11*128]

    add dst, dst, #16
    subs counter, counter, #16
    b.ne _looptop_210

    .unreq dst
    .unreq src
    .unreq zetas_ptr
    .unreq counter


    ret
