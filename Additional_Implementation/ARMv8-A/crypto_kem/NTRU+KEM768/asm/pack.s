.global poly_frombytes_asm
.global _poly_frombytes_asm
poly_frombytes_asm:
_poly_frombytes_asm:
    dst       .req x0
    src       .req x1
    table     .req x2
    counter   .req x8

    ldr  q0, [table, # 0*16]

    add counter, dst, #1536

_loop_frombytes:
    #load
    ldr  q4, [src, #0*16]
    ldr  q5, [src, #1*16]
    ldr  q6, [src, #2*16]    
    ldr  q7, [src, #3*16]
    ldr  q8, [src, #4*16]
    ldr  q9, [src, #5*16]

    and  v10.16b, v4.16b, v0.16b
    and  v11.16b, v5.16b, v0.16b
    ushr v4.8h, v4.8h, #12
    ushr v5.8h, v5.8h, #12
    shl v30.8h, v6.8h, #4
    shl v31.8h, v7.8h, #4
    eor  v4.16b, v4.16b, v30.16b
    eor  v5.16b, v5.16b, v31.16b
    and  v12.16b, v4.16b, v0.16b
    and  v13.16b, v5.16b, v0.16b
    ushr v4.8h, v6.8h, #8
    ushr v5.8h, v7.8h, #8
    shl v30.8h, v8.8h, #8
    shl v31.8h, v9.8h, #8
    eor  v4.16b, v4.16b, v30.16b
    eor  v5.16b, v5.16b, v31.16b
    and  v14.16b, v4.16b, v0.16b
    and  v15.16b, v5.16b, v0.16b
    ushr v4.8h, v8.8h, #4
    ushr v5.8h, v9.8h, #4
    and  v16.16b, v4.16b, v0.16b
    and  v17.16b, v5.16b, v0.16b

    #shuffle
    trn1 v18.2d, v10.2d, v14.2d
    trn2 v19.2d, v10.2d, v14.2d
    trn1 v20.2d, v11.2d, v15.2d
    trn2 v21.2d, v11.2d, v15.2d
    trn1 v22.2d, v12.2d, v16.2d
    trn2 v23.2d, v12.2d, v16.2d
    trn1 v24.2d, v13.2d, v17.2d
    trn2 v25.2d, v13.2d, v17.2d

    trn1 v10.4s, v18.4s, v22.4s
    trn2 v11.4s, v18.4s, v22.4s
    trn1 v12.4s, v19.4s, v23.4s
    trn2 v13.4s, v19.4s, v23.4s
    trn1 v14.4s, v20.4s, v24.4s
    trn2 v15.4s, v20.4s, v24.4s
    trn1 v16.4s, v21.4s, v25.4s
    trn2 v17.4s, v21.4s, v25.4s

    trn1 v4.8h, v10.8h, v14.8h
    trn2 v5.8h, v10.8h, v14.8h
    trn1 v6.8h, v11.8h, v15.8h
    trn2 v7.8h, v11.8h, v15.8h
    trn1 v8.8h, v12.8h, v16.8h
    trn2 v9.8h, v12.8h, v16.8h
    trn1 v10.8h, v13.8h, v17.8h
    trn2 v11.8h, v13.8h, v17.8h

    #store
    str q4, [dst, #0*16]
    str q5, [dst, #1*16]
    str q6, [dst, #2*16]
    str q7, [dst, #3*16]
    str q8, [dst, #4*16]
    str q9, [dst, #5*16]
    str q10, [dst, #6*16]
    str q11, [dst, #7*16]

    add src, src, #96
    add dst, dst, #128
    cmp dst, counter
    blt _loop_frombytes

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
    table     .req x2
    counter   .req x8

    ldr  q0, [table, # 0*16]

    add counter, src, #1536

_loop_tobytes:
    #load
    ldr  q4, [src, #0*16]
    ldr  q5, [src, #1*16]
    ldr  q6, [src, #2*16]
    ldr  q7, [src, #3*16]
    ldr  q8, [src, #4*16]
    ldr  q9, [src, #5*16]
    ldr q10, [src, #6*16]
    ldr q11, [src, #7*16]

    #shuffle
    trn1 v12.2d, v4.2d, v8.2d
    trn2 v13.2d, v4.2d, v8.2d
    trn1 v14.2d, v5.2d, v9.2d
    trn2 v15.2d, v5.2d, v9.2d
    trn1 v16.2d, v6.2d, v10.2d
    trn2 v17.2d, v6.2d, v10.2d
    trn1 v18.2d, v7.2d, v11.2d
    trn2 v19.2d, v7.2d, v11.2d

    trn1 v20.4s, v12.4s, v16.4s
    trn2 v21.4s, v12.4s, v16.4s
    trn1 v22.4s, v13.4s, v17.4s
    trn2 v23.4s, v13.4s, v17.4s
    trn1 v24.4s, v14.4s, v18.4s
    trn2 v25.4s, v14.4s, v18.4s
    trn1 v26.4s, v15.4s, v19.4s
    trn2 v27.4s, v15.4s, v19.4s

    trn1  v4.8h, v20.8h, v24.8h
    trn2  v5.8h, v20.8h, v24.8h
    trn1  v6.8h, v21.8h, v25.8h
    trn2  v7.8h, v21.8h, v25.8h
    trn1  v8.8h, v22.8h, v26.8h
    trn2  v9.8h, v22.8h, v26.8h
    trn1 v10.8h, v23.8h, v27.8h
    trn2 v11.8h, v23.8h, v27.8h

    #make it positive
    sshr v12.8h, v4.8h, #15
    sshr v13.8h, v5.8h, #15
    sshr v14.8h, v6.8h, #15
    sshr v15.8h, v7.8h, #15
    sshr v16.8h, v8.8h, #15
    sshr v17.8h, v9.8h, #15
    sshr v18.8h, v10.8h, #15
    sshr v19.8h, v11.8h, #15

    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b
    and v16.16b, v16.16b, v0.16b
    and v17.16b, v17.16b, v0.16b
    and v18.16b, v18.16b, v0.16b
    and v19.16b, v19.16b, v0.16b

    add   v4.8h,  v4.8h, v12.8h
    add   v5.8h,  v5.8h, v13.8h
    add   v6.8h,  v6.8h, v14.8h
    add   v7.8h,  v7.8h, v15.8h
    add   v8.8h,  v8.8h, v16.8h
    add   v9.8h,  v9.8h, v17.8h
    add  v10.8h, v10.8h, v18.8h
    add  v11.8h, v11.8h, v19.8h

    shl v28.8h, v6.8h, #12
    shl v29.8h, v7.8h, #12
    eor v4.16b, v4.16b, v28.16b  
    eor v5.16b, v5.16b, v29.16b
    shl v28.8h, v8.8h, #8
    shl v29.8h, v9.8h, #8
    ushr v30.8h, v6.8h, #4
    ushr v31.8h, v7.8h, #4
    eor v6.16b, v30.16b, v28.16b
    eor v7.16b, v31.16b, v29.16b
    shl v28.8h, v10.8h, #4
    shl v29.8h, v11.8h, #4
    ushr v30.8h, v8.8h, #8
    ushr v31.8h, v9.8h, #8
    eor v8.16b, v30.16b, v28.16b
    eor v9.16b, v31.16b, v29.16b

    #load
    str  q4, [dst, #0*16]
    str  q5, [dst, #1*16]
    str  q6, [dst, #2*16]    
    str  q7, [dst, #3*16]
    str  q8, [dst, #4*16]
    str  q9, [dst, #5*16]

    add src, src, #128
    add dst, dst, #96
    cmp src, counter
    blt _loop_tobytes

    .unreq    dst
    .unreq    src
    .unreq    counter
    ret
