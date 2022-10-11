.global poly_ntt
poly_ntt:
vmovdqa		_16xq(%rip),%ymm0
lea		zetas_exp(%rip),%rdx

#level0
#zetas
vpbroadcastd	(%rdx),%ymm1
vpbroadcastd	4(%rdx),%ymm2

xor		%rax,%rax
.p2align 5
_looptop_j_0:
#load
vmovdqa		768(%rsi),%ymm4
vmovdqa		800(%rsi),%ymm5
vmovdqa		832(%rsi),%ymm6
vmovdqa		864(%rsi),%ymm7
vmovdqa		896(%rsi),%ymm8
vmovdqa		928(%rsi),%ymm9

#mul
vpmullw		%ymm1,%ymm4,%ymm10
vpmullw		%ymm1,%ymm5,%ymm11
vpmullw		%ymm1,%ymm6,%ymm12
vpmullw		%ymm1,%ymm7,%ymm13
vpmullw		%ymm1,%ymm8,%ymm14
vpmullw		%ymm1,%ymm9,%ymm15
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13
vpsubw		%ymm14,%ymm8,%ymm14
vpsubw		%ymm15,%ymm9,%ymm15

#load
vmovdqa		(%rsi),%ymm4
vmovdqa		32(%rsi),%ymm5
vmovdqa		64(%rsi),%ymm6
vmovdqa		96(%rsi),%ymm7
vmovdqa		128(%rsi),%ymm8
vmovdqa		160(%rsi),%ymm9

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		768(%rsi),%ymm10,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		800(%rsi),%ymm11,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		832(%rsi),%ymm12,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		864(%rsi),%ymm13,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		896(%rsi),%ymm14,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15
vpaddw		928(%rsi),%ymm15,%ymm15

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm4,32(%rdi)
vmovdqa		%ymm5,64(%rdi)
vmovdqa		%ymm6,96(%rdi)
vmovdqa		%ymm7,128(%rdi)
vmovdqa		%ymm8,160(%rdi)
vmovdqa		%ymm10,768(%rdi)
vmovdqa		%ymm11,800(%rdi)
vmovdqa		%ymm12,832(%rdi)
vmovdqa		%ymm13,864(%rdi)
vmovdqa		%ymm14,896(%rdi)
vmovdqa		%ymm15,928(%rdi)

add		$192,%rdi
add		$192,%rsi
add		$192,%rax
cmp		$768,%eax
jb		_looptop_j_0

add		$8,%rdx
sub		$768,%rdi

#level 1
xor		%rax,%rax
.p2align 5
_looptop_start_1:
#zetas
vpbroadcastd	(%rdx),%ymm1
vpbroadcastd	4(%rdx),%ymm2

xor		%rcx,%rcx
.p2align 5
_looptop_j_1:
#load
vmovdqa		384(%rdi),%ymm4
vmovdqa		416(%rdi),%ymm5
vmovdqa		448(%rdi),%ymm6
vmovdqa		480(%rdi),%ymm7
vmovdqa		512(%rdi),%ymm8
vmovdqa		544(%rdi),%ymm9

#mul
vpmullw		%ymm1,%ymm4,%ymm10
vpmullw		%ymm1,%ymm5,%ymm11
vpmullw		%ymm1,%ymm6,%ymm12
vpmullw		%ymm1,%ymm7,%ymm13
vpmullw		%ymm1,%ymm8,%ymm14
vpmullw		%ymm1,%ymm9,%ymm15
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13
vpsubw		%ymm14,%ymm8,%ymm14
vpsubw		%ymm15,%ymm9,%ymm15

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm4,32(%rdi)
vmovdqa		%ymm5,64(%rdi)
vmovdqa		%ymm6,96(%rdi)
vmovdqa		%ymm7,128(%rdi)
vmovdqa		%ymm8,160(%rdi)
vmovdqa		%ymm10,384(%rdi)
vmovdqa		%ymm11,416(%rdi)
vmovdqa		%ymm12,448(%rdi)
vmovdqa		%ymm13,480(%rdi)
vmovdqa		%ymm14,512(%rdi)
vmovdqa		%ymm15,544(%rdi)

