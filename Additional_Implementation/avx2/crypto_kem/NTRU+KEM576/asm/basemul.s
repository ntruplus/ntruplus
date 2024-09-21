.global poly_basemul
poly_basemul:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa	 _16xqinv(%rip),%ymm15
lea     zetas_mul(%rip),%rcx

xor		%rax,%rax
.p2align 5
_looptop_basemul:
#load
vmovdqa		96(%rsi),%ymm1 # a[3]
vmovdqa		64(%rsi),%ymm3 # a[2]
vmovdqa		96(%rdx),%ymm5 # b[3]
vmovdqa		64(%rdx),%ymm6 # b[2]

#premul
vpmullw		%ymm15,%ymm1,%ymm2
vpmullw		%ymm15,%ymm3,%ymm4

#mul
vpmullw		%ymm2,%ymm6,%ymm7   # a[3]*b[2]
vpmullw		%ymm4,%ymm5,%ymm8   # a[2]*b[3]
vpmullw		%ymm4,%ymm6,%ymm9   # a[2]*b[2]
vpmulhw		%ymm1,%ymm6,%ymm10  # a[3]*b[2]
vpmulhw		%ymm3,%ymm5,%ymm11  # a[2]*b[3]
vpmulhw		%ymm3,%ymm6,%ymm12  # a[2]*b[2]

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm10  # a[3]*b[2]
vpsubw		%ymm8,%ymm11,%ymm11  # a[2]*b[3]
vpsubw		%ymm9,%ymm12,%ymm14  # a[2]*b[2] = c[0]

#add
vpaddw      %ymm10,%ymm11,%ymm13 # a[2]*b[3] + a[3]*b[2] = c[1]

#load
vmovdqa		32(%rsi),%ymm3 # a[1]
vmovdqa		32(%rdx),%ymm6 # b[1]

#premul
vpmullw		%ymm15,%ymm3,%ymm4

#mul
vpmullw		%ymm2,%ymm6,%ymm7   # a[3]*b[1]
vpmullw		%ymm4,%ymm5,%ymm8   # a[1]*b[3]
vpmullw		%ymm2,%ymm5,%ymm9   # a[3]*b[3]
vpmulhw		%ymm1,%ymm6,%ymm10  # a[3]*b[1]
vpmulhw		%ymm3,%ymm5,%ymm11  # a[1]*b[3]
vpmulhw		%ymm1,%ymm5,%ymm12  # a[3]*b[3]

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm10 # a[3]*b[1]
vpsubw		%ymm8,%ymm11,%ymm11 # a[1]*b[3]
vpsubw		%ymm9,%ymm12,%ymm12 # a[3]*b[3]

#add
vpaddw      %ymm10,%ymm14,%ymm14 # c[0]
vpaddw      %ymm11,%ymm14,%ymm14 # c[0]

#load zeta
vmovdqa		  (%rcx),%ymm1
vmovdqa		32(%rcx),%ymm2

#mul
vpmullw		%ymm1,%ymm14,%ymm9
vpmullw		%ymm1,%ymm13,%ymm10
vpmullw		%ymm1,%ymm12,%ymm11
vpmulhw		%ymm2,%ymm14,%ymm5
vpmulhw		%ymm2,%ymm13,%ymm7
vpmulhw		%ymm2,%ymm12,%ymm8

#reduce
vpmulhw		%ymm0,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm9,%ymm5,%ymm5
vpsubw		%ymm10,%ymm7,%ymm7
vpsubw		%ymm11,%ymm8,%ymm8

#store
vmovdqa		%ymm5,  (%rdi)
vmovdqa		%ymm7,32(%rdi)
vmovdqa		%ymm8,64(%rdi)

#load
vmovdqa		(%rsi),%ymm1 # a[0]
vmovdqa	    (%rdx),%ymm5 # b[0]

#premul
vpmullw		%ymm15,%ymm1,%ymm2

#mul
vpmullw		%ymm2,%ymm6,%ymm7   # a[0]*b[1]
vpmullw		%ymm4,%ymm5,%ymm8   # a[1]*b[0]
vpmullw		%ymm4,%ymm6,%ymm9   # a[1]*b[1]
vpmulhw		%ymm1,%ymm6,%ymm10  # a[0]*b[1]
vpmulhw		%ymm3,%ymm5,%ymm11  # a[1]*b[0]
vpmulhw		%ymm3,%ymm6,%ymm12  # a[1]*b[1]

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm10  # a[0]*b[1]
vpsubw		%ymm8,%ymm11,%ymm11  # a[1]*b[0]
vpsubw		%ymm9,%ymm12,%ymm14  # a[1]*b[1] = c[2]

