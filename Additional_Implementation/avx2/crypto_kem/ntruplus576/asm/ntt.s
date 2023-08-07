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
vmovdqa		576(%rsi),%ymm4
vmovdqa		608(%rsi),%ymm5
vmovdqa		640(%rsi),%ymm6
vmovdqa		672(%rsi),%ymm7
vmovdqa		704(%rsi),%ymm8
vmovdqa		736(%rsi),%ymm9

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
vpaddw		576(%rsi),%ymm10,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		608(%rsi),%ymm11,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		640(%rsi),%ymm12,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		672(%rsi),%ymm13,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		704(%rsi),%ymm14,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15
vpaddw		736(%rsi),%ymm15,%ymm15

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

add		$192,%rsi
add		$192,%rdi
add		$192,%rax
cmp		$576,%rax
jb		_looptop_j_0

add		$8,%rdx
sub		$576,%rdi

#level 1
#load
vmovdqa	_low_mask(%rip),%ymm1
vmovdqu	_16xwqinv(%rip),%ymm2 #winv
vmovdqu	_16xw(%rip),%ymm3     #w

xor         %rax,%rax
.p2align 5
_looptop_start_1:
#zetas
vpbroadcastd    (%rdx),%ymm4   #ainv
vpbroadcastd    8(%rdx),%ymm5  #a^2inv
vpbroadcastd    4(%rdx),%ymm6  #a
vpbroadcastd    12(%rdx),%ymm7 #a^2

xor		%rcx,%rcx
.p2align 5
_looptop_j_1:
#load
vmovdqa		192(%rdi),%ymm8
vmovdqa		384(%rdi),%ymm9

#mul
vpmullw		%ymm4,%ymm8,%ymm10   #Ba
vpmullw		%ymm5,%ymm9,%ymm11   #Ca^2
vpmulhw		%ymm6,%ymm8,%ymm8    #Ba
vpmulhw		%ymm7,%ymm9,%ymm9    #Ca^2

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10  #Ba
vpmulhw		%ymm0,%ymm11,%ymm11  #Ca^2
vpsubw		%ymm10,%ymm8,%ymm8   #Ba
vpsubw		%ymm11,%ymm9,%ymm9   #Ca^2

#sub
vpsubw		%ymm9,%ymm8,%ymm10   #(Ba-Ca^2)

#mul
vpmullw		%ymm2,%ymm10,%ymm11  #w(Ba-Ca^2)
vpmulhw		%ymm3,%ymm10,%ymm10  #w(Ba-Ca^2)

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11  #w(Ba-Ca^2)
vpsubw		%ymm11,%ymm10,%ymm10 #w(Ba-Ca^2)

#load
vmovdqa		(%rdi),%ymm11 #A

#update
vpaddw		%ymm8,%ymm11,%ymm12  #A + Ba
vpsubw		%ymm9,%ymm11,%ymm13  #A - Ca^2
vpsubw		%ymm8,%ymm11,%ymm14  #A - Ba

vpaddw		%ymm9,%ymm12,%ymm12  #A + Ba   + Ca^2
vpaddw		%ymm10,%ymm13,%ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw		%ymm10,%ymm14,%ymm14 #A - Ba   - w(Ba-Ca^2)

#store
vmovdqa		%ymm12,(%rdi)
vmovdqa		%ymm13,192(%rdi)
vmovdqa		%ymm14,384(%rdi)

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

#level 2
xor         %rax,%rax
.p2align 5
_looptop_start_2:
#zetas
vpbroadcastd    (%rdx),%ymm4   #ainv
vpbroadcastd    8(%rdx),%ymm5  #a^2inv
vpbroadcastd    4(%rdx),%ymm6  #a
vpbroadcastd    12(%rdx),%ymm7 #a^2

xor		%rcx,%rcx
.p2align 5
_looptop_j_2:
#load
vmovdqa		64(%rdi),%ymm8
vmovdqa		128(%rdi),%ymm9

#mul
vpmullw		%ymm4,%ymm8,%ymm10   #Ba
vpmullw		%ymm5,%ymm9,%ymm11   #Ca^2
vpmulhw		%ymm6,%ymm8,%ymm8    #Ba
vpmulhw		%ymm7,%ymm9,%ymm9    #Ca^2

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10  #Ba
vpmulhw		%ymm0,%ymm11,%ymm11  #Ca^2
vpsubw		%ymm10,%ymm8,%ymm8   #Ba
vpsubw		%ymm11,%ymm9,%ymm9   #Ca^2

#sub
vpsubw		%ymm9,%ymm8,%ymm10   #(Ba-Ca^2)

#mul
vpmullw		%ymm2,%ymm10,%ymm11  #w(Ba-Ca^2)
vpmulhw		%ymm3,%ymm10,%ymm10  #w(Ba-Ca^2)

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11  #w(Ba-Ca^2)
vpsubw		%ymm11,%ymm10,%ymm10 #w(Ba-Ca^2)

