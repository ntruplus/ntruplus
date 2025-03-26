.global poly_cbd1_asm
.global _poly_cbd1_asm
poly_cbd1_asm:
_poly_cbd1_asm:
    dst       .req x0
    src       .req x1 
    table     .req x2
    counter   .req x8

    #load
    ldr  q0, [table, #0]

    add counter, dst, #1536

_loop_cbd:
    #load
    ldr q3, [src, #0]
    ldr q4, [src, #16]
    ldr q5, [src, #108]
    ldr q6, [src, #124]
    
    ushr  v9.8h, v3.8h, #1     
    ushr v10.8h, v4.8h, #1
    ushr v13.8h, v5.8h, #1 
    ushr v14.8h, v6.8h, #1

    and  v7.16b,  v3.16b, v0.16b
    and  v8.16b,  v4.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b,  v5.16b, v0.16b
    and v12.16b,  v6.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h, v7.8h, v11.8h
    sub  v8.8h, v8.8h, v12.8h
    sub  v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #0*16]
    str q8, [dst, #1*16]
    str q9, [dst, #2*16]
    str q10, [dst, #3*16]

    ushr  v7.8h, v3.8h, #2     
    ushr  v8.8h, v4.8h, #2
    ushr  v9.8h, v3.8h, #3     
    ushr v10.8h, v4.8h, #3
    ushr v11.8h, v5.8h, #2 
    ushr v12.8h, v6.8h, #2
    ushr v13.8h, v5.8h, #3 
    ushr v14.8h, v6.8h, #3

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #4*16]
    str q8, [dst, #5*16]
    str q9, [dst, #6*16]
    str q10, [dst, #7*16]

    ushr  v7.8h, v3.8h, #4   
    ushr  v8.8h, v4.8h, #4
    ushr  v9.8h, v3.8h, #5     
    ushr v10.8h, v4.8h, #5
    ushr v11.8h, v5.8h, #4 
    ushr v12.8h, v6.8h, #4
    ushr v13.8h, v5.8h, #5 
    ushr v14.8h, v6.8h, #5

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str  q7, [dst,  #8*16]
    str  q8, [dst,  #9*16]
    str  q9, [dst, #10*16]
    str q10, [dst, #11*16]

    ushr  v7.8h, v3.8h, #6    
    ushr  v8.8h, v4.8h, #6
    ushr  v9.8h, v3.8h, #7     
    ushr v10.8h, v4.8h, #7
    ushr v11.8h, v5.8h, #6 
    ushr v12.8h, v6.8h, #6
    ushr v13.8h, v5.8h, #7 
    ushr v14.8h, v6.8h, #7

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str  q7, [dst, #12*16]
    str  q8, [dst, #13*16]
    str  q9, [dst, #14*16]
    str q10, [dst, #15*16]

    ushr  v7.8h, v3.8h, #8   
    ushr  v8.8h, v4.8h, #8
    ushr  v9.8h, v3.8h, #9     
    ushr v10.8h, v4.8h, #9
    ushr v11.8h, v5.8h, #8 
    ushr v12.8h, v6.8h, #8
    ushr v13.8h, v5.8h, #9 
    ushr v14.8h, v6.8h, #9

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #16*16]
    str q8, [dst, #17*16]
    str q9, [dst, #18*16]
    str q10, [dst, #19*16]    

    ushr  v7.8h, v3.8h, #10   
    ushr  v8.8h, v4.8h, #10
    ushr  v9.8h, v3.8h, #11    
    ushr v10.8h, v4.8h, #11
    ushr v11.8h, v5.8h, #10
    ushr v12.8h, v6.8h, #10
    ushr v13.8h, v5.8h, #11
    ushr v14.8h, v6.8h, #11

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #20*16]
    str q8, [dst, #21*16]
    str q9, [dst, #22*16]
    str q10, [dst, #23*16] 

    ushr  v7.8h, v3.8h, #12   
    ushr  v8.8h, v4.8h, #12
    ushr  v9.8h, v3.8h, #13    
    ushr v10.8h, v4.8h, #13
    ushr v11.8h, v5.8h, #12
    ushr v12.8h, v6.8h, #12
    ushr v13.8h, v5.8h, #13
    ushr v14.8h, v6.8h, #13

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #24*16]
    str q8, [dst, #25*16]
    str q9, [dst, #26*16]
    str q10, [dst, #27*16] 

    ushr  v7.8h, v3.8h, #14  
    ushr  v8.8h, v4.8h, #14
    ushr  v9.8h, v3.8h, #15    
    ushr v10.8h, v4.8h, #15
    ushr v11.8h, v5.8h, #14
    ushr v12.8h, v6.8h, #14
    ushr v13.8h, v5.8h, #15
    ushr v14.8h, v6.8h, #15

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #28*16]
    str q8, [dst, #29*16]
    str q9, [dst, #30*16]
    str q10, [dst, #31*16] 

    add dst, dst, #512
    add src, src, #32
    cmp dst, counter
    blt _loop_cbd

    #load
    ldr d5, [src, #0]
    ldr d6, [src, #108]

    ushr  v8.4h, v5.4h, #1 
    ushr  v9.4h, v5.4h, #2
    ushr v10.4h, v5.4h, #3

    ushr v12.4h, v6.4h, #1 
    ushr v13.4h, v6.4h, #2
    ushr v14.4h, v6.4h, #3

    and  v7.8b,  v5.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b,  v6.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str d7, [dst, #0*8]
    str d8, [dst, #1*8]
    str d9, [dst, #2*8]
    str d10, [dst, #3*8]

    ushr  v7.4h, v5.4h, #4
    ushr  v8.4h, v5.4h, #5
    ushr  v9.4h, v5.4h, #6
    ushr v10.4h, v5.4h, #7

    ushr v11.4h, v6.4h, #4
    ushr v12.4h, v6.4h, #5 
    ushr v13.4h, v6.4h, #6
    ushr v14.4h, v6.4h, #7

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str d7, [dst, #4*8]
    str d8, [dst, #5*8]
    str d9, [dst, #6*8]
    str d10, [dst, #7*8]

    ushr  v7.4h, v5.4h, #8
    ushr  v8.4h, v5.4h, #9
    ushr  v9.4h, v5.4h, #10
    ushr v10.4h, v5.4h, #11

    ushr v11.4h, v6.4h, #8
    ushr v12.4h, v6.4h, #9 
    ushr v13.4h, v6.4h, #10
    ushr v14.4h, v6.4h, #11

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str d7, [dst, #8*8]
    str d8, [dst, #9*8]
    str d9, [dst, #10*8]
    str d10, [dst, #11*8]

    ushr  v7.4h, v5.4h, #12
    ushr  v8.4h, v5.4h, #13
    ushr  v9.4h, v5.4h, #14
    ushr v10.4h, v5.4h, #15

    ushr v11.4h, v6.4h, #12
    ushr v12.4h, v6.4h, #13
    ushr v13.4h, v6.4h, #14
    ushr v14.4h, v6.4h, #15

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str d7, [dst, #12*8]
    str d8, [dst, #13*8]
    str d9, [dst, #14*8]
    str d10, [dst, #15*8]

    add dst, dst, #128
    add src, src, #8

    #load
    ldr s5, [src, #0]
    ldr s6, [src, #108]

    ushr  v8.4h, v5.4h, #1 
    ushr  v9.4h, v5.4h, #2
    ushr v10.4h, v5.4h, #3

    ushr v12.4h, v6.4h, #1 
    ushr v13.4h, v6.4h, #2
    ushr v14.4h, v6.4h, #3

    and  v7.8b,  v5.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b,  v6.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str s7, [dst, #0*4]
    str s8, [dst, #1*4]
    str s9, [dst, #2*4]
    str s10, [dst, #3*4]

    ushr  v7.4h, v5.4h, #4
    ushr  v8.4h, v5.4h, #5
    ushr  v9.4h, v5.4h, #6
    ushr v10.4h, v5.4h, #7

    ushr v11.4h, v6.4h, #4
    ushr v12.4h, v6.4h, #5 
    ushr v13.4h, v6.4h, #6
    ushr v14.4h, v6.4h, #7

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str s7, [dst, #4*4]
    str s8, [dst, #5*4]
    str s9, [dst, #6*4]
    str s10, [dst, #7*4]

    ushr  v7.4h, v5.4h, #8
    ushr  v8.4h, v5.4h, #9
    ushr  v9.4h, v5.4h, #10
    ushr v10.4h, v5.4h, #11

    ushr v11.4h, v6.4h, #8
    ushr v12.4h, v6.4h, #9 
    ushr v13.4h, v6.4h, #10
    ushr v14.4h, v6.4h, #11

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str s7, [dst, #8*4]
    str s8, [dst, #9*4]
    str s9, [dst, #10*4]
    str s10, [dst, #11*4]

    ushr  v7.4h, v5.4h, #12
    ushr  v8.4h, v5.4h, #13
    ushr  v9.4h, v5.4h, #14
    ushr v10.4h, v5.4h, #15

    ushr v11.4h, v6.4h, #12
    ushr v12.4h, v6.4h, #13
    ushr v13.4h, v6.4h, #14
    ushr v14.4h, v6.4h, #15

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str s7, [dst, #12*4]
    str s8, [dst, #13*4]
    str s9, [dst, #14*4]
    str s10, [dst, #15*4]

    .unreq    dst
    .unreq    src
    .unreq    table
    .unreq    counter

    ret

.global poly_sotp_asm
.global _poly_sotp_asm
poly_sotp_asm:
_poly_sotp_asm:
    dst       .req x0
    src1      .req x1
    src2      .req x2 
    table     .req x3
    counter   .req x8

    #load
    ldr  q0, [table, #0]

    add counter, dst, #1536

_loop_sotp:
    #load
    ldr q1, [src1, #0]
    ldr q2, [src1, #16]
    ldr q3, [src2, #0]
    ldr q4, [src2, #16]
    ldr q5, [src2, #108]
    ldr q6, [src2, #124]

    eor v3.16b, v1.16b, v3.16b
    eor v4.16b, v2.16b, v4.16b
    
    ushr  v9.8h, v3.8h, #1     
    ushr v10.8h, v4.8h, #1
    ushr v13.8h, v5.8h, #1 
    ushr v14.8h, v6.8h, #1

    and  v7.16b,  v3.16b, v0.16b
    and  v8.16b,  v4.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b,  v5.16b, v0.16b
    and v12.16b,  v6.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h, v7.8h, v11.8h
    sub  v8.8h, v8.8h, v12.8h
    sub  v9.8h, v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #0*16]
    str q8, [dst, #1*16]
    str q9, [dst, #2*16]
    str q10, [dst, #3*16]

    ushr  v7.8h, v3.8h, #2     
    ushr  v8.8h, v4.8h, #2
    ushr  v9.8h, v3.8h, #3     
    ushr v10.8h, v4.8h, #3
    ushr v11.8h, v5.8h, #2 
    ushr v12.8h, v6.8h, #2
    ushr v13.8h, v5.8h, #3 
    ushr v14.8h, v6.8h, #3

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #4*16]
    str q8, [dst, #5*16]
    str q9, [dst, #6*16]
    str q10, [dst, #7*16]

    ushr  v7.8h, v3.8h, #4   
    ushr  v8.8h, v4.8h, #4
    ushr  v9.8h, v3.8h, #5     
    ushr v10.8h, v4.8h, #5
    ushr v11.8h, v5.8h, #4 
    ushr v12.8h, v6.8h, #4
    ushr v13.8h, v5.8h, #5 
    ushr v14.8h, v6.8h, #5

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str  q7, [dst,  #8*16]
    str  q8, [dst,  #9*16]
    str  q9, [dst, #10*16]
    str q10, [dst, #11*16]

    ushr  v7.8h, v3.8h, #6    
    ushr  v8.8h, v4.8h, #6
    ushr  v9.8h, v3.8h, #7     
    ushr v10.8h, v4.8h, #7
    ushr v11.8h, v5.8h, #6 
    ushr v12.8h, v6.8h, #6
    ushr v13.8h, v5.8h, #7 
    ushr v14.8h, v6.8h, #7

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str  q7, [dst, #12*16]
    str  q8, [dst, #13*16]
    str  q9, [dst, #14*16]
    str q10, [dst, #15*16]

    ushr  v7.8h, v3.8h, #8   
    ushr  v8.8h, v4.8h, #8
    ushr  v9.8h, v3.8h, #9     
    ushr v10.8h, v4.8h, #9
    ushr v11.8h, v5.8h, #8 
    ushr v12.8h, v6.8h, #8
    ushr v13.8h, v5.8h, #9 
    ushr v14.8h, v6.8h, #9

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #16*16]
    str q8, [dst, #17*16]
    str q9, [dst, #18*16]
    str q10, [dst, #19*16]    

    ushr  v7.8h, v3.8h, #10   
    ushr  v8.8h, v4.8h, #10
    ushr  v9.8h, v3.8h, #11    
    ushr v10.8h, v4.8h, #11
    ushr v11.8h, v5.8h, #10
    ushr v12.8h, v6.8h, #10
    ushr v13.8h, v5.8h, #11
    ushr v14.8h, v6.8h, #11

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #20*16]
    str q8, [dst, #21*16]
    str q9, [dst, #22*16]
    str q10, [dst, #23*16] 

    ushr  v7.8h, v3.8h, #12   
    ushr  v8.8h, v4.8h, #12
    ushr  v9.8h, v3.8h, #13    
    ushr v10.8h, v4.8h, #13
    ushr v11.8h, v5.8h, #12
    ushr v12.8h, v6.8h, #12
    ushr v13.8h, v5.8h, #13
    ushr v14.8h, v6.8h, #13

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #24*16]
    str q8, [dst, #25*16]
    str q9, [dst, #26*16]
    str q10, [dst, #27*16] 

    ushr  v7.8h, v3.8h, #14  
    ushr  v8.8h, v4.8h, #14
    ushr  v9.8h, v3.8h, #15    
    ushr v10.8h, v4.8h, #15
    ushr v11.8h, v5.8h, #14
    ushr v12.8h, v6.8h, #14
    ushr v13.8h, v5.8h, #15
    ushr v14.8h, v6.8h, #15

    and  v7.16b,  v7.16b, v0.16b
    and  v8.16b,  v8.16b, v0.16b
    and  v9.16b,  v9.16b, v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    sub  v7.8h,  v7.8h, v11.8h
    sub  v8.8h,  v8.8h, v12.8h
    sub  v9.8h,  v9.8h, v13.8h
    sub v10.8h, v10.8h, v14.8h

    #store
    str q7, [dst, #28*16]
    str q8, [dst, #29*16]
    str q9, [dst, #30*16]
    str q10, [dst, #31*16] 

    add dst, dst, #512
    add src1, src1, #32
    add src2, src2, #32
    cmp dst, counter
    blt _loop_sotp

    #load
    ldr d4, [src1, #0]
    ldr d5, [src2, #0]
    ldr d6, [src2, #108]

    eor v5.8b, v4.8b, v5.8b  

    ushr v8.4h, v5.4h, #1 
    ushr v9.4h, v5.4h, #2
    ushr v10.4h, v5.4h, #3

    ushr v12.4h, v6.4h, #1 
    ushr v13.4h, v6.4h, #2
    ushr v14.4h, v6.4h, #3

    and  v7.8b,  v5.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b,  v6.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str d7, [dst, #0*8]
    str d8, [dst, #1*8]
    str d9, [dst, #2*8]
    str d10, [dst, #3*8]

    ushr  v7.4h, v5.4h, #4
    ushr  v8.4h, v5.4h, #5
    ushr  v9.4h, v5.4h, #6
    ushr v10.4h, v5.4h, #7

    ushr v11.4h, v6.4h, #4
    ushr v12.4h, v6.4h, #5 
    ushr v13.4h, v6.4h, #6
    ushr v14.4h, v6.4h, #7

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str d7, [dst, #4*8]
    str d8, [dst, #5*8]
    str d9, [dst, #6*8]
    str d10, [dst, #7*8]

    ushr  v7.4h, v5.4h, #8
    ushr  v8.4h, v5.4h, #9
    ushr  v9.4h, v5.4h, #10
    ushr v10.4h, v5.4h, #11

    ushr v11.4h, v6.4h, #8
    ushr v12.4h, v6.4h, #9 
    ushr v13.4h, v6.4h, #10
    ushr v14.4h, v6.4h, #11

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str d7, [dst, #8*8]
    str d8, [dst, #9*8]
    str d9, [dst, #10*8]
    str d10, [dst, #11*8]

    ushr  v7.4h, v5.4h, #12
    ushr  v8.4h, v5.4h, #13
    ushr  v9.4h, v5.4h, #14
    ushr v10.4h, v5.4h, #15

    ushr v11.4h, v6.4h, #12
    ushr v12.4h, v6.4h, #13
    ushr v13.4h, v6.4h, #14
    ushr v14.4h, v6.4h, #15

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str d7, [dst, #12*8]
    str d8, [dst, #13*8]
    str d9, [dst, #14*8]
    str d10, [dst, #15*8]

    add dst, dst, #128
    add src1, src1, #8
    add src2, src2, #8

    #load
    ldr s4, [src1, #0]
    ldr s5, [src2, #0]
    ldr s6, [src2, #108]

    eor v5.8b, v4.8b, v5.8b  

    ushr v8.4h, v5.4h, #1 
    ushr v9.4h, v5.4h, #2
    ushr v10.4h, v5.4h, #3

    ushr v12.4h, v6.4h, #1 
    ushr v13.4h, v6.4h, #2
    ushr v14.4h, v6.4h, #3

    and  v7.8b,  v5.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b,  v6.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str s7, [dst, #0*4]
    str s8, [dst, #1*4]
    str s9, [dst, #2*4]
    str s10, [dst, #3*4]

    ushr  v7.4h, v5.4h, #4
    ushr  v8.4h, v5.4h, #5
    ushr  v9.4h, v5.4h, #6
    ushr v10.4h, v5.4h, #7

    ushr v11.4h, v6.4h, #4
    ushr v12.4h, v6.4h, #5 
    ushr v13.4h, v6.4h, #6
    ushr v14.4h, v6.4h, #7

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str s7, [dst, #4*4]
    str s8, [dst, #5*4]
    str s9, [dst, #6*4]
    str s10, [dst, #7*4]

    ushr  v7.4h, v5.4h, #8
    ushr  v8.4h, v5.4h, #9
    ushr  v9.4h, v5.4h, #10
    ushr v10.4h, v5.4h, #11

    ushr v11.4h, v6.4h, #8
    ushr v12.4h, v6.4h, #9 
    ushr v13.4h, v6.4h, #10
    ushr v14.4h, v6.4h, #11

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str s7, [dst, #8*4]
    str s8, [dst, #9*4]
    str s9, [dst, #10*4]
    str s10, [dst, #11*4]

    ushr  v7.4h, v5.4h, #12
    ushr  v8.4h, v5.4h, #13
    ushr  v9.4h, v5.4h, #14
    ushr v10.4h, v5.4h, #15

    ushr v11.4h, v6.4h, #12
    ushr v12.4h, v6.4h, #13
    ushr v13.4h, v6.4h, #14
    ushr v14.4h, v6.4h, #15

    and  v7.8b,  v7.8b, v0.8b
    and  v8.8b,  v8.8b, v0.8b
    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b
    and v13.8b, v13.8b, v0.8b
    and v14.8b, v14.8b, v0.8b

    sub v7.4h, v7.4h, v11.4h
    sub v8.4h, v8.4h, v12.4h
    sub v9.4h, v9.4h, v13.4h
    sub v10.4h, v10.4h, v14.4h

    #store
    str s7, [dst, #12*4]
    str s8, [dst, #13*4]
    str s9, [dst, #14*4]
    str s10, [dst, #15*4]

    .unreq    dst
    .unreq    src1
    .unreq    src2    
    .unreq    table
    .unreq    counter

    ret

.global poly_sotp_inv_asm
.global _poly_sotp_inv_asm
poly_sotp_inv_asm:
_poly_sotp_inv_asm:
    dst       .req x0
    src1      .req x1
    src2      .req x2 
    table     .req x3
    counter   .req x8

    #load
    ldr  q0, [table, #0]

    eor v1.16b, v1.16b, v1.16b 

    add counter, src1, #1536

_loop_sotp_inv:
    eor v2.16b, v2.16b, v2.16b
    eor v3.16b, v3.16b, v3.16b

    #load
    ldr q4, [src2,  #0]
    ldr q5, [src2, #16]
    ldr q6, [src2, #108]
    ldr q7, [src2, #124]

    #load
    ldr  q8, [src1, #0*16]
    ldr  q9, [src1, #1*16]
    ldr q10, [src1, #2*16]
    ldr q11, [src1, #3*16]

    ushr v14.8h, v6.8h, #1
    ushr v15.8h, v7.8h, #1

    and v12.16b,  v6.16b, v0.16b
    and v13.16b,  v7.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b

    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h
    add v11.8h, v11.8h, v15.8h

    orr  v1.16b, v1.16b,  v8.16b
    orr  v1.16b, v1.16b,  v9.16b
    orr  v1.16b, v1.16b, v10.16b
    orr  v1.16b, v1.16b, v11.16b

    shl v10.8h, v10.8h, #1
    shl v11.8h, v11.8h, #1

    eor v2.16b, v2.16b, v8.16b
    eor v3.16b, v3.16b, v9.16b
    eor v2.16b, v2.16b, v10.16b
    eor v3.16b, v3.16b, v11.16b

    #load
    ldr  q8, [src1, #4*16]
    ldr  q9, [src1, #5*16]
    ldr q10, [src1, #6*16]
    ldr q11, [src1, #7*16]

    ushr v12.8h, v6.8h, #2
    ushr v13.8h, v7.8h, #2
    ushr v14.8h, v6.8h, #3
    ushr v15.8h, v7.8h, #3

    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b

    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h
    add v11.8h, v11.8h, v15.8h

    orr  v1.16b, v1.16b,  v8.16b
    orr  v1.16b, v1.16b,  v9.16b
    orr  v1.16b, v1.16b, v10.16b
    orr  v1.16b, v1.16b, v11.16b

    shl  v8.8h,  v8.8h, #2
    shl  v9.8h,  v9.8h, #2
    shl v10.8h, v10.8h, #3
    shl v11.8h, v11.8h, #3

    eor v2.16b, v2.16b,  v8.16b
    eor v3.16b, v3.16b,  v9.16b
    eor v2.16b, v2.16b, v10.16b
    eor v3.16b, v3.16b, v11.16b

    #load
    ldr  q8, [src1,  #8*16]
    ldr  q9, [src1,  #9*16]
    ldr q10, [src1, #10*16]
    ldr q11, [src1, #11*16]

    ushr v12.8h, v6.8h, #4
    ushr v13.8h, v7.8h, #4
    ushr v14.8h, v6.8h, #5
    ushr v15.8h, v7.8h, #5

    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b

    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h
    add v11.8h, v11.8h, v15.8h

    orr  v1.16b, v1.16b,  v8.16b
    orr  v1.16b, v1.16b,  v9.16b
    orr  v1.16b, v1.16b, v10.16b
    orr  v1.16b, v1.16b, v11.16b

    shl  v8.8h, v8.8h, #4
    shl  v9.8h, v9.8h, #4
    shl v10.8h, v10.8h, #5
    shl v11.8h, v11.8h, #5

    eor v2.16b, v2.16b,  v8.16b
    eor v3.16b, v3.16b,  v9.16b
    eor v2.16b, v2.16b, v10.16b
    eor v3.16b, v3.16b, v11.16b

    #load
    ldr  q8, [src1, #12*16]
    ldr  q9, [src1, #13*16]
    ldr q10, [src1, #14*16]
    ldr q11, [src1, #15*16]

    ushr v12.8h, v6.8h, #6
    ushr v13.8h, v7.8h, #6
    ushr v14.8h, v6.8h, #7
    ushr v15.8h, v7.8h, #7

    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b

    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h
    add v11.8h, v11.8h, v15.8h

    orr  v1.16b, v1.16b,  v8.16b
    orr  v1.16b, v1.16b,  v9.16b
    orr  v1.16b, v1.16b, v10.16b
    orr  v1.16b, v1.16b, v11.16b

    shl  v8.8h, v8.8h, #6
    shl  v9.8h, v9.8h, #6
    shl v10.8h, v10.8h, #7
    shl v11.8h, v11.8h, #7

    eor v2.16b, v2.16b,  v8.16b
    eor v3.16b, v3.16b,  v9.16b
    eor v2.16b, v2.16b, v10.16b
    eor v3.16b, v3.16b, v11.16b

    #load
    ldr  q8, [src1, #16*16]
    ldr  q9, [src1, #17*16]
    ldr q10, [src1, #18*16]
    ldr q11, [src1, #19*16]

    ushr v12.8h, v6.8h, #8
    ushr v13.8h, v7.8h, #8
    ushr v14.8h, v6.8h, #9
    ushr v15.8h, v7.8h, #9

    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b

    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h
    add v11.8h, v11.8h, v15.8h

    orr  v1.16b, v1.16b,  v8.16b
    orr  v1.16b, v1.16b,  v9.16b
    orr  v1.16b, v1.16b, v10.16b
    orr  v1.16b, v1.16b, v11.16b

    shl  v8.8h, v8.8h, #8
    shl  v9.8h, v9.8h, #8
    shl v10.8h, v10.8h, #9
    shl v11.8h, v11.8h, #9

    eor v2.16b, v2.16b,  v8.16b
    eor v3.16b, v3.16b,  v9.16b
    eor v2.16b, v2.16b, v10.16b
    eor v3.16b, v3.16b, v11.16b

    #load
    ldr  q8, [src1, #20*16]
    ldr  q9, [src1, #21*16]
    ldr q10, [src1, #22*16]
    ldr q11, [src1, #23*16]

    ushr v12.8h, v6.8h, #10
    ushr v13.8h, v7.8h, #10
    ushr v14.8h, v6.8h, #11
    ushr v15.8h, v7.8h, #11

    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b

    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h
    add v11.8h, v11.8h, v15.8h

    orr  v1.16b, v1.16b,  v8.16b
    orr  v1.16b, v1.16b,  v9.16b
    orr  v1.16b, v1.16b, v10.16b
    orr  v1.16b, v1.16b, v11.16b

    shl  v8.8h, v8.8h, #10
    shl  v9.8h, v9.8h, #10
    shl v10.8h, v10.8h, #11
    shl v11.8h, v11.8h, #11

    eor v2.16b, v2.16b,  v8.16b
    eor v3.16b, v3.16b,  v9.16b
    eor v2.16b, v2.16b, v10.16b
    eor v3.16b, v3.16b, v11.16b

    #load
    ldr  q8, [src1, #24*16]
    ldr  q9, [src1, #25*16]
    ldr q10, [src1, #26*16]
    ldr q11, [src1, #27*16]

    ushr v12.8h, v6.8h, #12
    ushr v13.8h, v7.8h, #12
    ushr v14.8h, v6.8h, #13
    ushr v15.8h, v7.8h, #13

    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b

    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h
    add v11.8h, v11.8h, v15.8h

    orr  v1.16b, v1.16b,  v8.16b
    orr  v1.16b, v1.16b,  v9.16b
    orr  v1.16b, v1.16b, v10.16b
    orr  v1.16b, v1.16b, v11.16b

    shl  v8.8h, v8.8h, #12
    shl  v9.8h, v9.8h, #12
    shl v10.8h, v10.8h, #13
    shl v11.8h, v11.8h, #13

    eor v2.16b, v2.16b,  v8.16b
    eor v3.16b, v3.16b,  v9.16b
    eor v2.16b, v2.16b, v10.16b
    eor v3.16b, v3.16b, v11.16b

    #load
    ldr  q8, [src1, #28*16]
    ldr  q9, [src1, #29*16]
    ldr q10, [src1, #30*16]
    ldr q11, [src1, #31*16]

    ushr v12.8h, v6.8h, #14
    ushr v13.8h, v7.8h, #14
    ushr v14.8h, v6.8h, #15
    ushr v15.8h, v7.8h, #15

    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b
    and v15.16b, v15.16b, v0.16b

    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h
    add v11.8h, v11.8h, v15.8h

    orr  v1.16b, v1.16b,  v8.16b
    orr  v1.16b, v1.16b,  v9.16b
    orr  v1.16b, v1.16b, v10.16b
    orr  v1.16b, v1.16b, v11.16b

    shl  v8.8h, v8.8h, #14
    shl  v9.8h, v9.8h, #14
    shl v10.8h, v10.8h, #15
    shl v11.8h, v11.8h, #15

    eor v2.16b, v2.16b,  v8.16b
    eor v3.16b, v3.16b,  v9.16b
    eor v2.16b, v2.16b, v10.16b
    eor v3.16b, v3.16b, v11.16b

    eor v2.16b, v2.16b, v4.16b
    eor v3.16b, v3.16b, v5.16b

    #store
    str q2, [dst, #0]
    str q3, [dst, #16]

    add dst, dst, #32
    add src1, src1, #512
    add src2, src2, #32
    cmp src1, counter
    blt _loop_sotp_inv

    eor v2.16b, v2.16b, v2.16b

    #load
    ldr d3, [src2, #0]
    ldr d4, [src2, #108]

    #load
    ldr d5, [src1, #0*8]
    ldr d6, [src1, #1*8]
    ldr d7, [src1, #2*8]
    ldr d8, [src1, #3*8]

    ushr v10.4h, v4.4h, #1
    ushr v11.4h, v4.4h, #2
    ushr v12.4h, v4.4h, #3

    and  v9.8b,  v4.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b

    add v5.4h, v5.4h,  v9.4h
    add v6.4h, v6.4h, v10.4h
    add v7.4h, v7.4h, v11.4h
    add v8.4h, v8.4h, v12.4h

    orr  v1.8b, v1.8b, v5.8b
    orr  v1.8b, v1.8b, v6.8b
    orr  v1.8b, v1.8b, v7.8b
    orr  v1.8b, v1.8b, v8.8b

    shl v6.4h, v6.4h, #1
    shl v7.4h, v7.4h, #2
    shl v8.4h, v8.4h, #3

    eor v2.8b, v2.8b, v5.8b
    eor v2.8b, v2.8b, v6.8b
    eor v2.8b, v2.8b, v7.8b
    eor v2.8b, v2.8b, v8.8b

    ldr d5, [src1, #4*8]
    ldr d6, [src1, #5*8]
    ldr d7, [src1, #6*8]
    ldr d8, [src1, #7*8]

    ushr  v9.4h, v4.4h, #4
    ushr v10.4h, v4.4h, #5
    ushr v11.4h, v4.4h, #6
    ushr v12.4h, v4.4h, #7

    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b

    add v5.4h, v5.4h,  v9.4h
    add v6.4h, v6.4h, v10.4h
    add v7.4h, v7.4h, v11.4h
    add v8.4h, v8.4h, v12.4h

    orr  v1.8b, v1.8b, v5.8b
    orr  v1.8b, v1.8b, v6.8b
    orr  v1.8b, v1.8b, v7.8b
    orr  v1.8b, v1.8b, v8.8b

    shl v5.4h, v5.4h, #4
    shl v6.4h, v6.4h, #5
    shl v7.4h, v7.4h, #6
    shl v8.4h, v8.4h, #7

    eor v2.8b, v2.8b, v5.8b
    eor v2.8b, v2.8b, v6.8b
    eor v2.8b, v2.8b, v7.8b
    eor v2.8b, v2.8b, v8.8b

    ldr d5, [src1, #8*8]
    ldr d6, [src1, #9*8]
    ldr d7, [src1, #10*8]
    ldr d8, [src1, #11*8]

    ushr  v9.4h, v4.4h, #8
    ushr v10.4h, v4.4h, #9
    ushr v11.4h, v4.4h, #10
    ushr v12.4h, v4.4h, #11

    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b

    add v5.4h, v5.4h,  v9.4h
    add v6.4h, v6.4h, v10.4h
    add v7.4h, v7.4h, v11.4h
    add v8.4h, v8.4h, v12.4h

    orr  v1.8b, v1.8b, v5.8b
    orr  v1.8b, v1.8b, v6.8b
    orr  v1.8b, v1.8b, v7.8b
    orr  v1.8b, v1.8b, v8.8b

    shl v5.4h, v5.4h, #8
    shl v6.4h, v6.4h, #9
    shl v7.4h, v7.4h, #10
    shl v8.4h, v8.4h, #11

    eor v2.8b, v2.8b, v5.8b
    eor v2.8b, v2.8b, v6.8b
    eor v2.8b, v2.8b, v7.8b
    eor v2.8b, v2.8b, v8.8b

    ldr d5, [src1, #12*8]
    ldr d6, [src1, #13*8]
    ldr d7, [src1, #14*8]
    ldr d8, [src1, #15*8]

    ushr  v9.4h, v4.4h, #12
    ushr v10.4h, v4.4h, #13
    ushr v11.4h, v4.4h, #14
    ushr v12.4h, v4.4h, #15

    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b

    add v5.4h, v5.4h,  v9.4h
    add v6.4h, v6.4h, v10.4h
    add v7.4h, v7.4h, v11.4h
    add v8.4h, v8.4h, v12.4h

    orr  v1.8b, v1.8b, v5.8b
    orr  v1.8b, v1.8b, v6.8b
    orr  v1.8b, v1.8b, v7.8b
    orr  v1.8b, v1.8b, v8.8b

    shl v5.4h, v5.4h, #12
    shl v6.4h, v6.4h, #13
    shl v7.4h, v7.4h, #14
    shl v8.4h, v8.4h, #15

    eor v2.8b, v2.8b, v5.8b
    eor v2.8b, v2.8b, v6.8b
    eor v2.8b, v2.8b, v7.8b
    eor v2.8b, v2.8b, v8.8b

    eor v2.8b, v2.8b, v3.8b
    str d2, [dst, #0]

    add dst, dst, #8
    add src1, src1, #128
    add src2, src2, #8

    eor v13.16b, v13.16b, v13.16b
    eor v2.16b,   v2.16b, v2.16b

    #load
    ldr s3, [src2, #0]
    ldr s4, [src2, #108]

    #load
    ldr s5, [src1, #0*4]
    ldr s6, [src1, #1*4]
    ldr s7, [src1, #2*4]
    ldr s8, [src1, #3*4]

    ushr v10.4h, v4.4h, #1
    ushr v11.4h, v4.4h, #2
    ushr v12.4h, v4.4h, #3

    and  v9.8b,  v4.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b

    add v5.4h, v5.4h,  v9.4h
    add v6.4h, v6.4h, v10.4h
    add v7.4h, v7.4h, v11.4h
    add v8.4h, v8.4h, v12.4h

    orr  v13.8b, v13.8b, v5.8b
    orr  v13.8b, v13.8b, v6.8b
    orr  v13.8b, v13.8b, v7.8b
    orr  v13.8b, v13.8b, v8.8b

    shl v6.4h, v6.4h, #1
    shl v7.4h, v7.4h, #2
    shl v8.4h, v8.4h, #3

    eor v2.8b, v2.8b, v5.8b
    eor v2.8b, v2.8b, v6.8b
    eor v2.8b, v2.8b, v7.8b
    eor v2.8b, v2.8b, v8.8b

    ldr s5, [src1, #4*4]
    ldr s6, [src1, #5*4]
    ldr s7, [src1, #6*4]
    ldr s8, [src1, #7*4]

    ushr  v9.4h, v4.4h, #4
    ushr v10.4h, v4.4h, #5
    ushr v11.4h, v4.4h, #6
    ushr v12.4h, v4.4h, #7

    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b

    add v5.4h, v5.4h,  v9.4h
    add v6.4h, v6.4h, v10.4h
    add v7.4h, v7.4h, v11.4h
    add v8.4h, v8.4h, v12.4h

    orr  v13.8b, v13.8b, v5.8b
    orr  v13.8b, v13.8b, v6.8b
    orr  v13.8b, v13.8b, v7.8b
    orr  v13.8b, v13.8b, v8.8b

    shl v5.4h, v5.4h, #4
    shl v6.4h, v6.4h, #5
    shl v7.4h, v7.4h, #6
    shl v8.4h, v8.4h, #7

    eor v2.8b, v2.8b, v5.8b
    eor v2.8b, v2.8b, v6.8b
    eor v2.8b, v2.8b, v7.8b
    eor v2.8b, v2.8b, v8.8b

    ldr s5, [src1, #8*4]
    ldr s6, [src1, #9*4]
    ldr s7, [src1, #10*4]
    ldr s8, [src1, #11*4]

    ushr  v9.4h, v4.4h, #8
    ushr v10.4h, v4.4h, #9
    ushr v11.4h, v4.4h, #10
    ushr v12.4h, v4.4h, #11

    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b

    add v5.4h, v5.4h,  v9.4h
    add v6.4h, v6.4h, v10.4h
    add v7.4h, v7.4h, v11.4h
    add v8.4h, v8.4h, v12.4h

    orr  v13.8b, v13.8b, v5.8b
    orr  v13.8b, v13.8b, v6.8b
    orr  v13.8b, v13.8b, v7.8b
    orr  v13.8b, v13.8b, v8.8b

    shl v5.4h, v5.4h, #8
    shl v6.4h, v6.4h, #9
    shl v7.4h, v7.4h, #10
    shl v8.4h, v8.4h, #11

    eor v2.8b, v2.8b, v5.8b
    eor v2.8b, v2.8b, v6.8b
    eor v2.8b, v2.8b, v7.8b
    eor v2.8b, v2.8b, v8.8b

    ldr s5, [src1, #12*4]
    ldr s6, [src1, #13*4]
    ldr s7, [src1, #14*4]
    ldr s8, [src1, #15*4]

    ushr  v9.4h, v4.4h, #12
    ushr v10.4h, v4.4h, #13
    ushr v11.4h, v4.4h, #14
    ushr v12.4h, v4.4h, #15

    and  v9.8b,  v9.8b, v0.8b
    and v10.8b, v10.8b, v0.8b
    and v11.8b, v11.8b, v0.8b
    and v12.8b, v12.8b, v0.8b

    add v5.4h, v5.4h,  v9.4h
    add v6.4h, v6.4h, v10.4h
    add v7.4h, v7.4h, v11.4h
    add v8.4h, v8.4h, v12.4h

    orr  v13.8b, v13.8b, v5.8b
    orr  v13.8b, v13.8b, v6.8b
    orr  v13.8b, v13.8b, v7.8b
    orr  v13.8b, v13.8b, v8.8b

    shl v5.4h, v5.4h, #12
    shl v6.4h, v6.4h, #13
    shl v7.4h, v7.4h, #14
    shl v8.4h, v8.4h, #15

    eor v2.8b, v2.8b, v5.8b
    eor v2.8b, v2.8b, v6.8b
    eor v2.8b, v2.8b, v7.8b
    eor v2.8b, v2.8b, v8.8b

    eor v2.8b, v2.8b, v3.8b
    str d2, [dst, #0]

    ushr v13.8b, v13.8b, #1
    umov  w13, v13.s[0]

    ushr v1.16b, v1.16b, #1
    umaxv s1, v1.4s
    umov  w0, v1.s[0]

    eor   w0, w0, w13
    cmp w0, #0
    cset x0, ne

    .unreq    dst
    .unreq    src1
    .unreq    src2    
    .unreq    table
    .unreq    counter

    ret
