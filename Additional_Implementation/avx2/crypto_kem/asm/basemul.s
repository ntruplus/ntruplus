.global poly_basemul
poly_basemul:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xqinv(%rip),%ymm1
lea		zetas_mul_exp(%rip),%rcx

xor		%rax,%rax

.p2align 5
_looptop:
vmovdqa		(%rcx),%ymm2   #zqinv
vmovdqa		32(%rcx),%ymm3 #z
vmovdqa		(%rsi),%ymm4    #a0
vmovdqa		32(%rsi),%ymm5  #a1
vmovdqa		(%rdx),%ymm6    #b0
vmovdqa		32(%rdx),%ymm7  #b1

#add
vpaddw		%ymm5,%ymm4,%ymm8 #a0+a1
vpaddw		%ymm7,%ymm6,%ymm9 #b0+b1

#premul
vpmullw		%ymm1,%ymm6,%ymm13 #b0qinv
vpmullw		%ymm1,%ymm7,%ymm14 #b1qinv
vpmullw		%ymm1,%ymm9,%ymm15 #(a0+a1)(b0+b1)qinv

#mul (a0+a1) * (b0+b1)
vpmullw		%ymm13,%ymm4,%ymm13 #a0 b0
vpmullw		%ymm14,%ymm5,%ymm14 #a1 b1
vpmullw		%ymm15,%ymm8,%ymm15 #(a0+a1)(b0+b1)
vpmulhw		%ymm6,%ymm4,%ymm10  #a0 b0
vpmulhw		%ymm7,%ymm5,%ymm11  #a1 b1
vpmulhw		%ymm9,%ymm8,%ymm12  #(a0+a1)(b0+b1)

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13  #a0 b0
vpmulhw		%ymm0,%ymm14,%ymm14  #a1 b1
vpmulhw		%ymm0,%ymm15,%ymm15  #(a0+a1)(b0+b1)
vpsubw		%ymm13,%ymm10,%ymm10 #a0 b0
vpsubw		%ymm14,%ymm11,%ymm11 #a1 b1
vpsubw		%ymm15,%ymm12,%ymm12 #(a0+a1)(b0+b1)

#c1
#update
vpaddw		%ymm11,%ymm10,%ymm13
vpsubw		%ymm13,%ymm12,%ymm5

#c0
#mul
vpmullw		%ymm2,%ymm11,%ymm2  #a1b1zeta
vpmulhw		%ymm3,%ymm11,%ymm3  #a1b1zeta

#reduce
vpmulhw		%ymm0,%ymm2,%ymm2  #a1b1zeta
vpsubw		%ymm2,%ymm3,%ymm2  #a1b1zeta

#update
vpaddw		%ymm2,%ymm10,%ymm4

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)

add		$64,%rcx
add		$64,%rsi
add		$64,%rdx
add		$64,%rdi
add		$64,%rax
cmp		$1536,%rax
jb		_looptop

ret
