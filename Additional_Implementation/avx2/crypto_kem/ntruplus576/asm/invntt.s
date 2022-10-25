.global poly_invntt
poly_invntt:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xv(%rip),%ymm1
lea		zetas_inv(%rip),%rdx

mov		%rdx,%r9
add		$2048,%r9
xor		%rax,%rax
.p2align 5
_looptop_start_6543:
#level6
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7

#shuffle
vpslld		$16,%ymm5,%ymm10
vpslld		$16,%ymm7,%ymm12
vpblendw	$0xAA,%ymm10,%ymm4,%ymm10
vpblendw	$0xAA,%ymm12,%ymm6,%ymm12
vpsrld		$16,%ymm4,%ymm11
vpsrld		$16,%ymm6,%ymm13
vpblendw	$0xAA,%ymm5,%ymm11,%ymm11
vpblendw	$0xAA,%ymm7,%ymm13,%ymm13

vmovdqa		%ymm10,%ymm4
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm12,%ymm6
vmovdqa		%ymm13,%ymm7

#update
vpsubw		%ymm5,%ymm4,%ymm10
vpsubw		%ymm7,%ymm6,%ymm12
vpaddw		%ymm5,%ymm4,%ymm4
vpaddw		%ymm7,%ymm6,%ymm6

#zetas
vmovdqa		(%rdx,%rax),%ymm2
vmovdqa		64(%rdx,%rax),%ymm3
vmovdqa		32(%rdx,%rax),%ymm13
vmovdqa		96(%rdx,%rax),%ymm14

#mul
vpmullw		%ymm2,%ymm10,%ymm5
vpmullw		%ymm3,%ymm12,%ymm7
vpmulhw		%ymm13,%ymm10,%ymm10
vpmulhw		%ymm14,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm5,%ymm10,%ymm5
vpsubw		%ymm7,%ymm12,%ymm7

#level5
#shuffle
vpsllq		$32,%ymm5,%ymm10
vpsllq		$32,%ymm7,%ymm12
vpblendd	$0xAA,%ymm10,%ymm4,%ymm10
vpblendd	$0xAA,%ymm12,%ymm6,%ymm12
vpsrlq		$32,%ymm4,%ymm11
vpsrlq		$32,%ymm6,%ymm13
vpblendd	$0xAA,%ymm5,%ymm11,%ymm11
vpblendd	$0xAA,%ymm7,%ymm13,%ymm13

vmovdqa		%ymm10,%ymm4
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm12,%ymm6
vmovdqa		%ymm13,%ymm7

#update
vpsubw		%ymm5,%ymm4,%ymm10
vpsubw		%ymm7,%ymm6,%ymm12
vpaddw		%ymm5,%ymm4,%ymm4
vpaddw		%ymm7,%ymm6,%ymm6

#zetas
vmovdqa		1152(%rdx,%rax),%ymm2
vmovdqa		1216(%rdx,%rax),%ymm3
vmovdqa		1184(%rdx,%rax),%ymm13
vmovdqa		1248(%rdx,%rax),%ymm14

#mul
vpmullw		%ymm2,%ymm10,%ymm5
vpmullw		%ymm3,%ymm12,%ymm7
vpmulhw		%ymm13,%ymm10,%ymm10
vpmulhw		%ymm14,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm5,%ymm10,%ymm5
vpsubw		%ymm7,%ymm12,%ymm7

#reduce2
vpmulhw		%ymm1,%ymm4,%ymm10
vpmulhw		%ymm1,%ymm6,%ymm11
vpsraw		$10,%ymm10,%ymm10
vpsraw		$10,%ymm11,%ymm11
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm6,%ymm6

#level4
#shuffle
vpunpcklqdq	%ymm5,%ymm4,%ymm10
vpunpcklqdq	%ymm7,%ymm6,%ymm12
vpunpckhqdq	%ymm5,%ymm4,%ymm11
vpunpckhqdq	%ymm7,%ymm6,%ymm13

vmovdqa		%ymm10,%ymm4
vmovdqa		%ymm11,%ymm5
vmovdqa		%ymm12,%ymm6
vmovdqa		%ymm13,%ymm7

#update
vpsubw		%ymm5,%ymm4,%ymm10
vpsubw		%ymm7,%ymm6,%ymm12
vpaddw		%ymm5,%ymm4,%ymm4
vpaddw		%ymm7,%ymm6,%ymm6

#zetas
vmovdqa		1152(%rdx,%rax),%ymm2
vmovdqa		1216(%rdx,%rax),%ymm3
vmovdqa		1184(%rdx,%rax),%ymm13
vmovdqa		1248(%rdx,%rax),%ymm14


