#include "asm.h"

/*
 * References for poly_basemul and poly_basemul_add:
 *
 * [BHK+21] Hanno Becker, Vincent Hwang, Matthias J. Kannwischer,
 * Bo-Yin Yang, and Shang-Yi Yang,
 * "Neon NTT: Faster Dilithium, Kyber, and Saber
 * on Cortex-A72 and Apple M1", IACR Transactions on Cryptographic
 * Hardware and Embedded Systems, 2022(1), pp. 221-244.
 * https://doi.org/10.46586/tches.v2022.i1.221-244
 * Fixed-operand Shoup/Barrett multiplication is adapted to AVX2.
 *
 * [SUPERCOP] SUPERCOP 20261018,
 * crypto_kem/ntruplus864/avx2-opt/basemul_shoup.s.
 * https://bench.cr.yp.to/supercop/supercop-20261018.tar.xz
 * The 12-bit Shoup/Barrett factor setup and quotient accumulation
 * are adapted from this implementation.
 */

/*************************************************
* Name:        poly_basemul
*
* Description: Multiplies two polynomials in the NTT domain using
*              Shoup/Barrett multiplication, without Montgomery scaling.
*
* Arguments:   - poly *c: output polynomial; must not overlap a or b
*              - const poly *a: small input with coefficients in (-q,q)
*              - const poly *b: input with signed 16-bit coefficients
*
* Returns:     void
**************************************************/
NTRUPLUS_ASM_START(poly_basemul)
lea NTRUPLUS_ASM_SYMBOL(zetas)+1888(%rip), %r8
lea 1728(%rsi), %r10

//q
vmovdqa NTRUPLUS_ASM_SYMBOL(16xq)(%rip), %ymm0

//Shoup/Barrett multiplication
vmovdqa NTRUPLUS_ASM_SYMBOL(16xv27_signed)(%rip), %ymm12

.balign 16
NTRUPLUS_ASM_LOCAL(looptop_basemul):

//positive zeta
//load
vmovdqa   (%rsi), %ymm1
vmovdqa 32(%rsi), %ymm2
vmovdqa 64(%rsi), %ymm3

//premul
vpsllw        $3, %ymm1,  %ymm5
vpsllw        $3, %ymm2,  %ymm6
vpsllw        $3, %ymm3,  %ymm7
vpmulhrsw %ymm12, %ymm5,  %ymm8
vpmulhrsw %ymm12, %ymm6,  %ymm9
vpmulhrsw %ymm12, %ymm7, %ymm10
vpaddw     %ymm8, %ymm5,  %ymm5
vpaddw     %ymm9, %ymm6,  %ymm6
vpaddw    %ymm10, %ymm7,  %ymm7

//load zeta
vmovdqa   (%r8), %ymm14 //zeta*qinv
vmovdqa 32(%r8), %ymm13 //zeta

//mul
vpmullw     (%rdx),  %ymm1, %ymm15 //a[0]*b[0]
vpmullw   64(%rdx),  %ymm2,  %ymm9 //a[1]*b[2]
vpmullw   32(%rdx),  %ymm3, %ymm11 //a[2]*b[1]
vpmulhrsw   (%rdx),  %ymm5,  %ymm4
vpmulhrsw 64(%rdx),  %ymm6, %ymm10
vpmulhrsw 32(%rdx),  %ymm7,  %ymm8
vpaddw      %ymm11,  %ymm9,  %ymm9
vpaddw       %ymm8, %ymm10, %ymm10
vpmullw      %ymm0,  %ymm4,  %ymm4
vpmullw      %ymm0, %ymm10, %ymm10
vpsubw       %ymm4, %ymm15, %ymm15
vpsubw      %ymm10,  %ymm9,  %ymm9

//mul zeta
vpmullw %ymm14,  %ymm9, %ymm11
vpmulhw %ymm13,  %ymm9,  %ymm9
vpmulhw  %ymm0, %ymm11, %ymm11
vpsubw  %ymm11,  %ymm9,  %ymm9

