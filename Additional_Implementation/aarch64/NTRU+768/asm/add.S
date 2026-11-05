#include "asm.h"

NTRUPLUS_ASM_START(poly_sub)

dst     .req x0
src1    .req x1
src2    .req x2
counter .req x8

mov counter, #1536

.balign 4
NTRUPLUS_ASM_LOCAL(loop_sub):
ld1 { v0.8h -  v3.8h}, [src1], #64
ld1 { v4.8h -  v7.8h}, [src1], #64
ld1 {v16.8h - v19.8h}, [src1], #64

ld1 {v20.8h - v23.8h}, [src2], #64
ld1 {v24.8h - v27.8h}, [src2], #64
ld1 {v28.8h - v31.8h}, [src2], #64

sub  v0.8h,  v0.8h, v20.8h
sub  v1.8h,  v1.8h, v21.8h
sub  v2.8h,  v2.8h, v22.8h
sub  v3.8h,  v3.8h, v23.8h
st1 { v0.8h,  v1.8h}, [dst], #32
sub  v4.8h,  v4.8h, v24.8h
sub  v5.8h,  v5.8h, v25.8h
st1 { v2.8h,  v3.8h}, [dst], #32
sub  v6.8h,  v6.8h, v26.8h
sub  v7.8h,  v7.8h, v27.8h
st1 { v4.8h,  v5.8h}, [dst], #32
sub v16.8h, v16.8h, v28.8h
sub v17.8h, v17.8h, v29.8h
st1 { v6.8h,  v7.8h}, [dst], #32
sub v18.8h, v18.8h, v30.8h
sub v19.8h, v19.8h, v31.8h
st1 {v16.8h, v17.8h}, [dst], #32
st1 {v18.8h, v19.8h}, [dst], #32

subs counter, counter, #192
b.ne NTRUPLUS_ASM_LOCAL(loop_sub)

.unreq dst
.unreq src1
.unreq src2
.unreq counter

ret
NTRUPLUS_ASM_END(poly_sub)


NTRUPLUS_ASM_GNU_STACK
