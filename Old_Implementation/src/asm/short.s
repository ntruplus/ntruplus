.global psi_1_n
psi_1_n:

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

.global psi_1_n_lambda
psi_1_n_lambda:
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
