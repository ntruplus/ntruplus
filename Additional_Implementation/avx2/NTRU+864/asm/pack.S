#include "asm.h"


.balign 32
NTRUPLUS_ASM_START(poly_tobytes)
vmovdqa NTRUPLUS_ASM_SYMBOL(16xv)(%rip), %ymm15
vmovdqa NTRUPLUS_ASM_SYMBOL(16xq)(%rip), %ymm14
lea 1728(%rsi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_tobytes):

//load
vmovdqa    (%rsi), %ymm0
vmovdqa  32(%rsi), %ymm1
vmovdqa  64(%rsi), %ymm2
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5

//reduce
vpmulhrsw %ymm15, %ymm0, %ymm6
vpmulhrsw %ymm15, %ymm1, %ymm7
vpmulhrsw %ymm15, %ymm2, %ymm8
vpmulhrsw %ymm15, %ymm3, %ymm9
vpmulhrsw %ymm15, %ymm4, %ymm10
vpmulhrsw %ymm15, %ymm5, %ymm11
vpmullw %ymm14, %ymm6,  %ymm6
vpmullw %ymm14, %ymm7,  %ymm7
vpmullw %ymm14, %ymm8,  %ymm8
vpmullw %ymm14, %ymm9,  %ymm9
vpmullw %ymm14, %ymm10, %ymm10
vpmullw %ymm14, %ymm11, %ymm11
vpsubw  %ymm6,  %ymm0,  %ymm0
vpsubw  %ymm7,  %ymm1,  %ymm1
vpsubw  %ymm8,  %ymm2,  %ymm2
vpsubw  %ymm9,  %ymm3,  %ymm3
vpsubw  %ymm10, %ymm4,  %ymm4
vpsubw  %ymm11, %ymm5,  %ymm5

//map
vpaddw  %ymm14, %ymm0,  %ymm6
vpaddw  %ymm14, %ymm1,  %ymm7
vpaddw  %ymm14, %ymm2,  %ymm8
vpaddw  %ymm14, %ymm3,  %ymm9
vpaddw  %ymm14, %ymm4, %ymm10
vpaddw  %ymm14, %ymm5, %ymm11
vpminuw  %ymm6, %ymm0,  %ymm0
vpminuw  %ymm7, %ymm1,  %ymm1
vpminuw  %ymm8, %ymm2,  %ymm2
vpminuw  %ymm9, %ymm3,  %ymm3
vpminuw %ymm10, %ymm4,  %ymm4
vpminuw %ymm11, %ymm5,  %ymm5

//pack
vpsllw       $12, %ymm1, %ymm6
vpor       %ymm0, %ymm6, %ymm6
vpsrlw        $4, %ymm1, %ymm7
vpsllw        $8, %ymm2, %ymm8
vpor       %ymm8, %ymm7, %ymm7
vpsrlw        $8, %ymm2, %ymm8
vpsllw        $4, %ymm3, %ymm9
vpor       %ymm9, %ymm8, %ymm8
vpsllw       $12, %ymm5, %ymm9
vpor       %ymm4, %ymm9, %ymm9
vpsrlw        $4, %ymm5, %ymm5

//shuffle
vpunpcklwd %ymm7, %ymm6, %ymm0
vpunpckhwd %ymm7, %ymm6, %ymm1
vpunpcklwd %ymm9, %ymm8, %ymm2
vpunpckhwd %ymm9, %ymm8, %ymm3

vpunpckldq %ymm2, %ymm0, %ymm6
vpunpckhdq %ymm2, %ymm0, %ymm7
vpunpckldq %ymm3, %ymm1, %ymm8
vpunpckhdq %ymm3, %ymm1, %ymm9

vpshufb    NTRUPLUS_ASM_LOCAL(pack96_masks)(%rip), %ymm6,  %ymm0
vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+32(%rip), %ymm5, %ymm10
vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+64(%rip), %ymm6,  %ymm1

vpshufb  NTRUPLUS_ASM_LOCAL(pack96_masks)+96(%rip), %ymm7,  %ymm6
vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+128(%rip), %ymm5, %ymm11
vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+160(%rip), %ymm7,  %ymm2

vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+192(%rip), %ymm8,  %ymm7
vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+224(%rip), %ymm5, %ymm12
vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+256(%rip), %ymm8,  %ymm3

vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+288(%rip), %ymm9,  %ymm8
vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+320(%rip), %ymm5, %ymm13
vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+352(%rip), %ymm9,  %ymm4
vpshufb NTRUPLUS_ASM_LOCAL(pack96_masks)+384(%rip), %ymm5,  %ymm9

vpor %ymm10, %ymm0, %ymm0
vpor  %ymm6, %ymm1, %ymm1
vpor %ymm11, %ymm1, %ymm1
vpor  %ymm7, %ymm2, %ymm2
vpor %ymm12, %ymm2, %ymm2
vpor  %ymm8, %ymm3, %ymm3
vpor %ymm13, %ymm3, %ymm3
vpor  %ymm9, %ymm4, %ymm4