add		$192,%rdi
add		$192,%rcx
cmp		$384,%rcx
jb		_looptop_j_1

add		$8,%rdx
add		$384,%rdi
add		$768,%rax
cmp		$1536,%rax
jb		_looptop_start_1

sub		$1536,%rdi
vmovdqa		_low_mask(%rip),%ymm1

xor		%rax,%rax
xor		%r8,%r8
.p2align 5
_looptop_start_234567:
#level 2
#load
vpbroadcastd	(%rdx,%rax),%ymm2
vmovdqa		192(%rdi),%ymm4
vmovdqa		224(%rdi),%ymm5
vmovdqa		256(%rdi),%ymm6
vmovdqa		288(%rdi),%ymm7
vmovdqa		320(%rdi),%ymm8
vmovdqa		352(%rdi),%ymm9
vpbroadcastd	4(%rdx,%rax),%ymm3

#mul
vpmullw		%ymm2,%ymm4,%ymm10
vpmullw		%ymm2,%ymm5,%ymm11
vpmullw		%ymm2,%ymm6,%ymm12
vpmullw		%ymm2,%ymm7,%ymm13
vpmullw		%ymm2,%ymm8,%ymm14
vpmullw		%ymm2,%ymm9,%ymm15
vpmulhw		%ymm3,%ymm4,%ymm4
vpmulhw		%ymm3,%ymm5,%ymm5
vpmulhw		%ymm3,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8
vpmulhw		%ymm3,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13
vpsubw		%ymm14,%ymm8,%ymm14
vpsubw		%ymm15,%ymm9,%ymm15

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9

#reduce2
vpsraw		$12,%ymm4,%ymm2
vpsraw		$12,%ymm5,%ymm3
vpand		%ymm1,%ymm4,%ymm4
vpand		%ymm1,%ymm5,%ymm5
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpaddw		%ymm2,%ymm4,%ymm4
vpaddw		%ymm3,%ymm5,%ymm5

vpsraw		$12,%ymm6,%ymm2
vpsraw		$12,%ymm7,%ymm3
vpand		%ymm1,%ymm6,%ymm6
vpand		%ymm1,%ymm7,%ymm7
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpaddw		%ymm2,%ymm6,%ymm6
vpaddw		%ymm3,%ymm7,%ymm7

vpsraw		$12,%ymm8,%ymm2
vpsraw		$12,%ymm9,%ymm3
vpand		%ymm1,%ymm8,%ymm8
vpand		%ymm1,%ymm9,%ymm9
vpsubw		%ymm2,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsubw		%ymm2,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsubw		%ymm2,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpaddw		%ymm2,%ymm8,%ymm8
vpaddw		%ymm3,%ymm9,%ymm9

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm4,32(%rdi)
vmovdqa		%ymm5,64(%rdi)
vmovdqa		%ymm10,192(%rdi)
vmovdqa		%ymm11,224(%rdi)
vmovdqa		%ymm12,256(%rdi)

#level 3
#load
vmovdqa		%ymm6,%ymm4
vmovdqa		%ymm7,%ymm5
vmovdqa		%ymm8,%ymm6
vmovdqa		%ymm13,%ymm7
vmovdqa		%ymm14,%ymm8
vmovdqa		%ymm15,%ymm9
vpbroadcastd	32(%rdx,%rax,2),%ymm12
vpbroadcastd	40(%rdx,%rax,2),%ymm15
vpbroadcastd	36(%rdx,%rax,2),%ymm2
vpbroadcastd	44(%rdx,%rax,2),%ymm3

#mul
vpmullw		%ymm12,%ymm4,%ymm10
vpmullw		%ymm12,%ymm5,%ymm11
vpmullw		%ymm12,%ymm6,%ymm12
vpmullw		%ymm15,%ymm7,%ymm13
vpmullw		%ymm15,%ymm8,%ymm14
vpmullw		%ymm15,%ymm9,%ymm15
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8
vpmulhw		%ymm3,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13
vpsubw		%ymm14,%ymm8,%ymm14
vpsubw		%ymm15,%ymm9,%ymm15

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7
vmovdqa		224(%rdi),%ymm8
vmovdqa		256(%rdi),%ymm9

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15

