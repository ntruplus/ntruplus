#include "asm.h"

/*
 * The fused level-0/radix-3 traversal follows the approach in
 * SUPERCOP 20261018, crypto_kem/ntruplus1152/avx2-opt/ntt.s.
 * The existing arithmetic and table layout are retained.
 */

NTRUPLUS_ASM_START(poly_ntt)
vmovdqa     NTRUPLUS_ASM_SYMBOL(16xq)(%rip), %ymm0
vmovdqa NTRUPLUS_ASM_SYMBOL(16xzeta1)(%rip), %ymm1
vmovdqa NTRUPLUS_ASM_SYMBOL(16xwqinv)(%rip), %ymm2
vmovdqa     NTRUPLUS_ASM_SYMBOL(16xw)(%rip), %ymm3
lea NTRUPLUS_ASM_SYMBOL(zetas)(%rip), %rdx

//level0+1
lea 384(%rdi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_start_01):

//load
vmovdqa     (%rdi),  %ymm8
vmovdqa  384(%rdi),  %ymm9
vmovdqa  768(%rdi), %ymm10
vmovdqa 1152(%rdi), %ymm11
vmovdqa 1536(%rdi), %ymm12
vmovdqa 1920(%rdi), %ymm13

//level0
// Input coefficients are in [-3,4].  The raw -722 product keeps this
// butterfly in [-2891,2896], so its Montgomery reduction is unnecessary.

//mul
vpmullw %ymm1, %ymm11, %ymm4
vpmullw %ymm1, %ymm12, %ymm5
vpmullw %ymm1, %ymm13, %ymm6

//update
vpsubw  %ymm4, %ymm11, %ymm11
vpsubw  %ymm5, %ymm12, %ymm12
vpsubw  %ymm6, %ymm13, %ymm13
vpaddw  %ymm8, %ymm11, %ymm11
vpaddw  %ymm9, %ymm12, %ymm12
vpaddw %ymm10, %ymm13, %ymm13
vpaddw  %ymm4,  %ymm8,  %ymm8
vpaddw  %ymm5,  %ymm9,  %ymm9
vpaddw  %ymm6, %ymm10, %ymm10

//level1
//zetas
vpbroadcastd  8(%rdx), %ymm4
vpbroadcastd 16(%rdx), %ymm5
vpbroadcastd 12(%rdx), %ymm6
vpbroadcastd 20(%rdx), %ymm7

//mul Ba, Ca^2
vpmullw %ymm4,  %ymm9, %ymm14
vpmullw %ymm5, %ymm10, %ymm15
vpmulhw %ymm6,  %ymm9,  %ymm9
vpmulhw %ymm7, %ymm10, %ymm10

//reduce
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14,  %ymm9,  %ymm9
vpsubw  %ymm15, %ymm10, %ymm10

//sub (Ba-Ca^2)
vpsubw %ymm10, %ymm9, %ymm14

//mul w(Ba-Ca^2)
vpmullw %ymm2, %ymm14, %ymm15
vpmulhw %ymm3, %ymm14, %ymm14

//reduce
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm15, %ymm14, %ymm14

//update
vpaddw  %ymm9,  %ymm8, %ymm15 //A + Ba
vpsubw %ymm10,  %ymm8,  %ymm4 //A - Ca^2
vpsubw  %ymm9,  %ymm8,  %ymm5 //A - Ba
vpaddw %ymm10, %ymm15, %ymm15 //A + Ba + Ca^2
vpaddw %ymm14,  %ymm4,  %ymm4 //A - Ca^2 + w(Ba-Ca^2)
vpsubw %ymm14,  %ymm5,  %ymm5 //A - Ba - w(Ba-Ca^2)

//store
vmovdqa %ymm15,    (%rdi)
vmovdqa  %ymm4, 384(%rdi)
vmovdqa  %ymm5, 768(%rdi)

//zetas
vpbroadcastd 24(%rdx), %ymm4
vpbroadcastd 32(%rdx), %ymm5
vpbroadcastd 28(%rdx), %ymm6
vpbroadcastd 36(%rdx), %ymm7

