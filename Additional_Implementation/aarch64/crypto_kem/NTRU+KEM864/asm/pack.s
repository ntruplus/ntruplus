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

    ushr  v7.8h, v1.8h, #12
    ushr  v8.8h, v2.8h, #12
    ushr  v9.8h, v3.8h, #8
    ushr v10.8h, v4.8h, #8
    ushr v25.8h, v5.8h, #4
    ushr v26.8h, v6.8h, #4

    shl v11.8h, v3.8h, #4
    shl v12.8h, v4.8h, #4
    shl v13.8h, v5.8h, #8
    shl v14.8h, v6.8h, #8

    eor v15.16b,  v7.16b, v11.16b
    eor v16.16b,  v8.16b, v12.16b
    eor v17.16b,  v9.16b, v13.16b
    eor v18.16b, v10.16b, v14.16b

    and v19.16b,  v1.16b, v0.16b
    and v20.16b,  v2.16b, v0.16b
    and v21.16b, v15.16b, v0.16b
    and v22.16b, v16.16b, v0.16b
    and v23.16b, v17.16b, v0.16b
    and v24.16b, v18.16b, v0.16b

    st1 {v19.8h-v22.8h}, [dst], #64
    st1 {v23.8h-v26.8h}, [dst], #64

    subs counter, counter, #128
    b.ne _loop_frombytes

    #load
    ldr  d27, [src, #0*8]
    ldr  d28, [src, #1*8]
    ldr  d29, [src, #2*8]
    ldr  d30, [src, #3*8]
    ldr  d31, [src, #4*8]
    ldr   d1, [src, #5*8]

    ushr  v2.4h, v27.4h, #12
    ushr  v3.4h, v28.4h, #12
    ushr  v4.4h, v29.4h, #8
    ushr  v5.4h, v30.4h, #8
    ushr v20.4h, v31.4h, #4
    ushr v21.4h,  v1.4h, #4

    shl v6.4h, v29.4h, #4
    shl v7.4h, v30.4h, #4
    shl v8.4h, v31.4h, #8
    shl v9.4h,  v1.4h, #8

    eor v10.8b, v2.8b, v6.8b
    eor v11.8b, v3.8b, v7.8b
    eor v12.8b, v4.8b, v8.8b
    eor v13.8b, v5.8b, v9.8b

    and v14.8b, v27.8b, v0.8b
    and v15.8b, v28.8b, v0.8b
    and v16.8b, v10.8b, v0.8b
    and v17.8b, v11.8b, v0.8b
    and v18.8b, v12.8b, v0.8b
    and v19.8b, v13.8b, v0.8b

    #store
    str d14, [dst, #0*8]
    str d15, [dst, #1*8]
    str d16, [dst, #2*8]
    str d17, [dst, #3*8]
    str d18, [dst, #4*8]
    str d19, [dst, #5*8]
    str d20, [dst, #6*8]
    str d21, [dst, #7*8]

    .unreq    dst
    .unreq    src
    .unreq    counter

    ret


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

    sshr  v9.8h, v1.8h, #15
    sshr v10.8h, v2.8h, #15
    sshr v11.8h, v3.8h, #15
    sshr v12.8h, v4.8h, #15
    sshr v13.8h, v5.8h, #15
    sshr v14.8h, v6.8h, #15
    sshr v15.8h, v7.8h, #15
    sshr v16.8h, v8.8h, #15

    and v17.16b,  v9.16b, v0.16b
    and v18.16b, v10.16b, v0.16b
    and v19.16b, v11.16b, v0.16b
    and v20.16b, v12.16b, v0.16b
    and v21.16b, v13.16b, v0.16b
    and v22.16b, v14.16b, v0.16b
    and v23.16b, v15.16b, v0.16b
    and v24.16b, v16.16b, v0.16b

    add v25.8h, v1.8h, v17.8h
    add v26.8h, v2.8h, v18.8h
    add v27.8h, v3.8h, v19.8h
    add v28.8h, v4.8h, v20.8h
    add v29.8h, v5.8h, v21.8h
    add v30.8h, v6.8h, v22.8h
    add v31.8h, v7.8h, v23.8h
    add  v1.8h, v8.8h, v24.8h

    ushr v2.8h, v27.8h, #4
    ushr v3.8h, v28.8h, #4
    ushr v4.8h, v29.8h, #8
    ushr v5.8h, v30.8h, #8

    shl  v6.8h, v27.8h, #12
    shl  v7.8h, v28.8h, #12
    shl  v8.8h, v29.8h, #8
    shl  v9.8h, v30.8h, #8
    shl v10.8h, v31.8h, #4
    shl v11.8h,  v1.8h, #4

    eor v12.16b, v25.16b,  v6.16b  
    eor v13.16b, v26.16b,  v7.16b 
    eor v14.16b,  v2.16b,  v8.16b 
    eor v15.16b,  v3.16b,  v9.16b
    eor v16.16b,  v4.16b, v10.16b
    eor v17.16b,  v5.16b, v11.16b

    #store
    st1 {v12.8h-v14.8h}, [dst], #48
    st1 {v15.8h-v17.8h}, [dst], #48

    subs counter, counter, #128
    b.ne _loop_tobytes

    #load
    ldr d18, [src, #0*8]
    ldr d19, [src, #1*8]
    ldr d20, [src, #2*8]
    ldr d21, [src, #3*8]
    ldr d22, [src, #4*8]
    ldr d23, [src, #5*8]
    ldr d24, [src, #6*8]
    ldr d25, [src, #7*8]

    sshr v26.4h, v18.4h, #15
    sshr v27.4h, v19.4h, #15
    sshr v28.4h, v20.4h, #15
    sshr v29.4h, v21.4h, #15
    sshr v30.4h, v22.4h, #15
    sshr v31.4h, v23.4h, #15
    sshr  v1.4h, v24.4h, #15
    sshr  v2.4h, v25.4h, #15

    and  v3.8b, v26.8b, v0.8b
    and  v4.8b, v27.8b, v0.8b
    and  v5.8b, v28.8b, v0.8b
    and  v6.8b, v29.8b, v0.8b
    and  v7.8b, v30.8b, v0.8b
    and  v8.8b, v31.8b, v0.8b
    and  v9.8b,  v1.8b, v0.8b
    and v10.8b,  v2.8b, v0.8b

    add v11.4h, v18.4h,  v3.4h
    add v12.4h, v19.4h,  v4.4h
    add v13.4h, v20.4h,  v5.4h
    add v14.4h, v21.4h,  v6.4h
    add v15.4h, v22.4h,  v7.4h
    add v16.4h, v23.4h,  v8.4h
    add v17.4h, v24.4h,  v9.4h
    add v18.4h, v25.4h, v10.4h

    ushr v19.4h, v13.4h, #4
    ushr v20.4h, v14.4h, #4
    ushr v21.4h, v15.4h, #8
    ushr v22.4h, v16.4h, #8

    shl v23.4h, v13.4h, #12
    shl v24.4h, v14.4h, #12
    shl v25.4h, v15.4h, #8
    shl v26.4h, v16.4h, #8
    shl v27.4h, v17.4h, #4
    shl v28.4h, v18.4h, #4

    eor v29.8b, v11.8b, v23.8b  
    eor v30.8b, v12.8b, v24.8b 
    eor v31.8b, v19.8b, v25.8b 
    eor  v1.8b, v20.8b, v26.8b
    eor  v2.8b, v21.8b, v27.8b
    eor  v3.8b, v22.8b, v28.8b

    #load
    str  d29, [dst, #0*8]
    str  d30, [dst, #1*8]
    str  d31, [dst, #2*8]
    str   d1, [dst, #3*8]
    str   d2, [dst, #4*8]
    str   d3, [dst, #5*8]

    .unreq    dst
    .unreq    src
    .unreq    counter
    
    ret

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
    ldr  q4, [src, #0*16]
    ldr  q5, [src, #1*16]
    ldr  q6, [src, #2*16]
    ldr  q7, [src, #3*16]
    ldr  q8, [src, #4*16]
    ldr  q9, [src, #5*16]

    #shuffle
    trn1 v10.2d, v4.2d, v7.2d
    trn2 v11.2d, v4.2d, v7.2d
    trn1 v12.2d, v5.2d, v8.2d
    trn2 v13.2d, v5.2d, v8.2d
    trn1 v14.2d, v6.2d, v9.2d
    trn2 v15.2d, v6.2d, v9.2d

    #shuffle
    trn1 v16.4s, v10.4s, v13.4s
    trn2 v17.4s, v10.4s, v13.4s
    trn1 v18.4s, v11.4s, v14.4s
    trn2 v19.4s, v11.4s, v14.4s
    trn1 v20.4s, v12.4s, v15.4s
    trn2 v21.4s, v12.4s, v15.4s

    #shuffle
    trn1 v4.8h, v16.8h, v19.8h
    trn2 v5.8h, v16.8h, v19.8h
    trn1 v6.8h, v17.8h, v20.8h
    trn2 v7.8h, v17.8h, v20.8h
    trn1 v8.8h, v18.8h, v21.8h
    trn2 v9.8h, v18.8h, v21.8h

    #store
    str  q4, [dst, #0*16]
    str  q5, [dst, #1*16]
    str  q6, [dst, #2*16]
    str  q7, [dst, #3*16]
    str  q8, [dst, #4*16]
    str  q9, [dst, #5*16]  

    add src, src, #96
    add dst, dst, #96
    cmp src, counter
    blt _loop_shuffle

    .unreq    dst
    .unreq    src
    .unreq    counter
    ret

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
    ldr  q4, [src, #0*16]
    ldr  q5, [src, #1*16]
    ldr  q6, [src, #2*16]
    ldr  q7, [src, #3*16]
    ldr  q8, [src, #4*16]
    ldr  q9, [src, #5*16]

    #shuffle
    trn1 v10.8h, v4.8h, v5.8h
    trn1 v11.8h, v6.8h, v7.8h
    trn1 v12.8h, v8.8h, v9.8h
    trn2 v13.8h, v4.8h, v5.8h
    trn2 v14.8h, v6.8h, v7.8h
    trn2 v15.8h, v8.8h, v9.8h

    #shuffle
    trn1 v16.4s, v10.4s, v11.4s
    trn1 v17.4s, v12.4s, v13.4s
    trn1 v18.4s, v14.4s, v15.4s
    trn2 v19.4s, v10.4s, v11.4s
    trn2 v20.4s, v12.4s, v13.4s
    trn2 v21.4s, v14.4s, v15.4s

    #shuffle
    trn1 v4.2d, v16.2d, v17.2d
    trn1 v5.2d, v18.2d, v19.2d
    trn1 v6.2d, v20.2d, v21.2d
    trn2 v7.2d, v16.2d, v17.2d
    trn2 v8.2d, v18.2d, v19.2d
    trn2 v9.2d, v20.2d, v21.2d
    
    #store
    str  q4, [dst, #0*16]
    str  q5, [dst, #1*16]
    str  q6, [dst, #2*16]
    str  q7, [dst, #3*16]
    str  q8, [dst, #4*16]
    str  q9, [dst, #5*16]  

    add src, src, #96
    add dst, dst, #96
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
    .hword 3457, 3457, 3457, 3457 
    .hword 3457, 3457, 3457, 3457
