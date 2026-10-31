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

lea 1728(%rsi), %r8

.p2align 5
_looptop_poly_tobytes:

#load
vmovdqa    (%rsi), %ymm0
vmovdqa  32(%rsi), %ymm1
vmovdqa  64(%rsi), %ymm2
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5

#reduce: [-32768,32767] -> [-3291,3291]
vpmulhrsw %ymm15,  %ymm0,  %ymm6
vpmulhrsw %ymm15,  %ymm1,  %ymm7
vpmulhrsw %ymm15,  %ymm2,  %ymm8
vpmulhrsw %ymm15,  %ymm3,  %ymm9
vpmulhrsw %ymm15,  %ymm4, %ymm10
vpmulhrsw %ymm15,  %ymm5, %ymm11
vpmullw   %ymm14,  %ymm6,  %ymm6
vpmullw   %ymm14,  %ymm7,  %ymm7
vpmullw   %ymm14,  %ymm8,  %ymm8
vpmullw   %ymm14,  %ymm9,  %ymm9
vpmullw   %ymm14, %ymm10, %ymm10
vpmullw   %ymm14, %ymm11, %ymm11
vpsubw     %ymm6,  %ymm0,  %ymm0
vpsubw     %ymm7,  %ymm1,  %ymm1
vpsubw     %ymm8,  %ymm2,  %ymm2
vpsubw     %ymm9,  %ymm3,  %ymm3
vpsubw    %ymm10,  %ymm4,  %ymm4
vpsubw    %ymm11,  %ymm5,  %ymm5

#map (-q,q) to [0,q-1].
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

#pack
vpsllw   $12, %ymm1, %ymm6
vpor   %ymm0, %ymm6, %ymm6
vpsrlw    $4, %ymm1, %ymm7
vpsllw    $8, %ymm2, %ymm8
vpor   %ymm8, %ymm7, %ymm7
vpsrlw    $8, %ymm2, %ymm8
vpsllw    $4, %ymm3, %ymm9
vpor   %ymm9, %ymm8, %ymm8
vpsllw   $12, %ymm5, %ymm9
vpor   %ymm4, %ymm9, %ymm9
vpsrlw    $4, %ymm5, %ymm5

#shuffle
vpunpcklwd %ymm7, %ymm6, %ymm0
vpunpckhwd %ymm7, %ymm6, %ymm1
vpunpcklwd %ymm9, %ymm8, %ymm2
vpunpckhwd %ymm9, %ymm8, %ymm3

vpunpckldq %ymm2, %ymm0, %ymm6
vpunpckhdq %ymm2, %ymm0, %ymm7
vpunpckldq %ymm3, %ymm1, %ymm8
vpunpckhdq %ymm3, %ymm1, %ymm9

vpshufb   _pack96_masks+0(%rip), %ymm6,  %ymm0
vpshufb  _pack96_masks+32(%rip), %ymm5, %ymm10
vpshufb  _pack96_masks+64(%rip), %ymm6,  %ymm1
vpshufb  _pack96_masks+96(%rip), %ymm7,  %ymm6
vpshufb _pack96_masks+128(%rip), %ymm5, %ymm11
vpshufb _pack96_masks+160(%rip), %ymm7,  %ymm2
vpshufb _pack96_masks+192(%rip), %ymm8,  %ymm7
vpshufb _pack96_masks+224(%rip), %ymm5, %ymm12
vpshufb _pack96_masks+256(%rip), %ymm8,  %ymm3
vpshufb _pack96_masks+288(%rip), %ymm9,  %ymm8
vpshufb _pack96_masks+320(%rip), %ymm5, %ymm13
vpshufb _pack96_masks+352(%rip), %ymm9,  %ymm4
vpshufb _pack96_masks+384(%rip), %ymm5,  %ymm9

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

vextracti128 $1, %ymm0,  %xmm8
vextracti128 $1, %ymm1,  %xmm9
vextracti128 $1, %ymm2, %xmm10
vextracti128 $1, %ymm3, %xmm11
vextracti128 $1, %ymm4, %xmm12

