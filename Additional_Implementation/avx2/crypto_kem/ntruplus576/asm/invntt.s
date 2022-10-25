.global poly_invntt
poly_invntt:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xv(%rip),%ymm1
lea		zetas_inv(%rip),%rdx

mov		%rdx,%r9
add		$2048,%r9
xor		%rax,%rax
xor		%r8,%r8
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
vpmulhw		%ymm1,%ymm6,%ymm12
vpsraw		$10,%ymm10,%ymm10
vpsraw		$10,%ymm12,%ymm12
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm12,%ymm6,%ymm6

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
vmovdqa		2304(%rdx,%rax),%ymm2
vmovdqa		2368(%rdx,%rax),%ymm3
vmovdqa		2336(%rdx,%rax),%ymm13
vmovdqa		2400(%rdx,%rax),%ymm14

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

#level3
#shuffle
vperm2i128	$0x20,%ymm5,%ymm4,%ymm10
vperm2i128	$0x20,%ymm7,%ymm6,%ymm12
vperm2i128	$0x31,%ymm5,%ymm4,%ymm11
vperm2i128	$0x31,%ymm7,%ymm6,%ymm13

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
vpbroadcastd 3456(%rdx,%r8),%ymm2
vpbroadcastd 3464(%rdx,%r8),%ymm3
vpbroadcastd 3460(%rdx,%r8),%ymm13
vpbroadcastd 3468(%rdx,%r8),%ymm14

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
vpmulhw		%ymm1,%ymm6,%ymm12
vpsraw		$10,%ymm10,%ymm10
vpsraw		$10,%ymm12,%ymm12
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm12,%ymm6,%ymm6

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,96(%rdi)

add		$128,%rdi
add     $16,%r8
add		$128,%rax
cmp		$1152,%rax
jb		_looptop_start_6543

sub		$1152,%rdi

#level2
vmovdqa _16xwinvqinv(%rip),%ymm2 #w^-1qinv %ymm15
vmovdqa _16xwinv(%rip),%ymm3      #w^-1 %ymm14

xor		%rax,%rax
.p2align 5
_looptop_start_2:
xor		%rcx,%rcx

#load
vpbroadcastd 3600(%rdx,%rax),%ymm4 #z^-1qinv
vpbroadcastd 3608(%rdx,%rax),%ymm5 #z^-2qinv
vpbroadcastd 3604(%rdx,%rax),%ymm6 #z^-1
vpbroadcastd 3612(%rdx,%rax),%ymm7 #z^-2

.p2align 5
_looptop_j_2:
vmovdqa		(%rdi),%ymm8   #X
vmovdqa		64(%rdi),%ymm9 #Y
vmovdqa		128(%rdi),%ymm10 #Z

#add
vpaddw %ymm9,%ymm10,%ymm11   #Y+Z

#mul
vpmullw		%ymm2,%ymm10,%ymm12  #Zw^-1
vpmulhw		%ymm3,%ymm10,%ymm15  #Zw^-1

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #Zw^-1
vpsubw		%ymm12,%ymm15,%ymm12 #Zw^-1

#add
vpaddw      %ymm12,%ymm9,%ymm10 #Y + Zw^-1

#mul
vpmullw		%ymm2,%ymm10,%ymm12  #w^-1(Y + Zw^-1)
vpmulhw		%ymm3,%ymm10,%ymm15  #w^-1(Y + Zw^-1)

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #w^-1(Y + Zw^-1)
vpsubw		%ymm12,%ymm15,%ymm12 #w^-1(Y + Zw^-1)

vpaddw %ymm12,%ymm11,%ymm9  #Y + Z + Yw^-1 + Zw^-2
vpsubw %ymm9,%ymm8,%ymm10   #X + Yw^-2 + Zw^-4
vpaddw %ymm12,%ymm8,%ymm9  #X + Yw^-1 + Zw^-2
vpaddw %ymm11,%ymm8,%ymm8   #X+Y+Z

#mul
vpmullw		%ymm4,%ymm9,%ymm11 #z^-1(X + Yw^-1 + Zw^-2)
vpmullw		%ymm5,%ymm10,%ymm12 #z^-2(X + Yw^-2 + Zw^-4)
vpmulhw		%ymm6,%ymm9,%ymm14 #z^-1(X + Yw^-1 + Zw^-2)
vpmulhw		%ymm7,%ymm10,%ymm15 #z^-2(X + Yw^-2 + Zw^-4)

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm11,%ymm14,%ymm9
vpsubw		%ymm12,%ymm15,%ymm10

