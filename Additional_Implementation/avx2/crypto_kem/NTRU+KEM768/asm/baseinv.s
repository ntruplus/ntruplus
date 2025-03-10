.global poly_baseinv
poly_baseinv:
vmovdqa _16xqinv(%rip), %ymm15
vmovdqa    _16xq(%rip), %ymm0
lea        zetas(%rip), %rdx
add              $1248, %rdx

lea 1536(%rsi), %r8

.p2align 5
_looptop:
#zeta
vmovdqa   (%rdx), %ymm14 #zeta*qinv
vmovdqa 32(%rdx), %ymm1  #zeta

#load
vmovdqa   (%rsi), %ymm2 #a[0]
vmovdqa 32(%rsi), %ymm3 #a[1]
vmovdqa 64(%rsi), %ymm4 #a[2]
vmovdqa 96(%rsi), %ymm5 #a[3]

#premul
vpmullw %ymm15, %ymm2, %ymm12 #a[0]
vpmullw %ymm15, %ymm3, %ymm13 #a[1]

#mul
vpmullw %ymm12, %ymm2, %ymm11 #a[0]*a[0]
vpmullw %ymm12, %ymm4, %ymm12 #a[0]*a[2]
vpmullw %ymm13, %ymm3, %ymm13 #a[1]*a[1]
vpmulhw %ymm2,  %ymm2, %ymm6
vpmulhw %ymm2,  %ymm4, %ymm7
vpmulhw %ymm3,  %ymm3, %ymm8

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm6,  %ymm6 #a[0]*a[0]
vpsubw  %ymm12, %ymm7,  %ymm7 #a[0]*a[2]
vpsubw  %ymm13, %ymm8,  %ymm8 #a[1]*a[1]

#add
vpsllw $1,    %ymm7, %ymm7
vpsubw %ymm8, %ymm7, %ymm7

#premul
vpmullw %ymm15, %ymm4, %ymm12 #a[2]
vpmullw %ymm15, %ymm5, %ymm13 #a[3]

#mul
vpmullw %ymm12, %ymm4, %ymm11 #a[2]*a[2]
vpmullw %ymm13, %ymm5, %ymm12 #a[3]*a[3]
vpmullw %ymm13, %ymm3, %ymm13 #a[3]*a[1]
vpmulhw %ymm4,  %ymm4, %ymm8
vpmulhw %ymm5,  %ymm5, %ymm9
vpmulhw %ymm5,  %ymm3, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm8,  %ymm8  #a[2]*a[2]
vpsubw  %ymm12, %ymm9,  %ymm9  #a[3]*a[3]
vpsubw  %ymm13, %ymm10, %ymm10 #a[3]*a[1]

#add
vpsllw $1,     %ymm10, %ymm10
vpsubw %ymm10, %ymm8,  %ymm8

#mul
vpmullw %ymm14, %ymm8, %ymm12
vpmullw %ymm14, %ymm9, %ymm13
vpmulhw %ymm1,  %ymm8, %ymm8
vpmulhw %ymm1,  %ymm9, %ymm9

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9

#update
vpaddw %ymm8, %ymm6, %ymm6 #t0
vpsubw %ymm9, %ymm7, %ymm7 #t1

#premul
vpmullw %ymm15, %ymm6, %ymm12
vpmullw %ymm15, %ymm7, %ymm13

#mul
vpmullw %ymm12, %ymm6, %ymm10
vpmullw %ymm13, %ymm7, %ymm11
vpmulhw %ymm6, %ymm6, %ymm8
vpmulhw %ymm7, %ymm7, %ymm9

#reduce
vpmulhw %ymm0, %ymm10, %ymm10
vpmulhw %ymm0, %ymm11, %ymm11
vpsubw  %ymm10, %ymm8, %ymm8
vpsubw  %ymm11, %ymm9, %ymm9

