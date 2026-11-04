#include "asm.h"

NTRUPLUS_ASM_START(poly_basemul)
vmovdqa NTRUPLUS_ASM_SYMBOL(16xq)(%rip), %ymm0
lea NTRUPLUS_ASM_SYMBOL(zetas)+1888(%rip), %rcx

lea 1728(%rsi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_basemul):

//positive zeta
//load
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15
vmovdqa                             (%rsi),  %ymm1
vmovdqa                           32(%rsi),  %ymm3
vmovdqa                           64(%rsi),  %ymm5
vmovdqa                             (%rdx),  %ymm7
vmovdqa                           32(%rdx),  %ymm8
vmovdqa                           64(%rdx),  %ymm9

//premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

//const in X
//mul
vpmullw  %ymm6,  %ymm7, %ymm10
vpmullw  %ymm4,  %ymm8, %ymm12
vpmullw  %ymm2,  %ymm9, %ymm14
vpmulhw  %ymm5,  %ymm7, %ymm11
vpmulhw  %ymm3,  %ymm8, %ymm13
vpmulhw  %ymm1,  %ymm9, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

//store
vmovdqa %ymm10, 64(%rdi)

//const in zeta
//mul
vpmullw  %ymm2,  %ymm7, %ymm10
vpmullw  %ymm2,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm7, %ymm14
vpmulhw  %ymm1,  %ymm7, %ymm11
vpmulhw  %ymm1,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm7, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm12, %ymm14, %ymm11

//load zeta
vmovdqa   (%rcx), %ymm1
vmovdqa 32(%rcx), %ymm2

//mul
vpmullw  %ymm6,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm9, %ymm14
vpmullw  %ymm6,  %ymm9,  %ymm7
vpmulhw  %ymm5,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm9, %ymm15
vpmulhw  %ymm5,  %ymm9,  %ymm8
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw   %ymm7,  %ymm8,  %ymm7

//add
vpaddw %ymm12, %ymm14, %ymm12

//mul zeta
vpmullw %ymm1, %ymm12,  %ymm3
vpmullw %ymm1,  %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm0,  %ymm3,  %ymm3
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4,  %ymm7,  %ymm7

//add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm11,  %ymm7, %ymm11

//store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rdi
add $96, %rsi
add $96, %rdx

//negative zeta
//load
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15
vmovdqa                             (%rsi),  %ymm1
vmovdqa                           32(%rsi),  %ymm3
vmovdqa                           64(%rsi),  %ymm5
vmovdqa                             (%rdx),  %ymm7
vmovdqa                           32(%rdx),  %ymm8
vmovdqa                           64(%rdx),  %ymm9

//premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

//const in X
//mul
vpmullw  %ymm6,  %ymm7, %ymm10
vpmullw  %ymm4,  %ymm8, %ymm12
vpmullw  %ymm2,  %ymm9, %ymm14
vpmulhw  %ymm5,  %ymm7, %ymm11
vpmulhw  %ymm3,  %ymm8, %ymm13
vpmulhw  %ymm1,  %ymm9, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

//store
vmovdqa %ymm10, 64(%rdi)

//const in zeta
//mul
vpmullw  %ymm2,  %ymm7, %ymm10
vpmullw  %ymm2,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm7, %ymm14
vpmulhw  %ymm1,  %ymm7, %ymm11
vpmulhw  %ymm1,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm7, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm12, %ymm14, %ymm11

//load zeta
vmovdqa   (%rcx), %ymm1
vmovdqa 32(%rcx), %ymm2

//mul
vpmullw  %ymm6,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm9, %ymm14
vpmullw  %ymm6,  %ymm9,  %ymm7
vpmulhw  %ymm5,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm9, %ymm15
vpmulhw  %ymm5,  %ymm9,  %ymm8
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw   %ymm7,  %ymm8,  %ymm7

//add
vpaddw %ymm12, %ymm14, %ymm12

//mul zeta
vpmullw %ymm1, %ymm12,  %ymm3
vpmullw %ymm1,  %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm0,  %ymm3,  %ymm3
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4,  %ymm7,  %ymm7

//sub
vpsubw %ymm12, %ymm10, %ymm10
vpsubw  %ymm7, %ymm11, %ymm11

