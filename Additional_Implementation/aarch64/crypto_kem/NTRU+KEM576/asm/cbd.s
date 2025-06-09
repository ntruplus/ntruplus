.global poly_cbd1
.global _poly_cbd1
poly_cbd1:
_poly_cbd1:
    dst       .req x0
    src       .req x1
    counter   .req x8

    movi v0.8h, #1

    mov counter, #1024

_loop_cbd:
    #load
    ldr q3, [src, #0]
    ldr q4, [src, #16]
    ldr q5, [src, #72]
    ldr q6, [src, #88]
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
    ldr d3, [src]
    ldr d4, [src, #72]

    ushr v7.4h, v3.4h, #1 
    ushr v8.4h, v4.4h, #1 

    and   v9.8b, v3.8b, v0.8b
    and  v10.8b, v4.8b, v0.8b
    and  v11.8b, v7.8b, v0.8b
    and  v12.8b, v8.8b, v0.8b

    ushr v13.4h, v3.4h, #2
    ushr v14.4h, v4.4h, #2

    sub v21.4h,  v9.4h, v10.4h
    sub v22.4h, v11.4h, v12.4h

    ushr v15.4h, v3.4h, #3
    ushr v16.4h, v4.4h, #3

    and v17.8b, v13.8b, v0.8b
    and v18.8b, v14.8b, v0.8b
    and v19.8b, v15.8b, v0.8b
    and v20.8b, v16.8b, v0.8b

    ushr v5.4h, v3.4h, #4
    ushr v6.4h, v4.4h, #4

    sub v23.4h, v17.4h, v18.4h
    sub v24.4h, v19.4h, v20.4h

    ushr v7.4h, v3.4h, #5
    ushr v8.4h, v4.4h, #5 

    and   v9.8b, v5.8b, v0.8b
    and  v10.8b, v6.8b, v0.8b
    and  v11.8b, v7.8b, v0.8b
    and  v12.8b, v8.8b, v0.8b

    ushr v13.4h, v3.4h, #6
    ushr v14.4h, v4.4h, #6

    sub v25.4h,  v9.4h, v10.4h
    sub v26.4h, v11.4h, v12.4h

    ushr v15.4h, v3.4h, #7
    ushr v16.4h, v4.4h, #7

    and v17.8b, v13.8b, v0.8b
    and v18.8b, v14.8b, v0.8b
    and v19.8b, v15.8b, v0.8b
    and v20.8b, v16.8b, v0.8b

    sub v27.4h, v17.4h, v18.4h
    sub v28.4h, v19.4h, v20.4h

    #store
    stp  d21, d22, [dst], #16
    stp  d23, d24, [dst], #16
    stp  d25, d26, [dst], #16
    stp  d27, d28, [dst], #16

    ushr v5.4h, v3.4h, #8
    ushr v6.4h, v4.4h, #8
    ushr v7.4h, v3.4h, #9
    ushr v8.4h, v4.4h, #9 

    and   v9.8b, v5.8b, v0.8b
    and  v10.8b, v6.8b, v0.8b
    and  v11.8b, v7.8b, v0.8b
    and  v12.8b, v8.8b, v0.8b

    ushr v13.4h, v3.4h, #10
    ushr v14.4h, v4.4h, #10

    sub v21.4h,  v9.4h, v10.4h
    sub v22.4h, v11.4h, v12.4h

    ushr v15.4h, v3.4h, #11
    ushr v16.4h, v4.4h, #11

    and v17.8b, v13.8b, v0.8b
    and v18.8b, v14.8b, v0.8b
    and v19.8b, v15.8b, v0.8b
    and v20.8b, v16.8b, v0.8b

    ushr v5.4h, v3.4h, #12
    ushr v6.4h, v4.4h, #12

    sub v23.4h, v17.4h, v18.4h
    sub v24.4h, v19.4h, v20.4h

    ushr v7.4h, v3.4h, #13
    ushr v8.4h, v4.4h, #13

    and   v9.8b, v5.8b, v0.8b
    and  v10.8b, v6.8b, v0.8b
    and  v11.8b, v7.8b, v0.8b
    and  v12.8b, v8.8b, v0.8b

    ushr v13.4h, v3.4h, #14
    ushr v14.4h, v4.4h, #14

    sub v25.4h,  v9.4h, v10.4h
    sub v26.4h, v11.4h, v12.4h

    ushr v15.4h, v3.4h, #15
    ushr v16.4h, v4.4h, #15

    and v17.8b, v13.8b, v0.8b
    and v18.8b, v14.8b, v0.8b
    and v19.8b, v15.8b, v0.8b
    and v20.8b, v16.8b, v0.8b

    sub v27.4h, v17.4h, v18.4h
    sub v28.4h, v19.4h, v20.4h

    #store
    stp  d21, d22, [dst], #16
    stp  d23, d24, [dst], #16
    stp  d25, d26, [dst], #16
    stp  d27, d28, [dst], #16

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

    mov counter, #1024

_loop_sotp:
    #load
    ldr q1, [src1, #0]
    ldr q2, [src1, #16]

    ldr q3, [src2, #0]
    ldr q4, [src2, #16]
    ldr q5, [src2, #72]
    ldr q6, [src2, #88]

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
    ldr d2, [src1]
    ldr d3, [src2]
    ldr d4, [src2, #72]

    eor v3.8b, v2.8b, v3.8b  

    ushr v7.4h, v3.4h, #1 
    ushr v8.4h, v4.4h, #1 

    and   v9.8b, v3.8b, v0.8b
    and  v10.8b, v4.8b, v0.8b
    and  v11.8b, v7.8b, v0.8b
    and  v12.8b, v8.8b, v0.8b

    ushr v13.4h, v3.4h, #2
    ushr v14.4h, v4.4h, #2

    sub v21.4h,  v9.4h, v10.4h
    sub v22.4h, v11.4h, v12.4h

    ushr v15.4h, v3.4h, #3
    ushr v16.4h, v4.4h, #3

    and v17.8b, v13.8b, v0.8b
    and v18.8b, v14.8b, v0.8b
    and v19.8b, v15.8b, v0.8b
    and v20.8b, v16.8b, v0.8b

    ushr v5.4h, v3.4h, #4
    ushr v6.4h, v4.4h, #4

    sub v23.4h, v17.4h, v18.4h
    sub v24.4h, v19.4h, v20.4h

    ushr v7.4h, v3.4h, #5
    ushr v8.4h, v4.4h, #5 

    and   v9.8b, v5.8b, v0.8b
    and  v10.8b, v6.8b, v0.8b
    and  v11.8b, v7.8b, v0.8b
    and  v12.8b, v8.8b, v0.8b

    ushr v13.4h, v3.4h, #6
    ushr v14.4h, v4.4h, #6

    sub v25.4h,  v9.4h, v10.4h
    sub v26.4h, v11.4h, v12.4h

    ushr v15.4h, v3.4h, #7
    ushr v16.4h, v4.4h, #7

    and v17.8b, v13.8b, v0.8b
    and v18.8b, v14.8b, v0.8b
    and v19.8b, v15.8b, v0.8b
    and v20.8b, v16.8b, v0.8b

    sub v27.4h, v17.4h, v18.4h
    sub v28.4h, v19.4h, v20.4h

    #store
    stp  d21, d22, [dst], #16
    stp  d23, d24, [dst], #16
    stp  d25, d26, [dst], #16
    stp  d27, d28, [dst], #16

    ushr v5.4h, v3.4h, #8
    ushr v6.4h, v4.4h, #8
    ushr v7.4h, v3.4h, #9
    ushr v8.4h, v4.4h, #9 

    and   v9.8b, v5.8b, v0.8b
    and  v10.8b, v6.8b, v0.8b
    and  v11.8b, v7.8b, v0.8b
    and  v12.8b, v8.8b, v0.8b

    ushr v13.4h, v3.4h, #10
    ushr v14.4h, v4.4h, #10

    sub v21.4h,  v9.4h, v10.4h
    sub v22.4h, v11.4h, v12.4h

    ushr v15.4h, v3.4h, #11
    ushr v16.4h, v4.4h, #11

    and v17.8b, v13.8b, v0.8b
    and v18.8b, v14.8b, v0.8b
    and v19.8b, v15.8b, v0.8b
    and v20.8b, v16.8b, v0.8b

    ushr v5.4h, v3.4h, #12
    ushr v6.4h, v4.4h, #12

    sub v23.4h, v17.4h, v18.4h
    sub v24.4h, v19.4h, v20.4h

    ushr v7.4h, v3.4h, #13
    ushr v8.4h, v4.4h, #13

    and   v9.8b, v5.8b, v0.8b
    and  v10.8b, v6.8b, v0.8b
    and  v11.8b, v7.8b, v0.8b
    and  v12.8b, v8.8b, v0.8b

    ushr v13.4h, v3.4h, #14
    ushr v14.4h, v4.4h, #14

    sub v25.4h,  v9.4h, v10.4h
    sub v26.4h, v11.4h, v12.4h

    ushr v15.4h, v3.4h, #15
    ushr v16.4h, v4.4h, #15

    and v17.8b, v13.8b, v0.8b
    and v18.8b, v14.8b, v0.8b
    and v19.8b, v15.8b, v0.8b
    and v20.8b, v16.8b, v0.8b

    sub v27.4h, v17.4h, v18.4h
    sub v28.4h, v19.4h, v20.4h

    #store
    stp  d21, d22, [dst], #16
    stp  d23, d24, [dst], #16
    stp  d25, d26, [dst], #16
    stp  d27, d28, [dst], #16

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

    mov counter, #1024

_loop_sotp_inv:
    eor v2.16b, v2.16b, v2.16b
    eor v3.16b, v3.16b, v3.16b

    #load
    ldr q4, [src2,  #0]
    ldr q5, [src2, #16]
    ldr q6, [src2, #72]
    ldr q7, [src2, #88]

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
    ldr d3, [src2]
    ldr d4, [src2, #72]

    #load
    ldr  d5, [src1, #0*8]
    ldr  d6, [src1, #1*8]
    ldr  d7, [src1, #2*8]
    ldr  d8, [src1, #3*8]
    ldr  d9, [src1, #4*8]
    ldr d10, [src1, #5*8]
    ldr d11, [src1, #6*8]
    ldr d12, [src1, #7*8]

    ushr v14.4h, v4.4h, #1
    ushr v15.4h, v4.4h, #2
    ushr v16.4h, v4.4h, #3
    ushr v17.4h, v4.4h, #4
    ushr v18.4h, v4.4h, #5
    ushr v19.4h, v4.4h, #6
    ushr v20.4h, v4.4h, #7

    and v13.8b,  v4.8b, v0.8b
    and v14.8b, v14.8b, v0.8b
    and v15.8b, v15.8b, v0.8b
    and v16.8b, v16.8b, v0.8b
    and v17.8b, v17.8b, v0.8b
    and v18.8b, v18.8b, v0.8b
    and v19.8b, v19.8b, v0.8b
    and v20.8b, v20.8b, v0.8b

    add  v5.4h,  v5.4h, v13.4h
    add  v6.4h,  v6.4h, v14.4h
    add  v7.4h,  v7.4h, v15.4h
    add  v8.4h,  v8.4h, v16.4h
    add  v9.4h,  v9.4h, v17.4h
    add v10.4h, v10.4h, v18.4h
    add v11.4h, v11.4h, v19.4h
    add v12.4h, v12.4h, v20.4h

    orr  v21.8b,  v5.8b,  v6.8b
    orr  v22.8b,  v7.8b,  v8.8b
    orr  v23.8b,  v9.8b, v10.8b
    orr  v24.8b, v11.8b, v12.8b
    orr  v25.8b, v21.8b, v22.8b
    orr  v26.8b, v23.8b, v24.8b
    orr  v27.8b, v25.8b, v26.8b
    orr   v1.8b,  v1.8b, v27.8b

    shl  v6.4h,  v6.4h, #1
    shl  v7.4h,  v7.4h, #2
    shl  v8.4h,  v8.4h, #3
    shl  v9.4h,  v9.4h, #4
    shl v10.4h, v10.4h, #5
    shl v11.4h, v11.4h, #6
    shl v12.4h, v12.4h, #7

    eor v21.8b,  v5.8b,  v6.8b
    eor v22.8b,  v7.8b,  v8.8b
    eor v23.8b,  v9.8b, v10.8b
    eor v24.8b, v11.8b, v12.8b
    orr v25.8b, v21.8b, v22.8b
    orr v26.8b, v23.8b, v24.8b
    orr  v2.8b, v25.8b, v26.8b

    #load
    ldr  d5, [src1, #8*8]
    ldr  d6, [src1, #9*8]
    ldr  d7, [src1, #10*8]
    ldr  d8, [src1, #11*8]
    ldr  d9, [src1, #12*8]
    ldr d10, [src1, #13*8]
    ldr d11, [src1, #14*8]
    ldr d12, [src1, #15*8]

    ushr v13.4h, v4.4h, #8
    ushr v14.4h, v4.4h, #9
    ushr v15.4h, v4.4h, #10
    ushr v16.4h, v4.4h, #11
    ushr v17.4h, v4.4h, #12
    ushr v18.4h, v4.4h, #13
    ushr v19.4h, v4.4h, #14
    ushr v20.4h, v4.4h, #15

    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b
    and v15.8b, v15.8b, v0.8b
    and v16.8b, v16.8b, v0.8b
    and v17.8b, v17.8b, v0.8b
    and v18.8b, v18.8b, v0.8b
    and v19.8b, v19.8b, v0.8b
    and v20.8b, v20.8b, v0.8b

    add  v5.4h,  v5.4h, v13.4h
    add  v6.4h,  v6.4h, v14.4h
    add  v7.4h,  v7.4h, v15.4h
    add  v8.4h,  v8.4h, v16.4h
    add  v9.4h,  v9.4h, v17.4h
    add v10.4h, v10.4h, v18.4h
    add v11.4h, v11.4h, v19.4h
    add v12.4h, v12.4h, v20.4h

    orr  v21.8b,  v5.8b,  v6.8b
    orr  v22.8b,  v7.8b,  v8.8b
    orr  v23.8b,  v9.8b, v10.8b
    orr  v24.8b, v11.8b, v12.8b
    orr  v25.8b, v21.8b, v22.8b
    orr  v26.8b, v23.8b, v24.8b
    orr  v27.8b, v25.8b, v26.8b
    orr   v1.8b,  v1.8b, v27.8b

    shl  v5.4h,  v5.4h, #8
    shl  v6.4h,  v6.4h, #9
    shl  v7.4h,  v7.4h, #10
    shl  v8.4h,  v8.4h, #11
    shl  v9.4h,  v9.4h, #12
    shl v10.4h, v10.4h, #13
    shl v11.4h, v11.4h, #14
    shl v12.4h, v12.4h, #15

    eor v21.8b,  v5.8b,  v6.8b
    eor v22.8b,  v7.8b,  v8.8b
    eor v23.8b,  v9.8b, v10.8b
    eor v24.8b, v11.8b, v12.8b
    orr v25.8b, v21.8b, v22.8b
    orr v26.8b, v23.8b, v24.8b
    orr v27.8b, v25.8b, v26.8b
    orr  v2.8b,  v2.8b, v27.8b

    eor v2.8b, v2.8b, v3.8b
    str d2, [dst]

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
