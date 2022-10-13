/*
.global poly_pack_uniform
poly_pack_uniform:

xor		%eax,%eax
.p2align 5
_looptop_pack_uniform:
#load
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3

vpsllw		$12,%ymm1,%ymm15
vpaddw		%ymm15,%ymm0,%ymm0
vmovdqu		%ymm0,(%rdi)

vpsllw		$8,%ymm2,%ymm15
vpsrlw		$4,%ymm1,%ymm14
vpaddw		%ymm15,%ymm14,%ymm0
vmovdqu		%ymm0,32(%rdi)

vpsllw		$4,%ymm3,%ymm15
vpsrlw		$8,%ymm2,%ymm14
vpaddw		%ymm15,%ymm14,%ymm0
vmovdqu		%ymm0,64(%rdi)

add     $96,%rdi
add     $128,%rsi

add		$64,%eax
cmp		$768,%eax
jb		_looptop_pack_uniform

ret

.global poly_unpack_uniform
poly_unpack_uniform:

vmovdqa		_low_mask(%rip),%ymm15

xor		%eax,%eax
.p2align 5
_looptop_unpack_uniform:
#load
vmovdqu		(%rsi),%ymm0
vmovdqu		32(%rsi),%ymm1
vmovdqu		64(%rsi),%ymm2

vpand       %ymm15,%ymm0,%ymm13
vmovdqa		%ymm13,(%rdi)

vpsrlw		$12,%ymm0,%ymm0
vpsllw		$4,%ymm1,%ymm13
vpaddw		%ymm13,%ymm0,%ymm0
vpand		%ymm15,%ymm0,%ymm0
vmovdqa		%ymm0,32(%rdi)

vpsrlw		$8,%ymm1,%ymm0
vpsllw		$8,%ymm2,%ymm13
vpaddw		%ymm13,%ymm0,%ymm0
vpand		%ymm15,%ymm0,%ymm0
vmovdqa		%ymm0,64(%rdi)

vpsrlw		$4,%ymm2,%ymm0
vpand		%ymm15,%ymm0,%ymm0
vmovdqa		%ymm0,96(%rdi)

add     $128,%rdi
add     $96,%rsi

add		$64,%eax
cmp		$768,%eax
jb		_looptop_unpack_uniform

ret

.global poly_pack_short_partial
poly_pack_short_partial:

vmovdqa		_16x1(%rip),%ymm0
vpsrlw		$1,%ymm0,%ymm0

xor		%rax,%rax
.p2align 5
_looptop_pack_short_partial:
#load
vmovdqa		(%rsi),%ymm1
vmovdqa		32(%rsi),%ymm2
vmovdqa		64(%rsi),%ymm3
vmovdqa		96(%rsi),%ymm4
vmovdqa		128(%rsi),%ymm5
vmovdqa		160(%rsi),%ymm6
vmovdqa		192(%rsi),%ymm7
vmovdqa		224(%rsi),%ymm8

vpaddw		%ymm0,%ymm1,%ymm1
vpaddw		%ymm0,%ymm2,%ymm2
vpaddw		%ymm0,%ymm3,%ymm3
vpaddw		%ymm0,%ymm4,%ymm4
vpaddw		%ymm0,%ymm5,%ymm5
vpaddw		%ymm0,%ymm6,%ymm6
vpaddw		%ymm0,%ymm7,%ymm7
vpaddw		%ymm0,%ymm8,%ymm8
vpsllw		$2,%ymm2,%ymm2
vpsllw		$4,%ymm3,%ymm3
vpsllw		$6,%ymm4,%ymm4
vpsllw		$8,%ymm5,%ymm5
vpsllw		$10,%ymm6,%ymm6
vpsllw		$12,%ymm7,%ymm7
vpsllw		$14,%ymm8,%ymm8
vpaddw		%ymm2,%ymm1,%ymm1
vpaddw		%ymm4,%ymm3,%ymm3
vpaddw		%ymm6,%ymm5,%ymm5
vpaddw		%ymm8,%ymm7,%ymm7
vpaddw		%ymm1,%ymm3,%ymm1
vpaddw		%ymm7,%ymm5,%ymm5
vpaddw		%ymm1,%ymm5,%ymm1
vmovdqu		%ymm1,(%rdi)

add		$256,%rsi
add		$32,%rdi
add		$128,%rax
cmp		$512,%rax
jb		_looptop_pack_short_partial

ret
*/

