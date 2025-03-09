.global poly_baseinv
poly_baseinv:
    vmovdqa  _16xqinv(%rip), %ymm15
    vmovdqa     _16xq(%rip), %ymm0
    lea     zetas_mul(%rip), %rdx

    lea 1152(%rsi), %r8

.p2align 5
_looptop:
    lea 192(%rdx), %r9

_loop_inner:
    #zeta
    vmovdqa   (%rdx), %ymm14 #zeta*qinv
    vmovdqa 32(%rdx), %ymm1  #zeta

    #load
    vmovdqa   (%rsi), %ymm2 # a[0]
    vmovdqa 32(%rsi), %ymm3 # a[1]
    vmovdqa 64(%rsi), %ymm4 # a[2]
    vmovdqa 96(%rsi), %ymm5 # a[3]

    #premul
    vpmullw %ymm15, %ymm2, %ymm12 # a[0]
    vpmullw %ymm15, %ymm3, %ymm13 # a[1]

    #mul
    vpmullw %ymm12, %ymm2, %ymm11 # a[0]*a[0]
    vpmullw %ymm12, %ymm4, %ymm12 # a[0]*a[2]
    vpmullw %ymm13, %ymm3, %ymm13 # a[1]*a[1]
    vpmulhw %ymm2,  %ymm2, %ymm6
    vpmulhw %ymm2,  %ymm4, %ymm7
    vpmulhw %ymm3,  %ymm3, %ymm8

    #reduce
    vpmulhw %ymm0,  %ymm11, %ymm11
    vpmulhw %ymm0,  %ymm12, %ymm12
    vpmulhw %ymm0,  %ymm13, %ymm13
    vpsubw  %ymm11, %ymm6,  %ymm6 # a[0]*a[0]
    vpsubw  %ymm12, %ymm7,  %ymm7 # a[0]*a[2]
    vpsubw  %ymm13, %ymm8,  %ymm8 # a[1]*a[1]

    #add
    vpsllw $1,    %ymm7, %ymm7
    vpsubw %ymm8, %ymm7, %ymm7

    #premul
    vpmullw %ymm15, %ymm4, %ymm12 # a[2]
    vpmullw %ymm15, %ymm5, %ymm13 # a[3]

    #mul
    vpmullw %ymm12, %ymm4, %ymm11 # a[2]*a[2]
    vpmullw %ymm13, %ymm5, %ymm12 # a[3]*a[3]
    vpmullw %ymm13, %ymm3, %ymm13 # a[3]*a[1]
    vpmulhw %ymm4,  %ymm4, %ymm8
    vpmulhw %ymm5,  %ymm5, %ymm9
    vpmulhw %ymm5,  %ymm3, %ymm10

    #reduce
    vpmulhw %ymm0,  %ymm11, %ymm11
    vpmulhw %ymm0,  %ymm12, %ymm12
    vpmulhw %ymm0,  %ymm13, %ymm13
    vpsubw  %ymm11, %ymm8,  %ymm8 # a[2]*a[2]
    vpsubw  %ymm12, %ymm9,  %ymm9 # a[3]*a[3]
    vpsubw  %ymm13, %ymm10, %ymm10 # a[3]*a[1]

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
    vpsubw  %ymm11, %ymm9,  %ymm9 # a[2]*zeta
    vpsubw  %ymm14, %ymm1,  %ymm1 # a[3]*zeta

    #mul
    vpmullw %ymm13, %ymm9, %ymm11
    vpmullw %ymm13, %ymm1, %ymm14
    vpmulhw %ymm7,  %ymm9,  %ymm9
    vpmulhw %ymm7,  %ymm1,  %ymm1

    #reduce
    vpmulhw %ymm0,  %ymm11, %ymm11
    vpmulhw %ymm0,  %ymm14, %ymm14
    vpsubw  %ymm11, %ymm9,  %ymm9 # a[2]*t1*zeta
    vpsubw  %ymm14, %ymm1,  %ymm1 # a[3]*t1*zeta

    #mul
    vpmullw %ymm13, %ymm2, %ymm14
    vpmullw %ymm13, %ymm3, %ymm13
    vpmulhw %ymm7,  %ymm2, %ymm11
    vpmulhw %ymm7,  %ymm3, %ymm7

    #reduce
    vpmulhw %ymm0,  %ymm14, %ymm14
    vpmulhw %ymm0,  %ymm13, %ymm13
    vpsubw  %ymm14, %ymm11, %ymm11 # a[0]*t1
    vpsubw  %ymm13, %ymm7,  %ymm7 # a[1]*t1

    #mul
    vpmullw %ymm12, %ymm2, %ymm14
    vpmullw %ymm12, %ymm3, %ymm13
    vpmulhw %ymm6,  %ymm2, %ymm2
    vpmulhw %ymm6,  %ymm3, %ymm3

    #reduce
    vpmulhw %ymm0,  %ymm14, %ymm14
    vpmulhw %ymm0,  %ymm13, %ymm13
    vpsubw  %ymm14, %ymm2,  %ymm2 # a[0]*t0
    vpsubw  %ymm13, %ymm3,  %ymm3 # a[1]*t0

    #mul
    vpmullw %ymm12, %ymm4, %ymm13
    vpmullw %ymm12, %ymm5, %ymm14
    vpmulhw %ymm6,  %ymm4, %ymm4
    vpmulhw %ymm6,  %ymm5, %ymm5

    #reduce
    vpmulhw %ymm0,  %ymm13, %ymm13
    vpmulhw %ymm0,  %ymm14, %ymm14
    vpsubw  %ymm13, %ymm4,  %ymm4 # a[2]*t0
    vpsubw  %ymm14, %ymm5,  %ymm5 # a[3]*t0
  
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

    add $64,  %rdx
    add $128, %rdi
    add $128, %rsi
    cmp %r9,  %rdx
    jb  _loop_inner

    sub $384, %rdi

    vmovdqu 64(%rsp), %ymm1
    vmovdqu 32(%rsp), %ymm2
    vmovdqu  0(%rsp), %ymm3
    add          $96, %rsp

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
    jnz _loopend

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
   
    #load
    vmovdqa   (%rdi), %ymm4
    vmovdqa 32(%rdi), %ymm5
    vmovdqa 64(%rdi), %ymm6
    vmovdqa 96(%rdi), %ymm7

    #premul
    vpmullw %ymm15, %ymm1, %ymm14 #t2qinv

    #mul
    vpmullw %ymm14, %ymm4, %ymm10
    vpmullw %ymm14, %ymm5, %ymm11
    vpmullw %ymm14, %ymm6, %ymm12
    vpmullw %ymm14, %ymm7, %ymm13
    vpmulhw %ymm1,  %ymm4, %ymm4
    vpmulhw %ymm1,  %ymm5, %ymm5
    vpmulhw %ymm1,  %ymm6, %ymm6
    vpmulhw %ymm1,  %ymm7, %ymm7

    #reduce
    vpmulhw %ymm0,  %ymm10, %ymm10
    vpmulhw %ymm0,  %ymm11, %ymm11
    vpmulhw %ymm0,  %ymm12, %ymm12
    vpmulhw %ymm0,  %ymm13, %ymm13
    vpsubw  %ymm10, %ymm4,  %ymm4
    vpsubw  %ymm5,  %ymm11, %ymm5
    vpsubw  %ymm12, %ymm6,  %ymm6
    vpsubw  %ymm7,  %ymm13, %ymm7

    #store
    vmovdqa %ymm4,   (%rdi)
    vmovdqa %ymm5, 32(%rdi)
    vmovdqa %ymm6, 64(%rdi)
    vmovdqa %ymm7, 96(%rdi)

    #load
    vmovdqa 128(%rdi), %ymm4
    vmovdqa 160(%rdi), %ymm5
    vmovdqa 192(%rdi), %ymm6
    vmovdqa 224(%rdi), %ymm7

    #premul
    vpmullw %ymm15, %ymm2, %ymm14 #t2qinv

    #mul
    vpmullw %ymm14, %ymm4, %ymm10
    vpmullw %ymm14, %ymm5, %ymm11
    vpmullw %ymm14, %ymm6, %ymm12
    vpmullw %ymm14, %ymm7, %ymm13
    vpmulhw %ymm2,  %ymm4, %ymm4
    vpmulhw %ymm2,  %ymm5, %ymm5
    vpmulhw %ymm2,  %ymm6, %ymm6
    vpmulhw %ymm2,  %ymm7, %ymm7

    #reduce
    vpmulhw %ymm0,  %ymm10, %ymm10
    vpmulhw %ymm0,  %ymm11, %ymm11
    vpmulhw %ymm0,  %ymm12, %ymm12
    vpmulhw %ymm0,  %ymm13, %ymm13
    vpsubw  %ymm10, %ymm4,  %ymm4
    vpsubw  %ymm5,  %ymm11, %ymm5
    vpsubw  %ymm12, %ymm6,  %ymm6
    vpsubw  %ymm7,  %ymm13, %ymm7

    #store
    vmovdqa %ymm4, 128(%rdi)
    vmovdqa %ymm5, 160(%rdi)
    vmovdqa %ymm6, 192(%rdi)
    vmovdqa %ymm7, 224(%rdi)

    #load
    vmovdqa 256(%rdi), %ymm4
    vmovdqa 288(%rdi), %ymm5
    vmovdqa 320(%rdi), %ymm6
    vmovdqa 352(%rdi), %ymm7

    #premul
    vpmullw %ymm15, %ymm3, %ymm14 #t2qinv

    #mul
    vpmullw %ymm14, %ymm4, %ymm10
    vpmullw %ymm14, %ymm5, %ymm11
    vpmullw %ymm14, %ymm6, %ymm12
    vpmullw %ymm14, %ymm7, %ymm13
    vpmulhw %ymm3,  %ymm4, %ymm4
    vpmulhw %ymm3,  %ymm5, %ymm5
    vpmulhw %ymm3,  %ymm6, %ymm6
    vpmulhw %ymm3,  %ymm7, %ymm7

    #reduce
    vpmulhw %ymm0,  %ymm10, %ymm10
    vpmulhw %ymm0,  %ymm11, %ymm11
    vpmulhw %ymm0,  %ymm12, %ymm12
    vpmulhw %ymm0,  %ymm13, %ymm13
    vpsubw  %ymm10, %ymm4,  %ymm4
    vpsubw  %ymm5,  %ymm11, %ymm5
    vpsubw  %ymm12, %ymm6,  %ymm6
    vpsubw  %ymm7,  %ymm13, %ymm7

    #store
    vmovdqa %ymm4, 256(%rdi)
    vmovdqa %ymm5, 288(%rdi)
    vmovdqa %ymm6, 320(%rdi)
    vmovdqa %ymm7, 352(%rdi)

    add $384, %rdi
    cmp %r8,  %rsi
    jb  _looptop

    xor %rax, %rax

    ret

    _loopend:
    mov $1, %rax

    ret
