#include "asm.h"


.text
NTRUPLUS_ASM_START(poly_sotp_encode)
vmovdqa NTRUPLUS_ASM_SYMBOL(16x5555)(%rip), %ymm0
vmovdqa NTRUPLUS_ASM_SYMBOL(16x0303)(%rip), %ymm1
vmovdqa NTRUPLUS_ASM_SYMBOL(16x0101)(%rip), %ymm2

vmovdqu 112(%rsi), %ymm5
vmovdqu 112(%rdx), %ymm3
vmovdqu 256(%rdx), %ymm4

vpxor %ymm5, %ymm3, %ymm3

vpsrlw $1, %ymm3, %ymm5
vpsrlw $1, %ymm4, %ymm6

vpand %ymm0, %ymm3, %ymm3
vpand %ymm0, %ymm4, %ymm4
vpand %ymm0, %ymm5, %ymm5
vpand %ymm0, %ymm6, %ymm6

vpaddb %ymm0, %ymm3, %ymm3
vpaddb %ymm0, %ymm5, %ymm5

vpsubb %ymm4, %ymm3, %ymm7
vpsubb %ymm6, %ymm5, %ymm8

vpsrlw $2, %ymm7,  %ymm9
vpsrlw $2, %ymm8, %ymm10

vpand %ymm1,  %ymm7, %ymm3
vpand %ymm1,  %ymm8, %ymm4
vpand %ymm1,  %ymm9, %ymm5
vpand %ymm1, %ymm10, %ymm6

vpsubb %ymm2, %ymm3, %ymm3
vpsubb %ymm2, %ymm4, %ymm4
vpsubb %ymm2, %ymm5, %ymm5
vpsubb %ymm2, %ymm6, %ymm6

vpsrlw $4,  %ymm7,  %ymm7
vpsrlw $4,  %ymm8,  %ymm8
vpsrlw $4,  %ymm9,  %ymm9
vpsrlw $4, %ymm10, %ymm10

vpand %ymm1,  %ymm7,  %ymm7
vpand %ymm1,  %ymm8,  %ymm8
vpand %ymm1,  %ymm9,  %ymm9
vpand %ymm1, %ymm10, %ymm10

vpsubb %ymm2,  %ymm7,  %ymm7
vpsubb %ymm2,  %ymm8,  %ymm8
vpsubb %ymm2,  %ymm9,  %ymm9
vpsubb %ymm2, %ymm10, %ymm10

vpunpcklbw  %ymm4, %ymm3, %ymm11
vpunpcklbw  %ymm6, %ymm5, %ymm12
vpunpcklbw  %ymm8, %ymm7, %ymm13
vpunpcklbw %ymm10, %ymm9, %ymm14

vpunpckhbw  %ymm4, %ymm3, %ymm3
vpunpckhbw  %ymm6, %ymm5, %ymm4
vpunpckhbw  %ymm8, %ymm7, %ymm5
vpunpckhbw %ymm10, %ymm9, %ymm6

vpunpcklwd %ymm12, %ymm11,  %ymm7
vpunpcklwd %ymm14, %ymm13,  %ymm8
vpunpckhwd %ymm12, %ymm11,  %ymm9
vpunpckhwd %ymm14, %ymm13, %ymm10

vpunpcklwd %ymm4, %ymm3, %ymm11
vpunpcklwd %ymm6, %ymm5, %ymm12
vpunpckhwd %ymm4, %ymm3, %ymm13
vpunpckhwd %ymm6, %ymm5, %ymm14

vpunpckldq %ymm12, %ymm11, %ymm3
vpunpckhdq %ymm12, %ymm11, %ymm4
vpunpckldq %ymm14, %ymm13, %ymm5
vpunpckhdq %ymm14, %ymm13, %ymm6

vpunpckldq  %ymm8, %ymm7, %ymm11
vpunpckhdq  %ymm8, %ymm7, %ymm12
vpunpckldq %ymm10, %ymm9, %ymm13
vpunpckhdq %ymm10, %ymm9, %ymm14

vpmovsxbw %xmm3,  %ymm7
vpmovsxbw %xmm4,  %ymm8
vpmovsxbw %xmm5,  %ymm9
vpmovsxbw %xmm6, %ymm10

vmovdqa  %ymm7, 1920(%rdi)
vmovdqa  %ymm8, 1952(%rdi)
vmovdqa  %ymm9, 1984(%rdi)
vmovdqa %ymm10, 2016(%rdi)

