.global poly_baseinv
poly_baseinv:
vmovdqa    _16xq(%rip), %ymm0
vmovdqa _16xqinv(%rip), %ymm15
lea        zetas(%rip), %rdx
add              $1888, %rdx

sub $192, %rsp

lea 1728(%rdi), %r8

.p2align 5
_looptop:
lea 576(%rdi), %r9

mov %rsp, %r10

.p2align 5
_loop_inner1:
#zeta
vmovdqa   (%rdx), %ymm14
vmovdqa 32(%rdx), %ymm1

#load
vmovdqa   (%rsi), %ymm3
vmovdqa 32(%rsi), %ymm5
vmovdqa 64(%rsi), %ymm7

#premul
vpmullw %ymm15, %ymm3, %ymm2
vpmullw %ymm15, %ymm5, %ymm4
vpmullw %ymm15, %ymm7, %ymm6

#mul
vpmullw %ymm5, %ymm14, %ymm8  #zeta a[1]
vpmullw %ymm7, %ymm14, %ymm10 #zeta a[2]
vpmullw %ymm7, %ymm2,  %ymm12 #a[0] a[2]
vpmullw %ymm5, %ymm4,  %ymm14 #a[1] a[1]
vpmulhw %ymm5, %ymm1, %ymm9 
vpmulhw %ymm7, %ymm1, %ymm11
vpmulhw %ymm7, %ymm3,  %ymm13
vpmulhw %ymm5, %ymm5,  %ymm1

#reduce
vpmulhw %ymm0,  %ymm8,  %ymm8
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm8,  %ymm9,  %ymm8
vpsubw  %ymm10, %ymm11, %ymm9
vpsubw  %ymm12, %ymm13, %ymm10
vpsubw  %ymm14, %ymm1, %ymm11

#add
vpsubw %ymm10, %ymm11, %ymm10 #r[2] = a[1] a[1] - a[0] a[2]

#mul
vpmullw %ymm3, %ymm2, %ymm11 #a[0] a[0]
vpmullw %ymm9, %ymm4, %ymm13 #zeta a[2] a[1]
vpmullw %ymm9, %ymm6, %ymm6  #zeta a[2] a[2]
vpmullw %ymm5, %ymm2, %ymm4  #a[1] a[0]
vpmulhw %ymm3, %ymm3, %ymm12
vpmulhw %ymm9, %ymm5, %ymm14
vpmulhw %ymm9, %ymm7, %ymm7
vpmulhw %ymm5, %ymm3, %ymm5

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11 #a[0] a[0]
vpmulhw %ymm0,  %ymm13, %ymm13 #zeta a[2] a[1]
vpmulhw %ymm0,  %ymm6,  %ymm6  #zeta a[2] a[2]
vpmulhw %ymm0,  %ymm4,  %ymm4  #a[1] a[0]
vpsubw  %ymm11, %ymm12, %ymm11 #a[0] a[0]
vpsubw  %ymm13, %ymm14, %ymm12 #zeta a[2] a[1]
vpsubw  %ymm6,  %ymm7,  %ymm6  #zeta a[2] a[2]
vpsubw  %ymm4,  %ymm5,  %ymm7  #a[1] a[0]

#add
vpsubw %ymm12, %ymm11, %ymm11 #r[0] = a[0] a[0] - zeta a[2] a[1]
vpsubw %ymm7,  %ymm6,  %ymm6  #r[1] = zeta a[2] a[2] - a[1] a[0]

#premul
vpmullw %ymm15, %ymm8, %ymm1 #premul a[1] zeta 
vpmullw %ymm15, %ymm9, %ymm13 #premul a[2] zeta 

#mul 3
vpmullw %ymm10, %ymm1, %ymm12 #r[2] * a[1] zeta 
vpmullw %ymm6,  %ymm13, %ymm14 #r[1] * a[2] zeta 
vpmullw %ymm11, %ymm2,  %ymm4  #r[0] * a[0]
vpmulhw %ymm10, %ymm8,  %ymm13
vpmulhw %ymm6,  %ymm9,  %ymm1
vpmulhw %ymm11, %ymm3,  %ymm5

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm1, %ymm13
vpsubw  %ymm4,  %ymm5,  %ymm14

#add
vpaddw %ymm12, %ymm13, %ymm12
vpaddw %ymm12, %ymm14, %ymm8