#mul
vpmullw %ymm14, %ymm9, %ymm11
vpmulhw %ymm1, %ymm9, %ymm9

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm11, %ymm9,  %ymm9

#add
vpsubw  %ymm9, %ymm8, %ymm8

#mul
vpmullw %ymm14, %ymm4, %ymm11
vpmullw %ymm14, %ymm5, %ymm14
vpmulhw %ymm1,  %ymm4, %ymm9
vpmulhw %ymm1,  %ymm5, %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm9,  %ymm9 #a[2]*zeta
vpsubw  %ymm14, %ymm1,  %ymm1 #a[3]*zeta

#mul
vpmullw %ymm13, %ymm9, %ymm11
vpmullw %ymm13, %ymm1, %ymm14
vpmulhw %ymm7,  %ymm9,  %ymm9
vpmulhw %ymm7,  %ymm1,  %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm9,  %ymm9 #a[2]*t1*zeta
vpsubw  %ymm14, %ymm1,  %ymm1 #a[3]*t1*zeta

#mul
vpmullw %ymm13, %ymm2, %ymm14
vpmullw %ymm13, %ymm3, %ymm13
vpmulhw %ymm7,  %ymm2, %ymm11
vpmulhw %ymm7,  %ymm3, %ymm7

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm14, %ymm11, %ymm11 #a[0]*t1
vpsubw  %ymm13, %ymm7,  %ymm7  #a[1]*t1

#mul
vpmullw %ymm12, %ymm2, %ymm14
vpmullw %ymm12, %ymm3, %ymm13
vpmulhw %ymm6,  %ymm2, %ymm2
vpmulhw %ymm6,  %ymm3, %ymm3

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm14, %ymm2,  %ymm2 #a[0]*t0
vpsubw  %ymm13, %ymm3,  %ymm3 #a[1]*t0

#mul
vpmullw %ymm12, %ymm4, %ymm13
vpmullw %ymm12, %ymm5, %ymm14
vpmulhw %ymm6,  %ymm4, %ymm4
vpmulhw %ymm6,  %ymm5, %ymm5

#reduce
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm13, %ymm4,  %ymm4 #a[2]*t0
vpsubw  %ymm14, %ymm5,  %ymm5 #a[3]*t0

#add
vpsubw  %ymm9,  %ymm2, %ymm2
vpsubw  %ymm1,  %ymm3, %ymm3
vpsubw  %ymm11, %ymm4, %ymm4
vpsubw  %ymm7,  %ymm5, %ymm5

vmovdqa %ymm2,   (%rdi)
vmovdqa %ymm3, 32(%rdi)
vmovdqa %ymm4, 64(%rdi)
vmovdqa %ymm5, 96(%rdi)

sub $32, %rsp
vmovdqu %ymm8, (%rsp)

#zeta
vmovdqa   (%rdx), %ymm14 #zeta*qinv
vmovdqa 32(%rdx), %ymm1  #zeta

#load
vmovdqa 128(%rsi), %ymm2 #a[0]
vmovdqa 160(%rsi), %ymm3 #a[1]
vmovdqa 192(%rsi), %ymm4 #a[2]
vmovdqa 224(%rsi), %ymm5 #a[3]

#premul
vpmullw %ymm15, %ymm2, %ymm12 #a[0]
vpmullw %ymm15, %ymm3, %ymm13 #a[1]

#mul
vpmullw %ymm12, %ymm2, %ymm11 #a[0]*a[0]
vpmullw %ymm12, %ymm4, %ymm12 #a[0]*a[2]
vpmullw %ymm13, %ymm3, %ymm13 #a[1]*a[1]
vpmulhw %ymm2,  %ymm2, %ymm6
vpmulhw %ymm2,  %ymm4, %ymm7
vpmulhw %ymm3,  %ymm3, %ymm8

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm6,  %ymm6 #a[0]*a[0]
vpsubw  %ymm12, %ymm7,  %ymm7 #a[0]*a[2]
vpsubw  %ymm13, %ymm8,  %ymm8 #a[1]*a[1]

