.global poly_ntt
.global _poly_ntt
poly_ntt:
_poly_ntt:
    dst       .req x0
    src       .req x1
    zetas_ptr .req x2
    counter   .req x8
    
    adr zetas_ptr, zetas
    
    ld1 {v0.8h - v3.8h}, [zetas_ptr], #64

    mov counter, #128

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

    sqrdmulh  v5.8h,  v5.8h, v1.h[7]
    sqrdmulh  v7.8h,  v7.8h, v2.h[1]
    sqrdmulh  v9.8h,  v9.8h, v2.h[3]

    mls v16.8h,  v5.8h, v0.h[0] //t1
    mls v17.8h,  v7.8h, v0.h[0] //t1
    mls v18.8h,  v9.8h, v0.h[0] //t1

    mul v19.8h, v11.8h, v2.h[4]
    mul v20.8h, v13.8h, v2.h[6]
    mul v21.8h, v15.8h, v3.h[0]

    sqrdmulh v11.8h, v11.8h, v2.h[5]
    sqrdmulh v13.8h, v13.8h, v2.h[7]
    sqrdmulh v15.8h, v15.8h, v3.h[1]

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
    subs counter, counter, #16
    b.ne _looptop_012

    sub src, src, #128
    sub dst, dst, #128

    mov counter, #1536

