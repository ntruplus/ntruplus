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

    ushr  v25.8h, v19.8h, #12
    shl   v26.8h, v20.8h, #4
    ushr  v27.8h, v20.8h, #8
    shl   v28.8h, v21.8h, #8
    ushr  v29.8h, v21.8h, #4
    
    ushr  v30.8h, v22.8h, #12
    shl   v31.8h, v23.8h, #4
    ushr  v1.8h,  v23.8h, #8
    shl   v2.8h,  v24.8h, #8
    ushr  v3.8h,  v24.8h, #4

    eor v4.16b, v25.16b, v26.16b
    eor v5.16b, v27.16b, v28.16b
    eor v6.16b, v30.16b, v31.16b
    eor v7.16b, v1.16b,  v2.16b

    and v8.16b,  v19.16b, v0.16b
    and v9.16b,  v4.16b,  v0.16b
    and v10.16b, v5.16b,  v0.16b
    and v11.16b, v29.16b, v0.16b
    and v12.16b, v22.16b, v0.16b
    and v13.16b, v6.16b,  v0.16b
    and v14.16b, v7.16b,  v0.16b
    and v15.16b, v3.16b,  v0.16b

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
    ldr  d7, [src, #0*8]
    ldr  d8, [src, #1*8]
    ldr  d9, [src, #2*8]
    ldr  d10, [src, #3*8]
    ldr  d11, [src, #4*8]
    ldr  d12, [src, #5*8]

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

    ushr  v25.4h, v19.4h, #12
    shl   v26.4h, v20.4h, #4
    ushr  v27.4h, v20.4h, #8
    shl   v28.4h, v21.4h, #8
    ushr  v29.4h, v21.4h, #4
    
    ushr  v30.4h, v22.4h, #12
    shl   v31.4h, v23.4h, #4
    ushr  v1.4h,  v23.4h, #8
    shl   v2.4h,  v24.4h, #8
    ushr  v3.4h,  v24.4h, #4

    eor v4.8b, v25.8b, v26.8b
    eor v5.8b, v27.8b, v28.8b
    eor v6.8b, v30.8b, v31.8b
    eor v7.8b, v1.8b,  v2.8b

    and v8.8b,  v19.8b, v0.8b
    and v9.8b,  v4.8b,  v0.8b
    and v10.8b, v5.8b,  v0.8b
    and v11.8b, v29.8b, v0.8b
    and v12.8b, v22.8b, v0.8b
    and v13.8b, v6.8b,  v0.8b
    and v14.8b, v7.8b,  v0.8b
    and v15.8b, v3.8b,  v0.8b

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
    str d24, [dst, #0*8]
    str d25, [dst, #1*8]
    str d26, [dst, #2*8]
    str d27, [dst, #3*8]
    str d28, [dst, #4*8]
    str d29, [dst, #5*8]
    str d30, [dst, #6*8]
    str d31, [dst, #7*8]

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

    sshr v2.8h, v25.8h, #15
    sshr v3.8h, v26.8h, #15
    sshr v4.8h, v27.8h, #15
    sshr v5.8h, v28.8h, #15
    sshr v6.8h, v29.8h, #15
    sshr v7.8h, v30.8h, #15
    sshr v8.8h, v31.8h, #15
    sshr v9.8h, v1.8h,  #15

    and v10.16b, v2.16b, v0.16b
    and v11.16b, v3.16b, v0.16b
    and v12.16b, v4.16b, v0.16b
    and v13.16b, v5.16b, v0.16b
    and v14.16b, v6.16b, v0.16b
    and v15.16b, v7.16b, v0.16b
    and v16.16b, v8.16b, v0.16b
    and v17.16b, v9.16b, v0.16b

    add v18.8h, v25.8h, v10.8h
    add v19.8h, v26.8h, v11.8h
    add v20.8h, v27.8h, v12.8h
    add v21.8h, v28.8h, v13.8h
    add v22.8h, v29.8h, v14.8h
    add v23.8h, v30.8h, v15.8h
    add v24.8h, v31.8h, v16.8h
    add v25.8h, v1.8h,  v17.8h

    ushr v26.8h, v19.8h, #4
    ushr v27.8h, v20.8h, #8
    ushr v28.8h, v23.8h, #4
    ushr v29.8h, v24.8h, #8

    shl  v30.8h, v19.8h, #12
    shl  v31.8h, v20.8h, #8
    shl  v1.8h,  v21.8h, #4
    shl  v2.8h,  v23.8h, #12
    shl  v3.8h,  v24.8h, #8
    shl  v4.8h,  v25.8h, #4

    eor v5.16b,  v18.16b, v30.16b  
    eor v6.16b,  v26.16b, v31.16b 
    eor v7.16b,  v27.16b, v1.16b
    eor v8.16b,  v22.16b, v2.16b 
    eor v9.16b,  v28.16b, v3.16b
    eor v10.16b, v29.16b, v4.16b

    trn1 v11.8h, v5.8h, v6.8h
    trn1 v12.8h, v7.8h, v8.8h
    trn1 v13.8h, v9.8h, v10.8h
    trn2 v14.8h, v5.8h, v6.8h
    trn2 v15.8h, v7.8h, v8.8h
    trn2 v16.8h, v9.8h, v10.8h

    trn1 v17.4s, v11.4s, v12.4s
    trn1 v18.4s, v13.4s, v14.4s
    trn1 v19.4s, v15.4s, v16.4s
    trn2 v20.4s, v11.4s, v12.4s
    trn2 v21.4s, v13.4s, v14.4s
    trn2 v22.4s, v15.4s, v16.4s

    trn1 v23.2d, v17.2d, v18.2d
    trn1 v24.2d, v19.2d, v20.2d
    trn1 v25.2d, v21.2d, v22.2d
    trn2 v26.2d, v17.2d, v18.2d
    trn2 v27.2d, v19.2d, v20.2d
    trn2 v28.2d, v21.2d, v22.2d

    #store
    st1 {v23.8h-v25.8h},  [dst], #48
    st1 {v26.8h-v28.8h}, [dst], #48

    subs counter, counter, #128
    b.ne _loop_tobytes

    #load
    ldr d9, [src, #0*8]
    ldr d10, [src, #1*8]
    ldr d11, [src, #2*8]
    ldr d12, [src, #3*8]
    ldr d13, [src, #4*8]
    ldr d14, [src, #5*8]
    ldr d15, [src, #6*8]
    ldr d16, [src, #7*8]

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

    sshr v2.4h, v25.4h, #15
    sshr v3.4h, v26.4h, #15
    sshr v4.4h, v27.4h, #15
    sshr v5.4h, v28.4h, #15
    sshr v6.4h, v29.4h, #15
    sshr v7.4h, v30.4h, #15
    sshr v8.4h, v31.4h, #15
    sshr v9.4h, v1.4h,  #15

    and v10.8b, v2.8b, v0.8b
    and v11.8b, v3.8b, v0.8b
    and v12.8b, v4.8b, v0.8b
    and v13.8b, v5.8b, v0.8b
    and v14.8b, v6.8b, v0.8b
    and v15.8b, v7.8b, v0.8b
    and v16.8b, v8.8b, v0.8b
    and v17.8b, v9.8b, v0.8b

    add v18.4h, v25.4h, v10.4h
    add v19.4h, v26.4h, v11.4h
    add v20.4h, v27.4h, v12.4h
    add v21.4h, v28.4h, v13.4h
    add v22.4h, v29.4h, v14.4h
    add v23.4h, v30.4h, v15.4h
    add v24.4h, v31.4h, v16.4h
    add v25.4h, v1.4h,  v17.4h

    ushr v26.4h, v19.4h, #4
    ushr v27.4h, v20.4h, #8
    ushr v28.4h, v23.4h, #4
    ushr v29.4h, v24.4h, #8

    shl  v30.4h, v19.4h, #12
    shl  v31.4h, v20.4h, #8
    shl  v1.4h,  v21.4h, #4
    shl  v2.4h,  v23.4h, #12
    shl  v3.4h,  v24.4h, #8
    shl  v4.4h,  v25.4h, #4

    eor v5.8b,  v18.8b, v30.8b  
    eor v6.8b,  v26.8b, v31.8b 
    eor v7.8b,  v27.8b, v1.8b
    eor v8.8b,  v22.8b, v2.8b 
    eor v9.8b,  v28.8b, v3.8b
    eor v10.8b, v29.8b, v4.8b

    trn1 v11.4h, v5.4h, v6.4h
    trn1 v12.4h, v7.4h, v8.4h
    trn1 v13.4h, v9.4h, v10.4h
    trn2 v14.4h, v5.4h, v6.4h
    trn2 v15.4h, v7.4h, v8.4h
    trn2 v16.4h, v9.4h, v10.4h

    trn1 v17.2s, v11.2s, v12.2s
    trn1 v18.2s, v13.2s, v14.2s
    trn1 v19.2s, v15.2s, v16.2s
    trn2 v20.2s, v11.2s, v12.2s
    trn2 v21.2s, v13.2s, v14.2s
    trn2 v22.2s, v15.2s, v16.2s

    #load
    str  d17, [dst, #0*8]
    str  d18, [dst, #1*8]
    str  d19, [dst, #2*8]
    str  d20, [dst, #3*8]
    str  d21, [dst, #4*8]
    str  d22, [dst, #5*8]

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
