.global poly_baseinv_asm
.global _poly_baseinv_asm
poly_baseinv_asm:
_poly_baseinv_asm:
    dst     .req x0
    src     .req x1
    table   .req x2
    counter .req x8

    add counter, dst, #1728

    ld1 {v0.8h}, [table], #16

_looptop_baseinv:
    #load
    ld1 {v1.8h, v2.8h}, [table], #32

    #load
    ld1 {v3.8h, v4.8h, v5.8h}, [src], #48
    ld1 {v6.8h, v7.8h, v8.8h}, [src], #48

    neg v30.8h, v3.8h //-a0
    neg v31.8h, v6.8h //-a0

    smull   v9.4s, v4.4h, v5.4h //a1*a2
    smull2 v10.4s, v4.8h, v5.8h //a1*a2
    smull  v11.4s, v7.4h, v8.4h //a1*a2
    smull2 v12.4s, v7.8h, v8.8h //a1*a2

    smull  v13.4s, v5.4h, v5.4h //a2*a2
    smull2 v14.4s, v5.8h, v5.8h //a2*a2
    smull  v15.4s, v8.4h, v8.4h //a2*a2
    smull2 v16.4s, v8.8h, v8.8h //a2*a2

    smull  v17.4s, v4.4h, v4.4h //a1*a1
    smull2 v18.4s, v4.8h, v4.8h //a1*a1
    smull  v19.4s, v7.4h, v7.4h //a1*a1
    smull2 v20.4s, v7.8h, v7.8h //a1*a1

    smlal  v17.4s, v30.4h, v5.4h //-a0*a2
    smlal2 v18.4s, v30.8h, v5.8h //-a0*a2
    smlal  v19.4s, v31.4h, v8.4h //-a0*a2
    smlal2 v20.4s, v31.8h, v8.8h //-a0*a2

    uzp1 v24.8h,  v9.8h, v10.8h
    uzp1 v25.8h, v11.8h, v12.8h
    uzp1 v26.8h, v13.8h, v14.8h
    uzp1 v27.8h, v15.8h, v16.8h
    uzp1 v28.8h, v17.8h, v18.8h
    uzp1 v29.8h, v19.8h, v20.8h

    mul v24.8h, v24.8h, v0.h[1]
    mul v25.8h, v25.8h, v0.h[1]
    mul v26.8h, v26.8h, v0.h[1]
    mul v27.8h, v27.8h, v0.h[1]
    mul v28.8h, v28.8h, v0.h[1]
    mul v29.8h, v29.8h, v0.h[1]

    smlal   v9.4s, v24.4h, v0.h[0]
    smlal2 v10.4s, v24.8h, v0.h[0]
    smlal  v11.4s, v25.4h, v0.h[0]
    smlal2 v12.4s, v25.8h, v0.h[0]
    smlal  v13.4s, v26.4h, v0.h[0]
    smlal2 v14.4s, v26.8h, v0.h[0]
    smlal  v15.4s, v27.4h, v0.h[0]
    smlal2 v16.4s, v27.8h, v0.h[0]
    smlal  v17.4s, v28.4h, v0.h[0]
    smlal2 v18.4s, v28.8h, v0.h[0]
    smlal  v19.4s, v29.4h, v0.h[0]
    smlal2 v20.4s, v29.8h, v0.h[0]

    uzp2 v24.8h,  v9.8h, v10.8h
    uzp2 v25.8h, v11.8h, v12.8h
    uzp2 v26.8h, v13.8h, v14.8h
    uzp2 v27.8h, v15.8h, v16.8h
    uzp2 v28.8h, v17.8h, v18.8h
    uzp2 v29.8h, v19.8h, v20.8h

    smull   v9.4s, v3.4h, v3.4h //a0*a0
    smull2 v10.4s, v3.8h, v3.8h //a0*a0
    smull  v11.4s, v6.4h, v6.4h //a0*a0
    smull2 v12.4s, v6.8h, v6.8h //a0*a0

    smlal   v9.4s, v24.4h, v2.4h //-r[0]*zeta
    smlal2 v10.4s, v24.8h, v2.8h //-r[0]*zeta
    smlal  v11.4s, v25.4h, v1.4h //-r[0]*zeta
    smlal2 v12.4s, v25.8h, v1.8h //-r[0]*zeta

    smull  v13.4s, v26.4h, v1.4h //r[1]*zeta
    smull2 v14.4s, v26.8h, v1.8h //r[1]*zeta
    smull  v15.4s, v27.4h, v2.4h //r[1]*zeta
    smull2 v16.4s, v27.8h, v2.8h //r[1]*zeta

    smlal  v13.4s, v30.4h, v4.4h //-a0*a1
    smlal2 v14.4s, v30.8h, v4.8h //-a0*a1
    smlal  v15.4s, v31.4h, v7.4h //-a0*a1
    smlal2 v16.4s, v31.8h, v7.8h //-a0*a1

    uzp1 v24.8h,  v9.8h, v10.8h
    uzp1 v25.8h, v11.8h, v12.8h
    uzp1 v26.8h, v13.8h, v14.8h
    uzp1 v27.8h, v15.8h, v16.8h

    mul v24.8h, v24.8h, v0.h[1]
    mul v25.8h, v25.8h, v0.h[1]
    mul v26.8h, v26.8h, v0.h[1]
    mul v27.8h, v27.8h, v0.h[1]

    smlal   v9.4s, v24.4h, v0.h[0]
    smlal2 v10.4s, v24.8h, v0.h[0]
    smlal  v11.4s, v25.4h, v0.h[0]
    smlal2 v12.4s, v25.8h, v0.h[0]
    smlal  v13.4s, v26.4h, v0.h[0]
    smlal2 v14.4s, v26.8h, v0.h[0]
    smlal  v15.4s, v27.4h, v0.h[0]
    smlal2 v16.4s, v27.8h, v0.h[0]

    uzp2 v24.8h,  v9.8h, v10.8h
    uzp2 v25.8h, v11.8h, v12.8h
    uzp2 v26.8h, v13.8h, v14.8h
    uzp2 v27.8h, v15.8h, v16.8h

    smull   v9.4s, v28.4h, v4.4h //r[2]*a1
    smull2 v10.4s, v28.8h, v4.8h //r[2]*a1
    smull  v11.4s, v29.4h, v7.4h //r[2]*a1
    smull2 v12.4s, v29.8h, v7.8h //r[2]*a1

    smlal   v9.4s, v26.4h, v5.4h //r[1]*a2
    smlal2 v10.4s, v26.8h, v5.8h //r[1]*a2
    smlal  v11.4s, v27.4h, v8.4h //r[1]*a2
    smlal2 v12.4s, v27.8h, v8.8h //r[1]*a2

    uzp1 v30.8h,  v9.8h, v10.8h
    uzp1 v31.8h, v11.8h, v12.8h

    mul v30.8h, v30.8h, v0.h[1]
    mul v31.8h, v31.8h, v0.h[1]

    smlal   v9.4s, v30.4h, v0.h[0]
    smlal2 v10.4s, v30.8h, v0.h[0]
    smlal  v11.4s, v31.4h, v0.h[0]
    smlal2 v12.4s, v31.8h, v0.h[0]

    uzp2 v30.8h,  v9.8h, v10.8h
    uzp2 v31.8h, v11.8h, v12.8h

    smull   v9.4s, v30.4h, v1.4h //det*zeta
    smull2 v10.4s, v30.8h, v1.8h //det*zeta
    smull  v11.4s, v31.4h, v2.4h //det*zeta
    smull2 v12.4s, v31.8h, v2.8h //det*zeta

    smlal   v9.4s, v24.4h, v3.4h //r[0]*a[0]
    smlal2 v10.4s, v24.8h, v3.8h //r[0]*a[0]
    smlal  v11.4s, v25.4h, v6.4h //r[0]*a[0]
    smlal2 v12.4s, v25.8h, v6.8h //r[0]*a[0]

    uzp1 v13.8h,  v9.8h, v10.8h
    uzp1 v14.8h, v11.8h, v12.8h

    mul v13.8h, v13.8h, v0.h[1]
    mul v14.8h, v14.8h, v0.h[1]

    smlal   v9.4s, v13.4h, v0.h[0]
    smlal2 v10.4s, v13.8h, v0.h[0]
    smlal  v11.4s, v14.4h, v0.h[0]
    smlal2 v12.4s, v14.8h, v0.h[0]

    uzp2 v30.8h,  v9.8h, v10.8h
    uzp2 v31.8h, v11.8h, v12.8h

    //Inverse test
    uminv h11, v30.8h
    uminv h12, v31.8h
    umov  w3, v11.h[0]
    umov  w4, v12.h[0]
    cbz   w3, _loop_notinvertible
    cbz   w4, _loop_notinvertible

    //Inverse
    //t1 = fqmul(a, a);    //10
    smull  v3.4s, v30.4h, v30.4h
    smull2 v4.4s, v30.8h, v30.8h
    smull  v5.4s, v31.4h, v31.4h
    smull2 v6.4s, v31.8h, v31.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v18.8h, v3.8h, v4.8h //t1
    uzp2 v19.8h, v5.8h, v6.8h //t1

    //t2 = fqmul(t1, t1);  //100
    smull  v3.4s, v18.4h, v18.4h
    smull2 v4.4s, v18.8h, v18.8h
    smull  v5.4s, v19.4h, v19.4h
    smull2 v6.4s, v19.8h, v19.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t2 = fqmul(t2, t2);  //1000
    smull  v3.4s, v20.4h, v20.4h
    smull2 v4.4s, v20.8h, v20.8h
    smull  v5.4s, v21.4h, v21.4h
    smull2 v6.4s, v21.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t3 = fqmul(t2, t2);  //10000
    smull  v3.4s, v20.4h, v20.4h
    smull2 v4.4s, v20.8h, v20.8h
    smull  v5.4s, v21.4h, v21.4h
    smull2 v6.4s, v21.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v22.8h, v3.8h, v4.8h //t3
    uzp2 v23.8h, v5.8h, v6.8h //t3

    //t1 = fqmul(t1, t2);  //1010
    smull  v3.4s, v18.4h, v20.4h
    smull2 v4.4s, v18.8h, v20.8h
    smull  v5.4s, v19.4h, v21.4h
    smull2 v6.4s, v19.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v18.8h, v3.8h, v4.8h //t1
    uzp2 v19.8h, v5.8h, v6.8h //t1
    
    //t2 = fqmul(t1, t3);  //11010
    smull  v3.4s, v18.4h, v22.4h
    smull2 v4.4s, v18.8h, v22.8h
    smull  v5.4s, v19.4h, v23.4h
    smull2 v6.4s, v19.8h, v23.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t2 = fqmul(t2, t2);  //110100
    smull  v3.4s, v20.4h, v20.4h
    smull2 v4.4s, v20.8h, v20.8h
    smull  v5.4s, v21.4h, v21.4h
    smull2 v6.4s, v21.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t2 = fqmul(t2, a);   //110101
    smull  v3.4s, v20.4h, v30.4h
    smull2 v4.4s, v20.8h, v30.8h
    smull  v5.4s, v21.4h, v31.4h
    smull2 v6.4s, v21.8h, v31.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t1 = fqmul(t1, t2);  //111111
    smull  v3.4s, v18.4h, v20.4h
    smull2 v4.4s, v18.8h, v20.8h
    smull  v5.4s, v19.4h, v21.4h
    smull2 v6.4s, v19.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v18.8h, v3.8h, v4.8h //t1
    uzp2 v19.8h, v5.8h, v6.8h //t1

    //t2 = fqmul(t2, t2);  //1101010
    smull  v3.4s, v20.4h, v20.4h
    smull2 v4.4s, v20.8h, v20.8h
    smull  v5.4s, v21.4h, v21.4h
    smull2 v6.4s, v21.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t2 = fqmul(t2, t2);  //11010100
    smull  v3.4s, v20.4h, v20.4h
    smull2 v4.4s, v20.8h, v20.8h
    smull  v5.4s, v21.4h, v21.4h
    smull2 v6.4s, v21.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t2 = fqmul(t2, t2);  //110101000
    smull  v3.4s, v20.4h, v20.4h
    smull2 v4.4s, v20.8h, v20.8h
    smull  v5.4s, v21.4h, v21.4h
    smull2 v6.4s, v21.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t2 = fqmul(t2, t2);  //1101010000
    smull  v3.4s, v20.4h, v20.4h
    smull2 v4.4s, v20.8h, v20.8h
    smull  v5.4s, v21.4h, v21.4h
    smull2 v6.4s, v21.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t2 = fqmul(t2, t2);  //11010100000
    smull  v3.4s, v20.4h, v20.4h
    smull2 v4.4s, v20.8h, v20.8h
    smull  v5.4s, v21.4h, v21.4h
    smull2 v6.4s, v21.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t2 = fqmul(t2, t2);  //110101000000
    smull  v3.4s, v20.4h, v20.4h
    smull2 v4.4s, v20.8h, v20.8h
    smull  v5.4s, v21.4h, v21.4h
    smull2 v6.4s, v21.8h, v21.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v20.8h, v3.8h, v4.8h //t2
    uzp2 v21.8h, v5.8h, v6.8h //t2

    //t2 = fqmul(t2, t1);  //110101111111
    smull  v3.4s, v20.4h, v18.4h
    smull2 v4.4s, v20.8h, v18.8h
    smull  v5.4s, v21.4h, v19.4h
    smull2 v6.4s, v21.8h, v19.8h

    uzp1 v7.8h, v3.8h, v4.8h    
    uzp1 v8.8h, v5.8h, v6.8h

    mul v7.8h, v7.8h, v0.h[1]    
    mul v8.8h, v8.8h, v0.h[1]

    smlal  v3.4s, v7.4h, v0.h[0]
    smlal2 v4.4s, v7.8h, v0.h[0]
    smlal  v5.4s, v8.4h, v0.h[0]
    smlal2 v6.4s, v8.8h, v0.h[0]

    uzp2 v30.8h, v3.8h, v4.8h //t2
    uzp2 v31.8h, v5.8h, v6.8h //t2
    
    //mul
    smull   v9.4s, v24.4h, v30.4h //r[0]*det
    smull2 v10.4s, v24.8h, v30.8h //r[0]*det
    smull  v11.4s, v25.4h, v31.4h //r[0]*det
    smull2 v12.4s, v25.8h, v31.8h //r[0]*det

    smull  v13.4s, v26.4h, v30.4h //r[1]*det
    smull2 v14.4s, v26.8h, v30.8h //r[1]*det
    smull  v15.4s, v27.4h, v31.4h //r[1]*det
    smull2 v16.4s, v27.8h, v31.8h //r[1]*det

    smull  v17.4s, v28.4h, v30.4h //r[2]*det
    smull2 v18.4s, v28.8h, v30.8h //r[2]*det
    smull  v19.4s, v29.4h, v31.4h //r[2]*det
    smull2 v20.4s, v29.8h, v31.8h //r[2]*det

    uzp1 v24.8h,  v9.8h, v10.8h
    uzp1 v25.8h, v11.8h, v12.8h
    uzp1 v26.8h, v13.8h, v14.8h
    uzp1 v27.8h, v15.8h, v16.8h
    uzp1 v28.8h, v17.8h, v18.8h
    uzp1 v29.8h, v19.8h, v20.8h

    mul v24.8h, v24.8h, v0.h[1]
    mul v25.8h, v25.8h, v0.h[1]
    mul v26.8h, v26.8h, v0.h[1]
    mul v27.8h, v27.8h, v0.h[1]
    mul v28.8h, v28.8h, v0.h[1]
    mul v29.8h, v29.8h, v0.h[1]

    smlal   v9.4s, v24.4h, v0.h[0]
    smlal2 v10.4s, v24.8h, v0.h[0]
    smlal  v11.4s, v25.4h, v0.h[0]
    smlal2 v12.4s, v25.8h, v0.h[0]
    smlal  v13.4s, v26.4h, v0.h[0]
    smlal2 v14.4s, v26.8h, v0.h[0]
    smlal  v15.4s, v27.4h, v0.h[0]
    smlal2 v16.4s, v27.8h, v0.h[0]
    smlal  v17.4s, v28.4h, v0.h[0]
    smlal2 v18.4s, v28.8h, v0.h[0]
    smlal  v19.4s, v29.4h, v0.h[0]
    smlal2 v20.4s, v29.8h, v0.h[0]

    uzp2 v3.8h,  v9.8h, v10.8h
    uzp2 v6.8h, v11.8h, v12.8h
    uzp2 v4.8h, v13.8h, v14.8h
    uzp2 v7.8h, v15.8h, v16.8h
    uzp2 v5.8h, v17.8h, v18.8h
    uzp2 v8.8h, v19.8h, v20.8h

    #store
    st1 {v3.8h, v4.8h, v5.8h},  [dst], #48
    st1 {v6.8h, v7.8h, v8.8h},  [dst], #48

    cmp dst, counter
    blt _looptop_baseinv

    eor x0, x0, x0

    ret

_loop_notinvertible:

    mov x0, #1

    ret    

    .unreq    dst
    .unreq    src
    .unreq    table
    .unreq    counter    
