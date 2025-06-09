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

    ld1  {v0.8h}, [zetas_ptr], #16

    mov counter, #1152

_looptop:
    #load
    ld1  {v1.8h}, [zetas_ptr], #16

    #load
    ld1 {v4.8h - v7.8h},  [src1], #64
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

    mov counter, #1152

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

    mov counter1, #1152

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

    st1 {v11.8h - v14.8h}, [dst], #64

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

    st1 {v11.8h - v14.8h}, [dst], #64

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
    .hword 0xfa00, 0x05bb, 0xfd5c, 0xf9fa, 0xff56, 0x027b, 0xfd3f, 0xfacc
    .hword 0x0600, 0xfa45, 0x02a4, 0x0606, 0x00aa, 0xfd85, 0x02c1, 0x0534
    .hword 0xfd6e, 0x033f, 0xf950, 0x051f, 0x05d0, 0xfc8f, 0x043f, 0xfadd
    .hword 0x0292, 0xfcc1, 0x06b0, 0xfae1, 0xfa30, 0x0371, 0xfbc1, 0x0523
    .hword 0x04dd, 0xffb5, 0x0317, 0xfffa, 0xfc95, 0xfd47, 0xffba, 0xfb76
    .hword 0xfb23, 0x004b, 0xfce9, 0x0006, 0x036b, 0x02b9, 0x0046, 0x048a
    .hword 0x011f, 0xfd01, 0xfc4f, 0x063e, 0xfc8e, 0x04ed, 0x00ce, 0x028e
    .hword 0xfee1, 0x02ff, 0x03b1, 0xf9c2, 0x0372, 0xfb13, 0xff32, 0xfd72
    .hword 0xfa73, 0xffaf, 0x02cc, 0xfb1d, 0x0346, 0xfaec, 0x040b, 0xff98
    .hword 0x058d, 0x0051, 0xfd34, 0x04e3, 0xfcba, 0x0514, 0xfbf5, 0x0068
    .hword 0x03c6, 0xfdd2, 0xffc3, 0xf958, 0x0194, 0xfc7d, 0x035e, 0xf9c7
    .hword 0xfc3a, 0x022e, 0x003d, 0x06a8, 0xfe6c, 0x0383, 0xfca2, 0x0639
    .hword 0xfa4c, 0xffdb, 0x04f2, 0x03c5, 0xf9d0, 0xfa84, 0xfef7, 0xfc52
    .hword 0x05b4, 0x0025, 0xfb0e, 0xfc3b, 0x0630, 0x057c, 0x0109, 0x03ae
    .hword 0x0389, 0x04ab, 0xfd95, 0x0313, 0x0076, 0x0240, 0x011e, 0xfa3d
    .hword 0xfc77, 0xfb55, 0x026b, 0xfced, 0xff8a, 0xfdc0, 0xfee2, 0x05c3
    .hword 0xff3e, 0x03a0, 0x04cd, 0xfbf8, 0x0648, 0x0457, 0xf97b, 0x0282
    .hword 0x00c2, 0xfc60, 0xfb33, 0x0408, 0xf9b8, 0xfba9, 0x0685, 0xfd7e