.global poly_tobytes
poly_tobytes:

xor		%eax,%eax
.p2align 5
_looptop_poly_tobytes:
#load
vmovdqa		(%rsi),%ymm5
vmovdqa		32(%rsi),%ymm6
vmovdqa		64(%rsi),%ymm7
vmovdqa		96(%rsi),%ymm8
vmovdqa		128(%rsi),%ymm9
vmovdqa		160(%rsi),%ymm10
vmovdqa		192(%rsi),%ymm11
vmovdqa		224(%rsi),%ymm12

vpsllw		$12,%ymm6,%ymm4
vpor		%ymm4,%ymm5,%ymm4
vmovdqu		%ymm4,(%rdi)

vpsrlw		$4,%ymm6,%ymm5
vpsllw		$8,%ymm7,%ymm6
vpor		%ymm5,%ymm6,%ymm5
vmovdqu		%ymm5,32(%rdi)

vpsrlw		$8,%ymm7,%ymm6
vpsllw		$4,%ymm8,%ymm7
vpor		%ymm6,%ymm7,%ymm6
vmovdqu		%ymm6,64(%rdi)

vpsllw		$12,%ymm10,%ymm7
vpor		%ymm7,%ymm9,%ymm7
vmovdqu		%ymm7,96(%rdi)

vpsrlw		$4,%ymm10,%ymm8
vpsllw		$8,%ymm11,%ymm9
vpor		%ymm8,%ymm9,%ymm8
vmovdqu		%ymm8,128(%rdi)

vpsrlw		$8,%ymm11,%ymm9
vpsllw		$4,%ymm12,%ymm10
vpor		%ymm9,%ymm10,%ymm9
vmovdqu		%ymm9,160(%rdi)

#shuffle1 4,5,3,5
vpslld		$16,%ymm5,%ymm3
vpblendw	$0xAA,%ymm3,%ymm4,%ymm3
vpsrld		$16,%ymm4,%ymm4
vpblendw	$0xAA,%ymm5,%ymm4,%ymm5

#shuffle1 6,7,4,7
vpslld		$16,%ymm7,%ymm4
vpblendw	$0xAA,%ymm4,%ymm6,%ymm4
vpsrld		$16,%ymm6,%ymm6
vpblendw	$0xAA,%ymm7,%ymm6,%ymm7

#shuffle1 8,9,6,9
vpslld		$16,%ymm9,%ymm6
vpblendw	$0xAA,%ymm6,%ymm8,%ymm6
vpsrld		$16,%ymm8,%ymm8
vpblendw	$0xAA,%ymm9,%ymm8,%ymm9

#shuffle2 3,4,8,4
vmovsldup	%ymm4,%ymm8
vpblendd	$0xAA,%ymm8,%ymm3,%ymm8
vpsrlq		$32,%ymm3,%ymm3
vpblendd	$0xAA,%ymm4,%ymm3,%ymm4

#shuffle2 6,5,3,5
vmovsldup	%ymm5,%ymm3
vpblendd	$0xAA,%ymm3,%ymm6,%ymm3
vpsrlq		$32,%ymm6,%ymm6
vpblendd	$0xAA,%ymm5,%ymm6,%ymm5

#shuffle2 7,9,6,9
vmovsldup	%ymm9,%ymm6
vpblendd	$0xAA,%ymm6,%ymm7,%ymm6
vpsrlq		$32,%ymm7,%ymm7
vpblendd	$0xAA,%ymm9,%ymm7,%ymm9


#shuffle4 8,3,7,3
vpunpcklqdq	%ymm3,%ymm8,%ymm7
vpunpckhqdq	%ymm3,%ymm8,%ymm3

#shuffle4 6,4,8,4
vpunpcklqdq	%ymm4,%ymm6,%ymm8
vpunpckhqdq	%ymm4,%ymm6,%ymm4

#shuffle4 5,9,6,9
vpunpcklqdq	%ymm9,%ymm5,%ymm6
vpunpckhqdq	%ymm9,%ymm5,%ymm9

#shuffle8 7,8,5,8
vperm2i128	$0x20,%ymm8,%ymm7,%ymm5
vperm2i128	$0x31,%ymm8,%ymm7,%ymm8

#shuffle8 6,3,7,3
vperm2i128	$0x20,%ymm3,%ymm6,%ymm7
vperm2i128	$0x31,%ymm3,%ymm6,%ymm3

