.global poly_basemul_asm
.global _poly_basemul_asm
poly_basemul_asm:
_poly_basemul_asm:
    dst       .req x0
    src1      .req x1
    src2      .req x2
    table     .req x3
    counter   .req x8

    add counter, dst, #1728

    #load
    ldr  q0, [table, # 0*16]

_looptop:
    #load
    ldr  q1, [table, # 1*16]

    #load
    ldr q4, [src1, #0*16] //a0
    ldr q5, [src1, #1*16] //a1
    ldr q6, [src1, #2*16] //a2

    ldr q7, [src2, #0*16] //b0
    ldr q8, [src2, #1*16] //b1
    ldr q9, [src2, #2*16] //b2

    smull  v10.4s, v5.4h, v9.4h //a1*b2
    smull2 v11.4s, v5.8h, v9.8h //a1*b2

    smlal  v10.4s, v6.4h, v8.4h //a2*b1
    smlal2 v11.4s, v6.8h, v8.8h //a2*b1
  
    smull  v12.4s, v6.4h, v9.4h //a2*b2
    smull2 v13.4s, v6.8h, v9.8h //a2*b2

    uzp1 v14.8h, v10.8h, v11.8h
    uzp1 v15.8h, v12.8h, v13.8h

    mul v14.8h, v14.8h, v0.h[1]
    mul v15.8h, v15.8h, v0.h[1]

    smlal  v10.4s, v14.4h, v0.h[0]
    smlal2 v11.4s, v14.8h, v0.h[0]
    smlal  v12.4s, v15.4h, v0.h[0]
    smlal2 v13.4s, v15.8h, v0.h[0]

    uzp2 v29.8h, v10.8h, v11.8h
    uzp2 v30.8h, v12.8h, v13.8h

    smull  v10.4s, v29.4h, v1.4h //r[0]*zeta
    smull2 v11.4s, v29.8h, v1.8h //r[0]*zeta

    smlal  v10.4s, v4.4h, v7.4h //a0*b0
    smlal2 v11.4s, v4.8h, v7.8h //a0*b0

    smull  v12.4s, v30.4h, v1.4h //r[1]*zeta
    smull2 v13.4s, v30.8h, v1.8h //r[1]*zeta

    smlal  v12.4s, v4.4h, v8.4h //a0*b1
    smlal2 v13.4s, v4.8h, v8.8h //a0*b1

    smlal  v12.4s, v5.4h, v7.4h //a1*b0
    smlal2 v13.4s, v5.8h, v7.8h //a1*b0
  
    smull  v14.4s, v4.4h, v9.4h //a0*b2
    smull2 v15.4s, v4.8h, v9.8h //a0*b2

    smlal  v14.4s, v5.4h, v8.4h //a1*b1
    smlal2 v15.4s, v5.8h, v8.8h //a1*b1

    smlal  v14.4s, v6.4h, v7.4h //a2*b0
    smlal2 v15.4s, v6.8h, v7.8h //a2*b0

    uzp1 v16.8h, v10.8h, v11.8h
    uzp1 v17.8h, v12.8h, v13.8h
    uzp1 v18.8h, v14.8h, v15.8h

    mul v16.8h, v16.8h, v0.h[1]
    mul v17.8h, v17.8h, v0.h[1]
    mul v18.8h, v18.8h, v0.h[1]

    smlal  v10.4s, v16.4h, v0.h[0]
    smlal2 v11.4s, v16.8h, v0.h[0]
    smlal  v12.4s, v17.4h, v0.h[0]
    smlal2 v13.4s, v17.8h, v0.h[0]
    smlal  v14.4s, v18.4h, v0.h[0]
    smlal2 v15.4s, v18.8h, v0.h[0]

    uzp2 v4.8h, v10.8h, v11.8h
    uzp2 v5.8h, v12.8h, v13.8h
    uzp2 v6.8h, v14.8h, v15.8h

    #reduce
    sqdmulh v29.8h,  v4.8h, v0.h[1]
    sqdmulh v30.8h,  v5.8h, v0.h[1]
    sqdmulh v31.8h,  v6.8h, v0.h[1]

    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls      v4.8h, v29.8h, v0.h[0]
    mls      v5.8h, v30.8h, v0.h[0]
    mls      v6.8h, v31.8h, v0.h[0]

    #store
    str q4, [dst, #0*16]
    str q5, [dst, #1*16]
    str q6, [dst, #2*16]

    add dst,  dst, #48
    add src1, src1, #48
    add src2, src2, #48
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

    add counter, dst, #1728

    #load
    ldr  q0, [table, # 0*16]

_looptop_add:
    #load
    ldr  q1, [table, # 1*16]

    #load
    ldr q4, [src1, #0*16] //a0
    ldr q5, [src1, #1*16] //a1
    ldr q6, [src1, #2*16] //a2

    ldr q7, [src2, #0*16] //b0
    ldr q8, [src2, #1*16] //b1
    ldr q9, [src2, #2*16] //b2

    ldr q10, [src3, #0*16] //c0
    ldr q11, [src3, #1*16] //c1
    ldr q12, [src3, #2*16] //c2

    smull  v13.4s, v5.4h, v9.4h //a1*b2
    smull2 v14.4s, v5.8h, v9.8h //a1*b2

    smlal  v13.4s, v6.4h, v8.4h //a2*b1
    smlal2 v14.4s, v6.8h, v8.8h //a2*b1
  
    smull  v15.4s, v6.4h, v9.4h //a2*b2
    smull2 v16.4s, v6.8h, v9.8h //a2*b2

    uzp1 v17.8h, v13.8h, v14.8h
    uzp1 v18.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]
    mul v18.8h, v18.8h, v0.h[1]

    smlal  v13.4s, v17.4h, v0.h[0]
    smlal2 v14.4s, v17.8h, v0.h[0]
    smlal  v15.4s, v18.4h, v0.h[0]
    smlal2 v16.4s, v18.8h, v0.h[0]

    uzp2 v29.8h, v13.8h, v14.8h
    uzp2 v30.8h, v15.8h, v16.8h

    smull  v13.4s, v29.4h, v1.4h //r[0]*zeta
    smull2 v14.4s, v29.8h, v1.8h //r[0]*zeta

    smlal  v13.4s, v4.4h, v7.4h //a0*b0
    smlal2 v14.4s, v4.8h, v7.8h //a0*b0

    smlal  v13.4s, v10.4h, v0.h[2] //c0*R
    smlal2 v14.4s, v10.8h, v0.h[2] //c0*R

    smull  v15.4s, v30.4h, v1.4h //r[1]*zeta
    smull2 v16.4s, v30.8h, v1.8h //r[1]*zeta

    smlal  v15.4s, v4.4h, v8.4h //a0*b1
    smlal2 v16.4s, v4.8h, v8.8h //a0*b1

    smlal  v15.4s, v5.4h, v7.4h //a1*b0
    smlal2 v16.4s, v5.8h, v7.8h //a1*b0
  
    smlal  v15.4s, v11.4h, v0.h[2] //c1*R
    smlal2 v16.4s, v11.8h, v0.h[2] //c1*R

    smull  v17.4s, v4.4h, v9.4h //a0*b2
    smull2 v18.4s, v4.8h, v9.8h //a0*b2

    smlal  v17.4s, v5.4h, v8.4h //a1*b1
    smlal2 v18.4s, v5.8h, v8.8h //a1*b1

    smlal  v17.4s, v6.4h, v7.4h //a2*b0
    smlal2 v18.4s, v6.8h, v7.8h //a2*b0

    smlal  v17.4s, v12.4h, v0.h[2] //c1*R
    smlal2 v18.4s, v12.8h, v0.h[2] //c1*R

    uzp1 v19.8h, v13.8h, v14.8h
    uzp1 v20.8h, v15.8h, v16.8h
    uzp1 v21.8h, v17.8h, v18.8h

    mul v19.8h, v19.8h, v0.h[1]
    mul v20.8h, v20.8h, v0.h[1]
    mul v21.8h, v21.8h, v0.h[1]

    smlal  v13.4s, v19.4h, v0.h[0]
    smlal2 v14.4s, v19.8h, v0.h[0]
    smlal  v15.4s, v20.4h, v0.h[0]
    smlal2 v16.4s, v20.8h, v0.h[0]
    smlal  v17.4s, v21.4h, v0.h[0]
    smlal2 v18.4s, v21.8h, v0.h[0]

    uzp2 v4.8h, v13.8h, v14.8h
    uzp2 v5.8h, v15.8h, v16.8h
    uzp2 v6.8h, v17.8h, v18.8h

    #reduce
    sqdmulh v29.8h,  v4.8h, v0.h[1]
    sqdmulh v30.8h,  v5.8h, v0.h[1]
    sqdmulh v31.8h,  v6.8h, v0.h[1]

    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls      v4.8h, v29.8h, v0.h[0]
    mls      v5.8h, v30.8h, v0.h[0]
    mls      v6.8h, v31.8h, v0.h[0]

    #store
    str q4, [dst, #0*16]
    str q5, [dst, #1*16]
    str q6, [dst, #2*16]

    add dst,  dst, #48
    add src1, src1, #48
    add src2, src2, #48
    add src3, src3, #48    
    add table, table, #16
    
    cmp dst, counter
    blt _looptop_add

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    src3
    .unreq    table
    .unreq    counter

    ret
