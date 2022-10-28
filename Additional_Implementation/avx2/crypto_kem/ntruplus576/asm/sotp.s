/*
.global sotp_internal
sotp_internal:
vmovdqa		_16x1(%rip),%ymm0
vmovdqu     (%rsi),%ymm1
vmovdqu     (%rdx),%ymm2
vmovdqu     32(%rdx),%ymm3

#msg xor g1
vpxor       %ymm2,%ymm1,%ymm2

#(msg xor g1) - g2
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm6
vmovdqa     %ymm6,1024(%rdi)

xor         %r8,%r8
_loop_sotp_internal:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm6
vmovdqa     %ymm6,1056(%rdi, %r8)

add         $32,%r8
cmp         $480,%r8
jb          _loop_sotp_internal

ret


.global sotp_inv_internal
sotp_inv_internal:
vmovdqa		_16x1(%rip),%ymm0
vmovdqa		_8x1(%rip),%ymm4
vmovdqa		_8x1(%rip),%ymm5

vmovdqu     1024(%rsi),%ymm1
vmovdqu     32(%rdx),%ymm2

vpand       %ymm0,%ymm2,%ymm3
vpaddw	    %ymm3,%ymm1,%ymm15

xor         %r8,%r8
_loop4:
vmovdqa     1056(%rsi, %r8),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpsllvd		%ymm4,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vpaddw      %ymm5,%ymm4,%ymm4
add         $32,%r8
cmp         $480,%r8
jb          _loop4

vmovdqu     (%rdx),%ymm0
vpxor       %ymm15,%ymm0,%ymm0
vmovdqu     %ymm0,(%rdi)

ret
*/
