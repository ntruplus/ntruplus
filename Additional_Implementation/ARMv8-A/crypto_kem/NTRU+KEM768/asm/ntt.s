.global poly_ntt_asm
.global _poly_ntt_asm
poly_ntt_asm:
_poly_ntt_asm:
    dst       .req x0
    src       .req x1
    table     .req x2
    counter   .req x8
    
    ldr  q0, [table, # 0*16]
    ldr  q1, [table, # 1*16]
    ldr  q2, [table, # 2*16]
    ldr  q3, [table, # 3*16]

add counter, src, #128

_looptop_012:
    #level 0
    ldr q10, [src, #6*128]
    ldr q11, [src, #7*128]
    ldr q12, [src, #8*128]
    ldr q13, [src, #9*128]
    ldr q14, [src, #10*128]
    ldr q15, [src, #11*128]

    mul v16.8h, v10.8h, v0.h[4]
    mul v17.8h, v11.8h, v0.h[4]
    mul v18.8h, v12.8h, v0.h[4]
    mul v19.8h, v13.8h, v0.h[4]
    mul v20.8h, v14.8h, v0.h[4]
    mul v21.8h, v15.8h, v0.h[4]

    sqrdmulh v4.8h, v10.8h, v0.h[5]
    sqrdmulh v5.8h, v11.8h, v0.h[5]
    sqrdmulh v6.8h, v12.8h, v0.h[5]
    sqrdmulh v7.8h, v13.8h, v0.h[5]
    sqrdmulh v8.8h, v14.8h, v0.h[5]
    sqrdmulh v9.8h, v15.8h, v0.h[5]

    mls v16.8h, v4.8h, v0.h[0]
    mls v17.8h, v5.8h, v0.h[0]
    mls v18.8h, v6.8h, v0.h[0]
    mls v19.8h, v7.8h, v0.h[0]
    mls v20.8h, v8.8h, v0.h[0]
    mls v21.8h, v9.8h, v0.h[0]

    #update 1
    sub v10.8h, v10.8h, v16.8h
    sub v11.8h, v11.8h, v17.8h
    sub v12.8h, v12.8h, v18.8h
    sub v13.8h, v13.8h, v19.8h
    sub v14.8h, v14.8h, v20.8h
    sub v15.8h, v15.8h, v21.8h

    #load 2
    ldr q4, [src, #0*128]
    ldr q5, [src, #1*128]
    ldr q6, [src, #2*128]
    ldr q7, [src, #3*128]
    ldr q8, [src, #4*128]
    ldr q9, [src, #5*128]

    #update 2
    add v10.8h, v10.8h, v4.8h
    add v11.8h, v11.8h, v5.8h
    add v12.8h, v12.8h, v6.8h
    add v13.8h, v13.8h, v7.8h
    add v14.8h, v14.8h, v8.8h
    add v15.8h, v15.8h, v9.8h

    add v4.8h, v4.8h, v16.8h
    add v5.8h, v5.8h, v17.8h
    add v6.8h, v6.8h, v18.8h
    add v7.8h, v7.8h, v19.8h
    add v8.8h, v8.8h, v20.8h
    add v9.8h, v9.8h, v21.8h

    #level 1
    #mul 1
    mul v16.8h, v6.8h, v0.h[6]
    mul v17.8h, v7.8h, v0.h[6]
    mul v18.8h, v8.8h, v1.h[0]
    mul v19.8h, v9.8h, v1.h[0]

    sqrdmulh v6.8h, v6.8h, v0.h[7]
    sqrdmulh v7.8h, v7.8h, v0.h[7]
    sqrdmulh v8.8h, v8.8h, v1.h[1]
    sqrdmulh v9.8h, v9.8h, v1.h[1]

    mls v16.8h, v6.8h, v0.h[0] //t1
    mls v17.8h, v7.8h, v0.h[0] //t1
    mls v18.8h, v8.8h, v0.h[0] //t2
    mls v19.8h, v9.8h, v0.h[0] //t2

    sub  v6.8h, v16.8h, v18.8h
    sub  v7.8h, v17.8h, v19.8h

    #mul 2
    mul v20.8h,  v6.8h, v0.h[2]
    mul v21.8h,  v7.8h, v0.h[2]

    sqrdmulh  v6.8h, v6.8h, v0.h[3]
    sqrdmulh  v7.8h, v7.8h, v0.h[3]

    mls v20.8h, v6.8h, v0.h[0] //t3
    mls v21.8h, v7.8h, v0.h[0] //t3

    #update
    sub v8.8h, v4.8h, v16.8h //r[i] - t1
    sub v9.8h, v5.8h, v17.8h //r[i] - t1

    sub v6.8h, v4.8h, v18.8h //r[i] - t2
    sub v7.8h, v5.8h, v19.8h //r[i] - t2

    add v4.8h, v4.8h, v16.8h //r[i] + t1
    add v5.8h, v5.8h, v17.8h //r[i] + t1

    sub v8.8h, v8.8h, v20.8h //r[i] - t1 - t3
    sub v9.8h, v9.8h, v21.8h //r[i] - t1 - t3

    add v6.8h, v6.8h, v20.8h //r[i] - t2 + t3
    add v7.8h, v7.8h, v21.8h //r[i] - t2 + t3

    add v4.8h, v4.8h, v18.8h //r[i] + t1 + t2
    add v5.8h, v5.8h, v19.8h //r[i] + t1 + t2

    #mul 1
    mul v16.8h, v12.8h, v1.h[2]
    mul v17.8h, v13.8h, v1.h[2]
    mul v18.8h, v14.8h, v1.h[4]
    mul v19.8h, v15.8h, v1.h[4]

    sqrdmulh v12.8h, v12.8h, v1.h[3]
    sqrdmulh v13.8h, v13.8h, v1.h[3]
    sqrdmulh v14.8h, v14.8h, v1.h[5]
    sqrdmulh v15.8h, v15.8h, v1.h[5]

    mls v16.8h, v12.8h, v0.h[0] //t1
    mls v17.8h, v13.8h, v0.h[0] //t1
    mls v18.8h, v14.8h, v0.h[0] //t2
    mls v19.8h, v15.8h, v0.h[0] //t2

    sub  v12.8h, v16.8h, v18.8h
    sub  v13.8h, v17.8h, v19.8h

    #mul 2
    mul v20.8h,  v12.8h, v0.h[2]
    mul v21.8h,  v13.8h, v0.h[2]

    sqrdmulh  v12.8h, v12.8h, v0.h[3]
    sqrdmulh  v13.8h, v13.8h, v0.h[3]

    mls v20.8h, v12.8h, v0.h[0] //t3
    mls v21.8h, v13.8h, v0.h[0] //t3

    #update
    sub v14.8h, v10.8h, v16.8h //r[i] - t1
    sub v15.8h, v11.8h, v17.8h //r[i] - t1

    sub v12.8h, v10.8h, v18.8h //r[i] - t2
    sub v13.8h, v11.8h, v19.8h //r[i] - t2

    add v10.8h, v10.8h, v16.8h //r[i] + t1
    add v11.8h, v11.8h, v17.8h //r[i] + t1

    sub v14.8h, v14.8h, v20.8h //r[i] - t1 - t3
    sub v15.8h, v15.8h, v21.8h //r[i] - t1 - t3

    add v12.8h, v12.8h, v20.8h //r[i] - t2 + t3
    add v13.8h, v13.8h, v21.8h //r[i] - t2 + t3

    add v10.8h, v10.8h, v18.8h //r[i] + t1 + t2
    add v11.8h, v11.8h, v19.8h //r[i] + t1 + t2

    #level2
    #mul 1
    mul v16.8h,  v5.8h, v1.h[6]
    mul v17.8h,  v7.8h, v2.h[0]
    mul v18.8h,  v9.8h, v2.h[2]
    mul v19.8h, v11.8h, v2.h[4]
    mul v20.8h, v13.8h, v2.h[6]
    mul v21.8h, v15.8h, v3.h[0]

    sqrdmulh  v5.8h,  v5.8h, v1.h[7]
    sqrdmulh  v7.8h,  v7.8h, v2.h[1]
    sqrdmulh  v9.8h,  v9.8h, v2.h[3]
    sqrdmulh v11.8h, v11.8h, v2.h[5]
    sqrdmulh v13.8h, v13.8h, v2.h[7]
    sqrdmulh v15.8h, v15.8h, v3.h[1]

    mls v16.8h,  v5.8h, v0.h[0] //t1
    mls v17.8h,  v7.8h, v0.h[0] //t1
    mls v18.8h,  v9.8h, v0.h[0] //t1
    mls v19.8h, v11.8h, v0.h[0] //t2
    mls v20.8h, v13.8h, v0.h[0] //t2
    mls v21.8h, v15.8h, v0.h[0] //t2

    #update
    sub  v5.8h,  v4.8h, v16.8h
    sub  v7.8h,  v6.8h, v17.8h
    sub  v9.8h,  v8.8h, v18.8h
    sub v11.8h, v10.8h, v19.8h
    sub v13.8h, v12.8h, v20.8h
    sub v15.8h, v14.8h, v21.8h

    add  v4.8h,  v4.8h, v16.8h
    add  v6.8h,  v6.8h, v17.8h
    add  v8.8h,  v8.8h, v18.8h
    add v10.8h, v10.8h, v19.8h
    add v12.8h, v12.8h, v20.8h
    add v14.8h, v14.8h, v21.8h

    str q4, [dst, #0*128]
    str q5, [dst, #1*128]
    str q6, [dst, #2*128]
    str q7, [dst, #3*128]
    str q8, [dst, #4*128]
    str q9, [dst, #5*128]
    str q10, [dst, #6*128]
    str q11, [dst, #7*128]
    str q12, [dst, #8*128]
    str q13, [dst, #9*128]
    str q14, [dst, #10*128]
    str q15, [dst, #11*128]

    add src, src, #16
    add dst, dst, #16
    cmp src, counter
    blt _looptop_012

    sub src, src, #128
    sub dst, dst, #128

    add counter, dst, #1536

_looptop_3456:
    ldr  q0, [table, # 4*16]
    ldr  q1, [table, # 5*16]
    ldr  q2, [table, # 6*16]
    ldr  q3, [table, # 7*16]

    #load
    ldr  q4, [dst, #0*16]
    ldr  q5, [dst, #1*16]
    ldr  q6, [dst, #2*16]
    ldr  q7, [dst, #3*16]
    ldr  q8, [dst, #4*16]
    ldr  q9, [dst, #5*16]
    ldr q10, [dst, #6*16]
    ldr q11, [dst, #7*16]

    #level 3
    #mul
    mul v12.8h,  v8.8h, v0.h[2]
    mul v13.8h,  v9.8h, v0.h[2]
    mul v14.8h, v10.8h, v0.h[2]
    mul v15.8h, v11.8h, v0.h[2]

    sqrdmulh  v8.8h,  v8.8h, v0.h[3]
    sqrdmulh  v9.8h,  v9.8h, v0.h[3]
    sqrdmulh v10.8h, v10.8h, v0.h[3]
    sqrdmulh v11.8h, v11.8h, v0.h[3]

    mls v12.8h,  v8.8h, v0.h[0]
    mls v13.8h,  v9.8h, v0.h[0]
    mls v14.8h, v10.8h, v0.h[0]
    mls v15.8h, v11.8h, v0.h[0]

    #update
    sub  v8.8h, v4.8h, v12.8h
    sub  v9.8h, v5.8h, v13.8h
    sub v10.8h, v6.8h, v14.8h
    sub v11.8h, v7.8h, v15.8h

    add v4.8h, v4.8h, v12.8h
    add v5.8h, v5.8h, v13.8h
    add v6.8h, v6.8h, v14.8h
    add v7.8h, v7.8h, v15.8h

    #level 4
    #mul
    mul v12.8h,  v6.8h, v0.h[4]
    mul v13.8h,  v7.8h, v0.h[4]
    mul v14.8h, v10.8h, v0.h[6]
    mul v15.8h, v11.8h, v0.h[6]

    sqrdmulh  v6.8h,  v6.8h, v0.h[5]
    sqrdmulh  v7.8h,  v7.8h, v0.h[5]
    sqrdmulh v10.8h, v10.8h, v0.h[7]
    sqrdmulh v11.8h, v11.8h, v0.h[7]

    mls v12.8h,  v6.8h, v0.h[0]
    mls v13.8h,  v7.8h, v0.h[0]
    mls v14.8h, v10.8h, v0.h[0]
    mls v15.8h, v11.8h, v0.h[0]

    #update
    sub  v6.8h,  v4.8h, v12.8h
    sub  v7.8h,  v5.8h, v13.8h
    sub v10.8h,  v8.8h, v14.8h
    sub v11.8h,  v9.8h, v15.8h

    add  v4.8h,  v4.8h, v12.8h
    add  v5.8h,  v5.8h, v13.8h
    add  v8.8h,  v8.8h, v14.8h
    add  v9.8h,  v9.8h, v15.8h

    #reduce
    sqdmulh v28.8h,  v6.8h, v0.h[1]
    sqdmulh v29.8h,  v7.8h, v0.h[1]
    sqdmulh v30.8h, v10.8h, v0.h[1]
    sqdmulh v31.8h, v11.8h, v0.h[1]

    sqdmulh v24.8h, v4.8h, v0.h[1]
    sqdmulh v25.8h, v5.8h, v0.h[1]
    sqdmulh v26.8h, v8.8h, v0.h[1]
    sqdmulh v27.8h, v9.8h, v0.h[1]

    srshr v28.8h, v28.8h, #11
    srshr v29.8h, v29.8h, #11
    srshr v30.8h, v30.8h, #11
    srshr v31.8h, v31.8h, #11

    srshr v24.8h, v24.8h, #11
    srshr v25.8h, v25.8h, #11
    srshr v26.8h, v26.8h, #11
    srshr v27.8h, v27.8h, #11

    mls v6.8h, v28.8h, v0.h[0]
    mls v7.8h, v29.8h, v0.h[0]
    mls v10.8h, v30.8h, v0.h[0]
    mls v11.8h, v31.8h, v0.h[0]

    mls v4.8h, v24.8h, v0.h[0]
    mls v5.8h, v25.8h, v0.h[0]
    mls v8.8h, v26.8h, v0.h[0]
    mls v9.8h, v27.8h, v0.h[0]
    
    #level 5
    #mul
    mul v28.8h,  v5.8h, v1.h[0]
    mul v29.8h,  v7.8h, v1.h[2]
    mul v30.8h,  v9.8h, v1.h[4]
    mul v31.8h, v11.8h, v1.h[6]

    sqrdmulh  v5.8h,  v5.8h, v1.h[1]
    sqrdmulh  v7.8h,  v7.8h, v1.h[3]
    sqrdmulh  v9.8h,  v9.8h, v1.h[5]
    sqrdmulh v11.8h, v11.8h, v1.h[7]

    mls v28.8h,  v5.8h, v0.h[0]
    mls v29.8h,  v7.8h, v0.h[0]
    mls v30.8h,  v9.8h, v0.h[0]
    mls v31.8h, v11.8h, v0.h[0]

    #update
    sub  v5.8h,  v4.8h, v28.8h
    sub  v7.8h,  v6.8h, v29.8h
    sub  v9.8h,  v8.8h, v30.8h
    sub v11.8h, v10.8h, v31.8h

    add  v4.8h,  v4.8h, v28.8h
    add  v6.8h,  v6.8h, v29.8h
    add  v8.8h,  v8.8h, v30.8h
    add v10.8h, v10.8h, v31.8h

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

    #level 6
    #mul
    mul v28.8h,  v8.8h, v2.8h
    mul v29.8h,  v9.8h, v2.8h
    mul v30.8h, v10.8h, v2.8h
    mul v31.8h, v11.8h, v2.8h

    sqrdmulh  v8.8h,  v8.8h, v3.8h
    sqrdmulh  v9.8h,  v9.8h, v3.8h
    sqrdmulh v10.8h, v10.8h, v3.8h
    sqrdmulh v11.8h, v11.8h, v3.8h

    mls v28.8h,  v8.8h, v0.h[0]
    mls v29.8h,  v9.8h, v0.h[0]
    mls v30.8h, v10.8h, v0.h[0]
    mls v31.8h, v11.8h, v0.h[0]

    #update
    sub  v8.8h, v4.8h, v28.8h
    sub  v9.8h, v5.8h, v29.8h
    sub v10.8h, v6.8h, v30.8h
    sub v11.8h, v7.8h, v31.8h

    add v4.8h, v4.8h, v28.8h
    add v5.8h, v5.8h, v29.8h
    add v6.8h, v6.8h, v30.8h
    add v7.8h, v7.8h, v31.8h

    #reduce
    sqdmulh v28.8h,  v8.8h, v0.h[1]
    sqdmulh v29.8h,  v9.8h, v0.h[1]
    sqdmulh v30.8h,  v10.8h, v0.h[1]
    sqdmulh v31.8h,  v11.8h, v0.h[1]

    sqdmulh v24.8h,  v4.8h, v0.h[1]
    sqdmulh v25.8h,  v5.8h, v0.h[1]
    sqdmulh v26.8h,  v6.8h, v0.h[1]
    sqdmulh v27.8h,  v7.8h, v0.h[1]

    srshr   v28.8h, v28.8h, #11
    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    srshr   v24.8h, v24.8h, #11
    srshr   v25.8h, v25.8h, #11
    srshr   v26.8h, v26.8h, #11
    srshr   v27.8h, v27.8h, #11

    mls      v8.8h, v28.8h, v0.h[0]
    mls      v9.8h, v29.8h, v0.h[0]
    mls      v10.8h, v30.8h, v0.h[0]
    mls      v11.8h, v31.8h, v0.h[0]

    mls      v4.8h, v24.8h, v0.h[0]
    mls      v5.8h, v25.8h, v0.h[0]
    mls      v6.8h, v26.8h, v0.h[0]
    mls      v7.8h, v27.8h, v0.h[0]

    #store
    str q4, [dst, #0*16]
    str q5, [dst, #1*16]
    str q6, [dst, #2*16]
    str q7, [dst, #3*16]
    str q8, [dst, #4*16]
    str q9, [dst, #5*16]
    str q10, [dst, #6*16]
    str q11, [dst, #7*16]

    add dst, dst, #128
    add table, table, #64
    cmp dst, counter
    blt _looptop_3456

    .unreq    dst
    .unreq    src
    .unreq    table
    .unreq    counter

    ret


.global poly_invntt_asm
.global _poly_invntt_asm
poly_invntt_asm:
_poly_invntt_asm:
    dst       .req x0
    src       .req x1    
    table     .req x2
    counter   .req x8

    add counter, src, #1536

    _looptop_6543:
    #zetas
    ldr  q0, [table, # 0*16]
    ldr  q1, [table, # 1*16]
    ldr  q2, [table, # 2*16]
    ldr  q3, [table, # 3*16]

    #load
    ldr  q4, [src, #0*16]
    ldr  q5, [src, #1*16]
    ldr  q6, [src, #2*16]
    ldr  q7, [src, #3*16]
    ldr  q8, [src, #4*16]
    ldr  q9, [src, #5*16]
    ldr q10, [src, #6*16]
    ldr q11, [src, #7*16]

    #level 6
    #update
    sub v12.8h,  v8.8h, v4.8h
    sub v13.8h,  v9.8h, v5.8h
    sub v14.8h, v10.8h, v6.8h
    sub v15.8h, v11.8h, v7.8h

    add v4.8h, v4.8h,  v8.8h
    add v5.8h, v5.8h,  v9.8h
    add v6.8h, v6.8h, v10.8h
    add v7.8h, v7.8h, v11.8h

    #mul
    mul  v8.8h, v12.8h, v2.8h
    mul  v9.8h, v13.8h, v2.8h
    mul v10.8h, v14.8h, v2.8h
    mul v11.8h, v15.8h, v2.8h

    sqrdmulh v12.8h, v12.8h, v3.8h
    sqrdmulh v13.8h, v13.8h, v3.8h
    sqrdmulh v14.8h, v14.8h, v3.8h
    sqrdmulh v15.8h, v15.8h, v3.8h

    mls  v8.8h, v12.8h, v0.h[0]
    mls  v9.8h, v13.8h, v0.h[0]
    mls v10.8h, v14.8h, v0.h[0]
    mls v11.8h, v15.8h, v0.h[0]

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

    #level 5
    #update
    sub v12.8h,  v5.8h,  v4.8h
    sub v13.8h,  v7.8h,  v6.8h
    sub v14.8h,  v9.8h,  v8.8h
    sub v15.8h, v11.8h, v10.8h

    add  v4.8h,  v5.8h,  v4.8h
    add  v6.8h,  v7.8h,  v6.8h
    add  v8.8h,  v9.8h,  v8.8h
    add v10.8h, v11.8h, v10.8h

    #mul
    mul  v5.8h, v12.8h, v0.h[2]
    mul  v7.8h, v13.8h, v0.h[4]
    mul  v9.8h, v14.8h, v0.h[6]
    mul v11.8h, v15.8h, v1.h[0]

    sqrdmulh v12.8h, v12.8h, v0.h[3]
    sqrdmulh v13.8h, v13.8h, v0.h[5]
    sqrdmulh v14.8h, v14.8h, v0.h[7]
    sqrdmulh v15.8h, v15.8h, v1.h[1]

    mls  v5.8h, v12.8h, v0.h[0]
    mls  v7.8h, v13.8h, v0.h[0]
    mls  v9.8h, v14.8h, v0.h[0]
    mls v11.8h, v15.8h, v0.h[0]

    #level 4
    #update
    sub v12.8h, v6.8h, v4.8h
    sub v13.8h, v7.8h, v5.8h
    sub v14.8h, v10.8h, v8.8h
    sub v15.8h, v11.8h, v9.8h

    add v4.8h, v6.8h, v4.8h
    add v5.8h, v7.8h, v5.8h
    add v8.8h, v10.8h, v8.8h
    add v9.8h, v11.8h, v9.8h

    #mul
    mul  v6.8h, v12.8h, v1.h[2]
    mul  v7.8h, v13.8h, v1.h[2]
    mul v10.8h, v14.8h, v1.h[4]
    mul v11.8h, v15.8h, v1.h[4]

    sqrdmulh v12.8h, v12.8h, v1.h[3]
    sqrdmulh v13.8h, v13.8h, v1.h[3]
    sqrdmulh v14.8h, v14.8h, v1.h[5]
    sqrdmulh v15.8h, v15.8h, v1.h[5]

    mls  v6.8h, v12.8h, v0.h[0]
    mls  v7.8h, v13.8h, v0.h[0]
    mls v10.8h, v14.8h, v0.h[0]
    mls v11.8h, v15.8h, v0.h[0]

    #reduce
    sqdmulh v28.8h,  v4.8h, v0.h[1]
    sqdmulh v29.8h,  v5.8h, v0.h[1]
    sqdmulh v30.8h,  v8.8h, v0.h[1]
    sqdmulh v31.8h,  v9.8h, v0.h[1]

    srshr   v28.8h, v28.8h, #11
    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls      v4.8h, v28.8h, v0.h[0]
    mls      v5.8h, v29.8h, v0.h[0]
    mls      v8.8h, v30.8h, v0.h[0]
    mls      v9.8h, v31.8h, v0.h[0]

    #level 3
    #update
    sub v12.8h,  v8.8h, v4.8h
    sub v13.8h,  v9.8h, v5.8h
    sub v14.8h, v10.8h, v6.8h
    sub v15.8h, v11.8h, v7.8h

    add v4.8h,  v8.8h, v4.8h
    add v5.8h,  v9.8h, v5.8h
    add v6.8h, v10.8h, v6.8h
    add v7.8h, v11.8h, v7.8h

    #mul
    mul  v8.8h, v12.8h, v1.h[6]
    mul  v9.8h, v13.8h, v1.h[6]
    mul v10.8h, v14.8h, v1.h[6]
    mul v11.8h, v15.8h, v1.h[6]

    sqrdmulh v12.8h, v12.8h, v1.h[7]
    sqrdmulh v13.8h, v13.8h, v1.h[7]
    sqrdmulh v14.8h, v14.8h, v1.h[7]
    sqrdmulh v15.8h, v15.8h, v1.h[7]

    mls  v8.8h, v12.8h, v0.h[0]
    mls  v9.8h, v13.8h, v0.h[0]
    mls v10.8h, v14.8h, v0.h[0]
    mls v11.8h, v15.8h, v0.h[0]

    #store
    str q4, [dst, #0*16]
    str q5, [dst, #1*16]
    str q6, [dst, #2*16]
    str q7, [dst, #3*16]
    str q8, [dst, #4*16]
    str q9, [dst, #5*16]
    str q10, [dst, #6*16]
    str q11, [dst, #7*16]

    add src, src, #128
    add dst, dst, #128    
    add table, table, #64
    cmp src, counter
    blt _looptop_6543

    sub dst, dst, #1536

    ldr  q0, [table, # 0*16]
    ldr  q1, [table, # 1*16]
    ldr  q2, [table, # 2*16]
    ldr  q3, [table, # 3*16]

    add counter, dst, #128

_looptop_210:
    #load
    ldr  q5, [dst, #0*128]
    ldr  q6, [dst, #1*128]
    ldr  q7, [dst, #2*128]
    ldr  q8, [dst, #3*128]
    ldr  q9, [dst, #4*128]
    ldr q10, [dst, #5*128]
    ldr q11, [dst, #6*128]
    ldr q12, [dst, #7*128]
    ldr q13, [dst, #8*128]
    ldr q14, [dst, #9*128]
    ldr q15, [dst, #10*128]
    ldr q16, [dst, #11*128]

    #level 2
    #update 1
    sub  v17.8h,  v6.8h,  v5.8h
    sub  v18.8h,  v8.8h,  v7.8h
    sub  v19.8h, v10.8h,  v9.8h
    sub  v20.8h, v12.8h, v11.8h
    sub  v21.8h, v14.8h, v13.8h
    sub  v22.8h, v16.8h, v15.8h

    add   v5.8h,  v5.8h,  v6.8h
    add   v7.8h,  v7.8h,  v8.8h
    add   v9.8h,  v9.8h, v10.8h
    add  v11.8h, v11.8h, v12.8h
    add  v13.8h, v13.8h, v14.8h
    add  v15.8h, v15.8h, v16.8h

    #mul 1
    mul  v6.8h, v17.8h, v0.h[4]
    mul  v8.8h, v18.8h, v0.h[6]
    mul v10.8h, v19.8h, v1.h[0]
    mul v12.8h, v20.8h, v1.h[2]
    mul v14.8h, v21.8h, v1.h[4]
    mul v16.8h, v22.8h, v1.h[6]

    sqrdmulh v17.8h, v17.8h, v0.h[5]
    sqrdmulh v18.8h, v18.8h, v0.h[7]
    sqrdmulh v19.8h, v19.8h, v1.h[1]
    sqrdmulh v20.8h, v20.8h, v1.h[3]
    sqrdmulh v21.8h, v21.8h, v1.h[5]
    sqrdmulh v22.8h, v22.8h, v1.h[7]

    mls  v6.8h, v17.8h, v0.h[0]
    mls  v8.8h, v18.8h, v0.h[0]
    mls v10.8h, v19.8h, v0.h[0]
    mls v12.8h, v20.8h, v0.h[0]
    mls v14.8h, v21.8h, v0.h[0]
    mls v16.8h, v22.8h, v0.h[0]

    #level 1
    #update 1
    sub v30.8h, v7.8h, v5.8h //r[i + step] - r[i]
    sub v31.8h, v8.8h, v6.8h //r[i + step] - r[i]

    #mul 1
    mul v17.8h, v30.8h, v0.h[2]
    mul v18.8h, v31.8h, v0.h[2]

    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v17.8h, v30.8h, v0.h[0] //t1
    mls v18.8h, v31.8h, v0.h[0] //t1

    #update 2
    sub  v30.8h,  v9.8h,  v7.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v10.8h,  v8.8h //r[i + 2*step] - r[i + step]
    
    sub  v28.8h,  v9.8h,  v5.8h //r[i + 2*step] - r[i]
    sub  v29.8h, v10.8h,  v6.8h //r[i + 2*step] - r[i]

    add   v5.8h,  v5.8h,  v7.8h //r[i] + r[i + step]
    add   v6.8h,  v6.8h,  v8.8h //r[i] + r[i + step]

    sub  v30.8h, v30.8h, v17.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v18.8h //r[i + 2*step] - r[i + step] - t1

    add  v28.8h, v28.8h, v17.8h //r[i + 2*step] - r[i] + t1
    add  v29.8h, v29.8h, v18.8h //r[i + 2*step] - r[i] + t1
    
    add   v5.8h,  v5.8h,  v9.8h //r[i] + r[i + step] + r[i + 2*step]
    add   v6.8h,  v6.8h, v10.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul  v9.8h, v30.8h, v2.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v10.8h, v31.8h, v2.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul  v7.8h, v28.8h, v2.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul  v8.8h, v29.8h, v2.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v30.8h, v30.8h, v2.h[3]
    sqrdmulh v31.8h, v31.8h, v2.h[3]
    sqrdmulh v28.8h, v28.8h, v2.h[1]
    sqrdmulh v29.8h, v29.8h, v2.h[1]

    mls  v9.8h, v30.8h, v0.h[0]
    mls v10.8h, v31.8h, v0.h[0]
    mls  v7.8h, v28.8h, v0.h[0]
    mls  v8.8h, v29.8h, v0.h[0]

    #reduce
    sqdmulh v28.8h,  v5.8h, v0.h[1]
    sqdmulh v29.8h,  v6.8h, v0.h[1]

    srshr   v28.8h, v28.8h, #11
    srshr   v29.8h, v29.8h, #11

    mls      v5.8h, v28.8h, v0.h[0]
    mls      v6.8h, v29.8h, v0.h[0]

    #update 1
    sub v30.8h, v13.8h, v11.8h //r[i + step] - r[i]
    sub v31.8h, v14.8h, v12.8h //r[i + step] - r[i]

    #mul 1
    mul v17.8h, v30.8h, v0.h[2]
    mul v18.8h, v31.8h, v0.h[2]

    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v17.8h, v30.8h, v0.h[0] //t1
    mls v18.8h, v31.8h, v0.h[0] //t1

    #update 2
    sub  v30.8h, v15.8h, v13.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v16.8h, v14.8h //r[i + 2*step] - r[i + step]
    
    sub  v28.8h, v15.8h, v11.8h //r[i + 2*step] - r[i]
    sub  v29.8h, v16.8h, v12.8h //r[i + 2*step] - r[i]

    add v11.8h, v11.8h, v13.8h //r[i] + r[i + step]
    add v12.8h, v12.8h, v14.8h //r[i] + r[i + step]

    sub  v30.8h, v30.8h, v17.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v18.8h //r[i + 2*step] - r[i + step] - t1

    add  v28.8h, v28.8h, v17.8h //r[i + 2*step] - r[i] + t1
    add  v29.8h, v29.8h, v18.8h //r[i + 2*step] - r[i] + t1
    
    add   v11.8h,  v11.8h, v15.8h //r[i] + r[i + step] + r[i + 2*step]
    add   v12.8h,  v12.8h, v16.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul v15.8h, v30.8h, v2.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v16.8h, v31.8h, v2.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v13.8h, v28.8h, v2.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v14.8h, v29.8h, v2.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v30.8h, v30.8h, v2.h[7]
    sqrdmulh v31.8h, v31.8h, v2.h[7]
    sqrdmulh v28.8h, v28.8h, v2.h[5]
    sqrdmulh v29.8h, v29.8h, v2.h[5]

    mls v15.8h, v30.8h, v0.h[0]
    mls v16.8h, v31.8h, v0.h[0]
    mls v13.8h, v28.8h, v0.h[0]
    mls v14.8h, v29.8h, v0.h[0]

    #reduce
    sqdmulh v28.8h, v11.8h, v0.h[1]
    sqdmulh v29.8h, v12.8h, v0.h[1]

    srshr v28.8h, v28.8h, #11
    srshr v29.8h, v29.8h, #11

    mls v11.8h, v28.8h, v0.h[0]
    mls v12.8h, v29.8h, v0.h[0]

    #level 0
    #update 1
    sub  v17.8h,  v5.8h, v11.8h
    sub  v18.8h,  v6.8h, v12.8h
    sub  v19.8h,  v7.8h, v13.8h
    sub  v20.8h,  v8.8h, v14.8h
    sub  v21.8h,  v9.8h, v15.8h
    sub  v22.8h, v10.8h, v16.8h

    add   v5.8h,  v5.8h, v11.8h //t1
    add   v6.8h,  v6.8h, v12.8h //t1
    add   v7.8h,  v7.8h, v13.8h //t1
    add   v8.8h,  v8.8h, v14.8h //t1
    add   v9.8h,  v9.8h, v15.8h //t1
    add  v10.8h, v10.8h, v16.8h //t1

    #mul 1
    mul v23.8h, v17.8h, v3.h[0]
    mul v24.8h, v18.8h, v3.h[0]
    mul v25.8h, v19.8h, v3.h[0]
    mul v26.8h, v20.8h, v3.h[0]
    mul v27.8h, v21.8h, v3.h[0]
    mul v28.8h, v22.8h, v3.h[0]

    sqrdmulh v17.8h, v17.8h, v3.h[1]
    sqrdmulh v18.8h, v18.8h, v3.h[1]
    sqrdmulh v19.8h, v19.8h, v3.h[1]
    sqrdmulh v20.8h, v20.8h, v3.h[1]
    sqrdmulh v21.8h, v21.8h, v3.h[1]
    sqrdmulh v22.8h, v22.8h, v3.h[1]

    mls v23.8h, v17.8h, v0.h[0] //t2
    mls v24.8h, v18.8h, v0.h[0] //t2
    mls v25.8h, v19.8h, v0.h[0] //t2
    mls v26.8h, v20.8h, v0.h[0] //t2
    mls v27.8h, v21.8h, v0.h[0] //t2
    mls v28.8h, v22.8h, v0.h[0] //t2

    #update 2
    sub  v17.8h,  v5.8h, v23.8h //t1 - t2
    sub  v18.8h,  v6.8h, v24.8h //t1 - t2
    sub  v19.8h,  v7.8h, v25.8h //t1 - t2
    sub  v20.8h,  v8.8h, v26.8h //t1 - t2
    sub  v21.8h,  v9.8h, v27.8h //t1 - t2
    sub  v22.8h, v10.8h, v28.8h //t1 - t2

    #mul 2
    mul  v5.8h, v17.8h, v3.h[2]
    mul  v6.8h, v18.8h, v3.h[2]
    mul  v7.8h, v19.8h, v3.h[2]
    mul  v8.8h, v20.8h, v3.h[2]
    mul  v9.8h, v21.8h, v3.h[2]
    mul v10.8h, v22.8h, v3.h[2]

    sqrdmulh v17.8h, v17.8h, v3.h[3]
    sqrdmulh v18.8h, v18.8h, v3.h[3]
    sqrdmulh v19.8h, v19.8h, v3.h[3]
    sqrdmulh v20.8h, v20.8h, v3.h[3]
    sqrdmulh v21.8h, v21.8h, v3.h[3]
    sqrdmulh v22.8h, v22.8h, v3.h[3]

    mls  v5.8h, v17.8h, v0.h[0]
    mls  v6.8h, v18.8h, v0.h[0]
    mls  v7.8h, v19.8h, v0.h[0]
    mls  v8.8h, v20.8h, v0.h[0]
    mls  v9.8h, v21.8h, v0.h[0]
    mls v10.8h, v22.8h, v0.h[0]

    mul v11.8h, v23.8h, v3.h[4]
    mul v12.8h, v24.8h, v3.h[4]
    mul v13.8h, v25.8h, v3.h[4]
    mul v14.8h, v26.8h, v3.h[4]
    mul v15.8h, v27.8h, v3.h[4]
    mul v16.8h, v28.8h, v3.h[4]

    sqrdmulh v23.8h, v23.8h, v3.h[5]
    sqrdmulh v24.8h, v24.8h, v3.h[5]
    sqrdmulh v25.8h, v25.8h, v3.h[5]
    sqrdmulh v26.8h, v26.8h, v3.h[5]
    sqrdmulh v27.8h, v27.8h, v3.h[5]
    sqrdmulh v28.8h, v28.8h, v3.h[5]

    mls v11.8h, v23.8h, v0.h[0]
    mls v12.8h, v24.8h, v0.h[0]
    mls v13.8h, v25.8h, v0.h[0]
    mls v14.8h, v26.8h, v0.h[0]
    mls v15.8h, v27.8h, v0.h[0]
    mls v16.8h, v28.8h, v0.h[0]

    #reduce
    sqdmulh v20.8h,  v5.8h, v0.h[1]
    sqdmulh v21.8h,  v6.8h, v0.h[1]
    sqdmulh v22.8h,  v7.8h, v0.h[1]
    sqdmulh v23.8h,  v8.8h, v0.h[1]
    sqdmulh v24.8h,  v9.8h, v0.h[1]
    sqdmulh v25.8h,  v10.8h, v0.h[1]
    sqdmulh v26.8h,  v11.8h, v0.h[1]
    sqdmulh v27.8h,  v12.8h, v0.h[1]
    sqdmulh v28.8h,  v13.8h, v0.h[1]
    sqdmulh v29.8h,  v14.8h, v0.h[1]
    sqdmulh v30.8h,  v15.8h, v0.h[1]
    sqdmulh v31.8h,  v16.8h, v0.h[1]

    srshr   v20.8h, v20.8h, #11
    srshr   v21.8h, v21.8h, #11
    srshr   v22.8h, v22.8h, #11
    srshr   v23.8h, v23.8h, #11
    srshr   v24.8h, v24.8h, #11
    srshr   v25.8h, v25.8h, #11
    srshr   v26.8h, v26.8h, #11
    srshr   v27.8h, v27.8h, #11
    srshr   v28.8h, v28.8h, #11
    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls       v5.8h, v20.8h, v0.h[0]
    mls       v6.8h, v21.8h, v0.h[0]
    mls       v7.8h, v22.8h, v0.h[0]
    mls       v8.8h, v23.8h, v0.h[0]
    mls       v9.8h, v24.8h, v0.h[0]
    mls      v10.8h, v25.8h, v0.h[0]
    mls      v11.8h, v26.8h, v0.h[0]
    mls      v12.8h, v27.8h, v0.h[0]
    mls      v13.8h, v28.8h, v0.h[0]
    mls      v14.8h, v29.8h, v0.h[0]
    mls      v15.8h, v30.8h, v0.h[0]
    mls      v16.8h, v31.8h, v0.h[0]
    
    #store
    str q5, [dst, #0*128]
    str q6, [dst, #1*128]
    str q7, [dst, #2*128]
    str q8, [dst, #3*128]
    str q9, [dst, #4*128]
    str q10, [dst, #5*128]
    str q11, [dst, #6*128]  
    str q12, [dst, #7*128]
    str q13, [dst, #8*128]
    str q14, [dst, #9*128]
    str q15, [dst, #10*128]
    str q16, [dst, #11*128]

    add dst, dst, #16
    cmp dst, counter
    blt _looptop_210

    .unreq    dst
    .unreq    src
    .unreq    table
    .unreq    counter

ret