#store
vmovdqa %ymm11,   (%rdi)
vmovdqa %ymm6,  32(%rdi)
vmovdqa %ymm10, 64(%rdi)

vmovdqu %ymm8, (%r10)
add $32, %r10

#negative zeta
#load
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm5
vmovdqa 160(%rsi), %ymm7
vmovdqa    (%rdx), %ymm14
vmovdqa  32(%rdx), %ymm1

#premul
vpmullw %ymm15, %ymm3, %ymm2
vpmullw %ymm15, %ymm5, %ymm4
vpmullw %ymm15, %ymm7, %ymm6

#mul 1
vpmullw %ymm5, %ymm14, %ymm8
vpmullw %ymm7, %ymm14, %ymm10
vpmullw %ymm7, %ymm2,  %ymm12
vpmullw %ymm5, %ymm4,  %ymm14
vpmulhw %ymm5, %ymm1, %ymm9
vpmulhw %ymm7, %ymm1, %ymm11
vpmulhw %ymm7, %ymm3,  %ymm13
vpmulhw %ymm5, %ymm5,  %ymm1

#reduce
vpmulhw %ymm0,  %ymm8,  %ymm8
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm8,  %ymm9,  %ymm8
vpsubw  %ymm10, %ymm11, %ymm9
vpsubw  %ymm12, %ymm13, %ymm10
vpsubw  %ymm14, %ymm1, %ymm11

#add
vpsubw %ymm10, %ymm11, %ymm10

#mul 2
vpmullw %ymm3, %ymm2, %ymm11
vpmullw %ymm9, %ymm4, %ymm13
vpmullw %ymm9, %ymm6, %ymm6
vpmullw %ymm5, %ymm2, %ymm4
vpmulhw %ymm3, %ymm3, %ymm12
vpmulhw %ymm9, %ymm5, %ymm14
vpmulhw %ymm9, %ymm7, %ymm7
vpmulhw %ymm5, %ymm3, %ymm5
vpmullw %ymm15, %ymm8, %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm6,  %ymm6
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm11, %ymm12, %ymm11
vpsubw  %ymm13, %ymm14, %ymm12
vpmullw %ymm15,  %ymm9,  %ymm13
vpsubw  %ymm6,  %ymm7,  %ymm6
vpsubw  %ymm4,  %ymm5,  %ymm7

#add
vpaddw %ymm12, %ymm11, %ymm11
vpaddw %ymm7,  %ymm6,  %ymm6
vpsubw %ymm6,  %ymm0,  %ymm6

#mul 3
vpmullw %ymm10, %ymm1, %ymm12
vpmullw %ymm6,  %ymm13, %ymm14
vpmullw %ymm11, %ymm2,  %ymm4
vpmulhw %ymm10, %ymm8,  %ymm13
vpmulhw %ymm6,  %ymm9,  %ymm1
vpmulhw %ymm11, %ymm3,  %ymm5

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm1, %ymm13
vpsubw  %ymm4,  %ymm5,  %ymm14

#add
vpaddw %ymm12, %ymm13, %ymm12
vpsubw %ymm12, %ymm14, %ymm8

#store
vmovdqa %ymm11,  96(%rdi)
vmovdqa %ymm6,  128(%rdi)
vmovdqa %ymm10, 160(%rdi)

vmovdqu %ymm8, (%r10)
add $32, %r10

add $64,  %rdx
add $192, %rdi
add $192, %rsi
cmp %r9,  %rdi
jb  _loop_inner1

sub $576, %rdi

mov %rsp, %r10

lea 576(%rdi), %r9

.p2align 5
_loop_inner2:
vmovdqu   (%r10), %ymm1
vmovdqu 32(%r10), %ymm2
vmovdqu 64(%r10), %ymm3
add          $96, %r10

#t1 = fqmul(a, a); //10
#mul
vpmullw %ymm1,  %ymm1,  %ymm12
vpmullw %ymm2,  %ymm2,  %ymm13
vpmullw %ymm3,  %ymm3,  %ymm14
vpmulhw %ymm1,  %ymm1,  %ymm4
vpmulhw %ymm2,  %ymm2,  %ymm5
vpmulhw %ymm3,  %ymm3,  %ymm6
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm4, %ymm4  
vpsubw  %ymm13, %ymm5, %ymm5  
vpsubw  %ymm14, %ymm6, %ymm6  

