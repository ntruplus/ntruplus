.global poly_invntt
poly_invntt:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xv(%rip),%ymm1
lea		zetas_inv(%rip),%rdx

xor		%rax,%rax
xor		%rcx,%rcx
.p2align 5
_looptop_start_76543:
#level7
#load
vmovdqa		(%rsi),%ymm4
vmovdqa		32(%rsi),%ymm5
vmovdqa		64(%rsi),%ymm6
vmovdqa		96(%rsi),%ymm7

#update
vpsubw		%ymm6,%ymm4,%ymm10
vpsubw		%ymm7,%ymm5,%ymm11
vpaddw		%ymm6,%ymm4,%ymm6
vpaddw		%ymm7,%ymm5,%ymm7

#zetas
vmovdqa		(%rdx,%rax),%ymm2
vmovdqa		32(%rdx,%rax),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm8
vpmullw		%ymm2,%ymm11,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm8,%ymm10,%ymm8
vpsubw		%ymm9,%ymm11,%ymm9

#shuffle
vpslld		$16,%ymm7,%ymm10
vpslld		$16,%ymm9,%ymm11
vpblendw	$0xAA,%ymm10,%ymm6,%ymm4
vpblendw	$0xAA,%ymm11,%ymm8,%ymm5
vpsrld		$16,%ymm6,%ymm12
vpsrld		$16,%ymm8,%ymm13
vpblendw	$0xAA,%ymm7,%ymm12,%ymm6
vpblendw	$0xAA,%ymm9,%ymm13,%ymm7

#level6
#update
vpsubw		%ymm6,%ymm4,%ymm10
vpsubw		%ymm7,%ymm5,%ymm11
vpaddw		%ymm6,%ymm4,%ymm6
vpaddw		%ymm7,%ymm5,%ymm7

#zetas
vmovdqa		768(%rdx,%rax),%ymm2
vmovdqa		800(%rdx,%rax),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm8
vpmullw		%ymm2,%ymm11,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm8,%ymm10,%ymm8
vpsubw		%ymm9,%ymm11,%ymm9

#reduce2
vpmulhw		%ymm1,%ymm6,%ymm10
vpmulhw		%ymm1,%ymm7,%ymm11
vpsraw		$10,%ymm10,%ymm10
vpsraw		$10,%ymm11,%ymm11
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm10,%ymm6,%ymm6
vpsubw		%ymm11,%ymm7,%ymm7

#shuffle
vpsllq		$32,%ymm7,%ymm10
vpsllq		$32,%ymm9,%ymm11
vpblendd	$0xAA,%ymm10,%ymm6,%ymm4
vpblendd	$0xAA,%ymm11,%ymm8,%ymm5
vpsrlq		$32,%ymm6,%ymm12
vpsrlq		$32,%ymm8,%ymm13
vpblendd	$0xAA,%ymm7,%ymm12,%ymm6
vpblendd	$0xAA,%ymm9,%ymm13,%ymm7

#level5
#update
vpsubw		%ymm6,%ymm4,%ymm10
vpsubw		%ymm7,%ymm5,%ymm11
vpaddw		%ymm6,%ymm4,%ymm6
vpaddw		%ymm7,%ymm5,%ymm7

#zetas
vmovdqa		1536(%rdx,%rax),%ymm2
vmovdqa		1568(%rdx,%rax),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm8
vpmullw		%ymm2,%ymm11,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm8,%ymm10,%ymm8
vpsubw		%ymm9,%ymm11,%ymm9

#shuffle
vpunpcklqdq	%ymm7,%ymm6,%ymm4
vpunpcklqdq	%ymm9,%ymm8,%ymm5
vpunpckhqdq	%ymm7,%ymm6,%ymm6
vpunpckhqdq	%ymm9,%ymm8,%ymm7

#level4
#update
vpsubw		%ymm6,%ymm4,%ymm10
vpsubw		%ymm7,%ymm5,%ymm11
vpaddw		%ymm6,%ymm4,%ymm6
vpaddw		%ymm7,%ymm5,%ymm7