//add
vpaddw %ymm15, %ymm9, %ymm9 //+a[0]*b[0]

//store
vmovdqa %ymm9, (%rdi)

//mul
vpmullw   32(%rdx),  %ymm1, %ymm15 //a[0]*b[1]
vpmullw     (%rdx),  %ymm2, %ymm11 //a[1]*b[0]
vpmullw   64(%rdx),  %ymm3,  %ymm9 //a[2]*b[2]
vpmulhrsw 32(%rdx),  %ymm5, %ymm10
vpmulhrsw   (%rdx),  %ymm6,  %ymm8
vpmulhrsw 64(%rdx),  %ymm7,  %ymm4
vpaddw      %ymm11, %ymm15, %ymm15
vpaddw       %ymm8, %ymm10, %ymm10
vpmullw      %ymm0, %ymm10, %ymm10
vpmullw      %ymm0,  %ymm4,  %ymm4
vpsubw      %ymm10, %ymm15, %ymm15
vpsubw       %ymm4,  %ymm9,  %ymm9

//mul zeta
vpmullw %ymm14,  %ymm9, %ymm11
vpmulhw %ymm13,  %ymm9,  %ymm9
vpmulhw  %ymm0, %ymm11, %ymm11
vpsubw  %ymm11,  %ymm9,  %ymm9

//add
vpaddw %ymm15, %ymm9, %ymm9 //+a[0]*b[1]+a[1]*b[0]

//store
vmovdqa %ymm9, 32(%rdi)

//mul
vpmullw   64(%rdx),  %ymm1,  %ymm9 //a[0]*b[2]
vpmullw   32(%rdx),  %ymm2, %ymm11 //a[1]*b[1]
vpmullw     (%rdx),  %ymm3,  %ymm4 //a[2]*b[0]
vpmulhrsw 64(%rdx),  %ymm5, %ymm10
vpmulhrsw 32(%rdx),  %ymm6,  %ymm8
vpmulhrsw   (%rdx),  %ymm7, %ymm15
vpaddw      %ymm11,  %ymm9,  %ymm9
vpaddw       %ymm4,  %ymm9,  %ymm9
vpaddw       %ymm8, %ymm10, %ymm10
vpaddw      %ymm15, %ymm10, %ymm10
vpmullw      %ymm0, %ymm10, %ymm10
vpsubw      %ymm10,  %ymm9,  %ymm9

//store
vmovdqa %ymm9, 64(%rdi)

add $96, %rsi
add $96, %rdx
add $96, %rdi

//negative zeta
//load
vmovdqa   (%rsi), %ymm1
vmovdqa 32(%rsi), %ymm2
vmovdqa 64(%rsi), %ymm3

//premul
vpsllw        $3, %ymm1,  %ymm5
vpsllw        $3, %ymm2,  %ymm6
vpsllw        $3, %ymm3,  %ymm7
vpmulhrsw %ymm12, %ymm5,  %ymm8
vpmulhrsw %ymm12, %ymm6,  %ymm9
vpmulhrsw %ymm12, %ymm7, %ymm10
vpaddw     %ymm8, %ymm5,  %ymm5
vpaddw     %ymm9, %ymm6,  %ymm6
vpaddw    %ymm10, %ymm7,  %ymm7

//load zeta
vmovdqa   (%r8), %ymm14 //zeta*qinv
vmovdqa 32(%r8), %ymm13 //zeta

//mul
vpmullw     (%rdx),  %ymm1, %ymm15 //a[0]*b[0]
vpmullw   64(%rdx),  %ymm2,  %ymm9 //a[1]*b[2]
vpmullw   32(%rdx),  %ymm3, %ymm11 //a[2]*b[1]
vpmulhrsw   (%rdx),  %ymm5,  %ymm4
vpmulhrsw 64(%rdx),  %ymm6, %ymm10
vpmulhrsw 32(%rdx),  %ymm7,  %ymm8
vpaddw      %ymm11,  %ymm9,  %ymm9
vpaddw       %ymm8, %ymm10, %ymm10
vpmullw      %ymm0,  %ymm4,  %ymm4
vpmullw      %ymm0, %ymm10, %ymm10
vpsubw       %ymm4, %ymm15, %ymm15
vpsubw      %ymm10,  %ymm9,  %ymm9