#add
vpsllw $1,    %ymm7, %ymm7
vpsubw %ymm8, %ymm7, %ymm7

#premul
vpmullw %ymm15, %ymm4, %ymm12 #a[2]
vpmullw %ymm15, %ymm5, %ymm13 #a[3]

#mul
vpmullw %ymm12, %ymm4, %ymm11 #a[2]*a[2]
vpmullw %ymm13, %ymm5, %ymm12 #a[3]*a[3]
vpmullw %ymm13, %ymm3, %ymm13 #a[3]*a[1]
vpmulhw %ymm4,  %ymm4, %ymm8
vpmulhw %ymm5,  %ymm5, %ymm9
vpmulhw %ymm5,  %ymm3, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm8,  %ymm8  #a[2]*a[2]
vpsubw  %ymm12, %ymm9,  %ymm9  #a[3]*a[3]
vpsubw  %ymm13, %ymm10, %ymm10 #a[3]*a[1]

#add
vpsllw $1,     %ymm10, %ymm10
vpsubw %ymm10, %ymm8,  %ymm8

#mul
vpmullw %ymm14, %ymm8, %ymm12
vpmullw %ymm14, %ymm9, %ymm13
vpmulhw %ymm1,  %ymm8, %ymm8
vpmulhw %ymm1,  %ymm9, %ymm9

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9

#update
vpsubw %ymm8, %ymm6, %ymm6 #t0
vpaddw %ymm9, %ymm7, %ymm7 #t1

#premul
vpmullw %ymm15, %ymm6, %ymm12
vpmullw %ymm15, %ymm7, %ymm13

#mul
vpmullw %ymm12, %ymm6, %ymm10
vpmullw %ymm13, %ymm7, %ymm11
vpmulhw %ymm6, %ymm6, %ymm8
vpmulhw %ymm7, %ymm7, %ymm9

#reduce
vpmulhw %ymm0, %ymm10, %ymm10
vpmulhw %ymm0, %ymm11, %ymm11
vpsubw  %ymm10, %ymm8, %ymm8
vpsubw  %ymm11, %ymm9, %ymm9

#mul
vpmullw %ymm14, %ymm9, %ymm11
vpmulhw %ymm1, %ymm9, %ymm9

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm11, %ymm9,  %ymm9

#add
vpaddw  %ymm9, %ymm8, %ymm8

#mul
vpmullw %ymm14, %ymm4, %ymm11
vpmullw %ymm14, %ymm5, %ymm14
vpmulhw %ymm1,  %ymm4, %ymm9
vpmulhw %ymm1,  %ymm5, %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm9,  %ymm9 #a[2]*zeta
vpsubw  %ymm14, %ymm1,  %ymm1 #a[3]*zeta

#mul
vpmullw %ymm13, %ymm9, %ymm11
vpmullw %ymm13, %ymm1, %ymm14
vpmulhw %ymm7,  %ymm9,  %ymm9
vpmulhw %ymm7,  %ymm1,  %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm9,  %ymm9 #a[2]*t1*zeta
vpsubw  %ymm14, %ymm1,  %ymm1 #a[3]*t1*zeta

#mul
vpmullw %ymm13, %ymm2, %ymm14
vpmullw %ymm13, %ymm3, %ymm13
vpmulhw %ymm7,  %ymm2, %ymm11
vpmulhw %ymm7,  %ymm3, %ymm7

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm14, %ymm11, %ymm11 #a[0]*t1
vpsubw  %ymm13, %ymm7,  %ymm7  #a[1]*t1

#mul
vpmullw %ymm12, %ymm2, %ymm14
vpmullw %ymm12, %ymm3, %ymm13
vpmulhw %ymm6,  %ymm2, %ymm2
vpmulhw %ymm6,  %ymm3, %ymm3

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm14, %ymm2,  %ymm2 #a[0]*t0
vpsubw  %ymm13, %ymm3,  %ymm3 #a[1]*t0