//store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rsi
add $96, %rdi
add $96, %rdx
add $64, %rcx
cmp %r8, %rsi
jb NTRUPLUS_ASM_LOCAL(looptop_basemul)

mov %rdi, %r8
sub $1728, %rdi

vmovdqa NTRUPLUS_ASM_SYMBOL(16xR2qinv)(%rip), %ymm15
vmovdqa     NTRUPLUS_ASM_SYMBOL(16xR2)(%rip),  %ymm1

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_basemul_2):

//load
vmovdqa   (%rdi), %ymm2
vmovdqa 32(%rdi), %ymm3
vmovdqa 64(%rdi), %ymm4

//mul
vpmullw %ymm15,  %ymm2, %ymm11
vpmullw %ymm15,  %ymm3, %ymm12
vpmullw %ymm15,  %ymm4, %ymm13
vpmulhw  %ymm1,  %ymm2,  %ymm2
vpmulhw  %ymm1,  %ymm3,  %ymm3
vpmulhw  %ymm1,  %ymm4,  %ymm4
vpmulhw  %ymm0, %ymm11, %ymm11
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm13, %ymm13
vpsubw  %ymm11,  %ymm2,  %ymm2
vpsubw  %ymm12,  %ymm3,  %ymm3
vpsubw  %ymm13,  %ymm4,  %ymm4

//store
vmovdqa %ymm2,   (%rdi)
vmovdqa %ymm3, 32(%rdi)
vmovdqa %ymm4, 64(%rdi)

add $96, %rdi
cmp %r8, %rdi
jb NTRUPLUS_ASM_LOCAL(looptop_basemul_2)

ret
NTRUPLUS_ASM_END(poly_basemul)


NTRUPLUS_ASM_START(poly_basemul_scaled)
vmovdqa NTRUPLUS_ASM_SYMBOL(16xq)(%rip), %ymm0
lea NTRUPLUS_ASM_SYMBOL(zetas)+1888(%rip), %rcx

lea 1728(%rsi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_basemul_scaled):

//positive zeta
//load
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15
vmovdqa                             (%rsi),  %ymm1
vmovdqa                           32(%rsi),  %ymm3
vmovdqa                           64(%rsi),  %ymm5
vmovdqa                             (%rdx),  %ymm7
vmovdqa                           32(%rdx),  %ymm8
vmovdqa                           64(%rdx),  %ymm9

//premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

//const in X
//mul
vpmullw  %ymm6,  %ymm7, %ymm10
vpmullw  %ymm4,  %ymm8, %ymm12
vpmullw  %ymm2,  %ymm9, %ymm14
vpmulhw  %ymm5,  %ymm7, %ymm11
vpmulhw  %ymm3,  %ymm8, %ymm13
vpmulhw  %ymm1,  %ymm9, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

//store
vmovdqa %ymm10, 64(%rdi)

//const in zeta
//mul
vpmullw  %ymm2,  %ymm7, %ymm10
vpmullw  %ymm2,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm7, %ymm14
vpmulhw  %ymm1,  %ymm7, %ymm11
vpmulhw  %ymm1,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm7, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm12, %ymm14, %ymm11

//load zeta
vmovdqa   (%rcx), %ymm1
vmovdqa 32(%rcx), %ymm2

//mul
vpmullw  %ymm6,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm9, %ymm14
vpmullw  %ymm6,  %ymm9,  %ymm7
vpmulhw  %ymm5,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm9, %ymm15
vpmulhw  %ymm5,  %ymm9,  %ymm8
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw   %ymm7,  %ymm8,  %ymm7

//add
vpaddw %ymm12, %ymm14, %ymm12

//mul zeta
vpmullw %ymm1, %ymm12,  %ymm3
vpmullw %ymm1,  %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm0,  %ymm3,  %ymm3
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4,  %ymm7,  %ymm7

//add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm11,  %ymm7, %ymm11

//store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rdi
add $96, %rsi
add $96, %rdx

//negative zeta
//load
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15
vmovdqa                             (%rsi),  %ymm1
vmovdqa                           32(%rsi),  %ymm3
vmovdqa                           64(%rsi),  %ymm5
vmovdqa                             (%rdx),  %ymm7
vmovdqa                           32(%rdx),  %ymm8
vmovdqa                           64(%rdx),  %ymm9

//premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

//const in X
//mul
vpmullw  %ymm6,  %ymm7, %ymm10
vpmullw  %ymm4,  %ymm8, %ymm12
vpmullw  %ymm2,  %ymm9, %ymm14
vpmulhw  %ymm5,  %ymm7, %ymm11
vpmulhw  %ymm3,  %ymm8, %ymm13
vpmulhw  %ymm1,  %ymm9, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

//store
vmovdqa %ymm10, 64(%rdi)

//const in zeta
//mul
vpmullw  %ymm2,  %ymm7, %ymm10
vpmullw  %ymm2,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm7, %ymm14
vpmulhw  %ymm1,  %ymm7, %ymm11
vpmulhw  %ymm1,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm7, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm12, %ymm14, %ymm11

//load zeta
vmovdqa   (%rcx), %ymm1
vmovdqa 32(%rcx), %ymm2

//mul
vpmullw  %ymm6,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm9, %ymm14
vpmullw  %ymm6,  %ymm9,  %ymm7
vpmulhw  %ymm5,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm9, %ymm15
vpmulhw  %ymm5,  %ymm9,  %ymm8
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw   %ymm7,  %ymm8,  %ymm7

//add
vpaddw %ymm12, %ymm14, %ymm12

//mul zeta
vpmullw %ymm1, %ymm12,  %ymm3
vpmullw %ymm1,  %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm0,  %ymm3,  %ymm3
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4,  %ymm7,  %ymm7

//sub
vpsubw %ymm12, %ymm10, %ymm10
vpsubw  %ymm7, %ymm11, %ymm11

//store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rsi
add $96, %rdi
add $96, %rdx
add $64, %rcx
cmp %r8, %rsi
jb NTRUPLUS_ASM_LOCAL(looptop_basemul_scaled)

ret
NTRUPLUS_ASM_END(poly_basemul_scaled)


NTRUPLUS_ASM_START(poly_basemul_add)
vmovdqa NTRUPLUS_ASM_SYMBOL(16xq)(%rip), %ymm0
lea NTRUPLUS_ASM_SYMBOL(zetas)+1888(%rip), %r9

lea 1728(%rsi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_basemul_add):

//positive zeta
//load
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15
vmovdqa                             (%rsi),  %ymm1
vmovdqa                           32(%rsi),  %ymm3
vmovdqa                           64(%rsi),  %ymm5
vmovdqa                             (%rdx),  %ymm7
vmovdqa                           32(%rdx),  %ymm8
vmovdqa                           64(%rdx),  %ymm9

//premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

//const in X
//mul
vpmullw  %ymm6,  %ymm7, %ymm10
vpmullw  %ymm4,  %ymm8, %ymm12
vpmullw  %ymm2,  %ymm9, %ymm14
vpmulhw  %ymm5,  %ymm7, %ymm11
vpmulhw  %ymm3,  %ymm8, %ymm13
vpmulhw  %ymm1,  %ymm9, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

//store
vmovdqa %ymm10, 64(%rdi)

//const in zeta
//mul
vpmullw  %ymm2,  %ymm7, %ymm10
vpmullw  %ymm2,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm7, %ymm14
vpmulhw  %ymm1,  %ymm7, %ymm11
vpmulhw  %ymm1,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm7, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm12, %ymm14, %ymm11

//load zeta
vmovdqa   (%r9), %ymm1
vmovdqa 32(%r9), %ymm2

//mul
vpmullw  %ymm6,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm9, %ymm14
vpmullw  %ymm6,  %ymm9,  %ymm7
vpmulhw  %ymm5,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm9, %ymm15
vpmulhw  %ymm5,  %ymm9,  %ymm8
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw   %ymm7,  %ymm8,  %ymm7

//add
vpaddw %ymm12, %ymm14, %ymm12

//mul zeta
vpmullw %ymm1, %ymm12,  %ymm3
vpmullw %ymm1,  %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm0,  %ymm3,  %ymm3
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4,  %ymm7,  %ymm7

//add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm11,  %ymm7, %ymm11

