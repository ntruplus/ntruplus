.global test_function
test_function:
vmovdqu  	(%rsi),%ymm0
vmovdqu  	32(%rsi),%ymm1
vmovdqu  	64(%rsi),%ymm2
vmovdqu  	96(%rsi),%ymm3
vmovdqu  	128(%rsi),%ymm4
vmovdqu  	160(%rsi),%ymm5
vmovdqu  	192(%rsi),%ymm6
vmovdqu  	224(%rsi),%ymm7

vpunpcklbw %ymm1,%ymm0,%ymm8
vpunpckhbw %ymm1,%ymm0,%ymm9 
vpunpcklbw %ymm3,%ymm2,%ymm10
vpunpckhbw %ymm3,%ymm2,%ymm11 
vpunpcklbw %ymm5,%ymm4,%ymm12
vpunpckhbw %ymm5,%ymm4,%ymm13 
vpunpcklbw %ymm7,%ymm6,%ymm14
vpunpckhbw %ymm7,%ymm6,%ymm15 

vpunpcklwd  %ymm10,%ymm8,%ymm0
vpunpcklwd  %ymm14,%ymm12,%ymm1
vpunpcklwd  %ymm11,%ymm9,%ymm2
vpunpcklwd  %ymm15,%ymm13,%ymm3
vpunpckhwd  %ymm10,%ymm8,%ymm4
vpunpckhwd  %ymm14,%ymm12,%ymm5
vpunpckhwd  %ymm11,%ymm9,%ymm6
vpunpckhwd  %ymm15,%ymm13,%ymm7

vpunpckldq %ymm1,%ymm0,%ymm8
vpunpckldq %ymm3,%ymm2,%ymm9
vpunpckldq %ymm5,%ymm4,%ymm10
vpunpckldq %ymm7,%ymm6,%ymm11
vpunpckhdq %ymm1,%ymm0,%ymm12
vpunpckhdq %ymm3,%ymm2,%ymm13
vpunpckhdq %ymm5,%ymm4,%ymm14
vpunpckhdq %ymm7,%ymm6,%ymm15
 
vperm2i128	$0x20,%ymm12,%ymm8,%ymm0
vperm2i128	$0x31,%ymm12,%ymm8,%ymm4
vperm2i128	$0x20,%ymm13,%ymm9,%ymm2
vperm2i128	$0x31,%ymm13,%ymm9,%ymm6
vperm2i128	$0x20,%ymm14,%ymm10,%ymm1
vperm2i128	$0x31,%ymm14,%ymm10,%ymm5
vperm2i128	$0x20,%ymm15,%ymm11,%ymm3
vperm2i128	$0x31,%ymm15,%ymm11,%ymm7
/*
vpunpckldq %ymm3,%ymm2,%ymm9
vpunpckldq %ymm5,%ymm4,%ymm10
vpunpckldq %ymm7,%ymm6,%ymm11

vpunpckhdq %ymm1,%ymm0,%ymm12
vpunpckhdq %ymm3,%ymm2,%ymm13
vpunpckhdq %ymm5,%ymm4,%ymm14
vpunpckhdq %ymm7,%ymm6,%ymm15
*/
/*
vmovdqu     %ymm8,(%rdi)
vmovdqu     %ymm9,32(%rdi)
vmovdqu     %ymm10,64(%rdi)
vmovdqu     %ymm11,96(%rdi)
vmovdqu     %ymm12,128(%rdi)
vmovdqu     %ymm13,160(%rdi)
vmovdqu     %ymm14,192(%rdi)
vmovdqu     %ymm15,224(%rdi)
*/
vmovdqu     %ymm0,(%rdi)
vmovdqu     %ymm1,32(%rdi)
vmovdqu     %ymm2,64(%rdi)
vmovdqu     %ymm3,96(%rdi)
vmovdqu     %ymm4,128(%rdi)
vmovdqu     %ymm5,160(%rdi)
vmovdqu     %ymm6,192(%rdi)
vmovdqu     %ymm7,224(%rdi)

ret
