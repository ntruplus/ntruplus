/*************************************************
* Name:        poly_frombytes
*
* Description: De-serializes a polynomial from its canonical 12-bit
*              coefficient representation into internal NTT order.
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

    adr x2, const_unpack_masks
    ld1 {v28.16b - v30.16b}, [x2], #48
    ldr q31, [x2]
    movi v0.8h, #0

    mov counter, #1728

_loop_frombytes:
    # Deinterleave the first 16 triples and preserve their B/C streams.
    ld3 {v16.16b - v18.16b}, [src], #48
    mov v20.16b, v18.16b
    mov v18.16b, v17.16b
    ld3 { v21.8b -  v23.8b}, [src], #24

    # Overlap the A/B and B/C tables at v18, which holds the B stream.
    zip1 v17.2d, v21.2d, v22.2d
    zip1 v19.2d, v22.2d, v23.2d

    # Gather byte pairs directly in internal NTT order, c[6*k+j].
    tbl v1.16b, {v16.16b - v18.16b}, v28.16b
    tbl v2.16b, {v18.16b - v20.16b}, v28.16b
    tbl v3.16b, {v16.16b - v18.16b}, v29.16b
    tbl v4.16b, {v18.16b - v20.16b}, v29.16b
    tbl v5.16b, {v16.16b - v18.16b}, v30.16b
    tbl v6.16b, {v18.16b - v20.16b}, v30.16b

    and v1.16b, v1.16b, v31.16b
    and v3.16b, v3.16b, v31.16b
    and v5.16b, v5.16b, v31.16b

    ushr v2.8h, v2.8h, #4
    ushr v4.8h, v4.8h, #4
    ushr v6.8h, v6.8h, #4

    st1 {v1.8h - v4.8h}, [dst], #64
    st1 {v5.8h - v6.8h}, [dst], #32

    umax v16.8h,  v1.8h,  v2.8h
    umax v17.8h,  v3.8h,  v4.8h
    umax v18.8h,  v5.8h,  v6.8h
    umax v16.8h, v16.8h, v17.8h
    umax v16.8h, v16.8h, v18.8h
    umax  v0.8h,  v0.8h, v16.8h

    subs counter, counter, #96
    b.ne _loop_frombytes

    .unreq dst
    .unreq src
    .unreq counter

    umaxv h0, v0.8h
    umov w0, v0.h[0]
    cmp w0, #3457
    cset w0, hs
    ret


/*************************************************
* Name:        poly_tobytes
*
* Description: Reduces polynomial coefficients to [0,q), converts them from
*              internal NTT order, and serializes each coefficient into 12 bits.
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
    adr x2, const_pack_masks
    ld1 {v28.16b - v30.16b}, [x2]

    mov counter, #1728

_loop_tobytes:
    ld1 {v1.8h - v4.8h}, [src], #64
    ld1 {v5.8h - v6.8h}, [src], #32

    # Barrett reduction with round(2^15/q) = 9
    sqrdmulh v16.8h,  v1.8h, v0.h[1]
    sqrdmulh v17.8h,  v2.8h, v0.h[1]
    sqrdmulh v18.8h,  v3.8h, v0.h[1]
    sqrdmulh v19.8h,  v4.8h, v0.h[1]
    sqrdmulh v20.8h,  v5.8h, v0.h[1]
    sqrdmulh v21.8h,  v6.8h, v0.h[1]
    mls       v1.8h, v16.8h, v0.h[0]
    mls       v2.8h, v17.8h, v0.h[0]
    mls       v3.8h, v18.8h, v0.h[0]
    mls       v4.8h, v19.8h, v0.h[0]
    mls       v5.8h, v20.8h, v0.h[0]
    mls       v6.8h, v21.8h, v0.h[0]

    cmlt v16.8h,  v1.8h, #0
    cmlt v17.8h,  v2.8h, #0
    cmlt v18.8h,  v3.8h, #0
    cmlt v19.8h,  v4.8h, #0
    cmlt v20.8h,  v5.8h, #0
    cmlt v21.8h,  v6.8h, #0
    mls   v1.8h, v16.8h, v0.h[0]
    mls   v2.8h, v17.8h, v0.h[0]
    mls   v3.8h, v18.8h, v0.h[0]
    mls   v4.8h, v19.8h, v0.h[0]
    mls   v5.8h, v20.8h, v0.h[0]
    mls   v6.8h, v21.8h, v0.h[0]

    # Pack each coefficient pair without changing its lane order.
    sli  v1.8h, v2.8h, #12
    ushr v2.8h, v2.8h, #4
    sli  v3.8h, v4.8h, #12
    ushr v4.8h, v4.8h, #4
    sli  v5.8h, v6.8h, #12
    ushr v6.8h, v6.8h, #4

    # Each 48-byte table contains all three pairs for four coefficient lanes.
    zip1 v16.2d, v1.2d, v2.2d
    zip1 v17.2d, v3.2d, v4.2d
    zip1 v18.2d, v5.2d, v6.2d
    zip2 v19.2d, v1.2d, v2.2d
    zip2 v20.2d, v3.2d, v4.2d
    zip2 v21.2d, v5.2d, v6.2d

    # Select the final 36-byte representation of each four-lane group.
    tbl v1.16b, {v16.16b - v18.16b}, v28.16b
    tbl v2.16b, {v16.16b - v18.16b}, v29.16b
    tbl  v3.8b, {v16.16b - v18.16b},  v30.8b
    tbl v4.16b, {v19.16b - v21.16b}, v28.16b
    tbl v5.16b, {v19.16b - v21.16b}, v29.16b
    tbl  v6.8b, {v19.16b - v21.16b},  v30.8b

    str q1, [dst], #16
    str q2, [dst], #16
    str s3, [dst], #4
    str q4, [dst], #16
    str q5, [dst], #16
    str s6, [dst], #4

    subs counter, counter, #96
    b.ne _loop_tobytes

    .unreq dst
    .unreq src
    .unreq counter

    ret


.align 4
const_unpack_masks:
    .byte 0, 32, 3, 35, 6, 38, 9, 41, 12, 44, 15, 47, 18, 26, 21, 29
    .byte 1, 33, 4, 36, 7, 39, 10, 42, 13, 45, 16, 24, 19, 27, 22, 30
    .byte 2, 34, 5, 37, 8, 40, 11, 43, 14, 46, 17, 25, 20, 28, 23, 31
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff

.align 4
const_pack_masks:
    .byte 0, 1, 8, 16, 17, 24, 32, 33, 40, 2, 3, 10, 18, 19, 26, 34
    .byte 35, 42, 4, 5, 12, 20, 21, 28, 36, 37, 44, 6, 7, 14, 22, 23
    .byte 30, 38, 39, 46, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255

.align 4
const_q:
    .hword 0x0d81, 0x0009, 0x0000, 0x0000
    .hword 0x0000, 0x0000, 0x0000, 0x0000
