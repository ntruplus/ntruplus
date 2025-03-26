.global poly_shuffle
.global _poly_shuffle
poly_shuffle:
_poly_shuffle:
    dst       .req x0
    src       .req x1
    counter   .req x8

    add counter, src, #1728

_loop_shuffle:

    #load
    ldr  q4, [src, #0*16]
    ldr  q5, [src, #1*16]
    ldr  q6, [src, #2*16]
    ldr  q7, [src, #3*16]
    ldr  q8, [src, #4*16]
    ldr  q9, [src, #5*16]

    #shuffle
    trn1 v10.2d, v4.2d, v7.2d
    trn2 v11.2d, v4.2d, v7.2d
    trn1 v12.2d, v5.2d, v8.2d
    trn2 v13.2d, v5.2d, v8.2d
    trn1 v14.2d, v6.2d, v9.2d
    trn2 v15.2d, v6.2d, v9.2d

    #shuffle
    trn1 v16.4s, v10.4s, v13.4s
    trn2 v17.4s, v10.4s, v13.4s
    trn1 v18.4s, v11.4s, v14.4s
    trn2 v19.4s, v11.4s, v14.4s
    trn1 v20.4s, v12.4s, v15.4s
    trn2 v21.4s, v12.4s, v15.4s

    #shuffle
    trn1 v4.8h, v16.8h, v19.8h
    trn2 v5.8h, v16.8h, v19.8h
    trn1 v6.8h, v17.8h, v20.8h
    trn2 v7.8h, v17.8h, v20.8h
    trn1 v8.8h, v18.8h, v21.8h
    trn2 v9.8h, v18.8h, v21.8h

    #store
    str  q4, [dst, #0*16]
    str  q5, [dst, #1*16]
    str  q6, [dst, #2*16]
    str  q7, [dst, #3*16]
    str  q8, [dst, #4*16]
    str  q9, [dst, #5*16]  

    add src, src, #96
    add dst, dst, #96
    cmp src, counter
    blt _loop_shuffle

    .unreq    dst
    .unreq    src
    .unreq    counter
    ret

.global poly_shuffle2
.global _poly_shuffle2
poly_shuffle2:
_poly_shuffle2:
    dst       .req x0
    src       .req x1
    counter   .req x8

    add counter, src, #1728

_loop_shuffle2:
    #load
    ldr  q4, [src, #0*16]
    ldr  q5, [src, #1*16]
    ldr  q6, [src, #2*16]
    ldr  q7, [src, #3*16]
    ldr  q8, [src, #4*16]
    ldr  q9, [src, #5*16]

    #shuffle
    trn1 v10.8h, v4.8h, v5.8h
    trn1 v11.8h, v6.8h, v7.8h
    trn1 v12.8h, v8.8h, v9.8h
    trn2 v13.8h, v4.8h, v5.8h
    trn2 v14.8h, v6.8h, v7.8h
    trn2 v15.8h, v8.8h, v9.8h

    #shuffle
    trn1 v16.4s, v10.4s, v11.4s
    trn1 v17.4s, v12.4s, v13.4s
    trn1 v18.4s, v14.4s, v15.4s
    trn2 v19.4s, v10.4s, v11.4s
    trn2 v20.4s, v12.4s, v13.4s
    trn2 v21.4s, v14.4s, v15.4s

    #shuffle
    trn1 v4.2d, v16.2d, v17.2d
    trn1 v5.2d, v18.2d, v19.2d
    trn1 v6.2d, v20.2d, v21.2d
    trn2 v7.2d, v16.2d, v17.2d
    trn2 v8.2d, v18.2d, v19.2d
    trn2 v9.2d, v20.2d, v21.2d
    
    #store
    str  q4, [dst, #0*16]
    str  q5, [dst, #1*16]
    str  q6, [dst, #2*16]
    str  q7, [dst, #3*16]
    str  q8, [dst, #4*16]
    str  q9, [dst, #5*16]  

    add src, src, #96
    add dst, dst, #96
    cmp src, counter
    blt _loop_shuffle2

    .unreq    dst
    .unreq    src
    .unreq    counter
    ret