//mul Ba, Ca^2
vpmullw %ymm4, %ymm12, %ymm14
vpmullw %ymm5, %ymm13, %ymm15
vpmulhw %ymm6, %ymm12, %ymm12
vpmulhw %ymm7, %ymm13, %ymm13

//reduce
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14, %ymm12, %ymm12
vpsubw  %ymm15, %ymm13, %ymm13

//sub (Ba-Ca^2)
vpsubw %ymm13, %ymm12, %ymm14

//mul w(Ba-Ca^2)
vpmullw %ymm2, %ymm14, %ymm15
vpmulhw %ymm3, %ymm14, %ymm14

//reduce
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm15, %ymm14, %ymm14

//update
vpaddw %ymm12, %ymm11,  %ymm8 //A + Ba
vpsubw %ymm13, %ymm11,  %ymm9 //A - Ca^2
vpsubw %ymm12, %ymm11, %ymm10 //A - Ba
vpaddw %ymm13,  %ymm8,  %ymm8 //A + Ba + Ca^2
vpaddw %ymm14,  %ymm9,  %ymm9 //A - Ca^2 + w(Ba-Ca^2)
vpsubw %ymm14, %ymm10, %ymm10 //A - Ba - w(Ba-Ca^2)

//store
vmovdqa  %ymm8, 1152(%rdi)
vmovdqa  %ymm9, 1536(%rdi)
vmovdqa %ymm10, 1920(%rdi)

add $32, %rdi
cmp %r8, %rdi
jb NTRUPLUS_ASM_LOCAL(looptop_start_01)

sub $384, %rdi
add $32, %rdx
vmovdqa NTRUPLUS_ASM_SYMBOL(16xv)(%rip), %ymm1

//level 2
lea 2304(%rdi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_start_2):
//zetas
vpbroadcastd   8(%rdx), %ymm4 //ainv
vpbroadcastd  16(%rdx), %ymm5 //a^2inv
vpbroadcastd  12(%rdx), %ymm6 //a
vpbroadcastd  20(%rdx), %ymm7 //a^2

lea 128(%rdi), %r9

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_j_2):
//load
vmovdqa    (%rdi), %ymm8
vmovdqa 128(%rdi), %ymm9
vmovdqa 256(%rdi), %ymm10

//mul Ba, Ca^2
vpmullw %ymm4, %ymm9,  %ymm11
vpmullw %ymm5, %ymm10, %ymm12
vpmulhw %ymm6, %ymm9,  %ymm9
vpmulhw %ymm7, %ymm10, %ymm10

//reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm11, %ymm9,  %ymm9
vpsubw  %ymm12, %ymm10, %ymm10

//sub (Ba-Ca^2)
vpsubw %ymm10, %ymm9, %ymm11

//mul w(Ba-Ca^2)
vpmullw %ymm2, %ymm11, %ymm12
vpmulhw %ymm3, %ymm11, %ymm11

//reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm12, %ymm11, %ymm11

//update
vpaddw %ymm9,  %ymm8,  %ymm12 //A + Ba
vpsubw %ymm10, %ymm8,  %ymm13 //A - Ca^2
vpsubw %ymm9,  %ymm8,  %ymm14 //A - Ba
vpaddw %ymm10, %ymm12, %ymm12 //A + Ba + Ca^2
vpaddw %ymm11, %ymm13, %ymm13 //A - Ca^2 + w(Ba-Ca^2)
vpsubw %ymm11, %ymm14, %ymm14 //A - Ba - w(Ba-Ca^2)

//store
vmovdqa %ymm12,    (%rdi)
vmovdqa %ymm13, 128(%rdi)
vmovdqa %ymm14, 256(%rdi)

add $32, %rdi
cmp %r9, %rdi
jb  NTRUPLUS_ASM_LOCAL(looptop_j_2)

add $256, %rdi
add $16,  %rdx
cmp %r8,  %rdi
jb  NTRUPLUS_ASM_LOCAL(looptop_start_2)

sub $2304, %rdi

