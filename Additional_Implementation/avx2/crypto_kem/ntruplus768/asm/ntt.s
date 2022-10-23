.global poly_ntt
poly_ntt:
vmovdqa		_16xq(%rip),%ymm0
lea		    zetas(%rip),%rdx

#level0
#zetas
vpbroadcastd	(%rdx),%ymm1
vpbroadcastd	4(%rdx),%ymm2

xor		%rax,%rax
.p2align 5
_looptop_j_0:
#load
vmovdqa		768(%rdi),%ymm4
vmovdqa		800(%rdi),%ymm5
vmovdqa		832(%rdi),%ymm6
vmovdqa		864(%rdi),%ymm7
vmovdqa		896(%rdi),%ymm8
vmovdqa		928(%rdi),%ymm9

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
vpaddw		768(%rdi),%ymm10,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		800(%rdi),%ymm11,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		832(%rdi),%ymm12,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		864(%rdi),%ymm13,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		896(%rdi),%ymm14,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15
vpaddw		928(%rdi),%ymm15,%ymm15

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
add		$192,%rax
cmp		$768,%eax
jb		_looptop_j_0

add		$8,%rdx
sub		$768,%rdi

#level 1
#ws
vmovdqu	_16xwqinv(%rip),%ymm1 #winv
vmovdqu	_16xwinvqinv(%rip),%ymm2 #w^2inv
vmovdqu	_16xw(%rip),%ymm3 #w
vmovdqu	_16xwinv(%rip),%ymm4 #w^2

xor         %rax,%rax
.p2align 5
_looptop_start_1:
#zetas
vpbroadcastd    (%rdx),%ymm5 #ainv
vpbroadcastd    8(%rdx),%ymm6 #a^2inv
vpbroadcastd    4(%rdx),%ymm7 #a
vpbroadcastd    12(%rdx),%ymm8 #a^2

xor		%rcx,%rcx
.p2align 5
_looptop_j_1:
#load
vmovdqa		(%rdi),%ymm9
vmovdqa		256(%rdi),%ymm10
vmovdqa		512(%rdi),%ymm11

#mul
vpmullw		%ymm5,%ymm10,%ymm12 #Ba
vpmullw		%ymm6,%ymm11,%ymm13 #Ca^2
vpmulhw		%ymm7,%ymm10,%ymm10 #Ba
vpmulhw		%ymm8,%ymm11,%ymm11 #Ca^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #Ba
vpmulhw		%ymm0,%ymm13,%ymm13  #Ca^2
vpsubw		%ymm12,%ymm10,%ymm10 #Ba
vpsubw		%ymm13,%ymm11,%ymm11 #Ca^2

#mul
vpmullw		%ymm1,%ymm10,%ymm12 #Bb
vpmullw		%ymm2,%ymm11,%ymm13 #Cb^2
vpmulhw		%ymm3,%ymm10,%ymm14 #Bb
vpmulhw		%ymm4,%ymm11,%ymm15 #Cb^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #Bb
vpmulhw		%ymm0,%ymm13,%ymm13  #Cb^2
vpsubw		%ymm12,%ymm14,%ymm12 #Bb
vpsubw		%ymm13,%ymm15,%ymm13 #Cb^2

#update
vpaddw		%ymm11,%ymm10,%ymm10 #Ba+Ca^2
vpaddw		%ymm13,%ymm12,%ymm11 #Bb+Cb^2
vpaddw		%ymm11,%ymm10,%ymm12 #Ba+Ca^2+Bb+Cb^2
vpaddw		%ymm10,%ymm9,%ymm13  #A+Ba+Ca^2
vpaddw		%ymm11,%ymm9,%ymm14  #A+Bb+Cb^2
vpsubw		%ymm12,%ymm9,%ymm15  #A+Bc+Cc^2

