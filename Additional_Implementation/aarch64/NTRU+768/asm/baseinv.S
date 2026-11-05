#include "asm.h"

.text

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
* Arguments:   - poly *r: output polynomial
*              - const poly *a: input polynomial with coefficients in (-q,q)
*
* Returns:     0 on success, 1 if the polynomial is not invertible.
*              The output is cleared on failure; stack scratch is always cleared.
**************************************************/
.balign 16
NTRUPLUS_ASM_START(poly_baseinv)

//stack
#ifdef NTRUPLUS_SUPERCOP
sub sp, sp, #800
#else
sub sp, sp, #736
#endif

//pointers
mov x15, x0
mov x2, x1
mov x9, sp
add x10, sp, #384
mov x1, x9


//baseinv_1
NTRUPLUS_ASM_LOAD_ADDRESS(x3, consts_base, 0)
ld1 {v0.8h}, [x3]

NTRUPLUS_ASM_LOAD_ADDRESS(x3, zetas, ZETAS_MUL_OFFSET)

mov x8, #1536

NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair):

//zeta
ldp q1, q2, [x3], #64

NTRUPLUS_ASM_LOCAL(looptop_baseinv_1):

//load
ld1 {v3.8h - v6.8h}, [x2], #64

//mul
sqrdmulh v17.8h,  v5.8h,   v2.8h
sqrdmulh v18.8h,  v6.8h,   v2.8h
mul       v7.8h,  v5.8h,   v1.8h //t0 = a[2]*zeta
mul      v16.8h,  v6.8h,   v1.8h //t1 = a[3]*zeta
mls       v7.8h, v17.8h, v0.h[0]
mls      v16.8h, v18.8h, v0.h[0]

//mul
//s0 = (a[0]*a[0] + a[2]*t0 - 2*a[1]*t1)/R (mod q)
//s1 = (a[1]*a[1] + a[3]*t1 - 2*a[0]*a[2])/R (mod q)
smull    v17.4s,  v3.4h,   v3.4h //a[0]*a[0]
smull2   v18.4s,  v3.8h,   v3.8h
smull    v19.4s,  v4.4h,   v4.4h //a[1]*a[1]
smull2   v20.4s,  v4.8h,   v4.8h
smlal    v17.4s,  v5.4h,   v7.4h //a[2]*t0
smlal2   v18.4s,  v5.8h,   v7.8h
smlal    v19.4s,  v6.4h,  v16.4h //a[3]*t1
smlal2   v20.4s,  v6.8h,  v16.8h
sqdmlsl  v17.4s,  v4.4h,  v16.4h //-2*a[1]*t1
sqdmlsl2 v18.4s,  v4.8h,  v16.8h
sqdmlsl  v19.4s,  v3.4h,   v5.4h //-2*a[0]*a[2]
sqdmlsl2 v20.4s,  v3.8h,   v5.8h
uzp1     v21.8h, v17.8h,  v18.8h
uzp1     v22.8h, v19.8h,  v20.8h
mul      v21.8h, v21.8h, v0.h[2]
mul      v22.8h, v22.8h, v0.h[2]
smlal    v17.4s, v21.4h, v0.h[0]
smlal2   v18.4s, v21.8h, v0.h[0]
smlal    v19.4s, v22.4h, v0.h[0]
smlal2   v20.4s, v22.8h, v0.h[0]
uzp2     v23.8h, v17.8h,  v18.8h //s0
uzp2     v24.8h, v19.8h,  v20.8h //s1

//mul
sqrdmulh v21.8h, v24.8h,   v2.8h
mul      v25.8h, v24.8h,   v1.8h //s2 = s1*zeta
mls      v25.8h, v21.8h, v0.h[0]

//mul
//det = (s0*s0 - s1*s2)/R (mod q)
smull  v17.4s, v23.4h,  v23.4h //s0*s0
smull2 v18.4s, v23.8h,  v23.8h
smlsl  v17.4s, v24.4h,  v25.4h //-s1*s2
smlsl2 v18.4s, v24.8h,  v25.8h
uzp1   v21.8h, v17.8h,  v18.8h
mul    v21.8h, v21.8h, v0.h[2]
smlal  v17.4s, v21.4h, v0.h[0]
smlal2 v18.4s, v21.8h, v0.h[0]
uzp2   v27.8h, v17.8h,  v18.8h //det

