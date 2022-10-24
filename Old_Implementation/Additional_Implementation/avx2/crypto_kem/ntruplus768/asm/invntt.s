.global poly_invntt
poly_invntt:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xv(%rip),%ymm1
lea		zetas_inv(%rip),%rdx

xor		%rax,%rax
xor     %r8,%r8
.p2align 5
_looptop_start_76543:
#level7
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
vmovdqu		0(%rdx,%rax),%ymm12
vmovdqu		64(%rdx,%rax),%ymm13
vmovdqu		32(%rdx,%rax),%ymm14
vmovdqu		96(%rdx,%rax),%ymm15

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
vpsllq		$32,%ymm5,%ymm10
vpsllq		$32,%ymm7,%ymm11
vpblendd	$0xAA,%ymm10,%ymm4,%ymm10
vpblendd	$0xAA,%ymm11,%ymm6,%ymm11
vpsrlq		$32,%ymm4,%ymm13
vpsrlq		$32,%ymm6,%ymm14
vpblendd	$0xAA,%ymm5,%ymm13,%ymm13
vpblendd	$0xAA,%ymm7,%ymm14,%ymm14

#save
vmovdqa		%ymm10,(%rdi)
vmovdqa		%ymm13,32(%rdi)
vmovdqa		%ymm11,64(%rdi)
vmovdqa		%ymm14,96(%rdi)

#level6
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
vmovdqu		1536(%rdx,%rax),%ymm12
vmovdqu		1600(%rdx,%rax),%ymm13
vmovdqu		1568(%rdx,%rax),%ymm14
vmovdqu		1632(%rdx,%rax),%ymm15

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

add		$128,%rdi
add     $8,%r8
add		$128,%rax
cmp		$1536,%rax
jb		_looptop_start_76543

sub		$1536,%rdi
/*
#level2
xor		%r8,%r8
.p2align 5
_looptop_level_2:
#zetas
vpbroadcastd	4808(%rdx,%r8),%ymm2
vpbroadcastd	4812(%rdx,%r8),%ymm3

#load
vmovdqa		0(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		128(%rdi),%ymm6
vmovdqa		160(%rdi),%ymm7

#update
vpsubw		%ymm6,%ymm4,%ymm8
vpsubw		%ymm7,%ymm5,%ymm9
vpaddw		%ymm6,%ymm4,%ymm4
vpaddw		%ymm7,%ymm5,%ymm5

#mul
vpmullw		%ymm2,%ymm8,%ymm10
vpmullw		%ymm2,%ymm9,%ymm11
vpmulhw		%ymm3,%ymm8,%ymm8
vpmulhw		%ymm3,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm10,%ymm8,%ymm8
vpsubw		%ymm11,%ymm9,%ymm9





xor		%r8,%r8
.p2align 5
_looptop_j_56:
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		(%rdi,%rax,2),%ymm7
vmovdqa		32(%rdi,%rax,2),%ymm8
vmovdqa		64(%rdi,%rax,2),%ymm9

#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#reduce2
vpmulhw		%ymm1,%ymm4,%ymm10
vpmulhw		%ymm1,%ymm5,%ymm11
vpmulhw		%ymm1,%ymm6,%ymm12
vpsraw		$10,%ymm10,%ymm10
vpsraw		$10,%ymm11,%ymm11
vpsraw		$10,%ymm12,%ymm12
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm11,%ymm11
vpmullw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5
vpsubw		%ymm12,%ymm6,%ymm6

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,(%rdi,%rax,2)
vmovdqa		%ymm8,32(%rdi,%rax,2)
vmovdqa		%ymm9,64(%rdi,%rax,2)

add		$96,%rdi
add		$48,%r8
cmp		%rax,%r8
jb		_looptop_j_56

add		%rax,%rdi
add		%rax,%rdi
add		$8,%r9
add		%rax,%rcx
add		%rax,%rcx
cmp		$768,%rcx
jb		_looptop_start_56

sub		$1536,%rdi
add		%rax,%rax
cmp		$384,%rax
jb		_looptop_level_56

#level 7
#zetas
vpbroadcastd	(%r9),%ymm2    #(z-z^5)^-1
vpbroadcastd	4(%r9),%ymm3   #(z-z^5)^-1
vpbroadcastd	8(%r9),%ymm13 
vpbroadcastd	12(%r9),%ymm14
vpsllw			$1,%ymm13,%ymm15
vpsllw			$1,%ymm14,%ymm1

xor			%rax,%rax
.p2align 5
_looptop_j_7:
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		768(%rdi),%ymm7
vmovdqa		800(%rdi),%ymm8
vmovdqa		832(%rdi),%ymm9

#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#update
vpsubw		%ymm7,%ymm4,%ymm4
vpsubw		%ymm8,%ymm5,%ymm5
vpsubw		%ymm9,%ymm6,%ymm6

#mul
vpmullw		%ymm13,%ymm4,%ymm10
vpmullw		%ymm13,%ymm5,%ymm11
vpmullw		%ymm13,%ymm6,%ymm12
vpmulhw		%ymm14,%ymm4,%ymm4
vpmulhw		%ymm14,%ymm5,%ymm5
vpmulhw		%ymm14,%ymm6,%ymm6

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5
vpsubw		%ymm12,%ymm6,%ymm6

#mul
vpmullw		%ymm15,%ymm7,%ymm10
vpmullw		%ymm15,%ymm8,%ymm11
vpmullw		%ymm15,%ymm9,%ymm12
vpmulhw		%ymm1,%ymm7,%ymm7
vpmulhw		%ymm1,%ymm8,%ymm8
vpmulhw		%ymm1,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm7,%ymm7
vpsubw		%ymm11,%ymm8,%ymm8
vpsubw		%ymm12,%ymm9,%ymm9

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,768(%rdi)
vmovdqa		%ymm8,800(%rdi)
vmovdqa		%ymm9,832(%rdi)

add		$96,%rdi
add		$48,%rax
cmp		$384,%rax
jb		_looptop_j_7
*/
ret

