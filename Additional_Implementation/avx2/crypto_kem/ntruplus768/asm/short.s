.global poly_cbd1
poly_cbd1:
vmovdqa		_16x1(%rip),%ymm0
xor		%eax,%eax
.p2align 5
_looptop1:
vmovdqu  	  (%rsi),%ymm1
vmovdqu  	96(%rsi),%ymm2

#1
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
add		$512,%eax
cmp		$1536,%eax
jb		_looptop1

ret

.global poly_cbd1_m1
poly_cbd1_m1:
vmovdqa		_16x1(%rip),%ymm0
xor		%eax,%eax
.p2align 5
_looptop2:
vmovdqu  	  (%rsi),%ymm1
vmovdqu  	64(%rsi),%ymm2

#1
vpand       %ymm0,%ymm1,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpsubw      %ymm4,%ymm3,%ymm5
vmovdqa     %ymm5,(%rdi)

xor         %r8,%r8
_loop2:
vpsrld		$1,%ymm1,%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm1,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpsubw      %ymm4,%ymm3,%ymm5
vmovdqa     %ymm5,32(%rdi, %r8)

add         $32,%r8
cmp         $480,%r8
jb          _loop2

add		$32,%rsi
add		$512,%rdi
add		$512,%eax
cmp		$1024,%eax
jb		_looptop2

ret

