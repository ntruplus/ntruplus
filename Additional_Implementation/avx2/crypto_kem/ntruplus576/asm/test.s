.global test
test:

vmovdqu		(%rsi),%ymm11

#check for invertibility
vpxor		%ymm4,%ymm4,%ymm4
vpcmpeqw	%ymm4,%ymm11,%ymm11
vperm2i128	$0x10,%ymm11,%ymm11,%ymm3
por	    	%xmm3,%xmm11
vpshufd		$0x0E,%xmm11,%xmm3 
por		    %xmm3,%xmm11
vpextrq		$0,%xmm11,%r10

mov		%r10,%rax

vmovdqu		%xmm11,(%rdi)


ret