#shuffle
vperm2i128	$0x20,%ymm10,%ymm3,%ymm2
vperm2i128	$0x31,%ymm10,%ymm3,%ymm3
vperm2i128	$0x20,%ymm11,%ymm4,%ymm10
vperm2i128	$0x31,%ymm11,%ymm4,%ymm4
vperm2i128	$0x20,%ymm12,%ymm5,%ymm11
vperm2i128	$0x31,%ymm12,%ymm5,%ymm5
vperm2i128	$0x20,%ymm13,%ymm6,%ymm12
vperm2i128	$0x31,%ymm13,%ymm6,%ymm6
vperm2i128	$0x20,%ymm14,%ymm7,%ymm13
vperm2i128	$0x31,%ymm14,%ymm7,%ymm7
vperm2i128	$0x20,%ymm15,%ymm8,%ymm14
vperm2i128	$0x31,%ymm15,%ymm8,%ymm8

#store

vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm10,64(%rdi)
vmovdqa		%ymm12,192(%rdi)
vmovdqa		%ymm6,224(%rdi)
vmovdqa		%ymm13,256(%rdi)



#level 4
#load
vmovdqa		%ymm5,%ymm6
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm8,%ymm9
vmovdqa		%ymm14,%ymm8
vmovdqu		96(%rdx,%r8),%ymm12
vmovdqu		160(%rdx,%r8),%ymm15
vmovdqu		128(%rdx,%r8),%ymm2
vmovdqu		192(%rdx,%r8),%ymm3

#mul
vpmullw		%ymm12,%ymm4,%ymm10
vpmullw		%ymm12,%ymm5,%ymm11
vpmullw		%ymm12,%ymm6,%ymm12
vpmullw		%ymm15,%ymm7,%ymm13
vpmullw		%ymm15,%ymm8,%ymm14
vpmullw		%ymm15,%ymm9,%ymm15
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8
vpmulhw		%ymm3,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13
vpsubw		%ymm14,%ymm8,%ymm14
vpsubw		%ymm15,%ymm9,%ymm15

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7
vmovdqa		224(%rdi),%ymm8
vmovdqa		256(%rdi),%ymm9

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15

#shuffle
vpunpcklqdq	%ymm10,%ymm3,%ymm2
vpunpckhqdq	%ymm10,%ymm3,%ymm3
vpunpcklqdq	%ymm11,%ymm4,%ymm10
vpunpckhqdq	%ymm11,%ymm4,%ymm4
vpunpcklqdq	%ymm12,%ymm5,%ymm11
vpunpckhqdq	%ymm12,%ymm5,%ymm5
vpunpcklqdq	%ymm13,%ymm6,%ymm12
vpunpckhqdq	%ymm13,%ymm6,%ymm6
vpunpcklqdq	%ymm14,%ymm7,%ymm13
vpunpckhqdq	%ymm14,%ymm7,%ymm7
vpunpcklqdq	%ymm15,%ymm8,%ymm14
vpunpckhqdq	%ymm15,%ymm8,%ymm8

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm10,64(%rdi)
vmovdqa		%ymm12,192(%rdi)
vmovdqa		%ymm6,224(%rdi)
vmovdqa		%ymm13,256(%rdi)

#level 5
#load
vmovdqa		%ymm5,%ymm6
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm8,%ymm9
vmovdqa		%ymm14,%ymm8
vmovdqu		608(%rdx,%r8),%ymm12
vmovdqu		672(%rdx,%r8),%ymm15
vmovdqu		640(%rdx,%r8),%ymm2
vmovdqu		704(%rdx,%r8),%ymm3

