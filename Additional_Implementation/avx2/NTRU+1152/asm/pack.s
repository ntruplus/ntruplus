/*
 * References:
 *
 * [BHK+21] Hanno Becker, Vincent Hwang, Matthias J. Kannwischer,
 * Bo-Yin Yang, and Shang-Yi Yang,
 * "Neon NTT: Faster Dilithium, Kyber, and Saber
 * on Cortex-A72 and Apple M1", IACR Transactions on Cryptographic
 * Hardware and Embedded Systems, 2022(1), pp. 221-244.
 * https://doi.org/10.46586/tches.v2022.i1.221-244
 * Rounded Barrett reduction is adapted to AVX2.
 */

.global poly_tobytes
poly_tobytes:
vmovdqa _16xv(%rip), %ymm15
vmovdqa _16xq(%rip), %ymm14

lea 2304(%rsi), %r8

.p2align 5
_looptop_poly_tobytes:

#load
vmovdqa    (%rsi), %ymm0
vmovdqa  32(%rsi), %ymm1
vmovdqa  64(%rsi), %ymm2
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5
vmovdqa 192(%rsi), %ymm6
vmovdqa 224(%rsi), %ymm7

#reduce: [-32768,32767] -> [-3291,3291]
vpmulhrsw %ymm15,  %ymm0, %ymm10
vpmulhrsw %ymm15,  %ymm1, %ymm11
vpmulhrsw %ymm15,  %ymm2, %ymm12
vpmulhrsw %ymm15,  %ymm3, %ymm13
vpmullw   %ymm14, %ymm10, %ymm10
vpmullw   %ymm14, %ymm11, %ymm11
vpmullw   %ymm14, %ymm12, %ymm12
vpmullw   %ymm14, %ymm13, %ymm13
vpsubw    %ymm10,  %ymm0,  %ymm0
vpsubw    %ymm11,  %ymm1,  %ymm1
vpsubw    %ymm12,  %ymm2,  %ymm2
vpsubw    %ymm13,  %ymm3,  %ymm3

vpmulhrsw %ymm15,  %ymm4, %ymm10
vpmulhrsw %ymm15,  %ymm5, %ymm11
vpmulhrsw %ymm15,  %ymm6, %ymm12
vpmulhrsw %ymm15,  %ymm7, %ymm13
vpmullw   %ymm14, %ymm10, %ymm10
vpmullw   %ymm14, %ymm11, %ymm11
vpmullw   %ymm14, %ymm12, %ymm12
vpmullw   %ymm14, %ymm13, %ymm13
vpsubw    %ymm10,  %ymm4,  %ymm4
vpsubw    %ymm11,  %ymm5,  %ymm5
vpsubw    %ymm12,  %ymm6,  %ymm6
vpsubw    %ymm13,  %ymm7,  %ymm7

#map (-q,q) to [0,q-1].
vpaddw  %ymm14, %ymm0, %ymm10
vpaddw  %ymm14, %ymm1, %ymm11
vpaddw  %ymm14, %ymm2, %ymm12
vpaddw  %ymm14, %ymm3, %ymm13
vpminuw %ymm10, %ymm0,  %ymm0
vpminuw %ymm11, %ymm1,  %ymm1
vpminuw %ymm12, %ymm2,  %ymm2
vpminuw %ymm13, %ymm3,  %ymm3

vpaddw  %ymm14, %ymm4, %ymm10
vpaddw  %ymm14, %ymm5, %ymm11
vpaddw  %ymm14, %ymm6, %ymm12
vpaddw  %ymm14, %ymm7, %ymm13
vpminuw %ymm10, %ymm4,  %ymm4
vpminuw %ymm11, %ymm5,  %ymm5
vpminuw %ymm12, %ymm6,  %ymm6
vpminuw %ymm13, %ymm7,  %ymm7

#pack
vpsllw    $12,  %ymm1, %ymm10
vpsllw    $12,  %ymm5, %ymm11
vpxor  %ymm10,  %ymm0,  %ymm0
vpxor  %ymm11,  %ymm4,  %ymm4
vpsllw     $8,  %ymm2, %ymm10
vpsllw     $8,  %ymm6, %ymm11
vpsrlw     $4,  %ymm1, %ymm12
vpsrlw     $4,  %ymm5, %ymm13
vpxor  %ymm10, %ymm12,  %ymm1
vpxor  %ymm11, %ymm13,  %ymm5
vpsllw     $4,  %ymm3, %ymm10
vpsllw     $4,  %ymm7, %ymm11
vpsrlw     $8,  %ymm2, %ymm12
vpsrlw     $8,  %ymm6, %ymm13
vpxor  %ymm10, %ymm12,  %ymm2
vpxor  %ymm11, %ymm13,  %ymm6