#shuffle8 4,9,6,9
vperm2i128	$0x20,%ymm9,%ymm4,%ymm6
vperm2i128	$0x31,%ymm9,%ymm4,%ymm9

#store
vmovdqu		%ymm5,(%rdi)
vmovdqu		%ymm7,32(%rdi)
vmovdqu		%ymm6,64(%rdi)
vmovdqu		%ymm8,96(%rdi)
vmovdqu		%ymm3,128(%rdi)
vmovdqu		%ymm9,160(%rdi)

add     $192,%rdi
add     $256,%rsi
add		$128,%eax
cmp		$768,%eax
jb		_looptop_poly_tobytes

ret

.global poly_frombytes
poly_frombytes:
vmovdqa		_low_mask(%rip),%ymm0
xor		%eax,%eax
.p2align 5
_looptop_poly_frombytes:
#load
vmovdqu		(%rsi),%ymm4
vmovdqu		32(%rsi),%ymm5
vmovdqu		64(%rsi),%ymm6
vmovdqu		96(%rsi),%ymm7
vmovdqu		128(%rsi),%ymm8
vmovdqu		160(%rsi),%ymm9

#shuffle8 4,3,7,3
vperm2i128	$0x20,%ymm7,%ymm4,%ymm3
vperm2i128	$0x31,%ymm7,%ymm4,%ymm7

#shuffle8 5,8,4,8
vperm2i128	$0x20,%ymm8,%ymm5,%ymm4
vperm2i128	$0x31,%ymm8,%ymm5,%ymm8

#shuffle8 6,9,5,9
vperm2i128	$0x20,%ymm9,%ymm6,%ymm5
vperm2i128	$0x31,%ymm9,%ymm6,%ymm9


#shuffle4 3,8,6,8
vpunpcklqdq	%ymm8,%ymm3,%ymm6
vpunpckhqdq	%ymm8,%ymm3,%ymm8

#shuffle4 7,5,3,5
vpunpcklqdq	%ymm5,%ymm7,%ymm3
vpunpckhqdq	%ymm5,%ymm7,%ymm5

#shuffle4 4,9,7,9
vpunpcklqdq	%ymm9,%ymm4,%ymm7
vpunpckhqdq	%ymm9,%ymm4,%ymm9


#shuffle2 6,5,4,5
vmovsldup	%ymm5,%ymm4
vpblendd	$0xAA,%ymm4,%ymm6,%ymm4
vpsrlq		$32,%ymm6,%ymm6
vpblendd	$0xAA,%ymm5,%ymm6,%ymm5

#shuffle2 8,7,6,7
vmovsldup	%ymm7,%ymm6
vpblendd	$0xAA,%ymm6,%ymm8,%ymm6
vpsrlq		$32,%ymm8,%ymm8
vpblendd	$0xAA,%ymm7,%ymm8,%ymm7

#shuffle2 3,9,8,9
vmovsldup	%ymm9,%ymm8
vpblendd	$0xAA,%ymm8,%ymm3,%ymm8
vpsrlq		$32,%ymm3,%ymm3
vpblendd	$0xAA,%ymm9,%ymm3,%ymm9


#shuffle1 4,7,10,7
vpslld		$16,%ymm7,%ymm10
vpblendw	$0xAA,%ymm10,%ymm4,%ymm10
vpsrld		$16,%ymm4,%ymm4
vpblendw	$0xAA,%ymm7,%ymm4,%ymm7

#shuffle1 5,8,4,8
vpslld		$16,%ymm8,%ymm4
vpblendw	$0xAA,%ymm4,%ymm5,%ymm4
vpsrld		$16,%ymm5,%ymm5
vpblendw	$0xAA,%ymm8,%ymm5,%ymm8

#shuffle1 6,9,5,9
vpslld		$16,%ymm9,%ymm5
vpblendw	$0xAA,%ymm5,%ymm6,%ymm5
vpsrld		$16,%ymm6,%ymm6
vpblendw	$0xAA,%ymm9,%ymm6,%ymm9


#bitunpack
vpsrlw		$12,%ymm10,%ymm11
vpsllw		$4,%ymm7,%ymm12
vpor		%ymm11,%ymm12,%ymm11
vpand		%ymm0,%ymm10,%ymm10
vpand		%ymm0,%ymm11,%ymm11

vpsrlw		$8,%ymm7,%ymm12
vpsllw		$8,%ymm4,%ymm13
vpor		%ymm12,%ymm13,%ymm12
vpand		%ymm0,%ymm12,%ymm12

