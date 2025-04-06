.global poly_baseinv
poly_baseinv:
vmovdqa    _16xq(%rip), %ymm0
vmovdqa _16xqinv(%rip), %ymm1
lea        zetas(%rip), %rdx
add              $1888, %rdx

lea 1728(%rsi), %r8

.p2align 5
_looptop:
#zeta
vmovdqa   (%rdx), %ymm14
vmovdqa 32(%rdx), %ymm15

#load
vmovdqa   (%rsi), %ymm3
vmovdqa 32(%rsi), %ymm5
vmovdqa 64(%rsi), %ymm7

#premul
vpmullw %ymm1, %ymm3, %ymm2
vpmullw %ymm1, %ymm5, %ymm4
vpmullw %ymm1, %ymm7, %ymm6

#mul
vpmullw %ymm5, %ymm14, %ymm8  #zeta a[1]
vpmullw %ymm7, %ymm14, %ymm10 #zeta a[2]
vpmullw %ymm7, %ymm2,  %ymm12 #a[0] a[2]
vpmullw %ymm5, %ymm4,  %ymm14 #a[1] a[1]
vpmulhw %ymm5, %ymm15, %ymm9 
vpmulhw %ymm7, %ymm15, %ymm11
vpmulhw %ymm7, %ymm3,  %ymm13
vpmulhw %ymm5, %ymm5,  %ymm15

#reduce
vpmulhw %ymm0,  %ymm8,  %ymm8
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm8,  %ymm9,  %ymm8
vpsubw  %ymm10, %ymm11, %ymm9
vpsubw  %ymm12, %ymm13, %ymm10
vpsubw  %ymm14, %ymm15, %ymm11

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
vpmullw %ymm1, %ymm8, %ymm15 #premul a[1] zeta 
vpmullw %ymm1, %ymm9, %ymm13 #premul a[2] zeta 

#mul 3
vpmullw %ymm10, %ymm15, %ymm12 #r[2] * a[1] zeta 
vpmullw %ymm6,  %ymm13, %ymm14 #r[1] * a[2] zeta 
vpmullw %ymm11, %ymm2,  %ymm4  #r[0] * a[0]
vpmulhw %ymm10, %ymm8,  %ymm13
vpmulhw %ymm6,  %ymm9,  %ymm15
vpmulhw %ymm11, %ymm3,  %ymm5

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm13
vpsubw  %ymm4,  %ymm5,  %ymm14

#add
vpaddw %ymm12, %ymm13, %ymm12
vpaddw %ymm12, %ymm14, %ymm8


#store
vmovdqa %ymm11,   (%rdi)
vmovdqa %ymm6,  32(%rdi)
vmovdqa %ymm10, 64(%rdi)

sub $32, %rsp
vmovdqu %ymm8, (%rsp)

#negative zeta
#load
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm5
vmovdqa 160(%rsi), %ymm7
vmovdqa    (%rdx), %ymm14
vmovdqa  32(%rdx), %ymm15

#premul
vpmullw %ymm1, %ymm3, %ymm2
vpmullw %ymm1, %ymm5, %ymm4
vpmullw %ymm1, %ymm7, %ymm6

#mul 1
vpmullw %ymm5, %ymm14, %ymm8
vpmullw %ymm7, %ymm14, %ymm10
vpmullw %ymm7, %ymm2,  %ymm12
vpmullw %ymm5, %ymm4,  %ymm14
vpmulhw %ymm5, %ymm15, %ymm9
vpmulhw %ymm7, %ymm15, %ymm11
vpmulhw %ymm7, %ymm3,  %ymm13
vpmulhw %ymm5, %ymm5,  %ymm15

#reduce
vpmulhw %ymm0,  %ymm8,  %ymm8
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm8,  %ymm9,  %ymm8
vpsubw  %ymm10, %ymm11, %ymm9
vpsubw  %ymm12, %ymm13, %ymm10
vpsubw  %ymm14, %ymm15, %ymm11

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
vpmullw %ymm1, %ymm8, %ymm15

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm6,  %ymm6
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm11, %ymm12, %ymm11
vpsubw  %ymm13, %ymm14, %ymm12
vpmullw %ymm1,  %ymm9,  %ymm13
vpsubw  %ymm6,  %ymm7,  %ymm6
vpsubw  %ymm4,  %ymm5,  %ymm7

#add
vpaddw %ymm12, %ymm11, %ymm11
vpaddw %ymm7,  %ymm6,  %ymm6
vpsubw %ymm6,  %ymm0,  %ymm6

#mul 3
vpmullw %ymm10, %ymm15, %ymm12
vpmullw %ymm6,  %ymm13, %ymm14
vpmullw %ymm11, %ymm2,  %ymm4
vpmulhw %ymm10, %ymm8,  %ymm13
vpmulhw %ymm6,  %ymm9,  %ymm15
vpmulhw %ymm11, %ymm3,  %ymm5

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm13
vpsubw  %ymm4,  %ymm5,  %ymm14