/*

vmovdqa		%ymm4,%ymm6 #Z
vmovdqa		%ymm3,%ymm5 #Y
vmovdqa		%ymm2,%ymm4 #X

#round1
#add
vpaddw		%ymm5,%ymm6,%ymm7   #Y+Z

#mul
vpmullw		%ymm15,%ymm6,%ymm14  #Zw^-1
vpmulhw		%ymm12,%ymm6,%ymm13  #Zw^-1

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14  #Zw^-1
vpsubw		%ymm14,%ymm13,%ymm14 #Zw^-1

#add
vpaddw      %ymm14,%ymm5,%ymm6 #Y + Zw^-1

#mul
vpmullw		%ymm15,%ymm6,%ymm14  #w^-1(Y + Zw^-1)
vpmulhw		%ymm12,%ymm6,%ymm13  #w^-1(Y + Zw^-1)

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14  #w^-1(Y + Zw^-1)
vpsubw		%ymm14,%ymm13,%ymm14 #w^-1(Y + Zw^-1)

vpaddw		%ymm14,%ymm7,%ymm5  #Y + Z + Yw^-1 + Zw^-2
vpsubw		%ymm5,%ymm4,%ymm6   #X + Yw^-2 + Zw^-4
vpaddw		%ymm14,%ymm4,%ymm5  #X + Yw^-1 + Zw^-2
vpaddw		%ymm7,%ymm4,%ymm4   #X+Y+Z

#load
vmovdqa		(%rdx,%r8),%ymm13 #z^-1qinv
vmovdqa		64(%rdx,%r8),%ymm14 #z^-2qinv
vmovdqa		32(%rdx,%r8),%ymm10 #z^-1
vmovdqa		96(%rdx,%r8),%ymm11 #z^-2

#mul
vpmullw		%ymm13,%ymm5,%ymm13 #z^-1(X + Yw^-1 + Zw^-2)
vpmullw		%ymm14,%ymm6,%ymm14 #z^-2(X + Yw^-2 + Zw^-4)
vpmulhw		%ymm10,%ymm5,%ymm10 #z^-1(X + Yw^-1 + Zw^-2)
vpmulhw		%ymm11,%ymm6,%ymm11 #z^-2(X + Yw^-2 + Zw^-4)

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm10,%ymm5
vpsubw		%ymm14,%ymm11,%ymm6

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)

#round2
#load
vmovdqa		96(%rdi),%ymm4  #X
vmovdqa		128(%rdi),%ymm5 #Y
vmovdqa		160(%rdi),%ymm6 #Z

#add
vpaddw %ymm5,%ymm6,%ymm7   #Y+Z

#mul
vpmullw		%ymm15,%ymm6,%ymm14  #Zw^-1
vpmulhw		%ymm12,%ymm6,%ymm13  #Zw^-1

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14  #Zw^-1
vpsubw		%ymm14,%ymm13,%ymm14 #Zw^-1

#add
vpaddw      %ymm14,%ymm5,%ymm6 #Y + Zw^-1

#mul
vpmullw		%ymm15,%ymm6,%ymm14  #w^-1(Y + Zw^-1)
vpmulhw		%ymm12,%ymm6,%ymm13  #w^-1(Y + Zw^-1)

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14  #w^-1(Y + Zw^-1)
vpsubw		%ymm14,%ymm13,%ymm14 #w^-1(Y + Zw^-1)

vpaddw %ymm14,%ymm7,%ymm5  #Y + Z + Yw^-1 + Zw^-2
vpsubw %ymm5,%ymm4,%ymm6   #X + Yw^-2 + Zw^-4
vpaddw %ymm14,%ymm4,%ymm5  #X + Yw^-1 + Zw^-2
vpaddw %ymm7,%ymm4,%ymm4   #X+Y+Z

#load
vmovdqa 128(%rdx,%r8),%ymm13 #z^-1qinv
vmovdqa 192(%rdx,%r8),%ymm14 #z^-2qinv
vmovdqa 160(%rdx,%r8),%ymm10 #z^-1
vmovdqa 224(%rdx,%r8),%ymm11 #z^-2

#mul
vpmullw		%ymm13,%ymm5,%ymm13 #z^-1(X + Yw^-1 + Zw^-2)
vpmullw		%ymm14,%ymm6,%ymm14 #z^-2(X + Yw^-2 + Zw^-4)
vpmulhw		%ymm10,%ymm5,%ymm10 #z^-1(X + Yw^-1 + Zw^-2)
vpmulhw		%ymm11,%ymm6,%ymm11 #z^-2(X + Yw^-2 + Zw^-4)

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm10,%ymm5
vpsubw		%ymm14,%ymm11,%ymm6

#store
vmovdqa		%ymm4,%ymm7
vmovdqa		%ymm5,%ymm8
vmovdqa		%ymm6,%ymm9

vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
*/