#zetas
vmovdqa		2304(%rdx,%rax),%ymm2
vmovdqa		2336(%rdx,%rax),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm8
vpmullw		%ymm2,%ymm11,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm8,%ymm10,%ymm8
vpsubw		%ymm9,%ymm11,%ymm9

#reduce2
vpmulhw		%ymm1,%ymm6,%ymm10
vpmulhw		%ymm1,%ymm7,%ymm11
vpsraw		$10,%ymm10,%ymm10
vpsraw		$10,%ymm11,%ymm11
vpmullw		%ymm0,%ymm10,%ymm10
vpmullw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm10,%ymm6,%ymm6
vpsubw		%ymm11,%ymm7,%ymm7

#shuffle
vperm2i128	$0x20,%ymm7,%ymm6,%ymm4
vperm2i128	$0x31,%ymm7,%ymm6,%ymm6
vperm2i128	$0x20,%ymm9,%ymm8,%ymm5
vperm2i128	$0x31,%ymm9,%ymm8,%ymm7

#level3
#update
vpsubw		%ymm6,%ymm4,%ymm10
vpsubw		%ymm7,%ymm5,%ymm11
vpaddw		%ymm6,%ymm4,%ymm6
vpaddw		%ymm7,%ymm5,%ymm7

#zetas
vpbroadcastd    3072(%rdx,%rcx),%ymm2
vpbroadcastd    3076(%rdx,%rcx),%ymm3

#mul
vpmullw		%ymm2,%ymm10,%ymm8
vpmullw		%ymm2,%ymm11,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm8,%ymm10,%ymm8
vpsubw		%ymm9,%ymm11,%ymm9

#store
vmovdqa		%ymm6,(%rdi)
vmovdqa		%ymm7,32(%rdi)
vmovdqa		%ymm8,64(%rdi)
vmovdqa		%ymm9,96(%rdi)

add		$128,%rsi
add		$128,%rdi
add		$64,%rax
add		$8,%rcx
cmp		$768,%rax
jb		_looptop_start_76543

sub		$1536,%rdi

#level2
vmovdqa _16xwinvqinv(%rip),%ymm2 #w^-1qinv
vmovdqa _16xwinv(%rip),%ymm3     #w^-1

xor		%rax,%rax
.p2align 5
_looptop_start_2:
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9
vmovdqa		192(%rdi),%ymm10
vmovdqa		224(%rdi),%ymm11

#update
vpsubw		%ymm8,%ymm4,%ymm12
vpsubw		%ymm9,%ymm5,%ymm13
vpsubw		%ymm10,%ymm6,%ymm14
vpsubw		%ymm11,%ymm7,%ymm15
vpaddw		%ymm8,%ymm4,%ymm4
vpaddw		%ymm9,%ymm5,%ymm5
vpaddw		%ymm10,%ymm6,%ymm6
vpaddw		%ymm11,%ymm7,%ymm7

#zetas
vpbroadcastd 3168(%rdx,%rax),%ymm2
vpbroadcastd 3172(%rdx,%rax),%ymm3

#mul
vpmullw		%ymm2,%ymm12,%ymm8
vpmullw		%ymm2,%ymm13,%ymm9
vpmullw		%ymm2,%ymm14,%ymm10
vpmullw		%ymm2,%ymm15,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12
vpmulhw		%ymm3,%ymm13,%ymm13
vpmulhw		%ymm3,%ymm14,%ymm14
vpmulhw		%ymm3,%ymm15,%ymm15

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm8,%ymm12,%ymm8
vpsubw		%ymm9,%ymm13,%ymm9
vpsubw		%ymm10,%ymm14,%ymm10
vpsubw		%ymm11,%ymm15,%ymm11

#reduce2
vpmulhw		%ymm1,%ymm4,%ymm2
vpmulhw		%ymm1,%ymm5,%ymm3
vpsraw		$10,%ymm2,%ymm2
vpsraw		$10,%ymm3,%ymm3
vpmullw		%ymm0,%ymm2,%ymm2
vpmullw		%ymm0,%ymm3,%ymm3
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5

