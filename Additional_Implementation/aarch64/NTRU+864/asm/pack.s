/*************************************************
* Name:        poly_frombytes_asm
*
* Description: De-serializes a polynomial from its canonical 12-bit
*              coefficient representation into serialization order.
*
* Arguments:   - poly *r:          pointer to the output polynomial
*              - const uint8_t *a: pointer to NTRUPLUS_POLYBYTES input bytes
*
* Returns:     none. Output coefficients lie in [0,q).
**************************************************/
.global poly_frombytes_asm
.global _poly_frombytes_asm
poly_frombytes_asm:
_poly_frombytes_asm:
    dst       .req x0
    src       .req x1
    counter   .req x8

    adr x2, const_mask_0fff
    ldr q0, [x2]

    mov counter, #1664

_loop_frombytes:
    ld1 {v1.8h-v3.8h}, [src], #48
    ld1 {v4.8h-v6.8h}, [src], #48

    trn1 v7.2d,  v1.2d, v4.2d
    trn2 v8.2d,  v1.2d, v4.2d
    trn1 v9.2d,  v2.2d, v5.2d
    trn2 v10.2d, v2.2d, v5.2d
    trn1 v11.2d, v3.2d, v6.2d
    trn2 v12.2d, v3.2d, v6.2d

    trn1 v13.4s, v7.4s, v10.4s
    trn2 v14.4s, v7.4s, v10.4s
    trn1 v15.4s, v8.4s, v11.4s
    trn2 v16.4s, v8.4s, v11.4s
    trn1 v17.4s, v9.4s, v12.4s
    trn2 v18.4s, v9.4s, v12.4s

    trn1 v19.8h, v13.8h, v16.8h
    trn2 v20.8h, v13.8h, v16.8h
    trn1 v21.8h, v14.8h, v17.8h
    trn2 v22.8h, v14.8h, v17.8h
    trn1 v23.8h, v15.8h, v18.8h
    trn2 v24.8h, v15.8h, v18.8h

    ushr v25.8h, v19.8h, #12
    sli  v25.8h, v20.8h, #4
    ushr v27.8h, v20.8h, #8
    sli  v27.8h, v21.8h, #8
    ushr v11.8h, v21.8h, #4

    ushr v30.8h, v22.8h, #12
    sli  v30.8h, v23.8h, #4
    ushr v1.8h,  v23.8h, #8
    sli  v1.8h,  v24.8h, #8
    ushr v15.8h, v24.8h, #4

    and v8.16b,  v19.16b, v0.16b
    and v9.16b,  v25.16b, v0.16b
    and v10.16b, v27.16b, v0.16b
    and v12.16b, v22.16b, v0.16b
    and v13.16b, v30.16b, v0.16b
    and v14.16b, v1.16b,  v0.16b

    trn1 v16.8h, v8.8h,  v9.8h
    trn1 v17.8h, v10.8h, v11.8h
    trn1 v18.8h, v12.8h, v13.8h
    trn1 v19.8h, v14.8h, v15.8h
    trn2 v20.8h, v8.8h,  v9.8h
    trn2 v21.8h, v10.8h, v11.8h
    trn2 v22.8h, v12.8h, v13.8h
    trn2 v23.8h, v14.8h, v15.8h

    trn1 v24.4s, v16.4s, v17.4s
    trn1 v25.4s, v18.4s, v19.4s
    trn1 v26.4s, v20.4s, v21.4s
    trn1 v27.4s, v22.4s, v23.4s
    trn2 v28.4s, v16.4s, v17.4s
    trn2 v29.4s, v18.4s, v19.4s
    trn2 v30.4s, v20.4s, v21.4s
    trn2 v31.4s, v22.4s, v23.4s

    trn1 v1.2d, v24.2d, v25.2d
    trn1 v2.2d, v26.2d, v27.2d
    trn1 v3.2d, v28.2d, v29.2d
    trn1 v4.2d, v30.2d, v31.2d
    trn2 v5.2d, v24.2d, v25.2d
    trn2 v6.2d, v26.2d, v27.2d
    trn2 v7.2d, v28.2d, v29.2d
    trn2 v8.2d, v30.2d, v31.2d

    st1 {v1.8h-v4.8h}, [dst], #64
    st1 {v5.8h-v8.8h}, [dst], #64

    subs counter, counter, #128
    b.ne _loop_frombytes

    #load
    ld1 {v7.4h-v10.4h},  [src], #32
    ld1 {v11.4h-v12.4h}, [src]

    trn1 v13.2s, v7.2s, v10.2s
    trn2 v14.2s, v7.2s, v10.2s
    trn1 v15.2s, v8.2s, v11.2s
    trn2 v16.2s, v8.2s, v11.2s
    trn1 v17.2s, v9.2s, v12.2s
    trn2 v18.2s, v9.2s, v12.2s

    trn1 v19.4h, v13.4h, v16.4h
    trn2 v20.4h, v13.4h, v16.4h
    trn1 v21.4h, v14.4h, v17.4h
    trn2 v22.4h, v14.4h, v17.4h
    trn1 v23.4h, v15.4h, v18.4h
    trn2 v24.4h, v15.4h, v18.4h

    ushr v25.4h, v19.4h, #12
    sli  v25.4h, v20.4h, #4
    ushr v27.4h, v20.4h, #8
    sli  v27.4h, v21.4h, #8
    ushr v11.4h, v21.4h, #4

    ushr v30.4h, v22.4h, #12
    sli  v30.4h, v23.4h, #4
    ushr v1.4h,  v23.4h, #8
    sli  v1.4h,  v24.4h, #8
    ushr v15.4h, v24.4h, #4

    and v8.8b,  v19.8b, v0.8b
    and v9.8b,  v25.8b, v0.8b
    and v10.8b, v27.8b, v0.8b
    and v12.8b, v22.8b, v0.8b
    and v13.8b, v30.8b, v0.8b
    and v14.8b, v1.8b,  v0.8b

    trn1 v16.4h, v8.4h,  v9.4h
    trn1 v17.4h, v10.4h, v11.4h
    trn1 v18.4h, v12.4h, v13.4h
    trn1 v19.4h, v14.4h, v15.4h
    trn2 v20.4h, v8.4h,  v9.4h
    trn2 v21.4h, v10.4h, v11.4h
    trn2 v22.4h, v12.4h, v13.4h
    trn2 v23.4h, v14.4h, v15.4h

    trn1 v24.2s, v16.2s, v17.2s
    trn1 v25.2s, v18.2s, v19.2s
    trn1 v26.2s, v20.2s, v21.2s
    trn1 v27.2s, v22.2s, v23.2s
    trn2 v28.2s, v16.2s, v17.2s
    trn2 v29.2s, v18.2s, v19.2s
    trn2 v30.2s, v20.2s, v21.2s
    trn2 v31.2s, v22.2s, v23.2s

    #store
    st1 {v24.4h-v27.4h}, [dst], #32
    st1 {v28.4h-v31.4h}, [dst]

    .unreq    dst
    .unreq    src
    .unreq    counter

    ret


