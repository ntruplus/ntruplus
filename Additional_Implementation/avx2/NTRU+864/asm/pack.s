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

/*************************************************
* Name:        poly_tobytes
*
* Description: Serialization of a polynomial in NTT order.
*              Input coefficients are signed 16-bit integers;
*              encoded coefficients lie in [0,q-1].
*
* Arguments:   - uint8_t *r:    pointer to output byte array
*                               (needs space for NTRUPLUS_POLYBYTES bytes)
*              - const poly *a: pointer to input polynomial
**************************************************/
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


/*************************************************
* Name:        poly_frombytes
*
* Description: De-serialization of a polynomial into NTT order;
*              inverse of poly_tobytes. Decoded coefficients lie
*              in [0,4095], and valid encodings use [0,q-1].
*
* Arguments:   - poly *r:          pointer to output polynomial
*              - const uint8_t *a: pointer to input byte array
*                                  (of NTRUPLUS_POLYBYTES bytes)
*
* Returns 0 on success, 1 if any coefficient is greater than or equal to q.
**************************************************/
.global poly_frombytes
poly_frombytes:
vmovdqa _low_mask(%rip), %ymm15
xor %eax, %eax
lea 1296(%rsi), %r8

.p2align 5
_looptop_poly_frombytes:

#load
vmovdqu    (%rsi),  %xmm0
vmovdqu  16(%rsi),  %xmm1
vmovdqu  32(%rsi),  %xmm2
vmovdqu  48(%rsi),  %xmm3
vmovdqu  64(%rsi),  %xmm4
vmovq   136(%rsi), %xmm10

vinserti128 $1,  72(%rsi), %ymm0, %ymm0
vinserti128 $1,  88(%rsi), %ymm1, %ymm1
vinserti128 $1, 104(%rsi), %ymm2, %ymm2
vinserti128 $1, 120(%rsi), %ymm3, %ymm3

vinserti128 $1, %xmm10, %ymm4, %ymm4

#shuffle
vpshufb   _unpack96_masks+0(%rip), %ymm0,  %ymm6
vpshufb  _unpack96_masks+32(%rip), %ymm1, %ymm10
vpshufb  _unpack96_masks+64(%rip), %ymm1,  %ymm7
vpshufb  _unpack96_masks+96(%rip), %ymm2, %ymm11
vpshufb _unpack96_masks+128(%rip), %ymm2,  %ymm8
vpshufb _unpack96_masks+160(%rip), %ymm3, %ymm12
vpshufb _unpack96_masks+192(%rip), %ymm3,  %ymm9
vpshufb _unpack96_masks+224(%rip), %ymm4, %ymm13
vpshufb _unpack96_masks+256(%rip), %ymm0,  %ymm5
vpshufb _unpack96_masks+288(%rip), %ymm1,  %ymm0
vpshufb _unpack96_masks+320(%rip), %ymm2,  %ymm1
vpshufb _unpack96_masks+352(%rip), %ymm3,  %ymm2
vpshufb _unpack96_masks+384(%rip), %ymm4,  %ymm3

vpor %ymm10, %ymm6, %ymm6
vpor %ymm11, %ymm7, %ymm7
vpor %ymm12, %ymm8, %ymm8
vpor %ymm13, %ymm9, %ymm9
vpor %ymm0, %ymm5, %ymm5
vpor %ymm1, %ymm5, %ymm5
vpor %ymm2, %ymm5, %ymm5
vpor %ymm3, %ymm5, %ymm5

vpunpcklwd %ymm7, %ymm6, %ymm0
vpunpckhwd %ymm7, %ymm6, %ymm1
vpunpcklwd %ymm9, %ymm8, %ymm2
vpunpckhwd %ymm9, %ymm8, %ymm3

vpunpcklwd %ymm1, %ymm0, %ymm6
vpunpckhwd %ymm1, %ymm0, %ymm7
vpunpcklwd %ymm3, %ymm2, %ymm8
vpunpckhwd %ymm3, %ymm2, %ymm9

vpunpcklqdq %ymm8, %ymm6, %ymm0
vpunpckhqdq %ymm8, %ymm6, %ymm6
vpunpcklqdq %ymm9, %ymm7, %ymm8
vpunpckhqdq %ymm9, %ymm7, %ymm9

#unpack
vpsrlw    $12, %ymm0,  %ymm1
vpand  %ymm15, %ymm0,  %ymm0
vpsllw     $4, %ymm6, %ymm10
vpor   %ymm10, %ymm1,  %ymm1
vpand  %ymm15, %ymm1,  %ymm1
vpsrlw     $8, %ymm6,  %ymm2
vpsllw     $8, %ymm8, %ymm10
vpor   %ymm10, %ymm2,  %ymm2
vpand  %ymm15, %ymm2,  %ymm2
vpsrlw     $4, %ymm8,  %ymm3
vpand  %ymm15, %ymm9,  %ymm4
vpsllw     $4, %ymm5,  %ymm5
vpsrlw    $12, %ymm9, %ymm10
vpor   %ymm10, %ymm5,  %ymm5

#check: accept [0,q-1]
vpmaxuw          %ymm1, %ymm0, %ymm6
vpmaxuw          %ymm3, %ymm2, %ymm7
vpmaxuw          %ymm5, %ymm4, %ymm8
vpmaxuw          %ymm7, %ymm6, %ymm6
vpmaxuw          %ymm8, %ymm6, %ymm6
vpcmpgtw _16xqm1(%rip), %ymm6, %ymm6
vpmovmskb %ymm6, %edx
or %edx, %eax

#store
vmovdqa %ymm0,   0(%rdi)
vmovdqa %ymm1,  32(%rdi)
vmovdqa %ymm2,  64(%rdi)
vmovdqa %ymm3,  96(%rdi)
vmovdqa %ymm4, 128(%rdi)
vmovdqa %ymm5, 160(%rdi)

add $144, %rsi
add $192, %rdi
cmp %r8, %rsi
jb _looptop_poly_frombytes

test   %eax, %eax
setne  %al
movzbl  %al, %eax
ret

.ifndef no_gnu_stack
.section .note.GNU-stack, "", @progbits
.endif