#store
vmovdqa		%ymm13,(%rdi)
vmovdqa		%ymm14,256(%rdi)
vmovdqa		%ymm15,512(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$256,%rcx
jb		_looptop_j_1

add		$16,%rdx
add		$512,%rdi
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
#zetas
vpbroadcastd	(%rdx,%rax),%ymm2
vpbroadcastd	4(%rdx,%rax),%ymm3

#load
vmovdqa		128(%rdi),%ymm4
vmovdqa		160(%rdi),%ymm5
vmovdqa		192(%rdi),%ymm6
vmovdqa		224(%rdi),%ymm7

#mul
vpmullw		%ymm2,%ymm4,%ymm10
vpmullw		%ymm2,%ymm5,%ymm11
vpmullw		%ymm2,%ymm6,%ymm12
vpmullw		%ymm2,%ymm7,%ymm13
vpmulhw		%ymm3,%ymm4,%ymm4
vpmulhw		%ymm3,%ymm5,%ymm5
vpmulhw		%ymm3,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7

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

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm4,32(%rdi)
vmovdqa		%ymm5,64(%rdi)
vmovdqa		%ymm6,96(%rdi)
vmovdqa		%ymm10,128(%rdi)
vmovdqa		%ymm11,160(%rdi)
vmovdqa		%ymm12,192(%rdi)
vmovdqa		%ymm13,224(%rdi)


#level 3
#load
vmovdqa		%ymm5,%ymm4
vmovdqa		%ymm6,%ymm5
vmovdqa		%ymm12,%ymm6
vmovdqa		%ymm13,%ymm7

vpbroadcastd	48(%rdx,%rax,2),%ymm12
vpbroadcastd	56(%rdx,%rax,2),%ymm15
vpbroadcastd	52(%rdx,%rax,2),%ymm2
vpbroadcastd	60(%rdx,%rax,2),%ymm3

#mul
vpmullw		%ymm12,%ymm4,%ymm10
vpmullw		%ymm12,%ymm5,%ymm11
vpmullw		%ymm15,%ymm6,%ymm12
vpmullw		%ymm15,%ymm7,%ymm13
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm3,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		128(%rdi),%ymm6
vmovdqa		160(%rdi),%ymm7

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13


#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm4,32(%rdi)
vmovdqa		%ymm10,64(%rdi)
vmovdqa		%ymm11,96(%rdi)
vmovdqa		%ymm5,128(%rdi)
vmovdqa		%ymm6,160(%rdi)
vmovdqa		%ymm12,192(%rdi)
vmovdqa		%ymm13,224(%rdi)

#level 4
#load1
vmovdqa		32(%rdi),%ymm4
vmovdqa		96(%rdi),%ymm5
vmovdqa		160(%rdi),%ymm6
vmovdqa		224(%rdi),%ymm7

vpbroadcastd		144(%rdx,%rax,4),%ymm12
vpbroadcastd		152(%rdx,%rax,4),%ymm13
vpbroadcastd		160(%rdx,%rax,4),%ymm14
vpbroadcastd		168(%rdx,%rax,4),%ymm15

vpbroadcastd		148(%rdx,%rax,4),%ymm8
vpbroadcastd		156(%rdx,%rax,4),%ymm9
vpbroadcastd		164(%rdx,%rax,4),%ymm10
vpbroadcastd		172(%rdx,%rax,4),%ymm11

#mul
vpmullw		%ymm12,%ymm4,%ymm12
vpmullw		%ymm13,%ymm5,%ymm13
vpmullw		%ymm14,%ymm6,%ymm14
vpmullw		%ymm15,%ymm7,%ymm15
vpmulhw		%ymm8,%ymm4,%ymm4
vpmulhw		%ymm9,%ymm5,%ymm5
vpmulhw		%ymm10,%ymm6,%ymm6
vpmulhw		%ymm11,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm12,%ymm10
vpmulhw		%ymm0,%ymm13,%ymm11
vpmulhw		%ymm0,%ymm14,%ymm12
vpmulhw		%ymm0,%ymm15,%ymm13
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		64(%rdi),%ymm5
vmovdqa		128(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm10,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm11,96(%rdi)
vmovdqa		%ymm5,128(%rdi)
vmovdqa		%ymm10,160(%rdi)
vmovdqa		%ymm6,192(%rdi)
vmovdqa		%ymm11,224(%rdi)

#load
vmovdqa     0(%rdi),%ymm3
vmovdqa     32(%rdi),%ymm4
vmovdqa     64(%rdi),%ymm5
vmovdqa     96(%rdi),%ymm6
vmovdqa     128(%rdi),%ymm10
vmovdqa     160(%rdi),%ymm11
vmovdqa     192(%rdi),%ymm12
vmovdqa     224(%rdi),%ymm13

#shuffle
vperm2i128	$0x20,%ymm4,%ymm3,%ymm2
vperm2i128	$0x31,%ymm4,%ymm3,%ymm3
vperm2i128	$0x20,%ymm6,%ymm5,%ymm4
vperm2i128	$0x31,%ymm6,%ymm5,%ymm5
vperm2i128	$0x20,%ymm11,%ymm10,%ymm6
vperm2i128	$0x31,%ymm11,%ymm10,%ymm7
vperm2i128	$0x20,%ymm13,%ymm12,%ymm8
vperm2i128	$0x31,%ymm13,%ymm12,%ymm9

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)
vmovdqa		%ymm8,192(%rdi)
vmovdqa		%ymm9,224(%rdi)


#level 5
#load
vmovdqa     32(%rdi),%ymm4
vmovdqa     96(%rdi),%ymm5
vmovdqa     160(%rdi),%ymm6
vmovdqa     224(%rdi),%ymm7

#zetas
vmovdqu		336(%rdx,%r8,2),%ymm12
vmovdqu		400(%rdx,%r8,2),%ymm13
vmovdqu		464(%rdx,%r8,2),%ymm14
vmovdqu		528(%rdx,%r8,2),%ymm15
vmovdqu		368(%rdx,%r8,2),%ymm8
vmovdqu		432(%rdx,%r8,2),%ymm9
vmovdqu		496(%rdx,%r8,2),%ymm10
vmovdqu		560(%rdx,%r8,2),%ymm11

#mul
vpmullw		%ymm12,%ymm4,%ymm12
vpmullw		%ymm13,%ymm5,%ymm13
vpmullw		%ymm14,%ymm6,%ymm14
vpmullw		%ymm15,%ymm7,%ymm15
vpmulhw		%ymm8,%ymm4,%ymm4
vpmulhw		%ymm9,%ymm5,%ymm5
vpmulhw		%ymm10,%ymm6,%ymm6
vpmulhw		%ymm11,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm12,%ymm10
vpmulhw		%ymm0,%ymm13,%ymm11
vpmulhw		%ymm0,%ymm14,%ymm12
vpmulhw		%ymm0,%ymm15,%ymm13
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		64(%rdi),%ymm5
vmovdqa		128(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7


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

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm10,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm11,96(%rdi)
vmovdqa		%ymm5,128(%rdi)
vmovdqa		%ymm12,160(%rdi)
vmovdqa		%ymm6,192(%rdi)
vmovdqa		%ymm13,224(%rdi)

#load
vmovdqa     0(%rdi),%ymm3
vmovdqa     32(%rdi),%ymm4
vmovdqa     64(%rdi),%ymm5
vmovdqa     96(%rdi),%ymm6
vmovdqa     128(%rdi),%ymm10
vmovdqa     160(%rdi),%ymm11
vmovdqa     192(%rdi),%ymm12
vmovdqa     224(%rdi),%ymm13

#shuffle
vpunpcklqdq  %ymm4,%ymm3,%ymm2
vpunpckhqdq  %ymm4,%ymm3,%ymm3
vpunpcklqdq  %ymm6,%ymm5,%ymm4
vpunpckhqdq  %ymm6,%ymm5,%ymm5
vpunpcklqdq  %ymm11,%ymm10,%ymm6
vpunpckhqdq  %ymm11,%ymm10,%ymm7
vpunpcklqdq  %ymm13,%ymm12,%ymm8
vpunpckhqdq  %ymm13,%ymm12,%ymm9

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)
vmovdqa		%ymm8,192(%rdi)
vmovdqa		%ymm9,224(%rdi)
/*
#level 6
#load
vmovdqa     32(%rdi),%ymm4
vmovdqa     96(%rdi),%ymm5
vmovdqa     160(%rdi),%ymm6
vmovdqa     224(%rdi),%ymm7

#zetas
vmovdqu		1872(%rdx,%r8,2),%ymm12
vmovdqu		1936(%rdx,%r8,2),%ymm13
vmovdqu		2000(%rdx,%r8,2),%ymm14
vmovdqu		2064(%rdx,%r8,2),%ymm15
vmovdqu		1904(%rdx,%r8,2),%ymm8
vmovdqu		1968(%rdx,%r8,2),%ymm9
vmovdqu		2032(%rdx,%r8,2),%ymm10
vmovdqu		2096(%rdx,%r8,2),%ymm11

#mul
vpmullw		%ymm12,%ymm4,%ymm12
vpmullw		%ymm13,%ymm5,%ymm13
vpmullw		%ymm14,%ymm6,%ymm14
vpmullw		%ymm15,%ymm7,%ymm15
vpmulhw		%ymm8,%ymm4,%ymm4
vpmulhw		%ymm9,%ymm5,%ymm5
vpmulhw		%ymm10,%ymm6,%ymm6
vpmulhw		%ymm11,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm12,%ymm10
vpmulhw		%ymm0,%ymm13,%ymm11
vpmulhw		%ymm0,%ymm14,%ymm12
vpmulhw		%ymm0,%ymm15,%ymm13
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		64(%rdi),%ymm5
vmovdqa		128(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm10,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm11,96(%rdi)
vmovdqa		%ymm5,128(%rdi)
vmovdqa		%ymm12,160(%rdi)
vmovdqa		%ymm6,192(%rdi)
vmovdqa		%ymm13,224(%rdi)


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

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm10,64(%rdi)
vmovdqa		%ymm4,96(%rdi)
vmovdqa		%ymm11,128(%rdi)
vmovdqa		%ymm5,160(%rdi)
vmovdqa		%ymm12,192(%rdi)
vmovdqa		%ymm6,224(%rdi)

#level 7
#load
vmovdqa     32(%rdi),%ymm4
vmovdqa     96(%rdi),%ymm5
vmovdqa     160(%rdi),%ymm6
vmovdqa     224(%rdi),%ymm7

#zetas
vmovdqu		3408(%rdx,%r8,2),%ymm12
vmovdqu		3472(%rdx,%r8,2),%ymm13
vmovdqu		3536(%rdx,%r8,2),%ymm14
vmovdqu		3600(%rdx,%r8,2),%ymm15
vmovdqu		3440(%rdx,%r8,2),%ymm8
vmovdqu		3504(%rdx,%r8,2),%ymm9
vmovdqu		3568(%rdx,%r8,2),%ymm10
vmovdqu		3632(%rdx,%r8,2),%ymm11

#mul
vpmullw		%ymm12,%ymm4,%ymm12
vpmullw		%ymm13,%ymm5,%ymm13
vpmullw		%ymm14,%ymm6,%ymm14
vpmullw		%ymm15,%ymm7,%ymm15
vpmulhw		%ymm8,%ymm4,%ymm4
vpmulhw		%ymm9,%ymm5,%ymm5
vpmulhw		%ymm10,%ymm6,%ymm6
vpmulhw		%ymm11,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm12,%ymm10
vpmulhw		%ymm0,%ymm13,%ymm11
vpmulhw		%ymm0,%ymm14,%ymm12
vpmulhw		%ymm0,%ymm15,%ymm13
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13

#load
vmovdqa		(%rdi),%ymm4
vmovdqa		64(%rdi),%ymm5
vmovdqa		128(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm10,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm11,96(%rdi)
vmovdqa		%ymm5,128(%rdi)
vmovdqa		%ymm12,160(%rdi)
vmovdqa		%ymm6,192(%rdi)
vmovdqa		%ymm13,224(%rdi)
*/
add		$128,%r8
add		$256,%rdi
add		$8,%rax
cmp		$48,%rax

jb		_looptop_start_234567

ret
