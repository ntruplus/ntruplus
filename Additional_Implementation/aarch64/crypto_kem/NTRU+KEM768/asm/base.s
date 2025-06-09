.global poly_basemul
.global _poly_basemul
poly_basemul:
_poly_basemul:
    dst       .req x0
    src1      .req x1
    src2      .req x2
    zetas_ptr .req x3
    counter   .req x8

    adr zetas_ptr, zetas_mul

    #load
    ld1  {v0.8h}, [zetas_ptr], #16

    mov counter, #1536

_looptop:
    #load
    ld1  {v1.8h}, [zetas_ptr], #16

    #load
    ld1 {v4.8h - v7.8h}, [src1], #64
    ld1 {v8.8h - v11.8h}, [src2], #64

    smull   v12.4s, v5.4h, v11.4h //a1*b3
    smull2  v13.4s, v5.8h, v11.8h //a1*b3
    smull   v14.4s, v6.4h, v11.4h //a2*b3
    smull2  v15.4s, v6.8h, v11.8h //a2*b3
    smull   v16.4s, v7.4h, v11.4h //a3*b3
    smull2  v17.4s, v7.8h, v11.8h //a3*b3

    smlal   v12.4s, v6.4h, v10.4h //a2*b2
    smlal2  v13.4s, v6.8h, v10.8h //a2*b2    
    smlal   v14.4s, v7.4h, v10.4h //a3*b2
    smlal2  v15.4s, v7.8h, v10.8h //a3*b2

    smlal   v12.4s, v7.4h, v9.4h //a3*b1
    smlal2  v13.4s, v7.8h, v9.8h //a3*b1

    uzp1    v20.8h, v16.8h, v17.8h
    uzp1    v19.8h, v14.8h, v15.8h
    uzp1    v18.8h, v12.8h, v13.8h

    mul     v20.8h, v20.8h, v0.h[1]
    mul     v19.8h, v19.8h, v0.h[1]
    mul     v18.8h, v18.8h, v0.h[1]

    smlal   v16.4s, v20.4h, v0.h[0]
    smlal2  v17.4s, v20.8h, v0.h[0]
    smlal   v14.4s, v19.4h, v0.h[0]
    smlal2  v15.4s, v19.8h, v0.h[0]
    smlal   v12.4s, v18.4h, v0.h[0]
    smlal2  v13.4s, v18.8h, v0.h[0]

    uzp2    v30.8h, v16.8h, v17.8h
    uzp2    v29.8h, v14.8h, v15.8h
    uzp2    v28.8h, v12.8h, v13.8h

    smull   v18.4s, v7.4h, v8.4h //a3*b0
    smull2  v19.4s, v7.8h, v8.8h //a3*b0
    smull   v16.4s, v30.4h, v1.4h //r[2]*zeta
    smull2  v17.4s, v30.8h, v1.8h //r[2]*zeta
    smull   v14.4s, v29.4h, v1.4h //r[1]*zeta
    smull2  v15.4s, v29.8h, v1.8h //r[1]*zeta
    smull   v12.4s, v28.4h, v1.4h //r[0]*zeta
    smull2  v13.4s, v28.8h, v1.8h //r[0]*zeta

    smlal   v18.4s, v4.4h,  v11.4h //a0*b3
    smlal2  v19.4s, v4.8h,  v11.8h //a0*b3
    smlal   v16.4s, v4.4h, v10.4h //a0*b2
    smlal2  v17.4s, v4.8h, v10.8h //a0*b2
    smlal   v14.4s, v4.4h, v9.4h //a0*b1
    smlal2  v15.4s, v4.8h, v9.8h //a0*b1
    smlal   v12.4s, v4.4h, v8.4h //a0*b0
    smlal2  v13.4s, v4.8h, v8.8h //a0*b0

    smlal   v18.4s, v5.4h, v10.4h //a1*b2
    smlal2  v19.4s, v5.8h, v10.8h //a1*b2
    smlal   v16.4s, v5.4h, v9.4h //a1*b1
    smlal2  v17.4s, v5.8h, v9.8h //a1*b1
    smlal   v14.4s, v5.4h, v8.4h //a1*b0
    smlal2  v15.4s, v5.8h, v8.8h //a1*b0

    smlal   v18.4s, v6.4h, v9.4h //a2*b1
    smlal2  v19.4s, v6.8h, v9.8h //a2*b1
    smlal   v16.4s, v6.4h, v8.4h //a2*b0
    smlal2  v17.4s, v6.8h, v8.8h //a2*b0

    uzp1    v23.8h, v18.8h, v19.8h
    uzp1    v22.8h, v16.8h, v17.8h
    uzp1    v21.8h, v14.8h, v15.8h
    uzp1    v20.8h, v12.8h, v13.8h

    mul     v23.8h, v23.8h, v0.h[1]
    mul     v22.8h, v22.8h, v0.h[1]
    mul     v21.8h, v21.8h, v0.h[1]
    mul     v20.8h, v20.8h, v0.h[1]

    smlal   v18.4s, v23.4h, v0.h[0]
    smlal   v16.4s, v22.4h, v0.h[0]
    smlal   v14.4s, v21.4h, v0.h[0]
    smlal   v12.4s, v20.4h, v0.h[0]

    smlal2  v19.4s, v23.8h, v0.h[0]
    smlal2  v17.4s, v22.8h, v0.h[0]
    smlal2  v15.4s, v21.8h, v0.h[0]
    smlal2  v13.4s, v20.8h, v0.h[0]

    uzp2    v7.8h, v18.8h, v19.8h
    uzp2    v6.8h, v16.8h, v17.8h
    uzp2    v5.8h, v14.8h, v15.8h
    uzp2    v4.8h, v12.8h, v13.8h

    #store
    st1 {v4.8h, v5.8h, v6.8h, v7.8h}, [dst], #64
    
    subs counter, counter, #64
    b.ne _looptop

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    zetas_ptr
    .unreq    counter

    ret