vextracti128 $1, %ymm3,  %xmm7
vextracti128 $1, %ymm4,  %xmm8
vextracti128 $1, %ymm5,  %xmm9
vextracti128 $1, %ymm6, %xmm10

vpmovsxbw  %xmm7,  %ymm7
vpmovsxbw  %xmm8,  %ymm8
vpmovsxbw  %xmm9,  %ymm9
vpmovsxbw %xmm10, %ymm10

vmovdqa  %ymm7, 2176(%rdi)
vmovdqa  %ymm8, 2208(%rdi)
vmovdqa  %ymm9, 2240(%rdi)
vmovdqa %ymm10, 2272(%rdi)

vpmovsxbw %xmm11,  %ymm7
vpmovsxbw %xmm12,  %ymm8
vpmovsxbw %xmm13,  %ymm9
vpmovsxbw %xmm14, %ymm10

vmovdqu  %ymm7, 1792(%rdi)
vmovdqa  %ymm8, 1824(%rdi)
vmovdqu  %ymm9, 1856(%rdi)
vmovdqa %ymm10, 1888(%rdi)

vextracti128 $1, %ymm11,  %xmm7
vextracti128 $1, %ymm12,  %xmm8
vextracti128 $1, %ymm13,  %xmm9
vextracti128 $1, %ymm14, %xmm10

vpmovsxbw  %xmm7,  %ymm7
vpmovsxbw  %xmm8,  %ymm8
vpmovsxbw  %xmm9,  %ymm9
vpmovsxbw %xmm10, %ymm10

vmovdqu  %ymm7, 2048(%rdi)
vmovdqa  %ymm8, 2080(%rdi)
vmovdqu  %ymm9, 2112(%rdi)
vmovdqa %ymm10, 2144(%rdi)

lea 128(%rsi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_sotp_encode):
vmovdqu    (%rsi), %ymm5
vmovdqu    (%rdx), %ymm3
vmovdqu 144(%rdx), %ymm4

vpxor %ymm5, %ymm3, %ymm3

vpsrlw $1, %ymm3, %ymm5
vpsrlw $1, %ymm4, %ymm6

vpand %ymm0, %ymm3, %ymm3
vpand %ymm0, %ymm4, %ymm4
vpand %ymm0, %ymm5, %ymm5
vpand %ymm0, %ymm6, %ymm6

vpaddb %ymm0, %ymm3, %ymm3
vpaddb %ymm0, %ymm5, %ymm5

vpsubb %ymm4, %ymm3, %ymm7
vpsubb %ymm6, %ymm5, %ymm8

vpsrlw $2, %ymm7,  %ymm9
vpsrlw $2, %ymm8, %ymm10

vpand %ymm1,  %ymm7, %ymm3
vpand %ymm1,  %ymm8, %ymm4
vpand %ymm1,  %ymm9, %ymm5
vpand %ymm1, %ymm10, %ymm6

vpsubb %ymm2, %ymm3, %ymm3
vpsubb %ymm2, %ymm4, %ymm4
vpsubb %ymm2, %ymm5, %ymm5
vpsubb %ymm2, %ymm6, %ymm6

vpsrlw $4,  %ymm7,  %ymm7
vpsrlw $4,  %ymm8,  %ymm8
vpsrlw $4,  %ymm9,  %ymm9
vpsrlw $4, %ymm10, %ymm10

vpand %ymm1,  %ymm7,  %ymm7
vpand %ymm1,  %ymm8,  %ymm8
vpand %ymm1,  %ymm9,  %ymm9
vpand %ymm1, %ymm10, %ymm10

vpsubb %ymm2,  %ymm7,  %ymm7
vpsubb %ymm2,  %ymm8,  %ymm8
vpsubb %ymm2,  %ymm9,  %ymm9
vpsubb %ymm2, %ymm10, %ymm10

vpunpcklbw  %ymm4, %ymm3, %ymm11
vpunpcklbw  %ymm6, %ymm5, %ymm12
vpunpcklbw  %ymm8, %ymm7, %ymm13
vpunpcklbw %ymm10, %ymm9, %ymm14

vpunpckhbw  %ymm4, %ymm3, %ymm3
vpunpckhbw  %ymm6, %ymm5, %ymm4
vpunpckhbw  %ymm8, %ymm7, %ymm5
vpunpckhbw %ymm10, %ymm9, %ymm6