#mul
vpmullw		%ymm12,%ymm4,%ymm10
vpmullw		%ymm12,%ymm5,%ymm11
vpmullw		%ymm12,%ymm6,%ymm12
vpmullw		%ymm15,%ymm7,%ymm13
vpmullw		%ymm15,%ymm8,%ymm14
vpmullw		%ymm15,%ymm9,%ymm15
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8
vpmulhw		%ymm3,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13
vpsubw		%ymm14,%ymm8,%ymm14
vpsubw		%ymm15,%ymm9,%ymm15

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7
vmovdqa		224(%rdi),%ymm8
vmovdqa		256(%rdi),%ymm9


#reduce2
vpsraw		$12,%ymm4,%ymm2
vpsraw		$12,%ymm5,%ymm3
vpand		%ymm1,%ymm4,%ymm4
vpand		%ymm1,%ymm5,%ymm5
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpaddw		%ymm2,%ymm4,%ymm4
vpaddw		%ymm3,%ymm5,%ymm5

vpsraw		$12,%ymm6,%ymm2
vpsraw		$12,%ymm7,%ymm3
vpand		%ymm1,%ymm6,%ymm6
vpand		%ymm1,%ymm7,%ymm7
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpaddw		%ymm2,%ymm6,%ymm6
vpaddw		%ymm3,%ymm7,%ymm7

vpsraw		$12,%ymm8,%ymm2
vpsraw		$12,%ymm9,%ymm3
vpand		%ymm1,%ymm8,%ymm8
vpand		%ymm1,%ymm9,%ymm9
vpsubw		%ymm2,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsubw		%ymm2,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsubw		%ymm2,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpaddw		%ymm2,%ymm8,%ymm8
vpaddw		%ymm3,%ymm9,%ymm9

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15

#shuffle
vpsllq		$32,%ymm10,%ymm2
vpblendd	$0xAA,%ymm2,%ymm3,%ymm2
vpsrlq		$32,%ymm3,%ymm3
vpblendd	$0xAA,%ymm10,%ymm3,%ymm3
vpsllq		$32,%ymm11,%ymm10
vpblendd	$0xAA,%ymm10,%ymm4,%ymm10
vpsrlq		$32,%ymm4,%ymm4
vpblendd	$0xAA,%ymm11,%ymm4,%ymm4
vpsllq		$32,%ymm12,%ymm11
vpblendd	$0xAA,%ymm11,%ymm5,%ymm11
vpsrlq		$32,%ymm5,%ymm5
vpblendd	$0xAA,%ymm12,%ymm5,%ymm5
vpsllq		$32,%ymm13,%ymm12
vpblendd	$0xAA,%ymm12,%ymm6,%ymm12
vpsrlq		$32,%ymm6,%ymm6
vpblendd	$0xAA,%ymm13,%ymm6,%ymm6
vpsllq		$32,%ymm14,%ymm13
vpblendd	$0xAA,%ymm13,%ymm7,%ymm13
vpsrlq		$32,%ymm7,%ymm7
vpblendd	$0xAA,%ymm14,%ymm7,%ymm7
vpsllq		$32,%ymm15,%ymm14
vpblendd	$0xAA,%ymm14,%ymm8,%ymm14
vpsrlq		$32,%ymm8,%ymm8
vpblendd	$0xAA,%ymm15,%ymm8,%ymm8

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm10,64(%rdi)
vmovdqa		%ymm12,192(%rdi)
vmovdqa		%ymm6,224(%rdi)
vmovdqa		%ymm13,256(%rdi)

#level 6
#load
vmovdqa		%ymm5,%ymm6
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm8,%ymm9
vmovdqa		%ymm14,%ymm8
vmovdqu		1120(%rdx,%r8),%ymm12
vmovdqu		1184(%rdx,%r8),%ymm15
vmovdqu		1152(%rdx,%r8),%ymm2
vmovdqu		1216(%rdx,%r8),%ymm3

