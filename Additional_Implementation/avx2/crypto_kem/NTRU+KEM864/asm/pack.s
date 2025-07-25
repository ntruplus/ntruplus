.global poly_tobytes
poly_tobytes:
lea 1664(%rsi), %r8

.p2align 5
_looptop_poly_tobytes:
#load
vmovdqa   (%rsi), %ymm0
vmovdqa 32(%rsi), %ymm1
vmovdqa 64(%rsi), %ymm2
vmovdqa 96(%rsi), %ymm3

vpsllw $12,    %ymm1,  %ymm13
vpxor  %ymm13, %ymm0,  %ymm0
vpsllw $8,     %ymm2,  %ymm13
vpsrlw $4,     %ymm1,  %ymm12
vpxor  %ymm13, %ymm12, %ymm1
vpsllw $4,     %ymm3,  %ymm13
vpsrlw $8,     %ymm2,  %ymm12
vpxor  %ymm13, %ymm12, %ymm2

vmovdqu %ymm0,   (%rdi)
vmovdqu %ymm1, 32(%rdi)
vmovdqu %ymm2, 64(%rdi)

add $96,  %rdi
add $128, %rsi
cmp %r8,  %rsi
jb  _looptop_poly_tobytes

#load
vmovdqa   (%rsi), %xmm0
vmovdqa 16(%rsi), %xmm1
vmovdqa 32(%rsi), %xmm2
vmovdqa 48(%rsi), %xmm3

vpsllw $12,    %xmm1,  %xmm13
vpxor  %xmm13, %xmm0,  %xmm0
vpsllw $8,     %xmm2,  %xmm13
vpsrlw $4,     %xmm1,  %xmm12
vpxor  %xmm13, %xmm12, %xmm1
vpsllw $4,     %xmm3,  %xmm13
vpsrlw $8,     %xmm2,  %xmm12
vpxor  %xmm13, %xmm12, %xmm2

vmovdqu %xmm0,   (%rdi)
vmovdqu %xmm1, 16(%rdi)
vmovdqu %xmm2, 32(%rdi)

ret


.global poly_frombytes
poly_frombytes:
vmovdqa _low_mask(%rip), %ymm15

lea 1664(%rdi), %r8

.p2align 5
_looptop_poly_frombytes:
#load
vmovdqu   (%rsi), %ymm4
vmovdqu 32(%rsi), %ymm5
vmovdqu 64(%rsi), %ymm6

vpand  %ymm15, %ymm4, %ymm0
vpsrlw $12,    %ymm4, %ymm4
vpsllw $4,     %ymm5, %ymm14
vpxor  %ymm14, %ymm4, %ymm4
vpand  %ymm15, %ymm4, %ymm1
vpsrlw $8,     %ymm5, %ymm4
vpsllw $8,     %ymm6, %ymm14
vpxor  %ymm14, %ymm4, %ymm4
vpand  %ymm15, %ymm4, %ymm2
vpsrlw $4,     %ymm6, %ymm4
vpand  %ymm15, %ymm4, %ymm3

vmovdqa %ymm0,   (%rdi)
vmovdqa %ymm1, 32(%rdi)
vmovdqa %ymm2, 64(%rdi)
vmovdqa %ymm3, 96(%rdi)

add $128, %rdi
add $96,  %rsi
cmp %r8,  %rdi
jb  _looptop_poly_frombytes

vmovdqu   (%rsi), %xmm4
vmovdqu 16(%rsi), %xmm5
vmovdqu 32(%rsi), %xmm6

vpand  %xmm15, %xmm4, %xmm0
vpsrlw $12,    %xmm4, %xmm4
vpsllw $4,     %xmm5, %xmm14
vpxor  %xmm14, %xmm4, %xmm4
vpand  %xmm15, %xmm4, %xmm1
vpsrlw $8,     %xmm5, %xmm4
vpsllw $8,     %xmm6, %xmm14
vpxor  %xmm14, %xmm4, %xmm4
vpand  %xmm15, %xmm4, %xmm2
vpsrlw $4,     %xmm6, %xmm4
vpand  %xmm15, %xmm4, %xmm3

vmovdqa %xmm0,   (%rdi)
vmovdqa %xmm1, 16(%rdi)
vmovdqa %xmm2, 32(%rdi)
vmovdqa %xmm3, 48(%rdi)

ret


.global poly_ntt_unpack
poly_ntt_unpack:
lea 1728(%rsi), %r8