//mul -zeta
vpmullw %ymm14,  %ymm9, %ymm11
vpmulhw %ymm13,  %ymm9,  %ymm9
vpmulhw  %ymm0, %ymm11, %ymm11
vpsubw   %ymm9, %ymm11,  %ymm9

//add
vpaddw %ymm15, %ymm9, %ymm9 //+a[0]*b[0]

//store
vmovdqa %ymm9, (%rdi)

//mul
vpmullw   32(%rdx),  %ymm1, %ymm15 //a[0]*b[1]
vpmullw     (%rdx),  %ymm2, %ymm11 //a[1]*b[0]
vpmullw   64(%rdx),  %ymm3,  %ymm9 //a[2]*b[2]
vpmulhrsw 32(%rdx),  %ymm5, %ymm10
vpmulhrsw   (%rdx),  %ymm6,  %ymm8
vpmulhrsw 64(%rdx),  %ymm7,  %ymm4
vpaddw      %ymm11, %ymm15, %ymm15
vpaddw       %ymm8, %ymm10, %ymm10
vpmullw      %ymm0, %ymm10, %ymm10
vpmullw      %ymm0,  %ymm4,  %ymm4
vpsubw      %ymm10, %ymm15, %ymm15
vpsubw       %ymm4,  %ymm9,  %ymm9

//mul -zeta
vpmullw %ymm14,  %ymm9, %ymm11
vpmulhw %ymm13,  %ymm9,  %ymm9
vpmulhw  %ymm0, %ymm11, %ymm11
vpsubw   %ymm9, %ymm11,  %ymm9

//add
vpaddw %ymm15, %ymm9, %ymm9 //+a[0]*b[1]+a[1]*b[0]

//store
vmovdqa %ymm9, 32(%rdi)

//mul
vpmullw   64(%rdx),  %ymm1,  %ymm9 //a[0]*b[2]
vpmullw   32(%rdx),  %ymm2, %ymm11 //a[1]*b[1]
vpmullw     (%rdx),  %ymm3,  %ymm4 //a[2]*b[0]
vpmulhrsw 64(%rdx),  %ymm5, %ymm10
vpmulhrsw 32(%rdx),  %ymm6,  %ymm8
vpmulhrsw   (%rdx),  %ymm7, %ymm15
vpaddw      %ymm11,  %ymm9,  %ymm9
vpaddw       %ymm4,  %ymm9,  %ymm9
vpaddw       %ymm8, %ymm10, %ymm10
vpaddw      %ymm15, %ymm10, %ymm10
vpmullw      %ymm0, %ymm10, %ymm10
vpsubw      %ymm10,  %ymm9,  %ymm9

//store
vmovdqa %ymm9, 64(%rdi)

add $96, %rsi
add $96, %rdx
add $96, %rdi
add $64, %r8
cmp %r10, %rsi
jb NTRUPLUS_ASM_LOCAL(looptop_basemul)

ret
NTRUPLUS_ASM_END(poly_basemul)


/*************************************************
* Name:        poly_basemul_scaled
*
* Description: Multiplies two polynomials in the NTT domain using
*              Montgomery multiplication. The output is scaled by
*              R^-1, where R = 2^16.
*
* Arguments:   - poly *r: output polynomial; must not overlap a or b
*              - const poly *a: first input polynomial in the NTT domain
*              - const poly *b: second input polynomial in the NTT domain
*
* Returns:     void
**************************************************/
NTRUPLUS_ASM_START(poly_basemul_scaled)
lea NTRUPLUS_ASM_SYMBOL(zetas)+1888(%rip), %r8
lea 1728(%rsi), %r10

//q
vmovdqa NTRUPLUS_ASM_SYMBOL(16xq)(%rip), %ymm0

//qinv
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_basemul_scaled):