#shuffle
vpunpcklwd %ymm1, %ymm0,  %ymm7
vpunpckhwd %ymm1, %ymm0,  %ymm8
vpunpcklwd %ymm4, %ymm2,  %ymm9
vpunpckhwd %ymm4, %ymm2, %ymm10
vpunpcklwd %ymm6, %ymm5, %ymm11
vpunpckhwd %ymm6, %ymm5, %ymm12

vpshufd  $0x6c,  %ymm7,  %ymm7
vpshufd  $0xb1,  %ymm9,  %ymm9
vpshufd  $0xc6, %ymm11, %ymm11
vpblendd $0x22,  %ymm9,  %ymm7,  %ymm0
vpblendd $0x44, %ymm11,  %ymm0,  %ymm6
vpblendd $0x22, %ymm11,  %ymm9,  %ymm0
vpblendd $0x44,  %ymm7,  %ymm0, %ymm13
vpblendd $0x22,  %ymm7, %ymm11,  %ymm0
vpblendd $0x44,  %ymm9,  %ymm0,  %ymm7

vpshufd  $0x6c,  %ymm8,  %ymm8
vpshufd  $0xb1, %ymm10, %ymm10
vpshufd  $0xc6, %ymm12, %ymm12
vpblendd $0x22, %ymm10,  %ymm8,  %ymm0
vpblendd $0x44, %ymm12,  %ymm0,  %ymm9
vpblendd $0x22, %ymm12, %ymm10,  %ymm0
vpblendd $0x44,  %ymm8,  %ymm0, %ymm11
vpblendd $0x22,  %ymm8, %ymm12,  %ymm0
vpblendd $0x44, %ymm10,  %ymm0, %ymm12

vperm2i128 $0x20, %ymm13,  %ymm6, %ymm0
vperm2i128 $0x20,  %ymm9,  %ymm7, %ymm1
vperm2i128 $0x20, %ymm12, %ymm11, %ymm2
vperm2i128 $0x31, %ymm13,  %ymm6, %ymm3
vperm2i128 $0x31,  %ymm9,  %ymm7, %ymm4
vperm2i128 $0x31, %ymm12, %ymm11, %ymm5

#store
vmovdqu %ymm0,    (%rdi)
vmovdqu %ymm1,  32(%rdi)
vmovdqu %ymm2,  64(%rdi)
vmovdqu %ymm3,  96(%rdi)
vmovdqu %ymm4, 128(%rdi)
vmovdqu %ymm5, 160(%rdi)

add $192, %rdi
add $256, %rsi
cmp %r8, %rsi
jb _looptop_poly_tobytes

ret


.global poly_frombytes
poly_frombytes:
vmovdqa _low_mask(%rip), %ymm15
vpxor %ymm14, %ymm14, %ymm14

lea 1728(%rsi), %r8

.p2align 5
_looptop_poly_frombytes:

#load
vmovdqu    (%rsi), %ymm0
vmovdqu  32(%rsi), %ymm1
vmovdqu  64(%rsi), %ymm2
vmovdqu  96(%rsi), %ymm3
vmovdqu 128(%rsi), %ymm4
vmovdqu 160(%rsi), %ymm5

#shuffle
vperm2i128 $0x20, %ymm3, %ymm0,  %ymm6
vperm2i128 $0x31, %ymm3, %ymm0,  %ymm7
vperm2i128 $0x20, %ymm4, %ymm1,  %ymm8
vperm2i128 $0x31, %ymm4, %ymm1,  %ymm9
vperm2i128 $0x20, %ymm5, %ymm2, %ymm10
vperm2i128 $0x31, %ymm5, %ymm2, %ymm11

vpunpcklqdq  %ymm9, %ymm6, %ymm0
vpunpckhqdq  %ymm9, %ymm6, %ymm1
vpunpcklqdq %ymm10, %ymm7, %ymm2
vpunpckhqdq %ymm10, %ymm7, %ymm3
vpunpcklqdq %ymm11, %ymm8, %ymm4
vpunpckhqdq %ymm11, %ymm8, %ymm5