/*

.global poly_cbd1
poly_cbd1:
xor		%rax,%rax
.p2align 5
_looptop1:
vmovdqa		_16x1(%rip),%ymm0
vmovdqa		_16x3(%rip),%ymm1
vmovdqa		_16x55(%rip),%ymm2

vmovdqu  	(%rsi),%ymm3
vmovdqu  	96(%rsi),%ymm4

vpand       %ymm2,%ymm3,%ymm5
vpsrld		$1,%ymm3,%ymm6
vpand       %ymm2,%ymm6,%ymm6

vpand       %ymm2,%ymm4,%ymm7
vpsrld		$1,%ymm4,%ymm8
vpand       %ymm2,%ymm8,%ymm8

vpaddw      %ymm2,%ymm5,%ymm5
vpsubw      %ymm7,%ymm5,%ymm5

vpaddw      %ymm2,%ymm6,%ymm6
vpsubw      %ymm8,%ymm6,%ymm6

vpand       %ymm1,%ymm5,%ymm8  #7
vpand       %ymm1,%ymm6,%ymm9  #8
vpsubw      %ymm0,%ymm8,%ymm8
vpsubw      %ymm0,%ymm9,%ymm9

vpsrlw      $2,%ymm5,%ymm5
vpsrlw      $2,%ymm6,%ymm6
vpand       %ymm1,%ymm5,%ymm10 #5
vpand       %ymm1,%ymm6,%ymm11 #6
vpsubw      %ymm0,%ymm10,%ymm10
vpsubw      %ymm0,%ymm11,%ymm11

vpsrlw      $2,%ymm5,%ymm5
vpsrlw      $2,%ymm6,%ymm6
vpand       %ymm1,%ymm5,%ymm12 #3
vpand       %ymm1,%ymm6,%ymm13 #4
vpsubw      %ymm0,%ymm12,%ymm12
vpsubw      %ymm0,%ymm13,%ymm13

vpsrlw      $2,%ymm5,%ymm5
vpsrlw      $2,%ymm6,%ymm6
vpand       %ymm1,%ymm5,%ymm14 #1
vpand       %ymm1,%ymm6,%ymm15 #2
vpsubw      %ymm0,%ymm14,%ymm14
vpsubw      %ymm0,%ymm15,%ymm15

vmovdqu     %ymm8,(%rdi)
vmovdqu     %ymm9,32(%rdi)
vmovdqu     %ymm10,64(%rdi)
vmovdqu     %ymm11,96(%rdi)
vmovdqu     %ymm12,128(%rdi)
vmovdqu     %ymm13,160(%rdi)
vmovdqu     %ymm14,192(%rdi)
vmovdqu     %ymm15,224(%rdi)

vpsrlw      $2,%ymm5,%ymm5
vpsrlw      $2,%ymm6,%ymm6
vpand       %ymm1,%ymm5,%ymm8  #7
vpand       %ymm1,%ymm6,%ymm9  #8
vpsubw      %ymm0,%ymm8,%ymm8
vpsubw      %ymm0,%ymm9,%ymm9

vpsrlw      $2,%ymm5,%ymm5
vpsrlw      $2,%ymm6,%ymm6
vpand       %ymm1,%ymm5,%ymm10 #5
vpand       %ymm1,%ymm6,%ymm11 #6
vpsubw      %ymm0,%ymm10,%ymm10
vpsubw      %ymm0,%ymm11,%ymm11

vpsrlw      $2,%ymm5,%ymm5
vpsrlw      $2,%ymm6,%ymm6
vpand       %ymm1,%ymm5,%ymm12 #3
vpand       %ymm1,%ymm6,%ymm13 #4
vpsubw      %ymm0,%ymm12,%ymm12
vpsubw      %ymm0,%ymm13,%ymm13

vpsrlw      $2,%ymm5,%ymm5
vpsrlw      $2,%ymm6,%ymm6
vpand       %ymm1,%ymm5,%ymm14 #1
vpand       %ymm1,%ymm6,%ymm15 #2
vpsubw      %ymm0,%ymm14,%ymm14
vpsubw      %ymm0,%ymm15,%ymm15

vmovdqu     %ymm8,256(%rdi)
vmovdqu     %ymm9,288(%rdi)
vmovdqu     %ymm10,320(%rdi)
vmovdqu     %ymm11,352(%rdi)
vmovdqu     %ymm12,384(%rdi)
vmovdqu     %ymm13,416(%rdi)
vmovdqu     %ymm14,448(%rdi)
vmovdqu     %ymm15,480(%rdi)


vmovdqu  	(%rdi),%ymm8
vmovdqu  	32(%rdi),%ymm9
vmovdqu  	64(%rdi),%ymm10
vmovdqu  	96(%rdi),%ymm11
vmovdqu  	128(%rdi),%ymm12
vmovdqu  	160(%rdi),%ymm13
vmovdqu  	192(%rdi),%ymm14
vmovdqu  	224(%rdi),%ymm15



#blend
vpunpcklbw %ymm9,%ymm8,%ymm0
vpunpckhbw %ymm9,%ymm8,%ymm1 
vpunpcklbw %ymm11,%ymm10,%ymm2
vpunpckhbw %ymm11,%ymm10,%ymm3 
vpunpcklbw %ymm13,%ymm12,%ymm4
vpunpckhbw %ymm13,%ymm12,%ymm5 
vpunpcklbw %ymm15,%ymm14,%ymm6
vpunpckhbw %ymm15,%ymm14,%ymm7 

vpunpcklwd  %ymm2,%ymm0,%ymm8
vpunpcklwd  %ymm6,%ymm4,%ymm9
vpunpcklwd  %ymm3,%ymm1,%ymm10
vpunpcklwd  %ymm7,%ymm5,%ymm11
vpunpckhwd  %ymm2,%ymm0,%ymm12
vpunpckhwd  %ymm6,%ymm4,%ymm13
vpunpckhwd  %ymm3,%ymm1,%ymm14
vpunpckhwd  %ymm7,%ymm5,%ymm15

vpunpckldq %ymm9,%ymm8,%ymm0
vpunpckldq %ymm11,%ymm10,%ymm1
vpunpckldq %ymm13,%ymm12,%ymm2
vpunpckldq %ymm15,%ymm14,%ymm3
vpunpckhdq %ymm9,%ymm8,%ymm4
vpunpckhdq %ymm11,%ymm10,%ymm5
vpunpckhdq %ymm13,%ymm12,%ymm6
vpunpckhdq %ymm15,%ymm14,%ymm7
 
vperm2i128	$0x20,%ymm4,%ymm0,%ymm8
vperm2i128	$0x31,%ymm4,%ymm0,%ymm12
vperm2i128	$0x20,%ymm5,%ymm1,%ymm10
vperm2i128	$0x31,%ymm5,%ymm1,%ymm14
vperm2i128	$0x20,%ymm6,%ymm2,%ymm9
vperm2i128	$0x31,%ymm6,%ymm2,%ymm13
vperm2i128	$0x20,%ymm7,%ymm3,%ymm11
vperm2i128	$0x31,%ymm7,%ymm3,%ymm15

vmovdqu     %ymm8,(%rdi)
vmovdqu     %ymm9,32(%rdi)
vmovdqu     %ymm10,64(%rdi)
vmovdqu     %ymm11,96(%rdi)
vmovdqu     %ymm12,128(%rdi)
vmovdqu     %ymm13,160(%rdi)
vmovdqu     %ymm14,192(%rdi)
vmovdqu     %ymm15,224(%rdi)



vmovdqu  	256(%rdi),%ymm8
vmovdqu  	288(%rdi),%ymm9
vmovdqu  	320(%rdi),%ymm10
vmovdqu  	352(%rdi),%ymm11
vmovdqu  	384(%rdi),%ymm12
vmovdqu  	416(%rdi),%ymm13
vmovdqu  	448(%rdi),%ymm14
vmovdqu  	480(%rdi),%ymm15



#blend
vpunpcklbw %ymm9,%ymm8,%ymm0
vpunpckhbw %ymm9,%ymm8,%ymm1 
vpunpcklbw %ymm11,%ymm10,%ymm2
vpunpckhbw %ymm11,%ymm10,%ymm3 
vpunpcklbw %ymm13,%ymm12,%ymm4
vpunpckhbw %ymm13,%ymm12,%ymm5 
vpunpcklbw %ymm15,%ymm14,%ymm6
vpunpckhbw %ymm15,%ymm14,%ymm7 

vpunpcklwd  %ymm2,%ymm0,%ymm8
vpunpcklwd  %ymm6,%ymm4,%ymm9
vpunpcklwd  %ymm3,%ymm1,%ymm10
vpunpcklwd  %ymm7,%ymm5,%ymm11
vpunpckhwd  %ymm2,%ymm0,%ymm12
vpunpckhwd  %ymm6,%ymm4,%ymm13
vpunpckhwd  %ymm3,%ymm1,%ymm14
vpunpckhwd  %ymm7,%ymm5,%ymm15

vpunpckldq %ymm9,%ymm8,%ymm0
vpunpckldq %ymm11,%ymm10,%ymm1
vpunpckldq %ymm13,%ymm12,%ymm2
vpunpckldq %ymm15,%ymm14,%ymm3
vpunpckhdq %ymm9,%ymm8,%ymm4
vpunpckhdq %ymm11,%ymm10,%ymm5
vpunpckhdq %ymm13,%ymm12,%ymm6
vpunpckhdq %ymm15,%ymm14,%ymm7
 
vperm2i128	$0x20,%ymm4,%ymm0,%ymm8
vperm2i128	$0x31,%ymm4,%ymm0,%ymm12
vperm2i128	$0x20,%ymm5,%ymm1,%ymm10
vperm2i128	$0x31,%ymm5,%ymm1,%ymm14
vperm2i128	$0x20,%ymm6,%ymm2,%ymm9
vperm2i128	$0x31,%ymm6,%ymm2,%ymm13
vperm2i128	$0x20,%ymm7,%ymm3,%ymm11
vperm2i128	$0x31,%ymm7,%ymm3,%ymm15

vmovdqu     %ymm8,256(%rdi)
vmovdqu     %ymm9,288(%rdi)
vmovdqu     %ymm10,320(%rdi)
vmovdqu     %ymm11,352(%rdi)
vmovdqu     %ymm12,384(%rdi)
vmovdqu     %ymm13,416(%rdi)
vmovdqu     %ymm14,448(%rdi)
vmovdqu     %ymm15,480(%rdi)


add		$32,%rsi
add		$512,%rdi
add		$256,%rax
cmp		$768,%rax
jb		_looptop1

ret


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