#add
vpaddw      %ymm10,%ymm11,%ymm13 # a[0]*b[1] + a[1]*b[0] = c[1]

#load
vmovdqa		  64(%rsi),%ymm3 # a[2]
vmovdqa		  64(%rdx),%ymm6 # b[2]

#premul
vpmullw		%ymm15,%ymm3,%ymm4

#mul
vpmullw		%ymm2,%ymm6,%ymm7   # a[0]*b[2]
vpmullw		%ymm4,%ymm5,%ymm8   # a[2]*b[0]
vpmullw		%ymm2,%ymm5,%ymm9   # a[0]*b[0]
vpmulhw		%ymm1,%ymm6,%ymm10  # a[0]*b[2]
vpmulhw		%ymm3,%ymm5,%ymm11  # a[2]*b[0]
vpmulhw		%ymm1,%ymm5,%ymm12  # a[0]*b[0]

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm10 # a[0]*b[2]
vpsubw		%ymm8,%ymm11,%ymm11 # a[2]*b[0]
vpsubw		%ymm9,%ymm12,%ymm12 # a[0]*b[0] = c[0]

#add
vpaddw      %ymm10,%ymm14,%ymm14 # c[2]
vpaddw      %ymm11,%ymm14,%ymm14 # c[2]

#load
vmovdqa		  (%rdi),%ymm7 # c[0]
vmovdqa		32(%rdi),%ymm8 # c[1]
vmovdqa		64(%rdi),%ymm9 # c[2]

#add
vpaddw      %ymm7,%ymm12,%ymm7 # c[0]
vpaddw      %ymm8,%ymm13,%ymm8 # c[1]
vpaddw      %ymm9,%ymm14,%ymm9 # c[2]

#store
vmovdqa		%ymm7,  (%rdi)
vmovdqa		%ymm8,32(%rdi)
vmovdqa		%ymm9,64(%rdi)

#load
vmovdqa	    32(%rdx),%ymm5 # b[1]
vmovdqa		96(%rdx),%ymm6 # b[3]

#mul
vpmullw		%ymm2,%ymm6,%ymm7   # a[0]*b[3]
vpmullw		%ymm4,%ymm5,%ymm8   # a[2]*b[1]
vpmulhw		%ymm1,%ymm6,%ymm9   # a[0]*b[3]
vpmulhw		%ymm3,%ymm5,%ymm10  # a[2]*b[1]

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpsubw		%ymm7,%ymm9,%ymm9    # a[0]*b[3]
vpsubw		%ymm8,%ymm10,%ymm10  # a[2]*b[1]

#add
vpaddw      %ymm9,%ymm10,%ymm11 # a[0]*b[3] + a[3]*b[0] = c[3]

#load
vmovdqa		32(%rsi),%ymm1 # a[1]
vmovdqa		96(%rsi),%ymm3 # a[3]
vmovdqa	      (%rdx),%ymm5 # b[0]
vmovdqa		64(%rdx),%ymm6 # b[2]

#premul
vpmullw		%ymm15,%ymm1,%ymm2
vpmullw		%ymm15,%ymm3,%ymm4

#mul
vpmullw		%ymm2,%ymm6,%ymm7   # a[1]*b[2]
vpmullw		%ymm4,%ymm5,%ymm8   # a[3]*b[0]
vpmulhw		%ymm1,%ymm6,%ymm9   # a[1]*b[2]
vpmulhw		%ymm3,%ymm5,%ymm10  # a[3]*b[0]

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpsubw		%ymm7,%ymm9,%ymm9    # a[1]*b[2]
vpsubw		%ymm8,%ymm10,%ymm10  # a[3]*b[0]

#add
vpaddw      %ymm9,%ymm11,%ymm11
vpaddw      %ymm10,%ymm11,%ymm11

#store
vmovdqa		%ymm11,96(%rdi) # c[3]

add     $64,%rcx
add		$128,%rsi
add		$128,%rdx
add		$128,%rdi
add		$128,%rax
cmp		$1152,%rax
jb		_looptop_basemul

ret
