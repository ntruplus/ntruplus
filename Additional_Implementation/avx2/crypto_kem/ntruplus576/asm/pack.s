.global poly_tobytes
poly_tobytes:

xor		%eax,%eax
.p2align 5
_looptop_poly_tobytes:
#load
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3

vpsllw		$12,%ymm1,%ymm15
vpxor		%ymm15,%ymm0,%ymm0
vmovdqu		%ymm0,(%rdi)

vpsllw		$8,%ymm2,%ymm15
vpsrlw		$4,%ymm1,%ymm14
vpxor		%ymm15,%ymm14,%ymm0
vmovdqu		%ymm0,32(%rdi)

vpsllw		$4,%ymm3,%ymm15
vpsrlw		$8,%ymm2,%ymm14
vpxor		%ymm15,%ymm14,%ymm0
vmovdqu		%ymm0,64(%rdi)

add     $96,%rdi
add     $128,%rsi

add		$64,%eax
cmp		$576,%eax
jb		_looptop_poly_tobytes

ret

.global poly_frombytes
poly_frombytes:

vmovdqa		_low_mask(%rip),%ymm15

xor		%eax,%eax
.p2align 5
_looptop_poly_frombytes:
#load
vmovdqu		(%rsi),%ymm0
vmovdqu		32(%rsi),%ymm1
vmovdqu		64(%rsi),%ymm2

vpand       %ymm15,%ymm0,%ymm13
vmovdqa		%ymm13,(%rdi)

vpsrlw		$12,%ymm0,%ymm0
vpsllw		$4,%ymm1,%ymm13
vpxor		%ymm13,%ymm0,%ymm0
vpand		%ymm15,%ymm0,%ymm0
vmovdqa		%ymm0,32(%rdi)

vpsrlw		$8,%ymm1,%ymm0
vpsllw		$8,%ymm2,%ymm13
vpxor		%ymm13,%ymm0,%ymm0
vpand		%ymm15,%ymm0,%ymm0
vmovdqa		%ymm0,64(%rdi)

vpsrlw		$4,%ymm2,%ymm0
vpand		%ymm15,%ymm0,%ymm0
vmovdqa		%ymm0,96(%rdi)

add     $128,%rdi
add     $96,%rsi

add		$64,%eax
cmp		$576,%eax
jb		_looptop_poly_frombytes

ret

.global poly_ntt_unpack
poly_ntt_unpack:
xor		%rax,%rax
.p2align 5
_looptop_poly_ntt_unpack:
#loads
vmovdqa		(%rsi),%ymm6
vmovdqa		32(%rsi),%ymm7
vmovdqa		64(%rsi),%ymm8
vmovdqa		96(%rsi),%ymm9

#shuffle
vperm2i128	$0x20,%ymm8,%ymm6,%ymm11
vperm2i128	$0x31,%ymm8,%ymm6,%ymm12
vperm2i128	$0x20,%ymm9,%ymm7,%ymm13
vperm2i128	$0x31,%ymm9,%ymm7,%ymm14

#shuffle
vpunpcklqdq	%ymm13,%ymm11,%ymm4
vpunpckhqdq	%ymm13,%ymm11,%ymm5
vpunpcklqdq	%ymm14,%ymm12,%ymm6
vpunpckhqdq	%ymm14,%ymm12,%ymm7

vmovdqa %ymm4,%ymm11
vmovdqa %ymm5,%ymm12
vmovdqa %ymm6,%ymm13
vmovdqa %ymm7,%ymm14

#shuffle
vpsllq		$32,%ymm13,%ymm2
vpblendd	$0xAA,%ymm2,%ymm11,%ymm4
vpsrlq		$32,%ymm11,%ymm11
vpblendd	$0xAA,%ymm13,%ymm11,%ymm5
vpsllq		$32,%ymm14,%ymm2
vpblendd	$0xAA,%ymm2,%ymm12,%ymm6
vpsrlq		$32,%ymm12,%ymm12
vpblendd	$0xAA,%ymm14,%ymm12,%ymm7

vmovdqa %ymm4,%ymm11
vmovdqa %ymm5,%ymm12
vmovdqa %ymm6,%ymm13
vmovdqa %ymm7,%ymm14

#shuffle
vpsllq		$16,%ymm13,%ymm2
vpblendw	$0xAA,%ymm2,%ymm11,%ymm4
vpsrlq		$16,%ymm11,%ymm11
vpblendw	$0xAA,%ymm13,%ymm11,%ymm5
vpsllq		$16,%ymm14,%ymm2
vpblendw	$0xAA,%ymm2,%ymm12,%ymm6
vpsrlq		$16,%ymm12,%ymm12
vpblendw	$0xAA,%ymm14,%ymm12,%ymm7

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,96(%rdi)

add		$128,%rsi
add		$128,%rdi
add		$64,%rax
cmp		$576,%rax

jb		_looptop_poly_ntt_unpack