#check for invertibility
vpxor    %ymm11, %ymm11, %ymm11
vpcmpeqw %ymm11, %ymm4,  %ymm7
vpcmpeqw %ymm11, %ymm5,  %ymm8
vpcmpeqw %ymm11, %ymm6,  %ymm9
vpor     %ymm7,  %ymm8,  %ymm7
vpor     %ymm7,  %ymm9,  %ymm7
vptest   %ymm7,  %ymm7
jnz      _loopend

#t2 = fqmul(t1, t1); //100
#mul
vpmullw %ymm4,  %ymm4,  %ymm12
vpmullw %ymm5,  %ymm5,  %ymm13
vpmullw %ymm6,  %ymm6,  %ymm14
vpmulhw %ymm4,  %ymm4,  %ymm7
vpmulhw %ymm5,  %ymm5,  %ymm8
vpmulhw %ymm6,  %ymm6,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm7
vpsubw  %ymm13, %ymm8,  %ymm8
vpsubw  %ymm14, %ymm9,  %ymm9

#t2 = fqmul(t2, t2); //1000
#mul
vpmullw %ymm7,  %ymm7,  %ymm12
vpmullw %ymm8,  %ymm8,  %ymm13
vpmullw %ymm9,  %ymm9,  %ymm14
vpmulhw %ymm7,  %ymm7,  %ymm7
vpmulhw %ymm8,  %ymm8,  %ymm8
vpmulhw %ymm9,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm7 
vpsubw  %ymm13, %ymm8,  %ymm8 
vpsubw  %ymm14, %ymm9,  %ymm9 

#t3 = fqmul(t2, t2); //10000
#mul
vpmullw %ymm7,  %ymm7,  %ymm13
vpmullw %ymm8,  %ymm8,  %ymm14
vpmulhw %ymm7,  %ymm7,  %ymm10
vpmulhw %ymm8,  %ymm8,  %ymm11
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm13, %ymm10, %ymm10
vpsubw  %ymm14, %ymm11, %ymm11

#mul
vpmullw %ymm9,  %ymm9,  %ymm14
vpmulhw %ymm9,  %ymm9,  %ymm12
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm14, %ymm12, %ymm12

#t1 = fqmul(t1, t2); //1010
#mul
vpmullw %ymm7,  %ymm4,  %ymm13
vpmullw %ymm8,  %ymm5,  %ymm14
vpmulhw %ymm7,  %ymm4,  %ymm4
vpmulhw %ymm8,  %ymm5,  %ymm5
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm13, %ymm4,  %ymm4
vpsubw  %ymm14, %ymm5,  %ymm5

#mul
vpmullw %ymm9,  %ymm6,  %ymm14
vpmulhw %ymm9,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm14, %ymm6,  %ymm6 

#t2 = fqmul(t1, t3); //11010
#mul
vpmullw %ymm4,  %ymm10, %ymm13
vpmullw %ymm5,  %ymm11, %ymm14
vpmulhw %ymm4,  %ymm10, %ymm7
vpmulhw %ymm5,  %ymm11, %ymm8
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm13, %ymm7,  %ymm7
vpsubw  %ymm14, %ymm8,  %ymm8

#mul
vpmullw %ymm6,  %ymm12, %ymm14
vpmulhw %ymm6,  %ymm12, %ymm9
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm14, %ymm9,  %ymm9

#t2 = fqmul(t2, t2); //110100
#mul
vpmullw %ymm7,  %ymm7,  %ymm12
vpmullw %ymm8,  %ymm8,  %ymm13
vpmullw %ymm9,  %ymm9,  %ymm14
vpmulhw %ymm7,  %ymm7,  %ymm7
vpmulhw %ymm8,  %ymm8,  %ymm8
vpmulhw %ymm9,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm7
vpsubw  %ymm13, %ymm8,  %ymm8
vpsubw  %ymm14, %ymm9,  %ymm9

#t2 = fqmul(t2, a); //110101
#mul
vpmullw %ymm1,  %ymm7,  %ymm12
vpmullw %ymm2,  %ymm8,  %ymm13
vpmullw %ymm3,  %ymm9,  %ymm14
vpmulhw %ymm1,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm3,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0, %ymm12, %ymm12
vpmulhw %ymm0, %ymm13, %ymm13
vpmulhw %ymm0, %ymm14, %ymm14
vpsubw  %ymm12, %ymm7, %ymm7
vpsubw  %ymm13, %ymm8, %ymm8
vpsubw  %ymm14, %ymm9, %ymm9