/*************************************************
* Name:        poly_tobytes_asm
*
* Description: Reduces polynomial coefficients to [0,q) and serializes each
*              coefficient from serialization order into 12 bits.
*
* Arguments:   - uint8_t *r:    pointer to NTRUPLUS_POLYBYTES output bytes
*              - const poly *a: pointer to the input polynomial;
*                               coefficients must lie in (-5q/2,5q/2)
*
* Returns:     none.
**************************************************/
.global poly_tobytes_asm
.global _poly_tobytes_asm
poly_tobytes_asm:
_poly_tobytes_asm:
    dst       .req x0
    src       .req x1
    counter   .req x8

    adr x2, const_q
    ldr q0, [x2]

    mov counter, #1664

_loop_tobytes:
    #load
    ld1 {v1.8h-v4.8h}, [src], #64
    ld1 {v5.8h-v8.8h}, [src], #64

    # Barrett reduction with round(2^15/q) = 9
    sqrdmulh v10.8h, v1.8h, v0.h[1]
    sqrdmulh v11.8h, v2.8h, v0.h[1]
    sqrdmulh v12.8h, v3.8h, v0.h[1]
    sqrdmulh v13.8h, v4.8h, v0.h[1]
    sqrdmulh v14.8h, v5.8h, v0.h[1]
    sqrdmulh v15.8h, v6.8h, v0.h[1]
    sqrdmulh v16.8h, v7.8h, v0.h[1]
    sqrdmulh v17.8h, v8.8h, v0.h[1]
    mls v1.8h, v10.8h, v0.h[0]
    mls v2.8h, v11.8h, v0.h[0]
    mls v3.8h, v12.8h, v0.h[0]
    mls v4.8h, v13.8h, v0.h[0]
    mls v5.8h, v14.8h, v0.h[0]
    mls v6.8h, v15.8h, v0.h[0]
    mls v7.8h, v16.8h, v0.h[0]
    mls v8.8h, v17.8h, v0.h[0]

    trn1 v9.2d,  v1.2d, v5.2d
    trn2 v10.2d, v1.2d, v5.2d
    trn1 v11.2d, v2.2d, v6.2d
    trn2 v12.2d, v2.2d, v6.2d
    trn1 v13.2d, v3.2d, v7.2d
    trn2 v14.2d, v3.2d, v7.2d
    trn1 v15.2d, v4.2d, v8.2d
    trn2 v16.2d, v4.2d, v8.2d

    trn1 v17.4s, v9.4s,  v13.4s
    trn2 v18.4s, v9.4s,  v13.4s
    trn1 v19.4s, v10.4s, v14.4s
    trn2 v20.4s, v10.4s, v14.4s
    trn1 v21.4s, v11.4s, v15.4s
    trn2 v22.4s, v11.4s, v15.4s
    trn1 v23.4s, v12.4s, v16.4s
    trn2 v24.4s, v12.4s, v16.4s

    trn1 v25.8h, v17.8h, v21.8h
    trn2 v26.8h, v17.8h, v21.8h
    trn1 v27.8h, v18.8h, v22.8h
    trn2 v28.8h, v18.8h, v22.8h
    trn1 v29.8h, v19.8h, v23.8h
    trn2 v30.8h, v19.8h, v23.8h
    trn1 v31.8h, v20.8h, v24.8h
    trn2 v1.8h,  v20.8h, v24.8h

    cmlt v2.8h, v25.8h, #0
    cmlt v3.8h, v26.8h, #0
    cmlt v4.8h, v27.8h, #0
    cmlt v5.8h, v28.8h, #0
    cmlt v6.8h, v29.8h, #0
    cmlt v7.8h, v30.8h, #0
    cmlt v8.8h, v31.8h, #0
    cmlt v9.8h, v1.8h,  #0
    mls v25.8h, v2.8h, v0.h[0]
    mls v26.8h, v3.8h, v0.h[0]
    mls v27.8h, v4.8h, v0.h[0]
    mls v28.8h, v5.8h, v0.h[0]
    mls v29.8h, v6.8h, v0.h[0]
    mls v30.8h, v7.8h, v0.h[0]
    mls v31.8h, v8.8h, v0.h[0]
    mls v1.8h,  v9.8h, v0.h[0]

    sli  v25.8h, v26.8h, #12
    ushr v2.8h, v26.8h, #4
    sli  v2.8h, v27.8h, #8
    ushr v3.8h, v27.8h, #8
    sli  v3.8h, v28.8h, #4
    sli  v29.8h, v30.8h, #12
    ushr v4.8h, v30.8h, #4
    sli  v4.8h, v31.8h, #8
    ushr v5.8h, v31.8h, #8
    sli  v5.8h, v1.8h,  #4

    trn1 v18.8h, v25.8h, v2.8h
    trn1 v19.8h, v3.8h,  v29.8h
    trn1 v20.8h, v4.8h,  v5.8h
    trn2 v21.8h, v25.8h, v2.8h
    trn2 v22.8h, v3.8h,  v29.8h
    trn2 v23.8h, v4.8h,  v5.8h

    trn1 v12.4s, v18.4s, v19.4s
    trn1 v13.4s, v20.4s, v21.4s
    trn1 v14.4s, v22.4s, v23.4s
    trn2 v15.4s, v18.4s, v19.4s
    trn2 v16.4s, v20.4s, v21.4s
    trn2 v17.4s, v22.4s, v23.4s

    trn1 v18.2d, v12.2d, v13.2d
    trn1 v19.2d, v14.2d, v15.2d
    trn1 v20.2d, v16.2d, v17.2d
    trn2 v21.2d, v12.2d, v13.2d
    trn2 v22.2d, v14.2d, v15.2d
    trn2 v23.2d, v16.2d, v17.2d

    #store
    st1 {v18.8h-v20.8h}, [dst], #48
    st1 {v21.8h-v23.8h}, [dst], #48

    subs counter, counter, #128
    b.ne _loop_tobytes

    #load
    ld1 {v9.4h-v12.4h},  [src], #32
    ld1 {v13.4h-v16.4h}, [src]

    # Barrett reduction with round(2^15/q) = 9
    sqrdmulh v17.4h, v9.4h,  v0.h[1]
    sqrdmulh v18.4h, v10.4h, v0.h[1]
    sqrdmulh v19.4h, v11.4h, v0.h[1]
    sqrdmulh v20.4h, v12.4h, v0.h[1]
    sqrdmulh v21.4h, v13.4h, v0.h[1]
    sqrdmulh v22.4h, v14.4h, v0.h[1]
    sqrdmulh v23.4h, v15.4h, v0.h[1]
    sqrdmulh v24.4h, v16.4h, v0.h[1]
    mls v9.4h,  v17.4h, v0.h[0]
    mls v10.4h, v18.4h, v0.h[0]
    mls v11.4h, v19.4h, v0.h[0]
    mls v12.4h, v20.4h, v0.h[0]
    mls v13.4h, v21.4h, v0.h[0]
    mls v14.4h, v22.4h, v0.h[0]
    mls v15.4h, v23.4h, v0.h[0]
    mls v16.4h, v24.4h, v0.h[0]

    trn1 v17.2s, v9.2s,  v13.2s
    trn2 v18.2s, v9.2s,  v13.2s
    trn1 v19.2s, v10.2s, v14.2s
    trn2 v20.2s, v10.2s, v14.2s
    trn1 v21.2s, v11.2s, v15.2s
    trn2 v22.2s, v11.2s, v15.2s
    trn1 v23.2s, v12.2s, v16.2s
    trn2 v24.2s, v12.2s, v16.2s

    trn1 v25.4h, v17.4h, v21.4h
    trn2 v26.4h, v17.4h, v21.4h
    trn1 v27.4h, v18.4h, v22.4h
    trn2 v28.4h, v18.4h, v22.4h
    trn1 v29.4h, v19.4h, v23.4h
    trn2 v30.4h, v19.4h, v23.4h
    trn1 v31.4h, v20.4h, v24.4h
    trn2 v1.4h,  v20.4h, v24.4h

    cmlt v2.4h, v25.4h, #0
    cmlt v3.4h, v26.4h, #0
    cmlt v4.4h, v27.4h, #0
    cmlt v5.4h, v28.4h, #0
    cmlt v6.4h, v29.4h, #0
    cmlt v7.4h, v30.4h, #0
    cmlt v8.4h, v31.4h, #0
    cmlt v9.4h, v1.4h,  #0
    mls v25.4h, v2.4h, v0.h[0]
    mls v26.4h, v3.4h, v0.h[0]
    mls v27.4h, v4.4h, v0.h[0]
    mls v28.4h, v5.4h, v0.h[0]
    mls v29.4h, v6.4h, v0.h[0]
    mls v30.4h, v7.4h, v0.h[0]
    mls v31.4h, v8.4h, v0.h[0]
    mls v1.4h,  v9.4h, v0.h[0]

    sli  v25.4h, v26.4h, #12
    ushr v2.4h, v26.4h, #4
    sli  v2.4h, v27.4h, #8
    ushr v3.4h, v27.4h, #8
    sli  v3.4h, v28.4h, #4
    sli  v29.4h, v30.4h, #12
    ushr v4.4h, v30.4h, #4
    sli  v4.4h, v31.4h, #8
    ushr v5.4h, v31.4h, #8
    sli  v5.4h, v1.4h,  #4

    trn1 v18.4h, v25.4h, v2.4h
    trn1 v19.4h, v3.4h,  v29.4h
    trn1 v20.4h, v4.4h,  v5.4h
    trn2 v21.4h, v25.4h, v2.4h
    trn2 v22.4h, v3.4h,  v29.4h
    trn2 v23.4h, v4.4h,  v5.4h

    trn1 v12.2s, v18.2s, v19.2s
    trn1 v13.2s, v20.2s, v21.2s
    trn1 v14.2s, v22.2s, v23.2s
    trn2 v15.2s, v18.2s, v19.2s
    trn2 v16.2s, v20.2s, v21.2s
    trn2 v17.2s, v22.2s, v23.2s

    #store
    st1 {v12.4h-v15.4h}, [dst], #32
    st1 {v16.4h-v17.4h}, [dst]

    .unreq    dst
    .unreq    src
    .unreq    counter

    ret