vpsrlw		$4,%ymm4,%ymm13
vpand		%ymm0,%ymm13,%ymm13

vpsrlw		$12,%ymm8,%ymm14
vpsllw		$4,%ymm5,%ymm15
vpor		%ymm14,%ymm15,%ymm14
vpand		%ymm0,%ymm8,%ymm8
vpand		%ymm0,%ymm14,%ymm14

vpsrlw		$8,%ymm5,%ymm15
vpsllw		$8,%ymm9,%ymm1
vpor		%ymm15,%ymm1,%ymm15
vpand		%ymm0,%ymm15,%ymm15

vpsrlw		$4,%ymm9,%ymm1
vpand		%ymm0,%ymm1,%ymm1

#store
vmovdqa		%ymm10,(%rdi)
vmovdqa		%ymm11,32(%rdi)
vmovdqa		%ymm12,64(%rdi)
vmovdqa		%ymm13,96(%rdi)
vmovdqa		%ymm8,128(%rdi)
vmovdqa		%ymm14,160(%rdi)
vmovdqa		%ymm15,192(%rdi)
vmovdqa		%ymm1,224(%rdi)

add     $256,%rdi
add     $192,%rsi

add		$128,%eax
cmp		$768,%eax
jb		_looptop_poly_frombytes

ret

.global poly_pack_short_partial
poly_pack_short_partial:

vmovdqa		_16x1(%rip),%ymm0
vpsrlw		$1,%ymm0,%ymm0

xor		%rax,%rax
.p2align 5
_looptop_pack_short_partial:
#load
vmovdqa		(%rsi),%ymm1
vmovdqa		32(%rsi),%ymm2
vmovdqa		64(%rsi),%ymm3
vmovdqa		96(%rsi),%ymm4
vmovdqa		128(%rsi),%ymm5
vmovdqa		160(%rsi),%ymm6
vmovdqa		192(%rsi),%ymm7
vmovdqa		224(%rsi),%ymm8

vpaddw		%ymm0,%ymm1,%ymm1
vpaddw		%ymm0,%ymm2,%ymm2
vpaddw		%ymm0,%ymm3,%ymm3
vpaddw		%ymm0,%ymm4,%ymm4
vpaddw		%ymm0,%ymm5,%ymm5
vpaddw		%ymm0,%ymm6,%ymm6
vpaddw		%ymm0,%ymm7,%ymm7
vpaddw		%ymm0,%ymm8,%ymm8
vpsllw		$2,%ymm2,%ymm2
vpsllw		$4,%ymm3,%ymm3
vpsllw		$6,%ymm4,%ymm4
vpsllw		$8,%ymm5,%ymm5
vpsllw		$10,%ymm6,%ymm6
vpsllw		$12,%ymm7,%ymm7
vpsllw		$14,%ymm8,%ymm8
vpaddw		%ymm2,%ymm1,%ymm1
vpaddw		%ymm4,%ymm3,%ymm3
vpaddw		%ymm6,%ymm5,%ymm5
vpaddw		%ymm8,%ymm7,%ymm7
vpaddw		%ymm1,%ymm3,%ymm1
vpaddw		%ymm7,%ymm5,%ymm5
vpaddw		%ymm1,%ymm5,%ymm1
vmovdqu		%ymm1,(%rdi)

add		$256,%rsi
add		$32,%rdi
add		$128,%rax
cmp		$512,%rax
jb		_looptop_pack_short_partial

ret



.global poly_ntt_pack
poly_ntt_pack:
xor		%rax,%rax
_looptop_poly_ntt_pack:
#load
vmovdqa		(%rsi),%ymm1
vmovdqa		32(%rsi),%ymm2
vmovdqa		64(%rsi),%ymm3
vmovdqa		96(%rsi),%ymm4
vmovdqa		128(%rsi),%ymm5
vmovdqa		160(%rsi),%ymm6

vpslld      $32,%ymm1,%ymm7
vpblendd	$0xAA,%ymm7,%ymm2,%ymm7
vpsrld      $32,%ymm2,%ymm8
vpblendd	$0xAA,%ymm8,%ymm1,%ymm8

vpslld      $32,%ymm1,%ymm7
vpblendw	$0xAA,%ymm7,%ymm2,%ymm7
vpsrld      $32,%ymm2,%ymm8
vpblendw	$0xAA,%ymm8,%ymm1,%ymm8