#t1 = fqmul(t1, t2); //111111
#mul
vpmullw %ymm7,  %ymm4,  %ymm12
vpmullw %ymm8,  %ymm5,  %ymm13
vpmullw %ymm9,  %ymm6,  %ymm14
vpmulhw %ymm7,  %ymm4,  %ymm4
vpmulhw %ymm8,  %ymm5,  %ymm5
vpmulhw %ymm9,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm4,  %ymm4
vpsubw  %ymm13, %ymm5,  %ymm5
vpsubw  %ymm14, %ymm6,  %ymm6

#t2 = fqmul(t2, t2); //1101010
#mul
vpmullw %ymm7,  %ymm7,  %ymm12
vpmullw %ymm8,  %ymm8,  %ymm13
vpmullw %ymm9,  %ymm9,  %ymm14
vpmulhw %ymm7,  %ymm7,  %ymm7
vpmulhw %ymm8,  %ymm8,  %ymm8
vpmulhw %ymm9,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm7
vpsubw  %ymm13, %ymm8,  %ymm8
vpsubw  %ymm14, %ymm9,  %ymm9

#t2 = fqmul(t2, t2); //11010100
#mul
vpmullw %ymm7,  %ymm7,  %ymm12
vpmullw %ymm8,  %ymm8,  %ymm13
vpmullw %ymm9,  %ymm9,  %ymm14
vpmulhw %ymm7,  %ymm7,  %ymm7
vpmulhw %ymm8,  %ymm8,  %ymm8
vpmulhw %ymm9,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm7
vpsubw  %ymm13, %ymm8,  %ymm8
vpsubw  %ymm14, %ymm9,  %ymm9

#t2 = fqmul(t2, t2); //110101000
#mul
vpmullw %ymm7,  %ymm7,  %ymm12
vpmullw %ymm8,  %ymm8,  %ymm13
vpmullw %ymm9,  %ymm9,  %ymm14
vpmulhw %ymm7,  %ymm7,  %ymm7
vpmulhw %ymm8,  %ymm8,  %ymm8
vpmulhw %ymm9,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm7
vpsubw  %ymm13, %ymm8,  %ymm8
vpsubw  %ymm14, %ymm9,  %ymm9

#t2 = fqmul(t2, t2); //1101010000
#mul
vpmullw %ymm7,  %ymm7,  %ymm12
vpmullw %ymm8,  %ymm8,  %ymm13
vpmullw %ymm9,  %ymm9,  %ymm14
vpmulhw %ymm7,  %ymm7,  %ymm7
vpmulhw %ymm8,  %ymm8,  %ymm8
vpmulhw %ymm9,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm7
vpsubw  %ymm13, %ymm8,  %ymm8
vpsubw  %ymm14, %ymm9,  %ymm9

#t2 = fqmul(t2, t2); //11010100000
#mul
vpmullw %ymm7,  %ymm7,  %ymm12
vpmullw %ymm8,  %ymm8,  %ymm13
vpmullw %ymm9,  %ymm9,  %ymm14
vpmulhw %ymm7,  %ymm7,  %ymm7
vpmulhw %ymm8,  %ymm8,  %ymm8
vpmulhw %ymm9,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm7
vpsubw  %ymm13, %ymm8,  %ymm8
vpsubw  %ymm14, %ymm9,  %ymm9

#t2 = fqmul(t2, t2); //110101000000
#mul
vpmullw %ymm7,  %ymm7,  %ymm12
vpmullw %ymm8,  %ymm8,  %ymm13
vpmullw %ymm9,  %ymm9,  %ymm14
vpmulhw %ymm7,  %ymm7,  %ymm7
vpmulhw %ymm8,  %ymm8,  %ymm8
vpmulhw %ymm9,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm7
vpsubw  %ymm13, %ymm8,  %ymm8
vpsubw  %ymm14, %ymm9,  %ymm9