#add
vpaddw %ymm12, %ymm13, %ymm12
vpsubw %ymm12, %ymm14, %ymm8

#store
vmovdqa %ymm11,  96(%rdi)
vmovdqa %ymm6,  128(%rdi)
vmovdqa %ymm10, 160(%rdi)

vmovdqu (%rsp), %ymm2
add $32, %rsp
vmovdqa %ymm8, %ymm3

#t1 = fqmul(a, a); //10
#premul
vpmullw %ymm1, %ymm2, %ymm14 #aqinv
vpmullw %ymm1, %ymm3, %ymm15 #aqinv

#mul
vpmullw %ymm14, %ymm2, %ymm12
vpmullw %ymm15, %ymm3, %ymm13
vpmulhw %ymm2, %ymm2, %ymm4
vpmulhw %ymm3, %ymm3, %ymm5

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm12, %ymm4,  %ymm4
vpsubw  %ymm13, %ymm5,  %ymm5

#check for invertibility
vpxor    %ymm11, %ymm11, %ymm11
vpcmpeqw %ymm11, %ymm4,  %ymm6
vpcmpeqw %ymm11, %ymm5,  %ymm7
vpor     %ymm6,  %ymm7,  %ymm6
vptest   %ymm6,  %ymm6
jnz      _loopend

#t2 = fqmul(t1, t1); //100
#premul
vpmullw %ymm1, %ymm4, %ymm12 #t1qinv
vpmullw %ymm1, %ymm5, %ymm13 #t1qinv

#mul
vpmullw %ymm12, %ymm4, %ymm10
vpmullw %ymm13, %ymm5, %ymm11
vpmulhw %ymm4,  %ymm4, %ymm6
vpmulhw %ymm5,  %ymm5, %ymm7

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t2 = fqmul(t2, t2); //1000
#mul
vpmullw %ymm6, %ymm6,  %ymm10
vpmullw %ymm7, %ymm7,  %ymm11
vpmulhw %ymm6, %ymm6,  %ymm6
vpmulhw %ymm7, %ymm7,  %ymm7
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t3 = fqmul(t2, t2); //10000
#mul
vpmullw %ymm6, %ymm6,  %ymm10
vpmullw %ymm7, %ymm7,  %ymm11
vpmulhw %ymm6, %ymm6,  %ymm8
vpmulhw %ymm7, %ymm7,  %ymm9
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm8,  %ymm8  #t3
vpsubw  %ymm11, %ymm9,  %ymm9  #t3

#t1 = fqmul(t1, t2); //1010
#mul
vpmullw %ymm12, %ymm6, %ymm10
vpmullw %ymm13, %ymm7, %ymm11
vpmulhw %ymm4,  %ymm6, %ymm4
vpmulhw %ymm5,  %ymm7, %ymm5

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm4,  %ymm4  #t1
vpsubw  %ymm11, %ymm5,  %ymm5  #t1

#t2 = fqmul(t1, t3); //11010
#premul
vpmullw %ymm1, %ymm4, %ymm12 #t1qinv
vpmullw %ymm1, %ymm5, %ymm13 #t1qinv

#mul
vpmullw %ymm12, %ymm8, %ymm10
vpmullw %ymm13, %ymm9, %ymm11
vpmulhw %ymm4,  %ymm8, %ymm6
vpmulhw %ymm5,  %ymm9, %ymm7

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t2 = fqmul(t2, t2); //110100
#mul
vpmullw %ymm6, %ymm6,  %ymm10
vpmullw %ymm7, %ymm7,  %ymm11
vpmulhw %ymm6, %ymm6,  %ymm6
vpmulhw %ymm7, %ymm7,  %ymm7
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t2 = fqmul(t2, a); //110101
#mul
vpmullw %ymm14, %ymm6, %ymm10
vpmullw %ymm15, %ymm7, %ymm11
vpmulhw %ymm2,  %ymm6, %ymm6
vpmulhw %ymm3,  %ymm7, %ymm7

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2 

#t1 = fqmul(t1, t2); //111111
#mul
vpmullw %ymm12, %ymm6, %ymm10
vpmullw %ymm13, %ymm7, %ymm11
vpmulhw %ymm4,  %ymm6, %ymm4
vpmulhw %ymm5,  %ymm7, %ymm5

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm4,  %ymm4  #t1
vpsubw  %ymm11, %ymm5,  %ymm5  #t1