vpunpcklqdq %xmm8,  %xmm4,  %xmm0
vpalignr       $8,  %xmm8,  %xmm9, %xmm1
vpalignr       $8,  %xmm9, %xmm10, %xmm2
vpalignr       $8, %xmm10, %xmm11, %xmm3
vpalignr       $8, %xmm11, %xmm12, %xmm4

vinserti128 $1, %xmm1, %ymm0, %ymm0
vinserti128 $1, %xmm3, %ymm2, %ymm2

#store
vmovdqu %ymm6,    (%rdi)
vmovdqu %ymm7,  32(%rdi)
vmovdqu %ymm0,  64(%rdi)
vmovdqu %ymm2,  96(%rdi)
vmovdqu %xmm4, 128(%rdi)

add $144, %rdi
add $192, %rsi
cmp %r8,  %rsi
jb  _looptop_poly_tobytes

ret

.global poly_frombytes_raw
poly_frombytes_raw:
vmovdqa _low_mask(%rip), %ymm15
xor %eax, %eax

lea 1664(%rdi), %r8

.p2align 5
_looptop_poly_frombytes:

#load
vmovdqu   (%rsi), %ymm4
vmovdqu 32(%rsi), %ymm5
vmovdqu 64(%rsi), %ymm6

#shuffle
vperm2i128 $0x30, %ymm5, %ymm4, %ymm0
vperm2i128 $0x03, %ymm4, %ymm6, %ymm1
vperm2i128 $0x30, %ymm6, %ymm5, %ymm2

vpshufd     $0x4E,  %ymm0, %ymm13
vpblendd    $0xCC,  %ymm1,  %ymm0, %ymm4
vpunpcklqdq %ymm2, %ymm13,  %ymm5
vpblendd    $0xCC,  %ymm2,  %ymm1, %ymm6

vpsrlq     $32,  %ymm4, %ymm12
vpsllq     $32,  %ymm6, %ymm13
vpblendd $0xAA,  %ymm5,  %ymm4, %ymm0
vpblendd $0xAA, %ymm13, %ymm12, %ymm1
vpblendd $0xAA,  %ymm6,  %ymm5, %ymm2

vpsrld     $16,  %ymm0, %ymm12
vpslld     $16,  %ymm2, %ymm13
vpblendw $0xAA,  %ymm1,  %ymm0, %ymm4
vpblendw $0xAA, %ymm13, %ymm12, %ymm5
vpblendw $0xAA,  %ymm2,  %ymm1, %ymm6

#unpack
vpand  %ymm15, %ymm4,  %ymm0
vpsrlw    $12, %ymm4,  %ymm4
vpsllw     $4, %ymm5, %ymm14
vpxor  %ymm14, %ymm4,  %ymm4
vpand  %ymm15, %ymm4,  %ymm1
vpsrlw     $8, %ymm5,  %ymm4
vpsllw     $8, %ymm6, %ymm14
vpxor  %ymm14, %ymm4,  %ymm4
vpand  %ymm15, %ymm4,  %ymm2
vpsrlw     $4, %ymm6,  %ymm4
vpand  %ymm15, %ymm4,  %ymm3

#shuffle
vpslld $16, %ymm1, %ymm10
vpslld $16, %ymm3, %ymm11
vpsrld $16, %ymm0, %ymm12
vpsrld $16, %ymm2, %ymm13

vpblendw $0xAA, %ymm10,  %ymm0, %ymm4
vpblendw $0xAA, %ymm11,  %ymm2, %ymm5
vpblendw $0xAA,  %ymm1, %ymm12, %ymm6
vpblendw $0xAA,  %ymm3, %ymm13, %ymm7

vpsllq $32, %ymm5, %ymm10
vpsllq $32, %ymm7, %ymm11
vpsrlq $32, %ymm4, %ymm12
vpsrlq $32, %ymm6, %ymm13