.p2align 5
_looptop_poly_ntt_unpack:
#load
vmovdqa    (%rsi), %ymm0
vmovdqa  32(%rsi), %ymm1
vmovdqa  64(%rsi), %ymm2
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5

#shuffle
vperm2i128 $0x20, %ymm3, %ymm0, %ymm10
vperm2i128 $0x31, %ymm3, %ymm0, %ymm11
vperm2i128 $0x20, %ymm4, %ymm1, %ymm12
vperm2i128 $0x31, %ymm4, %ymm1, %ymm13
vperm2i128 $0x20, %ymm5, %ymm2, %ymm14
vperm2i128 $0x31, %ymm5, %ymm2, %ymm15

#shuffle
vpunpcklqdq %ymm13, %ymm10, %ymm0
vpunpckhqdq %ymm13, %ymm10, %ymm1
vpunpcklqdq %ymm14, %ymm11, %ymm2
vpunpckhqdq %ymm14, %ymm11, %ymm3
vpunpcklqdq %ymm15, %ymm12, %ymm4
vpunpckhqdq %ymm15, %ymm12, %ymm5

#shuffle
vpsllq   $32,   %ymm3,  %ymm10
vpsrlq   $32,   %ymm0,  %ymm11
vpsllq   $32,   %ymm4,  %ymm12
vpsrlq   $32,   %ymm1,  %ymm13
vpsllq   $32,   %ymm5,  %ymm14
vpsrlq   $32,   %ymm2,  %ymm15
vpblendd $0xAA, %ymm10, %ymm0,  %ymm10
vpblendd $0xAA, %ymm3,  %ymm11, %ymm11
vpblendd $0xAA, %ymm12, %ymm1,  %ymm12
vpblendd $0xAA, %ymm4,  %ymm13, %ymm13
vpblendd $0xAA, %ymm14, %ymm2,  %ymm14
vpblendd $0xAA, %ymm5,  %ymm15, %ymm15

#shuffle
vpsllq   $16,   %ymm13, %ymm0
vpsrlq   $16,   %ymm10, %ymm1
vpsllq   $16,   %ymm14, %ymm2
vpsrlq   $16,   %ymm11, %ymm3
vpsllq   $16,   %ymm15, %ymm4
vpsrlq   $16,   %ymm12, %ymm5
vpblendw $0xAA, %ymm0,  %ymm10, %ymm0
vpblendw $0xAA, %ymm13, %ymm1,  %ymm1
vpblendw $0xAA, %ymm2,  %ymm11, %ymm2
vpblendw $0xAA, %ymm14, %ymm3,  %ymm3
vpblendw $0xAA, %ymm4,  %ymm12, %ymm4
vpblendw $0xAA, %ymm15, %ymm5,  %ymm5

#store
vmovdqa %ymm0,    (%rdi)
vmovdqa %ymm1,  32(%rdi)
vmovdqa %ymm2,  64(%rdi)
vmovdqa %ymm3,  96(%rdi)
vmovdqa %ymm4, 128(%rdi)
vmovdqa %ymm5, 160(%rdi)

add $192, %rsi
add $192, %rdi
cmp %r8,  %rsi
jb  _looptop_poly_ntt_unpack

ret


.global poly_ntt_pack
poly_ntt_pack:
vmovdqa _16xv(%rip), %ymm15
vmovdqa _16xq(%rip), %ymm14

lea 1728(%rsi), %r8

.p2align 5
_looptop_poly_ntt_pack:
#load
vmovdqa    (%rsi), %ymm0
vmovdqa  32(%rsi), %ymm1
vmovdqa  64(%rsi), %ymm2
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5

vpmulhw %ymm15, %ymm0,  %ymm6
vpmulhw %ymm15, %ymm1,  %ymm7
vpmulhw %ymm15, %ymm2,  %ymm8
vpmulhw %ymm15, %ymm3,  %ymm9
vpmulhw %ymm15, %ymm4,  %ymm10
vpmulhw %ymm15, %ymm5,  %ymm11
vpsraw  $10,    %ymm6,  %ymm6
vpsraw  $10,    %ymm7,  %ymm7
vpsraw  $10,    %ymm8,  %ymm8
vpsraw  $10,    %ymm9,  %ymm9
vpsraw  $10,    %ymm10, %ymm10
vpsraw  $10,    %ymm11, %ymm11
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