ret

.global poly_invntt_unpack
poly_invntt_unpack:
xor		%rax,%rax
.p2align 5
_looptop_poly_invntt_unpack:
#level6
#load
#load
vmovdqa		(%rsi),%ymm6
vmovdqa		32(%rsi),%ymm7
vmovdqa		64(%rsi),%ymm8
vmovdqa		96(%rsi),%ymm9

#shuffle
vpslld		$16,%ymm7,%ymm10
vpslld		$16,%ymm9,%ymm11
vpblendw	$0xAA,%ymm10,%ymm6,%ymm4
vpblendw	$0xAA,%ymm11,%ymm8,%ymm5
vpsrld		$16,%ymm6,%ymm12
vpsrld		$16,%ymm8,%ymm13
vpblendw	$0xAA,%ymm7,%ymm12,%ymm6
vpblendw	$0xAA,%ymm9,%ymm13,%ymm7

vmovdqa %ymm7,%ymm9
vmovdqa %ymm6,%ymm8
vmovdqa %ymm5,%ymm7
vmovdqa %ymm4,%ymm6

#shuffle
vpsllq		$32,%ymm7,%ymm10
vpsllq		$32,%ymm9,%ymm11
vpblendd	$0xAA,%ymm10,%ymm6,%ymm4
vpblendd	$0xAA,%ymm11,%ymm8,%ymm5
vpsrlq		$32,%ymm6,%ymm12
vpsrlq		$32,%ymm8,%ymm13
vpblendd	$0xAA,%ymm7,%ymm12,%ymm6
vpblendd	$0xAA,%ymm9,%ymm13,%ymm7

vmovdqa %ymm7,%ymm9
vmovdqa %ymm6,%ymm8
vmovdqa %ymm5,%ymm7
vmovdqa %ymm4,%ymm6

#shuffle
vpunpcklqdq	%ymm7,%ymm6,%ymm4
vpunpcklqdq	%ymm9,%ymm8,%ymm5
vpunpckhqdq	%ymm7,%ymm6,%ymm6
vpunpckhqdq	%ymm9,%ymm8,%ymm7

vmovdqa %ymm7,%ymm9
vmovdqa %ymm6,%ymm8
vmovdqa %ymm5,%ymm7
vmovdqa %ymm4,%ymm6

#shuffle
vperm2i128	$0x20,%ymm7,%ymm6,%ymm4
vperm2i128	$0x31,%ymm7,%ymm6,%ymm6
vperm2i128	$0x20,%ymm9,%ymm8,%ymm5
vperm2i128	$0x31,%ymm9,%ymm8,%ymm7

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,96(%rdi)

add		$128,%rsi
add		$128,%rdi
add		$64,%rax
cmp		$576,%rax
jb		_looptop_poly_invntt_unpack