//store
str q27, [x1], #16

//mul
//num[0] = (a[0]*s0 + a[2]*s2)/R (mod q)
//num[1] = (a[3]*s2 + a[1]*s0)/R (mod q)
smull  v17.4s,  v3.4h,  v23.4h //a[0]*s0
smull2 v18.4s,  v3.8h,  v23.8h
smull  v19.4s,  v6.4h,  v25.4h //a[3]*s2
smull2 v20.4s,  v6.8h,  v25.8h
smlal  v17.4s,  v5.4h,  v25.4h //a[2]*s2
smlal2 v18.4s,  v5.8h,  v25.8h
smlal  v19.4s,  v4.4h,  v23.4h //a[1]*s0
smlal2 v20.4s,  v4.8h,  v23.8h
uzp1   v21.8h, v17.8h,  v18.8h
uzp1   v22.8h, v19.8h,  v20.8h
mul    v21.8h, v21.8h, v0.h[2]
mul    v22.8h, v22.8h, v0.h[2]
smlal  v17.4s, v21.4h, v0.h[0]
smlal2 v18.4s, v21.8h, v0.h[0]
smlal  v19.4s, v22.4h, v0.h[0]
smlal2 v20.4s, v22.8h, v0.h[0]
uzp2   v27.8h, v17.8h,  v18.8h //num[0]
uzp2   v28.8h, v19.8h,  v20.8h //num[1]

//store
st1 {v27.8h, v28.8h}, [x0], #32

//mul
//num[2] = (a[2]*s0 + a[0]*s1)/R (mod q)
//num[3] = (a[1]*s1 + a[3]*s0)/R (mod q)
smull  v17.4s,  v5.4h,  v23.4h //a[2]*s0
smull2 v18.4s,  v5.8h,  v23.8h
smull  v19.4s,  v4.4h,  v24.4h //a[1]*s1
smull2 v20.4s,  v4.8h,  v24.8h
smlal  v17.4s,  v3.4h,  v24.4h //a[0]*s1
smlal2 v18.4s,  v3.8h,  v24.8h
smlal  v19.4s,  v6.4h,  v23.4h //a[3]*s0
smlal2 v20.4s,  v6.8h,  v23.8h
uzp1   v21.8h, v17.8h,  v18.8h
uzp1   v22.8h, v19.8h,  v20.8h
mul    v21.8h, v21.8h, v0.h[2]
mul    v22.8h, v22.8h, v0.h[2]
smlal  v17.4s, v21.4h, v0.h[0]
smlal2 v18.4s, v21.8h, v0.h[0]
smlal  v19.4s, v22.4h, v0.h[0]
smlal2 v20.4s, v22.8h, v0.h[0]
uzp2   v27.8h, v17.8h,  v18.8h //num[2]
uzp2   v28.8h, v19.8h,  v20.8h //num[3]

//store
st1 {v27.8h, v28.8h}, [x0], #32

subs x8, x8, #64
tbz x8, #6, NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair_check)

neg v1.8h, v1.8h
neg v2.8h, v2.8h
b NTRUPLUS_ASM_LOCAL(looptop_baseinv_1)

NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair_check):
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_1_pair)