/*************************************************
* Name:        poly_shuffle_asm
*
* Description: Converts coefficients from serialization order to the
*              internal NTT order. In-place operation is supported.
*
* Arguments:   - poly *r:       pointer to the output polynomial
*              - const poly *a: pointer to the input polynomial
*
* Returns:     none.
**************************************************/
.global poly_shuffle_asm
.global _poly_shuffle_asm
poly_shuffle_asm:
_poly_shuffle_asm:
    dst       .req x0
    src       .req x1
    counter   .req x8

    add counter, src, #1728

_loop_shuffle:
    #load
    ld1 {v0.8h-v3.8h}, [src], #64
    ld1 {v4.8h-v5.8h}, [src], #32

    #shuffle
    trn1 v16.2d, v0.2d, v3.2d
    trn2 v17.2d, v0.2d, v3.2d
    trn1 v18.2d, v1.2d, v4.2d
    trn2 v19.2d, v1.2d, v4.2d
    trn1 v20.2d, v2.2d, v5.2d
    trn2 v21.2d, v2.2d, v5.2d

    #shuffle
    trn1 v22.4s, v16.4s, v19.4s
    trn2 v23.4s, v16.4s, v19.4s
    trn1 v24.4s, v17.4s, v20.4s
    trn2 v25.4s, v17.4s, v20.4s
    trn1 v26.4s, v18.4s, v21.4s
    trn2 v27.4s, v18.4s, v21.4s

    #shuffle
    trn1 v0.8h, v22.8h, v25.8h
    trn2 v1.8h, v22.8h, v25.8h
    trn1 v2.8h, v23.8h, v26.8h
    trn2 v3.8h, v23.8h, v26.8h
    trn1 v4.8h, v24.8h, v27.8h
    trn2 v5.8h, v24.8h, v27.8h

    #store
    st1 {v0.8h-v3.8h}, [dst], #64
    st1 {v4.8h-v5.8h}, [dst], #32

    cmp src, counter
    blt _loop_shuffle

    .unreq    dst
    .unreq    src
    .unreq    counter
    ret