#load
vmovdqa		(%rdi),%ymm11 #A

#update
vpaddw		%ymm8,%ymm11,%ymm12  #A + Ba
vpsubw		%ymm9,%ymm11,%ymm13  #A - Ca^2
vpsubw		%ymm8,%ymm11,%ymm14  #A - Ba

vpaddw		%ymm9,%ymm12,%ymm12  #A + Ba   + Ca^2
vpaddw		%ymm10,%ymm13,%ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw		%ymm10,%ymm14,%ymm14 #A - Ba   - w(Ba-Ca^2)

#store
vmovdqa		%ymm12,(%rdi)
vmovdqa		%ymm13,64(%rdi)
vmovdqa		%ymm14,128(%rdi)

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

xor		%rax,%rax
.p2align 5
_looptop_start_3456:
#load
vmovdqa		(%rdi),%ymm6
vmovdqa		32(%rdi),%ymm7
vmovdqa		64(%rdi),%ymm8
vmovdqa		96(%rdi),%ymm9

#shuffle
vperm2i128	$0x20,%ymm8,%ymm6,%ymm4
vperm2i128	$0x31,%ymm8,%ymm6,%ymm5
vperm2i128	$0x20,%ymm9,%ymm7,%ymm6
vperm2i128	$0x31,%ymm9,%ymm7,%ymm7

#level3
#zetas
vmovdqu    (%rdx,%rax),%ymm15  #zetaqinv
vmovdqu    32(%rdx,%rax),%ymm2 #zeta

#mul
vpmullw		%ymm15,%ymm6,%ymm13
vpmullw		%ymm15,%ymm7,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#update
vpaddw		%ymm13,%ymm4,%ymm11
vpaddw		%ymm14,%ymm5,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14

#shuffle
vpunpcklqdq	%ymm13,%ymm11,%ymm4
vpunpckhqdq	%ymm13,%ymm11,%ymm5
vpunpcklqdq	%ymm14,%ymm12,%ymm6
vpunpckhqdq	%ymm14,%ymm12,%ymm7

#level4
#zetas
vmovdqu    576(%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    608(%rdx,%rax),%ymm2 #zeta

#mul
vpmullw		%ymm15,%ymm6,%ymm13
vpmullw		%ymm15,%ymm7,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

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

#update
vpaddw		%ymm13,%ymm4,%ymm11
vpaddw		%ymm14,%ymm5,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14

#shuffle
vpsllq		$32,%ymm13,%ymm2
vpblendd	$0xAA,%ymm2,%ymm11,%ymm4
vpsrlq		$32,%ymm11,%ymm11
vpblendd	$0xAA,%ymm13,%ymm11,%ymm5
vpsllq		$32,%ymm14,%ymm2
vpblendd	$0xAA,%ymm2,%ymm12,%ymm6
vpsrlq		$32,%ymm12,%ymm12
vpblendd	$0xAA,%ymm14,%ymm12,%ymm7

#level5
#zetas
vmovdqu    1152(%rdx,%rax),%ymm15 #ainv
vmovdqu    1184(%rdx,%rax),%ymm2 #ainv

#mul
vpmullw		%ymm15,%ymm6,%ymm13
vpmullw		%ymm15,%ymm7,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#update
vpaddw		%ymm13,%ymm4,%ymm11
vpaddw		%ymm14,%ymm5,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14

#shuffle
vpsllq		$16,%ymm13,%ymm2
vpblendw	$0xAA,%ymm2,%ymm11,%ymm4
vpsrlq		$16,%ymm11,%ymm11
vpblendw	$0xAA,%ymm13,%ymm11,%ymm5
vpsllq		$16,%ymm14,%ymm2
vpblendw	$0xAA,%ymm2,%ymm12,%ymm6
vpsrlq		$16,%ymm12,%ymm12
vpblendw	$0xAA,%ymm14,%ymm12,%ymm7

#level6
#zetas
vmovdqu    1728(%rdx,%rax),%ymm15 #ainv
vmovdqu    1760(%rdx,%rax),%ymm2 #ainv

#mul
vpmullw		%ymm15,%ymm6,%ymm13
vpmullw		%ymm15,%ymm7,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

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

#update
vpaddw		%ymm13,%ymm4,%ymm11
vpaddw		%ymm14,%ymm5,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14

#store
vmovdqa		%ymm11,(%rdi)
vmovdqa		%ymm12,32(%rdi)
vmovdqa		%ymm13,64(%rdi)
vmovdqa		%ymm14,96(%rdi)

add		$128,%rdi
add		$64,%rax
cmp		$576,%rax

jb		_looptop_start_3456

ret