//positive zeta
//load
vmovdqa   (%rsi), %ymm1
vmovdqa 32(%rsi), %ymm2
vmovdqa 64(%rsi), %ymm3

//premul
vpmullw %ymm15, %ymm1, %ymm4 //a[0]*qinv
vpmullw %ymm15, %ymm2, %ymm5 //a[1]*qinv
vpmullw %ymm15, %ymm3, %ymm6 //a[2]*qinv

//load zeta
vmovdqa   (%r8), %ymm14 //zeta*qinv
vmovdqa 32(%r8), %ymm13 //zeta

//mul
vpmullw   (%rdx),  %ymm4,  %ymm7 //a[0]*b[0]
vpmullw 64(%rdx),  %ymm5,  %ymm8 //a[1]*b[2]
vpmullw 32(%rdx),  %ymm6,  %ymm9 //a[2]*b[1]
vpmulhw   (%rdx),  %ymm1, %ymm10
vpmulhw 64(%rdx),  %ymm2, %ymm11
vpmulhw 32(%rdx),  %ymm3, %ymm12
vpmulhw    %ymm0,  %ymm7,  %ymm7
vpmulhw    %ymm0,  %ymm8,  %ymm8
vpmulhw    %ymm0,  %ymm9,  %ymm9
vpsubw     %ymm7, %ymm10,  %ymm7
vpsubw     %ymm8, %ymm11,  %ymm8
vpsubw     %ymm9, %ymm12,  %ymm9

//add
vpaddw %ymm9, %ymm8, %ymm8 //+a[2]*b[1]

//mul zeta
vpmullw %ymm14, %ymm8, %ymm9 //zeta*(a[1]*b[2]+a[2]*b[1])
vpmulhw %ymm13, %ymm8, %ymm8
vpmulhw  %ymm0, %ymm9, %ymm9
vpsubw   %ymm9, %ymm8, %ymm8

//add
vpaddw %ymm8, %ymm7, %ymm7 //+zeta*(a[1]*b[2]+a[2]*b[1])

//store
vmovdqa %ymm7, (%rdi)

//mul
vpmullw 32(%rdx),  %ymm4,  %ymm7 //a[0]*b[1]
vpmullw   (%rdx),  %ymm5,  %ymm8 //a[1]*b[0]
vpmullw 64(%rdx),  %ymm6,  %ymm9 //a[2]*b[2]
vpmulhw 32(%rdx),  %ymm1, %ymm10
vpmulhw   (%rdx),  %ymm2, %ymm11
vpmulhw 64(%rdx),  %ymm3, %ymm12
vpmulhw    %ymm0,  %ymm7,  %ymm7
vpmulhw    %ymm0,  %ymm8,  %ymm8
vpmulhw    %ymm0,  %ymm9,  %ymm9
vpsubw     %ymm7, %ymm10,  %ymm7
vpsubw     %ymm8, %ymm11,  %ymm8
vpsubw     %ymm9, %ymm12,  %ymm9

//add
vpaddw %ymm8, %ymm7, %ymm7 //+a[1]*b[0]

//mul zeta
vpmullw %ymm14, %ymm9, %ymm8 //zeta*a[2]*b[2]
vpmulhw %ymm13, %ymm9, %ymm9
vpmulhw  %ymm0, %ymm8, %ymm8
vpsubw   %ymm8, %ymm9, %ymm9

//add
vpaddw %ymm9, %ymm7, %ymm7 //+zeta*a[2]*b[2]

//store
vmovdqa %ymm7, 32(%rdi)

//mul
vpmullw 64(%rdx),  %ymm4,  %ymm7 //a[0]*b[2]
vpmullw 32(%rdx),  %ymm5,  %ymm8 //a[1]*b[1]
vpmullw   (%rdx),  %ymm6,  %ymm9 //a[2]*b[0]
vpmulhw 64(%rdx),  %ymm1, %ymm10
vpmulhw 32(%rdx),  %ymm2, %ymm11
vpmulhw   (%rdx),  %ymm3, %ymm12
vpmulhw    %ymm0,  %ymm7,  %ymm7
vpmulhw    %ymm0,  %ymm8,  %ymm8
vpmulhw    %ymm0,  %ymm9,  %ymm9
vpsubw     %ymm7, %ymm10,  %ymm7
vpsubw     %ymm8, %ymm11,  %ymm8
vpsubw     %ymm9, %ymm12,  %ymm9