ret
/*
.global poly_ntt_unpack
poly_ntt_unpack:
xor		%rax,%rax
_looptop_poly_ntt_unpack:
#load
vmovdqa		(%rsi),%ymm1
vmovdqa		32(%rsi),%ymm2
vmovdqa		64(%rsi),%ymm3
vmovdqa		96(%rsi),%ymm4
vmovdqa		128(%rsi),%ymm5
vmovdqa		160(%rsi),%ymm6

vperm2i128	$0x20,%ymm4,%ymm1,%ymm7
vperm2i128	$0x31,%ymm4,%ymm1,%ymm8
vperm2i128	$0x20,%ymm5,%ymm2,%ymm9
vperm2i128	$0x31,%ymm5,%ymm2,%ymm10
vperm2i128	$0x20,%ymm6,%ymm3,%ymm11
vperm2i128	$0x31,%ymm6,%ymm3,%ymm12

vpunpcklqdq	%ymm10,%ymm7,%ymm1
vpunpckhqdq	%ymm10,%ymm7,%ymm2
vpunpcklqdq	%ymm11,%ymm8,%ymm3
vpunpckhqdq	%ymm11,%ymm8,%ymm4
vpunpcklqdq	%ymm12,%ymm9,%ymm5
vpunpckhqdq	%ymm12,%ymm9,%ymm6

vpsllq      $32,%ymm4,%ymm7
vpsrlq      $32,%ymm1,%ymm8
vpsllq      $32,%ymm5,%ymm9
vpsrlq      $32,%ymm2,%ymm10
vpsllq      $32,%ymm6,%ymm11
vpsrlq      $32,%ymm3,%ymm12

vpblendd	$0xAA,%ymm7,%ymm1,%ymm7
vpblendd	$0xAA,%ymm4,%ymm8,%ymm8
vpblendd	$0xAA,%ymm9,%ymm2,%ymm9
vpblendd	$0xAA,%ymm5,%ymm10,%ymm10
vpblendd	$0xAA,%ymm11,%ymm3,%ymm11
vpblendd	$0xAA,%ymm6,%ymm12,%ymm12

vmovdqa		%ymm7,%ymm3
vmovdqa		%ymm8,%ymm4
vmovdqa		%ymm9,%ymm5
vmovdqa		%ymm10,%ymm6
vmovdqa		%ymm11,%ymm7
vmovdqa		%ymm12,%ymm8

#shuffle
vpslld		$16,%ymm4,%ymm2
vpblendw	$0xAA,%ymm2,%ymm3,%ymm2
vpsrld		$16,%ymm3,%ymm3
vpblendw	$0xAA,%ymm4,%ymm3,%ymm3
vpslld		$16,%ymm6,%ymm4
vpblendw	$0xAA,%ymm4,%ymm5,%ymm4
vpsrld		$16,%ymm5,%ymm5
vpblendw	$0xAA,%ymm6,%ymm5,%ymm5
vpslld		$16,%ymm8,%ymm6
vpblendw	$0xAA,%ymm6,%ymm7,%ymm6
vpsrld		$16,%ymm7,%ymm7
vpblendw	$0xAA,%ymm8,%ymm7,%ymm7

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)

add     $192,%rdi
add     $192,%rsi

add		$96,%rax
cmp		$768,%rax
jb		_looptop_poly_ntt_unpack

ret



.global poly_ntt_pack
poly_ntt_pack:
xor		%rax,%rax
_looptop_poly_ntt_pack:
#load
vmovdqa		(%rsi),%ymm3
vmovdqa		32(%rsi),%ymm4
vmovdqa		64(%rsi),%ymm5
vmovdqa		96(%rsi),%ymm6
vmovdqa		128(%rsi),%ymm7
vmovdqa		160(%rsi),%ymm8

#shuffle
vpslld		$16,%ymm4,%ymm2
vpblendw	$0xAA,%ymm2,%ymm3,%ymm2
vpsrld		$16,%ymm3,%ymm3
vpblendw	$0xAA,%ymm4,%ymm3,%ymm3
vpslld		$16,%ymm6,%ymm4
vpblendw	$0xAA,%ymm4,%ymm5,%ymm4
vpsrld		$16,%ymm5,%ymm5
vpblendw	$0xAA,%ymm6,%ymm5,%ymm5
vpslld		$16,%ymm8,%ymm6
vpblendw	$0xAA,%ymm6,%ymm7,%ymm6
vpsrld		$16,%ymm7,%ymm7
vpblendw	$0xAA,%ymm8,%ymm7,%ymm7

#store
vmovdqa		%ymm2,%ymm1 #X
vmovdqa		%ymm3,%ymm2 #Y
vmovdqa		%ymm4,%ymm3 #Z
vmovdqa		%ymm5,%ymm4
vmovdqa		%ymm6,%ymm5
vmovdqa		%ymm7,%ymm6

vpsllq      $32,%ymm2,%ymm7
vpsllq      $32,%ymm4,%ymm8
vpsllq      $32,%ymm6,%ymm9
vpsrlq      $32,%ymm1,%ymm10
vpsrlq      $32,%ymm3,%ymm11
vpsrlq      $32,%ymm5,%ymm12

vpblendd	$0xAA,%ymm7,%ymm1,%ymm7
vpblendd	$0xAA,%ymm8,%ymm3,%ymm8
vpblendd	$0xAA,%ymm9,%ymm5,%ymm9
vpblendd	$0xAA,%ymm2,%ymm10,%ymm10
vpblendd	$0xAA,%ymm4,%ymm11,%ymm11
vpblendd	$0xAA,%ymm6,%ymm12,%ymm12

vpunpcklqdq	%ymm8,%ymm7,%ymm1
vpunpcklqdq	%ymm10,%ymm9,%ymm2
vpunpcklqdq	%ymm12,%ymm11,%ymm3
vpunpckhqdq	%ymm8,%ymm7,%ymm4
vpunpckhqdq	%ymm10,%ymm9,%ymm5
vpunpckhqdq	%ymm12,%ymm11,%ymm6

vperm2i128	$0x20,%ymm2,%ymm1,%ymm7
vperm2i128	$0x20,%ymm4,%ymm3,%ymm8
vperm2i128	$0x20,%ymm6,%ymm5,%ymm9
vperm2i128	$0x31,%ymm2,%ymm1,%ymm10
vperm2i128	$0x31,%ymm4,%ymm3,%ymm11
vperm2i128	$0x31,%ymm6,%ymm5,%ymm12

#store
vmovdqa		%ymm7,(%rdi)
vmovdqa		%ymm8,32(%rdi)
vmovdqa		%ymm9,64(%rdi)
vmovdqa		%ymm10,96(%rdi)
vmovdqa		%ymm11,128(%rdi)
vmovdqa		%ymm12,160(%rdi)

add     $192,%rdi
add     $192,%rsi

add		$96,%rax
cmp		$768,%rax
jb		_looptop_poly_ntt_pack

ret

*/