vperm2i128 $0x20, %ymm1, %ymm0, %ymm6
vperm2i128 $0x20, %ymm3, %ymm2, %ymm7
vpermq      $0x4e, %ymm0, %ymm8
vpunpcklqdq %ymm8, %ymm4, %ymm8
vpalignr      $8, %ymm0, %ymm1, %ymm9
vpblendd   $0xf0, %ymm9, %ymm8, %ymm0

vpalignr      $8, %ymm1, %ymm2, %ymm8
vpalignr      $8, %ymm2, %ymm3, %ymm9
vperm2i128 $0x31, %ymm9, %ymm8, %ymm2
vpalignr      $8, %ymm3, %ymm4, %ymm8
vextracti128 $1, %ymm8, %xmm4

//store
vmovdqu %ymm6,    (%rdi)
vmovdqu %ymm7,  32(%rdi)
vmovdqu %ymm0,  64(%rdi)
vmovdqu %ymm2,  96(%rdi)
vmovdqu %xmm4, 128(%rdi)

add $192, %rsi
add $144, %rdi
cmp %r8, %rsi
jb NTRUPLUS_ASM_LOCAL(looptop_tobytes)

ret
NTRUPLUS_ASM_END(poly_tobytes)


.balign 32
NTRUPLUS_ASM_START(poly_frombytes)
vmovdqa NTRUPLUS_ASM_SYMBOL(low_mask)(%rip), %ymm15
vpxor %ymm14, %ymm14, %ymm14
lea 1728(%rdi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_frombytes):

//load
vmovdqu    (%rsi),  %xmm0
vmovdqu  16(%rsi),  %xmm1
vmovdqu  32(%rsi),  %xmm2
vmovdqu  48(%rsi),  %xmm3
vmovdqu  64(%rsi),  %xmm4
vmovq   136(%rsi), %xmm10

//shuffle
vinserti128 $1,  72(%rsi), %ymm0, %ymm0
vinserti128 $1,  88(%rsi), %ymm1, %ymm1
vinserti128 $1, 104(%rsi), %ymm2, %ymm2
vinserti128 $1, 120(%rsi), %ymm3, %ymm3
vinserti128 $1,    %xmm10, %ymm4, %ymm4

vpshufb    NTRUPLUS_ASM_LOCAL(unpack96_masks)(%rip), %ymm0,  %ymm6
vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+32(%rip), %ymm1, %ymm10

vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+64(%rip), %ymm1,  %ymm7
vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+96(%rip), %ymm2, %ymm11

vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+128(%rip), %ymm2,  %ymm8
vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+160(%rip), %ymm3, %ymm12

vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+192(%rip), %ymm3,  %ymm9
vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+224(%rip), %ymm4, %ymm13

vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+256(%rip), %ymm0, %ymm5
vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+288(%rip), %ymm1, %ymm0
vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+320(%rip), %ymm2, %ymm1
vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+352(%rip), %ymm3, %ymm2
vpshufb NTRUPLUS_ASM_LOCAL(unpack96_masks)+384(%rip), %ymm4, %ymm3

vpor %ymm10, %ymm6, %ymm6
vpor %ymm11, %ymm7, %ymm7
vpor %ymm12, %ymm8, %ymm8
vpor %ymm13, %ymm9, %ymm9
vpor  %ymm0, %ymm5, %ymm5
vpor  %ymm1, %ymm5, %ymm5
vpor  %ymm2, %ymm5, %ymm5
vpor  %ymm3, %ymm5, %ymm5

vpunpcklwd %ymm7, %ymm6, %ymm0
vpunpckhwd %ymm7, %ymm6, %ymm1
vpunpcklwd %ymm9, %ymm8, %ymm2
vpunpckhwd %ymm9, %ymm8, %ymm3

vpunpcklwd %ymm1, %ymm0, %ymm6
vpunpckhwd %ymm1, %ymm0, %ymm7
vpunpcklwd %ymm3, %ymm2, %ymm8
vpunpckhwd %ymm3, %ymm2, %ymm9

vpunpcklqdq  %ymm8, %ymm6,  %ymm0
vpunpckhqdq  %ymm8, %ymm6,  %ymm6
vpunpcklqdq  %ymm9, %ymm7,  %ymm8
vpunpckhqdq  %ymm9, %ymm7,  %ymm9
//unpack
vpsrlw         $12, %ymm0,  %ymm1
vpand       %ymm15, %ymm0,  %ymm0
vpsllw          $4, %ymm6, %ymm10
vpor        %ymm10, %ymm1,  %ymm1
vpand       %ymm15, %ymm1,  %ymm1

vpsrlw     $8, %ymm6,  %ymm2
vpsllw     $8, %ymm8, %ymm10
vpor   %ymm10, %ymm2,  %ymm2
vpand  %ymm15, %ymm2,  %ymm2

