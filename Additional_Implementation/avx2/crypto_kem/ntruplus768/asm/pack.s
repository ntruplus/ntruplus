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