#mul
vpmullw %ymm12, %ymm4, %ymm13
vpmullw %ymm12, %ymm5, %ymm14
vpmulhw %ymm6,  %ymm4, %ymm4
vpmulhw %ymm6,  %ymm5, %ymm5

#reduce
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm13, %ymm4,  %ymm4 #a[2]*t0
vpsubw  %ymm14, %ymm5,  %ymm5 #a[3]*t0

#add
vpaddw %ymm9,  %ymm2, %ymm2
vpaddw %ymm1,  %ymm3, %ymm3
vpsubw %ymm11, %ymm4, %ymm4
vpsubw %ymm7,  %ymm5, %ymm5

vmovdqa %ymm2, 128(%rdi)
vmovdqa %ymm3, 160(%rdi)
vmovdqa %ymm4, 192(%rdi)
vmovdqa %ymm5, 224(%rdi)

vmovdqu  (%rsp), %ymm1
add $32, %rsp
vmovdqa  %ymm8, %ymm2

#t1 = fqmul(a, a); //10
#premul
vpmullw %ymm15, %ymm1, %ymm13 #aqinv
vpmullw %ymm15, %ymm2, %ymm14 #aqinv

#mul
vpmullw %ymm13, %ymm1, %ymm11
vpmullw %ymm14, %ymm2, %ymm12
vpmulhw %ymm1, %ymm1, %ymm3
vpmulhw %ymm2, %ymm2, %ymm4

#reduce
vpmulhw %ymm0, %ymm11, %ymm11
vpmulhw %ymm0, %ymm12, %ymm12
vpsubw %ymm11, %ymm3, %ymm3
vpsubw %ymm12, %ymm4, %ymm4

#check for invertibility
vpxor    %ymm10, %ymm10, %ymm10
vpcmpeqw %ymm10, %ymm3,  %ymm5
vpcmpeqw %ymm10, %ymm4,  %ymm6
vpor     %ymm5,  %ymm6,  %ymm5
vptest   %ymm5,  %ymm5
jnz      _loopend

#t2 = fqmul(t1, t1); //100
#premul
vpmullw %ymm15, %ymm3, %ymm11 #t1qinv
vpmullw %ymm15, %ymm4, %ymm12 #t1qinv

#mul
vpmullw %ymm11, %ymm3, %ymm9
vpmullw %ymm12, %ymm4, %ymm10
vpmulhw %ymm3,  %ymm3, %ymm5
vpmulhw %ymm4,  %ymm4, %ymm6

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5 #t2
vpsubw  %ymm10, %ymm6,  %ymm6 #t2

#t2 = fqmul(t2, t2); //1000
#mul
vpmullw %ymm5,  %ymm5,  %ymm9
vpmullw %ymm6,  %ymm6,  %ymm10
vpmulhw %ymm5,  %ymm5,  %ymm5
vpmulhw %ymm6,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm9, %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5 #t2
vpsubw  %ymm10, %ymm6,  %ymm6 #t2

#t3 = fqmul(t2, t2); //10000
#mul
vpmullw %ymm5,  %ymm5,  %ymm9
vpmullw %ymm6,  %ymm6,  %ymm10
vpmulhw %ymm5,  %ymm5,  %ymm7
vpmulhw %ymm6,  %ymm6,  %ymm8
vpmullw %ymm15, %ymm9, %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm7,  %ymm7 #t3
vpsubw  %ymm10, %ymm8,  %ymm8 #t3

#t1 = fqmul(t1, t2); //1010
#mul
vpmullw %ymm11, %ymm5, %ymm9
vpmullw %ymm12, %ymm6, %ymm10
vpmulhw %ymm3, %ymm5, %ymm3
vpmulhw %ymm4, %ymm6, %ymm4