vpsrlw $4, %ymm8, %ymm3

vpand  %ymm15, %ymm9,  %ymm4
vpsllw     $4, %ymm5,  %ymm5
vpsrlw    $12, %ymm9, %ymm10
vpor   %ymm10, %ymm5,  %ymm5

//check
vpmaxuw %ymm1,  %ymm0,  %ymm6
vpmaxuw %ymm3,  %ymm2,  %ymm7
vpmaxuw %ymm5,  %ymm4,  %ymm8
vpmaxuw %ymm7,  %ymm6,  %ymm6
vpmaxuw %ymm8,  %ymm6,  %ymm6
vpmaxuw %ymm6, %ymm14, %ymm14

//store
vmovdqa %ymm0,    (%rdi)
vmovdqa %ymm1,  32(%rdi)
vmovdqa %ymm2,  64(%rdi)
vmovdqa %ymm3,  96(%rdi)
vmovdqa %ymm4, 128(%rdi)
vmovdqa %ymm5, 160(%rdi)

add $144, %rsi
add $192, %rdi
cmp %r8, %rdi
jb NTRUPLUS_ASM_LOCAL(looptop_frombytes)

//check
vpcmpgtw NTRUPLUS_ASM_SYMBOL(16xqm1)(%rip), %ymm14, %ymm14
vptest %ymm14, %ymm14
setnz %al
movzbl %al, %eax
ret
NTRUPLUS_ASM_END(poly_frombytes)


.balign 32
NTRUPLUS_ASM_LOCAL(pack96_masks):
.byte 0, 1, 2, 3, 4, 5, 6, 7, 128, 8, 9, 10, 11, 12, 13, 14
.byte 0, 1, 2, 3, 4, 5, 6, 7, 128, 8, 9, 10, 11, 12, 13, 14
.byte 128, 128, 128, 128, 128, 128, 128, 128, 0, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 128, 128, 0, 128, 128, 128, 128, 128, 128, 128
.byte 15, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 15, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 0, 1, 2, 3, 4, 5, 6, 7, 128, 8, 9, 10, 11, 12
.byte 128, 128, 0, 1, 2, 3, 4, 5, 6, 7, 128, 8, 9, 10, 11, 12
.byte 128, 2, 128, 128, 128, 128, 128, 128, 128, 128, 4, 128, 128, 128, 128, 128
.byte 128, 2, 128, 128, 128, 128, 128, 128, 128, 128, 4, 128, 128, 128, 128, 128
.byte 13, 14, 15, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 13, 14, 15, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 0, 1, 2, 3, 4, 5, 6, 7, 128, 8, 9, 10
.byte 128, 128, 128, 128, 0, 1, 2, 3, 4, 5, 6, 7, 128, 8, 9, 10
.byte 128, 128, 128, 6, 128, 128, 128, 128, 128, 128, 128, 128, 8, 128, 128, 128
.byte 128, 128, 128, 6, 128, 128, 128, 128, 128, 128, 128, 128, 8, 128, 128, 128
.byte 11, 12, 13, 14, 15, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 11, 12, 13, 14, 15, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 0, 1, 2, 3, 4, 5, 6, 7, 128, 8
.byte 128, 128, 128, 128, 128, 128, 0, 1, 2, 3, 4, 5, 6, 7, 128, 8
.byte 128, 128, 128, 128, 128, 10, 128, 128, 128, 128, 128, 128, 128, 128, 12, 128
.byte 128, 128, 128, 128, 128, 10, 128, 128, 128, 128, 128, 128, 128, 128, 12, 128
.byte 9, 10, 11, 12, 13, 14, 15, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 9, 10, 11, 12, 13, 14, 15, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 128, 14, 128, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 128, 14, 128, 128, 128, 128, 128, 128, 128, 128

.balign 32
NTRUPLUS_ASM_LOCAL(unpack96_masks):
.byte 0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 128
.byte 0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 128
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 0
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 0
.byte 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 128, 128, 128
.byte 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 0, 1, 2
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 0, 1, 2
.byte 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 128, 128, 128, 128, 128
.byte 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 0, 1, 2, 3, 4
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 0, 1, 2, 3, 4
.byte 6, 7, 8, 9, 10, 11, 12, 13, 15, 128, 128, 128, 128, 128, 128, 128
.byte 6, 7, 8, 9, 10, 11, 12, 13, 15, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 0, 1, 2, 3, 4, 5, 6
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 0, 1, 2, 3, 4, 5, 6
.byte 8, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 8, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 1, 128, 10, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 1, 128, 10, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 3, 128, 12, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 3, 128, 12, 128, 128, 128, 128, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 5, 128, 14, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 5, 128, 14, 128, 128, 128
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 7, 128
.byte 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 7, 128


NTRUPLUS_ASM_GNU_STACK