_looptop_3456:
    #zeta
    ld1 {v0.8h - v3.8h}, [zetas_ptr], #64

    #load
    ldr  q4, [dst, #0*16]
    ldr  q5, [dst, #1*16]
    ldr  q6, [dst, #2*16]
    ldr  q7, [dst, #3*16]
    ldr  q8, [dst, #4*16]
    ldr  q9, [dst, #5*16]
    ldr q10, [dst, #6*16]
    ldr q11, [dst, #7*16]

    #reduce
    sqdmulh v24.8h, v4.8h, v0.h[1]
    sqdmulh v25.8h, v5.8h, v0.h[1]
    sqdmulh v26.8h, v6.8h, v0.h[1]
    sqdmulh v27.8h, v7.8h, v0.h[1]

    srshr v24.8h, v24.8h, #11
    srshr v25.8h, v25.8h, #11
    srshr v26.8h, v26.8h, #11
    srshr v27.8h, v27.8h, #11

    mls v4.8h, v24.8h, v0.h[0]
    mls v5.8h, v25.8h, v0.h[0]
    mls v6.8h, v26.8h, v0.h[0]
    mls v7.8h, v27.8h, v0.h[0]

    sqdmulh v28.8h,  v8.8h, v0.h[1]
    sqdmulh v29.8h,  v9.8h, v0.h[1]
    sqdmulh v30.8h, v10.8h, v0.h[1]
    sqdmulh v31.8h, v11.8h, v0.h[1]

    srshr v28.8h, v28.8h, #11
    srshr v29.8h, v29.8h, #11
    srshr v30.8h, v30.8h, #11
    srshr v31.8h, v31.8h, #11

    mls  v8.8h, v28.8h, v0.h[0]
    mls  v9.8h, v29.8h, v0.h[0]
    mls v10.8h, v30.8h, v0.h[0]
    mls v11.8h, v31.8h, v0.h[0]

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

    srshr   v28.8h, v28.8h, #11
    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls      v8.8h, v28.8h, v0.h[0]
    mls      v9.8h, v29.8h, v0.h[0]
    mls      v10.8h, v30.8h, v0.h[0]
    mls      v11.8h, v31.8h, v0.h[0]

    sqdmulh v24.8h,  v4.8h, v0.h[1]
    sqdmulh v25.8h,  v5.8h, v0.h[1]
    sqdmulh v26.8h,  v6.8h, v0.h[1]
    sqdmulh v27.8h,  v7.8h, v0.h[1]

    srshr   v24.8h, v24.8h, #11
    srshr   v25.8h, v25.8h, #11
    srshr   v26.8h, v26.8h, #11
    srshr   v27.8h, v27.8h, #11

    mls      v4.8h, v24.8h, v0.h[0]
    mls      v5.8h, v25.8h, v0.h[0]
    mls      v6.8h, v26.8h, v0.h[0]
    mls      v7.8h, v27.8h, v0.h[0]

    #store
    st1 {v4.8h - v7.8h},  [dst], #64
    st1 {v8.8h - v11.8h}, [dst], #64

    subs counter, counter, #128
    b.ne _looptop_3456

    .unreq    dst
    .unreq    src
    .unreq    zetas_ptr
    .unreq    counter

    ret


.global poly_invntt
.global _poly_invntt
poly_invntt:
_poly_invntt:
    dst       .req x0
    src       .req x1    
    zetas_ptr .req x2
    counter   .req x8

    adr zetas_ptr, zetas_inv

    mov counter, #1536

    _looptop_6543:
    #zetas
    ld1 {v0.8h - v3.8h}, [zetas_ptr], #64

    #load
    ld1 {v4.8h - v7.8h},  [src], #64
    ld1 {v8.8h - v11.8h}, [src], #64

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
    st1 {v4.8h - v7.8h},  [dst], #64
    st1 {v8.8h - v11.8h}, [dst], #64

    subs counter, counter, #128
    b.ne _looptop_6543

    sub dst, dst, #1536

    ld1 {v0.8h - v3.8h}, [zetas_ptr], #64

    mov counter, #128

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

    #reduce
    sqdmulh v26.8h,  v5.8h, v0.h[1]
    sqdmulh v27.8h,  v7.8h, v0.h[1]
    sqdmulh v28.8h,  v9.8h, v0.h[1]

    srshr   v26.8h, v26.8h, #11
    srshr   v27.8h, v27.8h, #11
    srshr   v28.8h, v28.8h, #11

    mls       v5.8h, v26.8h, v0.h[0]
    mls       v7.8h, v27.8h, v0.h[0]
    mls       v9.8h, v28.8h, v0.h[0]

    sqdmulh v29.8h, v11.8h, v0.h[1]
    sqdmulh v30.8h, v13.8h, v0.h[1]
    sqdmulh v31.8h, v15.8h, v0.h[1]

    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls      v11.8h, v29.8h, v0.h[0]
    mls      v13.8h, v30.8h, v0.h[0]
    mls      v15.8h, v31.8h, v0.h[0]

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

    sqrdmulh v17.8h, v17.8h, v3.h[1]
    sqrdmulh v18.8h, v18.8h, v3.h[1]
    sqrdmulh v19.8h, v19.8h, v3.h[1]

    mls v23.8h, v17.8h, v0.h[0] //t2
    mls v24.8h, v18.8h, v0.h[0] //t2
    mls v25.8h, v19.8h, v0.h[0] //t2

    mul v26.8h, v20.8h, v3.h[0]
    mul v27.8h, v21.8h, v3.h[0]
    mul v28.8h, v22.8h, v3.h[0]

    sqrdmulh v20.8h, v20.8h, v3.h[1]
    sqrdmulh v21.8h, v21.8h, v3.h[1]
    sqrdmulh v22.8h, v22.8h, v3.h[1]

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

    sqrdmulh v17.8h, v17.8h, v3.h[3]
    sqrdmulh v18.8h, v18.8h, v3.h[3]
    sqrdmulh v19.8h, v19.8h, v3.h[3]

    mls  v5.8h, v17.8h, v0.h[0]
    mls  v6.8h, v18.8h, v0.h[0]
    mls  v7.8h, v19.8h, v0.h[0]

    mul  v8.8h, v20.8h, v3.h[2]
    mul  v9.8h, v21.8h, v3.h[2]
    mul v10.8h, v22.8h, v3.h[2]

    sqrdmulh v20.8h, v20.8h, v3.h[3]
    sqrdmulh v21.8h, v21.8h, v3.h[3]
    sqrdmulh v22.8h, v22.8h, v3.h[3]

    mls  v8.8h, v20.8h, v0.h[0]
    mls  v9.8h, v21.8h, v0.h[0]
    mls v10.8h, v22.8h, v0.h[0]

    mul v11.8h, v23.8h, v3.h[4]
    mul v12.8h, v24.8h, v3.h[4]
    mul v13.8h, v25.8h, v3.h[4]

    sqrdmulh v23.8h, v23.8h, v3.h[5]
    sqrdmulh v24.8h, v24.8h, v3.h[5]
    sqrdmulh v25.8h, v25.8h, v3.h[5]

    mls v11.8h, v23.8h, v0.h[0]
    mls v12.8h, v24.8h, v0.h[0]
    mls v13.8h, v25.8h, v0.h[0]

    mul v14.8h, v26.8h, v3.h[4]
    mul v15.8h, v27.8h, v3.h[4]
    mul v16.8h, v28.8h, v3.h[4]

    sqrdmulh v26.8h, v26.8h, v3.h[5]
    sqrdmulh v27.8h, v27.8h, v3.h[5]
    sqrdmulh v28.8h, v28.8h, v3.h[5]

    mls v14.8h, v26.8h, v0.h[0]
    mls v15.8h, v27.8h, v0.h[0]
    mls v16.8h, v28.8h, v0.h[0]

    #reduce
    sqdmulh v20.8h,  v5.8h, v0.h[1]
    sqdmulh v21.8h,  v6.8h, v0.h[1]
    sqdmulh v22.8h,  v7.8h, v0.h[1]

    srshr   v20.8h, v20.8h, #11
    srshr   v21.8h, v21.8h, #11
    srshr   v22.8h, v22.8h, #11

    mls       v5.8h, v20.8h, v0.h[0]
    mls       v6.8h, v21.8h, v0.h[0]
    mls       v7.8h, v22.8h, v0.h[0]

    sqdmulh v23.8h,  v8.8h, v0.h[1]
    sqdmulh v24.8h,  v9.8h, v0.h[1]
    sqdmulh v25.8h,  v10.8h, v0.h[1]

    srshr   v23.8h, v23.8h, #11
    srshr   v24.8h, v24.8h, #11
    srshr   v25.8h, v25.8h, #11

    mls       v8.8h, v23.8h, v0.h[0]
    mls       v9.8h, v24.8h, v0.h[0]
    mls      v10.8h, v25.8h, v0.h[0]

    sqdmulh v26.8h,  v11.8h, v0.h[1]
    sqdmulh v27.8h,  v12.8h, v0.h[1]
    sqdmulh v28.8h,  v13.8h, v0.h[1]

    srshr   v26.8h, v26.8h, #11
    srshr   v27.8h, v27.8h, #11
    srshr   v28.8h, v28.8h, #11

    mls      v11.8h, v26.8h, v0.h[0]
    mls      v12.8h, v27.8h, v0.h[0]
    mls      v13.8h, v28.8h, v0.h[0]

    sqdmulh v29.8h,  v14.8h, v0.h[1]
    sqdmulh v30.8h,  v15.8h, v0.h[1]
    sqdmulh v31.8h,  v16.8h, v0.h[1]

    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

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
    subs counter, counter, #16
    b.ne _looptop_210

    .unreq    dst
    .unreq    src
    .unreq    zetas_ptr
    .unreq    counter

ret


.align 4
zetas:
    .hword 0x0d81, 0x4bd4, 0xfd2d, 0xe53b, 0xfd2e, 0xe544, 0xf9dd, 0xc5d5
    .hword 0xfeff, 0xf67c, 0xfb9c, 0xd662, 0x0623, 0x3a2b, 0xfd56, 0xe6c0
    .hword 0x05e6, 0x37e9, 0xfb0f, 0xd129, 0xfbf7, 0xd9c0, 0xfc8a, 0xdf32
    .hword 0x0093, 0x0571, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0d81, 0x4bd4, 0xf94d, 0xc080, 0xfccc, 0xe1a3, 0xff28, 0xf801
    .hword 0x01e4, 0x11ec, 0xfe53, 0xf01e, 0x0360, 0x1ffe, 0x00b1, 0x068e
    .hword 0x0016, 0x06ad, 0xfeed, 0x0454, 0x0162, 0xf940, 0xfc38, 0x035a
    .hword 0x00d1, 0x3f47, 0xf5d1, 0x2906, 0x0d1b, 0xc005, 0xdc29, 0x1fc5
    .hword 0x0d81, 0x4bd4, 0x032d, 0x1e1a, 0xff87, 0xfb85, 0xfd0b, 0xe3f9
    .hword 0x036a, 0x205c, 0x000b, 0x0068, 0xfdd6, 0xeb7d, 0x0637, 0x3ae9
    .hword 0x04c5, 0xff26, 0x0126, 0xfd24, 0xfbb9, 0x037c, 0x0634, 0xfcf5
    .hword 0x2d36, 0xf7ee, 0x0ae3, 0xe4e6, 0xd775, 0x2107, 0x3acc, 0xe328
    .hword 0x0d81, 0x4bd4, 0x006d, 0x0409, 0xfea4, 0xf31d, 0x03a9, 0x22b2
    .hword 0x01d6, 0x1167, 0xfc88, 0xdf1f, 0x040f, 0x2678, 0x02d9, 0x1afe
    .hword 0x03fe, 0xfbd9, 0x041d, 0x04a4, 0x01a1, 0xfa91, 0xffe5, 0xf9a6
    .hword 0x25d7, 0xd8a4, 0x26fd, 0x2bfd, 0x0f71, 0xcc7f, 0xff00, 0xc3cc
    .hword 0x0d81, 0x4bd4, 0xfba2, 0xd69b, 0x037d, 0x2111, 0x0183, 0x0e54
    .hword 0x03c3, 0x23a8, 0xfcf9, 0xe34e, 0x003e, 0x024c, 0x0415, 0x26b1
    .hword 0x0581, 0x05dd, 0x0579, 0x00fb, 0x02a1, 0x0246, 0x00e6, 0xfe97
    .hword 0x342c, 0x3794, 0x33e0, 0x094b, 0x18eb, 0x158d, 0x0884, 0xf2a2
    .hword 0x0d81, 0x4bd4, 0x0270, 0x171b, 0xfda5, 0xe9ac, 0x06b1, 0x3f6d
    .hword 0xff8d, 0xfbbe, 0xf9f4, 0xc6af, 0xfedd, 0xf53a, 0xfa90, 0xcc76
    .hword 0xf9f2, 0x05fb, 0xfaa9, 0xff84, 0x05b2, 0x0563, 0xfc54, 0xf96f
    .hword 0xc69c, 0x38b0, 0xcd63, 0xfb69, 0x35fc, 0x330f, 0xdd32, 0xc1c2
    .hword 0x0d81, 0x4bd4, 0x02c0, 0x1a11, 0xfbaf, 0xd716, 0x0422, 0x272d
    .hword 0x03d2, 0x2436, 0xfc00, 0xda16, 0x0643, 0x3b5a, 0xfbfc, 0xd9f0
    .hword 0x0190, 0x0112, 0xf9f9, 0x0020, 0x0580, 0xfb20, 0xfec5, 0xf96b
    .hword 0x0ecf, 0x0a25, 0xc6de, 0x012f, 0x3422, 0xd1cb, 0xf456, 0xc19c
    .hword 0x0d81, 0x4bd4, 0x04ee, 0x2eba, 0xfce6, 0xe29a, 0xfac5, 0xce6c
    .hword 0xfe84, 0xf1ee, 0xfda2, 0xe990, 0x050d, 0x2fe0, 0x0295, 0x1879
    .hword 0xfd0d, 0xfaf1, 0x031b, 0x0277, 0x006c, 0xfe66, 0xfaba, 0x0684
    .hword 0xe40c, 0xd00d, 0x1d70, 0x175d, 0x0400, 0xf0d2, 0xce04, 0x3dc3
    .hword 0x0d81, 0x4bd4, 0xf9ca, 0xc521, 0xfe42, 0xef7c, 0x049d, 0x2bba
    .hword 0x0594, 0x34e0, 0xf9d4, 0xc580, 0xfdcb, 0xeb15, 0xfc20, 0xdb45
    .hword 0x051e, 0xfc14, 0x038e, 0xfb02, 0xfc68, 0x05a4, 0x0469, 0xfd03
    .hword 0x3081, 0xdad3, 0x21b2, 0xd0ae, 0xddf0, 0x3577, 0x29cd, 0xe3ad
    .hword 0x0d81, 0x4bd4, 0x064b, 0x3ba6, 0xfb53, 0xd3ae, 0x01ff, 0x12ec
    .hword 0xfdc7, 0xeaef, 0xf9af, 0xc421, 0xfa06, 0xc75a, 0x04af, 0x2c65
    .hword 0xfa5a, 0x01f0, 0x0316, 0x02ca, 0x012f, 0xff42, 0x0576, 0xfbc6
    .hword 0xca76, 0x125d, 0x1d40, 0x1a70, 0x0b38, 0xf8f7, 0x33c3, 0xd7f0
    .hword 0x0d81, 0x4bd4, 0x00de, 0x0838, 0xfdae, 0xea02, 0xfb4e, 0xd37f
    .hword 0x0385, 0x215c, 0x0665, 0x3c9d, 0x0345, 0x1efe, 0xfa57, 0xca59
    .hword 0xfd1a, 0xff80, 0xfbb8, 0x0640, 0x04ec, 0xff52, 0x05ff, 0xfafe
    .hword 0xe487, 0xfb43, 0xd76b, 0x3b3e, 0x2ea7, 0xf98f, 0x38d6, 0xd088
    .hword 0x0d81, 0x4bd4, 0x05cc, 0x36f2, 0xff77, 0xfaed, 0x00c8, 0x0768
    .hword 0x00b0, 0x0684, 0xff64, 0xfa39, 0x04e9, 0x2e8b, 0xfa1d, 0xc834
    .hword 0xfb68, 0xfdef, 0x0368, 0x0593, 0x0232, 0xfeab, 0xff91, 0xfc65
    .hword 0xd475, 0xec6a, 0x2049, 0x34d6, 0x14cf, 0xf360, 0xfbe4, 0xddd3
    .hword 0x0d81, 0x4bd4, 0x0100, 0x097b, 0xfff0, 0xff68, 0x03bd, 0x236f
    .hword 0xfd8f, 0xe8dc, 0x0004, 0x0026, 0xfcc2, 0xe145, 0xffce, 0xfe26
    .hword 0x019f, 0x0019, 0xfffe, 0x0588, 0x004e, 0x0058, 0xfc31, 0xfbb4
    .hword 0x0f5e, 0x00ed, 0xffed, 0x346e, 0x02e3, 0x0342, 0xdbe6, 0xd745

.align 4
zetas_inv:
    .hword 0x0d81, 0x4bd4, 0xffce, 0xfe26, 0xfcc2, 0xe145, 0x0004, 0x0026
    .hword 0xfd8f, 0xe8dc, 0x03bd, 0x236f, 0xfff0, 0xff68, 0x0100, 0x097b
    .hword 0xfbb4, 0xfc31, 0x0058, 0x004e, 0x0588, 0xfffe, 0x0019, 0x019f
    .hword 0xd745, 0xdbe6, 0x0342, 0x02e3, 0x346e, 0xffed, 0x00ed, 0x0f5e
    .hword 0x0d81, 0x4bd4, 0xfa1d, 0xc834, 0x04e9, 0x2e8b, 0xff64, 0xfa39
    .hword 0x00b0, 0x0684, 0x00c8, 0x0768, 0xff77, 0xfaed, 0x05cc, 0x36f2
    .hword 0xfc65, 0xff91, 0xfeab, 0x0232, 0x0593, 0x0368, 0xfdef, 0xfb68
    .hword 0xddd3, 0xfbe4, 0xf360, 0x14cf, 0x34d6, 0x2049, 0xec6a, 0xd475
    .hword 0x0d81, 0x4bd4, 0xfa57, 0xca59, 0x0345, 0x1efe, 0x0665, 0x3c9d
    .hword 0x0385, 0x215c, 0xfb4e, 0xd37f, 0xfdae, 0xea02, 0x00de, 0x0838
    .hword 0xfafe, 0x05ff, 0xff52, 0x04ec, 0x0640, 0xfbb8, 0xff80, 0xfd1a
    .hword 0xd088, 0x38d6, 0xf98f, 0x2ea7, 0x3b3e, 0xd76b, 0xfb43, 0xe487
    .hword 0x0d81, 0x4bd4, 0x04af, 0x2c65, 0xfa06, 0xc75a, 0xf9af, 0xc421
    .hword 0xfdc7, 0xeaef, 0x01ff, 0x12ec, 0xfb53, 0xd3ae, 0x064b, 0x3ba6
    .hword 0xfbc6, 0x0576, 0xff42, 0x012f, 0x02ca, 0x0316, 0x01f0, 0xfa5a
    .hword 0xd7f0, 0x33c3, 0xf8f7, 0x0b38, 0x1a70, 0x1d40, 0x125d, 0xca76
    .hword 0x0d81, 0x4bd4, 0xfc20, 0xdb45, 0xfdcb, 0xeb15, 0xf9d4, 0xc580
    .hword 0x0594, 0x34e0, 0x049d, 0x2bba, 0xfe42, 0xef7c, 0xf9ca, 0xc521
    .hword 0xfd03, 0x0469, 0x05a4, 0xfc68, 0xfb02, 0x038e, 0xfc14, 0x051e
    .hword 0xe3ad, 0x29cd, 0x3577, 0xddf0, 0xd0ae, 0x21b2, 0xdad3, 0x3081
    .hword 0x0d81, 0x4bd4, 0x0295, 0x1879, 0x050d, 0x2fe0, 0xfda2, 0xe990
    .hword 0xfe84, 0xf1ee, 0xfac5, 0xce6c, 0xfce6, 0xe29a, 0x04ee, 0x2eba
    .hword 0x0684, 0xfaba, 0xfe66, 0x006c, 0x0277, 0x031b, 0xfaf1, 0xfd0d
    .hword 0x3dc3, 0xce04, 0xf0d2, 0x0400, 0x175d, 0x1d70, 0xd00d, 0xe40c
    .hword 0x0d81, 0x4bd4, 0xfbfc, 0xd9f0, 0x0643, 0x3b5a, 0xfc00, 0xda16
    .hword 0x03d2, 0x2436, 0x0422, 0x272d, 0xfbaf, 0xd716, 0x02c0, 0x1a11
    .hword 0xf96b, 0xfec5, 0xfb20, 0x0580, 0x0020, 0xf9f9, 0x0112, 0x0190
    .hword 0xc19c, 0xf456, 0xd1cb, 0x3422, 0x012f, 0xc6de, 0x0a25, 0x0ecf
    .hword 0x0d81, 0x4bd4, 0xfa90, 0xcc76, 0xfedd, 0xf53a, 0xf9f4, 0xc6af
    .hword 0xff8d, 0xfbbe, 0x06b1, 0x3f6d, 0xfda5, 0xe9ac, 0x0270, 0x171b
    .hword 0xf96f, 0xfc54, 0x0563, 0x05b2, 0xff84, 0xfaa9, 0x05fb, 0xf9f2
    .hword 0xc1c2, 0xdd32, 0x330f, 0x35fc, 0xfb69, 0xcd63, 0x38b0, 0xc69c
    .hword 0x0d81, 0x4bd4, 0x0415, 0x26b1, 0x003e, 0x024c, 0xfcf9, 0xe34e
    .hword 0x03c3, 0x23a8, 0x0183, 0x0e54, 0x037d, 0x2111, 0xfba2, 0xd69b
    .hword 0xfe97, 0x00e6, 0x0246, 0x02a1, 0x00fb, 0x0579, 0x05dd, 0x0581
    .hword 0xf2a2, 0x0884, 0x158d, 0x18eb, 0x094b, 0x33e0, 0x3794, 0x342c
    .hword 0x0d81, 0x4bd4, 0x02d9, 0x1afe, 0x040f, 0x2678, 0xfc88, 0xdf1f
    .hword 0x01d6, 0x1167, 0x03a9, 0x22b2, 0xfea4, 0xf31d, 0x006d, 0x0409
    .hword 0xf9a6, 0xffe5, 0xfa91, 0x01a1, 0x04a4, 0x041d, 0xfbd9, 0x03fe
    .hword 0xc3cc, 0xff00, 0xcc7f, 0x0f71, 0x2bfd, 0x26fd, 0xd8a4, 0x25d7
    .hword 0x0d81, 0x4bd4, 0x0637, 0x3ae9, 0xfdd6, 0xeb7d, 0x000b, 0x0068
    .hword 0x036a, 0x205c, 0xfd0b, 0xe3f9, 0xff87, 0xfb85, 0x032d, 0x1e1a
    .hword 0xfcf5, 0x0634, 0x037c, 0xfbb9, 0xfd24, 0x0126, 0xff26, 0x04c5
    .hword 0xe328, 0x3acc, 0x2107, 0xd775, 0xe4e6, 0x0ae3, 0xf7ee, 0x2d36
    .hword 0x0d81, 0x4bd4, 0x00b1, 0x068e, 0x0360, 0x1ffe, 0xfe53, 0xf01e
    .hword 0x01e4, 0x11ec, 0xff28, 0xf801, 0xfccc, 0xe1a3, 0xf94d, 0xc080
    .hword 0x035a, 0xfc38, 0xf940, 0x0162, 0x0454, 0xfeed, 0x06ad, 0x0016
    .hword 0x1fc5, 0xdc29, 0xc005, 0x0d1b, 0x2906, 0xf5d1, 0x3f47, 0x00d1
    .hword 0x0d81, 0x4bd4, 0xfd2d, 0xe53b, 0x0093, 0x0571, 0xfc8a, 0xdf32
    .hword 0xfbf7, 0xd9c0, 0xfb0f, 0xd129, 0x05e6, 0x37e9, 0xfd56, 0xe6c0
    .hword 0xfb9c, 0xd662, 0x0623, 0x3a2b, 0xf9dd, 0xc5d5, 0xfeff, 0xf67c
    .hword 0x0662, 0x3c80, 0xfcd5, 0xe1f9, 0xf9aa, 0xc3f1, 0x0000, 0x0000
