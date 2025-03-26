.global poly_baseinv_asm
.global _poly_baseinv_asm
poly_baseinv_asm:
_poly_baseinv_asm:
    dst     .req x0
    src     .req x1
    table   .req x2
    counter .req x8

    add counter, dst, #2304

    ld1 {v0.8h}, [table], #16

_looptop_baseinv:
    #load
    ld1 {v1.8h, v2.8h}, [table], #32

    #load
    ld1 {v3.8h, v4.8h, v5.8h,  v6.8h}, [src], #64
    ld1 {v7.8h, v8.8h, v9.8h, v10.8h}, [src], #64

    neg v30.8h,  v4.8h //-a1
    neg v31.8h,  v8.8h //-a1

    smull  v11.4s, v5.4h, v5.4h //a2*a2
    smull2 v12.4s, v5.8h, v5.8h //a2*a2
    smull  v13.4s, v9.4h, v9.4h //a2*a2
    smull2 v14.4s, v9.8h, v9.8h //a2*a2

    smlal  v11.4s, v30.4h,  v6.4h //a1*a3
    smlal2 v12.4s, v30.8h,  v6.8h //a1*a3    
    smlal  v13.4s, v31.4h, v10.4h //a1*a3
    smlal2 v14.4s, v31.8h, v10.8h //a1*a3

    smlal  v11.4s, v30.4h,  v6.4h //a1*a3
    smlal2 v12.4s, v30.8h,  v6.8h //a1*a3    
    smlal  v13.4s, v31.4h, v10.4h //a1*a3
    smlal2 v14.4s, v31.8h, v10.8h //a1*a3

    smull  v15.4s,  v6.4h,  v6.4h //a3*a3
    smull2 v16.4s,  v6.8h,  v6.8h //a3*a3
    smull  v17.4s, v10.4h, v10.4h //a3*a3
    smull2 v18.4s, v10.8h, v10.8h //a3*a3

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

    uzp2 v26.8h, v11.8h, v12.8h //t0
    uzp2 v27.8h, v13.8h, v14.8h //t0
    uzp2 v28.8h, v15.8h, v16.8h //t1
    uzp2 v29.8h, v17.8h, v18.8h //t1
    
    smull  v11.4s, v26.4h, v1.4h //t0*zeta
    smull2 v12.4s, v26.8h, v1.8h //t0*zeta
    smull  v13.4s, v27.4h, v2.4h //t0*zeta
    smull2 v14.4s, v27.8h, v2.8h //t0*zeta

    smlal  v11.4s, v3.4h, v3.4h //a0*a0
    smlal2 v12.4s, v3.8h, v3.8h //a0*a0
    smlal  v13.4s, v7.4h, v7.4h //a0*a0
    smlal2 v14.4s, v7.8h, v7.8h //a0*a0

    smull  v15.4s, v28.4h, v2.4h //t1*zeta
    smull2 v16.4s, v28.8h, v2.8h //t1*zeta
    smull  v17.4s, v29.4h, v1.4h //t1*zeta
    smull2 v18.4s, v29.8h, v1.8h //t1*zeta
    
    smlal  v15.4s, v30.4h, v4.4h //a1*a1
    smlal2 v16.4s, v30.8h, v4.8h //a1*a1
    smlal  v17.4s, v31.4h, v8.4h //a1*a1
    smlal2 v18.4s, v31.8h, v8.8h //a1*a1

    smlal  v15.4s, v3.4h, v5.4h //a0*a2
    smlal2 v16.4s, v3.8h, v5.8h //a0*a2
    smlal  v17.4s, v7.4h, v9.4h //a0*a2
    smlal2 v18.4s, v7.8h, v9.8h //a0*a2

    smlal  v15.4s, v3.4h, v5.4h //a0*a2
    smlal2 v16.4s, v3.8h, v5.8h //a0*a2
    smlal  v17.4s, v7.4h, v9.4h //a0*a2
    smlal2 v18.4s, v7.8h, v9.8h //a0*a2

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

    uzp2 v26.8h, v11.8h, v12.8h //t0
    uzp2 v27.8h, v13.8h, v14.8h //t0
    uzp2 v28.8h, v15.8h, v16.8h //t1
    uzp2 v29.8h, v17.8h, v18.8h //t1

    smull  v11.4s, v28.4h, v28.4h //t1*t1
    smull2 v12.4s, v28.8h, v28.8h //t1*t1
    smull  v13.4s, v29.4h, v29.4h //t1*t1
    smull2 v14.4s, v29.8h, v29.8h //t1*t1

    uzp1 v15.8h, v11.8h, v12.8h
    uzp1 v16.8h, v13.8h, v14.8h

    mul  v15.8h, v15.8h, v0.h[1]
    mul  v16.8h, v16.8h, v0.h[1]
    
    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v30.8h, v11.8h, v12.8h
    uzp2 v31.8h, v13.8h, v14.8h

    smull  v11.4s, v26.4h, v26.4h //t0*t0
    smull2 v12.4s, v26.8h, v26.8h //t0*t0
    smull  v13.4s, v27.4h, v27.4h //t0*t0
    smull2 v14.4s, v27.8h, v27.8h //t0*t0

    smlal  v11.4s, v30.4h, v2.4h  //t2*zeta
    smlal2 v12.4s, v30.8h, v2.8h  //t2*zeta
    smlal  v13.4s, v31.4h, v1.4h  //t2*zeta
    smlal2 v14.4s, v31.8h, v1.8h  //t2*zeta

    uzp1 v15.8h, v11.8h, v12.8h
    uzp1 v16.8h, v13.8h, v14.8h

    mul  v15.8h, v15.8h, v0.h[1]
    mul  v16.8h, v16.8h, v0.h[1]
    
    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v30.8h, v11.8h, v12.8h //t2
    uzp2 v31.8h, v13.8h, v14.8h //t2

    //Inverse test
    uminv h11, v30.8h
    uminv h12, v31.8h
    umov  w3, v11.h[0]
    umov  w4, v12.h[0]
    cbz   w3, _loop_notinvertible
    cbz   w4, _loop_notinvertible

    //Inverse
    //t1 = fqmul(a, a);    //10
    smull  v11.4s, v30.4h, v30.4h
    smull2 v12.4s, v30.8h, v30.8h
    smull  v13.4s, v31.4h, v31.4h
    smull2 v14.4s, v31.8h, v31.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v20.8h, v11.8h, v12.8h //t1
    uzp2 v21.8h, v13.8h, v14.8h //t1

    //t2 = fqmul(t1, t1);  //100
    smull  v11.4s, v20.4h, v20.4h
    smull2 v12.4s, v20.8h, v20.8h
    smull  v13.4s, v21.4h, v21.4h
    smull2 v14.4s, v21.8h, v21.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h //t2
    uzp2 v23.8h, v13.8h, v14.8h //t2

    //t2 = fqmul(t2, t2);  //1000
    smull  v11.4s, v22.4h, v22.4h
    smull2 v12.4s, v22.8h, v22.8h
    smull  v13.4s, v23.4h, v23.4h
    smull2 v14.4s, v23.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h  //t2
    uzp2 v23.8h, v13.8h, v14.8h  //t2

    //t3 = fqmul(t2, t2);  //10000
    smull  v11.4s, v22.4h, v22.4h
    smull2 v12.4s, v22.8h, v22.8h
    smull  v13.4s, v23.4h, v23.4h
    smull2 v14.4s, v23.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v24.8h, v11.8h, v12.8h //t3
    uzp2 v25.8h, v13.8h, v14.8h //t3

    //t1 = fqmul(t1, t2);  //1010
    smull  v11.4s, v20.4h, v22.4h
    smull2 v12.4s, v20.8h, v22.8h
    smull  v13.4s, v21.4h, v23.4h
    smull2 v14.4s, v21.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v20.8h, v11.8h, v12.8h //t1
    uzp2 v21.8h, v13.8h, v14.8h //t1
    
    //t2 = fqmul(t1, t3);  //11010
    smull  v11.4s, v20.4h, v24.4h
    smull2 v12.4s, v20.8h, v24.8h
    smull  v13.4s, v21.4h, v25.4h
    smull2 v14.4s, v21.8h, v25.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h //t2
    uzp2 v23.8h, v13.8h, v14.8h //t2

    //t2 = fqmul(t2, t2);  //110100
    smull  v11.4s, v22.4h, v22.4h
    smull2 v12.4s, v22.8h, v22.8h
    smull  v13.4s, v23.4h, v23.4h
    smull2 v14.4s, v23.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h  //t2
    uzp2 v23.8h, v13.8h, v14.8h  //t2

    //t2 = fqmul(t2, a);   //110101
    smull  v11.4s, v22.4h, v30.4h
    smull2 v12.4s, v22.8h, v30.8h
    smull  v13.4s, v23.4h, v31.4h
    smull2 v14.4s, v23.8h, v31.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h  //t2
    uzp2 v23.8h, v13.8h, v14.8h  //t2

    //t1 = fqmul(t1, t2);  //111111
    smull  v11.4s, v20.4h, v22.4h
    smull2 v12.4s, v20.8h, v22.8h
    smull  v13.4s, v21.4h, v23.4h
    smull2 v14.4s, v21.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v20.8h, v11.8h, v12.8h //t1
    uzp2 v21.8h, v13.8h, v14.8h //t1

    //t2 = fqmul(t2, t2);  //1101010
    smull  v11.4s, v22.4h, v22.4h
    smull2 v12.4s, v22.8h, v22.8h
    smull  v13.4s, v23.4h, v23.4h
    smull2 v14.4s, v23.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h  //t2
    uzp2 v23.8h, v13.8h, v14.8h  //t2

    //t2 = fqmul(t2, t2);  //11010100
    smull  v11.4s, v22.4h, v22.4h
    smull2 v12.4s, v22.8h, v22.8h
    smull  v13.4s, v23.4h, v23.4h
    smull2 v14.4s, v23.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h  //t2
    uzp2 v23.8h, v13.8h, v14.8h  //t2

    //t2 = fqmul(t2, t2);  //110101000
    smull  v11.4s, v22.4h, v22.4h
    smull2 v12.4s, v22.8h, v22.8h
    smull  v13.4s, v23.4h, v23.4h
    smull2 v14.4s, v23.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h  //t2
    uzp2 v23.8h, v13.8h, v14.8h  //t2

    //t2 = fqmul(t2, t2);  //1101010000
    smull  v11.4s, v22.4h, v22.4h
    smull2 v12.4s, v22.8h, v22.8h
    smull  v13.4s, v23.4h, v23.4h
    smull2 v14.4s, v23.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h  //t2
    uzp2 v23.8h, v13.8h, v14.8h  //t2

    //t2 = fqmul(t2, t2);  //11010100000
    smull  v11.4s, v22.4h, v22.4h
    smull2 v12.4s, v22.8h, v22.8h
    smull  v13.4s, v23.4h, v23.4h
    smull2 v14.4s, v23.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h  //t2
    uzp2 v23.8h, v13.8h, v14.8h  //t2

    //t2 = fqmul(t2, t2);  //110101000000
    smull  v11.4s, v22.4h, v22.4h
    smull2 v12.4s, v22.8h, v22.8h
    smull  v13.4s, v23.4h, v23.4h
    smull2 v14.4s, v23.8h, v23.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v22.8h, v11.8h, v12.8h  //t2
    uzp2 v23.8h, v13.8h, v14.8h  //t2

    //t2 = fqmul(t2, t1);  //110101111111
    smull  v11.4s, v22.4h, v20.4h
    smull2 v12.4s, v22.8h, v20.8h
    smull  v13.4s, v23.4h, v21.4h
    smull2 v14.4s, v23.8h, v21.8h

    uzp1 v15.8h, v11.8h, v12.8h    
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]    
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v30.8h, v11.8h, v12.8h  //t2
    uzp2 v31.8h, v13.8h, v14.8h  //t2
    
    #update
    smull   v11.4s, v26.4h, v30.4h //t0*t2
    smull2  v12.4s, v26.8h, v30.8h //t0*t2
    smull   v13.4s, v27.4h, v31.4h //t0*t2
    smull2  v14.4s, v27.8h, v31.8h //t0*t2

    smull   v15.4s, v28.4h, v30.4h //t1*t2
    smull2  v16.4s, v28.8h, v30.8h //t1*t2
    smull   v17.4s, v29.4h, v31.4h //t1*t2
    smull2  v18.4s, v29.8h, v31.8h //t1*t2

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

    uzp2 v26.8h, v11.8h, v12.8h //t0
    uzp2 v27.8h, v13.8h, v14.8h //t0
    uzp2 v28.8h, v15.8h, v16.8h //t1
    uzp2 v29.8h, v17.8h, v18.8h //t1

    smull  v11.4s, v28.4h, v1.4h //t1*zeta
    smull2 v12.4s, v28.8h, v1.8h //t1*zeta
    smull  v13.4s, v29.4h, v2.4h //t1*zeta
    smull2 v14.4s, v29.8h, v2.8h //t1*zeta

    uzp1 v15.8h, v11.8h, v12.8h
    uzp1 v16.8h, v13.8h, v14.8h

    mul v15.8h, v15.8h, v0.h[1]
    mul v16.8h, v16.8h, v0.h[1]

    smlal  v11.4s, v15.4h, v0.h[0]
    smlal2 v12.4s, v15.8h, v0.h[0]
    smlal  v13.4s, v16.4h, v0.h[0]
    smlal2 v14.4s, v16.8h, v0.h[0]

    uzp2 v30.8h, v11.8h, v12.8h //t2
    uzp2 v31.8h, v13.8h, v14.8h //t2

    //mul
    neg v20.8h, v26.8h // -t0
    neg v22.8h, v28.8h // -t1
    neg v24.8h, v30.8h // -t2

    //mul
    smull  v11.4s, v3.4h, v26.4h //a0*t0
    smull2 v12.4s, v3.8h, v26.8h //a0*t0
    smull  v13.4s, v6.4h, v30.4h //a3*t2
    smull2 v14.4s, v6.8h, v30.8h //a3*t2
    smull  v15.4s, v5.4h, v26.4h //a2*t0
    smull2 v16.4s, v5.8h, v26.8h //a2*t0
    smull  v17.4s, v4.4h, v28.4h //a1*t1
    smull2 v18.4s, v4.8h, v28.8h //a1*t1

    smlal  v11.4s, v5.4h, v24.4h //a2*t2
    smlal2 v12.4s, v5.8h, v24.8h //a2*t2
    smlal  v13.4s, v4.4h, v20.4h //a1*t0
    smlal2 v14.4s, v4.8h, v20.8h //a1*t0
    smlal  v15.4s, v3.4h, v22.4h //a0*t1
    smlal2 v16.4s, v3.8h, v22.8h //a0*t1
    smlal  v17.4s, v6.4h, v20.4h //a3*t0
    smlal2 v18.4s, v6.8h, v20.8h //a3*t0

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

    uzp2 v3.8h, v11.8h, v12.8h
    uzp2 v4.8h, v13.8h, v14.8h
    uzp2 v5.8h, v15.8h, v16.8h
    uzp2 v6.8h, v17.8h, v18.8h

    #store
    st1 {v3.8h, v4.8h, v5.8h,  v6.8h},  [dst], #64

    //mul
    neg v21.8h, v27.8h //-t0
    neg v23.8h, v29.8h //-t1
    neg v25.8h, v31.8h //-t2

    //mul
    smull  v11.4s,  v7.4h, v27.4h //a0*t0
    smull2 v12.4s,  v7.8h, v27.8h //a0*t0
    smull  v13.4s, v10.4h, v31.4h //a3*t2
    smull2 v14.4s, v10.8h, v31.8h //a3*t2
    smull  v15.4s,  v9.4h, v27.4h //a2*t0
    smull2 v16.4s,  v9.8h, v27.8h //a2*t0
    smull  v17.4s,  v8.4h, v29.4h //a1*t1
    smull2 v18.4s,  v8.8h, v29.8h //a1*t1

    smlal  v11.4s,  v9.4h, v25.4h //a2*t2
    smlal2 v12.4s,  v9.8h, v25.8h //a2*t2
    smlal  v13.4s,  v8.4h, v21.4h //a1*t0
    smlal2 v14.4s,  v8.8h, v21.8h //a1*t0
    smlal  v15.4s,  v7.4h, v23.4h //a0*t1
    smlal2 v16.4s,  v7.8h, v23.8h //a0*t1
    smlal  v17.4s, v10.4h, v21.4h //a3*t0
    smlal2 v18.4s, v10.8h, v21.8h //a3*t0

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

    uzp2 v3.8h, v11.8h, v12.8h
    uzp2 v4.8h, v13.8h, v14.8h
    uzp2 v5.8h, v15.8h, v16.8h
    uzp2 v6.8h, v17.8h, v18.8h

    #store
    st1 {v3.8h, v4.8h, v5.8h,  v6.8h},  [dst], #64
    
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