#t2 = fqmul(t2, t1); //110101111111
#mul
vpmullw %ymm4,  %ymm7,  %ymm12
vpmullw %ymm5,  %ymm8,  %ymm13
vpmullw %ymm6,  %ymm9,  %ymm14
vpmulhw %ymm4,  %ymm7,  %ymm7
vpmulhw %ymm5,  %ymm8,  %ymm8
vpmulhw %ymm6,  %ymm9,  %ymm9
vpmullw %ymm15, %ymm12, %ymm12
vpmullw %ymm15, %ymm13, %ymm13
vpmullw %ymm15, %ymm14, %ymm14

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm7,  %ymm1
vpsubw  %ymm13, %ymm8,  %ymm2
vpsubw  %ymm14, %ymm9,  %ymm3

#premul
vpmullw %ymm15, %ymm1, %ymm12 #t2qinv
vpmullw %ymm15, %ymm2, %ymm13 #t2qinv
vpmullw %ymm15, %ymm3, %ymm14 #t2qinv

#load
vmovdqa   (%rdi), %ymm4
vmovdqa 32(%rdi), %ymm5
vmovdqa 64(%rdi), %ymm6

#mul
vpmullw %ymm12, %ymm4, %ymm9
vpmullw %ymm12, %ymm5, %ymm10
vpmullw %ymm12, %ymm6, %ymm11
vpmulhw %ymm1,  %ymm4, %ymm4
vpmulhw %ymm1,  %ymm5, %ymm5
vpmulhw %ymm1,  %ymm6, %ymm6

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm9,  %ymm4,  %ymm4
vpsubw  %ymm10, %ymm5,  %ymm5
vpsubw  %ymm11, %ymm6,  %ymm6

#store
vmovdqa %ymm4,   (%rdi)
vmovdqa %ymm5, 32(%rdi)
vmovdqa %ymm6, 64(%rdi)

#load
vmovdqa  96(%rdi), %ymm4
vmovdqa 128(%rdi), %ymm5
vmovdqa 160(%rdi), %ymm6

#mul
vpmullw %ymm13, %ymm4, %ymm9
vpmullw %ymm13, %ymm5, %ymm10
vpmullw %ymm13, %ymm6, %ymm11
vpmulhw %ymm2,  %ymm4, %ymm4
vpmulhw %ymm2,  %ymm5, %ymm5
vpmulhw %ymm2,  %ymm6, %ymm6

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm9,  %ymm4,  %ymm4
vpsubw  %ymm10, %ymm5,  %ymm5
vpsubw  %ymm11, %ymm6,  %ymm6

#store
vmovdqa %ymm4,  96(%rdi)
vmovdqa %ymm5, 128(%rdi)
vmovdqa %ymm6, 160(%rdi)

#load
vmovdqa 192(%rdi), %ymm4
vmovdqa 224(%rdi), %ymm5
vmovdqa 256(%rdi), %ymm6

#mul
vpmullw %ymm14, %ymm4, %ymm9
vpmullw %ymm14, %ymm5, %ymm10
vpmullw %ymm14, %ymm6, %ymm11
vpmulhw %ymm3,  %ymm4, %ymm4
vpmulhw %ymm3,  %ymm5, %ymm5
vpmulhw %ymm3,  %ymm6, %ymm6

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm9,  %ymm4,  %ymm4
vpsubw  %ymm10, %ymm5,  %ymm5
vpsubw  %ymm11, %ymm6,  %ymm6

#store
vmovdqa %ymm4, 192(%rdi)
vmovdqa %ymm5, 224(%rdi)
vmovdqa %ymm6, 256(%rdi)

add $288, %rdi
cmp %r9, %rdi
jb _loop_inner2

cmp %r8,  %rdi
jb  _looptop

xor %rax, %rax
vpxor %ymm0, %ymm0, %ymm0

vmovdqu %ymm0,    (%rsp)
vmovdqu %ymm0,  32(%rsp)
vmovdqu %ymm0,  64(%rsp)
vmovdqu %ymm0,  96(%rsp)
vmovdqu %ymm0, 128(%rsp)
vmovdqu %ymm0, 160(%rsp)

add $192, %rsp

ret

_loopend:
mov $1, %rax
vpxor %ymm0, %ymm0, %ymm0

vmovdqu %ymm0,    (%rsp)
vmovdqu %ymm0,  32(%rsp)
vmovdqu %ymm0,  64(%rsp)
vmovdqu %ymm0,  96(%rsp)
vmovdqu %ymm0, 128(%rsp)
vmovdqu %ymm0, 160(%rsp)

add $192, %rsp

ret