vpmulhw		%ymm1,%ymm6,%ymm2
vpmulhw		%ymm1,%ymm7,%ymm3
vpsraw		$10,%ymm2,%ymm2
vpsraw		$10,%ymm3,%ymm3
vpmullw		%ymm0,%ymm2,%ymm2
vpmullw		%ymm0,%ymm3,%ymm3
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,96(%rdi)
vmovdqa		%ymm8,128(%rdi)
vmovdqa		%ymm9,160(%rdi)
vmovdqa		%ymm10,192(%rdi)
vmovdqa		%ymm11,224(%rdi)

add		$256,%rdi
add		$8,%rax
cmp		$48,%rax
jb		_looptop_start_2

sub		$1536,%rdi

#level1
vmovdqa _16xwinvqinv(%rip),%ymm2 #w^-1qinv
vmovdqa _16xwinv(%rip),%ymm3     #w^-1

xor		%rax,%rax
.p2align 5
_looptop_start_1:
#load
vpbroadcastd 3216(%rdx,%rax),%ymm4 #z^-1qinv
vpbroadcastd 3224(%rdx,%rax),%ymm5 #z^-2qinv
vpbroadcastd 3220(%rdx,%rax),%ymm6 #z^-1
vpbroadcastd 3228(%rdx,%rax),%ymm7 #z^-2

xor		%rcx,%rcx
.p2align 5
_looptop_j_1:
#load
vmovdqa		(%rdi),%ymm8   #X
vmovdqa		256(%rdi),%ymm9 #Y
vmovdqa		512(%rdi),%ymm10 #Z

#add
vpaddw      %ymm9,%ymm10,%ymm11   #Y+Z

#mul
vpmullw		%ymm2,%ymm10,%ymm12  #Zw^-1
vpmulhw		%ymm3,%ymm10,%ymm13  #Zw^-1

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #Zw^-1
vpsubw		%ymm12,%ymm13,%ymm12 #Zw^-1

#add
vpaddw      %ymm12,%ymm9,%ymm10 #Y + Zw^-1

#mul
vpmullw		%ymm2,%ymm10,%ymm12  #w^-1(Y + Zw^-1)
vpmulhw		%ymm3,%ymm10,%ymm13  #w^-1(Y + Zw^-1)

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #w^-1(Y + Zw^-1)
vpsubw		%ymm12,%ymm13,%ymm12 #w^-1(Y + Zw^-1)

#add
vpaddw      %ymm12,%ymm11,%ymm9  #Y + Z + Yw^-1 + Zw^-2
vpsubw      %ymm9,%ymm8,%ymm10   #X + Yw^-2 + Zw^-4
vpaddw      %ymm12,%ymm8,%ymm9   #X + Yw^-1 + Zw^-2
vpaddw      %ymm11,%ymm8,%ymm8   #X + Y + Z

#mul
vpmullw		%ymm4,%ymm9,%ymm11 #z^-1(X + Yw^-1 + Zw^-2)
vpmullw		%ymm5,%ymm10,%ymm12 #z^-2(X + Yw^-2 + Zw^-4)
vpmulhw		%ymm6,%ymm9,%ymm13 #z^-1(X + Yw^-1 + Zw^-2)
vpmulhw		%ymm7,%ymm10,%ymm14 #z^-2(X + Yw^-2 + Zw^-4)

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm11,%ymm13,%ymm9
vpsubw		%ymm12,%ymm14,%ymm10

#store
vmovdqa		%ymm8,(%rdi)
vmovdqa		%ymm9,256(%rdi)
vmovdqa		%ymm10,512(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$256,%rcx
jb		_looptop_j_1

add		$512,%rdi
add     $16,%rax
cmp		$32,%rax
jb		_looptop_start_1

sub		$1536,%rdi

#level 0
#zetas
vpbroadcastd	3248(%rdx),%ymm2    #(z-z^5)^-1
vpbroadcastd	3252(%rdx),%ymm3   #(z-z^5)^-1

vpbroadcastd	3256(%rdx),%ymm13 
vpbroadcastd	3260(%rdx),%ymm14

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
add		$96,%rax
cmp		$768,%rax
jb		_looptop_start_0

ret