#zetas
vmovdqu		1536(%rdx,%rax),%ymm12
vmovdqu		1600(%rdx,%rax),%ymm13
vmovdqu		1568(%rdx,%rax),%ymm14
vmovdqu		1632(%rdx,%rax),%ymm15

#mul
vpmullw		%ymm2,%ymm10,%ymm5
vpmullw		%ymm3,%ymm12,%ymm7
vpmulhw		%ymm13,%ymm10,%ymm10
vpmulhw		%ymm14,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm5,%ymm10,%ymm5
vpsubw		%ymm7,%ymm12,%ymm7

#save
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,96(%rdi)

#shuffle
vpunpcklqdq	%ymm5,%ymm4,%ymm10
vpunpcklqdq	%ymm7,%ymm6,%ymm11
vpunpckhqdq	%ymm5,%ymm4,%ymm13
vpunpckhqdq	%ymm7,%ymm6,%ymm14

#save
vmovdqa		%ymm10,(%rdi)
vmovdqa		%ymm13,32(%rdi)
vmovdqa		%ymm11,64(%rdi)
vmovdqa		%ymm14,96(%rdi)

#level5
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7

#update
vpsubw		%ymm5,%ymm4,%ymm8
vpsubw		%ymm7,%ymm6,%ymm9
vpaddw		%ymm5,%ymm4,%ymm4
vpaddw		%ymm7,%ymm6,%ymm6

#zetas
vmovdqu		3072(%rdx,%rax),%ymm12
vmovdqu		3136(%rdx,%rax),%ymm13
vmovdqu		3104(%rdx,%rax),%ymm14
vmovdqu		3168(%rdx,%rax),%ymm15

#mul
vpmullw		%ymm12,%ymm8,%ymm12
vpmullw		%ymm13,%ymm9,%ymm13
vpmulhw		%ymm14,%ymm8,%ymm14
vpmulhw		%ymm15,%ymm9,%ymm15

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm12,%ymm14,%ymm5
vpsubw		%ymm13,%ymm15,%ymm7


#reduce2
vpmulhw		%ymm1,%ymm4,%ymm10
vpmulhw		%ymm1,%ymm6,%ymm11
vpsraw		$10,%ymm10,%ymm10
vpsraw		$10,%ymm11,%ymm11
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm6,%ymm6


#shuffle
vperm2i128	$0x20,%ymm5,%ymm4,%ymm10
vperm2i128	$0x20,%ymm7,%ymm6,%ymm11
vperm2i128	$0x31,%ymm5,%ymm4,%ymm12
vperm2i128	$0x31,%ymm7,%ymm6,%ymm13


#save
vmovdqa		%ymm10,(%rdi)
vmovdqa		%ymm12,32(%rdi)
vmovdqa		%ymm11,64(%rdi)
vmovdqa		%ymm13,96(%rdi)

#level4
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7

#update
vpsubw		%ymm5,%ymm4,%ymm8
vpsubw		%ymm7,%ymm6,%ymm9
vpaddw		%ymm5,%ymm4,%ymm4
vpaddw		%ymm7,%ymm6,%ymm6

#zetas
vpbroadcastd	4608(%rdx,%r8,2),%ymm12
vpbroadcastd	4616(%rdx,%r8,2),%ymm13
vpbroadcastd	4612(%rdx,%r8,2),%ymm14
vpbroadcastd	4620(%rdx,%r8,2),%ymm15

#mul
vpmullw		%ymm12,%ymm8,%ymm12
vpmullw		%ymm13,%ymm9,%ymm13
vpmulhw		%ymm14,%ymm8,%ymm14
vpmulhw		%ymm15,%ymm9,%ymm15

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm12,%ymm14,%ymm5
vpsubw		%ymm13,%ymm15,%ymm7

#save
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,96(%rdi)

#level3
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7

#update
vpsubw		%ymm6,%ymm4,%ymm8
vpsubw		%ymm7,%ymm5,%ymm9
vpaddw		%ymm6,%ymm4,%ymm4
vpaddw		%ymm7,%ymm5,%ymm5

#zetas
vpbroadcastd	4800(%rdx,%r8),%ymm2
vpbroadcastd	4804(%rdx,%r8),%ymm3

#mul
vpmullw		%ymm2,%ymm8,%ymm12
vpmullw		%ymm2,%ymm9,%ymm13
vpmulhw		%ymm3,%ymm8,%ymm14
vpmulhw		%ymm3,%ymm9,%ymm15

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm12,%ymm14,%ymm6
vpsubw		%ymm13,%ymm15,%ymm7

#save
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,96(%rdi)
*/
add		$128,%rdi
add     $8,%r8
add		$128,%rax
cmp		$1152,%rax
jb		_looptop_start_6543

sub		$1536,%rdi

ret
