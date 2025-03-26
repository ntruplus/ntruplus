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

    #load
    ldr d5, [src, #64]
    ldr d6, [src, #136]

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
    str d7, [dst, #1024]
    str d8, [dst, #1032]
    str d9, [dst, #1040]
    str d10, [dst, #1048]

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
    str d7, [dst, #1056]
    str d8, [dst, #1064]
    str d9, [dst, #1072]
    str d10, [dst, #1080]

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
    str d7, [dst, #1088]
    str d8, [dst, #1096]
    str d9, [dst, #1104]
    str d10, [dst, #1112]

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
    str d7, [dst, #1120]
    str d8, [dst, #1128]
    str d9, [dst, #1136]
    str d10, [dst, #1144]

    add counter, dst, #1024

_loop_cbd:
    #load
    ldr q3, [src, #0]
    ldr q4, [src, #16]
    ldr q5, [src, #72]
    ldr q6, [src, #88]
    
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

    #load
    ldr d4, [src1, #64]
    ldr d5, [src2, #64]
    ldr d6, [src2, #136]

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
    str d7, [dst, #1024]
    str d8, [dst, #1032]
    str d9, [dst, #1040]
    str d10, [dst, #1048]

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
    str d7, [dst, #1056]
    str d8, [dst, #1064]
    str d9, [dst, #1072]
    str d10, [dst, #1080]

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
    str d7, [dst, #1088]
    str d8, [dst, #1096]
    str d9, [dst, #1104]
    str d10, [dst, #1112]

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
    str d7, [dst, #1120]
    str d8, [dst, #1128]
    str d9, [dst, #1136]
    str d10, [dst, #1144]

    add counter, dst, #1024

_loop_sotp:
    #load
    ldr q1, [src1, #0]
    ldr q2, [src1, #16]
    ldr q3, [src2, #0]
    ldr q4, [src2, #16]
    ldr q5, [src2, #72]
    ldr q6, [src2, #88]

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
    eor v2.16b, v2.16b, v2.16b

    #load
    ldr d3, [src2, #64]
    ldr d4, [src2, #136]

    #load
    ldr d5, [src1, #1024]
    ldr d6, [src1, #1032]
    ldr d7, [src1, #1040]
    ldr d8, [src1, #1048]

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

    ldr d5, [src1, #1056]
    ldr d6, [src1, #1064]
    ldr d7, [src1, #1072]
    ldr d8, [src1, #1080]

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

    ldr d5, [src1, #1088]
    ldr d6, [src1, #1096]
    ldr d7, [src1, #1104]
    ldr d8, [src1, #1112]

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

    ldr d5, [src1, #1120]
    ldr d6, [src1, #1128]
    ldr d7, [src1, #1136]
    ldr d8, [src1, #1144]

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
    str d2, [dst, #64]

    add counter, src1, #1024

_loop_sotp_inv:
    eor v2.16b, v2.16b, v2.16b
    eor v3.16b, v3.16b, v3.16b

    #load
    ldr q4, [src2,  #0]
    ldr q5, [src2, #16]
    ldr q6, [src2, #72]
    ldr q7, [src2, #88]

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

    ushr v1.16b, v1.16b, #1
    umaxv h1, v1.8h
    umov  w0, v1.h[0]
    cmp w0, #0
    cset x0, ne

    .unreq    dst
    .unreq    src1
    .unreq    src2    
    .unreq    table
    .unreq    counter

    ret