//add
vpaddw %ymm8, %ymm7, %ymm7 //+a[1]*b[1]
vpaddw %ymm9, %ymm7, %ymm7 //+a[2]*b[0]

//store
vmovdqa %ymm7, 64(%rdi)

add $96, %rsi
add $96, %rdx
add $96, %rdi

//negative zeta
//load
vmovdqa   (%rsi), %ymm1
vmovdqa 32(%rsi), %ymm2
vmovdqa 64(%rsi), %ymm3

//premul
vpmullw %ymm15, %ymm1, %ymm4 //a[0]*qinv
vpmullw %ymm15, %ymm2, %ymm5 //a[1]*qinv
vpmullw %ymm15, %ymm3, %ymm6 //a[2]*qinv

//mul
vpmullw   (%rdx),  %ymm4,  %ymm7 //a[0]*b[0]
vpmullw 64(%rdx),  %ymm5,  %ymm8 //a[1]*b[2]
vpmullw 32(%rdx),  %ymm6,  %ymm9 //a[2]*b[1]
vpmulhw   (%rdx),  %ymm1, %ymm10
vpmulhw 64(%rdx),  %ymm2, %ymm11
vpmulhw 32(%rdx),  %ymm3, %ymm12
vpmulhw    %ymm0,  %ymm7,  %ymm7
vpmulhw    %ymm0,  %ymm8,  %ymm8
vpmulhw    %ymm0,  %ymm9,  %ymm9
vpsubw     %ymm7, %ymm10,  %ymm7
vpsubw     %ymm8, %ymm11,  %ymm8
vpsubw     %ymm9, %ymm12,  %ymm9

//add
vpaddw %ymm9, %ymm8, %ymm8 //+a[2]*b[1]

//mul -zeta
vpmullw %ymm14, %ymm8, %ymm9 //-zeta*(a[1]*b[2]+a[2]*b[1])
vpmulhw %ymm13, %ymm8, %ymm8
vpmulhw  %ymm0, %ymm9, %ymm9
vpsubw   %ymm8, %ymm9, %ymm8

//add
vpaddw %ymm8, %ymm7, %ymm7 //-zeta*(a[1]*b[2]+a[2]*b[1])

//store
vmovdqa %ymm7, (%rdi)

//mul
vpmullw 32(%rdx),  %ymm4,  %ymm7 //a[0]*b[1]
vpmullw   (%rdx),  %ymm5,  %ymm8 //a[1]*b[0]
vpmullw 64(%rdx),  %ymm6,  %ymm9 //a[2]*b[2]
vpmulhw 32(%rdx),  %ymm1, %ymm10
vpmulhw   (%rdx),  %ymm2, %ymm11
vpmulhw 64(%rdx),  %ymm3, %ymm12
vpmulhw    %ymm0,  %ymm7,  %ymm7
vpmulhw    %ymm0,  %ymm8,  %ymm8
vpmulhw    %ymm0,  %ymm9,  %ymm9
vpsubw     %ymm7, %ymm10,  %ymm7
vpsubw     %ymm8, %ymm11,  %ymm8
vpsubw     %ymm9, %ymm12,  %ymm9

//add
vpaddw %ymm8, %ymm7, %ymm7 //+a[1]*b[0]

//mul -zeta
vpmullw %ymm14, %ymm9, %ymm8 //-zeta*a[2]*b[2]
vpmulhw %ymm13, %ymm9, %ymm9
vpmulhw  %ymm0, %ymm8, %ymm8
vpsubw   %ymm9, %ymm8, %ymm9

//add
vpaddw %ymm9, %ymm7, %ymm7 //-zeta*a[2]*b[2]