vpunpcklwd %ymm12, %ymm11,  %ymm7
vpunpcklwd %ymm14, %ymm13,  %ymm8
vpunpckhwd %ymm12, %ymm11,  %ymm9
vpunpckhwd %ymm14, %ymm13, %ymm10

vpunpcklwd %ymm4, %ymm3, %ymm11
vpunpcklwd %ymm6, %ymm5, %ymm12
vpunpckhwd %ymm4, %ymm3, %ymm13
vpunpckhwd %ymm6, %ymm5, %ymm14

vpunpckldq %ymm12, %ymm11, %ymm3
vpunpckhdq %ymm12, %ymm11, %ymm4
vpunpckldq %ymm14, %ymm13, %ymm5
vpunpckhdq %ymm14, %ymm13, %ymm6

vpunpckldq  %ymm8, %ymm7, %ymm11
vpunpckhdq  %ymm8, %ymm7, %ymm12
vpunpckldq %ymm10, %ymm9, %ymm13
vpunpckhdq %ymm10, %ymm9, %ymm14

vpmovsxbw %xmm3,  %ymm7
vpmovsxbw %xmm4,  %ymm8
vpmovsxbw %xmm5,  %ymm9
vpmovsxbw %xmm6, %ymm10

vmovdqa  %ymm7, 128(%rdi)
vmovdqa  %ymm8, 160(%rdi)
vmovdqa  %ymm9, 192(%rdi)
vmovdqa %ymm10, 224(%rdi)

vextracti128 $1, %ymm3,  %xmm7
vextracti128 $1, %ymm4,  %xmm8
vextracti128 $1, %ymm5,  %xmm9
vextracti128 $1, %ymm6, %xmm10

vpmovsxbw  %xmm7,  %ymm7
vpmovsxbw  %xmm8,  %ymm8
vpmovsxbw  %xmm9,  %ymm9
vpmovsxbw %xmm10, %ymm10

vmovdqa  %ymm7, 384(%rdi)
vmovdqa  %ymm8, 416(%rdi)
vmovdqa  %ymm9, 448(%rdi)
vmovdqa %ymm10, 480(%rdi)

vpmovsxbw %xmm11,  %ymm7
vpmovsxbw %xmm12,  %ymm8
vpmovsxbw %xmm13,  %ymm9
vpmovsxbw %xmm14, %ymm10

vmovdqa  %ymm7,  0(%rdi)
vmovdqa  %ymm8, 32(%rdi)
vmovdqa  %ymm9, 64(%rdi)
vmovdqa %ymm10, 96(%rdi)

vextracti128 $1, %ymm11,  %xmm7
vextracti128 $1, %ymm12,  %xmm8
vextracti128 $1, %ymm13,  %xmm9
vextracti128 $1, %ymm14, %xmm10

vpmovsxbw  %xmm7,  %ymm7
vpmovsxbw  %xmm8,  %ymm8
vpmovsxbw  %xmm9,  %ymm9
vpmovsxbw %xmm10, %ymm10

vmovdqa  %ymm7, 256(%rdi)
vmovdqa  %ymm8, 288(%rdi)
vmovdqa  %ymm9, 320(%rdi)
vmovdqa %ymm10, 352(%rdi)

add $32, %rsi
add $32, %rdx
add $512, %rdi
cmp %r8, %rsi
jb NTRUPLUS_ASM_LOCAL(looptop_sotp_encode)

ret
NTRUPLUS_ASM_END(poly_sotp_encode)


/*************************************************
* Name:        poly_sotp_decode
*
* Description: Decode a message deterministically using SOTP_INV and a random
*
* Arguments:   - uint8_t *msg: pointer to output message
*              - const poly *a: pointer to iput polynomial
*              - const uint8_t *buf: pointer to input random
*
* Returns 0 (success) or 1 (failure)
**************************************************/
NTRUPLUS_ASM_START(poly_sotp_decode)
mov %rdi, %rcx
vmovdqa NTRUPLUS_ASM_SYMBOL(16x0101)(%rip), %ymm13
vmovdqa NTRUPLUS_ASM_SYMBOL(16x5555)(%rip), %ymm14
vpcmpeqb %ymm15, %ymm15, %ymm15

    //tail