.global poly_basemul_add
.global _poly_basemul_add
poly_basemul_add:
_poly_basemul_add:
    dst       .req x0
    src1      .req x1
    src2      .req x2
    src3      .req x3    
    zetas_ptr .req x4
    counter   .req x8

    adr zetas_ptr, zetas_mul

    #load
    ld1  {v0.8h}, [zetas_ptr], #16

    mov counter, #1536

_looptop_add:
    #load
    ld1  {v1.8h}, [zetas_ptr], #16

    #load
    ld1 {v4.8h - v7.8h},   [src1], #64
    ld1 {v8.8h - v11.8h},  [src2], #64
    ld1 {v12.8h - v15.8h}, [src3], #64

    smull  v16.4s, v5.4h, v11.4h //a1*b3
    smull2 v17.4s, v5.8h, v11.8h //a1*b3
    smull  v18.4s, v6.4h, v11.4h //a2*b3
    smull2 v19.4s, v6.8h, v11.8h //a2*b3
    smull  v20.4s, v7.4h, v11.4h //a3*b3
    smull2 v21.4s, v7.8h, v11.8h //a3*b3

    smlal  v16.4s, v6.4h, v10.4h //a2*b2
    smlal2 v17.4s, v6.8h, v10.8h //a2*b2
    smlal  v18.4s, v7.4h, v10.4h //a3*b2
    smlal2 v19.4s, v7.8h, v10.8h //a3*b2

    smlal  v16.4s, v7.4h, v9.4h //a3*b1
    smlal2 v17.4s, v7.8h, v9.8h //a3*b1

    uzp1 v24.8h, v20.8h, v21.8h
    uzp1 v23.8h, v18.8h, v19.8h
    uzp1 v22.8h, v16.8h, v17.8h

    mul v24.8h, v24.8h, v0.h[1]
    mul v23.8h, v23.8h, v0.h[1]
    mul v22.8h, v22.8h, v0.h[1]

    smlal  v20.4s, v24.4h, v0.h[0]
    smlal2 v21.4s, v24.8h, v0.h[0]
    smlal  v18.4s, v23.4h, v0.h[0]
    smlal2 v19.4s, v23.8h, v0.h[0]
    smlal  v16.4s, v22.4h, v0.h[0]
    smlal2 v17.4s, v22.8h, v0.h[0]

    uzp2 v30.8h, v20.8h, v21.8h
    uzp2 v29.8h, v18.8h, v19.8h
    uzp2 v28.8h, v16.8h, v17.8h

    smull  v22.4s, v7.4h, v8.4h //a3*b0
    smull2 v23.4s, v7.8h, v8.8h //a3*b0
    smull  v20.4s, v30.4h, v1.4h //r[2]*zeta
    smull2 v21.4s, v30.8h, v1.8h //r[2]*zeta
    smull  v18.4s, v29.4h, v1.4h //r[1]*zeta
    smull2 v19.4s, v29.8h, v1.8h //r[1]*zeta
    smull  v16.4s, v28.4h, v1.4h //r[0]*zeta
    smull2 v17.4s, v28.8h, v1.8h //r[0]*zeta

    smlal  v22.4s, v4.4h, v11.4h //a0*b3
    smlal2 v23.4s, v4.8h, v11.8h //a0*b3
    smlal  v20.4s, v4.4h, v10.4h //a0*b2
    smlal2 v21.4s, v4.8h, v10.8h //a0*b2
    smlal  v18.4s, v4.4h, v9.4h //a0*b1
    smlal2 v19.4s, v4.8h, v9.8h //a0*b1
    smlal  v16.4s, v4.4h, v8.4h //a0*b0
    smlal2 v17.4s, v4.8h, v8.8h //a0*b0

    smlal  v22.4s, v5.4h, v10.4h //a1*b2
    smlal2 v23.4s, v5.8h, v10.8h //a1*b2
    smlal  v20.4s, v5.4h, v9.4h //a1*b1
    smlal2 v21.4s, v5.8h, v9.8h //a1*b1
    smlal  v18.4s, v5.4h, v8.4h //a1*b0
    smlal2 v19.4s, v5.8h, v8.8h //a1*b0

    smlal  v22.4s, v6.4h, v9.4h //a2*b1
    smlal2 v23.4s, v6.8h, v9.8h //a2*b1
    smlal  v20.4s, v6.4h, v8.4h //a2*b0
    smlal2 v21.4s, v6.8h, v8.8h //a2*b0

    smlal  v16.4s, v12.4h, v0.h[2] //c0*R
    smlal2 v17.4s, v12.8h, v0.h[2] //c0*R
    smlal  v18.4s, v13.4h, v0.h[2] //c1*R
    smlal2 v19.4s, v13.8h, v0.h[2] //c1*R
    smlal  v20.4s, v14.4h, v0.h[2] //c2*R
    smlal2 v21.4s, v14.8h, v0.h[2] //c2*R
    smlal  v22.4s, v15.4h, v0.h[2] //c3*R
    smlal2 v23.4s, v15.8h, v0.h[2] //c3*R

    uzp1 v24.8h, v16.8h, v17.8h
    uzp1 v25.8h, v18.8h, v19.8h
    uzp1 v26.8h, v20.8h, v21.8h
    uzp1 v27.8h, v22.8h, v23.8h

    mul v24.8h, v24.8h, v0.h[1]
    mul v25.8h, v25.8h, v0.h[1]
    mul v26.8h, v26.8h, v0.h[1]
    mul v27.8h, v27.8h, v0.h[1]

    smlal  v16.4s, v24.4h, v0.h[0]
    smlal2 v17.4s, v24.8h, v0.h[0]
    smlal  v18.4s, v25.4h, v0.h[0]
    smlal2 v19.4s, v25.8h, v0.h[0]
    smlal  v20.4s, v26.4h, v0.h[0]
    smlal2 v21.4s, v26.8h, v0.h[0]
    smlal  v22.4s, v27.4h, v0.h[0]
    smlal2 v23.4s, v27.8h, v0.h[0]

    uzp2 v4.8h, v16.8h, v17.8h
    uzp2 v5.8h, v18.8h, v19.8h
    uzp2 v6.8h, v20.8h, v21.8h
    uzp2 v7.8h, v22.8h, v23.8h

    #store
    st1 {v4.8h - v7.8h}, [dst], #64
    
    subs counter, counter, #64
    b.ne _looptop_add

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    zetas_ptr
    .unreq    counter

    ret