vpsubw %ymm14, %ymm0,  %ymm0
vpsubw %ymm14, %ymm1,  %ymm1
vpsubw %ymm14, %ymm2,  %ymm2
vpsubw %ymm14, %ymm3,  %ymm3
vpsubw %ymm14, %ymm4,  %ymm4
vpsubw %ymm14, %ymm5,  %ymm5
vpsraw $15,    %ymm0,  %ymm6
vpsraw $15,    %ymm1,  %ymm7
vpsraw $15,    %ymm2,  %ymm8
vpsraw $15,    %ymm3,  %ymm9
vpsraw $15,    %ymm4,  %ymm10
vpsraw $15,    %ymm5,  %ymm11
vpand  %ymm14, %ymm6,  %ymm6
vpand  %ymm14, %ymm7,  %ymm7
vpand  %ymm14, %ymm8,  %ymm8
vpand  %ymm14, %ymm9,  %ymm9
vpand  %ymm14, %ymm10, %ymm10
vpand  %ymm14, %ymm11, %ymm11
vpaddw %ymm6,  %ymm0,  %ymm0
vpaddw %ymm7,  %ymm1,  %ymm1
vpaddw %ymm8,  %ymm2,  %ymm2
vpaddw %ymm9,  %ymm3,  %ymm3
vpaddw %ymm10, %ymm4,  %ymm4
vpaddw %ymm11, %ymm5,  %ymm5

#shuffle
vpslld   $16,   %ymm1, %ymm6
vpslld   $16,   %ymm3, %ymm7
vpslld   $16,   %ymm5, %ymm8
vpsrld   $16,   %ymm0, %ymm9
vpsrld   $16,   %ymm2, %ymm10
vpsrld   $16,   %ymm4, %ymm11
vpblendw $0xAA, %ymm6, %ymm0,  %ymm6
vpblendw $0xAA, %ymm7, %ymm2,  %ymm7
vpblendw $0xAA, %ymm8, %ymm4,  %ymm8
vpblendw $0xAA, %ymm1, %ymm9,  %ymm9
vpblendw $0xAA, %ymm3, %ymm10, %ymm10
vpblendw $0xAA, %ymm5, %ymm11, %ymm11

#shuffle
vpsllq   $32,   %ymm7,  %ymm0
vpsllq   $32,   %ymm9,  %ymm1
vpsllq   $32,   %ymm11, %ymm2
vpsrlq   $32,   %ymm6,  %ymm3
vpsrlq   $32,   %ymm8,  %ymm4
vpsrlq   $32,   %ymm10, %ymm5
vpblendd $0xAA, %ymm0,  %ymm6,  %ymm0
vpblendd $0xAA, %ymm1,  %ymm8,  %ymm1
vpblendd $0xAA, %ymm2,  %ymm10, %ymm2
vpblendd $0xAA, %ymm7,  %ymm3,  %ymm3
vpblendd $0xAA, %ymm9,  %ymm4,  %ymm4
vpblendd $0xAA, %ymm11, %ymm5,  %ymm5

#shuffle
vpunpcklqdq %ymm1, %ymm0, %ymm6
vpunpcklqdq %ymm3, %ymm2, %ymm7
vpunpcklqdq %ymm5, %ymm4, %ymm8
vpunpckhqdq %ymm1, %ymm0, %ymm9
vpunpckhqdq %ymm3, %ymm2, %ymm10
vpunpckhqdq %ymm5, %ymm4, %ymm11

#shuffle
vperm2i128 $0x20, %ymm7,  %ymm6,  %ymm0
vperm2i128 $0x20, %ymm9,  %ymm8,  %ymm1
vperm2i128 $0x20, %ymm11, %ymm10, %ymm2
vperm2i128 $0x31, %ymm7,  %ymm6,  %ymm3
vperm2i128 $0x31, %ymm9,  %ymm8,  %ymm4
vperm2i128 $0x31, %ymm11, %ymm10, %ymm5

#store
vmovdqa %ymm0,    (%rdi)
vmovdqa %ymm1,  32(%rdi)
vmovdqa %ymm2,  64(%rdi)
vmovdqa %ymm3,  96(%rdi)
vmovdqa %ymm4, 128(%rdi)
vmovdqa %ymm5, 160(%rdi)

add $192, %rsi
add $192, %rdi
cmp %r8,  %rsi
jb  _looptop_poly_ntt_pack

ret

.section .note.GNU-stack,"",@progbits