add $1792, %rsi
add $112, %rdx
add $112, %rdi

    //load
vmovdqa   0(%rsi), %ymm0
vmovdqa 128(%rsi), %ymm1
vmovdqa 256(%rsi), %ymm2
vmovdqa 384(%rsi), %ymm3
vmovdqa  32(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5
vmovdqa 288(%rsi), %ymm6
vmovdqa 416(%rsi), %ymm7

vpacksswb %ymm1, %ymm0, %ymm8
vpacksswb %ymm3, %ymm2, %ymm0
vpacksswb %ymm5, %ymm4, %ymm1
vpacksswb %ymm7, %ymm6, %ymm2

vmovdqa  64(%rsi),  %ymm3
vmovdqa 192(%rsi),  %ymm4
vmovdqa 320(%rsi),  %ymm5
vmovdqa 448(%rsi),  %ymm6
vmovdqa  96(%rsi),  %ymm7
vmovdqa 224(%rsi),  %ymm9
vmovdqa 352(%rsi), %ymm10
vmovdqa 480(%rsi), %ymm11

vpacksswb  %ymm4,  %ymm3, %ymm12
vpacksswb  %ymm6,  %ymm5,  %ymm3
vpacksswb  %ymm9,  %ymm7,  %ymm4
vpacksswb %ymm11, %ymm10,  %ymm5

vperm2i128 $0x20, %ymm0,  %ymm8, %ymm6
vperm2i128 $0x31, %ymm0,  %ymm8, %ymm7
vperm2i128 $0x20, %ymm2,  %ymm1, %ymm0
vperm2i128 $0x31, %ymm2,  %ymm1, %ymm8
vperm2i128 $0x20, %ymm3, %ymm12, %ymm1
vperm2i128 $0x31, %ymm3, %ymm12, %ymm2
vperm2i128 $0x20, %ymm5,  %ymm4, %ymm3
vperm2i128 $0x31, %ymm5,  %ymm4, %ymm9

vpsllq $32, %ymm1,  %ymm4
vpsrlq $32, %ymm6,  %ymm5
vpsllq $32, %ymm2, %ymm10
vpsrlq $32, %ymm7, %ymm11

vpblendd $0xaa,  %ymm4, %ymm6, %ymm12
vpblendd $0x55,  %ymm5, %ymm1,  %ymm4
vpblendd $0xaa, %ymm10, %ymm7,  %ymm1
vpblendd $0x55, %ymm11, %ymm2,  %ymm5

vpsllq $32, %ymm3,  %ymm2
vpsrlq $32, %ymm0,  %ymm6
vpsllq $32, %ymm9,  %ymm7
vpsrlq $32, %ymm8, %ymm10

vpblendd $0xaa,  %ymm2, %ymm0, %ymm11
vpblendd $0x55,  %ymm6, %ymm3,  %ymm0
vpblendd $0xaa,  %ymm7, %ymm8,  %ymm2
vpblendd $0x55, %ymm10, %ymm9,  %ymm3

vpslld $16, %ymm11, %ymm6
vpsrld $16, %ymm12, %ymm7
vpslld $16,  %ymm0, %ymm8
vpsrld $16,  %ymm4, %ymm9

vpblendw $0xaa, %ymm6, %ymm12, %ymm10
vpblendw $0x55, %ymm7, %ymm11,  %ymm6
vpblendw $0xaa, %ymm8,  %ymm4,  %ymm7
vpblendw $0x55, %ymm9,  %ymm0,  %ymm4

vpslld $16, %ymm2,  %ymm0
vpsrld $16, %ymm1,  %ymm8
vpslld $16, %ymm3,  %ymm9
vpsrld $16, %ymm5, %ymm11

vpblendw $0xaa,  %ymm0, %ymm1, %ymm12
vpblendw $0x55,  %ymm8, %ymm2,  %ymm0
vpblendw $0xaa,  %ymm9, %ymm5,  %ymm1
vpblendw $0x55, %ymm11, %ymm3,  %ymm2

vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_lo)(%rip), %ymm10, %ymm3
vpsllw                                     $8, %ymm12, %ymm5
vpsrlw                                     $8, %ymm10, %ymm8
vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_hi)(%rip), %ymm12, %ymm9

vpxor %ymm5, %ymm3, %ymm10
vpxor %ymm9, %ymm8,  %ymm3

vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_lo)(%rip), %ymm6, %ymm5
vpsllw                                     $8, %ymm0, %ymm8
vpsrlw                                     $8, %ymm6, %ymm9
vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_hi)(%rip), %ymm0, %ymm6

vpxor %ymm8, %ymm5, %ymm0
vpxor %ymm6, %ymm9, %ymm5

vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_lo)(%rip), %ymm7, %ymm6
vpsllw                                     $8, %ymm1, %ymm8
vpsrlw                                     $8, %ymm7, %ymm9
vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_hi)(%rip), %ymm1, %ymm7

vpxor %ymm8, %ymm6, %ymm1
vpxor %ymm7, %ymm9, %ymm6

vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_lo)(%rip), %ymm4, %ymm7
vpsllw                                     $8, %ymm2, %ymm8
vpsrlw                                     $8, %ymm4, %ymm9
vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_hi)(%rip), %ymm2, %ymm4

vpxor %ymm8, %ymm7, %ymm2
vpxor %ymm4, %ymm9, %ymm7

vpaddb %ymm13, %ymm10, %ymm4
vpaddb %ymm13,  %ymm3, %ymm8
vpaddb %ymm13,  %ymm0, %ymm3
vpaddb %ymm13,  %ymm5, %ymm0
vpaddb %ymm13,  %ymm1, %ymm5
vpaddb %ymm13,  %ymm6, %ymm1
vpaddb %ymm13,  %ymm2, %ymm6
vpaddb %ymm13,  %ymm7, %ymm2

vpsllw $2, %ymm3, %ymm7
vpsllw $2, %ymm0, %ymm3
vpsllw $4, %ymm5, %ymm0
vpsllw $4, %ymm1, %ymm5
vpsllw $6, %ymm6, %ymm1
vpsllw $6, %ymm2, %ymm6

vpxor %ymm7, %ymm4, %ymm2
vpxor %ymm3, %ymm8, %ymm4
vpxor %ymm1, %ymm0, %ymm3
vpxor %ymm6, %ymm5, %ymm0

vpxor %ymm3, %ymm2, %ymm1
vpxor %ymm0, %ymm4, %ymm2

vmovdqu NTRUPLUS_N/8(%rdx), %ymm0
vpsrlw $1, %ymm0, %ymm3

vpand %ymm14, %ymm0, %ymm4
vpand %ymm14, %ymm3, %ymm0

vpaddb %ymm4, %ymm1, %ymm3
vpaddb %ymm0, %ymm2, %ymm1

    //check
vpsrlw $1, %ymm3, %ymm0
vpsrlw $1, %ymm1, %ymm2

vpxor %ymm0, %ymm3, %ymm4
vpxor %ymm2, %ymm1, %ymm0

vpand %ymm0,  %ymm4,  %ymm2
vpand %ymm2, %ymm15, %ymm15

    //decode
vpand  %ymm14, %ymm3, %ymm0
vpand  %ymm14, %ymm1, %ymm2
vpsllw     $1, %ymm2, %ymm1

vpxor                                 %ymm1, %ymm0, %ymm2
vpxor NTRUPLUS_ASM_LOCAL(sotp_maskff)(%rip), %ymm2, %ymm0

vmovdqu (%rdx), %ymm1

vpxor %ymm1, %ymm0, %ymm2

vmovdqu %ymm2, (%rdi)
sub $1792, %rsi
sub $112, %rdx
sub $112, %rdi

lea 128(%rdi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_sotp_decode):

    //load
