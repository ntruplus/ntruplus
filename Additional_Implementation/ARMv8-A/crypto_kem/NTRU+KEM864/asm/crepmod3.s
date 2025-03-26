.global poly_crepmod3_asm
.global _poly_crepmod3_asm
poly_crepmod3_asm:
_poly_crepmod3_asm:
    dst       .req x0
    src       .req x1
    table     .req x2
    counter   .req x8

add counter, src, #1728

    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [table], #64
    ld1 {v4.8h, v5.8h, v6.8h}, [table], #48

_looptop:
    ld1 {v7.8h, v8.8h, v9.8h, v10.8h}, [src], #64

    sshr v11.8h,  v7.8h, #15
    sshr v12.8h,  v8.8h, #15
    sshr v13.8h,  v9.8h, #15
    sshr v14.8h, v10.8h, #15

    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    add  v7.8h,  v7.8h, v11.8h
    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h

    sub  v7.8h,  v7.8h, v1.8h
    sub  v8.8h,  v8.8h, v1.8h
    sub  v9.8h,  v9.8h, v1.8h
    sub v10.8h, v10.8h, v1.8h

    sshr v11.8h,  v7.8h, #15
    sshr v12.8h,  v8.8h, #15
    sshr v13.8h,  v9.8h, #15
    sshr v14.8h, v10.8h, #15

    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b
    and v13.16b, v13.16b, v0.16b
    and v14.16b, v14.16b, v0.16b

    add  v7.8h,  v7.8h, v11.8h
    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h

    sub  v7.8h,  v7.8h, v2.8h
    sub  v8.8h,  v8.8h, v2.8h
    sub  v9.8h,  v9.8h, v2.8h 
    sub v10.8h, v10.8h, v2.8h

    //a  = (a >> 8) + (a & 255);
    sshr v11.8h,  v7.8h, #8
    sshr v12.8h,  v8.8h, #8
    sshr v13.8h,  v9.8h, #8
    sshr v14.8h, v10.8h, #8

    and  v7.16b,  v7.16b, v3.16b
    and  v8.16b,  v8.16b, v3.16b
    and  v9.16b,  v9.16b, v3.16b
    and v10.16b, v10.16b, v3.16b

    add  v7.8h,  v7.8h, v11.8h
    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h

    //a = (a >> 4) + (a & 15);
    sshr v11.8h,  v7.8h, #4
    sshr v12.8h,  v8.8h, #4
    sshr v13.8h,  v9.8h, #4
    sshr v14.8h, v10.8h, #4

    and  v7.16b,  v7.16b, v4.16b
    and  v8.16b,  v8.16b, v4.16b
    and  v9.16b,  v9.16b, v4.16b
    and v10.16b, v10.16b, v4.16b

    add  v7.8h,  v7.8h, v11.8h
    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h

    //a = (a >> 2) + (a & 3);
    sshr v11.8h,  v7.8h, #2
    sshr v12.8h,  v8.8h, #2
    sshr v13.8h,  v9.8h, #2
    sshr v14.8h, v10.8h, #2

    and  v7.16b,  v7.16b, v5.16b
    and  v8.16b,  v8.16b, v5.16b
    and  v9.16b,  v9.16b, v5.16b
    and v10.16b, v10.16b, v5.16b

    add  v7.8h,  v7.8h, v11.8h
    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h

    //a = (a >> 2) + (a & 3);
    sshr v11.8h,  v7.8h, #2
    sshr v12.8h,  v8.8h, #2
    sshr v13.8h,  v9.8h, #2
    sshr v14.8h, v10.8h, #2

    and  v7.16b,  v7.16b, v5.16b
    and  v8.16b,  v8.16b, v5.16b
    and  v9.16b,  v9.16b, v5.16b
    and v10.16b, v10.16b, v5.16b

    add  v7.8h,  v7.8h, v11.8h
    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h

    //a -= 3;
    sub  v7.8h,  v7.8h, v5.8h
    sub  v8.8h,  v8.8h, v5.8h
    sub  v9.8h,  v9.8h, v5.8h
    sub v10.8h, v10.8h, v5.8h

    //a += ((a + 1) >> 15) & 3;
    add v11.8h,  v7.8h, v6.8h
    add v12.8h,  v8.8h, v6.8h
    add v13.8h,  v9.8h, v6.8h 
    add v14.8h, v10.8h, v6.8h

    sshr v11.8h, v11.8h, #15
    sshr v12.8h, v12.8h, #15
    sshr v13.8h, v13.8h, #15
    sshr v14.8h, v14.8h, #15

    and v11.16b, v11.16b, v5.16b
    and v12.16b, v12.16b, v5.16b
    and v13.16b, v13.16b, v5.16b
    and v14.16b, v14.16b, v5.16b

    add  v7.8h,  v7.8h, v11.8h
    add  v8.8h,  v8.8h, v12.8h
    add  v9.8h,  v9.8h, v13.8h
    add v10.8h, v10.8h, v14.8h

    st1 {v7.8h, v8.8h, v9.8h, v10.8h}, [dst], #64

    cmp dst, counter
    blt _looptop

    .unreq    dst
    .unreq    src
    .unreq    table
    .unreq    counter

    ret    
