/*************************************************
* Name:        poly_frombytes
*
* Description: De-serializes a polynomial from its canonical 12-bit
*              coefficient representation.
*
* Arguments:   - poly *r:          pointer to the output polynomial
*              - const uint8_t *a: pointer to NTRUPLUS_POLYBYTES input bytes
*
* Returns:     0 on success, 1 if any coefficient is greater than or equal to q.
*              Output coefficients lie in [0,4095].
**************************************************/
.global poly_frombytes
.global _poly_frombytes
poly_frombytes:
_poly_frombytes:

    dst     .req x0
    src     .req x1
    counter .req x8

    adr x2, const_mask_0fff
    ldr q0, [x2]
    movi v7.8h, #0

    mov counter, #1536

_loop_frombytes:
    ld3 {v1.8h - v3.8h}, [src], #48
    ld3 {v4.8h - v6.8h}, [src], #48

    # Separate the packed words for coefficients 0..3 and 4..7.
    uzp1 v26.8h, v1.8h, v4.8h
    uzp1 v27.8h, v2.8h, v5.8h
    uzp1 v28.8h, v3.8h, v6.8h
    uzp2 v29.8h, v1.8h, v4.8h
    uzp2 v30.8h, v2.8h, v5.8h
    uzp2 v31.8h, v3.8h, v6.8h

    ushr  v2.8h, v26.8h, #12
    sli   v2.8h, v27.8h, #4
    ushr  v3.8h, v27.8h, #8
    sli   v3.8h, v28.8h, #8
    ushr v19.8h, v28.8h, #4

    ushr  v4.8h, v29.8h, #12
    sli   v4.8h, v30.8h, #4
    ushr  v5.8h, v30.8h, #8
    sli   v5.8h, v31.8h, #8
    ushr v23.8h, v31.8h, #4

    and v16.16b, v26.16b, v0.16b
    and v17.16b,  v2.16b, v0.16b
    and v18.16b,  v3.16b, v0.16b
    and v20.16b, v29.16b, v0.16b
    and v21.16b,  v4.16b, v0.16b
    and v22.16b,  v5.16b, v0.16b

    st1 {v16.8h - v19.8h}, [dst], #64
    st1 {v20.8h - v23.8h}, [dst], #64

    umax v25.8h, v16.8h, v17.8h
    umax v26.8h, v18.8h, v19.8h
    umax v27.8h, v20.8h, v21.8h
    umax v28.8h, v22.8h, v23.8h
    umax v25.8h, v25.8h, v26.8h
    umax v27.8h, v27.8h, v28.8h
    umax v25.8h, v25.8h, v27.8h
    umax  v7.8h,  v7.8h, v25.8h

    subs counter, counter, #128
    b.ne _loop_frombytes

    .unreq dst
    .unreq src
    .unreq counter

    umaxv h7, v7.8h
    umov w0, v7.h[0]
    cmp w0, #3457
    cset w0, hs

    ret


/*************************************************
* Name:        poly_tobytes
*
* Description: Reduces polynomial coefficients to [0,q) and serializes each
*              coefficient into 12 bits.
*
* Arguments:   - uint8_t *r:    pointer to NTRUPLUS_POLYBYTES output bytes
*              - const poly *a: pointer to the input polynomial;
*                               coefficients must lie in (-5q/2,5q/2)
*
* Returns:     none.
**************************************************/
.global poly_tobytes
.global _poly_tobytes
poly_tobytes:
_poly_tobytes:

    dst     .req x0
    src     .req x1
    counter .req x8

    adr x2, const_q
    ldr q0, [x2]

    mov counter, #1536

_loop_tobytes:
    #load
    ld1 {v16.8h - v19.8h}, [src], #64
    ld1 {v20.8h - v23.8h}, [src], #64

    # Barrett reduction with round(2^15/q) = 9
    sqrdmulh v25.8h, v16.8h, v0.h[1]
    sqrdmulh v26.8h, v17.8h, v0.h[1]
    sqrdmulh v27.8h, v18.8h, v0.h[1]
    sqrdmulh v28.8h, v19.8h, v0.h[1]
    sqrdmulh v29.8h, v20.8h, v0.h[1]
    sqrdmulh v30.8h, v21.8h, v0.h[1]
    sqrdmulh v31.8h, v22.8h, v0.h[1]
    sqrdmulh  v7.8h, v23.8h, v0.h[1]
    mls      v16.8h, v25.8h, v0.h[0]
    mls      v17.8h, v26.8h, v0.h[0]
    mls      v18.8h, v27.8h, v0.h[0]
    mls      v19.8h, v28.8h, v0.h[0]
    mls      v20.8h, v29.8h, v0.h[0]
    mls      v21.8h, v30.8h, v0.h[0]
    mls      v22.8h, v31.8h, v0.h[0]
    mls      v23.8h,  v7.8h, v0.h[0]

    cmlt v24.8h, v16.8h, #0
    cmlt v25.8h, v17.8h, #0
    cmlt v26.8h, v18.8h, #0
    cmlt v27.8h, v19.8h, #0
    cmlt v28.8h, v20.8h, #0
    cmlt v29.8h, v21.8h, #0
    cmlt v30.8h, v22.8h, #0
    cmlt v31.8h, v23.8h, #0
    mls  v16.8h, v24.8h, v0.h[0]
    mls  v17.8h, v25.8h, v0.h[0]
    mls  v18.8h, v26.8h, v0.h[0]
    mls  v19.8h, v27.8h, v0.h[0]
    mls  v20.8h, v28.8h, v0.h[0]
    mls  v21.8h, v29.8h, v0.h[0]
    mls  v22.8h, v30.8h, v0.h[0]
    mls  v23.8h, v31.8h, v0.h[0]

    sli  v16.8h, v17.8h, #12
    ushr v24.8h, v17.8h, #4
    sli  v24.8h, v18.8h, #8
    ushr v25.8h, v18.8h, #8
    sli  v25.8h, v19.8h, #4
    sli  v20.8h, v21.8h, #12
    ushr v26.8h, v21.8h, #4
    sli  v26.8h, v22.8h, #8
    ushr v27.8h, v22.8h, #8
    sli  v27.8h, v23.8h, #4

    # Interleave the two groups of three packed halfword streams.
    zip1 v1.8h, v16.8h, v20.8h
    zip1 v2.8h, v24.8h, v26.8h
    zip1 v3.8h, v25.8h, v27.8h
    zip2 v4.8h, v16.8h, v20.8h
    zip2 v5.8h, v24.8h, v26.8h
    zip2 v6.8h, v25.8h, v27.8h

    st3 {v1.8h - v3.8h}, [dst], #48
    st3 {v4.8h - v6.8h}, [dst], #48

    subs counter, counter, #128
    b.ne _loop_tobytes

    .unreq dst
    .unreq src
    .unreq counter

    ret

.align 4
const_mask_0fff:
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff

.align 4
const_q:
    .hword 0x0d81, 0x0009, 0x0000, 0x0000
    .hword 0x0000, 0x0000, 0x0000, 0x0000