#mul
vpmullw		%ymm12,%ymm4,%ymm10
vpmullw		%ymm12,%ymm5,%ymm11
vpmullw		%ymm12,%ymm6,%ymm12
vpmullw		%ymm15,%ymm7,%ymm13
vpmullw		%ymm15,%ymm8,%ymm14
vpmullw		%ymm15,%ymm9,%ymm15
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8
vpmulhw		%ymm3,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13
vpsubw		%ymm14,%ymm8,%ymm14
vpsubw		%ymm15,%ymm9,%ymm15

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7
vmovdqa		224(%rdi),%ymm8
vmovdqa		256(%rdi),%ymm9

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15

#store
vmovdqa		%ymm10,96(%rdi)
vmovdqa		%ymm11,128(%rdi)
vmovdqa		%ymm12,160(%rdi)
vmovdqa		%ymm6,192(%rdi)
vmovdqa		%ymm7,224(%rdi)
vmovdqa		%ymm8,256(%rdi)
vmovdqa		%ymm13,288(%rdi)
vmovdqa		%ymm14,320(%rdi)
vmovdqa		%ymm15,352(%rdi)

#level 7
#round1
#load
vmovdqu		_16xwqinv(%rip),%ymm14 #winv
vmovdqu		_16xwinvqinv(%rip),%ymm15 #w^2inv
vmovdqu		_16xw(%rip),%ymm8 #w
vmovdqu		_16xwinv(%rip),%ymm9 #w^2

vmovdqu		1632(%rdx,%r8,4),%ymm12 #ainv
vmovdqu		1696(%rdx,%r8,4),%ymm13 #a^2inv
vmovdqu		1664(%rdx,%r8,4),%ymm6 #a
vmovdqu		1728(%rdx,%r8,4),%ymm7 #a^2

#mul
vpmullw		%ymm12,%ymm4,%ymm12 #Ba
vpmullw		%ymm13,%ymm5,%ymm13 #Ca^2
vpmulhw		%ymm6,%ymm4,%ymm6   #Ba
vpmulhw		%ymm7,%ymm5,%ymm7   #Ca^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12 #Ba
vpmulhw		%ymm0,%ymm13,%ymm13 #Ca^2
vpsubw		%ymm12,%ymm6,%ymm12 #Ba
vpsubw		%ymm13,%ymm7,%ymm13 #Ca^2

#mul
vpmullw		%ymm14,%ymm12,%ymm10 #Bb
vpmullw		%ymm15,%ymm13,%ymm11 #Cb^2
vpmulhw		%ymm8,%ymm12,%ymm6   #Bb
vpmulhw		%ymm9,%ymm13,%ymm7   #Cb^2

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10 #Bb
vpmulhw		%ymm0,%ymm11,%ymm11 #Cb^2
vpsubw		%ymm10,%ymm6,%ymm10 #Bb
vpsubw		%ymm11,%ymm7,%ymm11 #Cb^2

#update
vpaddw		%ymm13,%ymm12,%ymm12 #Ba+Ca^2
vpaddw		%ymm11,%ymm10,%ymm13 #Bb+Cb^2
vpaddw		%ymm13,%ymm12,%ymm10 #Ba+Ca^2+Bb+Cb^2
vpsubw		%ymm10,%ymm3,%ymm6   #A+Bc+Cc^2
vpaddw		%ymm13,%ymm3,%ymm5   #A+Bb+Cb^2
vpaddw		%ymm12,%ymm3,%ymm4   #A+Ba+Ca^2

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)

#round2
#load
vmovdqu		96(%rdi),%ymm3  #A
vmovdqu		128(%rdi),%ymm4 #B
vmovdqu		160(%rdi),%ymm5 #C

vmovdqu		1632+128(%rdx,%r8,4),%ymm12 #ainv
vmovdqu		1696+128(%rdx,%r8,4),%ymm13 #a^2inv
vmovdqu		1664+128(%rdx,%r8,4),%ymm6 #a
vmovdqu		1728+128(%rdx,%r8,4),%ymm7 #a^2

#mul
vpmullw		%ymm12,%ymm4,%ymm12 #Ba
vpmullw		%ymm13,%ymm5,%ymm13 #Ca^2
vpmulhw		%ymm6,%ymm4,%ymm6   #Ba
vpmulhw		%ymm7,%ymm5,%ymm7   #Ca^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12 #Ba
vpmulhw		%ymm0,%ymm13,%ymm13 #Ca^2
vpsubw		%ymm12,%ymm6,%ymm12 #Ba
vpsubw		%ymm13,%ymm7,%ymm13 #Ca^2