vpblendd $0xAA, %ymm10,  %ymm4, %ymm0
vpblendd $0xAA, %ymm11,  %ymm6, %ymm1
vpblendd $0xAA,  %ymm5, %ymm12, %ymm2
vpblendd $0xAA,  %ymm7, %ymm13, %ymm3

vpunpcklqdq %ymm1, %ymm0, %ymm4
vpunpcklqdq %ymm3, %ymm2, %ymm5
vpunpckhqdq %ymm1, %ymm0, %ymm6
vpunpckhqdq %ymm3, %ymm2, %ymm7

vperm2i128 $0x20, %ymm5, %ymm4, %ymm0
vperm2i128 $0x20, %ymm7, %ymm6, %ymm1
vperm2i128 $0x31, %ymm5, %ymm4, %ymm2
vperm2i128 $0x31, %ymm7, %ymm6, %ymm3

#store
vmovdqa %ymm0,   (%rdi)
vmovdqa %ymm1, 32(%rdi)
vmovdqa %ymm2, 64(%rdi)
vmovdqa %ymm3, 96(%rdi)

#check: accept [0,q-1]
vpmaxuw   %ymm1, %ymm0, %ymm4
vpmaxuw   %ymm3, %ymm2, %ymm5
vpmaxuw   %ymm5, %ymm4, %ymm4
vpcmpgtw  _16xqm1(%rip), %ymm4, %ymm4
vpmovmskb %ymm4, %edx
or %edx, %eax

add $128, %rdi
add $96, %rsi
cmp %r8, %rdi
jb _looptop_poly_frombytes

#load
vmovdqu   (%rsi), %xmm0
vmovdqu 16(%rsi), %xmm1
vmovdqu 32(%rsi), %xmm2

#shuffle
vpshufd     $0x4E,  %xmm0, %xmm13
vpblendd    $0xCC,  %xmm1,  %xmm0, %xmm4
vpunpcklqdq %xmm2, %xmm13,  %xmm5
vpblendd    $0xCC,  %xmm2,  %xmm1, %xmm6

vpsrlq     $32,  %xmm4, %xmm12
vpsllq     $32,  %xmm6, %xmm13
vpblendd $0xAA,  %xmm5,  %xmm4, %xmm0
vpblendd $0xAA, %xmm13, %xmm12, %xmm1
vpblendd $0xAA,  %xmm6,  %xmm5, %xmm2

vpsrld     $16,  %xmm0, %xmm12
vpslld     $16,  %xmm2, %xmm13
vpblendw $0xAA,  %xmm1,  %xmm0, %xmm4
vpblendw $0xAA, %xmm13, %xmm12, %xmm5
vpblendw $0xAA,  %xmm2,  %xmm1, %xmm6

#unpack
vpand  %xmm15, %xmm4,  %xmm0
vpsrlw    $12, %xmm4,  %xmm4
vpsllw     $4, %xmm5, %xmm14
vpxor  %xmm14, %xmm4,  %xmm4
vpand  %xmm15, %xmm4,  %xmm1
vpsrlw     $8, %xmm5,  %xmm4
vpsllw     $8, %xmm6, %xmm14
vpxor  %xmm14, %xmm4,  %xmm4
vpand  %xmm15, %xmm4,  %xmm2
vpsrlw     $4, %xmm6,  %xmm4
vpand  %xmm15, %xmm4,  %xmm3

#shuffle
vpslld $16, %xmm1, %xmm10
vpslld $16, %xmm3, %xmm11
vpsrld $16, %xmm0, %xmm12
vpsrld $16, %xmm2, %xmm13

vpblendw $0xAA, %xmm10,  %xmm0, %xmm4
vpblendw $0xAA, %xmm11,  %xmm2, %xmm5
vpblendw $0xAA,  %xmm1, %xmm12, %xmm6
vpblendw $0xAA,  %xmm3, %xmm13, %xmm7