#store
vmovdqa		%ymm8,(%rdi)
vmovdqa		%ymm9,64(%rdi)
vmovdqa		%ymm10,128(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$64,%rcx
jb		_looptop_j_2

add		$128,%rdi
add     $16,%rax
cmp		$96,%rax
jb		_looptop_start_2

sub		$1152,%rdi


/*
xor		%rax,%rax
.p2align 5
_looptop_start_1:
xor		%rcx,%rcx
.p2align 5
_looptop_j_1:
vmovdqa		(%rdi),%ymm4   #X
vmovdqa		192(%rdi),%ymm5 #Y
vmovdqa		384(%rdi),%ymm6 #Z

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
vpbroadcastd 3616(%rdx,%rax),%ymm13 #z^-1qinv
vpbroadcastd 3624(%rdx,%rax),%ymm14 #z^-2qinv
vpbroadcastd 3620(%rdx,%rax),%ymm10 #z^-1
vpbroadcastd 3628(%rdx,%rax),%ymm11 #z^-2

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
vmovdqa		%ymm5,192(%rdi)
vmovdqa		%ymm6,384(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$192,%rcx
jb		_looptop_j_1

add		$256,%rdi
add     $16,%rax
cmp		$32,%rax
jb		_looptop_start_1

sub		$1152,%rdi

/*

xor		%rax,%rax
.p2align 5
_looptop_start_2:
xor		%rcx,%rcx
.p2align 5
_looptop_j_2:
vmovdqa		(%rdi),%ymm4   #X
vmovdqa		64(%rdi),%ymm5 #Y
vmovdqa		128(%rdi),%ymm6 #Z

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
vpbroadcastd 3600(%rdx,%rax),%ymm13 #z^-1qinv
vpbroadcastd 3608(%rdx,%rax),%ymm14 #z^-2qinv
vpbroadcastd 3604(%rdx,%rax),%ymm10 #z^-1
vpbroadcastd 3612(%rdx,%rax),%ymm11 #z^-2

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
vmovdqa		%ymm5,64(%rdi)
vmovdqa		%ymm6,128(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$64,%rcx
jb		_looptop_j_2

add		$128,%rdi
add     $16,%rax
cmp		$96,%rax
jb		_looptop_start_2

sub		$1152,%rdi
/*
#level2
vmovdqa _16xwinvqinv(%rip),%ymm2 #w^-1qinv %ymm15
vmovdqa _16xwinv(%rip),%ymm3      #w^-1 %ymm14

xor		%rax,%rax
.p2align 5
_looptop_start_2:
#load
vpbroadcastd 3600(%rdx,%rax),%ymm4 #z^-1qinv
vpbroadcastd 3608(%rdx,%rax),%ymm5 #z^-2qinv
vpbroadcastd 3604(%rdx,%rax),%ymm6 #z^-1
vpbroadcastd 3612(%rdx,%rax),%ymm7 #z^-2

xor		%rcx,%rcx
.p2align 5
_looptop_j_2:
vmovdqa		(%rdi),%ymm8   #X
vmovdqa		64(%rdi),%ymm9 #Y
vmovdqa		128(%rdi),%ymm10 #Z


Y*w^-1 + Z*w^-2
Y + Z

Z = z^-2(X - (Y + Z + Y*w^-1 + Z*w^-2))
Y = z^-1(X + Y*w^-1 + Z*w^-2)
X = X + Y + Z
#add
vpaddw		%ymm10,%ymm9,%ymm11   #Y + Z

#mul
vpmullw		%ymm2,%ymm10,%ymm12  #Zw^-1
vpmulhw		%ymm3,%ymm10,%ymm10  

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #Zw^-1
vpsubw		%ymm12,%ymm10,%ymm10 

#add
vpaddw      %ymm9,%ymm10,%ymm10 #Y + Zw^-1

#mul
vpmullw		%ymm2,%ymm10,%ymm12  #w^-1(Y + Zw^-1)
vpmulhw		%ymm3,%ymm10,%ymm10  

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #w^-1(Y + Zw^-1)
vpsubw		%ymm12,%ymm10,%ymm10 

#add
vpaddw		%ymm11,%ymm8,%ymm13  #X+Y+Z
vpaddw		%ymm11,%ymm10,%ymm14 #Y + Z + w^-1(Y + Zw^-1)
vpsubw		%ymm14,%ymm8,%ymm15  #X + Yw^-2 + Zw^-4
vpaddw		%ymm10,%ymm8,%ymm10  #X + Yw^-1 + Zw^-2

#mul
vpmullw		%ymm4,%ymm10,%ymm8 #z^-1(X + Yw^-1 + Zw^-2)
vpmullw		%ymm5,%ymm15,%ymm9 #z^-2(X + Yw^-2 + Zw^-4)
vpmulhw		%ymm6,%ymm10,%ymm10 
vpmulhw		%ymm7,%ymm15,%ymm11

#reduce
vpmulhw		%ymm0,%ymm10,%ymm14
vpmulhw		%ymm0,%ymm11,%ymm15
vpsubw		%ymm10,%ymm10,%ymm10
vpsubw		%ymm11,%ymm11,%ymm11

#store
vmovdqa		%ymm13,(%rdi)
vmovdqa		%ymm10,64(%rdi)
vmovdqa		%ymm11,128(%rdi)


#store
vmovdqa		%ymm6,(%rdi)
vmovdqa		%ymm0,64(%rdi)
vmovdqa		%ymm0,128(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$64,%rcx
jb		_looptop_j_2

add		$128,%rdi
add     $16,%rax
cmp		$96,%rax
jb		_looptop_start_2

sub		$1152,%rdi
/*
#level1
xor         %rax,%rax
.p2align 5
_looptop_start_1:
xor		%rcx,%rcx
.p2align 5
_looptop_j_1:
vmovdqa		(%rdi),%ymm4   #X
vmovdqa		192(%rdi),%ymm5 #Y
vmovdqa		384(%rdi),%ymm6 #Z

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
vpbroadcastd 3616(%rdx,%r8),%ymm13 #z^-1qinv
vpbroadcastd 3624(%rdx,%r8),%ymm14 #z^-2qinv
vpbroadcastd 3620(%rdx,%r8),%ymm10 #z^-1
vpbroadcastd 3628(%rdx,%r8),%ymm11 #z^-2

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
vmovdqa		%ymm5,192(%rdi)
vmovdqa		%ymm6,384(%rdi)

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
/*
#level 0
#zetas
vpbroadcastd	(%r9),%ymm2    #(z-z^5)^-1
vpbroadcastd	4(%r9),%ymm3   #(z-z^5)^-1
vpbroadcastd	8(%r9),%ymm13 
vpbroadcastd	12(%r9),%ymm14
vpsllw			$1,%ymm13,%ymm15
vpsllw			$1,%ymm14,%ymm1

xor			%rax,%rax
.p2align 5
_looptop_start_0:
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
jb		_looptop_start_0
*/
ret
