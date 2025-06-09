.global poly_ntt
.global _poly_ntt
poly_ntt:
_poly_ntt:
    dst       .req x0
    src       .req x1
    zetas_ptr .req x2
    counter   .req x8
    
    adr zetas_ptr, zetas
    
    ld1 {v0.8h - v2.8h}, [zetas_ptr], #48
    ld1 {v3.8h - v4.8h}, [zetas_ptr], #32

    mov counter, #64

_looptop_012:
#level 0
    ldr q14, [src, #9*64]
    ldr q15, [src, #10*64]
    ldr q16, [src, #11*64]
    ldr q17, [src, #12*64]
    ldr q18, [src, #13*64]
    ldr q19, [src, #14*64]
    ldr q20, [src, #15*64]
    ldr q21, [src, #16*64]
    ldr q22, [src, #17*64]

    mul v23.8h, v14.8h, v0.h[4]
    mul v24.8h, v15.8h, v0.h[4]
    mul v25.8h, v16.8h, v0.h[4]
    mul v26.8h, v17.8h, v0.h[4]
    mul v27.8h, v18.8h, v0.h[4]
    mul v28.8h, v19.8h, v0.h[4]
    mul v29.8h, v20.8h, v0.h[4]
    mul v30.8h, v21.8h, v0.h[4]
    mul v31.8h, v22.8h, v0.h[4]

    sqrdmulh v5.8h, v14.8h, v0.h[5]
    sqrdmulh v6.8h, v15.8h, v0.h[5]
    sqrdmulh v7.8h, v16.8h, v0.h[5]
    sqrdmulh v8.8h, v17.8h, v0.h[5]
    sqrdmulh v9.8h, v18.8h, v0.h[5]
    sqrdmulh v10.8h, v19.8h, v0.h[5]
    sqrdmulh v11.8h, v20.8h, v0.h[5]
    sqrdmulh v12.8h, v21.8h, v0.h[5]
    sqrdmulh v13.8h, v22.8h, v0.h[5]

    mls v23.8h, v5.8h, v0.h[0]
    mls v24.8h, v6.8h, v0.h[0]
    mls v25.8h, v7.8h, v0.h[0]
    mls v26.8h, v8.8h, v0.h[0]
    mls v27.8h, v9.8h, v0.h[0]
    mls v28.8h, v10.8h, v0.h[0]
    mls v29.8h, v11.8h, v0.h[0]
    mls v30.8h, v12.8h, v0.h[0]
    mls v31.8h, v13.8h, v0.h[0]

    #update 1
    sub v14.8h, v14.8h, v23.8h
    sub v15.8h, v15.8h, v24.8h
    sub v16.8h, v16.8h, v25.8h
    sub v17.8h, v17.8h, v26.8h
    sub v18.8h, v18.8h, v27.8h
    sub v19.8h, v19.8h, v28.8h
    sub v20.8h, v20.8h, v29.8h
    sub v21.8h, v21.8h, v30.8h
    sub v22.8h, v22.8h, v31.8h

    #load 2
    ldr  q5, [src, #0*64]
    ldr  q6, [src, #1*64]
    ldr  q7, [src, #2*64]
    ldr  q8, [src, #3*64]
    ldr  q9, [src, #4*64]
    ldr q10, [src, #5*64]
    ldr q11, [src, #6*64]
    ldr q12, [src, #7*64]    
    ldr q13, [src, #8*64]

    #update 2
    add v14.8h, v14.8h, v5.8h
    add v15.8h, v15.8h, v6.8h
    add v16.8h, v16.8h, v7.8h
    add v17.8h, v17.8h, v8.8h
    add v18.8h, v18.8h, v9.8h
    add v19.8h, v19.8h, v10.8h
    add v20.8h, v20.8h, v11.8h
    add v21.8h, v21.8h, v12.8h
    add v22.8h, v22.8h, v13.8h

    add  v5.8h,  v5.8h, v23.8h
    add  v6.8h,  v6.8h, v24.8h
    add  v7.8h,  v7.8h, v25.8h
    add  v8.8h,  v8.8h, v26.8h
    add  v9.8h,  v9.8h, v27.8h
    add v10.8h, v10.8h, v28.8h
    add v11.8h, v11.8h, v29.8h
    add v12.8h, v12.8h, v30.8h
    add v13.8h, v13.8h, v31.8h

    #level1
    #mul 1
    mul v23.8h,  v8.8h, v0.h[6]
    mul v24.8h,  v9.8h, v0.h[6]
    mul v25.8h, v10.8h, v0.h[6]

    sqrdmulh  v8.8h,  v8.8h, v0.h[7]
    sqrdmulh  v9.8h,  v9.8h, v0.h[7]
    sqrdmulh v10.8h, v10.8h, v0.h[7]

    mls v23.8h,  v8.8h, v0.h[0] //t1
    mls v24.8h,  v9.8h, v0.h[0] //t1
    mls v25.8h, v10.8h, v0.h[0] //t1

    mul v26.8h, v11.8h, v1.h[0]
    mul v27.8h, v12.8h, v1.h[0]
    mul v28.8h, v13.8h, v1.h[0]

    sqrdmulh v11.8h, v11.8h, v1.h[1]
    sqrdmulh v12.8h, v12.8h, v1.h[1]
    sqrdmulh v13.8h, v13.8h, v1.h[1]

    mls v26.8h, v11.8h, v0.h[0] //t2
    mls v27.8h, v12.8h, v0.h[0] //t2
    mls v28.8h, v13.8h, v0.h[0] //t2

    sub  v8.8h, v23.8h, v26.8h
    sub  v9.8h, v24.8h, v27.8h
    sub v10.8h, v25.8h, v28.8h

    #mul 2
    mul v29.8h,  v8.8h, v0.h[2]
    mul v30.8h,  v9.8h, v0.h[2]
    mul v31.8h, v10.8h, v0.h[2]

    sqrdmulh  v8.8h,  v8.8h, v0.h[3]
    sqrdmulh  v9.8h,  v9.8h, v0.h[3]
    sqrdmulh v10.8h, v10.8h, v0.h[3]

    mls v29.8h,  v8.8h, v0.h[0] //t3
    mls v30.8h,  v9.8h, v0.h[0] //t3
    mls v31.8h, v10.8h, v0.h[0] //t3

    #update
    sub v11.8h, v5.8h, v23.8h //r[i] - t1
    sub v12.8h, v6.8h, v24.8h //r[i] - t1
    sub v13.8h, v7.8h, v25.8h //r[i] - t1

    sub  v8.8h, v5.8h, v26.8h //r[i] - t2
    sub  v9.8h, v6.8h, v27.8h //r[i] - t2
    sub v10.8h, v7.8h, v28.8h //r[i] - t2

    add v5.8h, v5.8h, v23.8h //r[i] + t1
    add v6.8h, v6.8h, v24.8h //r[i] + t1
    add v7.8h, v7.8h, v25.8h //r[i] + t1

    sub v11.8h, v11.8h, v29.8h //r[i] - t1 - t3
    sub v12.8h, v12.8h, v30.8h //r[i] - t1 - t3
    sub v13.8h, v13.8h, v31.8h //r[i] - t1 - t3

    add  v8.8h,  v8.8h, v29.8h //r[i] - t2 + t3
    add  v9.8h,  v9.8h, v30.8h //r[i] - t2 + t3
    add v10.8h, v10.8h, v31.8h //r[i] - t2 + t3

    add v5.8h, v5.8h, v26.8h //r[i] + t1 + t2
    add v6.8h, v6.8h, v27.8h //r[i] + t1 + t2
    add v7.8h, v7.8h, v28.8h //r[i] + t1 + t2

    #mul 1
    mul v23.8h, v17.8h, v1.h[2]
    mul v24.8h, v18.8h, v1.h[2]
    mul v25.8h, v19.8h, v1.h[2]

    sqrdmulh v17.8h, v17.8h, v1.h[3]
    sqrdmulh v18.8h, v18.8h, v1.h[3]
    sqrdmulh v19.8h, v19.8h, v1.h[3]

    mls v23.8h, v17.8h, v0.h[0] //t1
    mls v24.8h, v18.8h, v0.h[0] //t1
    mls v25.8h, v19.8h, v0.h[0] //t1

    mul v26.8h, v20.8h, v1.h[4]
    mul v27.8h, v21.8h, v1.h[4]
    mul v28.8h, v22.8h, v1.h[4]

    sqrdmulh v20.8h, v20.8h, v1.h[5]
    sqrdmulh v21.8h, v21.8h, v1.h[5]
    sqrdmulh v22.8h, v22.8h, v1.h[5]

    mls v26.8h, v20.8h, v0.h[0] //t2
    mls v27.8h, v21.8h, v0.h[0] //t2
    mls v28.8h, v22.8h, v0.h[0] //t2

    sub v17.8h, v23.8h, v26.8h
    sub v18.8h, v24.8h, v27.8h
    sub v19.8h, v25.8h, v28.8h

    #mul 2
    mul v29.8h, v17.8h, v0.h[2]
    mul v30.8h, v18.8h, v0.h[2]
    mul v31.8h, v19.8h, v0.h[2]

    sqrdmulh v17.8h, v17.8h, v0.h[3]
    sqrdmulh v18.8h, v18.8h, v0.h[3]
    sqrdmulh v19.8h, v19.8h, v0.h[3]

    mls v29.8h, v17.8h, v0.h[0] //t3
    mls v30.8h, v18.8h, v0.h[0] //t3
    mls v31.8h, v19.8h, v0.h[0] //t3

    #update
    sub v20.8h, v14.8h, v23.8h //r[i] - t1
    sub v21.8h, v15.8h, v24.8h //r[i] - t1
    sub v22.8h, v16.8h, v25.8h //r[i] - t1

    sub v17.8h, v14.8h, v26.8h //r[i] - t2
    sub v18.8h, v15.8h, v27.8h //r[i] - t2
    sub v19.8h, v16.8h, v28.8h //r[i] - t2

    add v14.8h, v14.8h, v23.8h //r[i] + t1
    add v15.8h, v15.8h, v24.8h //r[i] + t1
    add v16.8h, v16.8h, v25.8h //r[i] + t1

    sub v20.8h, v20.8h, v29.8h //r[i] - t1 - t3
    sub v21.8h, v21.8h, v30.8h //r[i] - t1 - t3
    sub v22.8h, v22.8h, v31.8h //r[i] - t1 - t3

    add v17.8h, v17.8h, v29.8h //r[i] - t2 + t3
    add v18.8h, v18.8h, v30.8h //r[i] - t2 + t3
    add v19.8h, v19.8h, v31.8h //r[i] - t2 + t3

    add v14.8h, v14.8h, v26.8h //r[i] + t1 + t2
    add v15.8h, v15.8h, v27.8h //r[i] + t1 + t2
    add v16.8h, v16.8h, v28.8h //r[i] + t1 + t2

#level2
    #mul 1
    mul v23.8h,  v6.8h, v1.h[6]
    mul v26.8h,  v9.8h, v2.h[2]
    mul v29.8h, v12.8h, v2.h[6]
    mul v24.8h,  v7.8h, v2.h[0]
    mul v27.8h, v10.8h, v2.h[4]
    mul v30.8h, v13.8h, v3.h[0]

    sqrdmulh  v6.8h,  v6.8h, v1.h[7]
    sqrdmulh  v9.8h,  v9.8h, v2.h[3]
    sqrdmulh v12.8h, v12.8h, v2.h[7]
    sqrdmulh  v7.8h,  v7.8h, v2.h[1]
    sqrdmulh v10.8h, v10.8h, v2.h[5]
    sqrdmulh v13.8h, v13.8h, v3.h[1]

    mls v23.8h,  v6.8h, v0.h[0] //t1
    mls v26.8h,  v9.8h, v0.h[0] //t1
    mls v29.8h, v12.8h, v0.h[0] //t1
    mls v24.8h,  v7.8h, v0.h[0] //t2
    mls v27.8h, v10.8h, v0.h[0] //t2
    mls v30.8h, v13.8h, v0.h[0] //t2

    sub  v6.8h, v23.8h, v24.8h
    sub  v9.8h, v26.8h, v27.8h
    sub v12.8h, v29.8h, v30.8h

    #mul 2
    mul v25.8h,  v6.8h, v0.h[2]
    mul v28.8h,  v9.8h, v0.h[2]
    mul v31.8h, v12.8h, v0.h[2]

    sqrdmulh  v6.8h,  v6.8h, v0.h[3]
    sqrdmulh  v9.8h,  v9.8h, v0.h[3]
    sqrdmulh v12.8h, v12.8h, v0.h[3]

    mls v25.8h,  v6.8h, v0.h[0] //t3
    mls v28.8h,  v9.8h, v0.h[0] //t3
    mls v31.8h, v12.8h, v0.h[0] //t3

    #update
    sub  v7.8h,  v5.8h, v23.8h //r[i] - t1
    sub v10.8h,  v8.8h, v26.8h //r[i] - t1
    sub v13.8h, v11.8h, v29.8h //r[i] - t1

    sub v6.8h,   v5.8h, v24.8h //r[i] - t2
    sub v9.8h,   v8.8h, v27.8h //r[i] - t2
    sub v12.8h, v11.8h, v30.8h //r[i] - t2

    add  v5.8h,  v5.8h, v23.8h //r[i] + t1
    add  v8.8h,  v8.8h, v26.8h //r[i] + t1
    add v11.8h, v11.8h, v29.8h //r[i] + t1

    sub  v7.8h,  v7.8h, v25.8h //r[i] - t1 - t3
    sub v10.8h, v10.8h, v28.8h //r[i] - t1 - t3
    sub v13.8h, v13.8h, v31.8h //r[i] - t1 - t3

    add  v6.8h,  v6.8h, v25.8h //r[i] - t2 + t3
    add  v9.8h,  v9.8h, v28.8h //r[i] - t2 + t3
    add v12.8h, v12.8h, v31.8h //r[i] - t2 + t3

    add  v5.8h,  v5.8h, v24.8h //r[i] + t1 + t2
    add  v8.8h,  v8.8h, v27.8h //r[i] + t1 + t2
    add v11.8h, v11.8h, v30.8h //r[i] + t1 + t2

    #mul 1
    mul v23.8h, v15.8h, v3.h[2]
    mul v26.8h, v18.8h, v3.h[6]
    mul v29.8h, v21.8h, v4.h[2]
    mul v24.8h, v16.8h, v3.h[4]
    mul v27.8h, v19.8h, v4.h[0]
    mul v30.8h, v22.8h, v4.h[4]

    sqrdmulh v15.8h, v15.8h, v3.h[3]
    sqrdmulh v18.8h, v18.8h, v3.h[7]
    sqrdmulh v21.8h, v21.8h, v4.h[3]
    sqrdmulh v16.8h, v16.8h, v3.h[5]
    sqrdmulh v19.8h, v19.8h, v4.h[1]
    sqrdmulh v22.8h, v22.8h, v4.h[5]

    mls v23.8h, v15.8h, v0.h[0] //t1
    mls v26.8h, v18.8h, v0.h[0] //t1
    mls v29.8h, v21.8h, v0.h[0] //t1
    mls v24.8h, v16.8h, v0.h[0] //t2
    mls v27.8h, v19.8h, v0.h[0] //t2
    mls v30.8h, v22.8h, v0.h[0] //t2

    sub v15.8h, v23.8h, v24.8h
    sub v18.8h, v26.8h, v27.8h
    sub v21.8h, v29.8h, v30.8h

    #mul 2
    mul v25.8h, v15.8h, v0.h[2]
    mul v28.8h, v18.8h, v0.h[2]
    mul v31.8h, v21.8h, v0.h[2]

    sqrdmulh v15.8h, v15.8h, v0.h[3]
    sqrdmulh v18.8h, v18.8h, v0.h[3]
    sqrdmulh v21.8h, v21.8h, v0.h[3]

    mls v25.8h, v15.8h, v0.h[0] //t3
    mls v28.8h, v18.8h, v0.h[0] //t3
    mls v31.8h, v21.8h, v0.h[0] //t3

    #update
    sub v16.8h, v14.8h, v23.8h //r[i] - t1
    sub v19.8h, v17.8h, v26.8h //r[i] - t1
    sub v22.8h, v20.8h, v29.8h //r[i] - t1

    sub v15.8h, v14.8h, v24.8h //r[i] - t2
    sub v18.8h, v17.8h, v27.8h //r[i] - t2
    sub v21.8h, v20.8h, v30.8h //r[i] - t2

    add v14.8h, v14.8h, v23.8h //r[i] + t1
    add v17.8h, v17.8h, v26.8h //r[i] + t1
    add v20.8h, v20.8h, v29.8h //r[i] + t1

    sub v16.8h, v16.8h, v25.8h //r[i] - t1 - t3
    sub v19.8h, v19.8h, v28.8h //r[i] - t1 - t3
    sub v22.8h, v22.8h, v31.8h //r[i] - t1 - t3

    add v15.8h, v15.8h, v25.8h //r[i] - t2 + t3
    add v18.8h, v18.8h, v28.8h //r[i] - t2 + t3
    add v21.8h, v21.8h, v31.8h //r[i] - t2 + t3

    add v14.8h, v14.8h, v24.8h //r[i] + t1 + t2
    add v17.8h, v17.8h, v27.8h //r[i] + t1 + t2
    add v20.8h, v20.8h, v30.8h //r[i] + t1 + t2

    str q5, [dst, #0*64]
    str q6, [dst, #1*64]
    str q7, [dst, #2*64]
    str q8, [dst, #3*64]
    str q9, [dst, #4*64]
    str q10, [dst, #5*64]
    str q11, [dst, #6*64]
    str q12, [dst, #7*64]
    str q13, [dst, #8*64]

    str q14, [dst, #9*64]
    str q15, [dst, #10*64]
    str q16, [dst, #11*64]
    str q17, [dst, #12*64]
    str q18, [dst, #13*64]
    str q19, [dst, #14*64]
    str q20, [dst, #15*64]
    str q21, [dst, #16*64]    
    str q22, [dst, #17*64]

    add src, src, #16
    add dst, dst, #16
    subs counter, counter, #16
    b.ne _looptop_012

    sub src, src, #64
    sub dst, dst, #64

    mov counter, #1152

_looptop_345:
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

    #level 3
    #mul
    mul v28.8h,  v6.8h, v0.h[2]
    mul v29.8h,  v7.8h, v0.h[2]
    mul v30.8h, v10.8h, v0.h[4]
    mul v31.8h, v11.8h, v0.h[4]

    sqrdmulh  v6.8h,  v6.8h, v0.h[3]
    sqrdmulh  v7.8h,  v7.8h, v0.h[3]
    sqrdmulh v10.8h, v10.8h, v0.h[5]
    sqrdmulh v11.8h, v11.8h, v0.h[5]

    mls v28.8h,  v6.8h, v0.h[0]
    mls v29.8h,  v7.8h, v0.h[0]
    mls v30.8h, v10.8h, v0.h[0]
    mls v31.8h, v11.8h, v0.h[0]

    #update
    sub  v6.8h,  v4.8h, v28.8h
    sub  v7.8h,  v5.8h, v29.8h
    sub v10.8h,  v8.8h, v30.8h
    sub v11.8h,  v9.8h, v31.8h

    add  v4.8h,  v4.8h, v28.8h
    add  v5.8h,  v5.8h, v29.8h
    add  v8.8h,  v8.8h, v30.8h
    add  v9.8h,  v9.8h, v31.8h

    #level 4
    #mul
    mul v28.8h,  v5.8h, v0.h[6]
    mul v29.8h,  v7.8h, v1.h[0]
    mul v30.8h,  v9.8h, v1.h[2]
    mul v31.8h, v11.8h, v1.h[4]

    sqrdmulh  v5.8h,  v5.8h, v0.h[7]
    sqrdmulh  v7.8h,  v7.8h, v1.h[1]
    sqrdmulh  v9.8h,  v9.8h, v1.h[3]
    sqrdmulh v11.8h, v11.8h, v1.h[5]

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

    #level 5
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
    b.ne _looptop_345

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

    mov counter, #1152

_looptop_543:
    #zetas
    ld1 {v0.8h - v3.8h}, [zetas_ptr], #64

    #load
    ld1 {v4.8h - v7.8h},  [src], #64
    ld1 {v8.8h - v11.8h}, [src], #64

    #level 5
    #update
    sub v13.8h,  v8.8h, v4.8h
    sub v14.8h,  v9.8h, v5.8h
    sub v15.8h, v10.8h, v6.8h
    sub v16.8h, v11.8h, v7.8h

    add v4.8h, v4.8h,  v8.8h
    add v5.8h, v5.8h,  v9.8h
    add v6.8h, v6.8h, v10.8h
    add v7.8h, v7.8h, v11.8h

    #mul
    mul  v8.8h, v13.8h, v2.8h
    mul  v9.8h, v14.8h, v2.8h
    mul v10.8h, v15.8h, v2.8h
    mul v11.8h, v16.8h, v2.8h

    sqrdmulh v13.8h, v13.8h, v3.8h
    sqrdmulh v14.8h, v14.8h, v3.8h
    sqrdmulh v15.8h, v15.8h, v3.8h
    sqrdmulh v16.8h, v16.8h, v3.8h

    mls  v8.8h, v13.8h, v0.h[0]
    mls  v9.8h, v14.8h, v0.h[0]
    mls v10.8h, v15.8h, v0.h[0]
    mls v11.8h, v16.8h, v0.h[0]

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
    
    #level 4
    #update
    sub v20.8h,  v5.8h,  v4.8h
    sub v21.8h,  v7.8h,  v6.8h
    sub v22.8h,  v9.8h,  v8.8h
    sub v23.8h, v11.8h, v10.8h

    add  v4.8h,  v5.8h,  v4.8h
    add  v6.8h,  v7.8h,  v6.8h
    add  v8.8h,  v9.8h,  v8.8h
    add v10.8h, v11.8h, v10.8h

    #mul
    mul  v5.8h, v20.8h, v0.h[2]
    mul  v7.8h, v21.8h, v0.h[4]
    mul  v9.8h, v22.8h, v0.h[6]
    mul v11.8h, v23.8h, v1.h[0]

    sqrdmulh v20.8h, v20.8h, v0.h[3]
    sqrdmulh v21.8h, v21.8h, v0.h[5]
    sqrdmulh v22.8h, v22.8h, v0.h[7]
    sqrdmulh v23.8h, v23.8h, v1.h[1]

    mls  v5.8h, v20.8h, v0.h[0]
    mls  v7.8h, v21.8h, v0.h[0]
    mls  v9.8h, v22.8h, v0.h[0]
    mls v11.8h, v23.8h, v0.h[0]

    #level 3
    #update
    sub v13.8h, v6.8h, v4.8h
    sub v14.8h, v7.8h, v5.8h
    sub v15.8h, v10.8h, v8.8h
    sub v16.8h, v11.8h, v9.8h

    add v4.8h, v6.8h, v4.8h
    add v5.8h, v7.8h, v5.8h
    add v8.8h, v10.8h, v8.8h
    add v9.8h, v11.8h, v9.8h

    #mul
    mul  v6.8h, v13.8h, v1.h[2]
    mul  v7.8h, v14.8h, v1.h[2]
    mul v10.8h, v15.8h, v1.h[4]
    mul v11.8h, v16.8h, v1.h[4]

    sqrdmulh v13.8h, v13.8h, v1.h[3]
    sqrdmulh v14.8h, v14.8h, v1.h[3]
    sqrdmulh v15.8h, v15.8h, v1.h[5]
    sqrdmulh v16.8h, v16.8h, v1.h[5]

    mls  v6.8h, v13.8h, v0.h[0]
    mls  v7.8h, v14.8h, v0.h[0]
    mls v10.8h, v15.8h, v0.h[0]
    mls v11.8h, v16.8h, v0.h[0]

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

    #store
    st1 {v4.8h - v7.8h},  [dst], #64
    st1 {v8.8h - v11.8h}, [dst], #64   
    
    subs counter, counter, #128
    b.ne _looptop_543

    sub dst, dst, #1152

    ld1 {v0.8h - v2.8h}, [zetas_ptr], #48
    ld1 {v3.8h - v4.8h}, [zetas_ptr], #32

    mov counter, #64

_looptop_210:
    #load
    ldr  q5, [dst, #0*64]
    ldr  q6, [dst, #1*64]
    ldr  q7, [dst, #2*64]
    ldr  q8, [dst, #3*64]
    ldr  q9, [dst, #4*64]
    ldr q10, [dst, #5*64]
    ldr q11, [dst, #6*64]
    ldr q12, [dst, #7*64]
    ldr q13, [dst, #8*64]

    ldr q14, [dst, #9*64]
    ldr q15, [dst, #10*64]
    ldr q16, [dst, #11*64]
    ldr q17, [dst, #12*64]
    ldr q18, [dst, #13*64]
    ldr q19, [dst, #14*64]
    ldr q20, [dst, #15*64]
    ldr q21, [dst, #16*64]
    ldr q22, [dst, #17*64]

    #level 2
    #update 1
    sub  v29.8h,  v6.8h,  v5.8h
    sub  v30.8h,  v9.8h,  v8.8h
    sub  v31.8h, v12.8h, v11.8h

    #mul 1
    mul v23.8h, v29.8h, v0.h[2]
    mul v24.8h, v30.8h, v0.h[2]
    mul v25.8h, v31.8h, v0.h[2]

    sqrdmulh v29.8h, v29.8h, v0.h[3]
    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v23.8h, v29.8h, v0.h[0]
    mls v24.8h, v30.8h, v0.h[0]
    mls v25.8h, v31.8h, v0.h[0]

    #update 2
    sub  v29.8h,  v7.8h,  v6.8h //r[i + 2*step] - r[i + step]
    sub  v30.8h, v10.8h,  v9.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v13.8h, v12.8h //r[i + 2*step] - r[i + step]

    sub  v26.8h,  v7.8h,  v5.8h //r[i + 2*step] - r[i]
    sub  v27.8h, v10.8h,  v8.8h //r[i + 2*step] - r[i]
    sub  v28.8h, v13.8h, v11.8h //r[i + 2*step] - r[i]

    add   v5.8h,  v5.8h,  v6.8h //r[i] + r[i + step]
    add   v8.8h,  v8.8h,  v9.8h //r[i] + r[i + step]
    add  v11.8h, v11.8h, v12.8h //r[i] + r[i + step]

    sub  v29.8h, v29.8h, v23.8h //r[i + 2*step] - r[i + step] - t1
    sub  v30.8h, v30.8h, v24.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v25.8h //r[i + 2*step] - r[i + step] - t1

    add  v26.8h, v26.8h, v23.8h //r[i + 2*step] - r[i] + t1
    add  v27.8h, v27.8h, v24.8h //r[i + 2*step] - r[i] + t1
    add  v28.8h, v28.8h, v25.8h //r[i + 2*step] - r[i] + t1

    add   v5.8h,  v5.8h,  v7.8h //r[i] + r[i + step] + r[i + 2*step]
    add   v8.8h,  v8.8h, v10.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v11.8h, v11.8h, v13.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul  v7.8h, v29.8h, v0.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v10.8h, v30.8h, v1.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v13.8h, v31.8h, v1.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);

    sqrdmulh v29.8h, v29.8h, v0.h[7]
    sqrdmulh v30.8h, v30.8h, v1.h[3]
    sqrdmulh v31.8h, v31.8h, v1.h[7]

    mls  v7.8h, v29.8h, v0.h[0]
    mls v10.8h, v30.8h, v0.h[0]
    mls v13.8h, v31.8h, v0.h[0]

    mul  v6.8h, v26.8h, v0.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul  v9.8h, v27.8h, v1.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v12.8h, v28.8h, v1.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v26.8h, v26.8h, v0.h[5]
    sqrdmulh v27.8h, v27.8h, v1.h[1]
    sqrdmulh v28.8h, v28.8h, v1.h[5]

    mls  v6.8h, v26.8h, v0.h[0]
    mls  v9.8h, v27.8h, v0.h[0]
    mls v12.8h, v28.8h, v0.h[0]

    #update 1
    sub  v29.8h, v15.8h, v14.8h
    sub  v30.8h, v18.8h, v17.8h
    sub  v31.8h, v21.8h, v20.8h

    #mul 1
    mul v23.8h, v29.8h, v0.h[2]
    mul v24.8h, v30.8h, v0.h[2]
    mul v25.8h, v31.8h, v0.h[2]

    sqrdmulh v29.8h, v29.8h, v0.h[3]
    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v23.8h, v29.8h, v0.h[0]
    mls v24.8h, v30.8h, v0.h[0]
    mls v25.8h, v31.8h, v0.h[0]

    #update 2
    sub  v29.8h, v16.8h,  v15.8h //r[i + 2*step] - r[i + step]
    sub  v30.8h, v19.8h, v18.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v22.8h, v21.8h //r[i + 2*step] - r[i + step]

    sub  v26.8h, v16.8h, v14.8h //r[i + 2*step] - r[i]
    sub  v27.8h, v19.8h, v17.8h //r[i + 2*step] - r[i]
    sub  v28.8h, v22.8h, v20.8h //r[i + 2*step] - r[i]

    add  v14.8h, v14.8h, v15.8h //r[i] + r[i + step]
    add  v17.8h, v17.8h, v18.8h //r[i] + r[i + step]
    add  v20.8h, v20.8h, v21.8h //r[i] + r[i + step]

    sub  v29.8h, v29.8h, v23.8h //r[i + 2*step] - r[i + step] - t1
    sub  v30.8h, v30.8h, v24.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v25.8h //r[i + 2*step] - r[i + step] - t1

    add  v26.8h, v26.8h, v23.8h //r[i + 2*step] - r[i] + t1
    add  v27.8h, v27.8h, v24.8h //r[i + 2*step] - r[i] + t1
    add  v28.8h, v28.8h, v25.8h //r[i + 2*step] - r[i] + t1

    add  v14.8h, v14.8h, v16.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v17.8h, v17.8h, v19.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v20.8h, v20.8h, v22.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul v16.8h, v29.8h, v2.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v19.8h, v30.8h, v2.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v22.8h, v31.8h, v3.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);

    sqrdmulh v29.8h, v29.8h, v2.h[3]
    sqrdmulh v30.8h, v30.8h, v2.h[7]
    sqrdmulh v31.8h, v31.8h, v3.h[3]

    mls v16.8h, v29.8h, v0.h[0]
    mls v19.8h, v30.8h, v0.h[0]
    mls v22.8h, v31.8h, v0.h[0]

    mul v15.8h, v26.8h, v2.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v18.8h, v27.8h, v2.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v21.8h, v28.8h, v3.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v26.8h, v26.8h, v2.h[1]
    sqrdmulh v27.8h, v27.8h, v2.h[5]
    sqrdmulh v28.8h, v28.8h, v3.h[1]

    mls v15.8h, v26.8h, v0.h[0]
    mls v18.8h, v27.8h, v0.h[0]
    mls v21.8h, v28.8h, v0.h[0]

    #level 1
    #update 1
    sub  v29.8h,  v8.8h, v5.8h
    sub  v30.8h,  v9.8h, v6.8h
    sub  v31.8h, v10.8h, v7.8h

    #mul 1
    mul v23.8h, v29.8h, v0.h[2]
    mul v24.8h, v30.8h, v0.h[2]
    mul v25.8h, v31.8h, v0.h[2]

    sqrdmulh v29.8h, v29.8h, v0.h[3]
    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v23.8h, v29.8h, v0.h[0]
    mls v24.8h, v30.8h, v0.h[0]
    mls v25.8h, v31.8h, v0.h[0]

    #update 2
    sub  v29.8h, v11.8h,  v8.8h //r[i + 2*step] - r[i + step]
    sub  v30.8h, v12.8h,  v9.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v13.8h, v10.8h //r[i + 2*step] - r[i + step]

    sub  v26.8h, v11.8h, v5.8h //r[i + 2*step] - r[i]
    sub  v27.8h, v12.8h, v6.8h //r[i + 2*step] - r[i]
    sub  v28.8h, v13.8h, v7.8h //r[i + 2*step] - r[i]

    add  v5.8h, v5.8h,  v8.8h //r[i] + r[i + step]
    add  v6.8h, v6.8h,  v9.8h //r[i] + r[i + step]
    add  v7.8h, v7.8h, v10.8h //r[i] + r[i + step]

    sub  v29.8h, v29.8h, v23.8h //r[i + 2*step] - r[i + step] - t1
    sub  v30.8h, v30.8h, v24.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v25.8h //r[i + 2*step] - r[i + step] - t1

    add  v26.8h, v26.8h, v23.8h //r[i + 2*step] - r[i] + t1
    add  v27.8h, v27.8h, v24.8h //r[i + 2*step] - r[i] + t1
    add  v28.8h, v28.8h, v25.8h //r[i + 2*step] - r[i] + t1

    add  v5.8h, v5.8h, v11.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v6.8h, v6.8h, v12.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v7.8h, v7.8h, v13.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul v11.8h, v29.8h, v3.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v12.8h, v30.8h, v3.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v13.8h, v31.8h, v3.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);

    sqrdmulh v29.8h, v29.8h, v3.h[7]
    sqrdmulh v30.8h, v30.8h, v3.h[7]
    sqrdmulh v31.8h, v31.8h, v3.h[7]

    mls v11.8h, v29.8h, v0.h[0]
    mls v12.8h, v30.8h, v0.h[0]
    mls v13.8h, v31.8h, v0.h[0]

    mul  v8.8h, v26.8h, v3.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul  v9.8h, v27.8h, v3.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v10.8h, v28.8h, v3.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v26.8h, v26.8h, v3.h[5]
    sqrdmulh v27.8h, v27.8h, v3.h[5]
    sqrdmulh v28.8h, v28.8h, v3.h[5]

    mls  v8.8h, v26.8h, v0.h[0]
    mls  v9.8h, v27.8h, v0.h[0]
    mls v10.8h, v28.8h, v0.h[0]

    #reduce
    sqdmulh v28.8h,  v5.8h, v0.h[1]
    sqdmulh v29.8h,  v6.8h, v0.h[1]
    sqdmulh v30.8h,  v7.8h, v0.h[1]

    srshr   v28.8h, v28.8h, #11
    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11

    mls      v5.8h, v28.8h, v0.h[0]
    mls      v6.8h, v29.8h, v0.h[0]
    mls      v7.8h, v30.8h, v0.h[0]

    #update 1
    sub  v29.8h, v17.8h, v14.8h
    sub  v30.8h, v18.8h, v15.8h
    sub  v31.8h, v19.8h, v16.8h

    #mul 1
    mul v23.8h, v29.8h, v0.h[2]
    mul v24.8h, v30.8h, v0.h[2]
    mul v25.8h, v31.8h, v0.h[2]

    sqrdmulh v29.8h, v29.8h, v0.h[3]
    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v23.8h, v29.8h, v0.h[0]
    mls v24.8h, v30.8h, v0.h[0]
    mls v25.8h, v31.8h, v0.h[0]

    #update 2
    sub  v29.8h, v20.8h, v17.8h //r[i + 2*step] - r[i + step]
    sub  v30.8h, v21.8h, v18.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v22.8h, v19.8h //r[i + 2*step] - r[i + step]

    sub  v26.8h, v20.8h, v14.8h //r[i + 2*step] - r[i]
    sub  v27.8h, v21.8h, v15.8h //r[i + 2*step] - r[i]
    sub  v28.8h, v22.8h, v16.8h //r[i + 2*step] - r[i]

    add  v14.8h, v14.8h, v17.8h //r[i] + r[i + step]
    add  v15.8h, v15.8h, v18.8h //r[i] + r[i + step]
    add  v16.8h, v16.8h, v19.8h //r[i] + r[i + step]

    sub  v29.8h, v29.8h, v23.8h //r[i + 2*step] - r[i + step] - t1
    sub  v30.8h, v30.8h, v24.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v25.8h //r[i + 2*step] - r[i + step] - t1

    add  v26.8h, v26.8h, v23.8h //r[i + 2*step] - r[i] + t1
    add  v27.8h, v27.8h, v24.8h //r[i + 2*step] - r[i] + t1
    add  v28.8h, v28.8h, v25.8h //r[i + 2*step] - r[i] + t1

    add  v14.8h, v14.8h, v20.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v15.8h, v15.8h, v21.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v16.8h, v16.8h, v22.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul v20.8h, v29.8h, v4.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v21.8h, v30.8h, v4.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v22.8h, v31.8h, v4.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);

    sqrdmulh v29.8h, v29.8h, v4.h[3]
    sqrdmulh v30.8h, v30.8h, v4.h[3]
    sqrdmulh v31.8h, v31.8h, v4.h[3]

    mls v20.8h, v29.8h, v0.h[0]
    mls v21.8h, v30.8h, v0.h[0]
    mls v22.8h, v31.8h, v0.h[0]

    mul v17.8h, v26.8h, v4.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v18.8h, v27.8h, v4.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v19.8h, v28.8h, v4.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v26.8h, v26.8h, v4.h[1]
    sqrdmulh v27.8h, v27.8h, v4.h[1]
    sqrdmulh v28.8h, v28.8h, v4.h[1]

    mls v17.8h, v26.8h, v0.h[0]
    mls v18.8h, v27.8h, v0.h[0]
    mls v19.8h, v28.8h, v0.h[0]

    #reduce
    sqdmulh v28.8h,  v14.8h, v0.h[1]
    sqdmulh v29.8h,  v15.8h, v0.h[1]
    sqdmulh v30.8h,  v16.8h, v0.h[1]

    srshr   v28.8h, v28.8h, #11
    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11

    mls      v14.8h, v28.8h, v0.h[0]
    mls      v15.8h, v29.8h, v0.h[0]
    mls      v16.8h, v30.8h, v0.h[0]

    #level 0
    #update 1
    sub  v23.8h, v5.8h, v14.8h
    sub  v24.8h, v6.8h, v15.8h
    sub  v25.8h, v7.8h, v16.8h
    sub  v26.8h, v8.8h, v17.8h
    sub  v27.8h, v9.8h, v18.8h
    sub  v28.8h, v10.8h, v19.8h
    sub  v29.8h, v11.8h, v20.8h
    sub  v30.8h, v12.8h, v21.8h
    sub  v31.8h, v13.8h, v22.8h

    add  v5.8h, v5.8h, v14.8h
    add  v6.8h, v6.8h, v15.8h
    add  v7.8h, v7.8h, v16.8h
    add  v8.8h, v8.8h, v17.8h
    add  v9.8h, v9.8h, v18.8h
    add  v10.8h, v10.8h, v19.8h
    add  v11.8h, v11.8h, v20.8h
    add  v12.8h, v12.8h, v21.8h
    add  v13.8h, v13.8h, v22.8h

    #mul 1
    mul v14.8h, v23.8h, v4.h[4]
    mul v15.8h, v24.8h, v4.h[4]
    mul v16.8h, v25.8h, v4.h[4]

    sqrdmulh v23.8h, v23.8h, v4.h[5]
    sqrdmulh v24.8h, v24.8h, v4.h[5]
    sqrdmulh v25.8h, v25.8h, v4.h[5]

    mls v14.8h, v23.8h, v0.h[0]
    mls v15.8h, v24.8h, v0.h[0]
    mls v16.8h, v25.8h, v0.h[0]

    mul v17.8h, v26.8h, v4.h[4]
    mul v18.8h, v27.8h, v4.h[4]
    mul v19.8h, v28.8h, v4.h[4]

    sqrdmulh v26.8h, v26.8h, v4.h[5]
    sqrdmulh v27.8h, v27.8h, v4.h[5]
    sqrdmulh v28.8h, v28.8h, v4.h[5]

    mls v17.8h, v26.8h, v0.h[0]
    mls v18.8h, v27.8h, v0.h[0]
    mls v19.8h, v28.8h, v0.h[0]

    mul v20.8h, v29.8h, v4.h[4]
    mul v21.8h, v30.8h, v4.h[4]
    mul v22.8h, v31.8h, v4.h[4]

    sqrdmulh v29.8h, v29.8h, v4.h[5]
    sqrdmulh v30.8h, v30.8h, v4.h[5]
    sqrdmulh v31.8h, v31.8h, v4.h[5]

    mls v20.8h, v29.8h, v0.h[0]
    mls v21.8h, v30.8h, v0.h[0]
    mls v22.8h, v31.8h, v0.h[0]

    #update 2
    sub  v23.8h, v5.8h, v14.8h
    sub  v24.8h, v6.8h, v15.8h
    sub  v25.8h, v7.8h, v16.8h
    sub  v26.8h, v8.8h, v17.8h
    sub  v27.8h, v9.8h, v18.8h
    sub  v28.8h, v10.8h, v19.8h
    sub  v29.8h, v11.8h, v20.8h
    sub  v30.8h, v12.8h, v21.8h
    sub  v31.8h, v13.8h, v22.8h

    #mul 2
    mul  v5.8h, v23.8h, v4.h[6]
    mul  v6.8h, v24.8h, v4.h[6]
    mul  v7.8h, v25.8h, v4.h[6]

    sqrdmulh v23.8h, v23.8h, v4.h[7]
    sqrdmulh v24.8h, v24.8h, v4.h[7]
    sqrdmulh v25.8h, v25.8h, v4.h[7]

    mls  v5.8h, v23.8h, v0.h[0]
    mls  v6.8h, v24.8h, v0.h[0]
    mls  v7.8h, v25.8h, v0.h[0]

    mul  v8.8h, v26.8h, v4.h[6]
    mul  v9.8h, v27.8h, v4.h[6]
    mul v10.8h, v28.8h, v4.h[6]

    sqrdmulh v26.8h, v26.8h, v4.h[7]
    sqrdmulh v27.8h, v27.8h, v4.h[7]
    sqrdmulh v28.8h, v28.8h, v4.h[7]

    mls  v8.8h, v26.8h, v0.h[0]
    mls  v9.8h, v27.8h, v0.h[0]
    mls v10.8h, v28.8h, v0.h[0]

    mul v11.8h, v29.8h, v4.h[6]
    mul v12.8h, v30.8h, v4.h[6]
    mul v13.8h, v31.8h, v4.h[6]

    sqrdmulh v29.8h, v29.8h, v4.h[7]
    sqrdmulh v30.8h, v30.8h, v4.h[7]
    sqrdmulh v31.8h, v31.8h, v4.h[7]

    mls v11.8h, v29.8h, v0.h[0]
    mls v12.8h, v30.8h, v0.h[0]
    mls v13.8h, v31.8h, v0.h[0]

    mul v23.8h,  v14.8h, v4.h[6]
    mul v24.8h,  v15.8h, v4.h[6]
    mul v25.8h,  v16.8h, v4.h[6]

    sqrdmulh v14.8h, v14.8h, v4.h[7]
    sqrdmulh v15.8h, v15.8h, v4.h[7]
    sqrdmulh v16.8h, v16.8h, v4.h[7]

    mls v23.8h, v14.8h, v0.h[0]
    mls v24.8h, v15.8h, v0.h[0]
    mls v25.8h, v16.8h, v0.h[0]

    shl v14.8h, v23.8h, #1
    shl v15.8h, v24.8h, #1
    shl v16.8h, v25.8h, #1

    mul v26.8h,  v17.8h, v4.h[6]
    mul v27.8h,  v18.8h, v4.h[6]
    mul v28.8h, v19.8h, v4.h[6]

    sqrdmulh v17.8h, v17.8h, v4.h[7]
    sqrdmulh v18.8h, v18.8h, v4.h[7]
    sqrdmulh v19.8h, v19.8h, v4.h[7]

    mls v26.8h, v17.8h, v0.h[0]
    mls v27.8h, v18.8h, v0.h[0]
    mls v28.8h, v19.8h, v0.h[0]

    shl v17.8h, v26.8h, #1
    shl v18.8h, v27.8h, #1
    shl v19.8h, v28.8h, #1

    mul v29.8h, v20.8h, v4.h[6]
    mul v30.8h, v21.8h, v4.h[6]
    mul v31.8h, v22.8h, v4.h[6]

    sqrdmulh v20.8h, v20.8h, v4.h[7]
    sqrdmulh v21.8h, v21.8h, v4.h[7]
    sqrdmulh v22.8h, v22.8h, v4.h[7]

    mls v29.8h, v20.8h, v0.h[0]
    mls v30.8h, v21.8h, v0.h[0]
    mls v31.8h, v22.8h, v0.h[0]
    
    shl v20.8h, v29.8h, #1
    shl v21.8h, v30.8h, #1
    shl v22.8h, v31.8h, #1

    #reduce
    sqdmulh v23.8h,  v5.8h, v0.h[1]
    sqdmulh v24.8h,  v6.8h, v0.h[1]
    sqdmulh v25.8h,  v7.8h, v0.h[1]

    srshr   v23.8h, v23.8h, #11
    srshr   v24.8h, v24.8h, #11
    srshr   v25.8h, v25.8h, #11

    mls       v5.8h, v23.8h, v0.h[0]
    mls       v6.8h, v24.8h, v0.h[0]
    mls       v7.8h, v25.8h, v0.h[0]

    sqdmulh v26.8h,  v8.8h, v0.h[1]
    sqdmulh v27.8h,  v9.8h, v0.h[1]
    sqdmulh v28.8h,  v10.8h, v0.h[1]

    srshr   v26.8h, v26.8h, #11
    srshr   v27.8h, v27.8h, #11
    srshr   v28.8h, v28.8h, #11

    mls       v8.8h, v26.8h, v0.h[0]
    mls       v9.8h, v27.8h, v0.h[0]
    mls      v10.8h, v28.8h, v0.h[0]

    sqdmulh v29.8h,  v11.8h, v0.h[1]
    sqdmulh v30.8h,  v12.8h, v0.h[1]
    sqdmulh v31.8h,  v13.8h, v0.h[1]

    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls      v11.8h, v29.8h, v0.h[0]
    mls      v12.8h, v30.8h, v0.h[0]
    mls      v13.8h, v31.8h, v0.h[0]

    #store
    str q5, [dst, #0*64]
    str q6, [dst, #1*64]
    str q7, [dst, #2*64]
    str q8, [dst, #3*64]
    str q9, [dst, #4*64]
    str q10, [dst, #5*64]
    str q11, [dst, #6*64]  
    str q12, [dst, #7*64]
    str q13, [dst, #8*64]

    #reduce
    sqdmulh v23.8h,  v14.8h, v0.h[1]
    sqdmulh v24.8h,  v15.8h, v0.h[1]
    sqdmulh v25.8h,  v16.8h, v0.h[1]

    srshr   v23.8h, v23.8h, #11
    srshr   v24.8h, v24.8h, #11
    srshr   v25.8h, v25.8h, #11

    mls      v14.8h, v23.8h, v0.h[0]
    mls      v15.8h, v24.8h, v0.h[0]
    mls      v16.8h, v25.8h, v0.h[0]

    sqdmulh v26.8h,  v17.8h, v0.h[1]
    sqdmulh v27.8h,  v18.8h, v0.h[1]
    sqdmulh v28.8h,  v19.8h, v0.h[1]

    srshr   v26.8h, v26.8h, #11
    srshr   v27.8h, v27.8h, #11
    srshr   v28.8h, v28.8h, #11

    mls      v17.8h, v26.8h, v0.h[0]
    mls      v18.8h, v27.8h, v0.h[0]
    mls      v19.8h, v28.8h, v0.h[0]

    sqdmulh v29.8h,  v20.8h, v0.h[1]
    sqdmulh v30.8h,  v21.8h, v0.h[1]
    sqdmulh v31.8h,  v22.8h, v0.h[1]

    srshr   v29.8h, v29.8h, #11
    srshr   v30.8h, v30.8h, #11
    srshr   v31.8h, v31.8h, #11

    mls      v20.8h, v29.8h, v0.h[0]
    mls      v21.8h, v30.8h, v0.h[0]
    mls      v22.8h, v31.8h, v0.h[0]

    #store
    str q14, [dst, #9*64]
    str q15, [dst, #10*64]
    str q16, [dst, #11*64]
    str q17, [dst, #12*64]
    str q18, [dst, #13*64]
    str q19, [dst, #14*64]
    str q20, [dst, #15*64]
    str q21, [dst, #16*64]
    str q22, [dst, #17*64]

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
    .hword 0x0d81, 0x4bd4, 0xfd2d, 0xe53b, 0xfd2e, 0xe544, 0xfa10, 0xc7b8
    .hword 0x0464, 0x299e, 0x0363, 0x201a, 0x05f0, 0x3848, 0x01c2, 0x10a9
    .hword 0xfa49, 0xc9d5, 0x0436, 0x27ea, 0x0214, 0x13b3, 0x06ba, 0x3fc2
    .hword 0xfcca, 0xe190, 0x038d, 0x21a8, 0x003a, 0x0226, 0xf9ec, 0xc663
    .hword 0x04d4, 0x2dc4, 0x012a, 0x0b09, 0xfbca, 0xd816, 0x0000, 0x0000
    .hword 0x0d81, 0x4bd4, 0x009d, 0x05d0, 0x02d7, 0x1aeb, 0xfe9f, 0xf2ee
    .hword 0xfc04, 0xda3c, 0xfba1, 0xd691, 0xfda9, 0xe9d2, 0x0000, 0x0000
    .hword 0x0051, 0xfa73, 0x04e3, 0x02cc, 0xf9c2, 0xfc4f, 0x011f, 0xfd01
    .hword 0x0300, 0xcb63, 0x2e52, 0x1a83, 0xc4d5, 0xdd03, 0x0aa0, 0xe39a
    .hword 0x0d81, 0x4bd4, 0x023a, 0x151b, 0xff95, 0xfc0a, 0xfc48, 0xdcc0
    .hword 0x0063, 0x03aa, 0xfd74, 0xe7dc, 0x0656, 0x3c0f, 0x0000, 0x0000
    .hword 0xfd72, 0x00ce, 0xfc8e, 0x04ed, 0x0606, 0xfd5c, 0xfa00, 0x05bb
    .hword 0xe7c9, 0x07a1, 0xdf58, 0x2eb1, 0x3918, 0xe6f8, 0xc721, 0x3651
    .hword 0x0d81, 0x4bd4, 0x04b0, 0x2c6e, 0x051b, 0x3065, 0x030f, 0x1cfe
    .hword 0x04dc, 0x2e10, 0x0250, 0x15eb, 0x0347, 0x1f11, 0x0000, 0x0000
    .hword 0x0534, 0xfd3f, 0xff56, 0x027b, 0xfae1, 0xf950, 0xfd6e, 0x033f
    .hword 0x3152, 0xe5e5, 0xf9b5, 0x1783, 0xcf75, 0xc09c, 0xe7a3, 0x1ec5
    .hword 0x0d81, 0x4bd4, 0x00a1, 0x05f6, 0x0510, 0x2ffc, 0x02d5, 0x1ad8
    .hword 0x0680, 0x3d9d, 0x0024, 0x0155, 0x0509, 0x2fba, 0x0000, 0x0000
    .hword 0x0523, 0x043f, 0x05d0, 0xfc8f, 0x0006, 0x0317, 0x04dd, 0xffb5
    .hword 0x30b1, 0x283f, 0x3718, 0xdf61, 0x0039, 0x1d4a, 0x2e19, 0xfd39
    .hword 0x0d81, 0x4bd4, 0x046f, 0x2a06, 0xfa07, 0xc763, 0xfa5d, 0xca92
    .hword 0x065c, 0x3c47, 0x00ac, 0x065e, 0x030d, 0x1ceb, 0x0000, 0x0000
    .hword 0x048a, 0xffba, 0xfc95, 0xfd47, 0xfba9, 0x0648, 0xfd7e, 0xf97b
    .hword 0x2b06, 0xfd68, 0xdf9a, 0xe631, 0xd6dd, 0x3b8a, 0xe83b, 0xc234
    .hword 0x0d81, 0x4bd4, 0x0483, 0x2ac4, 0xfcfb, 0xe361, 0x0494, 0x2b65
    .hword 0x0060, 0x038e, 0x010c, 0x09ec, 0xfe79, 0xf186, 0x0000, 0x0000
    .hword 0x05c3, 0x011e, 0x0076, 0x0240, 0x0408, 0x04cd, 0xff3e, 0x03a0
    .hword 0x369d, 0x0a97, 0x045e, 0x1554, 0x2636, 0x2d81, 0xf8d1, 0x225c
    .hword 0x0d81, 0x4bd4, 0x03d0, 0x2423, 0x022c, 0x1496, 0x01bd, 0x107a
    .hword 0x01d9, 0x1183, 0xfef8, 0xf63a, 0xff16, 0xf756, 0x0000, 0x0000
    .hword 0x0068, 0x040b, 0x0346, 0xfaec, 0x06a8, 0xffc3, 0x03c6, 0xfdd2
    .hword 0x03da, 0x2652, 0x1f07, 0xcfde, 0x3f18, 0xfdbe, 0x23c4, 0xeb57
    .hword 0x0d81, 0x4bd4, 0xfe5c, 0xf073, 0xfe2d, 0xeeb5, 0x00d3, 0x07d0
    .hword 0x02e1, 0x1b4a, 0x050c, 0x2fd7, 0xfaa7, 0xcd50, 0x0000, 0x0000
    .hword 0x0639, 0x035e, 0x0194, 0xfc7d, 0xfc3b, 0x04f2, 0xfa4c, 0xffdb
    .hword 0x3afc, 0x1feb, 0x0ef5, 0xdeb7, 0xdc45, 0x2ee0, 0xc9f1, 0xfea1
    .hword 0x0d81, 0x4bd4, 0xf9b4, 0xc450, 0xfb87, 0xd59b, 0xfbc3, 0xd7d4
    .hword 0xfd2a, 0xe51e, 0x0236, 0x14f5, 0xfee4, 0xf57c, 0x0000, 0x0000
    .hword 0x03ae, 0xfef7, 0xf9d0, 0xfa84, 0xfced, 0xfd95, 0x0389, 0x04ab
    .hword 0x22e1, 0xf630, 0xc55a, 0xcc04, 0xe2dc, 0xe915, 0x2182, 0x2c3f

.align 4
zetas_inv:
    .hword 0x0d81, 0x4bd4, 0xfee4, 0xf57c, 0x0236, 0x14f5, 0xfd2a, 0xe51e
    .hword 0xfbc3, 0xd7d4, 0xfb87, 0xd59b, 0xf9b4, 0xc450, 0x0000, 0x0000
    .hword 0x04ab, 0x0389, 0xfd95, 0xfced, 0xfa84, 0xf9d0, 0xfef7, 0x03ae
    .hword 0x2c3f, 0x2182, 0xe915, 0xe2dc, 0xcc04, 0xc55a, 0xf630, 0x22e1
    .hword 0x0d81, 0x4bd4, 0xfaa7, 0xcd50, 0x050c, 0x2fd7, 0x02e1, 0x1b4a
    .hword 0x00d3, 0x07d0, 0xfe2d, 0xeeb5, 0xfe5c, 0xf073, 0x0000, 0x0000
    .hword 0xffdb, 0xfa4c, 0x04f2, 0xfc3b, 0xfc7d, 0x0194, 0x035e, 0x0639
    .hword 0xfea1, 0xc9f1, 0x2ee0, 0xdc45, 0xdeb7, 0x0ef5, 0x1feb, 0x3afc
    .hword 0x0d81, 0x4bd4, 0xff16, 0xf756, 0xfef8, 0xf63a, 0x01d9, 0x1183
    .hword 0x01bd, 0x107a, 0x022c, 0x1496, 0x03d0, 0x2423, 0x0000, 0x0000
    .hword 0xfdd2, 0x03c6, 0xffc3, 0x06a8, 0xfaec, 0x0346, 0x040b, 0x0068
    .hword 0xeb57, 0x23c4, 0xfdbe, 0x3f18, 0xcfde, 0x1f07, 0x2652, 0x03da
    .hword 0x0d81, 0x4bd4, 0xfe79, 0xf186, 0x010c, 0x09ec, 0x0060, 0x038e
    .hword 0x0494, 0x2b65, 0xfcfb, 0xe361, 0x0483, 0x2ac4, 0x0000, 0x0000
    .hword 0x03a0, 0xff3e, 0x04cd, 0x0408, 0x0240, 0x0076, 0x011e, 0x05c3
    .hword 0x225c, 0xf8d1, 0x2d81, 0x2636, 0x1554, 0x045e, 0x0a97, 0x369d
    .hword 0x0d81, 0x4bd4, 0x030d, 0x1ceb, 0x00ac, 0x065e, 0x065c, 0x3c47
    .hword 0xfa5d, 0xca92, 0xfa07, 0xc763, 0x046f, 0x2a06, 0x0000, 0x0000
    .hword 0xf97b, 0xfd7e, 0x0648, 0xfba9, 0xfd47, 0xfc95, 0xffba, 0x048a
    .hword 0xc234, 0xe83b, 0x3b8a, 0xd6dd, 0xe631, 0xdf9a, 0xfd68, 0x2b06
    .hword 0x0d81, 0x4bd4, 0x0509, 0x2fba, 0x0024, 0x0155, 0x0680, 0x3d9d
    .hword 0x02d5, 0x1ad8, 0x0510, 0x2ffc, 0x00a1, 0x05f6, 0x0000, 0x0000
    .hword 0xffb5, 0x04dd, 0x0317, 0x0006, 0xfc8f, 0x05d0, 0x043f, 0x0523
    .hword 0xfd39, 0x2e19, 0x1d4a, 0x0039, 0xdf61, 0x3718, 0x283f, 0x30b1
    .hword 0x0d81, 0x4bd4, 0x0347, 0x1f11, 0x0250, 0x15eb, 0x04dc, 0x2e10
    .hword 0x030f, 0x1cfe, 0x051b, 0x3065, 0x04b0, 0x2c6e, 0x0000, 0x0000
    .hword 0x033f, 0xfd6e, 0xf950, 0xfae1, 0x027b, 0xff56, 0xfd3f, 0x0534
    .hword 0x1ec5, 0xe7a3, 0xc09c, 0xcf75, 0x1783, 0xf9b5, 0xe5e5, 0x3152
    .hword 0x0d81, 0x4bd4, 0x0656, 0x3c0f, 0xfd74, 0xe7dc, 0x0063, 0x03aa
    .hword 0xfc48, 0xdcc0, 0xff95, 0xfc0a, 0x023a, 0x151b, 0x0000, 0x0000
    .hword 0x05bb, 0xfa00, 0xfd5c, 0x0606, 0x04ed, 0xfc8e, 0x00ce, 0xfd72
    .hword 0x3651, 0xc721, 0xe6f8, 0x3918, 0x2eb1, 0xdf58, 0x07a1, 0xe7c9
    .hword 0x0d81, 0x4bd4, 0xfda9, 0xe9d2, 0xfba1, 0xd691, 0xfc04, 0xda3c
    .hword 0xfe9f, 0xf2ee, 0x02d7, 0x1aeb, 0x009d, 0x05d0, 0x0000, 0x0000
    .hword 0xfd01, 0x011f, 0xfc4f, 0xf9c2, 0x02cc, 0x04e3, 0xfa73, 0x0051
    .hword 0xe39a, 0x0aa0, 0xdd03, 0xc4d5, 0x1a83, 0x2e52, 0xcb63, 0x0300
    .hword 0x0d81, 0x4bd4, 0xfd2d, 0xe53b, 0x012a, 0x0b09, 0xfbca, 0xd816
    .hword 0xf9ec, 0xc663, 0x04d4, 0x2dc4, 0x038d, 0x21a8, 0x003a, 0x0226
    .hword 0x06ba, 0x3fc2, 0xfcca, 0xe190, 0x0436, 0x27ea, 0x0214, 0x13b3
    .hword 0x01c2, 0x10a9, 0xfa49, 0xc9d5, 0x0363, 0x201a, 0x05f0, 0x3848
    .hword 0xfa10, 0xc7b8, 0x0464, 0x299e, 0x0662, 0x3c80, 0x0047, 0x02a1
