.global poly_frombytes
.global _poly_frombytes
poly_frombytes:
_poly_frombytes:
    dst       .req x0
    src       .req x1
    counter   .req x8

    adr x2, const_mask_0fff
    ldr q0, [x2]

    mov counter, #2304

_loop_frombytes:
    ld1 {v1.8h-v3.8h}, [src], #48
    ld1 {v4.8h-v6.8h}, [src], #48

    trn1 v7.2d,  v1.2d, v4.2d
    trn2 v8.2d,  v1.2d, v4.2d
    trn1 v9.2d,  v2.2d, v5.2d
    trn2 v10.2d, v2.2d, v5.2d
    trn1 v11.2d, v3.2d, v6.2d
    trn2 v12.2d, v3.2d, v6.2d

    trn1 v13.4s, v7.4s, v10.4s
    trn2 v14.4s, v7.4s, v10.4s
    trn1 v15.4s, v8.4s, v11.4s
    trn2 v16.4s, v8.4s, v11.4s
    trn1 v17.4s, v9.4s, v12.4s
    trn2 v18.4s, v9.4s, v12.4s

    trn1 v19.8h, v13.8h, v16.8h
    trn2 v20.8h, v13.8h, v16.8h
    trn1 v21.8h, v14.8h, v17.8h
    trn2 v22.8h, v14.8h, v17.8h
    trn1 v23.8h, v15.8h, v18.8h
    trn2 v24.8h, v15.8h, v18.8h

    ushr  v25.8h, v19.8h, #12
    shl   v26.8h, v20.8h, #4
    ushr  v27.8h, v20.8h, #8
    shl   v28.8h, v21.8h, #8
    ushr  v29.8h, v21.8h, #4
    
    ushr  v30.8h, v22.8h, #12
    shl   v31.8h, v23.8h, #4
    ushr  v1.8h,  v23.8h, #8
    shl   v2.8h,  v24.8h, #8
    ushr  v3.8h,  v24.8h, #4

    eor v4.16b, v25.16b, v26.16b
    eor v5.16b, v27.16b, v28.16b
    eor v6.16b, v30.16b, v31.16b
    eor v7.16b, v1.16b,  v2.16b

    and v8.16b,  v19.16b, v0.16b
    and v9.16b,  v4.16b,  v0.16b
    and v10.16b, v5.16b,  v0.16b
    and v11.16b, v29.16b, v0.16b
    and v12.16b, v22.16b, v0.16b
    and v13.16b, v6.16b,  v0.16b
    and v14.16b, v7.16b,  v0.16b
    and v15.16b, v3.16b,  v0.16b

    st1 {v8.8h-v11.8h},  [dst], #64
    st1 {v12.8h-v15.8h}, [dst], #64

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

    mov counter, #2304

_loop_tobytes:
    #load
    ld1 {v1.8h-v4.8h}, [src], #64
    ld1 {v5.8h-v8.8h}, [src], #64

    sshr v9.8h,  v1.8h, #15
    sshr v10.8h, v2.8h, #15
    sshr v11.8h, v3.8h, #15
    sshr v12.8h, v4.8h, #15
    sshr v13.8h, v5.8h, #15
    sshr v14.8h, v6.8h, #15
    sshr v15.8h, v7.8h, #15
    sshr v16.8h, v8.8h, #15

    and v17.16b, v9.16b,  v0.16b
    and v18.16b, v10.16b, v0.16b
    and v19.16b, v11.16b, v0.16b
    and v20.16b, v12.16b, v0.16b
    and v21.16b, v13.16b, v0.16b
    and v22.16b, v14.16b, v0.16b
    and v23.16b, v15.16b, v0.16b
    and v24.16b, v16.16b, v0.16b

    add v25.8h, v1.8h, v17.8h
    add v26.8h, v2.8h, v18.8h
    add v27.8h, v3.8h, v19.8h
    add v28.8h, v4.8h, v20.8h
    add v29.8h, v5.8h, v21.8h
    add v30.8h, v6.8h, v22.8h
    add v31.8h, v7.8h, v23.8h
    add v1.8h,  v8.8h, v24.8h

    ushr v2.8h, v26.8h, #4
    ushr v3.8h, v27.8h, #8
    ushr v4.8h, v30.8h, #4
    ushr v5.8h, v31.8h, #8

    shl  v6.8h,  v26.8h, #12
    shl  v7.8h,  v27.8h, #8
    shl  v8.8h,  v28.8h, #4
    shl  v9.8h,  v30.8h, #12
    shl  v10.8h, v31.8h, #8
    shl  v11.8h, v1.8h,  #4

    eor v12.16b, v25.16b, v6.16b  
    eor v13.16b, v2.16b,  v7.16b 
    eor v14.16b, v3.16b,  v8.16b
    eor v15.16b, v29.16b, v9.16b 
    eor v16.16b, v4.16b,  v10.16b
    eor v17.16b, v5.16b,  v11.16b

    trn1 v18.8h, v12.8h, v13.8h
    trn1 v19.8h, v14.8h, v15.8h
    trn1 v20.8h, v16.8h, v17.8h
    trn2 v21.8h, v12.8h, v13.8h
    trn2 v22.8h, v14.8h, v15.8h
    trn2 v23.8h, v16.8h, v17.8h

    trn1 v24.4s, v18.4s, v19.4s
    trn1 v25.4s, v20.4s, v21.4s
    trn1 v26.4s, v22.4s, v23.4s
    trn2 v27.4s, v18.4s, v19.4s
    trn2 v28.4s, v20.4s, v21.4s
    trn2 v29.4s, v22.4s, v23.4s

    trn1 v1.2d, v24.2d, v25.2d
    trn1 v2.2d, v26.2d, v27.2d
    trn1 v3.2d, v28.2d, v29.2d
    trn2 v4.2d, v24.2d, v25.2d
    trn2 v5.2d, v26.2d, v27.2d
    trn2 v6.2d, v28.2d, v29.2d

    #store
    st1 {v1.8h-v3.8h}, [dst], #48
    st1 {v4.8h-v6.8h}, [dst], #48

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