vmovdqa   0(%rsi), %ymm0
vmovdqa 128(%rsi), %ymm1
vmovdqa 256(%rsi), %ymm2
vmovdqa 384(%rsi), %ymm3
vmovdqa  32(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5
vmovdqa 288(%rsi), %ymm6
vmovdqa 416(%rsi), %ymm7

vpacksswb %ymm1, %ymm0, %ymm8
vpacksswb %ymm3, %ymm2, %ymm0
vpacksswb %ymm5, %ymm4, %ymm1
vpacksswb %ymm7, %ymm6, %ymm2

vmovdqa  64(%rsi),  %ymm3
vmovdqa 192(%rsi),  %ymm4
vmovdqa 320(%rsi),  %ymm5
vmovdqa 448(%rsi),  %ymm6
vmovdqa  96(%rsi),  %ymm7
vmovdqa 224(%rsi),  %ymm9
vmovdqa 352(%rsi), %ymm10
vmovdqa 480(%rsi), %ymm11

vpacksswb  %ymm4,  %ymm3, %ymm12
vpacksswb  %ymm6,  %ymm5,  %ymm3
vpacksswb  %ymm9,  %ymm7,  %ymm4
vpacksswb %ymm11, %ymm10,  %ymm5

vperm2i128 $0x20, %ymm0,  %ymm8, %ymm6
vperm2i128 $0x31, %ymm0,  %ymm8, %ymm7
vperm2i128 $0x20, %ymm2,  %ymm1, %ymm0
vperm2i128 $0x31, %ymm2,  %ymm1, %ymm8
vperm2i128 $0x20, %ymm3, %ymm12, %ymm1
vperm2i128 $0x31, %ymm3, %ymm12, %ymm2
vperm2i128 $0x20, %ymm5,  %ymm4, %ymm3
vperm2i128 $0x31, %ymm5,  %ymm4, %ymm9

vpsllq $32, %ymm1,  %ymm4
vpsrlq $32, %ymm6,  %ymm5
vpsllq $32, %ymm2, %ymm10
vpsrlq $32, %ymm7, %ymm11

vpblendd $0xaa,  %ymm4, %ymm6, %ymm12
vpblendd $0x55,  %ymm5, %ymm1,  %ymm4
vpblendd $0xaa, %ymm10, %ymm7,  %ymm1
vpblendd $0x55, %ymm11, %ymm2,  %ymm5

vpsllq $32, %ymm3,  %ymm2
vpsrlq $32, %ymm0,  %ymm6
vpsllq $32, %ymm9,  %ymm7
vpsrlq $32, %ymm8, %ymm10

vpblendd $0xaa,  %ymm2, %ymm0, %ymm11
vpblendd $0x55,  %ymm6, %ymm3,  %ymm0
vpblendd $0xaa,  %ymm7, %ymm8,  %ymm2
vpblendd $0x55, %ymm10, %ymm9,  %ymm3

vpslld $16, %ymm11, %ymm6
vpsrld $16, %ymm12, %ymm7
vpslld $16,  %ymm0, %ymm8
vpsrld $16,  %ymm4, %ymm9

vpblendw $0xaa, %ymm6, %ymm12, %ymm10
vpblendw $0x55, %ymm7, %ymm11,  %ymm6
vpblendw $0xaa, %ymm8,  %ymm4,  %ymm7
vpblendw $0x55, %ymm9,  %ymm0,  %ymm4

vpslld $16, %ymm2,  %ymm0
vpsrld $16, %ymm1,  %ymm8
vpslld $16, %ymm3,  %ymm9
vpsrld $16, %ymm5, %ymm11

vpblendw $0xaa,  %ymm0, %ymm1, %ymm12
vpblendw $0x55,  %ymm8, %ymm2,  %ymm0
vpblendw $0xaa,  %ymm9, %ymm5,  %ymm1
vpblendw $0x55, %ymm11, %ymm3,  %ymm2

vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_lo)(%rip), %ymm10, %ymm3
vpsllw                                     $8, %ymm12, %ymm5
vpsrlw                                     $8, %ymm10, %ymm8
vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_hi)(%rip), %ymm12, %ymm9

vpxor %ymm5, %ymm3, %ymm10
vpxor %ymm9, %ymm8,  %ymm3

vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_lo)(%rip), %ymm6, %ymm5
vpsllw                                     $8, %ymm0, %ymm8
vpsrlw                                     $8, %ymm6, %ymm9
vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_hi)(%rip), %ymm0, %ymm6

vpxor %ymm8, %ymm5, %ymm0
vpxor %ymm6, %ymm9, %ymm5

vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_lo)(%rip), %ymm7, %ymm6
vpsllw                                     $8, %ymm1, %ymm8
vpsrlw                                     $8, %ymm7, %ymm9
vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_hi)(%rip), %ymm1, %ymm7

vpxor %ymm8, %ymm6, %ymm1
vpxor %ymm7, %ymm9, %ymm6

vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_lo)(%rip), %ymm4, %ymm7
vpsllw                                     $8, %ymm2, %ymm8
vpsrlw                                     $8, %ymm4, %ymm9
vpand  NTRUPLUS_ASM_LOCAL(sotp_mask_hi)(%rip), %ymm2, %ymm4

