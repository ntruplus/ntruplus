.global poly_crepmod3
.global _poly_crepmod3
poly_crepmod3:
_poly_crepmod3:
    dst       .req x0
    src       .req x1
    counter   .req x8

    movi v0.8h, #3 
    movi v1.16b, #0x55

    mov counter, #2304

_looptop:
    ld1 {v2.8h - v5.8h},   [src], #64

    sqdmulh v6.8h, v2.8h, v1.8h
    sqdmulh v7.8h, v3.8h, v1.8h
    sqdmulh v8.8h, v4.8h, v1.8h
    sqdmulh v9.8h, v5.8h, v1.8h

    srshr v6.8h, v6.8h, #1
    srshr v7.8h, v7.8h, #1
    srshr v8.8h, v8.8h, #1
    srshr v9.8h, v9.8h, #1

    mls v2.8h, v6.8h, v0.8h
    mls v3.8h, v7.8h, v0.8h
    mls v4.8h, v8.8h, v0.8h
    mls v5.8h, v9.8h, v0.8h

    st1 {v2.8h - v5.8h},   [dst], #64

    subs counter, counter, #64
    b.ne _looptop

    .unreq dst
    .unreq src
    .unreq counter

    ret