#mul
vpmullw		%ymm14,%ymm12,%ymm10 #Bb
vpmullw		%ymm15,%ymm13,%ymm11 #Cb^2
vpmulhw		%ymm8,%ymm12,%ymm6   #Bb
vpmulhw		%ymm9,%ymm13,%ymm7   #Cb^2

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10 #Bb
vpmulhw		%ymm0,%ymm11,%ymm11 #Cb^2
vpsubw		%ymm10,%ymm6,%ymm10 #Bb
vpsubw		%ymm11,%ymm7,%ymm11 #Cb^2

#update
vpaddw		%ymm13,%ymm12,%ymm12 #Ba+Ca^2
vpaddw		%ymm11,%ymm10,%ymm13 #Bb+Cb^2
vpaddw		%ymm13,%ymm12,%ymm10 #Ba+Ca^2+Bb+Cb^2
vpsubw		%ymm10,%ymm3,%ymm6   #A+Bc+Cc^2
vpaddw		%ymm13,%ymm3,%ymm5   #A+Bb+Cb^2
vpaddw		%ymm12,%ymm3,%ymm4   #A+Ba+Ca^2


#store
vmovdqa		%ymm4,96(%rdi)
vmovdqa		%ymm5,128(%rdi)
vmovdqa		%ymm6,160(%rdi)

#round3
#load
vmovdqu		192(%rdi),%ymm3 #A
vmovdqu		224(%rdi),%ymm4 #B
vmovdqu		256(%rdi),%ymm5 #C

vmovdqu		1632+256(%rdx,%r8,4),%ymm12 #ainv
vmovdqu		1696+256(%rdx,%r8,4),%ymm13 #a^2inv
vmovdqu		1664+256(%rdx,%r8,4),%ymm6 #a
vmovdqu		1728+256(%rdx,%r8,4),%ymm7 #a^2

#mul
vpmullw		%ymm12,%ymm4,%ymm12 #Ba
vpmullw		%ymm13,%ymm5,%ymm13 #Ca^2
vpmulhw		%ymm6,%ymm4,%ymm6   #Ba
vpmulhw		%ymm7,%ymm5,%ymm7   #Ca^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12 #Ba
vpmulhw		%ymm0,%ymm13,%ymm13 #Ca^2
vpsubw		%ymm12,%ymm6,%ymm12 #Ba
vpsubw		%ymm13,%ymm7,%ymm13 #Ca^2

#mul
vpmullw		%ymm14,%ymm12,%ymm10 #Bb
vpmullw		%ymm15,%ymm13,%ymm11 #Cb^2
vpmulhw		%ymm8,%ymm12,%ymm6   #Bb
vpmulhw		%ymm9,%ymm13,%ymm7   #Cb^2

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10 #Bb
vpmulhw		%ymm0,%ymm11,%ymm11 #Cb^2
vpsubw		%ymm10,%ymm6,%ymm10 #Bb
vpsubw		%ymm11,%ymm7,%ymm11 #Cb^2

#update
vpaddw		%ymm13,%ymm12,%ymm12 #Ba+Ca^2
vpaddw		%ymm11,%ymm10,%ymm13 #Bb+Cb^2
vpaddw		%ymm13,%ymm12,%ymm10 #Ba+Ca^2+Bb+Cb^2
vpsubw		%ymm10,%ymm3,%ymm6   #A+Bc+Cc^2
vpaddw		%ymm13,%ymm3,%ymm5   #A+Bb+Cb^2
vpaddw		%ymm12,%ymm3,%ymm4   #A+Ba+Ca^2

#store
vmovdqa		%ymm4,192(%rdi)
vmovdqa		%ymm5,224(%rdi)
vmovdqa		%ymm6,256(%rdi)