//store
vmovdqa %ymm7, 32(%rdi)

//mul
vpmullw 64(%rdx),  %ymm4,  %ymm7 //a[0]*b[2]
vpmullw 32(%rdx),  %ymm5,  %ymm8 //a[1]*b[1]
vpmullw   (%rdx),  %ymm6,  %ymm9 //a[2]*b[0]
vpmulhw 64(%rdx),  %ymm1, %ymm10
vpmulhw 32(%rdx),  %ymm2, %ymm11
vpmulhw   (%rdx),  %ymm3, %ymm12
vpmulhw    %ymm0,  %ymm7,  %ymm7
vpmulhw    %ymm0,  %ymm8,  %ymm8
vpmulhw    %ymm0,  %ymm9,  %ymm9
vpsubw     %ymm7, %ymm10,  %ymm7
vpsubw     %ymm8, %ymm11,  %ymm8
vpsubw     %ymm9, %ymm12,  %ymm9

//add
vpaddw %ymm8, %ymm7, %ymm7 //+a[1]*b[1]
vpaddw %ymm9, %ymm7, %ymm7 //+a[2]*b[0]

//store
vmovdqa %ymm7, 64(%rdi)

add $96, %rsi
add $96, %rdx
add $96, %rdi
add $64, %r8
cmp %r10, %rsi
jb NTRUPLUS_ASM_LOCAL(looptop_basemul_scaled)

ret
NTRUPLUS_ASM_END(poly_basemul_scaled)


/*************************************************
* Name:        poly_basemul_add
*
* Description: Computes c = a*b + m in the NTT domain using
*              Shoup/Barrett multiplication, without Montgomery scaling.
*
* Arguments:   - poly *c: output polynomial; must not overlap a or b
*              - const poly *a: canonical input with coefficients in [0,q)
*              - const poly *b: input with coefficient magnitudes <= 16722
*              - const poly *m: addend with coefficient magnitudes <= 16722
*
* Returns:     void
**************************************************/
NTRUPLUS_ASM_START(poly_basemul_add)
lea NTRUPLUS_ASM_SYMBOL(zetas)+1888(%rip), %r8
lea 1728(%rsi), %r10

//q
vmovdqa NTRUPLUS_ASM_SYMBOL(16xq)(%rip), %ymm0

//Shoup/Barrett multiplication
vmovdqa NTRUPLUS_ASM_SYMBOL(16xv27)(%rip), %ymm12

.balign 16
NTRUPLUS_ASM_LOCAL(looptop_basemul_add):

//positive zeta
//load
vmovdqa   (%rsi), %ymm1
vmovdqa 32(%rsi), %ymm2
vmovdqa 64(%rsi), %ymm3

//premul
vpsllw       $4, %ymm1, %ymm5
vpsllw       $4, %ymm2, %ymm6
vpsllw       $4, %ymm3, %ymm7
vpmulhuw %ymm12, %ymm5, %ymm5
vpmulhuw %ymm12, %ymm6, %ymm6
vpmulhuw %ymm12, %ymm7, %ymm7

//load zeta
vmovdqa   (%r8), %ymm14 //zeta*qinv
vmovdqa 32(%r8), %ymm13 //zeta

//mul
vpmullw     (%rdx),  %ymm1, %ymm15 //a[0]*b[0]
vpmullw   64(%rdx),  %ymm2,  %ymm9 //a[1]*b[2]
vpmullw   32(%rdx),  %ymm3, %ymm11 //a[2]*b[1]
vpmulhrsw   (%rdx),  %ymm5,  %ymm4
vpmulhrsw 64(%rdx),  %ymm6, %ymm10
vpmulhrsw 32(%rdx),  %ymm7,  %ymm8
vpaddw      %ymm11,  %ymm9,  %ymm9
vpaddw       %ymm8, %ymm10, %ymm10
vpmullw      %ymm0,  %ymm4,  %ymm4
vpmullw      %ymm0, %ymm10, %ymm10
vpsubw       %ymm4, %ymm15, %ymm15
vpsubw      %ymm10,  %ymm9,  %ymm9

