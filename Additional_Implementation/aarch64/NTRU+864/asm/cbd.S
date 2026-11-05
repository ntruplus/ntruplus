#include "asm.h"

/*************************************************
* Name:        poly_cbd1
*
* Description: Samples a polynomial from the centered binomial distribution
*              with parameter eta = 1.
*
* Arguments:   - poly *r: pointer to the output polynomial
*              - const uint8_t *buf: pointer to NTRUPLUS_N/4 input bytes
*
* Returns:     none. Output coefficients lie in {-1,0,1}.
**************************************************/
NTRUPLUS_ASM_START(poly_cbd1)

dst     .req x0
src     .req x1
counter .req x8
taildst .req x9

movi v0.16b, #0x55
movi v1.16b, #0x03
movi v2.16b, #0x01

//load
ldr q20, [src, #92]
ldr q16, [src, #200]

ushr v17.16b, v20.16b, #1
ushr v18.16b, v16.16b, #1

and v3.16b, v20.16b, v0.16b
and v4.16b, v16.16b, v0.16b
and v5.16b, v17.16b, v0.16b
and v6.16b, v18.16b, v0.16b

add v3.16b, v3.16b, v0.16b
add v5.16b, v5.16b, v0.16b

sub v20.16b, v3.16b, v4.16b
sub v16.16b, v5.16b, v6.16b

ushr v17.16b, v20.16b, #2
ushr v18.16b, v16.16b, #2

//extract 1
and v3.16b, v20.16b, v1.16b
and v4.16b, v16.16b, v1.16b
and v5.16b, v17.16b, v1.16b
and v6.16b, v18.16b, v1.16b

ushr v20.16b, v20.16b, #4
ushr v16.16b, v16.16b, #4
ushr v17.16b, v17.16b, #4
ushr v18.16b, v18.16b, #4

//extract 2
and  v7.16b, v20.16b, v1.16b
and v20.16b, v16.16b, v1.16b
and v21.16b, v17.16b, v1.16b
and v22.16b, v18.16b, v1.16b

//shuffles
trn1 v23.16b,  v3.16b,  v4.16b
trn1 v24.16b,  v5.16b,  v6.16b
trn1 v25.16b,  v7.16b, v20.16b
trn1 v26.16b, v21.16b, v22.16b

trn2 v27.16b,  v3.16b,  v4.16b
trn2 v16.16b,  v5.16b,  v6.16b
trn2 v17.16b,  v7.16b, v20.16b
trn2 v18.16b, v21.16b, v22.16b

trn1 v19.8h, v23.8h, v24.8h
trn1 v28.8h, v25.8h, v26.8h
trn1 v29.8h, v27.8h, v16.8h
trn1 v30.8h, v17.8h, v18.8h

trn2 v31.8h, v23.8h, v24.8h
trn2 v21.8h, v25.8h, v26.8h
trn2 v22.8h, v27.8h, v16.8h
trn2 v20.8h, v17.8h, v18.8h

trn1 v16.4s, v19.4s, v28.4s
trn1 v17.4s, v29.4s, v30.4s
trn1 v18.4s, v31.4s, v21.4s
trn1  v3.4s, v22.4s, v20.4s

trn2 v4.4s, v19.4s, v28.4s
trn2 v5.4s, v29.4s, v30.4s
trn2 v6.4s, v31.4s, v21.4s
trn2 v7.4s, v22.4s, v20.4s

//expand
usubl v20.8h, v16.8b, v2.8b
usubl v21.8h, v17.8b, v2.8b
usubl v22.8h, v18.8b, v2.8b
usubl v23.8h,  v3.8b, v2.8b

usubl v24.8h, v4.8b, v2.8b
usubl v25.8h, v5.8b, v2.8b
usubl v26.8h, v6.8b, v2.8b
usubl v27.8h, v7.8b, v2.8b

usubl2 v16.8h, v16.16b, v2.16b
usubl2 v17.8h, v17.16b, v2.16b
usubl2 v18.8h, v18.16b, v2.16b
usubl2 v19.8h,  v3.16b, v2.16b

usubl2 v28.8h, v4.16b, v2.16b
usubl2 v29.8h, v5.16b, v2.16b
usubl2 v30.8h, v6.16b, v2.16b
usubl2 v31.8h, v7.16b, v2.16b

add taildst, dst, #1472

//store
st1 {v20.8h - v23.8h}, [taildst], #64
st1 {v24.8h - v27.8h}, [taildst], #64
st1 {v16.8h - v19.8h}, [taildst], #64
st1 {v28.8h - v31.8h}, [taildst], #64

mov counter, #1536

NTRUPLUS_ASM_LOCAL(loop_cbd):

//load
ldr q20, [src], #16
ldr q16, [src, #92]

ushr v17.16b, v20.16b, #1
ushr v18.16b, v16.16b, #1

and v3.16b, v20.16b, v0.16b
and v4.16b, v16.16b, v0.16b
and v5.16b, v17.16b, v0.16b
and v6.16b, v18.16b, v0.16b

add v3.16b, v3.16b, v0.16b
add v5.16b, v5.16b, v0.16b

sub v20.16b, v3.16b, v4.16b
sub v16.16b, v5.16b, v6.16b

ushr v17.16b, v20.16b, #2
ushr v18.16b, v16.16b, #2

//extract 1
and v3.16b, v20.16b, v1.16b
and v4.16b, v16.16b, v1.16b
and v5.16b, v17.16b, v1.16b
and v6.16b, v18.16b, v1.16b

ushr v20.16b, v20.16b, #4
ushr v16.16b, v16.16b, #4
ushr v17.16b, v17.16b, #4
ushr v18.16b, v18.16b, #4

//extract 2
and  v7.16b, v20.16b, v1.16b
and v20.16b, v16.16b, v1.16b
and v21.16b, v17.16b, v1.16b
and v22.16b, v18.16b, v1.16b

//shuffles
trn1 v23.16b,  v3.16b,  v4.16b
trn1 v24.16b,  v5.16b,  v6.16b
trn1 v25.16b,  v7.16b, v20.16b
trn1 v26.16b, v21.16b, v22.16b

trn2 v27.16b,  v3.16b,  v4.16b
trn2 v16.16b,  v5.16b,  v6.16b
trn2 v17.16b,  v7.16b, v20.16b
trn2 v18.16b, v21.16b, v22.16b

trn1 v19.8h, v23.8h, v24.8h
trn1 v28.8h, v25.8h, v26.8h
trn1 v29.8h, v27.8h, v16.8h
trn1 v30.8h, v17.8h, v18.8h

trn2 v31.8h, v23.8h, v24.8h
trn2 v21.8h, v25.8h, v26.8h
trn2 v22.8h, v27.8h, v16.8h
trn2 v20.8h, v17.8h, v18.8h

trn1 v16.4s, v19.4s, v28.4s
trn1 v17.4s, v29.4s, v30.4s
trn1 v18.4s, v31.4s, v21.4s
trn1  v3.4s, v22.4s, v20.4s

trn2 v4.4s, v19.4s, v28.4s
trn2 v5.4s, v29.4s, v30.4s
trn2 v6.4s, v31.4s, v21.4s
trn2 v7.4s, v22.4s, v20.4s

//expand
usubl v20.8h, v16.8b, v2.8b
usubl v21.8h, v17.8b, v2.8b
usubl v22.8h, v18.8b, v2.8b
usubl v23.8h,  v3.8b, v2.8b

usubl v24.8h, v4.8b, v2.8b
usubl v25.8h, v5.8b, v2.8b
usubl v26.8h, v6.8b, v2.8b
usubl v27.8h, v7.8b, v2.8b

usubl2 v16.8h, v16.16b, v2.16b
usubl2 v17.8h, v17.16b, v2.16b
usubl2 v18.8h, v18.16b, v2.16b
usubl2 v19.8h,  v3.16b, v2.16b

usubl2 v28.8h, v4.16b, v2.16b
usubl2 v29.8h, v5.16b, v2.16b
usubl2 v30.8h, v6.16b, v2.16b
usubl2 v31.8h, v7.16b, v2.16b

//store
st1 {v20.8h - v23.8h}, [dst], #64
st1 {v24.8h - v27.8h}, [dst], #64
st1 {v16.8h - v19.8h}, [dst], #64
st1 {v28.8h - v31.8h}, [dst], #64

subs counter, counter, #256
b.ne NTRUPLUS_ASM_LOCAL(loop_cbd)

.unreq dst
.unreq src
.unreq counter
.unreq taildst

ret
NTRUPLUS_ASM_END(poly_cbd1)


/*************************************************
* Name:        poly_cbd1_triple
*
* Description: Samples a polynomial from the centered binomial distribution
*              with parameter eta = 1 and multiplies coefficients by 3.
*
* Arguments:   - poly *r: pointer to the output polynomial
*              - const uint8_t *buf: pointer to NTRUPLUS_N/4 input bytes
*
* Returns:     none. Output coefficients lie in {-3,0,3}.
**************************************************/
NTRUPLUS_ASM_START(poly_cbd1_triple)

dst     .req x0
src     .req x1
counter .req x8
taildst .req x9

movi v0.16b, #0x55
movi v1.16b, #0x03
movi v2.16b, #0x01

//load
ldr q20, [src, #92]
ldr q16, [src, #200]

ushr v17.16b, v20.16b, #1
ushr v18.16b, v16.16b, #1

and v3.16b, v20.16b, v0.16b
and v4.16b, v16.16b, v0.16b
and v5.16b, v17.16b, v0.16b
and v6.16b, v18.16b, v0.16b

add v3.16b, v3.16b, v0.16b
add v5.16b, v5.16b, v0.16b

sub v20.16b, v3.16b, v4.16b
sub v16.16b, v5.16b, v6.16b

ushr v17.16b, v20.16b, #2
ushr v18.16b, v16.16b, #2

//extract 1
and v3.16b, v20.16b, v1.16b
and v4.16b, v16.16b, v1.16b
and v5.16b, v17.16b, v1.16b
and v6.16b, v18.16b, v1.16b

sub v3.16b, v3.16b, v2.16b
sub v4.16b, v4.16b, v2.16b
sub v5.16b, v5.16b, v2.16b
sub v6.16b, v6.16b, v2.16b

ushr v20.16b, v20.16b, #4
ushr v16.16b, v16.16b, #4
ushr v17.16b, v17.16b, #4
ushr v18.16b, v18.16b, #4

//extract 2
and  v7.16b, v20.16b, v1.16b
and v20.16b, v16.16b, v1.16b
and v21.16b, v17.16b, v1.16b
and v22.16b, v18.16b, v1.16b

sub  v7.16b,  v7.16b, v2.16b
sub v20.16b, v20.16b, v2.16b
sub v21.16b, v21.16b, v2.16b
sub v22.16b, v22.16b, v2.16b

//shuffles
trn1 v23.16b,  v3.16b,  v4.16b
trn1 v24.16b,  v5.16b,  v6.16b
trn1 v25.16b,  v7.16b, v20.16b
trn1 v26.16b, v21.16b, v22.16b

trn2 v27.16b,  v3.16b,  v4.16b
trn2 v16.16b,  v5.16b,  v6.16b
trn2 v17.16b,  v7.16b, v20.16b
trn2 v18.16b, v21.16b, v22.16b

trn1 v19.8h, v23.8h, v24.8h
trn1 v28.8h, v25.8h, v26.8h
trn1 v29.8h, v27.8h, v16.8h
trn1 v30.8h, v17.8h, v18.8h

trn2 v31.8h, v23.8h, v24.8h
trn2 v21.8h, v25.8h, v26.8h
trn2 v22.8h, v27.8h, v16.8h
trn2 v20.8h, v17.8h, v18.8h

trn1 v16.4s, v19.4s, v28.4s
trn1 v17.4s, v29.4s, v30.4s
trn1 v18.4s, v31.4s, v21.4s
trn1  v3.4s, v22.4s, v20.4s

trn2 v4.4s, v19.4s, v28.4s
trn2 v5.4s, v29.4s, v30.4s
trn2 v6.4s, v31.4s, v21.4s
trn2 v7.4s, v22.4s, v20.4s

//triple
//expand
smull v20.8h, v16.8b, v1.8b
smull v21.8h, v17.8b, v1.8b
smull v22.8h, v18.8b, v1.8b
smull v23.8h,  v3.8b, v1.8b

smull v24.8h, v4.8b, v1.8b
smull v25.8h, v5.8b, v1.8b
smull v26.8h, v6.8b, v1.8b
smull v27.8h, v7.8b, v1.8b

smull2 v16.8h, v16.16b, v1.16b
smull2 v17.8h, v17.16b, v1.16b
smull2 v18.8h, v18.16b, v1.16b
smull2 v19.8h,  v3.16b, v1.16b

smull2 v28.8h, v4.16b, v1.16b
smull2 v29.8h, v5.16b, v1.16b
smull2 v30.8h, v6.16b, v1.16b
smull2 v31.8h, v7.16b, v1.16b

add taildst, dst, #1472

//store
st1 {v20.8h - v23.8h}, [taildst], #64
st1 {v24.8h - v27.8h}, [taildst], #64
st1 {v16.8h - v19.8h}, [taildst], #64
st1 {v28.8h - v31.8h}, [taildst], #64

mov counter, #1536

NTRUPLUS_ASM_LOCAL(loop_cbd_triple):

//load
ldr q20, [src], #16
ldr q16, [src, #92]

ushr v17.16b, v20.16b, #1
ushr v18.16b, v16.16b, #1

and v3.16b, v20.16b, v0.16b
and v4.16b, v16.16b, v0.16b
and v5.16b, v17.16b, v0.16b
and v6.16b, v18.16b, v0.16b

add v3.16b, v3.16b, v0.16b
add v5.16b, v5.16b, v0.16b

sub v20.16b, v3.16b, v4.16b
sub v16.16b, v5.16b, v6.16b

ushr v17.16b, v20.16b, #2
ushr v18.16b, v16.16b, #2

//extract 1
and v3.16b, v20.16b, v1.16b
and v4.16b, v16.16b, v1.16b
and v5.16b, v17.16b, v1.16b
and v6.16b, v18.16b, v1.16b

sub v3.16b, v3.16b, v2.16b
sub v4.16b, v4.16b, v2.16b
sub v5.16b, v5.16b, v2.16b
sub v6.16b, v6.16b, v2.16b

ushr v20.16b, v20.16b, #4
ushr v16.16b, v16.16b, #4
ushr v17.16b, v17.16b, #4
ushr v18.16b, v18.16b, #4

//extract 2
and  v7.16b, v20.16b, v1.16b
and v20.16b, v16.16b, v1.16b
and v21.16b, v17.16b, v1.16b
and v22.16b, v18.16b, v1.16b

sub  v7.16b,  v7.16b, v2.16b
sub v20.16b, v20.16b, v2.16b
sub v21.16b, v21.16b, v2.16b
sub v22.16b, v22.16b, v2.16b

//shuffles
trn1 v23.16b,  v3.16b,  v4.16b
trn1 v24.16b,  v5.16b,  v6.16b
trn1 v25.16b,  v7.16b, v20.16b
trn1 v26.16b, v21.16b, v22.16b

trn2 v27.16b,  v3.16b,  v4.16b
trn2 v16.16b,  v5.16b,  v6.16b
trn2 v17.16b,  v7.16b, v20.16b
trn2 v18.16b, v21.16b, v22.16b

trn1 v19.8h, v23.8h, v24.8h
trn1 v28.8h, v25.8h, v26.8h
trn1 v29.8h, v27.8h, v16.8h
trn1 v30.8h, v17.8h, v18.8h

trn2 v31.8h, v23.8h, v24.8h
trn2 v21.8h, v25.8h, v26.8h
trn2 v22.8h, v27.8h, v16.8h
trn2 v20.8h, v17.8h, v18.8h

trn1 v16.4s, v19.4s, v28.4s
trn1 v17.4s, v29.4s, v30.4s
trn1 v18.4s, v31.4s, v21.4s
trn1  v3.4s, v22.4s, v20.4s

trn2 v4.4s, v19.4s, v28.4s
trn2 v5.4s, v29.4s, v30.4s
trn2 v6.4s, v31.4s, v21.4s
trn2 v7.4s, v22.4s, v20.4s

//triple
//expand
smull v20.8h, v16.8b, v1.8b
smull v21.8h, v17.8b, v1.8b
smull v22.8h, v18.8b, v1.8b
smull v23.8h,  v3.8b, v1.8b

smull v24.8h, v4.8b, v1.8b
smull v25.8h, v5.8b, v1.8b
smull v26.8h, v6.8b, v1.8b
smull v27.8h, v7.8b, v1.8b

smull2 v16.8h, v16.16b, v1.16b
smull2 v17.8h, v17.16b, v1.16b
smull2 v18.8h, v18.16b, v1.16b
smull2 v19.8h,  v3.16b, v1.16b

smull2 v28.8h, v4.16b, v1.16b
smull2 v29.8h, v5.16b, v1.16b
smull2 v30.8h, v6.16b, v1.16b
smull2 v31.8h, v7.16b, v1.16b

//store
st1 {v20.8h - v23.8h}, [dst], #64
st1 {v24.8h - v27.8h}, [dst], #64
st1 {v16.8h - v19.8h}, [dst], #64
st1 {v28.8h - v31.8h}, [dst], #64

subs counter, counter, #256
b.ne NTRUPLUS_ASM_LOCAL(loop_cbd_triple)

.unreq dst
.unreq src
.unreq counter
.unreq taildst

ret
NTRUPLUS_ASM_END(poly_cbd1_triple)


NTRUPLUS_ASM_GNU_STACK
