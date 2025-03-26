.global poly_basemul_asm
.global _poly_basemul_asm
poly_basemul_asm:
_poly_basemul_asm:
    dst       .req x0
    src1      .req x1
    src2      .req x2
    table     .req x3
    counter   .req x8

    add counter, dst, #1152

    #load
    ldr  q0, [table, # 0*16]

_looptop:
    #load
    ldr  q1, [table, # 1*16]

    #load
    ldr q4, [src1, #0*16] //a0
    ldr q5, [src1, #1*16] //a1
    ldr q6, [src1, #2*16] //a2
    ldr q7, [src1, #3*16] //a3

    ldr q8,  [src2, #0*16] //b0
    ldr q9,  [src2, #1*16] //b1
    ldr q10, [src2, #2*16] //b2
    ldr q11, [src2, #3*16] //b3

    smull  v12.4s, v5.4h, v11.4h //a1*b3
    smull2 v13.4s, v5.8h, v11.8h //a1*b3

    smlal  v12.4s, v6.4h, v10.4h //a2*b2
    smlal2 v13.4s, v6.8h, v10.8h //a2*b2

    smlal  v12.4s, v7.4h, v9.4h //a3*b1
    smlal2 v13.4s, v7.8h, v9.8h //a3*b1
  
    smull  v14.4s, v6.4h, v11.4h //a2*b3
    smull2 v15.4s, v6.8h, v11.8h //a2*b3

    smlal  v14.4s, v7.4h, v10.4h //a3*b2
    smlal2 v15.4s, v7.8h, v10.8h //a3*b2

    smull  v16.4s, v7.4h, v11.4h //a3*b3
    smull2 v17.4s, v7.8h, v11.8h //a3*b3

    uzp1 v18.8h, v12.8h, v13.8h
    uzp1 v19.8h, v14.8h, v15.8h
    uzp1 v20.8h, v16.8h, v17.8h

    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    mul v20.8h, v20.8h, v0.h[1]

    smlal  v12.4s, v18.4h, v0.h[0]
    smlal2 v13.4s, v18.8h, v0.h[0]
    smlal  v14.4s, v19.4h, v0.h[0]
    smlal2 v15.4s, v19.8h, v0.h[0]
    smlal  v16.4s, v20.4h, v0.h[0]
    smlal2 v17.4s, v20.8h, v0.h[0]

    uzp2 v28.8h, v12.8h, v13.8h
    uzp2 v29.8h, v14.8h, v15.8h
    uzp2 v30.8h, v16.8h, v17.8h

    smull  v12.4s, v28.4h, v1.4h //r[0]*zeta
    smull2 v13.4s, v28.8h, v1.8h //r[0]*zeta

    smlal  v12.4s, v4.4h, v8.4h //a0*b0
    smlal2 v13.4s, v4.8h, v8.8h //a0*b0

    smull  v14.4s, v29.4h, v1.4h //r[1]*zeta
    smull2 v15.4s, v29.8h, v1.8h //r[1]*zeta

    smlal  v14.4s, v4.4h, v9.4h //a0*b1
    smlal2 v15.4s, v4.8h, v9.8h //a0*b1

    smlal  v14.4s, v5.4h, v8.4h //a1*b0
    smlal2 v15.4s, v5.8h, v8.8h //a1*b0
  
    smull  v16.4s, v30.4h, v1.4h //r[2]*zeta
    smull2 v17.4s, v30.8h, v1.8h //r[2]*zeta
    
    smlal  v16.4s, v4.4h, v10.4h //a0*b2
    smlal2 v17.4s, v4.8h, v10.8h //a0*b2

    smlal  v16.4s, v5.4h, v9.4h //a1*b1
    smlal2 v17.4s, v5.8h, v9.8h //a1*b1

    smlal  v16.4s, v6.4h, v8.4h //a2*b0
    smlal2 v17.4s, v6.8h, v8.8h //a2*b0

    smull  v18.4s, v4.4h, v11.4h //a0*b3
    smull2 v19.4s, v4.8h, v11.8h //a0*b3

    smlal  v18.4s, v5.4h, v10.4h //a1*b2
    smlal2 v19.4s, v5.8h, v10.8h //a1*b2

    smlal  v18.4s, v6.4h, v9.4h //a2*b1
    smlal2 v19.4s, v6.8h, v9.8h //a2*b1

    smlal  v18.4s, v7.4h, v8.4h //a3*b0
    smlal2 v19.4s, v7.8h, v8.8h //a3*b0

    uzp1 v20.8h, v12.8h, v13.8h
    uzp1 v21.8h, v14.8h, v15.8h
    uzp1 v22.8h, v16.8h, v17.8h
    uzp1 v23.8h, v18.8h, v19.8h

    mul v20.8h, v20.8h, v0.h[1]
    mul v21.8h, v21.8h, v0.h[1]
    mul v22.8h, v22.8h, v0.h[1]
    mul v23.8h, v23.8h, v0.h[1]

    smlal  v12.4s, v20.4h, v0.h[0]
    smlal2 v13.4s, v20.8h, v0.h[0]
    smlal  v14.4s, v21.4h, v0.h[0]
    smlal2 v15.4s, v21.8h, v0.h[0]
    smlal  v16.4s, v22.4h, v0.h[0]
    smlal2 v17.4s, v22.8h, v0.h[0]
    smlal  v18.4s, v23.4h, v0.h[0]
    smlal2 v19.4s, v23.8h, v0.h[0]

    uzp2 v4.8h, v12.8h, v13.8h
    uzp2 v5.8h, v14.8h, v15.8h
    uzp2 v6.8h, v16.8h, v17.8h
    uzp2 v7.8h, v18.8h, v19.8h

    #reduce
    sqdmulh v28.8h,  v4.8h, v0.h[1]
    sqdmulh v29.8h,  v5.8h, v0.h[1]
    sqdmulh v30.8h,  v6.8h, v0.h[1]
    sqdmulh v31.8h,  v7.8h, v0.h[1]

    srshr   v28.8h, v28.8h, #11
    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls      v4.8h, v28.8h, v0.h[0]
    mls      v5.8h, v29.8h, v0.h[0]
    mls      v6.8h, v30.8h, v0.h[0]
    mls      v7.8h, v31.8h, v0.h[0]

    #store
    str q4, [dst, #0*16]
    str q5, [dst, #1*16]
    str q6, [dst, #2*16]
    str q7, [dst, #3*16]

    add dst,  dst, #64
    add src1, src1, #64
    add src2, src2, #64
    add table, table, #16
    
    cmp dst, counter
    blt _looptop

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    table
    .unreq    counter

    ret



.global poly_basemul_add_asm
.global _poly_basemul_add_asm
poly_basemul_add_asm:
_poly_basemul_add_asm:
    dst       .req x0
    src1      .req x1
    src2      .req x2
    src3      .req x3    
    table     .req x4
    counter   .req x8

    add counter, dst, #1152

    #load
    ldr  q0, [table, # 0*16]

_looptop_add:
    #load
    ldr  q1, [table, # 1*16]

    #load
    ldr q4, [src1, #0*16] //a0
    ldr q5, [src1, #1*16] //a1
    ldr q6, [src1, #2*16] //a2
    ldr q7, [src1, #3*16] //a3

    ldr q8,  [src2, #0*16] //b0
    ldr q9,  [src2, #1*16] //b1
    ldr q10, [src2, #2*16] //b2
    ldr q11, [src2, #3*16] //b3

    ldr q12, [src3, #0*16] //c0
    ldr q13, [src3, #1*16] //c1
    ldr q14, [src3, #2*16] //c2
    ldr q15, [src3, #3*16] //c3

    smull  v16.4s, v5.4h, v11.4h //a1*b3
    smull2 v17.4s, v5.8h, v11.8h //a1*b3

    smlal  v16.4s, v6.4h, v10.4h //a2*b2
    smlal2 v17.4s, v6.8h, v10.8h //a2*b2

    smlal  v16.4s, v7.4h, v9.4h //a3*b1
    smlal2 v17.4s, v7.8h, v9.8h //a3*b1
  
    smull  v18.4s, v6.4h, v11.4h //a2*b3
    smull2 v19.4s, v6.8h, v11.8h //a2*b3

    smlal  v18.4s, v7.4h, v10.4h //a3*b2
    smlal2 v19.4s, v7.8h, v10.8h //a3*b2

    smull  v20.4s, v7.4h, v11.4h //a3*b3
    smull2 v21.4s, v7.8h, v11.8h //a3*b3

    uzp1 v22.8h, v16.8h, v17.8h
    uzp1 v23.8h, v18.8h, v19.8h
    uzp1 v24.8h, v20.8h, v21.8h

    mul v22.8h, v22.8h, v0.h[1]
    mul v23.8h, v23.8h, v0.h[1]
    mul v24.8h, v24.8h, v0.h[1]

    smlal  v16.4s, v22.4h, v0.h[0]
    smlal2 v17.4s, v22.8h, v0.h[0]
    smlal  v18.4s, v23.4h, v0.h[0]
    smlal2 v19.4s, v23.8h, v0.h[0]
    smlal  v20.4s, v24.4h, v0.h[0]
    smlal2 v21.4s, v24.8h, v0.h[0]

    uzp2 v28.8h, v16.8h, v17.8h
    uzp2 v29.8h, v18.8h, v19.8h
    uzp2 v30.8h, v20.8h, v21.8h

    smull  v16.4s, v28.4h, v1.4h //r[0]*zeta
    smull2 v17.4s, v28.8h, v1.8h //r[0]*zeta

    smlal  v16.4s, v4.4h, v8.4h //a0*b0
    smlal2 v17.4s, v4.8h, v8.8h //a0*b0

    smlal  v16.4s, v12.4h, v0.h[2] //c0*R
    smlal2 v17.4s, v12.8h, v0.h[2] //c0*R

    smull  v18.4s, v29.4h, v1.4h //r[1]*zeta
    smull2 v19.4s, v29.8h, v1.8h //r[1]*zeta

    smlal  v18.4s, v4.4h, v9.4h //a0*b1
    smlal2 v19.4s, v4.8h, v9.8h //a0*b1

    smlal  v18.4s, v5.4h, v8.4h //a1*b0
    smlal2 v19.4s, v5.8h, v8.8h //a1*b0
  
    smlal  v18.4s, v13.4h, v0.h[2] //c1*R
    smlal2 v19.4s, v13.8h, v0.h[2] //c1*R

    smull  v20.4s, v30.4h, v1.4h //r[2]*zeta
    smull2 v21.4s, v30.8h, v1.8h //r[2]*zeta
    
    smlal  v20.4s, v4.4h, v10.4h //a0*b2
    smlal2 v21.4s, v4.8h, v10.8h //a0*b2

    smlal  v20.4s, v5.4h, v9.4h //a1*b1
    smlal2 v21.4s, v5.8h, v9.8h //a1*b1

    smlal  v20.4s, v6.4h, v8.4h //a2*b0
    smlal2 v21.4s, v6.8h, v8.8h //a2*b0

    smlal  v20.4s, v14.4h, v0.h[2] //c2*R
    smlal2 v21.4s, v14.8h, v0.h[2] //c2*R

    smull  v22.4s, v4.4h, v11.4h //a0*b3
    smull2 v23.4s, v4.8h, v11.8h //a0*b3

    smlal  v22.4s, v5.4h, v10.4h //a1*b2
    smlal2 v23.4s, v5.8h, v10.8h //a1*b2

    smlal  v22.4s, v6.4h, v9.4h //a2*b1
    smlal2 v23.4s, v6.8h, v9.8h //a2*b1

    smlal  v22.4s, v7.4h, v8.4h //a3*b0
    smlal2 v23.4s, v7.8h, v8.8h //a3*b0

    smlal  v22.4s, v15.4h, v0.h[2] //c3*R
    smlal2 v23.4s, v15.8h, v0.h[2] //c3*R

    uzp1 v24.8h, v16.8h, v17.8h
    uzp1 v25.8h, v18.8h, v19.8h
    uzp1 v26.8h, v20.8h, v21.8h
    uzp1 v27.8h, v22.8h, v23.8h

    mul v24.8h, v24.8h, v0.h[1]
    mul v25.8h, v25.8h, v0.h[1]
    mul v26.8h, v26.8h, v0.h[1]
    mul v27.8h, v27.8h, v0.h[1]

    smlal  v16.4s, v24.4h, v0.h[0]
    smlal2 v17.4s, v24.8h, v0.h[0]
    smlal  v18.4s, v25.4h, v0.h[0]
    smlal2 v19.4s, v25.8h, v0.h[0]
    smlal  v20.4s, v26.4h, v0.h[0]
    smlal2 v21.4s, v26.8h, v0.h[0]
    smlal  v22.4s, v27.4h, v0.h[0]
    smlal2 v23.4s, v27.8h, v0.h[0]

    uzp2 v4.8h, v16.8h, v17.8h
    uzp2 v5.8h, v18.8h, v19.8h
    uzp2 v6.8h, v20.8h, v21.8h
    uzp2 v7.8h, v22.8h, v23.8h

    #reduce
    sqdmulh v28.8h,  v4.8h, v0.h[1]
    sqdmulh v29.8h,  v5.8h, v0.h[1]
    sqdmulh v30.8h,  v6.8h, v0.h[1]
    sqdmulh v31.8h,  v7.8h, v0.h[1]

    srshr   v28.8h, v28.8h, #11
    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls      v4.8h, v28.8h, v0.h[0]
    mls      v5.8h, v29.8h, v0.h[0]
    mls      v6.8h, v30.8h, v0.h[0]
    mls      v7.8h, v31.8h, v0.h[0]

    #store
    str q4, [dst, #0*16]
    str q5, [dst, #1*16]
    str q6, [dst, #2*16]
    str q7, [dst, #3*16]

    add dst,  dst, #64
    add src1, src1, #64
    add src2, src2, #64
    add src3, src3, #64
    add table, table, #16
    
    cmp dst, counter
    blt _looptop_add

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    table
    .unreq    counter

    ret