//mul zeta
vpmullw %ymm14,  %ymm9, %ymm11
vpmulhw %ymm13,  %ymm9,  %ymm9
vpmulhw  %ymm0, %ymm11, %ymm11
vpsubw  %ymm11,  %ymm9,  %ymm9

//add
vpaddw %ymm15, %ymm9, %ymm9 //+a[0]*b[0]
vpaddw (%rcx), %ymm9, %ymm9 //+m[0]

//store
vmovdqa %ymm9, (%rdi)

//mul
vpmullw   32(%rdx),  %ymm1, %ymm15 //a[0]*b[1]
vpmullw     (%rdx),  %ymm2, %ymm11 //a[1]*b[0]
vpmullw   64(%rdx),  %ymm3,  %ymm9 //a[2]*b[2]
vpmulhrsw 32(%rdx),  %ymm5, %ymm10
vpmulhrsw   (%rdx),  %ymm6,  %ymm8
vpmulhrsw 64(%rdx),  %ymm7,  %ymm4
vpaddw      %ymm11, %ymm15, %ymm15
vpaddw       %ymm8, %ymm10, %ymm10
vpmullw      %ymm0, %ymm10, %ymm10
vpmullw      %ymm0,  %ymm4,  %ymm4
vpsubw      %ymm10, %ymm15, %ymm15
vpsubw       %ymm4,  %ymm9,  %ymm9

//mul zeta
vpmullw %ymm14,  %ymm9, %ymm11
vpmulhw %ymm13,  %ymm9,  %ymm9
vpmulhw  %ymm0, %ymm11, %ymm11
vpsubw  %ymm11,  %ymm9,  %ymm9

//add
vpaddw   %ymm15, %ymm9, %ymm9 //+a[0]*b[1]+a[1]*b[0]
vpaddw 32(%rcx), %ymm9, %ymm9 //+m[1]

//store
vmovdqa %ymm9, 32(%rdi)

//mul
vpmullw   64(%rdx),  %ymm1,  %ymm9 //a[0]*b[2]
vpmullw   32(%rdx),  %ymm2, %ymm11 //a[1]*b[1]
vpmullw     (%rdx),  %ymm3,  %ymm4 //a[2]*b[0]
vpmulhrsw 64(%rdx),  %ymm5, %ymm10
vpmulhrsw 32(%rdx),  %ymm6,  %ymm8
vpmulhrsw   (%rdx),  %ymm7, %ymm15
vpaddw      %ymm11,  %ymm9,  %ymm9
vpaddw       %ymm4,  %ymm9,  %ymm9
vpaddw       %ymm8, %ymm10, %ymm10
vpaddw      %ymm15, %ymm10, %ymm10
vpmullw      %ymm0, %ymm10, %ymm10
vpsubw      %ymm10,  %ymm9,  %ymm9

//add
vpaddw 64(%rcx), %ymm9, %ymm9 //+m[2]

//store
vmovdqa %ymm9, 64(%rdi)

add $96, %rsi
add $96, %rdx
add $96, %rcx
add $96, %rdi

//negative zeta
//load
vmovdqa   (%rsi), %ymm1
vmovdqa 32(%rsi), %ymm2
vmovdqa 64(%rsi), %ymm3

//premul
vpsllw       $4, %ymm1, %ymm5
vpsllw       $4, %ymm2, %ymm6
vpsllw       $4, %ymm3, %ymm7
vpmulhuw %ymm12, %ymm5, %ymm5
vpmulhuw %ymm12, %ymm6, %ymm6
vpmulhuw %ymm12, %ymm7, %ymm7

//load zeta
vmovdqa   (%r8), %ymm14 //zeta*qinv
vmovdqa 32(%r8), %ymm13 //zeta

