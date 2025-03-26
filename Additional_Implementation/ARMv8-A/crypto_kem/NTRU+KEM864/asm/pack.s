.global poly_frombytes_asm
.global _poly_frombytes_asm
poly_frombytes_asm:
_poly_frombytes_asm:
    dst       .req x0
    src       .req x1
    table     .req x2
    counter   .req x8

    ldr  q0, [table, # 0*16]

    add counter, dst, #1664

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

    #store
    str q10, [dst, #0*16]
    str q11, [dst, #1*16]
    str q12, [dst, #2*16]
    str q13, [dst, #3*16]
    str q14, [dst, #4*16]
    str q15, [dst, #5*16]
    str q16, [dst, #6*16]
    str q17, [dst, #7*16]

    add src, src, #96
    add dst, dst, #128
    cmp dst, counter
    blt _loop_frombytes

    #load
    ldr  d4, [src, #0*8]
    ldr  d5, [src, #1*8]
    ldr  d6, [src, #2*8]
    ldr  d7, [src, #3*8]
    ldr  d8, [src, #4*8]
    ldr  d9, [src, #5*8]

    and  v10.8b, v4.8b, v0.8b
    and  v11.8b, v5.8b, v0.8b
    ushr v4.4h, v4.4h, #12
    ushr v5.4h, v5.4h, #12
    shl v30.4h, v6.4h, #4
    shl v31.4h, v7.4h, #4
    eor  v4.8b, v4.8b, v30.8b
    eor  v5.8b, v5.8b, v31.8b
    and  v12.8b, v4.8b, v0.8b
    and  v13.8b, v5.8b, v0.8b
    ushr v4.4h, v6.4h, #8
    ushr v5.4h, v7.4h, #8
    shl v30.4h, v8.4h, #8
    shl v31.4h, v9.4h, #8
    eor  v4.8b, v4.8b, v30.8b
    eor  v5.8b, v5.8b, v31.8b
    and  v14.8b, v4.8b, v0.8b
    and  v15.8b, v5.8b, v0.8b
    ushr v4.4h, v8.4h, #4
    ushr v5.4h, v9.4h, #4
    and  v16.8b, v4.8b, v0.8b
    and  v17.8b, v5.8b, v0.8b

    #store
    str d10, [dst, #0*8]
    str d11, [dst, #1*8]
    str d12, [dst, #2*8]
    str d13, [dst, #3*8]
    str d14, [dst, #4*8]
    str d15, [dst, #5*8]
    str d16, [dst, #6*8]
    str d17, [dst, #7*8]

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

    add counter, src, #1664

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

    #load
    ldr  d4, [src, #0*8]
    ldr  d5, [src, #1*8]
    ldr  d6, [src, #2*8]
    ldr  d7, [src, #3*8]
    ldr  d8, [src, #4*8]
    ldr  d9, [src, #5*8]
    ldr d10, [src, #6*8]
    ldr d11, [src, #7*8]

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
    str  d4, [dst, #0*8]
    str  d5, [dst, #1*8]
    str  d6, [dst, #2*8]    
    str  d7, [dst, #3*8]
    str  d8, [dst, #4*8]
    str  d9, [dst, #5*8]

    .unreq    dst
    .unreq    src
    .unreq    counter
    ret