lea 2304(%rdi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_start_3456):
//load
vmovdqa    (%rdi), %ymm11
vmovdqa  32(%rdi), %ymm12
vmovdqa  64(%rdi), %ymm13
vmovdqa  96(%rdi), %ymm14
vmovdqa 128(%rdi), %ymm7
vmovdqa 160(%rdi), %ymm8
vmovdqa 192(%rdi), %ymm9
vmovdqa 224(%rdi), %ymm10

//level3
//zetas
vmovdqa 32(%rdx), %ymm15 //zetaqinv
vmovdqa 64(%rdx), %ymm2  //zeta

//shuffle
vperm2i128 $0x20, %ymm7,  %ymm11, %ymm3
vperm2i128 $0x31, %ymm7,  %ymm11, %ymm4
vperm2i128 $0x20, %ymm8,  %ymm12, %ymm5
vperm2i128 $0x31, %ymm8,  %ymm12, %ymm6
vperm2i128 $0x20, %ymm9,  %ymm13, %ymm7
vperm2i128 $0x31, %ymm9,  %ymm13, %ymm8
vperm2i128 $0x20, %ymm10, %ymm14, %ymm9
vperm2i128 $0x31, %ymm10, %ymm14, %ymm10

//mul
vpmullw %ymm15, %ymm7,  %ymm11
vpmullw %ymm15, %ymm8,  %ymm12
vpmullw %ymm15, %ymm9,  %ymm13
vpmullw %ymm15, %ymm10, %ymm14
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

//reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm7,  %ymm7
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9
vpsubw  %ymm14, %ymm10, %ymm10

//update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

//level4
//zetas
vmovdqa 608(%rdx), %ymm15 //zetaqinv
vmovdqa 640(%rdx), %ymm2  //zeta

//shuffle
vpunpcklqdq %ymm7,  %ymm11, %ymm3
vpunpckhqdq %ymm7,  %ymm11, %ymm4
vpunpcklqdq %ymm8,  %ymm12, %ymm5
vpunpckhqdq %ymm8,  %ymm12, %ymm6
vpunpcklqdq %ymm9,  %ymm13, %ymm7
vpunpckhqdq %ymm9,  %ymm13, %ymm8
vpunpcklqdq %ymm10, %ymm14, %ymm9
vpunpckhqdq %ymm10, %ymm14, %ymm10

//mul
vpmullw %ymm15, %ymm7,  %ymm11
vpmullw %ymm15, %ymm8,  %ymm12
vpmullw %ymm15, %ymm9,  %ymm13
vpmullw %ymm15, %ymm10, %ymm14
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

//reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm7,  %ymm7
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9
vpsubw  %ymm14, %ymm10, %ymm10

//update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

//level5
//zetas
vmovdqa 1184(%rdx), %ymm15 //zetaqinv
vmovdqa 1216(%rdx), %ymm2  //zeta

//shuffle
vpsllq   $32,   %ymm7,  %ymm3
vpsrlq   $32,   %ymm11, %ymm4
vpsllq   $32,   %ymm8,  %ymm5
vpsrlq   $32,   %ymm12, %ymm6
vpblendd $0xAA, %ymm3,  %ymm11, %ymm3
vpblendd $0xAA, %ymm7,  %ymm4,  %ymm4
vpblendd $0xAA, %ymm5,  %ymm12, %ymm5
vpblendd $0xAA, %ymm8,  %ymm6,  %ymm6
vpsllq   $32,   %ymm9,  %ymm7
vpsrlq   $32,   %ymm13, %ymm8
vpsllq   $32,   %ymm10, %ymm11
vpsrlq   $32,   %ymm14, %ymm12
vpblendd $0xAA, %ymm7,  %ymm13, %ymm7
vpblendd $0xAA, %ymm9,  %ymm8,  %ymm8
vpblendd $0xAA, %ymm11, %ymm14, %ymm9
vpblendd $0xAA, %ymm10, %ymm12, %ymm10

//mul
vpmullw %ymm15, %ymm7,  %ymm11
vpmullw %ymm15, %ymm8,  %ymm12
vpmullw %ymm15, %ymm9,  %ymm13
vpmullw %ymm15, %ymm10, %ymm14
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

//reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm7,  %ymm7
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9
vpsubw  %ymm14, %ymm10, %ymm10