//store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rdi
add $96, %rsi
add $96, %rdx

//negative zeta
//load
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15
vmovdqa                             (%rsi),  %ymm1
vmovdqa                           32(%rsi),  %ymm3
vmovdqa                           64(%rsi),  %ymm5
vmovdqa                             (%rdx),  %ymm7
vmovdqa                           32(%rdx),  %ymm8
vmovdqa                           64(%rdx),  %ymm9

//premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

//const in X
//mul
vpmullw  %ymm6,  %ymm7, %ymm10
vpmullw  %ymm4,  %ymm8, %ymm12
vpmullw  %ymm2,  %ymm9, %ymm14
vpmulhw  %ymm5,  %ymm7, %ymm11
vpmulhw  %ymm3,  %ymm8, %ymm13
vpmulhw  %ymm1,  %ymm9, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

//store
vmovdqa %ymm10, 64(%rdi)

//const in zeta
//mul
vpmullw  %ymm2,  %ymm7, %ymm10
vpmullw  %ymm2,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm7, %ymm14
vpmulhw  %ymm1,  %ymm7, %ymm11
vpmulhw  %ymm1,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm7, %ymm15
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

//add
vpaddw %ymm12, %ymm14, %ymm11

//load zeta
vmovdqa   (%r9), %ymm1
vmovdqa 32(%r9), %ymm2

//mul
vpmullw  %ymm6,  %ymm8, %ymm12
vpmullw  %ymm4,  %ymm9, %ymm14
vpmullw  %ymm6,  %ymm9,  %ymm7
vpmulhw  %ymm5,  %ymm8, %ymm13
vpmulhw  %ymm3,  %ymm9, %ymm15
vpmulhw  %ymm5,  %ymm9,  %ymm8
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw   %ymm7,  %ymm8,  %ymm7

//add
vpaddw %ymm12, %ymm14, %ymm12

//mul zeta
vpmullw %ymm1, %ymm12,  %ymm3
vpmullw %ymm1,  %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm0,  %ymm3,  %ymm3
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4,  %ymm7,  %ymm7

//sub
vpsubw %ymm12, %ymm10, %ymm10
vpsubw  %ymm7, %ymm11, %ymm11

//store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rsi
add $96, %rdi
add $96, %rdx
add $64, %r9
cmp %r8, %rsi
jb NTRUPLUS_ASM_LOCAL(looptop_basemul_add)

mov %rdi, %r8
sub $1728, %rdi

vmovdqa NTRUPLUS_ASM_SYMBOL(16xR2qinv)(%rip), %ymm15
vmovdqa     NTRUPLUS_ASM_SYMBOL(16xR2)(%rip),  %ymm1

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_basemul_add_2):

//load
vmovdqa   (%rdi), %ymm2
vmovdqa 32(%rdi), %ymm3
vmovdqa 64(%rdi), %ymm4

//mul
vpmullw %ymm15,  %ymm2, %ymm11
vpmullw %ymm15,  %ymm3, %ymm12
vpmullw %ymm15,  %ymm4, %ymm13
vpmulhw  %ymm1,  %ymm2,  %ymm2
vpmulhw  %ymm1,  %ymm3,  %ymm3
vpmulhw  %ymm1,  %ymm4,  %ymm4
vpmulhw  %ymm0, %ymm11, %ymm11
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm13, %ymm13
vpsubw  %ymm11,  %ymm2,  %ymm2
vpsubw  %ymm12,  %ymm3,  %ymm3
vpsubw  %ymm13,  %ymm4,  %ymm4

//add
vpaddw   (%rcx), %ymm2, %ymm2
vpaddw 32(%rcx), %ymm3, %ymm3
vpaddw 64(%rcx), %ymm4, %ymm4

//store
vmovdqa %ymm2,   (%rdi)
vmovdqa %ymm3, 32(%rdi)
vmovdqa %ymm4, 64(%rdi)

add $96, %rdi
add $96, %rcx
cmp %r8, %rdi
jb NTRUPLUS_ASM_LOCAL(looptop_basemul_add_2)

ret
NTRUPLUS_ASM_END(poly_basemul_add)


NTRUPLUS_ASM_GNU_STACK
