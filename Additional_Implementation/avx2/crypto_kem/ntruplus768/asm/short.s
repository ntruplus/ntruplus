.global poly_cbd1
poly_cbd1:

vmovdqa		_16x1(%rip),%ymm0
xor		%rax,%rax
.p2align 5
_looptop1:
vmovdqu  	(%rsi),%ymm1
vmovdqu  	96(%rsi),%ymm2

vpand       %ymm0,%ymm1,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpsubw      %ymm4,%ymm3,%ymm5

vmovdqa     %ymm5,(%rdi)

xor         %r8,%r8

_loop1:
vpsrld		$1,%ymm1,%ymm1
vpsrld		$1,%ymm2,%ymm2

vpand       %ymm0,%ymm1,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpsubw      %ymm4,%ymm3,%ymm5

vmovdqa     %ymm5,32(%rdi, %r8)

add         $32,%r8
cmp         $480,%r8
jb          _loop1

add		$32,%rsi
add		$512,%rdi
add		$512,%rax
cmp		$1536,%rax
jb		_looptop1

ret


/*
vpsllq      $32,%ymm2,%ymm7
vpsllq      $32,%ymm4,%ymm8
vpsllq      $32,%ymm6,%ymm9
vpsrlq      $32,%ymm1,%ymm10
vpsrlq      $32,%ymm3,%ymm11
vpsrlq      $32,%ymm5,%ymm12

vpblendd	$0xAA,%ymm7,%ymm1,%ymm7
vpblendd	$0xAA,%ymm8,%ymm3,%ymm8
vpblendd	$0xAA,%ymm9,%ymm5,%ymm9
vpblendd	$0xAA,%ymm2,%ymm10,%ymm10
vpblendd	$0xAA,%ymm4,%ymm11,%ymm11
vpblendd	$0xAA,%ymm6,%ymm12,%ymm12

vpunpcklqdq	%ymm8,%ymm7,%ymm1
vpunpcklqdq	%ymm10,%ymm9,%ymm2
vpunpcklqdq	%ymm12,%ymm11,%ymm3
vpunpckhqdq	%ymm8,%ymm7,%ymm4
vpunpckhqdq	%ymm10,%ymm9,%ymm5
vpunpckhqdq	%ymm12,%ymm11,%ymm6

vperm2i128	$0x20,%ymm2,%ymm1,%ymm7
vperm2i128	$0x20,%ymm4,%ymm3,%ymm8
vperm2i128	$0x20,%ymm6,%ymm5,%ymm9
vperm2i128	$0x31,%ymm2,%ymm1,%ymm10
vperm2i128	$0x31,%ymm4,%ymm3,%ymm11
vperm2i128	$0x31,%ymm6,%ymm5,%ymm12
*/
/*
.global poly_cbd1
poly_cbd1:

vmovdqa		_16x1(%rip),%ymm0
xor		%eax,%eax
.p2align 5
_looptop1:
vmovdqu  	(%rsi),%ymm15

#1
vpand       %ymm15, %ymm0, %ymm1

#2
vpsrld		$1,%ymm15,%ymm15
vpand       %ymm15, %ymm0, %ymm2

vpsubw      %ymm2,%ymm1,%ymm1
vmovdqa     %ymm1,(%rdi)

xor         %r8,%r8
_loop1:
vpsrld		$1,%ymm15,%ymm15
vpand       %ymm15, %ymm0, %ymm1

vpsrld		$1,%ymm15,%ymm15
vpand       %ymm15, %ymm0, %ymm2

vpsubw      %ymm2,%ymm1,%ymm1
vmovdqa     %ymm1,32(%rdi, %r8)

add         $32,%r8
cmp         $224,%r8
jb          _loop1

add		$32,%rsi
add		$256,%rdi
add		$256,%eax
cmp		$1536,%eax
jb		_looptop1

ret
*/
.global poly_cbd1_m1
poly_cbd1_m1:
vmovdqa		_16x1(%rip),%ymm0
xor	        %rax,%rax

.p2align 5
_looptop2:
vmovdqu  	(%rsi),%ymm15