vpxor %ymm8, %ymm7, %ymm2
vpxor %ymm4, %ymm9, %ymm7

vpaddb %ymm13, %ymm10, %ymm4
vpaddb %ymm13,  %ymm3, %ymm8
vpaddb %ymm13,  %ymm0, %ymm3
vpaddb %ymm13,  %ymm5, %ymm0
vpaddb %ymm13,  %ymm1, %ymm5
vpaddb %ymm13,  %ymm6, %ymm1
vpaddb %ymm13,  %ymm2, %ymm6
vpaddb %ymm13,  %ymm7, %ymm2

vpsllw $2, %ymm3, %ymm7
vpsllw $2, %ymm0, %ymm3
vpsllw $4, %ymm5, %ymm0
vpsllw $4, %ymm1, %ymm5
vpsllw $6, %ymm6, %ymm1
vpsllw $6, %ymm2, %ymm6

vpxor %ymm7, %ymm4, %ymm2
vpxor %ymm3, %ymm8, %ymm4
vpxor %ymm1, %ymm0, %ymm3
vpxor %ymm6, %ymm5, %ymm0

vpxor %ymm3, %ymm2, %ymm1
vpxor %ymm0, %ymm4, %ymm2

vmovdqu NTRUPLUS_N/8(%rdx), %ymm0
vpsrlw $1, %ymm0, %ymm3

vpand %ymm14, %ymm0, %ymm4
vpand %ymm14, %ymm3, %ymm0

vpaddb %ymm4, %ymm1, %ymm3
vpaddb %ymm0, %ymm2, %ymm1

    //check
vpsrlw $1, %ymm3, %ymm0
vpsrlw $1, %ymm1, %ymm2

vpxor %ymm0, %ymm3, %ymm4
vpxor %ymm2, %ymm1, %ymm0

vpand %ymm0,  %ymm4,  %ymm2
vpand %ymm2, %ymm15, %ymm15

    //decode
vpand  %ymm14, %ymm3, %ymm0
vpand  %ymm14, %ymm1, %ymm2
vpsllw     $1, %ymm2, %ymm1

vpxor                                 %ymm1, %ymm0, %ymm2
vpxor NTRUPLUS_ASM_LOCAL(sotp_maskff)(%rip), %ymm2, %ymm0

vmovdqu (%rdx), %ymm1

vpxor %ymm1, %ymm0, %ymm2

vmovdqu %ymm2, (%rdi)

add $512, %rsi
add $32, %rdx
add $32, %rdi
cmp %r8, %rdi
jb NTRUPLUS_ASM_LOCAL(looptop_sotp_decode)

    //check
vpxor NTRUPLUS_ASM_LOCAL(sotp_maskff)(%rip), %ymm15, %ymm15
vpand                                %ymm14, %ymm15, %ymm15
vptest       %ymm15, %ymm15
setnz %al
movzbl %al, %eax
lea -1(%rax), %r10d
vmovd %r10d, %xmm0
vpbroadcastb  %xmm0,  %ymm0

    //clear
mov %rcx, %rdi
.balign 32
NTRUPLUS_ASM_LOCAL(looptop_sotp_clear):

vmovdqu (%rdi),  %ymm1
vpand %ymm0, %ymm1, %ymm1
vmovdqu  %ymm1, (%rdi)
add $32, %rdi
cmp %r8, %rdi
jb NTRUPLUS_ASM_LOCAL(looptop_sotp_clear)

vmovdqu 112(%rcx),     %ymm1
vpand %ymm0, %ymm1, %ymm1
vmovdqu     %ymm1, 112(%rcx)

ret
NTRUPLUS_ASM_END(poly_sotp_decode)


.balign 32
NTRUPLUS_ASM_LOCAL(sotp_maskff):
.quad 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff

.balign 32
NTRUPLUS_ASM_LOCAL(sotp_mask_lo):
.quad 0x00ff00ff00ff00ff, 0x00ff00ff00ff00ff, 0x00ff00ff00ff00ff, 0x00ff00ff00ff00ff

.balign 32
NTRUPLUS_ASM_LOCAL(sotp_mask_hi):
.quad 0xff00ff00ff00ff00, 0xff00ff00ff00ff00, 0xff00ff00ff00ff00, 0xff00ff00ff00ff00


NTRUPLUS_ASM_GNU_STACK