#t2 = fqmul(t2, t2); //1101010
#mul
vpmullw %ymm6, %ymm6,  %ymm10
vpmullw %ymm7, %ymm7,  %ymm11
vpmulhw %ymm6, %ymm6,  %ymm6
vpmulhw %ymm7, %ymm7,  %ymm7
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t2 = fqmul(t2, t2); //11010100
#mul
vpmullw %ymm6, %ymm6,  %ymm10
vpmullw %ymm7, %ymm7,  %ymm11
vpmulhw %ymm6, %ymm6,  %ymm6
vpmulhw %ymm7, %ymm7,  %ymm7
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t2 = fqmul(t2, t2); //110101000
#mul
vpmullw %ymm6, %ymm6,  %ymm10
vpmullw %ymm7, %ymm7,  %ymm11
vpmulhw %ymm6, %ymm6,  %ymm6
vpmulhw %ymm7, %ymm7,  %ymm7
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t2 = fqmul(t2, t2); //1101010000
#mul
vpmullw %ymm6, %ymm6,  %ymm10
vpmullw %ymm7, %ymm7,  %ymm11
vpmulhw %ymm6, %ymm6,  %ymm6
vpmulhw %ymm7, %ymm7,  %ymm7
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t2 = fqmul(t2, t2); //11010100000
#mul
vpmullw %ymm6, %ymm6,  %ymm10
vpmullw %ymm7, %ymm7,  %ymm11
vpmulhw %ymm6, %ymm6,  %ymm6
vpmulhw %ymm7, %ymm7,  %ymm7
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t2 = fqmul(t2, t2); //110101000000
#mul
vpmullw %ymm6, %ymm6,  %ymm10
vpmullw %ymm7, %ymm7,  %ymm11
vpmulhw %ymm6, %ymm6,  %ymm6
vpmulhw %ymm7, %ymm7,  %ymm7
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm6  #t2
vpsubw  %ymm11, %ymm7,  %ymm7  #t2

#t2 = fqmul(t2, t1); //110101111111
#mul
vpmullw %ymm6, %ymm4,  %ymm10
vpmullw %ymm7, %ymm5,  %ymm11
vpmulhw %ymm6, %ymm4,  %ymm6
vpmulhw %ymm7, %ymm5,  %ymm7
vpmullw %ymm1, %ymm10, %ymm10
vpmullw %ymm1, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm10, %ymm6,  %ymm2  #t2
vpsubw  %ymm11, %ymm7,  %ymm3  #t2

#premul
vpmullw %ymm1, %ymm2, %ymm14 #t2qinv
vpmullw %ymm1, %ymm3, %ymm15 #t2qinv

#load
vmovdqa   (%rdi), %ymm4
vmovdqa 32(%rdi), %ymm5
vmovdqa 64(%rdi), %ymm6

#mul
vpmullw %ymm14, %ymm4, %ymm11
vpmullw %ymm14, %ymm5, %ymm12
vpmullw %ymm14, %ymm6, %ymm13
vpmulhw %ymm2,  %ymm4, %ymm4
vpmulhw %ymm2,  %ymm5, %ymm5
vpmulhw %ymm2,  %ymm6, %ymm6

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm4,  %ymm4
vpsubw  %ymm12, %ymm5,  %ymm5
vpsubw  %ymm13, %ymm6,  %ymm6

#store
vmovdqa %ymm4,   (%rdi)
vmovdqa %ymm5, 32(%rdi)
vmovdqa %ymm6, 64(%rdi)

#load
vmovdqa  96(%rdi), %ymm4
vmovdqa 128(%rdi), %ymm5
vmovdqa 160(%rdi), %ymm6

#mul
vpmullw %ymm15, %ymm4, %ymm11
vpmullw %ymm15, %ymm5, %ymm12
vpmullw %ymm15, %ymm6, %ymm13
vpmulhw %ymm3,  %ymm4, %ymm4
vpmulhw %ymm3,  %ymm5, %ymm5
vpmulhw %ymm3,  %ymm6, %ymm6

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm4,  %ymm4
vpsubw  %ymm12, %ymm5,  %ymm5
vpsubw  %ymm13, %ymm6,  %ymm6

#store
vmovdqa %ymm4,  96(%rdi)
vmovdqa %ymm5, 128(%rdi)
vmovdqa %ymm6, 160(%rdi)

add $192, %rsi
add $192, %rdi
add $64,  %rdx
cmp %r8,  %rsi
jb  _looptop

xor %rax, %rax
vpxor %ymm0, %ymm0, %ymm0

sub $96,  %rsp

vmovdqu %ymm0, 64(%rsp)
vmovdqu %ymm0, 32(%rsp)
vmovdqu %ymm0,   (%rsp)

add $96, %rsp

ret

_loopend:
mov $1, %rax
vpxor %ymm0, %ymm0, %ymm0

sub $96,  %rsp

vmovdqu %ymm0, 64(%rsp)
vmovdqu %ymm0, 32(%rsp)
vmovdqu %ymm0,   (%rsp)

add $96, %rsp

ret
