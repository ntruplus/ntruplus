.global poly_cbd1
.global _poly_cbd1
poly_cbd1:
_poly_cbd1:
    dst       .req x0
    src       .req x1 
    counter   .req x8

    movi v0.8h, #1

    mov counter, #2048

_loop_cbd:
    #load
    ldr q3, [src, #0]
    ldr q4, [src, #16]
    ldr q5, [src, #144]
    ldr q6, [src, #160]
    add src, src, #32

    and v11.16b, v3.16b, v0.16b
    and v12.16b, v4.16b, v0.16b
    and v13.16b, v5.16b, v0.16b
    and v14.16b, v6.16b, v0.16b

    ushr v15.8h, v3.8h, #1     
    ushr v16.8h, v4.8h, #1

    sub  v23.8h, v11.8h, v13.8h
    sub  v24.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #1 
    ushr v18.8h, v6.8h, #1

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #2     
    ushr  v8.8h, v4.8h, #2

    sub v25.8h, v19.8h, v21.8h
    sub v26.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #2 
    ushr v10.8h, v6.8h, #2

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #3  
    ushr v16.8h, v4.8h, #3

    sub  v27.8h, v11.8h, v13.8h
    sub  v28.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #3 
    ushr v18.8h, v6.8h, #3

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #4     
    ushr  v8.8h, v4.8h, #4

    sub v29.8h, v19.8h, v21.8h
    sub v30.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #4 
    ushr v10.8h, v6.8h, #4    

    #store
    st1 {v23.8h - v26.8h},  [dst], #64
    st1 {v27.8h - v30.8h},  [dst], #64

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #5
    ushr v16.8h, v4.8h, #5

    sub  v23.8h, v11.8h, v13.8h
    sub  v24.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #5 
    ushr v18.8h, v6.8h, #5

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #6  
    ushr  v8.8h, v4.8h, #6

    sub v25.8h, v19.8h, v21.8h
    sub v26.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #6 
    ushr v10.8h, v6.8h, #6

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #7
    ushr v16.8h, v4.8h, #7

    sub  v27.8h, v11.8h, v13.8h
    sub  v28.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #7 
    ushr v18.8h, v6.8h, #7

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #8
    ushr  v8.8h, v4.8h, #8

    sub v29.8h, v19.8h, v21.8h
    sub v30.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #8 
    ushr v10.8h, v6.8h, #8

    #store
    st1 {v23.8h - v26.8h},  [dst], #64
    st1 {v27.8h - v30.8h},  [dst], #64

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #9
    ushr v16.8h, v4.8h, #9

    sub  v23.8h, v11.8h, v13.8h
    sub  v24.8h, v12.8h, v14.8h
    
    ushr v17.8h, v5.8h, #9 
    ushr v18.8h, v6.8h, #9

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #10
    ushr  v8.8h, v4.8h, #10

    sub v25.8h, v19.8h, v21.8h
    sub v26.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #10
    ushr v10.8h, v6.8h, #10

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #11
    ushr v16.8h, v4.8h, #11

    sub  v27.8h, v11.8h, v13.8h
    sub  v28.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #11
    ushr v18.8h, v6.8h, #11

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #12     
    ushr  v8.8h, v4.8h, #12

    sub v29.8h, v19.8h, v21.8h
    sub v30.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #12 
    ushr v10.8h, v6.8h, #12

    #store
    st1 {v23.8h - v26.8h},  [dst], #64
    st1 {v27.8h - v30.8h},  [dst], #64

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #13
    ushr v16.8h, v4.8h, #13

    sub  v23.8h, v11.8h, v13.8h
    sub  v24.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #13 
    ushr v18.8h, v6.8h, #13

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #14
    ushr  v8.8h, v4.8h, #14

    sub v25.8h, v19.8h, v21.8h
    sub v26.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #14
    ushr v10.8h, v6.8h, #14

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #15
    ushr v16.8h, v4.8h, #15

    sub  v27.8h, v11.8h, v13.8h
    sub  v28.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #15
    ushr v18.8h, v6.8h, #15

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    sub v29.8h, v19.8h, v21.8h
    sub v30.8h, v20.8h, v22.8h

    #store
    st1 {v23.8h - v26.8h},  [dst], #64
    st1 {v27.8h - v30.8h},  [dst], #64

    subs counter, counter, #512
    b.ne _loop_cbd

    #load
    ldr q5, [src, #0]
    ldr q6, [src, #144]

    ushr  v8.8h, v5.8h, #1 
    ushr  v9.8h, v5.8h, #2
    ushr v10.8h, v5.8h, #3

    ushr v12.8h, v6.8h, #1 
    ushr v13.8h, v6.8h, #2
    ushr v14.8h, v6.8h, #3

    and  v7.16b,  v5.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b,  v6.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub v7.8h, v7.8h, v11.8h
    sub v8.8h, v8.8h, v12.8h
    sub v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7,  [dst, #0*16]
    str q8,  [dst, #1*16]
    str q9,  [dst, #2*16]
    str q10, [dst, #3*16]

    ushr  v7.8h, v5.8h, #4
    ushr  v8.8h, v5.8h, #5
    ushr  v9.8h, v5.8h, #6
    ushr v10.8h, v5.8h, #7

    ushr v11.8h, v6.8h, #4
    ushr v12.8h, v6.8h, #5 
    ushr v13.8h, v6.8h, #6
    ushr v14.8h, v6.8h, #7

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub v7.8h, v7.8h, v11.8h
    sub v8.8h, v8.8h, v12.8h
    sub v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7,  [dst, #4*16]
    str q8,  [dst, #5*16]
    str q9,  [dst, #6*16]
    str q10, [dst, #7*16]

    ushr  v7.8h, v5.8h, #8
    ushr  v8.8h, v5.8h, #9
    ushr  v9.8h, v5.8h, #10
    ushr v10.8h, v5.8h, #11

    ushr v11.8h, v6.8h, #8
    ushr v12.8h, v6.8h, #9 
    ushr v13.8h, v6.8h, #10
    ushr v14.8h, v6.8h, #11

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub v7.8h, v7.8h, v11.8h
    sub v8.8h, v8.8h, v12.8h
    sub v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7,  [dst, #8*16]
    str q8,  [dst, #9*16]
    str q9,  [dst, #10*16]
    str q10, [dst, #11*16]

    ushr  v7.8h, v5.8h, #12
    ushr  v8.8h, v5.8h, #13
    ushr  v9.8h, v5.8h, #14
    ushr v10.8h, v5.8h, #15

    ushr v11.8h, v6.8h, #12
    ushr v12.8h, v6.8h, #13
    ushr v13.8h, v6.8h, #14
    ushr v14.8h, v6.8h, #15

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub v7.8h, v7.8h, v11.8h
    sub v8.8h, v8.8h, v12.8h
    sub v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7,  [dst, #12*16]
    str q8,  [dst, #13*16]
    str q9,  [dst, #14*16]
    str q10, [dst, #15*16]

    .unreq    dst
    .unreq    src
    .unreq    counter

    ret


.global poly_sotp
.global _poly_sotp
poly_sotp:
_poly_sotp:
    dst       .req x0
    src1      .req x1
    src2      .req x2 
    counter   .req x8

    movi v0.8h, #1

    mov counter, #2048

_loop_sotp:
    #load
    ldr q1, [src1, #0]
    ldr q2, [src1, #16]

    ldr q3, [src2, #0]
    ldr q4, [src2, #16]
    ldr q5, [src2, #144]
    ldr q6, [src2, #160]

    add src1, src1, #32
    add src2, src2, #32

    eor v3.16b, v1.16b, v3.16b
    eor v4.16b, v2.16b, v4.16b

    and v11.16b, v3.16b, v0.16b
    and v12.16b, v4.16b, v0.16b
    and v13.16b, v5.16b, v0.16b
    and v14.16b, v6.16b, v0.16b

    ushr v15.8h, v3.8h, #1     
    ushr v16.8h, v4.8h, #1

    sub  v23.8h, v11.8h, v13.8h
    sub  v24.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #1 
    ushr v18.8h, v6.8h, #1

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #2     
    ushr  v8.8h, v4.8h, #2

    sub v25.8h, v19.8h, v21.8h
    sub v26.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #2 
    ushr v10.8h, v6.8h, #2

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #3  
    ushr v16.8h, v4.8h, #3

    sub  v27.8h, v11.8h, v13.8h
    sub  v28.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #3 
    ushr v18.8h, v6.8h, #3

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #4     
    ushr  v8.8h, v4.8h, #4

    sub v29.8h, v19.8h, v21.8h
    sub v30.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #4 
    ushr v10.8h, v6.8h, #4    

    #store
    st1 {v23.8h - v26.8h},  [dst], #64
    st1 {v27.8h - v30.8h},  [dst], #64

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #5
    ushr v16.8h, v4.8h, #5

    sub  v23.8h, v11.8h, v13.8h
    sub  v24.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #5 
    ushr v18.8h, v6.8h, #5

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #6  
    ushr  v8.8h, v4.8h, #6

    sub v25.8h, v19.8h, v21.8h
    sub v26.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #6 
    ushr v10.8h, v6.8h, #6

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #7
    ushr v16.8h, v4.8h, #7

    sub  v27.8h, v11.8h, v13.8h
    sub  v28.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #7 
    ushr v18.8h, v6.8h, #7

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #8
    ushr  v8.8h, v4.8h, #8

    sub v29.8h, v19.8h, v21.8h
    sub v30.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #8 
    ushr v10.8h, v6.8h, #8

    #store
    st1 {v23.8h - v26.8h},  [dst], #64
    st1 {v27.8h - v30.8h},  [dst], #64

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #9
    ushr v16.8h, v4.8h, #9

    sub  v23.8h, v11.8h, v13.8h
    sub  v24.8h, v12.8h, v14.8h
    
    ushr v17.8h, v5.8h, #9 
    ushr v18.8h, v6.8h, #9

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #10
    ushr  v8.8h, v4.8h, #10

    sub v25.8h, v19.8h, v21.8h
    sub v26.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #10
    ushr v10.8h, v6.8h, #10

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #11
    ushr v16.8h, v4.8h, #11

    sub  v27.8h, v11.8h, v13.8h
    sub  v28.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #11
    ushr v18.8h, v6.8h, #11

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #12     
    ushr  v8.8h, v4.8h, #12

    sub v29.8h, v19.8h, v21.8h
    sub v30.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #12 
    ushr v10.8h, v6.8h, #12

    #store
    st1 {v23.8h - v26.8h},  [dst], #64
    st1 {v27.8h - v30.8h},  [dst], #64

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #13
    ushr v16.8h, v4.8h, #13

    sub  v23.8h, v11.8h, v13.8h
    sub  v24.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #13 
    ushr v18.8h, v6.8h, #13

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    ushr  v7.8h, v3.8h, #14
    ushr  v8.8h, v4.8h, #14

    sub v25.8h, v19.8h, v21.8h
    sub v26.8h, v20.8h, v22.8h

    ushr  v9.8h, v5.8h, #14
    ushr v10.8h, v6.8h, #14

    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b
    and v13.16b,  v9.16b, v0.16b
    and v14.16b, v10.16b, v0.16b

    ushr v15.8h, v3.8h, #15
    ushr v16.8h, v4.8h, #15

    sub  v27.8h, v11.8h, v13.8h
    sub  v28.8h, v12.8h, v14.8h

    ushr v17.8h, v5.8h, #15
    ushr v18.8h, v6.8h, #15

    and v19.16b, v15.16b, v0.16b
    and v20.16b, v16.16b, v0.16b
    and v21.16b, v17.16b, v0.16b
    and v22.16b, v18.16b, v0.16b

    sub v29.8h, v19.8h, v21.8h
    sub v30.8h, v20.8h, v22.8h

    #store
    st1 {v23.8h - v26.8h},  [dst], #64
    st1 {v27.8h - v30.8h},  [dst], #64

    subs counter, counter, #512
    b.ne _loop_sotp

    #load
    ldr q4, [src1, #0]
    ldr q5, [src2, #0]
    ldr q6, [src2, #144]

    eor v5.16b, v4.16b, v5.16b 

    ushr  v8.8h, v5.8h, #1 
    ushr  v9.8h, v5.8h, #2
    ushr v10.8h, v5.8h, #3

    ushr v12.8h, v6.8h, #1 
    ushr v13.8h, v6.8h, #2
    ushr v14.8h, v6.8h, #3

    and  v7.16b,  v5.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b,  v6.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub v7.8h, v7.8h, v11.8h
    sub v8.8h, v8.8h, v12.8h
    sub v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7,  [dst, #0*16]
    str q8,  [dst, #1*16]
    str q9,  [dst, #2*16]
    str q10, [dst, #3*16]

    ushr  v7.8h, v5.8h, #4
    ushr  v8.8h, v5.8h, #5
    ushr  v9.8h, v5.8h, #6
    ushr v10.8h, v5.8h, #7

    ushr v11.8h, v6.8h, #4
    ushr v12.8h, v6.8h, #5 
    ushr v13.8h, v6.8h, #6
    ushr v14.8h, v6.8h, #7

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub v7.8h, v7.8h, v11.8h
    sub v8.8h, v8.8h, v12.8h
    sub v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7,  [dst, #4*16]
    str q8,  [dst, #5*16]
    str q9,  [dst, #6*16]
    str q10, [dst, #7*16]

    ushr  v7.8h, v5.8h, #8
    ushr  v8.8h, v5.8h, #9
    ushr  v9.8h, v5.8h, #10
    ushr v10.8h, v5.8h, #11

    ushr v11.8h, v6.8h, #8
    ushr v12.8h, v6.8h, #9 
    ushr v13.8h, v6.8h, #10
    ushr v14.8h, v6.8h, #11

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub v7.8h, v7.8h, v11.8h
    sub v8.8h, v8.8h, v12.8h
    sub v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7,  [dst, #8*16]
    str q8,  [dst, #9*16]
    str q9,  [dst, #10*16]
    str q10, [dst, #11*16]

    ushr  v7.8h, v5.8h, #12
    ushr  v8.8h, v5.8h, #13
    ushr  v9.8h, v5.8h, #14
    ushr v10.8h, v5.8h, #15

    ushr v11.8h, v6.8h, #12
    ushr v12.8h, v6.8h, #13
    ushr v13.8h, v6.8h, #14
    ushr v14.8h, v6.8h, #15

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub v7.8h, v7.8h, v11.8h
    sub v8.8h, v8.8h, v12.8h
    sub v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7,  [dst, #12*16]
    str q8,  [dst, #13*16]
    str q9,  [dst, #14*16]
    str q10, [dst, #15*16]

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    counter

    ret
    

.global poly_sotp_inv
.global _poly_sotp_inv
poly_sotp_inv:
_poly_sotp_inv:
    dst       .req x0
    src1      .req x1
    src2      .req x2
    counter   .req x8

    movi v0.8h, #1

    eor v1.16b, v1.16b, v1.16b

    mov counter, #2048

_loop_sotp_inv:
    eor v2.16b, v2.16b, v2.16b
    eor v3.16b, v3.16b, v3.16b

    #load
    ldr q4, [src2,  #0]
    ldr q5, [src2, #16]
    ldr q6, [src2, #144]
    ldr q7, [src2, #160]

    #load
    ld1 {v8.8h - v11.8h},  [src1], #64
    ld1 {v12.8h - v15.8h}, [src1], #64

    ushr v18.8h, v6.8h, #1
    ushr v20.8h, v6.8h, #2
    ushr v22.8h, v6.8h, #3
    ushr v19.8h, v7.8h, #1
    ushr v21.8h, v7.8h, #2
    ushr v23.8h, v7.8h, #3

    and v16.16b,  v6.16b, v0.16b
    and v18.16b, v18.16b, v0.16b
    and v20.16b, v20.16b, v0.16b
    and v22.16b, v22.16b, v0.16b
    and v17.16b,  v7.16b, v0.16b
    and v19.16b, v19.16b, v0.16b
    and v21.16b, v21.16b, v0.16b
    and v23.16b, v23.16b, v0.16b

    add  v8.8h,  v8.8h, v16.8h
    add v10.8h, v10.8h, v18.8h
    add v12.8h, v12.8h, v20.8h
    add v14.8h, v14.8h, v22.8h
    add  v9.8h,  v9.8h, v17.8h
    add v11.8h, v11.8h, v19.8h    
    add v13.8h, v13.8h, v21.8h    
    add v15.8h, v15.8h, v23.8h

    orr  v24.16b,  v8.16b, v10.16b
    orr  v25.16b, v12.16b, v14.16b
    orr  v26.16b,  v9.16b, v11.16b
    orr  v27.16b, v13.16b, v15.16b
    orr  v28.16b, v24.16b, v25.16b
    orr  v29.16b, v26.16b, v27.16b
    orr  v30.16b, v28.16b, v29.16b
    orr   v1.16b,  v1.16b, v30.16b

    shl v10.8h, v10.8h, #1
    shl v12.8h, v12.8h, #2
    shl v14.8h, v14.8h, #3
    shl v11.8h, v11.8h, #1
    shl v13.8h, v13.8h, #2
    shl v15.8h, v15.8h, #3

    eor v2.16b, v2.16b, v8.16b
    eor v2.16b, v2.16b, v10.16b
    eor v2.16b, v2.16b, v12.16b
    eor v2.16b, v2.16b, v14.16b
    eor v3.16b, v3.16b, v9.16b
    eor v3.16b, v3.16b, v11.16b
    eor v3.16b, v3.16b, v13.16b
    eor v3.16b, v3.16b, v15.16b

    #load
    ld1 {v8.8h - v11.8h},  [src1], #64
    ld1 {v12.8h - v15.8h}, [src1], #64

    ushr v16.8h, v6.8h, #4
    ushr v18.8h, v6.8h, #5
    ushr v20.8h, v6.8h, #6
    ushr v22.8h, v6.8h, #7
    ushr v17.8h, v7.8h, #4
    ushr v19.8h, v7.8h, #5
    ushr v21.8h, v7.8h, #6
    ushr v23.8h, v7.8h, #7

    and v16.16b, v16.16b, v0.16b
    and v18.16b, v18.16b, v0.16b
    and v20.16b, v20.16b, v0.16b
    and v22.16b, v22.16b, v0.16b
    and v17.16b, v17.16b, v0.16b
    and v19.16b, v19.16b, v0.16b
    and v21.16b, v21.16b, v0.16b
    and v23.16b, v23.16b, v0.16b

    add  v8.8h,  v8.8h, v16.8h
    add v10.8h, v10.8h, v18.8h
    add v12.8h, v12.8h, v20.8h
    add v14.8h, v14.8h, v22.8h
    add  v9.8h,  v9.8h, v17.8h
    add v11.8h, v11.8h, v19.8h    
    add v13.8h, v13.8h, v21.8h    
    add v15.8h, v15.8h, v23.8h

    orr  v24.16b,  v8.16b, v10.16b
    orr  v25.16b, v12.16b, v14.16b
    orr  v26.16b,  v9.16b, v11.16b
    orr  v27.16b, v13.16b, v15.16b
    orr  v28.16b, v24.16b, v25.16b
    orr  v29.16b, v26.16b, v27.16b
    orr  v30.16b, v28.16b, v29.16b
    orr   v1.16b,  v1.16b, v30.16b

    shl  v8.8h,  v8.8h, #4
    shl v10.8h, v10.8h, #5
    shl v12.8h, v12.8h, #6
    shl v14.8h, v14.8h, #7
    shl  v9.8h,  v9.8h, #4
    shl v11.8h, v11.8h, #5
    shl v13.8h, v13.8h, #6
    shl v15.8h, v15.8h, #7

    eor v2.16b, v2.16b, v8.16b
    eor v2.16b, v2.16b, v10.16b
    eor v2.16b, v2.16b, v12.16b
    eor v2.16b, v2.16b, v14.16b
    eor v3.16b, v3.16b, v9.16b
    eor v3.16b, v3.16b, v11.16b
    eor v3.16b, v3.16b, v13.16b
    eor v3.16b, v3.16b, v15.16b

    #load
    ld1 {v8.8h - v11.8h},  [src1], #64
    ld1 {v12.8h - v15.8h}, [src1], #64

    ushr v16.8h, v6.8h, #8
    ushr v18.8h, v6.8h, #9
    ushr v20.8h, v6.8h, #10
    ushr v22.8h, v6.8h, #11
    ushr v17.8h, v7.8h, #8
    ushr v19.8h, v7.8h, #9
    ushr v21.8h, v7.8h, #10
    ushr v23.8h, v7.8h, #11

    and v16.16b, v16.16b, v0.16b
    and v18.16b, v18.16b, v0.16b
    and v20.16b, v20.16b, v0.16b
    and v22.16b, v22.16b, v0.16b
    and v17.16b, v17.16b, v0.16b
    and v19.16b, v19.16b, v0.16b
    and v21.16b, v21.16b, v0.16b
    and v23.16b, v23.16b, v0.16b

    add  v8.8h,  v8.8h, v16.8h
    add v10.8h, v10.8h, v18.8h
    add v12.8h, v12.8h, v20.8h
    add v14.8h, v14.8h, v22.8h
    add  v9.8h,  v9.8h, v17.8h
    add v11.8h, v11.8h, v19.8h    
    add v13.8h, v13.8h, v21.8h    
    add v15.8h, v15.8h, v23.8h

    orr  v24.16b,  v8.16b, v10.16b
    orr  v25.16b, v12.16b, v14.16b
    orr  v26.16b,  v9.16b, v11.16b
    orr  v27.16b, v13.16b, v15.16b
    orr  v28.16b, v24.16b, v25.16b
    orr  v29.16b, v26.16b, v27.16b
    orr  v30.16b, v28.16b, v29.16b
    orr   v1.16b,  v1.16b, v30.16b

    shl  v8.8h,  v8.8h, #8
    shl v10.8h, v10.8h, #9
    shl v12.8h, v12.8h, #10
    shl v14.8h, v14.8h, #11
    shl  v9.8h,  v9.8h, #8
    shl v11.8h, v11.8h, #9
    shl v13.8h, v13.8h, #10
    shl v15.8h, v15.8h, #11

    eor v2.16b, v2.16b, v8.16b
    eor v2.16b, v2.16b, v10.16b
    eor v2.16b, v2.16b, v12.16b
    eor v2.16b, v2.16b, v14.16b
    eor v3.16b, v3.16b, v9.16b
    eor v3.16b, v3.16b, v11.16b
    eor v3.16b, v3.16b, v13.16b
    eor v3.16b, v3.16b, v15.16b

    #load
    ld1 {v8.8h - v11.8h},  [src1], #64
    ld1 {v12.8h - v15.8h}, [src1], #64

    ushr v16.8h, v6.8h, #12
    ushr v18.8h, v6.8h, #13
    ushr v20.8h, v6.8h, #14
    ushr v22.8h, v6.8h, #15
    ushr v17.8h, v7.8h, #12
    ushr v19.8h, v7.8h, #13
    ushr v21.8h, v7.8h, #14
    ushr v23.8h, v7.8h, #15

    and v16.16b, v16.16b, v0.16b
    and v18.16b, v18.16b, v0.16b
    and v20.16b, v20.16b, v0.16b
    and v22.16b, v22.16b, v0.16b
    and v17.16b, v17.16b, v0.16b
    and v19.16b, v19.16b, v0.16b
    and v21.16b, v21.16b, v0.16b
    and v23.16b, v23.16b, v0.16b

    add  v8.8h,  v8.8h, v16.8h
    add v10.8h, v10.8h, v18.8h
    add v12.8h, v12.8h, v20.8h
    add v14.8h, v14.8h, v22.8h
    add  v9.8h,  v9.8h, v17.8h
    add v11.8h, v11.8h, v19.8h    
    add v13.8h, v13.8h, v21.8h    
    add v15.8h, v15.8h, v23.8h

    orr  v24.16b,  v8.16b, v10.16b
    orr  v25.16b, v12.16b, v14.16b
    orr  v26.16b,  v9.16b, v11.16b
    orr  v27.16b, v13.16b, v15.16b
    orr  v28.16b, v24.16b, v25.16b
    orr  v29.16b, v26.16b, v27.16b
    orr  v30.16b, v28.16b, v29.16b
    orr   v1.16b,  v1.16b, v30.16b

    shl  v8.8h,  v8.8h, #12
    shl v10.8h, v10.8h, #13
    shl v12.8h, v12.8h, #14
    shl v14.8h, v14.8h, #15
    shl  v9.8h,  v9.8h, #12
    shl v11.8h, v11.8h, #13
    shl v13.8h, v13.8h, #14
    shl v15.8h, v15.8h, #15

    eor v2.16b, v2.16b, v8.16b
    eor v2.16b, v2.16b, v10.16b
    eor v2.16b, v2.16b, v12.16b
    eor v2.16b, v2.16b, v14.16b
    eor v3.16b, v3.16b, v9.16b
    eor v3.16b, v3.16b, v11.16b
    eor v3.16b, v3.16b, v13.16b
    eor v3.16b, v3.16b, v15.16b

    eor v2.16b, v2.16b, v4.16b
    eor v3.16b, v3.16b, v5.16b

    #store
    str q2, [dst, #0]
    str q3, [dst, #16]

    add dst, dst, #32
    add src2, src2, #32
    subs counter, counter, #512
    b.ne _loop_sotp_inv

    #load
    ldr q3, [src2]
    ldr q4, [src2, #144]

    #load
    ldr  q5, [src1, #0*16]
    ldr  q6, [src1, #1*16]
    ldr  q7, [src1, #2*16]
    ldr  q8, [src1, #3*16]
    ldr  q9, [src1, #4*16]
    ldr q10, [src1, #5*16]
    ldr q11, [src1, #6*16]
    ldr q12, [src1, #7*16]

    ushr v14.8h, v4.8h, #1
    ushr v15.8h, v4.8h, #2
    ushr v16.8h, v4.8h, #3
    ushr v17.8h, v4.8h, #4
    ushr v18.8h, v4.8h, #5
    ushr v19.8h, v4.8h, #6
    ushr v20.8h, v4.8h, #7

    and v13.16b,  v4.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b
    and v16.16b, v16.16b, v0.16b
    and v17.16b, v17.16b, v0.16b
    and v18.16b, v18.16b, v0.16b
    and v19.16b, v19.16b, v0.16b
    and v20.16b, v20.16b, v0.16b

    add  v5.8h,  v5.8h, v13.8h
    add  v6.8h,  v6.8h, v14.8h
    add  v7.8h,  v7.8h, v15.8h
    add  v8.8h,  v8.8h, v16.8h
    add  v9.8h,  v9.8h, v17.8h
    add v10.8h, v10.8h, v18.8h
    add v11.8h, v11.8h, v19.8h
    add v12.8h, v12.8h, v20.8h

    orr  v21.16b,  v5.16b,  v6.16b
    orr  v22.16b,  v7.16b,  v8.16b
    orr  v23.16b,  v9.16b, v10.16b
    orr  v24.16b, v11.16b, v12.16b
    orr  v25.16b, v21.16b, v22.16b
    orr  v26.16b, v23.16b, v24.16b
    orr  v27.16b, v25.16b, v26.16b
    orr   v1.16b,  v1.16b, v27.16b

    shl  v6.8h,  v6.8h, #1
    shl  v7.8h,  v7.8h, #2
    shl  v8.8h,  v8.8h, #3
    shl  v9.8h,  v9.8h, #4
    shl v10.8h, v10.8h, #5
    shl v11.8h, v11.8h, #6
    shl v12.8h, v12.8h, #7

    eor v21.16b,  v5.16b,  v6.16b
    eor v22.16b,  v7.16b,  v8.16b
    eor v23.16b,  v9.16b, v10.16b
    eor v24.16b, v11.16b, v12.16b
    orr v25.16b, v21.16b, v22.16b
    orr v26.16b, v23.16b, v24.16b
    orr  v2.16b, v25.16b, v26.16b

    #load
    ldr  q5, [src1, #8*16]
    ldr  q6, [src1, #9*16]
    ldr  q7, [src1, #10*16]
    ldr  q8, [src1, #11*16]
    ldr  q9, [src1, #12*16]
    ldr q10, [src1, #13*16]
    ldr q11, [src1, #14*16]
    ldr q12, [src1, #15*16]

    ushr v13.8h, v4.8h, #8
    ushr v14.8h, v4.8h, #9
    ushr v15.8h, v4.8h, #10
    ushr v16.8h, v4.8h, #11
    ushr v17.8h, v4.8h, #12
    ushr v18.8h, v4.8h, #13
    ushr v19.8h, v4.8h, #14
    ushr v20.8h, v4.8h, #15

    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b
    and v16.16b, v16.16b, v0.16b
    and v17.16b, v17.16b, v0.16b
    and v18.16b, v18.16b, v0.16b
    and v19.16b, v19.16b, v0.16b
    and v20.16b, v20.16b, v0.16b

    add  v5.8h,  v5.8h, v13.8h
    add  v6.8h,  v6.8h, v14.8h
    add  v7.8h,  v7.8h, v15.8h
    add  v8.8h,  v8.8h, v16.8h
    add  v9.8h,  v9.8h, v17.8h
    add v10.8h, v10.8h, v18.8h
    add v11.8h, v11.8h, v19.8h
    add v12.8h, v12.8h, v20.8h

    orr  v21.16b,  v5.16b,  v6.16b
    orr  v22.16b,  v7.16b,  v8.16b
    orr  v23.16b,  v9.16b, v10.16b
    orr  v24.16b, v11.16b, v12.16b
    orr  v25.16b, v21.16b, v22.16b
    orr  v26.16b, v23.16b, v24.16b
    orr  v27.16b, v25.16b, v26.16b
    orr   v1.16b,  v1.16b, v27.16b

    shl  v5.8h,  v5.8h, #8
    shl  v6.8h,  v6.8h, #9
    shl  v7.8h,  v7.8h, #10
    shl  v8.8h,  v8.8h, #11
    shl  v9.8h,  v9.8h, #12
    shl v10.8h, v10.8h, #13
    shl v11.8h, v11.8h, #14
    shl v12.8h, v12.8h, #15

    eor v21.16b,  v5.16b,  v6.16b
    eor v22.16b,  v7.16b,  v8.16b
    eor v23.16b,  v9.16b, v10.16b
    eor v24.16b, v11.16b, v12.16b
    orr v25.16b, v21.16b, v22.16b
    orr v26.16b, v23.16b, v24.16b
    orr v27.16b, v25.16b, v26.16b
    orr  v2.16b,  v2.16b, v27.16b

    eor v2.16b, v2.16b, v3.16b
    str q2, [dst]

    ushr v1.8h, v1.8h, #1
    umaxv h1, v1.8h
    umov  w0, v1.h[0]
    cmp w0, #0
    cset x0, ne

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    counter

    ret