#reduce
vpmulhw %ymm0, %ymm9, %ymm9
vpmulhw %ymm0, %ymm10, %ymm10
vpsubw %ymm9, %ymm3, %ymm3 #t1
vpsubw %ymm10, %ymm4, %ymm4 #t1

#t2 = fqmul(t1, t3); //11010
#premul
vpmullw %ymm15, %ymm3, %ymm11 #t1qinv
vpmullw %ymm15, %ymm4, %ymm12 #t1qinv

#mul
vpmullw %ymm11, %ymm7, %ymm9
vpmullw %ymm12, %ymm8, %ymm10
vpmulhw %ymm3, %ymm7, %ymm5
vpmulhw %ymm4, %ymm8, %ymm6

#reduce
vpmulhw %ymm0, %ymm9, %ymm9
vpmulhw %ymm0, %ymm10, %ymm10
vpsubw  %ymm9, %ymm5, %ymm5  #t2
vpsubw  %ymm10, %ymm6, %ymm6 #t2

#t2 = fqmul(t2, t2); //110100
#mul
vpmullw %ymm5,  %ymm5,  %ymm9
vpmullw %ymm6,  %ymm6,  %ymm10
vpmulhw %ymm5,  %ymm5,  %ymm5
vpmulhw %ymm6,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm9,  %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5 #t2
vpsubw  %ymm10, %ymm6,  %ymm6 #t2

#t2 = fqmul(t2, a); //110101
#mul
vpmullw %ymm13, %ymm5,  %ymm9
vpmullw %ymm14, %ymm6,  %ymm10
vpmulhw %ymm1,  %ymm5,  %ymm5
vpmulhw %ymm2,  %ymm6,  %ymm6

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5 #t2
vpsubw  %ymm10, %ymm6,  %ymm6 #t2    

#t1 = fqmul(t1, t2); //111111
#mul
vpmullw %ymm11, %ymm5,  %ymm9
vpmullw %ymm12, %ymm6,  %ymm10
vpmulhw %ymm3,  %ymm5,  %ymm3
vpmulhw %ymm4,  %ymm6,  %ymm4

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm3,  %ymm3 #t1
vpsubw  %ymm10, %ymm4,  %ymm4 #t1

#t2 = fqmul(t2, t2); //1101010
#mul
vpmullw %ymm5,  %ymm5,  %ymm9
vpmullw %ymm6,  %ymm6,  %ymm10
vpmulhw %ymm5,  %ymm5,  %ymm5
vpmulhw %ymm6,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm9, %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5 #t2
vpsubw  %ymm10, %ymm6,  %ymm6 #t2

#t2 = fqmul(t2, t2); //11010100
#mul
vpmullw %ymm5,  %ymm5,  %ymm9
vpmullw %ymm6,  %ymm6,  %ymm10
vpmulhw %ymm5,  %ymm5,  %ymm5
vpmulhw %ymm6,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm9, %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5 #t2
vpsubw  %ymm10, %ymm6,  %ymm6 #t2

#t2 = fqmul(t2, t2); //110101000
#mul
vpmullw %ymm5,  %ymm5,  %ymm9
vpmullw %ymm6,  %ymm6,  %ymm10
vpmulhw %ymm5,  %ymm5,  %ymm5
vpmulhw %ymm6,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm9, %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5
vpsubw  %ymm10, %ymm6,  %ymm6

#t2 = fqmul(t2, t2); //1101010000
#mul
vpmullw %ymm5,  %ymm5,  %ymm9
vpmullw %ymm6,  %ymm6,  %ymm10
vpmulhw %ymm5,  %ymm5,  %ymm5
vpmulhw %ymm6,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm9, %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5
vpsubw  %ymm10, %ymm6,  %ymm6

#t2 = fqmul(t2, t2); //11010100000
#mul
vpmullw %ymm5,  %ymm5,  %ymm9
vpmullw %ymm6,  %ymm6,  %ymm10
vpmulhw %ymm5,  %ymm5,  %ymm5
vpmulhw %ymm6,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm9, %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5
vpsubw  %ymm10, %ymm6,  %ymm6

