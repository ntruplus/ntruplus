/*************************************************
* Name:        poly_crepmod3
*
* Description: Centers coefficients modulo q and reduces them modulo 3.
*
* Arguments:   - poly *r: pointer to the input/output polynomial;
*                         input coefficients must lie in [-q+1,q-1]
*
* Returns:     none. Output coefficients lie in {-1,0,1}.
**************************************************/
.global poly_crepmod3
.global _poly_crepmod3
poly_crepmod3:
_poly_crepmod3:
    dst        .req x0
    src        .req x9
    const_ptr  .req x2
    counter    .req x8

    mov src, dst
    adr const_ptr, crepmod3_consts
    ld1 {v0.8h - v3.8h}, [const_ptr]
    movi v4.8h, #3

    mov counter, #1728

_looptop:
    ld1 {v5.8h - v8.8h}, [src], #64

    sshr v9.8h,  v5.8h, #15
    sshr v10.8h, v6.8h, #15
    sshr v11.8h, v7.8h, #15
    sshr v12.8h, v8.8h, #15

    and v9.16b,  v9.16b,  v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b

    add v5.8h, v5.8h, v9.8h
    add v6.8h, v6.8h, v10.8h
    add v7.8h, v7.8h, v11.8h
    add v8.8h, v8.8h, v12.8h

    sub v5.8h, v5.8h, v1.8h
    sub v6.8h, v6.8h, v1.8h
    sub v7.8h, v7.8h, v1.8h
    sub v8.8h, v8.8h, v1.8h

    sshr v9.8h,  v5.8h, #15
    sshr v10.8h, v6.8h, #15
    sshr v11.8h, v7.8h, #15
    sshr v12.8h, v8.8h, #15

    and v9.16b,  v9.16b,  v0.16b
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    and v12.16b, v12.16b, v0.16b

    add v5.8h, v5.8h, v9.8h
    add v6.8h, v6.8h, v10.8h
    add v7.8h, v7.8h, v11.8h
    add v8.8h, v8.8h, v12.8h

    sub v5.8h, v5.8h, v2.8h
    sub v6.8h, v6.8h, v2.8h
    sub v7.8h, v7.8h, v2.8h
    sub v8.8h, v8.8h, v2.8h

    sqrdmulh v9.8h,  v5.8h, v3.8h
    sqrdmulh v10.8h, v6.8h, v3.8h
    sqrdmulh v11.8h, v7.8h, v3.8h
    sqrdmulh v12.8h, v8.8h, v3.8h

    mls v5.8h, v9.8h,  v4.8h
    mls v6.8h, v10.8h, v4.8h
    mls v7.8h, v11.8h, v4.8h
    mls v8.8h, v12.8h, v4.8h

    st1 {v5.8h - v8.8h}, [dst], #64

    subs counter, counter, #64
    b.ne _looptop

    .unreq dst
    .unreq src
    .unreq const_ptr
    .unreq counter

    ret


.align 4
crepmod3_consts:
    .hword 3457, 3457, 3457, 3457, 3457, 3457, 3457, 3457
    .hword 1729, 1729, 1729, 1729, 1729, 1729, 1729, 1729
    .hword 1728, 1728, 1728, 1728, 1728, 1728, 1728, 1728
    .hword 10923, 10923, 10923, 10923, 10923, 10923, 10923, 10923
