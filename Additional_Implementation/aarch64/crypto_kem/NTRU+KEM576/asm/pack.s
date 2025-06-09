.global poly_frombytes
.global _poly_frombytes
poly_frombytes:
_poly_frombytes:
    dst       .req x0
    src       .req x1
    counter   .req x8

    adr x2, const_mask_0fff
    ldr q0, [x2]

    mov counter, #1152

_loop_frombytes:
    ld1 {v1.8h-v3.8h}, [src], #48
    ld1 {v4.8h-v6.8h}, [src], #48

    ushr  v7.8h, v1.8h, #12
    ushr  v8.8h, v2.8h, #12
    ushr  v9.8h, v3.8h, #8
    ushr v10.8h, v4.8h, #8
    ushr v25.8h, v5.8h, #4
    ushr v26.8h, v6.8h, #4

    shl v11.8h, v3.8h, #4
    shl v12.8h, v4.8h, #4
    shl v13.8h, v5.8h, #8
    shl v14.8h, v6.8h, #8

    eor v15.16b,  v7.16b, v11.16b
    eor v16.16b,  v8.16b, v12.16b
    eor v17.16b,  v9.16b, v13.16b
    eor v18.16b, v10.16b, v14.16b

    and v19.16b,  v1.16b, v0.16b
    and v20.16b,  v2.16b, v0.16b
    and v21.16b, v15.16b, v0.16b
    and v22.16b, v16.16b, v0.16b
    and v23.16b, v17.16b, v0.16b
    and v24.16b, v18.16b, v0.16b

    trn1 v27.2d, v19.2d, v23.2d
    trn2 v28.2d, v19.2d, v23.2d
    trn1 v29.2d, v20.2d, v24.2d
    trn2 v30.2d, v20.2d, v24.2d
    trn1 v31.2d, v21.2d, v25.2d
    trn2  v1.2d, v21.2d, v25.2d
    trn1  v2.2d, v22.2d, v26.2d
    trn2  v3.2d, v22.2d, v26.2d

    trn1  v4.4s, v27.4s, v31.4s
    trn2  v5.4s, v27.4s, v31.4s
    trn1  v6.4s, v28.4s,  v1.4s
    trn2  v7.4s, v28.4s,  v1.4s
    trn1  v8.4s, v29.4s,  v2.4s
    trn2  v9.4s, v29.4s,  v2.4s
    trn1 v10.4s, v30.4s,  v3.4s
    trn2 v11.4s, v30.4s,  v3.4s

    trn1 v12.8h, v4.8h,  v8.8h
    trn2 v13.8h, v4.8h,  v8.8h
    trn1 v14.8h, v5.8h,  v9.8h
    trn2 v15.8h, v5.8h,  v9.8h
    trn1 v16.8h, v6.8h, v10.8h
    trn2 v17.8h, v6.8h, v10.8h
    trn1 v18.8h, v7.8h, v11.8h
    trn2 v19.8h, v7.8h, v11.8h

    st1 {v12.8h-v15.8h}, [dst], #64
    st1 {v16.8h-v19.8h}, [dst], #64

    subs counter, counter, #128
    b.ne _loop_frombytes

    .unreq dst
    .unreq src
    .unreq counter

    ret


.global poly_tobytes
.global _poly_tobytes
poly_tobytes:
_poly_tobytes:
    dst       .req x0
    src       .req x1
    counter   .req x8

    adr x2, const_q
    ldr q0, [x2]

    mov counter, #1152

_loop_tobytes:
    #load
    ld1 {v1.8h-v4.8h}, [src], #64
    ld1 {v5.8h-v8.8h}, [src], #64

    trn1  v9.2d, v1.2d, v5.2d
    trn2 v10.2d, v1.2d, v5.2d
    trn1 v11.2d, v2.2d, v6.2d
    trn2 v12.2d, v2.2d, v6.2d
    trn1 v13.2d, v3.2d, v7.2d
    trn2 v14.2d, v3.2d, v7.2d
    trn1 v15.2d, v4.2d, v8.2d
    trn2 v16.2d, v4.2d, v8.2d

    trn1 v17.4s,  v9.4s, v13.4s
    trn2 v18.4s,  v9.4s, v13.4s
    trn1 v19.4s, v10.4s, v14.4s
    trn2 v20.4s, v10.4s, v14.4s
    trn1 v21.4s, v11.4s, v15.4s
    trn2 v22.4s, v11.4s, v15.4s
    trn1 v23.4s, v12.4s, v16.4s
    trn2 v24.4s, v12.4s, v16.4s

    trn1 v25.8h, v17.8h, v21.8h
    trn2 v26.8h, v17.8h, v21.8h
    trn1 v27.8h, v18.8h, v22.8h
    trn2 v28.8h, v18.8h, v22.8h
    trn1 v29.8h, v19.8h, v23.8h
    trn2 v30.8h, v19.8h, v23.8h
    trn1 v31.8h, v20.8h, v24.8h
    trn2  v1.8h, v20.8h, v24.8h

    sshr v2.8h, v25.8h, #15
    sshr v3.8h, v26.8h, #15
    sshr v4.8h, v27.8h, #15
    sshr v5.8h, v28.8h, #15
    sshr v6.8h, v29.8h, #15
    sshr v7.8h, v30.8h, #15
    sshr v8.8h, v31.8h, #15
    sshr v9.8h,  v1.8h, #15

    and v10.16b, v2.16b, v0.16b
    and v11.16b, v3.16b, v0.16b
    and v12.16b, v4.16b, v0.16b
    and v13.16b, v5.16b, v0.16b
    and v14.16b, v6.16b, v0.16b
    and v15.16b, v7.16b, v0.16b
    and v16.16b, v8.16b, v0.16b
    and v17.16b, v9.16b, v0.16b

    add v18.8h, v25.8h, v10.8h
    add v19.8h, v26.8h, v11.8h
    add v20.8h, v27.8h, v12.8h
    add v21.8h, v28.8h, v13.8h
    add v22.8h, v29.8h, v14.8h
    add v23.8h, v30.8h, v15.8h
    add v24.8h, v31.8h, v16.8h
    add v25.8h,  v1.8h, v17.8h

    ushr v26.8h, v20.8h, #4
    ushr v27.8h, v21.8h, #4
    ushr v28.8h, v22.8h, #8
    ushr v29.8h, v23.8h, #8

    shl v30.8h, v20.8h, #12
    shl v31.8h, v21.8h, #12
    shl  v2.8h, v22.8h, #8
    shl  v3.8h, v23.8h, #8
    shl  v4.8h, v24.8h, #4
    shl  v5.8h, v25.8h, #4

    eor  v6.16b, v18.16b, v30.16b  
    eor  v7.16b, v19.16b, v31.16b 
    eor  v8.16b, v26.16b,  v2.16b 
    eor  v9.16b, v27.16b,  v3.16b
    eor v10.16b, v28.16b,  v4.16b
    eor v11.16b, v29.16b,  v5.16b

    #store
    st1 {v6.8h-v8.8h},  [dst], #48
    st1 {v9.8h-v11.8h}, [dst], #48

    subs counter, counter, #128
    b.ne _loop_tobytes

    .unreq    dst
    .unreq    src
    .unreq    counter

    ret

.align 4
const_mask_0fff:
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff

.align 4
const_q:
    .hword 3457, 3457, 3457, 3457 
    .hword 3457, 3457, 3457, 3457