#t2 = fqmul(t2, t2); //110101000000
#mul
vpmullw %ymm5,  %ymm5,  %ymm9
vpmullw %ymm6,  %ymm6,  %ymm10
vpmulhw %ymm5,  %ymm5,  %ymm5
vpmulhw %ymm6,  %ymm6,  %ymm6
vpmullw %ymm15, %ymm9, %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm5
vpsubw  %ymm10, %ymm6,  %ymm6

#t2 = fqmul(t2, t1); //110101111111
#mul
vpmullw %ymm5,  %ymm3,  %ymm9
vpmullw %ymm6,  %ymm4,  %ymm10
vpmulhw %ymm5,  %ymm3,  %ymm5
vpmulhw %ymm6,  %ymm4,  %ymm6
vpmullw %ymm15, %ymm9, %ymm9
vpmullw %ymm15, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm9,  %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpsubw  %ymm9,  %ymm5,  %ymm1 #t2
vpsubw  %ymm10, %ymm6,  %ymm2 #t2

#premul
vpmullw %ymm15, %ymm1, %ymm13 #t2qinv
vpmullw %ymm15, %ymm2, %ymm14 #t2qinv

#load
vmovdqa   (%rdi), %ymm3
vmovdqa 32(%rdi), %ymm4
vmovdqa 64(%rdi), %ymm5
vmovdqa 96(%rdi), %ymm6

#mul
vpmullw %ymm13, %ymm3, %ymm9
vpmullw %ymm13, %ymm4, %ymm10
vpmullw %ymm13, %ymm5, %ymm11
vpmullw %ymm13, %ymm6, %ymm12
vpmulhw %ymm1,  %ymm3, %ymm3
vpmulhw %ymm1,  %ymm4, %ymm4
vpmulhw %ymm1,  %ymm5, %ymm5
vpmulhw %ymm1,  %ymm6, %ymm6

#reduce
vpmulhw %ymm0,  %ymm9, %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm9, %ymm3,  %ymm3
vpsubw  %ymm4,  %ymm10, %ymm4
vpsubw  %ymm11, %ymm5,  %ymm5
vpsubw  %ymm6,  %ymm12, %ymm6

#store
vmovdqa %ymm3,   (%rdi)
vmovdqa %ymm4, 32(%rdi)
vmovdqa %ymm5, 64(%rdi)
vmovdqa %ymm6, 96(%rdi)

#load
vmovdqa 128(%rdi), %ymm3
vmovdqa 160(%rdi), %ymm4
vmovdqa 192(%rdi), %ymm5
vmovdqa 224(%rdi), %ymm6

#mul
vpmullw %ymm14, %ymm3, %ymm9
vpmullw %ymm14, %ymm4, %ymm10
vpmullw %ymm14, %ymm5, %ymm11
vpmullw %ymm14, %ymm6, %ymm12
vpmulhw %ymm2,  %ymm3, %ymm3
vpmulhw %ymm2,  %ymm4, %ymm4
vpmulhw %ymm2,  %ymm5, %ymm5
vpmulhw %ymm2,  %ymm6, %ymm6

#reduce
vpmulhw %ymm0,  %ymm9, %ymm9
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm9, %ymm3,  %ymm3
vpsubw  %ymm4,  %ymm10, %ymm4
vpsubw  %ymm11, %ymm5,  %ymm5
vpsubw  %ymm6,  %ymm12, %ymm6

#store
vmovdqa %ymm3, 128(%rdi)
vmovdqa %ymm4, 160(%rdi)
vmovdqa %ymm5, 192(%rdi)
vmovdqa %ymm6, 224(%rdi)

add $256, %rsi
add $256, %rdi
add $64,  %rdx
cmp %r8,  %rsi
jb  _looptop

xor %rax, %rax

ret

_loopend:
mov $1, %rax

ret