vpsllq     $32,  %ymm3,  %ymm8
vpsrlq     $32,  %ymm0,  %ymm9
vpsllq     $32,  %ymm4, %ymm10
vpsrlq     $32,  %ymm1, %ymm11
vpsllq     $32,  %ymm5, %ymm12
vpsrlq     $32,  %ymm2, %ymm13
vpblendd $0xAA,  %ymm8,  %ymm0,  %ymm8
vpblendd $0xAA,  %ymm3,  %ymm9,  %ymm9
vpblendd $0xAA, %ymm10,  %ymm1, %ymm10
vpblendd $0xAA,  %ymm4, %ymm11, %ymm11
vpblendd $0xAA, %ymm12,  %ymm2, %ymm12
vpblendd $0xAA,  %ymm5, %ymm13, %ymm13

vpsllq     $16, %ymm11,  %ymm0
vpsrlq     $16,  %ymm8,  %ymm1
vpsllq     $16, %ymm12,  %ymm2
vpsrlq     $16,  %ymm9,  %ymm3
vpsllq     $16, %ymm13,  %ymm4
vpsrlq     $16, %ymm10,  %ymm5
vpblendw $0xAA,  %ymm0,  %ymm8, %ymm0
vpblendw $0xAA, %ymm11,  %ymm1, %ymm1
vpblendw $0xAA,  %ymm2,  %ymm9, %ymm2
vpblendw $0xAA, %ymm12,  %ymm3, %ymm3
vpblendw $0xAA,  %ymm4, %ymm10, %ymm4
vpblendw $0xAA, %ymm13,  %ymm5, %ymm5

#unpack
vpand  %ymm15, %ymm0, %ymm11
vpand  %ymm15, %ymm3,  %ymm7
vpsrlw    $12, %ymm0,  %ymm0
vpsrlw    $12, %ymm3,  %ymm3
vpsllw     $4, %ymm1,  %ymm6
vpsllw     $4, %ymm4,  %ymm9
vpxor   %ymm6, %ymm0,  %ymm0
vpxor   %ymm9, %ymm3,  %ymm3
vpand  %ymm15, %ymm0, %ymm12
vpand  %ymm15, %ymm3,  %ymm8
vpsrlw     $8, %ymm1,  %ymm0
vpsrlw     $8, %ymm4,  %ymm3
vpsllw     $8, %ymm2,  %ymm1
vpsllw     $8, %ymm5,  %ymm4
vpxor   %ymm1, %ymm0,  %ymm0
vpxor   %ymm4, %ymm3,  %ymm3
vpand  %ymm15, %ymm0, %ymm13
vpand  %ymm15, %ymm3,  %ymm9
vpsrlw     $4, %ymm2,  %ymm3
vpsrlw     $4, %ymm5, %ymm10

#store
vmovdqa %ymm11,    (%rdi)
vmovdqa %ymm12,  32(%rdi)
vmovdqa %ymm13,  64(%rdi)
vmovdqa  %ymm3,  96(%rdi)
vmovdqa  %ymm7, 128(%rdi)
vmovdqa  %ymm8, 160(%rdi)
vmovdqa  %ymm9, 192(%rdi)
vmovdqa %ymm10, 224(%rdi)

#check: accept [0,q-1]
vpmaxuw %ymm12, %ymm11,  %ymm0
vpmaxuw  %ymm3, %ymm13,  %ymm1
vpmaxuw  %ymm8,  %ymm7,  %ymm2
vpmaxuw %ymm10,  %ymm9,  %ymm3
vpmaxuw  %ymm1,  %ymm0,  %ymm0
vpmaxuw  %ymm3,  %ymm2,  %ymm2
vpmaxuw  %ymm2,  %ymm0,  %ymm0
vpmaxuw  %ymm0, %ymm14, %ymm14

add $256, %rdi
add $192, %rsi
cmp %r8, %rsi
jb _looptop_poly_frombytes

vpcmpgtw _16xqm1(%rip), %ymm14, %ymm14

vptest %ymm14, %ymm14
setne  %al
movzbl %al, %eax
ret

.ifndef no_gnu_stack
.section .note.GNU-stack, "", @progbits
.endif