vpsllq $32, %xmm5, %xmm10
vpsllq $32, %xmm7, %xmm11
vpsrlq $32, %xmm4, %xmm12
vpsrlq $32, %xmm6, %xmm13

vpblendd $0xAA, %xmm10,  %xmm4, %xmm0
vpblendd $0xAA, %xmm11,  %xmm6, %xmm1
vpblendd $0xAA,  %xmm5, %xmm12, %xmm2
vpblendd $0xAA,  %xmm7, %xmm13, %xmm3

vpunpcklqdq %xmm1, %xmm0, %xmm4
vpunpcklqdq %xmm3, %xmm2, %xmm5
vpunpckhqdq %xmm1, %xmm0, %xmm6
vpunpckhqdq %xmm3, %xmm2, %xmm7

#store
vmovdqa %xmm4,   (%rdi)
vmovdqa %xmm5, 16(%rdi)
vmovdqa %xmm6, 32(%rdi)
vmovdqa %xmm7, 48(%rdi)

#check: accept [0,q-1]
vpmaxuw   %xmm5, %xmm4, %xmm0
vpmaxuw   %xmm7, %xmm6, %xmm1
vpmaxuw   %xmm1, %xmm0, %xmm0
vpcmpgtw  _16xqm1(%rip), %xmm0, %xmm0
vpmovmskb %xmm0, %edx
or %edx, %eax

test %eax, %eax
setne %al
movzbl %al, %eax
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

vpunpcklqdq %ymm13, %ymm10, %ymm0
vpunpckhqdq %ymm13, %ymm10, %ymm1
vpunpcklqdq %ymm14, %ymm11, %ymm2
vpunpckhqdq %ymm14, %ymm11, %ymm3
vpunpcklqdq %ymm15, %ymm12, %ymm4
vpunpckhqdq %ymm15, %ymm12, %ymm5

vpsllq     $32,  %ymm3, %ymm10
vpsrlq     $32,  %ymm0, %ymm11
vpsllq     $32,  %ymm4, %ymm12
vpsrlq     $32,  %ymm1, %ymm13
vpsllq     $32,  %ymm5, %ymm14
vpsrlq     $32,  %ymm2, %ymm15
vpblendd $0xAA, %ymm10,  %ymm0, %ymm10
vpblendd $0xAA,  %ymm3, %ymm11, %ymm11
vpblendd $0xAA, %ymm12,  %ymm1, %ymm12
vpblendd $0xAA,  %ymm4, %ymm13, %ymm13
vpblendd $0xAA, %ymm14,  %ymm2, %ymm14
vpblendd $0xAA,  %ymm5, %ymm15, %ymm15

vpsllq     $16, %ymm13,  %ymm0
vpsrlq     $16, %ymm10,  %ymm1
vpsllq     $16, %ymm14,  %ymm2
vpsrlq     $16, %ymm11,  %ymm3
vpsllq     $16, %ymm15,  %ymm4
vpsrlq     $16, %ymm12,  %ymm5
vpblendw $0xAA,  %ymm0, %ymm10, %ymm0
vpblendw $0xAA, %ymm13,  %ymm1, %ymm1
vpblendw $0xAA,  %ymm2, %ymm11, %ymm2
vpblendw $0xAA, %ymm14,  %ymm3, %ymm3
vpblendw $0xAA,  %ymm4, %ymm12, %ymm4
vpblendw $0xAA, %ymm15,  %ymm5, %ymm5

#store
vmovdqa %ymm0,    (%rdi)
vmovdqa %ymm1,  32(%rdi)
vmovdqa %ymm2,  64(%rdi)
vmovdqa %ymm3,  96(%rdi)
vmovdqa %ymm4, 128(%rdi)
vmovdqa %ymm5, 160(%rdi)

add $192, %rsi
add $192, %rdi
cmp %r8, %rsi
jb _looptop_poly_ntt_unpack

ret


.ifndef no_gnu_stack
.section .note.GNU-stack, "", @progbits
.endif