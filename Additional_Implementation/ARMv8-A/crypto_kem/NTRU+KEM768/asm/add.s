.global poly_sub
.global _poly_sub
poly_sub:
_poly_sub:
    dst       .req x0
    src1      .req x1
    src2      .req x2
    counter   .req x8

    add counter, dst, #1536

.align 2
_loop_sub:
    ld1 {v0.8h,  v1.8h,  v2.8h,  v3.8h},  [x1], #64
    ld1 {v12.8h, v13.8h, v14.8h, v15.8h}, [x2], #64

    sub v0.8h, v0.8h, v12.8h
    sub v1.8h, v1.8h, v13.8h
    sub v2.8h, v2.8h, v14.8h
    sub v3.8h, v3.8h, v15.8h

    st1 {v0.8h, v1.8h,  v2.8h,  v3.8h}, [x0], #64

    
    ld1 {v4.8h,  v5.8h,  v6.8h,  v7.8h},  [x1], #64
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x2], #64
    
    sub v4.8h, v4.8h, v16.8h
    sub v5.8h, v5.8h, v17.8h
    sub v6.8h, v6.8h, v18.8h
    sub v7.8h, v7.8h, v19.8h

    st1 {v4.8h, v5.8h,  v6.8h,  v7.8h}, [x0], #64

    ld1 {v8.8h,  v9.8h,  v10.8h, v11.8h}, [x1], #64
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x2], #64

    sub v8.8h, v8.8h, v20.8h
    sub v9.8h, v9.8h, v21.8h
    sub v10.8h, v10.8h, v22.8h
    sub v11.8h, v11.8h, v23.8h

    st1 {v8.8h, v9.8h, v10.8h, v11.8h}, [x0], #64


    cmp dst, counter
    blt _loop_sub

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    counter

    ret


.global poly_triple
.global _poly_triple
poly_triple:
_poly_triple:
    dst     .req x0
    src     .req x1
    counter .req x8

    add counter, dst, #1536

.align 2
_loop_triple:
    ld1 {v0.8h, v1.8h,  v2.8h,  v3.8h}, [x1], #64

    add v12.8h, v0.8h, v0.8h
    add v13.8h, v1.8h, v1.8h
    add v14.8h, v2.8h, v2.8h
    add v15.8h, v3.8h, v3.8h

    add v0.8h, v0.8h, v12.8h
    add v1.8h, v1.8h, v13.8h
    add v2.8h, v2.8h, v14.8h
    add v3.8h, v3.8h, v15.8h

    st1 {v0.8h, v1.8h, v2.8h,  v3.8h},  [x0], #64

    ld1 {v4.8h, v5.8h,  v6.8h,  v7.8h}, [x1], #64

    add v16.8h, v4.8h, v4.8h
    add v17.8h, v5.8h, v5.8h
    add v18.8h, v6.8h, v6.8h
    add v19.8h, v7.8h, v7.8h

    add v4.8h, v4.8h, v16.8h
    add v5.8h, v5.8h, v17.8h
    add v6.8h, v6.8h, v18.8h
    add v7.8h, v7.8h, v19.8h

    st1 {v4.8h, v5.8h, v6.8h,  v7.8h},  [x0], #64

    ld1 {v8.8h, v9.8h, v10.8h, v11.8h}, [x1], #64

    add v20.8h, v8.8h, v8.8h
    add v21.8h, v9.8h, v9.8h
    add v22.8h, v10.8h, v10.8h
    add v23.8h, v11.8h, v11.8h

    add v8.8h, v8.8h, v20.8h
    add v9.8h, v9.8h, v21.8h
    add v10.8h, v10.8h, v22.8h
    add v11.8h, v11.8h, v23.8h

    st1 {v8.8h, v9.8h, v10.8h, v11.8h}, [x0], #64

    cmp dst, counter
    blt _loop_triple

    .unreq    dst
    .unreq    src
    .unreq    counter

    ret
