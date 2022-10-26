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
vmovdqa		576(%rdi),%ymm4
vmovdqa		608(%rdi),%ymm5
vmovdqa		640(%rdi),%ymm6
vmovdqa		672(%rdi),%ymm7
vmovdqa		704(%rdi),%ymm8
vmovdqa		736(%rdi),%ymm9

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
vpaddw		576(%rdi),%ymm10,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		608(%rdi),%ymm11,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		640(%rdi),%ymm12,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		672(%rdi),%ymm13,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		704(%rdi),%ymm14,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15
vpaddw		736(%rdi),%ymm15,%ymm15

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm4,32(%rdi)
vmovdqa		%ymm5,64(%rdi)
vmovdqa		%ymm6,96(%rdi)
vmovdqa		%ymm7,128(%rdi)
vmovdqa		%ymm8,160(%rdi)
vmovdqa		%ymm10,576(%rdi)
vmovdqa		%ymm11,608(%rdi)
vmovdqa		%ymm12,640(%rdi)
vmovdqa		%ymm13,672(%rdi)
vmovdqa		%ymm14,704(%rdi)
vmovdqa		%ymm15,736(%rdi)

add		$192,%rdi
add		$192,%rax
cmp		$576,%rax
jb		_looptop_j_0

add		$8,%rdx
sub		$576,%rdi

#level 1
#load
vmovdqu	_16xwqinv(%rip),%ymm2 #winv
vmovdqu	_16xwinvqinv(%rip),%ymm3 #w^2inv
vmovdqu	_16xw(%rip),%ymm4 #w
vmovdqu	_16xwinv(%rip),%ymm5 #w^2

xor         %rax,%rax
.p2align 5
_looptop_start_1:
#zetas
vpbroadcastd    (%rdx),%ymm6 #ainv
vpbroadcastd    8(%rdx),%ymm7 #a^2inv
vpbroadcastd    4(%rdx),%ymm8 #a
vpbroadcastd    12(%rdx),%ymm9 #a^2

xor		%rcx,%rcx
.p2align 5
_looptop_j_1:
#load
vmovdqa		192(%rdi),%ymm10
vmovdqa		384(%rdi),%ymm11

#mul
vpmullw		%ymm6,%ymm10,%ymm12 #Ba
vpmullw		%ymm7,%ymm11,%ymm13 #Ca^2
vpmulhw		%ymm8,%ymm10,%ymm10 #Ba
vpmulhw		%ymm9,%ymm11,%ymm11 #Ca^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #Ba
vpmulhw		%ymm0,%ymm13,%ymm13  #Ca^2
vpsubw		%ymm12,%ymm10,%ymm10 #Ba
vpsubw		%ymm13,%ymm11,%ymm11 #Ca^2

#mul
vpmullw		%ymm2,%ymm10,%ymm12 #Bb
vpmullw		%ymm3,%ymm11,%ymm13 #Cb^2
vpmulhw		%ymm4,%ymm10,%ymm14 #Bb
vpmulhw		%ymm5,%ymm11,%ymm15 #Cb^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #Bb
vpmulhw		%ymm0,%ymm13,%ymm13  #Cb^2
vpsubw		%ymm12,%ymm14,%ymm12 #Bb
vpsubw		%ymm13,%ymm15,%ymm13 #Cb^2

#load
vmovdqa		(%rdi),%ymm14

#update
vpaddw		%ymm11,%ymm10,%ymm10 #Ba+Ca^2
vpaddw		%ymm13,%ymm12,%ymm11 #Bb+Cb^2
vpaddw		%ymm11,%ymm10,%ymm12 #Ba+Ca^2+Bb+Cb^2
vpaddw		%ymm10,%ymm14,%ymm10  #A+Ba+Ca^2
vpaddw		%ymm11,%ymm14,%ymm11  #A+Bb+Cb^2
vpsubw		%ymm12,%ymm14,%ymm12  #A+Bc+Cc^2