//product_chain
//load
ldr q1, [x9]
ldr q2, [x9, #128]
ldr q3, [x9, #256]

//store
str q1, [x10]
str q2, [x10, #112]
str q3, [x10, #224]

//pointers
add x0, x9, #16
add x1, x9, #144
add x2, x9, #272
add x3, x10, #16
add x4, x10, #128
add x5, x10, #240
mov x8, #6

NTRUPLUS_ASM_LOCAL(looptop_baseinv_product):

//load
ldr q4, [x0], #16
ldr q5, [x1], #16
ldr q6, [x2], #16

//premul
mul v23.8h, v4.8h, v0.h[7]
mul v24.8h, v5.8h, v0.h[7]
mul v25.8h, v6.8h, v0.h[7]

//mul
mul     v26.8h,  v1.8h,  v23.8h //x0 = x0*den0[i]
mul     v27.8h,  v2.8h,  v24.8h //x1 = x1*den1[i]
mul     v28.8h,  v3.8h,  v25.8h //x2 = x2*den2[i]
sqdmulh v29.8h,  v1.8h,   v4.8h
sqdmulh v30.8h,  v2.8h,   v5.8h
sqdmulh v31.8h,  v3.8h,   v6.8h
sqdmulh v26.8h, v26.8h, v0.h[0]
sqdmulh v27.8h, v27.8h, v0.h[0]
sqdmulh v28.8h, v28.8h, v0.h[0]
shsub    v1.8h, v29.8h,  v26.8h
shsub    v2.8h, v30.8h,  v27.8h
shsub    v3.8h, v31.8h,  v28.8h

//store
str q1, [x3], #16
str q2, [x4], #16
str q3, [x5], #16

subs x8, x8, #1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_product)

//load
ldr q4, [x0]
ldr q5, [x1]
ldr q6, [x2]

//premul
mul v23.8h, v4.8h, v0.h[7]
mul v24.8h, v5.8h, v0.h[7]
mul v25.8h, v6.8h, v0.h[7]

//mul
mul     v26.8h,  v1.8h,  v23.8h //x0 = x0*den0[last]
mul     v27.8h,  v2.8h,  v24.8h //x1 = x1*den1[last]
mul     v28.8h,  v3.8h,  v25.8h //x2 = x2*den2[last]
sqdmulh v29.8h,  v1.8h,   v4.8h
sqdmulh v30.8h,  v2.8h,   v5.8h
sqdmulh v31.8h,  v3.8h,   v6.8h
sqdmulh v26.8h, v26.8h, v0.h[0]
sqdmulh v27.8h, v27.8h, v0.h[0]
sqdmulh v28.8h, v28.8h, v0.h[0]
shsub    v1.8h, v29.8h,  v26.8h
shsub    v2.8h, v30.8h,  v27.8h
shsub    v3.8h, v31.8h,  v28.8h


//check_zero
umin v4.8h, v1.8h, v2.8h
umin v4.8h, v4.8h, v3.8h

uminv h4, v4.8h
umov w11, v4.h[0]
cmp w11, #0
cset w11, eq

#ifdef NTRUPLUS_SUPERCOP
//declassify
//request
str w11, [sp, #720]
add x4, sp, #728
mov w13, #0x0002
movk w13, #0x4d43, lsl #16
str x13, [x4]
add x14, sp, #720
str x14, [x4, #8]
mov x13, #4
str x13, [x4, #16]
stp xzr, xzr, [x4, #24]
str xzr, [x4, #40]

//execute request
mov x3, #0
ror x12, x12, #3
ror x12, x12, #13
ror x12, x12, #51
ror x12, x12, #61
orr x10, x10, x10
ldr w11, [sp, #720]
#endif
cbnz w11, NTRUPLUS_ASM_LOCAL(baseinv_fail)


//product_tree
//premul
mul v16.8h, v2.8h, v0.h[7]

//mul
mul     v27.8h,  v1.8h,  v16.8h //x01 = x0*x1
sqdmulh v26.8h,  v1.8h,   v2.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v4.8h, v26.8h,  v27.8h

//premul
mul v16.8h, v3.8h, v0.h[7]

//mul
mul     v27.8h,  v4.8h,  v16.8h //a = x01*x2
sqdmulh v26.8h,  v4.8h,   v3.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v5.8h, v26.8h,  v27.8h


//fqinv
//premul
mul v16.8h, v5.8h, v0.h[7]

//mul
mul     v27.8h,  v5.8h,  v16.8h //t0 = a*a
sqdmulh v26.8h,  v5.8h,   v5.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//scale
shl v6.8h, v6.8h, #4 //t0 = 16*t0

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v6.8h,  v16.8h //t0 = t0*t0 (100)
sqdmulh v26.8h,  v6.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v6.8h,  v16.8h //t0 = t0*t0 (1000)
sqdmulh v26.8h,  v6.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v6.8h,  v16.8h //t0 = t0*t0 (10000)
sqdmulh v26.8h,  v6.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v5.8h,  v16.8h //t1 = a*t0 (10001)
sqdmulh v26.8h,  v5.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v7.8h, v26.8h,  v27.8h

//mul
mul     v27.8h,  v6.8h,  v16.8h //t0 = t0*t0 (100000)
sqdmulh v26.8h,  v6.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v6.8h,  v16.8h //t0 = t0*t0 (1000000)
sqdmulh v26.8h,  v6.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v6.8h,  v16.8h //t0 = t0*t0 (10000000)
sqdmulh v26.8h,  v6.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v7.8h,  v16.8h //t1 = t1*t0 (10010001)
sqdmulh v26.8h,  v7.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v7.8h, v26.8h,  v27.8h

//mul
mul     v27.8h,  v7.8h,  v16.8h //t0 = t1*t0 (100010001)
sqdmulh v26.8h,  v7.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v7.8h,  v16.8h //t1 = t1*t0 (110100010)
sqdmulh v26.8h,  v7.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v7.8h, v26.8h,  v27.8h

//mul
mul     v27.8h,  v7.8h,  v16.8h //t1 = t1*t0 (1010110011)
sqdmulh v26.8h,  v7.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v7.8h, v26.8h,  v27.8h

//premul
mul v16.8h, v7.8h, v0.h[7]

//mul
mul     v27.8h,  v7.8h,  v16.8h //t0 = t1*t1 (10101100110)
sqdmulh v26.8h,  v7.8h,   v7.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//premul
mul v17.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v6.8h,  v17.8h //t0 = t0*t0 (101011001100)
sqdmulh v26.8h,  v6.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h

//mul
mul     v27.8h,  v6.8h,  v16.8h //inv = t0*t1 (110101111111)
sqdmulh v26.8h,  v6.8h,   v7.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v6.8h, v26.8h,  v27.8h


//recover_tree
//premul
mul v16.8h, v6.8h, v0.h[7]

//mul
mul     v27.8h,  v3.8h,  v16.8h //inv01 = x2*inv
sqdmulh v26.8h,  v3.8h,   v6.8h
sqdmulh v27.8h, v27.8h, v0.h[0]
shsub    v7.8h, v26.8h,  v27.8h

//premul
mul v17.8h, v7.8h, v0.h[7]

//mul
mul     v26.8h,  v2.8h,  v17.8h //inv0 = x1*inv01
mul     v27.8h,  v1.8h,  v17.8h //inv1 = x0*inv01
mul     v28.8h,  v4.8h,  v16.8h //inv2 = x01*inv
sqdmulh v29.8h,  v2.8h,   v7.8h
sqdmulh v30.8h,  v1.8h,   v7.8h
sqdmulh v31.8h,  v4.8h,   v6.8h
sqdmulh v26.8h, v26.8h, v0.h[0]
sqdmulh v27.8h, v27.8h, v0.h[0]
sqdmulh v28.8h, v28.8h, v0.h[0]
shsub   v18.8h, v29.8h,  v26.8h
shsub   v19.8h, v30.8h,  v27.8h
shsub   v20.8h, v31.8h,  v28.8h


//recover_chain
//pointers
add x0, x9, #112
add x1, x9, #240
add x2, x9, #368
add x3, x10, #96
add x4, x10, #208
add x5, x10, #320
mov x8, #7

NTRUPLUS_ASM_LOCAL(looptop_baseinv_2):

//load
ldr q1, [x0]
ldr q2, [x1]
ldr q3, [x2]
ldr q4, [x3], #-16
ldr q5, [x4], #-16
ldr q6, [x5], #-16

//premul
mul v23.8h, v18.8h, v0.h[7]
mul v24.8h, v19.8h, v0.h[7]
mul v25.8h, v20.8h, v0.h[7]

//mul
mul     v26.8h,  v4.8h,  v23.8h //den0[i] = pc0[i-1]*inv0
mul     v27.8h,  v5.8h,  v24.8h //den1[i] = pc1[i-1]*inv1
mul     v28.8h,  v6.8h,  v25.8h //den2[i] = pc2[i-1]*inv2
sqdmulh v29.8h,  v4.8h,  v18.8h
sqdmulh v30.8h,  v5.8h,  v19.8h
sqdmulh v31.8h,  v6.8h,  v20.8h
sqdmulh v26.8h, v26.8h, v0.h[0]
sqdmulh v27.8h, v27.8h, v0.h[0]
sqdmulh v28.8h, v28.8h, v0.h[0]
shsub    v4.8h, v29.8h,  v26.8h
shsub    v5.8h, v30.8h,  v27.8h
shsub    v6.8h, v31.8h,  v28.8h

//store
str q4, [x0], #-16
str q5, [x1], #-16
str q6, [x2], #-16

//mul
mul     v26.8h,  v1.8h,  v23.8h //inv0 = den0[i]*inv0
mul     v27.8h,  v2.8h,  v24.8h //inv1 = den1[i]*inv1
mul     v28.8h,  v3.8h,  v25.8h //inv2 = den2[i]*inv2
sqdmulh v29.8h,  v1.8h,  v18.8h
sqdmulh v30.8h,  v2.8h,  v19.8h
sqdmulh v31.8h,  v3.8h,  v20.8h
sqdmulh v26.8h, v26.8h, v0.h[0]
sqdmulh v27.8h, v27.8h, v0.h[0]
sqdmulh v28.8h, v28.8h, v0.h[0]
shsub   v18.8h, v29.8h,  v26.8h
shsub   v19.8h, v30.8h,  v27.8h
shsub   v20.8h, v31.8h,  v28.8h

subs x8, x8, #1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_2)

//store
str q18, [x0]
str q19, [x1]
str q20, [x2]


//finish
mov x0, x15
mov x1, x9
mov x8, #24

NTRUPLUS_ASM_LOCAL(looptop_baseinv_finish):

//load
ldr q1, [x1], #16
ld1 {v16.8h - v19.8h}, [x0]

//premul
neg v2.8h, v1.8h
mul v3.8h, v1.8h, v0.h[7]
neg v4.8h, v3.8h

//mul
mul     v20.8h, v16.8h,   v3.8h //r[0] = r[0]*den
mul     v21.8h, v17.8h,   v4.8h //r[1] = r[1]*(-den)
mul     v22.8h, v18.8h,   v3.8h //r[2] = r[2]*den
mul     v23.8h, v19.8h,   v4.8h //r[3] = r[3]*(-den)
sqdmulh v24.8h, v16.8h,   v1.8h
sqdmulh v25.8h, v17.8h,   v2.8h
sqdmulh v26.8h, v18.8h,   v1.8h
sqdmulh v27.8h, v19.8h,   v2.8h
sqdmulh v20.8h, v20.8h, v0.h[0]
sqdmulh v21.8h, v21.8h, v0.h[0]
sqdmulh v22.8h, v22.8h, v0.h[0]
sqdmulh v23.8h, v23.8h, v0.h[0]
shsub   v16.8h, v24.8h,  v20.8h
shsub   v17.8h, v25.8h,  v21.8h
shsub   v18.8h, v26.8h,  v22.8h
shsub   v19.8h, v27.8h,  v23.8h

//store
st1 {v16.8h - v19.8h}, [x0], #64

subs x8, x8, #1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_finish)
b NTRUPLUS_ASM_LOCAL(baseinv_clear_stack)

NTRUPLUS_ASM_LOCAL(baseinv_fail):

//clear_output
movi v1.16b, #0
mov x0, x15
mov x8, #48

NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_output):

//store
stp q1, q1, [x0], #32

subs x8, x8, #1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_output)

NTRUPLUS_ASM_LOCAL(baseinv_clear_stack):

//clear_stack
movi v1.16b, #0
mov x0, sp
#ifdef NTRUPLUS_SUPERCOP
mov x8, #6
#else
mov x8, #5
#endif

NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_stack):

//store
stp q1, q1, [x0], #32
stp q1, q1, [x0], #32
stp q1, q1, [x0], #32
stp q1, q1, [x0], #32

subs x8, x8, #1
b.ne NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_stack)

stp q1, q1, [x0], #32
#ifndef NTRUPLUS_SUPERCOP
stp q1, q1, [x0], #32
stp q1, q1, [x0], #32
#endif

#ifdef NTRUPLUS_SUPERCOP
add sp, sp, #800
#else
add sp, sp, #736
#endif
mov w0, w11
ret
NTRUPLUS_ASM_END(poly_baseinv)


NTRUPLUS_ASM_GNU_STACK