#round4
#load
vmovdqu		288(%rdi),%ymm3 #A
vmovdqu		320(%rdi),%ymm4 #B
vmovdqu		352(%rdi),%ymm5 #C

vmovdqu		1632+384(%rdx,%r8,4),%ymm12 #ainv
vmovdqu		1696+384(%rdx,%r8,4),%ymm13 #a^2inv
vmovdqu		1664+384(%rdx,%r8,4),%ymm6 #a
vmovdqu		1728+384(%rdx,%r8,4),%ymm7 #a^2

#mul
vpmullw		%ymm12,%ymm4,%ymm12 #Ba
vpmullw		%ymm13,%ymm5,%ymm13 #Ca^2
vpmulhw		%ymm6,%ymm4,%ymm6   #Ba
vpmulhw		%ymm7,%ymm5,%ymm7   #Ca^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12 #Ba
vpmulhw		%ymm0,%ymm13,%ymm13 #Ca^2
vpsubw		%ymm12,%ymm6,%ymm12 #Ba
vpsubw		%ymm13,%ymm7,%ymm13 #Ca^2

#mul
vpmullw		%ymm14,%ymm12,%ymm10 #Bb
vpmullw		%ymm15,%ymm13,%ymm11 #Cb^2
vpmulhw		%ymm8,%ymm12,%ymm6   #Bb
vpmulhw		%ymm9,%ymm13,%ymm7   #Cb^2

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10 #Bb
vpmulhw		%ymm0,%ymm11,%ymm11 #Cb^2
vpsubw		%ymm10,%ymm6,%ymm10 #Bb
vpsubw		%ymm11,%ymm7,%ymm11 #Cb^2

#update
vpaddw		%ymm13,%ymm12,%ymm12 #Ba+Ca^2
vpaddw		%ymm11,%ymm10,%ymm13 #Bb+Cb^2
vpaddw		%ymm13,%ymm12,%ymm10 #Ba+Ca^2+Bb+Cb^2
vpsubw		%ymm10,%ymm3,%ymm6   #A+Bc+Cc^2
vpaddw		%ymm13,%ymm3,%ymm5   #A+Bb+Cb^2
vpaddw		%ymm12,%ymm3,%ymm4   #A+Ba+Ca^2

#store
vmovdqa		%ymm4,%ymm12
vmovdqa		%ymm5,%ymm13
vmovdqa		%ymm6,%ymm14

vmovdqa		(%rdi),%ymm3
vmovdqa		32(%rdi),%ymm4
vmovdqa		64(%rdi),%ymm5
vmovdqa		96(%rdi),%ymm6
vmovdqa		128(%rdi),%ymm7
vmovdqa		160(%rdi),%ymm8
vmovdqa		192(%rdi),%ymm9
vmovdqa		224(%rdi),%ymm10
vmovdqa		256(%rdi),%ymm11

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
vpslld		$16,%ymm10,%ymm8
vpblendw	$0xAA,%ymm8,%ymm9,%ymm8
vpsrld		$16,%ymm9,%ymm9
vpblendw	$0xAA,%ymm10,%ymm9,%ymm9
vpslld		$16,%ymm12,%ymm10
vpblendw	$0xAA,%ymm10,%ymm11,%ymm10
vpsrld		$16,%ymm11,%ymm11
vpblendw	$0xAA,%ymm12,%ymm11,%ymm11
vpslld		$16,%ymm14,%ymm12
vpblendw	$0xAA,%ymm12,%ymm13,%ymm12
vpsrld		$16,%ymm13,%ymm13
vpblendw	$0xAA,%ymm14,%ymm13,%ymm13

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)
vmovdqa		%ymm8,192(%rdi)
vmovdqa		%ymm9,224(%rdi)
vmovdqa		%ymm10,256(%rdi)
vmovdqa		%ymm11,288(%rdi)
vmovdqa		%ymm12,320(%rdi)
vmovdqa		%ymm13,352(%rdi)

add		$128,%r8
add		$384,%rdi
add		$8,%rax
cmp		$32,%rax

jb		_looptop_start_234567

ret