/*************************************************
* Name:        poly_shuffle2_asm
*
* Description: Converts coefficients from the internal NTT order to
*              serialization order. In-place operation is supported.
*
* Arguments:   - poly *r:       pointer to the output polynomial
*              - const poly *a: pointer to the input polynomial
*
* Returns:     none.
**************************************************/
.global poly_shuffle2_asm
.global _poly_shuffle2_asm
poly_shuffle2_asm:
_poly_shuffle2_asm:
    dst       .req x0
    src       .req x1
    counter   .req x8

    add counter, src, #1728

_loop_shuffle2:
    #load
    ld1 {v0.8h-v3.8h}, [src], #64
    ld1 {v4.8h-v5.8h}, [src], #32

    #shuffle
    trn1 v16.8h, v0.8h, v1.8h
    trn1 v17.8h, v2.8h, v3.8h
    trn1 v18.8h, v4.8h, v5.8h
    trn2 v19.8h, v0.8h, v1.8h
    trn2 v20.8h, v2.8h, v3.8h
    trn2 v21.8h, v4.8h, v5.8h

    #shuffle
    trn1 v22.4s, v16.4s, v17.4s
    trn1 v23.4s, v18.4s, v19.4s
    trn1 v24.4s, v20.4s, v21.4s
    trn2 v25.4s, v16.4s, v17.4s
    trn2 v26.4s, v18.4s, v19.4s
    trn2 v27.4s, v20.4s, v21.4s

    #shuffle
    trn1 v0.2d, v22.2d, v23.2d
    trn1 v1.2d, v24.2d, v25.2d
    trn1 v2.2d, v26.2d, v27.2d
    trn2 v3.2d, v22.2d, v23.2d
    trn2 v4.2d, v24.2d, v25.2d
    trn2 v5.2d, v26.2d, v27.2d

    #store
    st1 {v0.8h-v3.8h}, [dst], #64
    st1 {v4.8h-v5.8h}, [dst], #32

    cmp src, counter
    blt _loop_shuffle2

    .unreq    dst
    .unreq    src
    .unreq    counter
    ret

.align 4
const_mask_0fff:
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff

.align 4
const_q:
    .hword 0x0d81, 0x0009, 0x0000, 0x0000
    .hword 0x0000, 0x0000, 0x0000, 0x0000