.global poly_baseinv
.global _poly_baseinv
poly_baseinv:
_poly_baseinv:
    dst       .req x0
    src       .req x1
    zetas_ptr .req x2
    counter1  .req x8
    counter2  .req x9
    stack_ptr .req x10

    adr zetas_ptr, zetas_mul
    
    ld1 {v0.8h}, [zetas_ptr], #16

    sub sp, sp, #96

    mov counter1, #1536

_looptop_baseinv:

    mov counter2, #384

    mov stack_ptr, sp

_loop_inner1:
    #load
    ld1 {v1.8h, v2.8h}, [zetas_ptr], #32

    #load
    ld1 {v3.8h - v6.8h},   [src], #64
    ld1 {v7.8h - v10.8h},  [src], #64

    neg v26.8h, v6.8h  //-a3
    neg v30.8h, v10.8h //-a3
    neg v27.8h, v5.8h  //-a2
    neg v31.8h, v9.8h  //-a2

    shl v26.8h, v26.8h, #1 //-2*a3
    shl v30.8h, v30.8h, #1 //-2*a3
    shl v27.8h, v27.8h, #1 //-2*a2
    shl v31.8h, v31.8h, #1 //-2*a2

    smull  v11.4s, v5.4h, v5.4h //a2*a2
    smull2 v12.4s, v5.8h, v5.8h //a2*a2
    smull  v13.4s, v9.4h, v9.4h //a2*a2
    smull2 v14.4s, v9.8h, v9.8h //a2*a2

    smull  v15.4s,  v6.4h,  v6.4h //a3*a3
    smull2 v16.4s,  v6.8h,  v6.8h //a3*a3
    smull  v17.4s, v10.4h, v10.4h //a3*a3
    smull2 v18.4s, v10.8h, v10.8h //a3*a3

    smlal  v11.4s, v4.4h, v26.4h //-2*a1*a3
    smlal2 v12.4s, v4.8h, v26.8h //-2*a1*a3
    smlal  v13.4s, v8.4h, v30.4h //-2*a1*a3
    smlal2 v14.4s, v8.8h, v30.8h //-2*a1*a3

    uzp1 v21.8h, v15.8h, v16.8h
    uzp1 v22.8h, v17.8h, v18.8h
    uzp1 v19.8h, v11.8h, v12.8h
    uzp1 v20.8h, v13.8h, v14.8h

    mul v21.8h, v21.8h, v0.h[1]
    mul v22.8h, v22.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    mul v20.8h, v20.8h, v0.h[1]

    smlal  v15.4s, v21.4h, v0.h[0]
    smlal2 v16.4s, v21.8h, v0.h[0]
    smlal  v17.4s, v22.4h, v0.h[0]
    smlal2 v18.4s, v22.8h, v0.h[0]
    smlal  v11.4s, v19.4h, v0.h[0]
    smlal2 v12.4s, v19.8h, v0.h[0]
    smlal  v13.4s, v20.4h, v0.h[0]
    smlal2 v14.4s, v20.8h, v0.h[0]

    uzp2 v25.8h, v15.8h, v16.8h //t1
    uzp2 v29.8h, v17.8h, v18.8h //t1
    uzp2 v24.8h, v11.8h, v12.8h //t0
    uzp2 v28.8h, v13.8h, v14.8h //t0

    smull  v15.4s, v25.4h, v1.4h //t1*zeta
    smull2 v16.4s, v25.8h, v1.8h //t1*zeta
    smull  v17.4s, v29.4h, v2.4h //t1*zeta
    smull2 v18.4s, v29.8h, v2.8h //t1*zeta

    smull  v11.4s, v24.4h, v1.4h //t0*zeta
    smull2 v12.4s, v24.8h, v1.8h //t0*zeta
    smull  v13.4s, v28.4h, v2.4h //t0*zeta
    smull2 v14.4s, v28.8h, v2.8h //t0*zeta

    smlal  v15.4s, v4.4h, v4.4h //a1*a1
    smlal2 v16.4s, v4.8h, v4.8h //a1*a1
    smlal  v17.4s, v8.4h, v8.4h //a1*a1
    smlal2 v18.4s, v8.8h, v8.8h //a1*a1

    smlal  v11.4s, v3.4h, v3.4h //a0*a0
    smlal2 v12.4s, v3.8h, v3.8h //a0*a0
    smlal  v13.4s, v7.4h, v7.4h //a0*a0
    smlal2 v14.4s, v7.8h, v7.8h //a0*a0

    smlal  v15.4s, v3.4h, v27.4h //-2*a0*a2
    smlal2 v16.4s, v3.8h, v27.8h //-2*a0*a2
    smlal  v17.4s, v7.4h, v31.4h //-2*a0*a2
    smlal2 v18.4s, v7.8h, v31.8h //-2*a0*a2

    uzp1 v19.8h, v11.8h, v12.8h
    uzp1 v20.8h, v13.8h, v14.8h
    uzp1 v21.8h, v15.8h, v16.8h
    uzp1 v22.8h, v17.8h, v18.8h

    mul v19.8h, v19.8h, v0.h[1]
    mul v20.8h, v20.8h, v0.h[1]
    mul v21.8h, v21.8h, v0.h[1]
    mul v22.8h, v22.8h, v0.h[1]

    smlal  v11.4s, v19.4h, v0.h[0]
    smlal2 v12.4s, v19.8h, v0.h[0]
    smlal  v13.4s, v20.4h, v0.h[0]
    smlal2 v14.4s, v20.8h, v0.h[0]
    smlal  v15.4s, v21.4h, v0.h[0]
    smlal2 v16.4s, v21.8h, v0.h[0]
    smlal  v17.4s, v22.4h, v0.h[0]
    smlal2 v18.4s, v22.8h, v0.h[0]

    uzp2 v24.8h, v11.8h, v12.8h //t0
    uzp2 v28.8h, v13.8h, v14.8h //t0
    uzp2 v25.8h, v15.8h, v16.8h //t1
    uzp2 v29.8h, v17.8h, v18.8h //t1

    smull  v11.4s, v25.4h, v1.4h //t1*zeta
    smull2 v12.4s, v25.8h, v1.8h //t1*zeta
    smull  v13.4s, v29.4h, v2.4h //t1*zeta
    smull2 v14.4s, v29.8h, v2.8h //t1*zeta

    uzp1 v19.8h, v11.8h, v12.8h
    uzp1 v20.8h, v13.8h, v14.8h

    mul v19.8h, v19.8h, v0.h[1]
    mul v20.8h, v20.8h, v0.h[1]

    smlal  v11.4s, v19.4h, v0.h[0]
    smlal2 v12.4s, v19.8h, v0.h[0]
    smlal  v13.4s, v20.4h, v0.h[0]
    smlal2 v14.4s, v20.8h, v0.h[0]

    uzp2 v26.8h, v11.8h, v12.8h //t2
    uzp2 v30.8h, v13.8h, v14.8h //t2

    neg v27.8h, v25.8h //-t1
    neg v31.8h, v29.8h //-t1

    smull  v11.4s, v24.4h, v24.4h //t0*t0
    smull2 v12.4s, v24.8h, v24.8h //t0*t0
    smull  v13.4s, v28.4h, v28.4h //t0*t0
    smull2 v14.4s, v28.8h, v28.8h //t0*t0

    smlal  v11.4s, v27.4h, v26.4h //-t1*t2
    smlal2 v12.4s, v27.8h, v26.8h //-t1*t2
    smlal  v13.4s, v31.4h, v30.4h //-t1*t2
    smlal2 v14.4s, v31.8h, v30.8h //-t1*t2

    uzp1 v19.8h, v11.8h, v12.8h
    uzp1 v20.8h, v13.8h, v14.8h

    mul v19.8h, v19.8h, v0.h[1]
    mul v20.8h, v20.8h, v0.h[1]

    smlal  v11.4s, v19.4h, v0.h[0]
    smlal2 v12.4s, v19.8h, v0.h[0]
    smlal  v13.4s, v20.4h, v0.h[0]
    smlal2 v14.4s, v20.8h, v0.h[0]

    uzp2 v19.8h, v11.8h, v12.8h //det0
    uzp2 v20.8h, v13.8h, v14.8h //det1

    st1 {v19.8h - v20.8h}, [stack_ptr], #32

    //Inverse test
    umin v18.8h, v19.8h, v20.8h
    uminv h18, v18.8h
    umov w15, v18.h[0]
    cmp w15, #0
    b.eq _loop_notinvertible

    smull  v11.4s, v3.4h, v24.4h //a0*t0
    smull2 v12.4s, v3.8h, v24.8h //a0*t0
    smull  v13.4s, v6.4h, v26.4h //a3*t2
    smull2 v14.4s, v6.8h, v26.8h //a3*t2

    smull  v15.4s, v5.4h, v24.4h //a2*t0
    smull2 v16.4s, v5.8h, v24.8h //a2*t0
    smull  v17.4s, v4.4h, v25.4h //a1*t1
    smull2 v18.4s, v4.8h, v25.8h //a1*t1

    smlal  v11.4s, v5.4h, v26.4h //a2*t2
    smlal2 v12.4s, v5.8h, v26.8h //a2*t2
    smlal  v13.4s, v4.4h, v24.4h //a1*t0
    smlal2 v14.4s, v4.8h, v24.8h //a1*t0
    
    smlal  v15.4s, v3.4h, v25.4h //a0*t1
    smlal2 v16.4s, v3.8h, v25.8h //a0*t1
    smlal  v17.4s, v6.4h, v24.4h //a3*t0
    smlal2 v18.4s, v6.8h, v24.8h //a3*t0

    uzp1 v19.8h, v11.8h, v12.8h
    uzp1 v20.8h, v13.8h, v14.8h
    uzp1 v21.8h, v15.8h, v16.8h
    uzp1 v22.8h, v17.8h, v18.8h

    mul v19.8h, v19.8h, v0.h[1]
    mul v20.8h, v20.8h, v0.h[1]
    mul v21.8h, v21.8h, v0.h[1]
    mul v22.8h, v22.8h, v0.h[1]

    smlal  v11.4s, v19.4h, v0.h[0]
    smlal2 v12.4s, v19.8h, v0.h[0]
    smlal  v13.4s, v20.4h, v0.h[0]
    smlal2 v14.4s, v20.8h, v0.h[0]
    smlal  v15.4s, v21.4h, v0.h[0]
    smlal2 v16.4s, v21.8h, v0.h[0]
    smlal  v17.4s, v22.4h, v0.h[0]
    smlal2 v18.4s, v22.8h, v0.h[0]

    uzp2 v11.8h, v11.8h, v12.8h //r[0]
    uzp2 v12.8h, v13.8h, v14.8h //r[1]
    uzp2 v13.8h, v15.8h, v16.8h //r[2]
    uzp2 v14.8h, v17.8h, v18.8h //r[3]

    str q11, [dst, #0*16]
    str q12, [dst, #1*16]
    str q13, [dst, #2*16]
    str q14, [dst, #3*16]

    smull  v11.4s,  v7.4h, v28.4h //a0*t0
    smull2 v12.4s,  v7.8h, v28.8h //a0*t0   
    smull  v13.4s, v10.4h, v30.4h //a3*t2
    smull2 v14.4s, v10.8h, v30.8h //a3*t2 
    
    smull  v15.4s, v9.4h, v28.4h //a2*t0
    smull2 v16.4s, v9.8h, v28.8h //a2*t0   
    smull  v17.4s, v8.4h, v29.4h //a1*t1
    smull2 v18.4s, v8.8h, v29.8h //a1*t1

    smlal  v11.4s, v9.4h, v30.4h //a2*t2
    smlal2 v12.4s, v9.8h, v30.8h //a2*t2   
    smlal  v13.4s, v8.4h, v28.4h //a1*t0
    smlal2 v14.4s, v8.8h, v28.8h //a1*t0

    smlal  v15.4s,  v7.4h, v29.4h //a0*t1
    smlal2 v16.4s,  v7.8h, v29.8h //a0*t1   
    smlal  v17.4s, v10.4h, v28.4h //a3*t0
    smlal2 v18.4s, v10.8h, v28.8h //a3*t0

    uzp1 v19.8h, v11.8h, v12.8h
    uzp1 v20.8h, v13.8h, v14.8h
    uzp1 v21.8h, v15.8h, v16.8h
    uzp1 v22.8h, v17.8h, v18.8h

    mul v19.8h, v19.8h, v0.h[1]
    mul v20.8h, v20.8h, v0.h[1]
    mul v21.8h, v21.8h, v0.h[1]
    mul v22.8h, v22.8h, v0.h[1]

    smlal  v11.4s, v19.4h, v0.h[0]
    smlal2 v12.4s, v19.8h, v0.h[0]
    smlal  v13.4s, v20.4h, v0.h[0]
    smlal2 v14.4s, v20.8h, v0.h[0]
    smlal  v15.4s, v21.4h, v0.h[0]
    smlal2 v16.4s, v21.8h, v0.h[0]
    smlal  v17.4s, v22.4h, v0.h[0]
    smlal2 v18.4s, v22.8h, v0.h[0]

    uzp2 v11.8h, v11.8h, v12.8h //r[0]
    uzp2 v12.8h, v13.8h, v14.8h //r[1]
    uzp2 v13.8h, v15.8h, v16.8h //r[2]
    uzp2 v14.8h, v17.8h, v18.8h //r[3]

    str q11, [dst, #4*16]
    str q12, [dst, #5*16]
    str q13, [dst, #6*16]
    str q14, [dst, #7*16]

    add dst, dst, #128
    subs counter2, counter2, #128
    b.ne _loop_inner1


    subs dst, dst, #384
    mov stack_ptr, sp
    mov counter2, #384

_loop_inner2:
    ld1 {v29.8h - v31.8h}, [stack_ptr], #48

    //Inverse
    //t1 = fqmul(a, a);    //10
    smull  v11.4s, v29.4h, v29.4h
    smull2 v12.4s, v29.8h, v29.8h
    smull  v13.4s, v30.4h, v30.4h
    smull2 v14.4s, v30.8h, v30.8h
    smull  v15.4s, v31.4h, v31.4h
    smull2 v16.4s, v31.8h, v31.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v20.8h, v11.8h, v12.8h //t1
    uzp2 v21.8h, v13.8h, v14.8h //t1
    uzp2 v22.8h, v15.8h, v16.8h //t1

    //t2 = fqmul(t1, t1);  //100
    smull  v11.4s, v20.4h, v20.4h
    smull2 v12.4s, v20.8h, v20.8h
    smull  v13.4s, v21.4h, v21.4h
    smull2 v14.4s, v21.8h, v21.8h
    smull  v15.4s, v22.4h, v22.4h
    smull2 v16.4s, v22.8h, v22.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t2 = fqmul(t2, t2);  //1000
    smull  v11.4s, v23.4h, v23.4h
    smull2 v12.4s, v23.8h, v23.8h
    smull  v13.4s, v24.4h, v24.4h
    smull2 v14.4s, v24.8h, v24.8h
    smull  v15.4s, v25.4h, v25.4h
    smull2 v16.4s, v25.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t3 = fqmul(t2, t2);  //10000
    smull  v11.4s, v23.4h, v23.4h
    smull2 v12.4s, v23.8h, v23.8h
    smull  v13.4s, v24.4h, v24.4h
    smull2 v14.4s, v24.8h, v24.8h
    smull  v15.4s, v25.4h, v25.4h
    smull2 v16.4s, v25.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v26.8h, v11.8h, v12.8h //t3
    uzp2 v27.8h, v13.8h, v14.8h //t3
    uzp2 v28.8h, v15.8h, v16.8h //t3

    //t1 = fqmul(t1, t2);  //1010
    smull  v11.4s, v20.4h, v23.4h
    smull2 v12.4s, v20.8h, v23.8h
    smull  v13.4s, v21.4h, v24.4h
    smull2 v14.4s, v21.8h, v24.8h
    smull  v15.4s, v22.4h, v25.4h
    smull2 v16.4s, v22.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v20.8h, v11.8h, v12.8h //t1
    uzp2 v21.8h, v13.8h, v14.8h //t1
    uzp2 v22.8h, v15.8h, v16.8h //t1
    
    //t2 = fqmul(t1, t3);  //11010
    smull  v11.4s, v20.4h, v26.4h
    smull2 v12.4s, v20.8h, v26.8h
    smull  v13.4s, v21.4h, v27.4h
    smull2 v14.4s, v21.8h, v27.8h
    smull  v15.4s, v22.4h, v28.4h
    smull2 v16.4s, v22.8h, v28.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t2 = fqmul(t2, t2);  //110100
    smull  v11.4s, v23.4h, v23.4h
    smull2 v12.4s, v23.8h, v23.8h
    smull  v13.4s, v24.4h, v24.4h
    smull2 v14.4s, v24.8h, v24.8h
    smull  v15.4s, v25.4h, v25.4h
    smull2 v16.4s, v25.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t2 = fqmul(t2, a);   //110101
    smull  v11.4s, v23.4h, v29.4h
    smull2 v12.4s, v23.8h, v29.8h
    smull  v13.4s, v24.4h, v30.4h
    smull2 v14.4s, v24.8h, v30.8h
    smull  v15.4s, v25.4h, v31.4h
    smull2 v16.4s, v25.8h, v31.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t1 = fqmul(t1, t2);  //111111
    smull  v11.4s, v20.4h, v23.4h
    smull2 v12.4s, v20.8h, v23.8h
    smull  v13.4s, v21.4h, v24.4h
    smull2 v14.4s, v21.8h, v24.8h
    smull  v15.4s, v22.4h, v25.4h
    smull2 v16.4s, v22.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v20.8h, v11.8h, v12.8h //t1
    uzp2 v21.8h, v13.8h, v14.8h //t1
    uzp2 v22.8h, v15.8h, v16.8h //t1

    //t2 = fqmul(t2, t2);  //1101010
    smull  v11.4s, v23.4h, v23.4h
    smull2 v12.4s, v23.8h, v23.8h
    smull  v13.4s, v24.4h, v24.4h
    smull2 v14.4s, v24.8h, v24.8h
    smull  v15.4s, v25.4h, v25.4h
    smull2 v16.4s, v25.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t2 = fqmul(t2, t2);  //11010100
    smull  v11.4s, v23.4h, v23.4h
    smull2 v12.4s, v23.8h, v23.8h
    smull  v13.4s, v24.4h, v24.4h
    smull2 v14.4s, v24.8h, v24.8h
    smull  v15.4s, v25.4h, v25.4h
    smull2 v16.4s, v25.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t2 = fqmul(t2, t2);  //110101000
    smull  v11.4s, v23.4h, v23.4h
    smull2 v12.4s, v23.8h, v23.8h
    smull  v13.4s, v24.4h, v24.4h
    smull2 v14.4s, v24.8h, v24.8h
    smull  v15.4s, v25.4h, v25.4h
    smull2 v16.4s, v25.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t2 = fqmul(t2, t2);  //1101010000
    smull  v11.4s, v23.4h, v23.4h
    smull2 v12.4s, v23.8h, v23.8h
    smull  v13.4s, v24.4h, v24.4h
    smull2 v14.4s, v24.8h, v24.8h
    smull  v15.4s, v25.4h, v25.4h
    smull2 v16.4s, v25.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t2 = fqmul(t2, t2);  //11010100000
    smull  v11.4s, v23.4h, v23.4h
    smull2 v12.4s, v23.8h, v23.8h
    smull  v13.4s, v24.4h, v24.4h
    smull2 v14.4s, v24.8h, v24.8h
    smull  v15.4s, v25.4h, v25.4h
    smull2 v16.4s, v25.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t2 = fqmul(t2, t2);  //110101000000
    smull  v11.4s, v23.4h, v23.4h
    smull2 v12.4s, v23.8h, v23.8h
    smull  v13.4s, v24.4h, v24.4h
    smull2 v14.4s, v24.8h, v24.8h
    smull  v15.4s, v25.4h, v25.4h
    smull2 v16.4s, v25.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v23.8h, v11.8h, v12.8h //t2
    uzp2 v24.8h, v13.8h, v14.8h //t2
    uzp2 v25.8h, v15.8h, v16.8h //t2

    //t2 = fqmul(t1, t2);  //110101111111
    smull  v11.4s, v20.4h, v23.4h
    smull2 v12.4s, v20.8h, v23.8h
    smull  v13.4s, v21.4h, v24.4h
    smull2 v14.4s, v21.8h, v24.8h
    smull  v15.4s, v22.4h, v25.4h
    smull2 v16.4s, v22.8h, v25.8h

    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h
    uzp1 v19.8h, v15.8h, v16.8h

    mul v17.8h, v17.8h, v0.h[1]    
    mul v18.8h, v18.8h, v0.h[1]
    mul v19.8h, v19.8h, v0.h[1]
    
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]
    smlal  v15.4s, v19.4h, v0.h[0]
    smlal2 v16.4s, v19.8h, v0.h[0]

    uzp2 v29.8h, v11.8h, v12.8h //det0
    uzp2 v30.8h, v13.8h, v14.8h //det1
    uzp2 v31.8h, v15.8h, v16.8h //det2

    neg v26.8h, v29.8h //-det0
    neg v27.8h, v30.8h //-det0
    neg v28.8h, v31.8h //-det0

    ld1 {v3.8h - v6.8h},  [dst]

    smull   v7.4s, v3.4h, v29.4h //r[0]*det0
    smull2  v8.4s, v3.8h, v29.8h //r[0]*det0
    smull   v9.4s, v4.4h, v26.4h //-r[1]*det0
    smull2 v10.4s, v4.8h, v26.8h //-r[1]*det0
    smull  v11.4s, v5.4h, v29.4h //r[2]*det0
    smull2 v12.4s, v5.8h, v29.8h //r[2]*det0
    smull  v13.4s, v6.4h, v26.4h //-r[3]*det0
    smull2 v14.4s, v6.8h, v26.8h //-r[3]*det0

    uzp1 v15.8h,  v7.8h, v8.8h
    uzp1 v16.8h,  v9.8h, v10.8h
    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]
    mul v16.8h, v16.8h, v0.h[1]
    mul v17.8h, v17.8h, v0.h[1]
    mul v18.8h, v18.8h, v0.h[1]

    smlal   v7.4s, v15.4h, v0.h[0]
    smlal2  v8.4s, v15.8h, v0.h[0]
    smlal   v9.4s, v16.4h, v0.h[0]
    smlal2 v10.4s, v16.8h, v0.h[0]
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]

    uzp2 v3.8h,  v7.8h,  v8.8h
    uzp2 v4.8h,  v9.8h, v10.8h
    uzp2 v5.8h, v11.8h, v12.8h
    uzp2 v6.8h, v13.8h, v14.8h

    st1 {v3.8h - v6.8h},  [dst], #64

    ld1 {v3.8h - v6.8h},  [dst]

    smull   v7.4s, v3.4h, v30.4h //r[0]*det1
    smull2  v8.4s, v3.8h, v30.8h //r[0]*det1
    smull   v9.4s, v4.4h, v27.4h //-r[1]*det1
    smull2 v10.4s, v4.8h, v27.8h //-r[1]*det1
    smull  v11.4s, v5.4h, v30.4h //r[2]*det1
    smull2 v12.4s, v5.8h, v30.8h //r[2]*det1
    smull  v13.4s, v6.4h, v27.4h //-r[3]*det1
    smull2 v14.4s, v6.8h, v27.8h //-r[3]*det1

    uzp1 v15.8h,  v7.8h, v8.8h
    uzp1 v16.8h,  v9.8h, v10.8h
    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]
    mul v16.8h, v16.8h, v0.h[1]
    mul v17.8h, v17.8h, v0.h[1]
    mul v18.8h, v18.8h, v0.h[1]

    smlal   v7.4s, v15.4h, v0.h[0]
    smlal2  v8.4s, v15.8h, v0.h[0]
    smlal   v9.4s, v16.4h, v0.h[0]
    smlal2 v10.4s, v16.8h, v0.h[0]
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]

    uzp2 v3.8h,  v7.8h,  v8.8h
    uzp2 v4.8h,  v9.8h, v10.8h
    uzp2 v5.8h, v11.8h, v12.8h
    uzp2 v6.8h, v13.8h, v14.8h

    st1 {v3.8h - v6.8h},  [dst], #64
    
    ld1 {v3.8h - v6.8h},  [dst]

    smull   v7.4s, v3.4h, v31.4h //r[0]*det0
    smull2  v8.4s, v3.8h, v31.8h //r[0]*det0
    smull   v9.4s, v4.4h, v28.4h //-r[1]*det0
    smull2 v10.4s, v4.8h, v28.8h //-r[1]*det0
    smull  v11.4s, v5.4h, v31.4h //r[2]*det0
    smull2 v12.4s, v5.8h, v31.8h //r[2]*det0
    smull  v13.4s, v6.4h, v28.4h //-r[3]*det0
    smull2 v14.4s, v6.8h, v28.8h //-r[3]*det0

    uzp1 v15.8h,  v7.8h, v8.8h
    uzp1 v16.8h,  v9.8h, v10.8h
    uzp1 v17.8h, v11.8h, v12.8h
    uzp1 v18.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]
    mul v16.8h, v16.8h, v0.h[1]
    mul v17.8h, v17.8h, v0.h[1]
    mul v18.8h, v18.8h, v0.h[1]

    smlal   v7.4s, v15.4h, v0.h[0]
    smlal2  v8.4s, v15.8h, v0.h[0]
    smlal   v9.4s, v16.4h, v0.h[0]
    smlal2 v10.4s, v16.8h, v0.h[0]
    smlal  v11.4s, v17.4h, v0.h[0]
    smlal2 v12.4s, v17.8h, v0.h[0]
    smlal  v13.4s, v18.4h, v0.h[0]
    smlal2 v14.4s, v18.8h, v0.h[0]

    uzp2 v3.8h,  v7.8h,  v8.8h
    uzp2 v4.8h,  v9.8h, v10.8h
    uzp2 v5.8h, v11.8h, v12.8h
    uzp2 v6.8h, v13.8h, v14.8h

    st1 {v3.8h - v6.8h},  [dst], #64

    subs counter2, counter2, #192
    b.ne _loop_inner2

    subs counter1, counter1, #384
    b.ne _looptop_baseinv

    eor v0.16b, v0.16b, v0.16b

    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16

    eor x0, x0, x0

    ret

    .unreq    dst
    .unreq    src
    .unreq    zetas_ptr
    .unreq    counter1
    .unreq    counter2

_loop_notinvertible:

    eor v0.16b, v0.16b, v0.16b
    
    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16
    st1 {v0.8h}, [sp], #16

    mov x0, #1

    ret


.align 4
zetas_mul:
    .hword 0x0d81, 0xcd7f, 0xff6d, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x00df, 0x0472, 0xfbdd, 0xfe73, 0xff49, 0x0677, 0x022f, 0xf976
    .hword 0xff21, 0xfb8e, 0x0423, 0x018d, 0x00b7, 0xf989, 0xfdd1, 0x068a
    .hword 0x0115, 0x03a5, 0x06bb, 0x01b5, 0xfa16, 0x00f2, 0x0668, 0x01b0
    .hword 0xfeeb, 0xfc5b, 0xf945, 0xfe4b, 0x05ea, 0xff0e, 0xf998, 0xfe50
    .hword 0xf9d1, 0x02b8, 0x0306, 0x0687, 0x039f, 0x0202, 0x0200, 0x01e9
    .hword 0x062f, 0xfd48, 0xfcfa, 0xf979, 0xfc61, 0xfdfe, 0xfe00, 0xfe17
    .hword 0x0129, 0x0259, 0x05c1, 0x046a, 0x052a, 0x0367, 0x02f8, 0x04bc
    .hword 0xfed7, 0xfda7, 0xfa3f, 0xfb96, 0xfad6, 0xfc99, 0xfd08, 0xfb44
    .hword 0xfec8, 0xfea0, 0x01bb, 0x03af, 0x0008, 0x04e2, 0xff9c, 0x067c
    .hword 0x0138, 0x0160, 0xfe45, 0xfc51, 0xfff8, 0xfb1e, 0x0064, 0xf984
    .hword 0xffe1, 0x04b6, 0xfac3, 0xfb21, 0x01bc, 0x00eb, 0x0554, 0xfb47
    .hword 0x001f, 0xfb4a, 0x053d, 0x04df, 0xfe44, 0xff15, 0xfaac, 0x04b9
    .hword 0x0169, 0x00e6, 0x02a1, 0x0246, 0x0581, 0x05dd, 0x0579, 0x00fb
    .hword 0xfe97, 0xff1a, 0xfd5f, 0xfdba, 0xfa7f, 0xfa23, 0xfa87, 0xff05
    .hword 0x03fe, 0xfbd9, 0x041d, 0x04a4, 0x01a1, 0xfa91, 0xffe5, 0xf9a6
    .hword 0xfc02, 0x0427, 0xfbe3, 0xfb5c, 0xfe5f, 0x056f, 0x001b, 0x065a
    .hword 0x0695, 0xfec5, 0x0580, 0xfb20, 0x0190, 0x0112, 0xf9f9, 0x0020
    .hword 0xf96b, 0x013b, 0xfa80, 0x04e0, 0xfe70, 0xfeee, 0x0607, 0xffe0
    .hword 0xf9f2, 0x05fb, 0xfaa9, 0xff84, 0x05b2, 0x0563, 0xfc54, 0xf96f
    .hword 0x060e, 0xfa05, 0x0557, 0x007c, 0xfa4e, 0xfa9d, 0x03ac, 0x0691
    .hword 0x0016, 0x06ad, 0xfeed, 0x0454, 0x0162, 0xf940, 0xfc38, 0x035a
    .hword 0xffea, 0xf953, 0x0113, 0xfbac, 0xfe9e, 0x06c0, 0x03c8, 0xfca6
    .hword 0x04c5, 0xff26, 0x0126, 0xfd24, 0xfbb9, 0x037c, 0x0634, 0xfcf5
    .hword 0xfb3b, 0x00da, 0xfeda, 0x02dc, 0x0447, 0xfc84, 0xf9cc, 0x030b