#store
vmovdqa		%ymm10,(%rdi)
vmovdqa		%ymm11,192(%rdi)
vmovdqa		%ymm12,384(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$192,%rcx
jb		_looptop_j_1

add		$16,%rdx
add		$384,%rdi
add		$576,%rax
cmp		$1152,%rax
jb		_looptop_start_1

sub		$1152,%rdi
vmovdqa		_low_mask(%rip),%ymm1

#level 2
xor         %rax,%rax
.p2align 5
_looptop_start_2:
#zetas
vpbroadcastd    (%rdx),%ymm6 #ainv
vpbroadcastd    8(%rdx),%ymm7 #a^2inv
vpbroadcastd    4(%rdx),%ymm8 #a
vpbroadcastd    12(%rdx),%ymm9 #a^2

xor		%rcx,%rcx
.p2align 5
_looptop_j_2:
#load
vmovdqa		64(%rdi),%ymm10
vmovdqa		128(%rdi),%ymm11

#mul
vpmullw		%ymm6,%ymm10,%ymm12 #Ba
vpmullw		%ymm7,%ymm11,%ymm13 #Ca^2
vpmulhw		%ymm8,%ymm10,%ymm10 #Ba
vpmulhw		%ymm9,%ymm11,%ymm11 #Ca^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #Ba
vpmulhw		%ymm0,%ymm13,%ymm13  #Ca^2
vpsubw		%ymm12,%ymm10,%ymm10 #Ba
vpsubw		%ymm13,%ymm11,%ymm11 #Ca^2

#mul
vpmullw		%ymm2,%ymm10,%ymm12 #Bb
vpmullw		%ymm3,%ymm11,%ymm13 #Cb^2
vpmulhw		%ymm4,%ymm10,%ymm14 #Bb
vpmulhw		%ymm5,%ymm11,%ymm15 #Cb^2

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #Bb
vpmulhw		%ymm0,%ymm13,%ymm13  #Cb^2
vpsubw		%ymm12,%ymm14,%ymm12 #Bb
vpsubw		%ymm13,%ymm15,%ymm13 #Cb^2

#load
vmovdqa		(%rdi),%ymm14

#reduce2
vpsraw		$12,%ymm14,%ymm15
vpand		%ymm1,%ymm14,%ymm14
vpsubw		%ymm15,%ymm14,%ymm14
vpsllw		$7,%ymm15,%ymm15
vpsubw		%ymm15,%ymm14,%ymm14
vpsllw		$1,%ymm15,%ymm15
vpsubw		%ymm15,%ymm14,%ymm14
vpsllw		$2,%ymm15,%ymm15
vpaddw		%ymm15,%ymm14,%ymm14

#update
vpaddw		%ymm11,%ymm10,%ymm10 #Ba+Ca^2
vpaddw		%ymm13,%ymm12,%ymm11 #Bb+Cb^2
vpaddw		%ymm11,%ymm10,%ymm12 #Ba+Ca^2+Bb+Cb^2
vpaddw		%ymm10,%ymm14,%ymm10  #A+Ba+Ca^2
vpaddw		%ymm11,%ymm14,%ymm11  #A+Bb+Cb^2
vpsubw		%ymm12,%ymm14,%ymm12  #A+Bc+Cc^2

#store
vmovdqa		%ymm10,(%rdi)
vmovdqa		%ymm11,64(%rdi)
vmovdqa		%ymm12,128(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$64,%rcx
jb		_looptop_j_2

add		$16,%rdx
add		$128,%rdi
add		$192,%rax
cmp		$1152,%rax
jb		_looptop_start_2

sub		$1152,%rdi
vmovdqa		_low_mask(%rip),%ymm1


xor		%rax,%rax
xor		%r8,%r8
.p2align 5
_looptop_start_3456:
#load
vmovdqa		(%rdi),%ymm8
vmovdqa		32(%rdi),%ymm9
vmovdqa		64(%rdi),%ymm10
vmovdqa		96(%rdi),%ymm11
vmovdqa		128(%rdi),%ymm12
vmovdqa		160(%rdi),%ymm13
vmovdqa		192(%rdi),%ymm14
vmovdqa		224(%rdi),%ymm15

#shuffle
vperm2i128	$0x31,%ymm12,%ymm8,%ymm4
vperm2i128	$0x20,%ymm12,%ymm8,%ymm5
vperm2i128	$0x31,%ymm13,%ymm9,%ymm6
vperm2i128	$0x20,%ymm13,%ymm9,%ymm7
vperm2i128	$0x31,%ymm14,%ymm10,%ymm8
vperm2i128	$0x20,%ymm14,%ymm10,%ymm9
vperm2i128	$0x31,%ymm15,%ymm11,%ymm10
vperm2i128	$0x20,%ymm15,%ymm11,%ymm11

#shuffle
vpunpcklqdq	%ymm6,%ymm4,%ymm2
vpunpckhqdq	%ymm4,%ymm6,%ymm3
vpunpcklqdq	%ymm7,%ymm5,%ymm4
vpunpckhqdq	%ymm5,%ymm7,%ymm5
vpunpcklqdq	%ymm10,%ymm8,%ymm6
vpunpckhqdq	%ymm8,%ymm10,%ymm7
vpunpcklqdq	%ymm11,%ymm9,%ymm8
vpunpckhqdq	%ymm9,%ymm11,%ymm9

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)
vmovdqa		%ymm8,192(%rdi)
vmovdqa		%ymm9,224(%rdi)

#level3
#zetas
vmovdqu    (%rdx,%rax),%ymm14 #ainv
vmovdqu    64(%rdx,%rax),%ymm15 #ainv
vmovdqu    32(%rdx,%rax),%ymm2 #ainv
vmovdqu    96(%rdx,%rax),%ymm3 #ainv

#load
vmovdqa		64(%rdi),%ymm5
vmovdqa		96(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7
vmovdqa		224(%rdi),%ymm8

#mul
vpmullw		%ymm14,%ymm5,%ymm10
vpmullw		%ymm14,%ymm6,%ymm11
vpmullw		%ymm15,%ymm7,%ymm12
vpmullw		%ymm15,%ymm8,%ymm13
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm10,%ymm5,%ymm10
vpsubw		%ymm11,%ymm6,%ymm11
vpsubw		%ymm12,%ymm7,%ymm12
vpsubw		%ymm13,%ymm8,%ymm13

#load
vmovdqa		(%rdi),%ymm6
vmovdqa		32(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9

#update
vpaddw		%ymm10,%ymm6,%ymm4
vpaddw		%ymm11,%ymm7,%ymm5
vpsubw		%ymm10,%ymm6,%ymm6
vpsubw		%ymm11,%ymm7,%ymm7
vpaddw		%ymm12,%ymm8,%ymm10
vpaddw		%ymm13,%ymm9,%ymm11
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13

#shuffle
vpsllq		$32,%ymm6,%ymm2
vpblendd	$0xAA,%ymm2,%ymm4,%ymm2
vpsrlq		$32,%ymm4,%ymm4
vpblendd	$0xAA,%ymm6,%ymm4,%ymm3
vpsllq		$32,%ymm7,%ymm4
vpblendd	$0xAA,%ymm4,%ymm5,%ymm4
vpsrlq		$32,%ymm5,%ymm5
vpblendd	$0xAA,%ymm7,%ymm5,%ymm5
vpsllq		$32,%ymm12,%ymm6
vpblendd	$0xAA,%ymm6,%ymm10,%ymm6
vpsrlq		$32,%ymm10,%ymm7
vpblendd	$0xAA,%ymm7,%ymm10,%ymm7
vpsllq		$32,%ymm13,%ymm8
vpblendd	$0xAA,%ymm8,%ymm11,%ymm8
vpsrlq		$32,%ymm11,%ymm9
vpblendd	$0xAA,%ymm9,%ymm13,%ymm9

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)
vmovdqa		%ymm8,192(%rdi)
vmovdqa		%ymm9,224(%rdi)


#level4
#zetas
vmovdqu    1152(%rdx,%rax),%ymm14 #ainv
vmovdqu    1216(%rdx,%rax),%ymm15 #ainv
vmovdqu    1184(%rdx,%rax),%ymm2 #ainv
vmovdqu    1248(%rdx,%rax),%ymm3 #ainv

#load
vmovdqa		64(%rdi),%ymm5
vmovdqa		96(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7
vmovdqa		224(%rdi),%ymm8

#mul
vpmullw		%ymm14,%ymm5,%ymm10
vpmullw		%ymm14,%ymm6,%ymm11
vpmullw		%ymm15,%ymm7,%ymm12
vpmullw		%ymm15,%ymm8,%ymm13
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm10,%ymm5,%ymm10
vpsubw		%ymm11,%ymm6,%ymm11
vpsubw		%ymm12,%ymm7,%ymm12
vpsubw		%ymm13,%ymm8,%ymm13

#load
vmovdqa		(%rdi),%ymm6
vmovdqa		32(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9

#reduce2
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
vpaddw		%ymm10,%ymm6,%ymm4
vpaddw		%ymm11,%ymm7,%ymm5
vpsubw		%ymm10,%ymm6,%ymm6
vpsubw		%ymm11,%ymm7,%ymm7
vpaddw		%ymm12,%ymm8,%ymm10
vpaddw		%ymm13,%ymm9,%ymm11
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13

#shuffle
vpsllq		$16,%ymm6,%ymm2
vpblendw	$0xAA,%ymm2,%ymm4,%ymm2
vpsrlq		$16,%ymm4,%ymm4
vpblendw	$0xAA,%ymm6,%ymm4,%ymm3
vpsllq		$16,%ymm7,%ymm4
vpblendw	$0xAA,%ymm4,%ymm5,%ymm4
vpsrlq		$16,%ymm5,%ymm5
vpblendw	$0xAA,%ymm7,%ymm5,%ymm5
vpsllq		$16,%ymm12,%ymm6
vpblendw	$0xAA,%ymm6,%ymm10,%ymm6
vpsrlq		$16,%ymm10,%ymm7
vpblendw	$0xAA,%ymm7,%ymm10,%ymm7
vpsllq		$16,%ymm13,%ymm8
vpblendw	$0xAA,%ymm8,%ymm11,%ymm8
vpsrlq		$16,%ymm11,%ymm9
vpblendw	$0xAA,%ymm9,%ymm13,%ymm9

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)
vmovdqa		%ymm8,192(%rdi)
vmovdqa		%ymm9,224(%rdi)

#level5
#zetas
vmovdqu    3456(%rdx),%ymm14 #ainv
vmovdqu    3520(%rdx),%ymm15 #ainv
vmovdqu    3488(%rdx),%ymm2 #ainv
vmovdqu    3552(%rdx),%ymm3 #ainv

#load
vmovdqa		64(%rdi),%ymm5
vmovdqa		96(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7
vmovdqa		224(%rdi),%ymm8

#mul
vpmullw		%ymm14,%ymm5,%ymm10
vpmullw		%ymm14,%ymm6,%ymm11
vpmullw		%ymm15,%ymm7,%ymm12
vpmullw		%ymm15,%ymm8,%ymm13
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm10,%ymm5,%ymm10
vpsubw		%ymm11,%ymm6,%ymm11
vpsubw		%ymm12,%ymm7,%ymm12
vpsubw		%ymm13,%ymm8,%ymm13

#load
vmovdqa		(%rdi),%ymm6
vmovdqa		32(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9

#update
vpaddw		%ymm10,%ymm6,%ymm4
vpaddw		%ymm11,%ymm7,%ymm5
vpsubw		%ymm10,%ymm6,%ymm6
vpsubw		%ymm11,%ymm7,%ymm7
vpaddw		%ymm12,%ymm8,%ymm10
vpaddw		%ymm13,%ymm9,%ymm11
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)
vmovdqa		%ymm8,192(%rdi)
vmovdqa		%ymm9,224(%rdi)

#level6
vmovdqu    (%rdx),%ymm14 #ainv
vmovdqu    (%rdx),%ymm15 #ainv
vmovdqu    (%rdx),%ymm2 #ainv
vmovdqu    (%rdx),%ymm3 #ainv

#load
vmovdqa		64(%rdi),%ymm5
vmovdqa		96(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7
vmovdqa		224(%rdi),%ymm8

#mul
vpmullw		%ymm14,%ymm5,%ymm10
vpmullw		%ymm14,%ymm6,%ymm11
vpmullw		%ymm15,%ymm7,%ymm12
vpmullw		%ymm15,%ymm8,%ymm13
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm10,%ymm5,%ymm10
vpsubw		%ymm11,%ymm6,%ymm11
vpsubw		%ymm12,%ymm7,%ymm12
vpsubw		%ymm13,%ymm8,%ymm13

#load
vmovdqa		(%rdi),%ymm6
vmovdqa		32(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9

#reduce2
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
vpaddw		%ymm10,%ymm6,%ymm4
vpaddw		%ymm11,%ymm7,%ymm5
vpsubw		%ymm10,%ymm6,%ymm6
vpsubw		%ymm11,%ymm7,%ymm7
vpaddw		%ymm12,%ymm8,%ymm10
vpaddw		%ymm13,%ymm9,%ymm11
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)
vmovdqa		%ymm8,192(%rdi)
vmovdqa		%ymm9,224(%rdi)

#level 6
vmovdqu    4608(%rdx),%ymm14 #ainv
vmovdqu    4672(%rdx),%ymm15 #ainv
vmovdqu    4640(%rdx),%ymm2 #ainv
vmovdqu    4704(%rdx),%ymm3 #ainv

#load
vmovdqa		64(%rdi),%ymm5
vmovdqa		96(%rdi),%ymm6
vmovdqa		192(%rdi),%ymm7
vmovdqa		224(%rdi),%ymm8

#mul
vpmullw		%ymm14,%ymm5,%ymm10
vpmullw		%ymm14,%ymm6,%ymm11
vpmullw		%ymm15,%ymm7,%ymm12
vpmullw		%ymm15,%ymm8,%ymm13
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm3,%ymm7,%ymm7
vpmulhw		%ymm3,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm10,%ymm5,%ymm10
vpsubw		%ymm11,%ymm6,%ymm11
vpsubw		%ymm12,%ymm7,%ymm12
vpsubw		%ymm13,%ymm8,%ymm13

#load
vmovdqa		(%rdi),%ymm6
vmovdqa		32(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9

#update
vpaddw		%ymm10,%ymm6,%ymm4
vpaddw		%ymm11,%ymm7,%ymm5
vpsubw		%ymm10,%ymm6,%ymm6
vpsubw		%ymm11,%ymm7,%ymm7
vpaddw		%ymm12,%ymm8,%ymm10
vpaddw		%ymm13,%ymm9,%ymm11
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)
vmovdqa		%ymm6,128(%rdi)
vmovdqa		%ymm7,160(%rdi)
vmovdqa		%ymm8,192(%rdi)
vmovdqa		%ymm9,224(%rdi)

add		$128,%rdi
add		$128,%rax
cmp		$1152,%rax

jb		_looptop_start_3456

ret
