.global poly_baseinv
poly_baseinv:
mov             %rsp,%r11
and             $31,%r11
add             $32,%r11
sub             %r11,%rsp

vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xqinv(%rip),%ymm1

lea		zetas_mul_exp(%rip),%rdx
xor		%rcx,%rcx
xor		%rax,%rax
.p2align 5
_looptop:
#load
vmovdqa		(%rsi),%ymm3    #a[0]
vmovdqa		32(%rsi),%ymm5  #a[1]

#premul
vpmullw		%ymm1,%ymm3,%ymm2 #a0
vpmullw		%ymm1,%ymm5,%ymm4 #a1

#mul
vpmullw		%ymm2,%ymm3,%ymm12 #a0*a0
vpmullw		%ymm4,%ymm5,%ymm14 #a1*a1
vpmulhw		%ymm3,%ymm3,%ymm13 #a0*a0
vpmulhw		%ymm5,%ymm5,%ymm15 #a1*a1

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #a0*a0
vpmulhw		%ymm0,%ymm14,%ymm14  #a1*a1
vpsubw		%ymm12,%ymm13,%ymm10 #a0*a0
vpsubw		%ymm14,%ymm15,%ymm11 #a1*a1

#load
vmovdqu		(%rdx),%ymm14   #zqinv
vmovdqu		32(%rdx),%ymm15 #z

#mul
vpmullw		%ymm14,%ymm11,%ymm14 #a1*a1z
vpmulhw		%ymm15,%ymm11,%ymm15 #a1*a1z

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14  #a1*a1z
vpsubw		%ymm14,%ymm15,%ymm11 #a1*a1z

#a0*a0 - a1*a1z
vpsubw		%ymm11,%ymm10,%ymm10 #determinant

#reduce2
vmovdqa		_low_mask(%rip),%ymm15
vpsraw		$12,%ymm10,%ymm6
vpand		%ymm15,%ymm10,%ymm10
vpsubw		%ymm6,%ymm10,%ymm10
vpsllw		$7,%ymm6,%ymm6
vpsubw		%ymm6,%ymm10,%ymm10
vpsllw		$1,%ymm6,%ymm6
vpsubw		%ymm6,%ymm10,%ymm10
vpsllw		$2,%ymm6,%ymm6
vpaddw		%ymm6,%ymm10,%ymm10

#inverse of determinants
vmovdqa %ymm10, %ymm11

#i = 1, t^2
vpmullw     %ymm1,%ymm11,%ymm6
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i = 2
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=3
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=4
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=5
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=6
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=7
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=8
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=9
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=10
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=11
vpmullw     %ymm1,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#divide by determinant
#Q-a[1]
vpsubw      %ymm5,%ymm0,%ymm5

#premul
vpmullw		%ymm1,%ymm11,%ymm10

#mul
vpmullw		%ymm10,%ymm3,%ymm12
vpmullw		%ymm10,%ymm5,%ymm13
vpmulhw		%ymm11,%ymm3,%ymm14
vpmulhw		%ymm11,%ymm5,%ymm15

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm12,%ymm14,%ymm4
vpsubw		%ymm13,%ymm15,%ymm5

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)

#check for invertibility
vpxor		%ymm15,%ymm15,%ymm15
vpcmpeqw	%ymm15,%ymm11,%ymm11
vperm2i128	$0x10,%ymm11,%ymm11,%ymm3
por	    	%xmm3,%xmm11
vpshufd		$0x0E,%xmm11,%xmm3
por		    %xmm3,%xmm11
vpextrq		$0,%xmm11,%r10
or		    %r10,%rcx

add		$64,%rdi
add		$64,%rsi
add		$64,%rdx
add		$32,%rax
cmp		$768,%rax
jb		_looptop

add     %r11,%rsp
mov		%rcx,%rax
ret
