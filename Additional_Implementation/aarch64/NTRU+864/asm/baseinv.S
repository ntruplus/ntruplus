#include "asm.h"

/*
 * References:
 *
 * [BHK+21] Hanno Becker, Vincent Hwang, Matthias J. Kannwischer,
 * Bo-Yin Yang, and Shang-Yi Yang,
 * "Neon NTT: Faster Dilithium, Kyber, and Saber
 * on Cortex-A72 and Apple M1", IACR Transactions on Cryptographic
 * Hardware and Embedded Systems, 2022(1), pp. 221-244.
 * https://doi.org/10.46586/tches.v2022.i1.221-244
 * Barrett multiplication (Algorithm 10) and accumulated Montgomery
 * reduction (Algorithm 14) are used in stage 1.
 *
 * [KCP26] Jonghyun Kim, Haehyun Cho, and Jong Hwan Park,
 * "Accelerating NTRU+ Key Generation via Hierarchical Batch Inversion",
 * Cryptology ePrint Archive, Paper 2026/1191, 2026.
 * https://eprint.iacr.org/2026/1191
 */

/*************************************************
* Name:        poly_baseinv
*
* Description: Inverts a polynomial in the NTT domain using three
*              product chains and one SIMD field inversion.
*
* Arguments:   - poly *r: output polynomial; may equal a
*              - const poly *a: input with coefficients in (-q,q)
*
* Returns:     0 on success, 1 on failure. Failure clears r. Both paths
*              clear every byte of the temporary workspace.
**************************************************/
.text
.balign 16
NTRUPLUS_ASM_START(poly_baseinv)

//stack
#ifdef NTRUPLUS_SUPERCOP
sub sp, sp, #1184
#else
sub sp, sp, #1120
#endif

//pointers
mov x15, x0
mov x13, sp
add x14, sp, #576
mov x2, x1
mov x1, x13


//baseinv_1
NTRUPLUS_ASM_LOAD_ADDRESS(x3, consts_base, 0)
ld1 {v0.8h}, [x3]

NTRUPLUS_ASM_LOAD_ADDRESS(x3, zetas, ZETAS_MUL_OFFSET)
mov x8, #1728

NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair):

//zeta
ldp q1, q2, [x3], #64

NTRUPLUS_ASM_LOCAL(looptop_baseinv_1):

//load
ld1 {v3.8h - v5.8h}, [x2], #48

//mul
mul       v6.8h,  v4.8h,   v1.8h //t0 = a[1]*zeta
mul       v7.8h,  v5.8h,   v1.8h //t1 = a[2]*zeta
sqrdmulh v22.8h,  v4.8h,   v2.8h
sqrdmulh v23.8h,  v5.8h,   v2.8h
mls       v6.8h, v22.8h, v0.h[0]
mls       v7.8h, v23.8h, v0.h[0]

//mul
//num0 = (a[0]*a[0] - a[1]*t1)/R (mod q)
//num1 = (a[2]*t1 - a[0]*a[1])/R (mod q)
//num2 = (a[1]*a[1] - a[0]*a[2])/R (mod q)
smull  v16.4s,  v3.4h,   v3.4h //a[0]*a[0]
smull2 v17.4s,  v3.8h,   v3.8h
smull  v18.4s,  v5.4h,   v7.4h //a[2]*t1
smull2 v19.4s,  v5.8h,   v7.8h
smull  v20.4s,  v4.4h,   v4.4h //a[1]*a[1]
smull2 v21.4s,  v4.8h,   v4.8h
smlsl  v16.4s,  v4.4h,   v7.4h //-a[1]*t1
smlsl2 v17.4s,  v4.8h,   v7.8h
smlsl  v18.4s,  v3.4h,   v4.4h //-a[0]*a[1]
smlsl2 v19.4s,  v3.8h,   v4.8h
smlsl  v20.4s,  v3.4h,   v5.4h //-a[0]*a[2]
smlsl2 v21.4s,  v3.8h,   v5.8h
uzp1   v22.8h, v16.8h,  v17.8h
uzp1   v23.8h, v18.8h,  v19.8h
uzp1   v24.8h, v20.8h,  v21.8h
mul    v22.8h, v22.8h, v0.h[2]
mul    v23.8h, v23.8h, v0.h[2]
mul    v24.8h, v24.8h, v0.h[2]
smlal  v16.4s, v22.4h, v0.h[0]
smlal2 v17.4s, v22.8h, v0.h[0]
smlal  v18.4s, v23.4h, v0.h[0]
smlal2 v19.4s, v23.8h, v0.h[0]
smlal  v20.4s, v24.4h, v0.h[0]
smlal2 v21.4s, v24.8h, v0.h[0]
uzp2   v25.8h, v16.8h,  v17.8h //num0
uzp2   v26.8h, v18.8h,  v19.8h //num1
uzp2   v27.8h, v20.8h,  v21.8h //num2