//mul
vpmullw     (%rdx),  %ymm1, %ymm15 //a[0]*b[0]
vpmullw   64(%rdx),  %ymm2,  %ymm9 //a[1]*b[2]
vpmullw   32(%rdx),  %ymm3, %ymm11 //a[2]*b[1]
vpmulhrsw   (%rdx),  %ymm5,  %ymm4
vpmulhrsw 64(%rdx),  %ymm6, %ymm10
vpmulhrsw 32(%rdx),  %ymm7,  %ymm8
vpaddw      %ymm11,  %ymm9,  %ymm9
vpaddw       %ymm8, %ymm10, %ymm10
vpmullw      %ymm0,  %ymm4,  %ymm4
vpmullw      %ymm0, %ymm10, %ymm10
vpsubw       %ymm4, %ymm15, %ymm15
vpsubw      %ymm10,  %ymm9,  %ymm9

//mul -zeta
vpmullw %ymm14,  %ymm9, %ymm11
vpmulhw %ymm13,  %ymm9,  %ymm9
vpmulhw  %ymm0, %ymm11, %ymm11
vpsubw   %ymm9, %ymm11,  %ymm9

//add
vpaddw %ymm15, %ymm9, %ymm9 //+a[0]*b[0]
vpaddw (%rcx), %ymm9, %ymm9 //+m[0]

//store
vmovdqa %ymm9, (%rdi)

//mul
vpmullw   32(%rdx),  %ymm1, %ymm15 //a[0]*b[1]
vpmullw     (%rdx),  %ymm2, %ymm11 //a[1]*b[0]
vpmullw   64(%rdx),  %ymm3,  %ymm9 //a[2]*b[2]
vpmulhrsw 32(%rdx),  %ymm5, %ymm10
vpmulhrsw   (%rdx),  %ymm6,  %ymm8
vpmulhrsw 64(%rdx),  %ymm7,  %ymm4
vpaddw      %ymm11, %ymm15, %ymm15
vpaddw       %ymm8, %ymm10, %ymm10
vpmullw      %ymm0, %ymm10, %ymm10
vpmullw      %ymm0,  %ymm4,  %ymm4
vpsubw      %ymm10, %ymm15, %ymm15
vpsubw       %ymm4,  %ymm9,  %ymm9

//mul -zeta
vpmullw %ymm14,  %ymm9, %ymm11
vpmulhw %ymm13,  %ymm9,  %ymm9
vpmulhw  %ymm0, %ymm11, %ymm11
vpsubw   %ymm9, %ymm11,  %ymm9

//add
vpaddw   %ymm15, %ymm9, %ymm9 //+a[0]*b[1]+a[1]*b[0]
vpaddw 32(%rcx), %ymm9, %ymm9 //+m[1]

//store
vmovdqa %ymm9, 32(%rdi)

//mul
vpmullw   64(%rdx),  %ymm1,  %ymm9 //a[0]*b[2]
vpmullw   32(%rdx),  %ymm2, %ymm11 //a[1]*b[1]
vpmullw     (%rdx),  %ymm3,  %ymm4 //a[2]*b[0]
vpmulhrsw 64(%rdx),  %ymm5, %ymm10
vpmulhrsw 32(%rdx),  %ymm6,  %ymm8
vpmulhrsw   (%rdx),  %ymm7, %ymm15
vpaddw      %ymm11,  %ymm9,  %ymm9
vpaddw       %ymm4,  %ymm9,  %ymm9
vpaddw       %ymm8, %ymm10, %ymm10
vpaddw      %ymm15, %ymm10, %ymm10
vpmullw      %ymm0, %ymm10, %ymm10
vpsubw      %ymm10,  %ymm9,  %ymm9

//add
vpaddw 64(%rcx), %ymm9, %ymm9 //+m[2]

//store
vmovdqa %ymm9, 64(%rdi)

add $96, %rsi
add $96, %rdx
add $96, %rcx
add $96, %rdi
add $64, %r8
cmp %r10, %rsi
jb NTRUPLUS_ASM_LOCAL(looptop_basemul_add)

ret
NTRUPLUS_ASM_END(poly_basemul_add)


NTRUPLUS_ASM_GNU_STACK