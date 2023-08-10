.global poly_ntt
poly_ntt:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa	_low_mask(%rip),%ymm1
lea		    zetas(%rip),%rdx

#level0
#zetas
vpbroadcastd	(%rdx),%ymm15
vpbroadcastd	4(%rdx),%ymm2

xor		%rax,%rax
.p2align 5
_looptop_j_0:
#load
vmovdqa		(%rsi),%ymm3
vmovdqa		32(%rsi),%ymm4
vmovdqa		64(%rsi),%ymm5
vmovdqa		1152(%rsi),%ymm6
vmovdqa		1184(%rsi),%ymm7
vmovdqa		1216(%rsi),%ymm8

#mul
vpmullw		%ymm15,%ymm6,%ymm12
vpmullw		%ymm15,%ymm7,%ymm13
vpmullw		%ymm15,%ymm8,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm9
vpmulhw		%ymm2,%ymm7,%ymm10
vpmulhw		%ymm2,%ymm8,%ymm11

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm12,%ymm9,%ymm12
vpsubw		%ymm13,%ymm10,%ymm13
vpsubw		%ymm14,%ymm11,%ymm14

#update
vpaddw		%ymm12,%ymm3,%ymm9
vpaddw		%ymm13,%ymm4,%ymm10
vpaddw		%ymm14,%ymm5,%ymm11
vpsubw		%ymm12,%ymm3,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14
vpaddw		%ymm6,%ymm12,%ymm12
vpaddw		%ymm7,%ymm13,%ymm13
vpaddw		%ymm8,%ymm14,%ymm14

#store
vmovdqa		%ymm9,(%rdi)
vmovdqa		%ymm10,32(%rdi)
vmovdqa		%ymm11,64(%rdi)
vmovdqa		%ymm12,1152(%rdi)
vmovdqa		%ymm13,1184(%rdi)
vmovdqa		%ymm14,1216(%rdi)

add		$96,%rsi
add		$96,%rdi
add		$96,%rax
cmp		$1152,%rax
jb		_looptop_j_0

add		$8,%rdx
sub		$1152,%rdi

#level 1
#load
vmovdqa	_low_mask(%rip),%ymm1
vmovdqu	_16xwqinv(%rip),%ymm2 #winv
vmovdqu	_16xw(%rip),%ymm3 #w

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
vmovdqa		384(%rdi),%ymm8
vmovdqa		768(%rdi),%ymm9

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
vmovdqa		%ymm13,384(%rdi)
vmovdqa		%ymm14,768(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$384,%rcx
jb		_looptop_j_1

add		$16,%rdx
add		$768,%rdi
add		$1152,%rax
cmp		$2304,%rax
jb		_looptop_start_1

sub		$2304,%rdi

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
vmovdqa		128(%rdi),%ymm8
vmovdqa		256(%rdi),%ymm9

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
vmovdqa		%ymm13,128(%rdi)
vmovdqa		%ymm14,256(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$128,%rcx
jb		_looptop_j_2

add		$16,%rdx
add		$256,%rdi
add		$384,%rax
cmp		$2304,%rax
jb		_looptop_start_2

sub		$2304,%rdi

xor		%rax,%rax
xor		%rcx,%rcx
.p2align 5
_looptop_start_34567:
#level3
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7

#zetas
vpbroadcastd    (%rdx,%rcx),%ymm15 #zetaqinv
vpbroadcastd    4(%rdx,%rcx),%ymm2 #zeta

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
vperm2i128	$0x20,%ymm13,%ymm11,%ymm4
vperm2i128	$0x31,%ymm13,%ymm11,%ymm5
vperm2i128	$0x20,%ymm14,%ymm12,%ymm6
vperm2i128	$0x31,%ymm14,%ymm12,%ymm7

#level4
#zetas
vmovdqu    144(%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    176(%rdx,%rax),%ymm2 #zeta

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
vpunpcklqdq	%ymm13,%ymm11,%ymm4
vpunpckhqdq	%ymm13,%ymm11,%ymm5
vpunpcklqdq	%ymm14,%ymm12,%ymm6
vpunpckhqdq	%ymm14,%ymm12,%ymm7

#level5
#zetas
vmovdqu    1296(%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    1328(%rdx,%rax),%ymm2 #zeta

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
vpsllq		$32,%ymm13,%ymm2
vpblendd	$0xAA,%ymm2,%ymm11,%ymm4
vpsrlq		$32,%ymm11,%ymm11
vpblendd	$0xAA,%ymm13,%ymm11,%ymm5
vpsllq		$32,%ymm14,%ymm2
vpblendd	$0xAA,%ymm2,%ymm12,%ymm6
vpsrlq		$32,%ymm12,%ymm12
vpblendd	$0xAA,%ymm14,%ymm12,%ymm7

#level6
#zetas
vmovdqu    2448(%rdx,%rax),%ymm15 #ainv
vmovdqu    2480(%rdx,%rax),%ymm2 #ainv

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
vpsllq		$16,%ymm13,%ymm2
vpblendw	$0xAA,%ymm2,%ymm11,%ymm4
vpsrlq		$16,%ymm11,%ymm11
vpblendw	$0xAA,%ymm13,%ymm11,%ymm5
vpsllq		$16,%ymm14,%ymm2
vpblendw	$0xAA,%ymm2,%ymm12,%ymm6
vpsrlq		$16,%ymm12,%ymm12
vpblendw	$0xAA,%ymm14,%ymm12,%ymm7

#level7
#zetas
vmovdqu    3600(%rdx,%rax),%ymm15 #ainv
vmovdqu    3632(%rdx,%rax),%ymm2 #ainv

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

#store
vmovdqa		%ymm11,(%rdi)
vmovdqa		%ymm12,32(%rdi)
vmovdqa		%ymm13,64(%rdi)
vmovdqa		%ymm14,96(%rdi)

add		$128,%rdi
add     $8,%rcx
add		$64,%rax
cmp		$1152,%rax

jb		_looptop_start_34567

ret