//mul
//det = (num0*a[0] + num1*t1 + num2*t0)/R (mod q)
smull  v16.4s, v25.4h,   v3.4h //num0*a[0]
smull2 v17.4s, v25.8h,   v3.8h
smlal  v16.4s, v26.4h,   v7.4h //num1*t1
smlal2 v17.4s, v26.8h,   v7.8h
smlal  v16.4s, v27.4h,   v6.4h //num2*t0
smlal2 v17.4s, v27.8h,   v6.8h
uzp1   v22.8h, v16.8h,  v17.8h
mul    v22.8h, v22.8h, v0.h[2]
smlal  v16.4s, v22.4h, v0.h[0]
smlal2 v17.4s, v22.8h, v0.h[0]
uzp2   v28.8h, v16.8h,  v17.8h //det

//store
st1 {v28.8h}, [x1], #16
st1 {v25.8h - v27.8h}, [x0], #48

subs x8, x8, #48
tbz x8, #4, NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair_check)

neg v1.8h, v1.8h
neg v2.8h, v2.8h
b NTRUPLUS_ASM_LOCAL(looptop_baseinv_1)

NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair_check):
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair)


//product_chain
//load
ldr q1, [x13]
ldr q2, [x13, #192]
ldr q3, [x13, #384]

//store
str q1, [x14]
str q2, [x14, #176]
str q3, [x14, #352]

//pointers
add x3, x13, #16
add x4, x13, #208
add x5, x13, #400
add x6, x14, #16
add x7, x14, #192
add x9, x14, #368
mov w10, #10

NTRUPLUS_ASM_LOCAL(looptop_baseinv_product):

//load
ldr q16, [x3], #16
ldr q17, [x4], #16
ldr q18, [x5], #16

//premul
mul v4.8h, v16.8h, v0.h[7]
mul v5.8h, v17.8h, v0.h[7]
mul v6.8h, v18.8h, v0.h[7]

//mul
sqdmulh v19.8h,  v1.8h,  v16.8h
sqdmulh v20.8h,  v2.8h,  v17.8h
sqdmulh v21.8h,  v3.8h,  v18.8h
mul     v22.8h,  v1.8h,   v4.8h //x0 = x0*den0[i]
mul     v23.8h,  v2.8h,   v5.8h //x1 = x1*den1[i]
mul     v24.8h,  v3.8h,   v6.8h //x2 = x2*den2[i]
sqdmulh v22.8h, v22.8h, v0.h[0]
sqdmulh v23.8h, v23.8h, v0.h[0]
sqdmulh v24.8h, v24.8h, v0.h[0]
shsub    v1.8h, v19.8h,  v22.8h
shsub    v2.8h, v20.8h,  v23.8h
shsub    v3.8h, v21.8h,  v24.8h

//store
str q1, [x6], #16
str q2, [x7], #16
str q3, [x9], #16

subs w10, w10, #1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_product)

//load
ldr q16, [x3]
ldr q17, [x4]
ldr q18, [x5]

//premul
mul v4.8h, v16.8h, v0.h[7]
mul v5.8h, v17.8h, v0.h[7]
mul v6.8h, v18.8h, v0.h[7]

//mul
sqdmulh v19.8h,  v1.8h,  v16.8h
sqdmulh v20.8h,  v2.8h,  v17.8h
sqdmulh v21.8h,  v3.8h,  v18.8h
mul     v22.8h,  v1.8h,   v4.8h //x0 = x0*den0[last]
mul     v23.8h,  v2.8h,   v5.8h //x1 = x1*den1[last]
mul     v24.8h,  v3.8h,   v6.8h //x2 = x2*den2[last]
sqdmulh v22.8h, v22.8h, v0.h[0]
sqdmulh v23.8h, v23.8h, v0.h[0]
sqdmulh v24.8h, v24.8h, v0.h[0]
shsub    v1.8h, v19.8h,  v22.8h
shsub    v2.8h, v20.8h,  v23.8h
shsub    v3.8h, v21.8h,  v24.8h


//check_zero
umin v16.8h,  v1.8h, v2.8h
umin v16.8h, v16.8h, v3.8h
uminv h16, v16.8h
umov w11, v16.h[0]
cmp w11, #0
cset w11, eq

#ifdef NTRUPLUS_SUPERCOP
//declassify
str w11, [sp, #1104]
add x4, sp, #1120
movz w9, #0x0002
movk w9, #0x4d43, lsl #16
str x9, [x4]
add x9, sp, #1104
str x9, [x4, #8]
mov x9, #4
str x9, [x4, #16]
stp xzr, xzr, [x4, #24]
str xzr, [x4, #40]

//execute request
mov x3, #0
ror x12, x12, #3
ror x12, x12, #13
ror x12, x12, #51
ror x12, x12, #61
orr x10, x10, x10
ldr w11, [sp, #1104]
#endif
cbnz w11, NTRUPLUS_ASM_LOCAL(baseinv_fail)


//product_tree
//mul
sqdmulh v18.8h,  v1.8h,   v2.8h
mul     v17.8h,  v1.8h,   v2.8h //x01 = x0*x1
mul     v17.8h, v17.8h, v0.h[7]
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v4.8h, v18.8h,  v17.8h

//mul
sqdmulh v18.8h,  v4.8h,   v3.8h
mul     v17.8h,  v4.8h,   v3.8h //a = x01*x2
mul     v17.8h, v17.8h, v0.h[7]
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v5.8h, v18.8h,  v17.8h


//fqinv
//mul
sqdmulh v18.8h,  v5.8h,   v5.8h
mul     v17.8h,  v5.8h,   v5.8h //t0 = a*a
mul     v17.8h, v17.8h, v0.h[7]
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v6.8h, v18.8h,  v17.8h

//scale
shl v6.8h, v6.8h, #4 //t0 = 16*t0

//mul
sqdmulh v18.8h,  v6.8h,   v6.8h
mul     v17.8h,  v6.8h,   v6.8h //t0 = t0*t0 (100)
mul     v17.8h, v17.8h, v0.h[7]
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v6.8h, v18.8h,  v17.8h

//mul
sqdmulh v18.8h,  v6.8h,   v6.8h
mul     v17.8h,  v6.8h,   v6.8h //t0 = t0*t0 (1000)
mul     v17.8h, v17.8h, v0.h[7]
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v6.8h, v18.8h,  v17.8h

//mul
sqdmulh v18.8h,  v6.8h,   v6.8h
mul     v17.8h,  v6.8h,   v6.8h //t0 = t0*t0 (10000)
mul     v17.8h, v17.8h, v0.h[7]
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v6.8h, v18.8h,  v17.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
sqdmulh v18.8h,  v5.8h,   v6.8h
sqdmulh v19.8h,  v6.8h,   v6.8h
mul     v17.8h,  v5.8h,  v16.8h //t1 = a*t0 (10001)
mul     v20.8h,  v6.8h,  v16.8h //t0 = t0*t0 (100000)
sqdmulh v17.8h, v17.8h, v0.h[0]
sqdmulh v20.8h, v20.8h, v0.h[0]
shsub    v7.8h, v18.8h,  v17.8h
shsub    v6.8h, v19.8h,  v20.8h

//mul
sqdmulh v18.8h,  v6.8h,   v6.8h
mul     v17.8h,  v6.8h,   v6.8h //t0 = t0*t0 (1000000)
mul     v17.8h, v17.8h, v0.h[7]
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v6.8h, v18.8h,  v17.8h

//mul
sqdmulh v18.8h,  v6.8h,   v6.8h
mul     v17.8h,  v6.8h,   v6.8h //t0 = t0*t0 (10000000)
mul     v17.8h, v17.8h, v0.h[7]
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v6.8h, v18.8h,  v17.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
sqdmulh v18.8h,  v7.8h,   v6.8h
mul     v17.8h,  v7.8h,  v16.8h //t1 = t1*t0 (10010001)
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v7.8h, v18.8h,  v17.8h

//mul
sqdmulh v18.8h,  v7.8h,   v6.8h
mul     v17.8h,  v7.8h,  v16.8h //t0 = t1*t0 (100010001)
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v6.8h, v18.8h,  v17.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
sqdmulh v18.8h,  v7.8h,   v6.8h
mul     v17.8h,  v7.8h,  v16.8h //t1 = t1*t0 (110100010)
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v7.8h, v18.8h,  v17.8h

//mul
sqdmulh v18.8h,  v7.8h,   v6.8h
mul     v17.8h,  v7.8h,  v16.8h //t1 = t1*t0 (1010110011)
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v7.8h, v18.8h,  v17.8h

//premul
mul v16.8h, v7.8h, v0.h[7]

//mul
sqdmulh v18.8h,  v7.8h,   v7.8h
mul     v17.8h,  v7.8h,  v16.8h //t0 = t1*t1 (10101100110)
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v6.8h, v18.8h,  v17.8h

//mul
sqdmulh v18.8h,  v6.8h,   v6.8h
mul     v17.8h,  v6.8h,   v6.8h //t0 = t0*t0 (101011001100)
mul     v17.8h, v17.8h, v0.h[7]
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v6.8h, v18.8h,  v17.8h

//mul
sqdmulh v18.8h,  v6.8h,   v7.8h
mul     v17.8h,  v6.8h,  v16.8h //inv = t0*t1 (110101111111)
sqdmulh v17.8h, v17.8h, v0.h[0]
shsub    v5.8h, v18.8h,  v17.8h


//recover_tree
//premul
mul v16.8h, v5.8h, v0.h[7]

//mul
sqdmulh v18.8h,  v4.8h,   v5.8h
sqdmulh v19.8h,  v3.8h,   v5.8h
mul     v17.8h,  v4.8h,  v16.8h //inv2 = x01*inv
mul     v20.8h,  v3.8h,  v16.8h //inv01 = x2*inv
sqdmulh v17.8h, v17.8h, v0.h[0]
sqdmulh v20.8h, v20.8h, v0.h[0]
shsub    v7.8h, v18.8h,  v17.8h
shsub    v6.8h, v19.8h,  v20.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
sqdmulh v18.8h,  v1.8h,   v6.8h
sqdmulh v19.8h,  v2.8h,   v6.8h
mul     v17.8h,  v1.8h,  v16.8h //inv1 = x0*inv01
mul     v20.8h,  v2.8h,  v16.8h //inv0 = x1*inv01
sqdmulh v17.8h, v17.8h, v0.h[0]
sqdmulh v20.8h, v20.8h, v0.h[0]
shsub    v4.8h, v18.8h,  v17.8h
shsub    v1.8h, v19.8h,  v20.8h

mov v2.16b, v4.16b
mov v3.16b, v7.16b


//recover_chain
//pointers
add x3, x13, #176
add x4, x13, #368
add x5, x13, #560
add x6, x14, #160
add x7, x14, #336
add x9, x14, #512
mov w10, #11

NTRUPLUS_ASM_LOCAL(looptop_baseinv_2):

//load
ldr q16, [x3]
ldr q17, [x4]
ldr q18, [x5]
ldr q25, [x6], #-16
ldr q26, [x7], #-16
ldr q27, [x9], #-16

//premul
mul v4.8h, v1.8h, v0.h[7]
mul v5.8h, v2.8h, v0.h[7]
mul v6.8h, v3.8h, v0.h[7]

//mul
sqdmulh v19.8h, v25.8h,   v1.8h
sqdmulh v20.8h, v26.8h,   v2.8h
sqdmulh v21.8h, v27.8h,   v3.8h
mul     v22.8h, v25.8h,   v4.8h //den0[i] = pc0[i-1]*inv0
mul     v23.8h, v26.8h,   v5.8h //den1[i] = pc1[i-1]*inv1
mul     v24.8h, v27.8h,   v6.8h //den2[i] = pc2[i-1]*inv2
sqdmulh v22.8h, v22.8h, v0.h[0]
sqdmulh v23.8h, v23.8h, v0.h[0]
sqdmulh v24.8h, v24.8h, v0.h[0]
shsub   v22.8h, v19.8h,  v22.8h
shsub   v23.8h, v20.8h,  v23.8h
shsub   v24.8h, v21.8h,  v24.8h

//store
str q22, [x3], #-16
str q23, [x4], #-16
str q24, [x5], #-16

//mul
sqdmulh v19.8h, v16.8h,   v1.8h
sqdmulh v20.8h, v17.8h,   v2.8h
sqdmulh v21.8h, v18.8h,   v3.8h
mul     v22.8h, v16.8h,   v4.8h //inv0 = den0[i]*inv0
mul     v23.8h, v17.8h,   v5.8h //inv1 = den1[i]*inv1
mul     v24.8h, v18.8h,   v6.8h //inv2 = den2[i]*inv2
sqdmulh v22.8h, v22.8h, v0.h[0]
sqdmulh v23.8h, v23.8h, v0.h[0]
sqdmulh v24.8h, v24.8h, v0.h[0]
shsub    v1.8h, v19.8h,  v22.8h
shsub    v2.8h, v20.8h,  v23.8h
shsub    v3.8h, v21.8h,  v24.8h

subs w10, w10, #1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_2)

//store
str q1, [x3]
str q2, [x4]
str q3, [x5]


//finish
//pointers
mov x0, x15
mov x1, x13
mov w10, #36

NTRUPLUS_ASM_LOCAL(looptop_baseinv_finish):

//load
ld1 {v1.8h - v3.8h}, [x0]
ldr q4, [x1], #16

//premul
mul v5.8h, v4.8h, v0.h[7]

//mul
sqdmulh v19.8h,  v1.8h,   v4.8h
sqdmulh v20.8h,  v2.8h,   v4.8h
sqdmulh v21.8h,  v3.8h,   v4.8h
mul     v22.8h,  v1.8h,   v5.8h //r[0]*den
mul     v23.8h,  v2.8h,   v5.8h //r[1]*den
mul     v24.8h,  v3.8h,   v5.8h //r[2]*den
sqdmulh v22.8h, v22.8h, v0.h[0]
sqdmulh v23.8h, v23.8h, v0.h[0]
sqdmulh v24.8h, v24.8h, v0.h[0]
shsub    v1.8h, v19.8h,  v22.8h
shsub    v2.8h, v20.8h,  v23.8h
shsub    v3.8h, v21.8h,  v24.8h

//store
st1 {v1.8h - v3.8h}, [x0], #48

subs w10, w10, #1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_finish)
b NTRUPLUS_ASM_LOCAL(baseinv_clear_stack)


NTRUPLUS_ASM_LOCAL(baseinv_fail):

//clear_output
movi v16.16b, #0
mov x0, x15
add x1, x15, #1728

NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_output):

//store
stp q16, q16, [x0], #32
cmp x0, x1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_output)


NTRUPLUS_ASM_LOCAL(baseinv_clear_stack):

//clear_stack
movi v16.16b, #0
mov x0, sp
#ifdef NTRUPLUS_SUPERCOP
mov x8, #9
#else
mov x8, #8
#endif

NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_stack):

//store
stp q16, q16, [x0], #32
stp q16, q16, [x0], #32
stp q16, q16, [x0], #32
stp q16, q16, [x0], #32

subs x8, x8, #1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_stack)

stp q16, q16, [x0], #32
#ifndef NTRUPLUS_SUPERCOP
stp q16, q16, [x0], #32
stp q16, q16, [x0], #32
#endif

mov w0, w11
#ifdef NTRUPLUS_SUPERCOP
add sp, sp, #1184
#else
add sp, sp, #1120
#endif
ret
NTRUPLUS_ASM_END(poly_baseinv)


NTRUPLUS_ASM_GNU_STACK