//update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

//level6
//zetas
vmovdqa  1760(%rdx), %ymm15 //zetaqinv
vmovdqa  1792(%rdx), %ymm2  //zeta

//shuffle
vpsllq   $16,   %ymm7,  %ymm3
vpsrlq   $16,   %ymm11, %ymm4
vpsllq   $16,   %ymm8,  %ymm5
vpsrlq   $16,   %ymm12, %ymm6
vpblendw $0xAA, %ymm3,  %ymm11, %ymm3
vpblendw $0xAA, %ymm7,  %ymm4,  %ymm4
vpblendw $0xAA, %ymm5,  %ymm12, %ymm5
vpblendw $0xAA, %ymm8,  %ymm6,  %ymm6
vpsllq   $16,   %ymm9,  %ymm7
vpsrlq   $16,   %ymm13, %ymm8
vpsllq   $16,   %ymm10, %ymm11
vpsrlq   $16,   %ymm14, %ymm12
vpblendw $0xAA, %ymm7,  %ymm13, %ymm7
vpblendw $0xAA, %ymm9,  %ymm8,  %ymm8
vpblendw $0xAA, %ymm11, %ymm14, %ymm9
vpblendw $0xAA, %ymm10, %ymm12, %ymm10

//mul
vpmullw %ymm15, %ymm7,  %ymm11
vpmullw %ymm15, %ymm8,  %ymm12
vpmullw %ymm15, %ymm9,  %ymm13
vpmullw %ymm15, %ymm10, %ymm14
vpmulhw %ymm2,  %ymm7,   %ymm7
vpmulhw %ymm2,  %ymm8,   %ymm8
vpmulhw %ymm2,  %ymm9,   %ymm9
vpmulhw %ymm2,  %ymm10,  %ymm10

//reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm7,  %ymm7
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9
vpsubw  %ymm14, %ymm10, %ymm10

//update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

//reduce2
vpmulhrsw %ymm1, %ymm11, %ymm3
vpmulhrsw %ymm1, %ymm12, %ymm4
vpmulhrsw %ymm1, %ymm13, %ymm5
vpmulhrsw %ymm1, %ymm14, %ymm6
vpmullw %ymm0, %ymm3,  %ymm3
vpmullw %ymm0, %ymm4,  %ymm4
vpmullw %ymm0, %ymm5,  %ymm5
vpmullw %ymm0, %ymm6,  %ymm6
vpsubw  %ymm3, %ymm11, %ymm11
vpsubw  %ymm4, %ymm12, %ymm12
vpsubw  %ymm5, %ymm13, %ymm13
vpsubw  %ymm6, %ymm14, %ymm14

vpmulhrsw %ymm1, %ymm7,  %ymm3
vpmulhrsw %ymm1, %ymm8,  %ymm4
vpmulhrsw %ymm1, %ymm9,  %ymm5
vpmulhrsw %ymm1, %ymm10, %ymm6
vpmullw %ymm0, %ymm3,  %ymm3
vpmullw %ymm0, %ymm4,  %ymm4
vpmullw %ymm0, %ymm5,  %ymm5
vpmullw %ymm0, %ymm6,  %ymm6
vpsubw  %ymm3, %ymm7,  %ymm7
vpsubw  %ymm4, %ymm8,  %ymm8
vpsubw  %ymm5, %ymm9,  %ymm9
vpsubw  %ymm6, %ymm10, %ymm10

//store
vmovdqa %ymm11,    (%rdi)
vmovdqa %ymm12,  32(%rdi)
vmovdqa %ymm13,  64(%rdi)
vmovdqa %ymm14,  96(%rdi)
vmovdqa %ymm7,  128(%rdi)
vmovdqa %ymm8,  160(%rdi)
vmovdqa %ymm9,  192(%rdi)
vmovdqa %ymm10, 224(%rdi)

add $256, %rdi
add $64,  %rdx
cmp %r8,  %rdi
jb  NTRUPLUS_ASM_LOCAL(looptop_start_3456)

ret
NTRUPLUS_ASM_END(poly_ntt)


NTRUPLUS_ASM_GNU_STACK
