.global sotp_internal
sotp_internal:
vmovdqa		_16x1(%rip),%ymm0

vmovdqu     (%rsi),%ymm1
vmovdqu     (%rdx),%ymm2
vmovdqu     32(%rdx),%ymm3

//msg xor g1
vpxor       %ymm2,%ymm1,%ymm2

//(msg xor g1) - g2
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm6
vmovdqa     %ymm6,1024(%rdi)

xor         %r8,%r8
.p2align 5
_loop3:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm6
vmovdqa     %ymm6,1056(%rdi, %r8)

add         $32,%r8
cmp         $480,%r8
jb          _loop3

ret

.global sotp_inv_internal
sotp_inv_internal:
vmovdqa		_16x1(%rip),%ymm0

vmovdqu     1024(%rsi),%ymm1
vmovdqu     32(%rdx),%ymm2

vpand       %ymm0,%ymm2,%ymm3
vpaddw	    %ymm3,%ymm1,%ymm15

vmovdqa     1056(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$1,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1088(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$2,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1120(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$3,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1152(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$4,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1184(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$5,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1216(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$6,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1248(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$7,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1280(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$8,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1312(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$9,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1344(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$10,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1376(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$11,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1408(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$12,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1440(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$13,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1472(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$14,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqa     1504(%rsi),%ymm1
vpsrld		$1,%ymm2,%ymm2
vpand       %ymm0,%ymm2,%ymm3
vpaddw      %ymm3,%ymm1,%ymm14
vpslld		$15,%ymm14,%ymm14
vpaddw      %ymm14,%ymm15,%ymm15

vmovdqu     (%rdx),%ymm0

vpxor       %ymm15,%ymm0,%ymm0
vmovdqu     %ymm0,(%rdi)

ret