#1
vpand       %ymm15, %ymm0, %ymm1

#2
vpsrld		$1,%ymm15,%ymm15
vpand       %ymm15, %ymm0, %ymm2

vpsubw      %ymm2,%ymm1,%ymm1
vmovdqa     %ymm1,(%rdi)

xor         %r8,%r8
_loop2:
vpsrld		$1,%ymm15,%ymm15
vpand       %ymm15, %ymm0, %ymm1

vpsrld		$1,%ymm15,%ymm15
vpand       %ymm15, %ymm0, %ymm2

vpsubw      %ymm2,%ymm1,%ymm1
vmovdqa     %ymm1,32(%rdi, %r8)

add         $32,%r8
cmp         $224,%r8
jb          _loop2

add		$32,%rsi
add		$256,%rdi
add		$256,%rax
cmp		$1024,%rax
jb		_looptop2

ret

/*
.global poly_short
poly_short:

vmovdqa		_4x9(%rip),%ymm0
vmovdqa		_16x3(%rip),%ymm1
vmovdqa		_16x3(%rip),%ymm2
vmovdqa		_16x1(%rip),%ymm3

xor		%eax,%eax
.p2align 5
_looptop:
vpmovzxbq   (%rsi),%ymm4
vpsrld		$2,%ymm4,%ymm5
vpsrld		$4,%ymm4,%ymm6
vpsrld		$6,%ymm4,%ymm7

vpand		%ymm1,%ymm4,%ymm4
vpand		%ymm1,%ymm5,%ymm5
vpand		%ymm1,%ymm6,%ymm6
vpand		%ymm1,%ymm7,%ymm7

vpsrlvd		%ymm4,%ymm0,%ymm4
vpsrlvd		%ymm5,%ymm0,%ymm5
vpsrlvd		%ymm6,%ymm0,%ymm6
vpsrlvd		%ymm7,%ymm0,%ymm7

vpand		%ymm1,%ymm4,%ymm4
vpand		%ymm1,%ymm5,%ymm5
vpand		%ymm1,%ymm6,%ymm6
vpand		%ymm1,%ymm7,%ymm7

vpsllq		$16,%ymm5,%ymm5
vpsllq		$32,%ymm6,%ymm6
vpsllq		$48,%ymm7,%ymm7
vpor		%ymm4,%ymm5,%ymm4

vpor		%ymm6,%ymm7,%ymm5
vpor		%ymm4,%ymm5,%ymm4
vpand		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm4,%ymm4

vmovdqa		%ymm4,(%rdi)

add		$4,%rsi
add		$32,%rdi
add		$16,%eax
cmp		$768,%eax
jb		_looptop

ret



.global poly_short5
poly_short5:
vmovdqa		_16x1(%rip),%ymm0

xor         %r9,%r9

_loop_poly_short_outer:
vmovdqu  	(%rsi),%ymm2
vmovdqu  	96(%rsi),%ymm3

//g1 - g2
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm6
vmovdqa     %ymm6,(%rdi)

xor         %r8,%r8
.p2align 5
_loop5:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm6
vmovdqa     %ymm6,32(%rdi, %r8)

add         $32,%r8
cmp         $480,%r8
jb          _loop5

add         $512,%rdi
add         $32,%rsi
add         $512,%r9
cmp         $1536,%r9
jb          _loop_poly_short_outer

ret



.global poly_short5_m1
poly_short5_m1:
vmovdqa		_16x1(%rip),%ymm0

xor         %r9,%r9

_loop_poly_short_m1_outer:
vmovdqu  	(%rsi),%ymm2
vmovdqu  	48(%rsi),%ymm3

//g1 - g2
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm6
vmovdqa     %ymm6,(%rdi)

xor         %r8,%r8
.p2align 5
_loop_poly_short_m1_inner:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm6
vmovdqa     %ymm6,32(%rdi, %r8)

add         $32,%r8
cmp         $480,%r8
jb          _loop_poly_short_m1_inner

add         $512,%rdi
add         $32,%rsi
add         $512,%r9
cmp         $1024,%r9
jb          _loop_poly_short_m1_outer

ret
*/