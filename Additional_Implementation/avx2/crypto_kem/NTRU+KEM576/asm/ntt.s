.global poly_ntt
poly_ntt:
vmovdqa _16xq(%rip), %ymm0
vmovdqa _16xv(%rip), %ymm1
lea     zetas(%rip), %rdx

#level0
#zetas
vpbroadcastd  (%rdx), %ymm15
vpbroadcastd 4(%rdx), %ymm2

lea 576(%rsi), %r8

.p2align 5
_looptop_j_0:
#load
vmovdqa    (%rsi), %ymm3
vmovdqa  32(%rsi), %ymm4
vmovdqa  64(%rsi), %ymm5
vmovdqa 576(%rsi), %ymm6
vmovdqa 608(%rsi), %ymm7
vmovdqa 640(%rsi), %ymm8

#mul
vpmullw %ymm15, %ymm6, %ymm12
vpmullw %ymm15, %ymm7, %ymm13
vpmullw %ymm15, %ymm8, %ymm14
vpmulhw %ymm2,  %ymm6, %ymm9
vpmulhw %ymm2,  %ymm7, %ymm10
vpmulhw %ymm2,  %ymm8, %ymm11

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm12, %ymm9,  %ymm12
vpsubw  %ymm13, %ymm10, %ymm13
vpsubw  %ymm14, %ymm11, %ymm14

#update
vpaddw %ymm12, %ymm3,  %ymm9
vpaddw %ymm13, %ymm4,  %ymm10
vpaddw %ymm14, %ymm5,  %ymm11
vpsubw %ymm12, %ymm3,  %ymm12
vpsubw %ymm13, %ymm4,  %ymm13
vpsubw %ymm14, %ymm5,  %ymm14
vpaddw %ymm6,  %ymm12, %ymm12
vpaddw %ymm7,  %ymm13, %ymm13
vpaddw %ymm8,  %ymm14, %ymm14

#store
vmovdqa %ymm9,     (%rdi)
vmovdqa %ymm10,  32(%rdi)
vmovdqa %ymm11,  64(%rdi)
vmovdqa %ymm12, 576(%rdi)
vmovdqa %ymm13, 608(%rdi)
vmovdqa %ymm14, 640(%rdi)

add $96, %rsi
add $96, %rdi
cmp %r8, %rsi
jb _looptop_j_0

sub $576, %rdi

#level 1
#load
vmovdqa _16xwqinv(%rip), %ymm2 #winv
vmovdqa     _16xw(%rip), %ymm3 #w

lea 1152(%rdi), %r8

.p2align 5
_looptop_start_1:
#zetas
vpbroadcastd  8(%rdx), %ymm4 #ainv
vpbroadcastd 16(%rdx), %ymm5 #a^2inv
vpbroadcastd 12(%rdx), %ymm6 #a
vpbroadcastd 20(%rdx), %ymm7 #a^2

lea 192(%rdi), %r9

.p2align 5
_looptop_j_1:
#load
vmovdqa    (%rdi), %ymm8
vmovdqa 192(%rdi), %ymm9
vmovdqa 384(%rdi), %ymm10

#mul Ba, Ca^2
vpmullw %ymm4, %ymm9,  %ymm11
vpmullw %ymm5, %ymm10, %ymm12
vpmulhw %ymm6, %ymm9,  %ymm9
vpmulhw %ymm7, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm11, %ymm9,  %ymm9
vpsubw  %ymm12, %ymm10, %ymm10

#sub (Ba-Ca^2)
vpsubw %ymm10, %ymm9, %ymm11

#mul w(Ba-Ca^2)
vpmullw %ymm2, %ymm11, %ymm12
vpmulhw %ymm3, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm12, %ymm11, %ymm11

#update
vpaddw %ymm9,  %ymm8,  %ymm12 #A + Ba
vpsubw %ymm10, %ymm8,  %ymm13 #A - Ca^2
vpsubw %ymm9,  %ymm8,  %ymm14 #A - Ba
vpaddw %ymm10, %ymm12, %ymm12 #A + Ba + Ca^2
vpaddw %ymm11, %ymm13, %ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw %ymm11, %ymm14, %ymm14 #A - Ba - w(Ba-Ca^2)

#store
vmovdqa %ymm12,    (%rdi)
vmovdqa %ymm13, 192(%rdi)
vmovdqa %ymm14, 384(%rdi)

add $32, %rdi
cmp %r9, %rdi
jb  _looptop_j_1

add $384, %rdi
add $16,  %rdx
cmp %r8,  %rdi
jb _looptop_start_1

sub $1152, %rdi

#level 2
lea 1152(%rdi), %r8

.p2align 5
_looptop_start_2:
#zetas
vpbroadcastd  8(%rdx), %ymm4 #ainv
vpbroadcastd 16(%rdx), %ymm5 #a^2inv
vpbroadcastd 12(%rdx), %ymm6 #a
vpbroadcastd 20(%rdx), %ymm7 #a^2

lea 64(%rdi), %r9

.p2align 5
_looptop_j_2:
#load
vmovdqa    (%rdi), %ymm8
vmovdqa  64(%rdi), %ymm9
vmovdqa 128(%rdi), %ymm10

#mul Ba, Ca^2
vpmullw %ymm4, %ymm9,  %ymm11
vpmullw %ymm5, %ymm10, %ymm12
vpmulhw %ymm6, %ymm9,  %ymm9
vpmulhw %ymm7, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm11, %ymm9,  %ymm9
vpsubw  %ymm12, %ymm10, %ymm10

#sub (Ba-Ca^2)
vpsubw %ymm10, %ymm9, %ymm11

#mul w(Ba-Ca^2)
vpmullw %ymm2, %ymm11, %ymm12
vpmulhw %ymm3, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm12, %ymm11, %ymm11

#update
vpaddw %ymm9,  %ymm8,  %ymm12 #A + Ba
vpsubw %ymm10, %ymm8,  %ymm13 #A - Ca^2
vpsubw %ymm9,  %ymm8,  %ymm14 #A - Ba
vpaddw %ymm10, %ymm12, %ymm12 #A + Ba + Ca^2
vpaddw %ymm11, %ymm13, %ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw %ymm11, %ymm14, %ymm14 #A - Ba - w(Ba-Ca^2)

#store
vmovdqa %ymm12,    (%rdi)
vmovdqa %ymm13,  64(%rdi)
vmovdqa %ymm14, 128(%rdi)

add $32, %rdi
cmp %r9, %rdi
jb _looptop_j_2

add $128, %rdi
add $16,  %rdx
cmp %r8,  %rdi
jb _looptop_start_2

sub $1152, %rdi

lea 1152(%rdi), %r8

.p2align 5
_looptop_start_345:
#load
vmovdqa   (%rdi), %ymm3
vmovdqa 32(%rdi), %ymm4
vmovdqa 64(%rdi), %ymm5
vmovdqa 96(%rdi), %ymm6

#level3
#zetas
vmovdqa 32(%rdx), %ymm15 #zetaqinv
vmovdqa 64(%rdx), %ymm2  #zeta

#shuffle
vperm2i128 $0x20, %ymm5, %ymm3, %ymm7
vperm2i128 $0x31, %ymm5, %ymm3, %ymm8
vperm2i128 $0x20, %ymm6, %ymm4, %ymm9
vperm2i128 $0x31, %ymm6, %ymm4, %ymm10

#mul
vpmullw %ymm15, %ymm9,  %ymm11
vpmullw %ymm15, %ymm10, %ymm12
vpmulhw %ymm2,  %ymm9,  %ymm13
vpmulhw %ymm2,  %ymm10, %ymm14

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm11, %ymm13, %ymm13
vpsubw  %ymm12, %ymm14, %ymm14

#update
vpaddw %ymm13, %ymm7, %ymm3
vpaddw %ymm14, %ymm8, %ymm4
vpsubw %ymm13, %ymm7, %ymm5
vpsubw %ymm14, %ymm8, %ymm6

#level4
#zetas
vmovdqa 608(%rdx), %ymm15 #zetaqinv
vmovdqa 640(%rdx), %ymm2  #zeta

#shuffle
vpunpcklqdq %ymm5, %ymm3, %ymm7
vpunpckhqdq %ymm5, %ymm3, %ymm8
vpunpcklqdq %ymm6, %ymm4, %ymm9
vpunpckhqdq %ymm6, %ymm4, %ymm10

#mul
vpmullw %ymm15, %ymm9,  %ymm11
vpmullw %ymm15, %ymm10, %ymm12
vpmulhw %ymm2,  %ymm9,  %ymm13
vpmulhw %ymm2,  %ymm10, %ymm14

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm11, %ymm13, %ymm13
vpsubw  %ymm12, %ymm14, %ymm14

#update
vpaddw %ymm13, %ymm7, %ymm3
vpaddw %ymm14, %ymm8, %ymm4
vpsubw %ymm13, %ymm7, %ymm5
vpsubw %ymm14, %ymm8, %ymm6

#level5
#zetas
vmovdqa 1184(%rdx), %ymm15 #zetaqinv
vmovdqa 1216(%rdx), %ymm2  #zeta

#shuffle
vpsllq   $32,   %ymm5, %ymm7
vpsrlq   $32,   %ymm3, %ymm8
vpsllq   $32,   %ymm6, %ymm9
vpsrlq   $32,   %ymm4, %ymm10
vpblendd $0xAA, %ymm7, %ymm3,  %ymm7
vpblendd $0xAA, %ymm5, %ymm8,  %ymm8
vpblendd $0xAA, %ymm9, %ymm4,  %ymm9
vpblendd $0xAA, %ymm6, %ymm10, %ymm10

#mul
vpmullw %ymm15, %ymm9,  %ymm11
vpmullw %ymm15, %ymm10, %ymm12
vpmulhw %ymm2,  %ymm9,  %ymm13
vpmulhw %ymm2,  %ymm10, %ymm14

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm11, %ymm13, %ymm13
vpsubw  %ymm12, %ymm14, %ymm14

#update
vpaddw %ymm13, %ymm7, %ymm3
vpaddw %ymm14, %ymm8, %ymm4
vpsubw %ymm13, %ymm7, %ymm5
vpsubw %ymm14, %ymm8, %ymm6

#reduce2
vpmulhw %ymm1, %ymm3, %ymm7
vpmulhw %ymm1, %ymm4, %ymm8
vpmulhw %ymm1, %ymm5, %ymm9
vpmulhw %ymm1, %ymm6, %ymm10

vpsraw $10, %ymm7,  %ymm7
vpsraw $10, %ymm8,  %ymm8
vpsraw $10, %ymm9,  %ymm9
vpsraw $10, %ymm10, %ymm10

vpmullw %ymm0, %ymm7,  %ymm7
vpmullw %ymm0, %ymm8,  %ymm8
vpmullw %ymm0, %ymm9,  %ymm9
vpmullw %ymm0, %ymm10, %ymm10

vpsubw %ymm7,  %ymm3, %ymm3
vpsubw %ymm8,  %ymm4, %ymm4
vpsubw %ymm9,  %ymm5, %ymm5
vpsubw %ymm10, %ymm6, %ymm6

#shuffle
vpsllq   $16,   %ymm5, %ymm7
vpsrlq   $16,   %ymm3, %ymm8
vpsllq   $16,   %ymm6, %ymm9
vpsrlq   $16,   %ymm4, %ymm10
vpblendw $0xAA, %ymm7, %ymm3,  %ymm7
vpblendw $0xAA, %ymm5, %ymm8,  %ymm8
vpblendw $0xAA, %ymm9, %ymm4,  %ymm9
vpblendw $0xAA, %ymm6, %ymm10, %ymm10

#store
vmovdqa %ymm7,    (%rdi)
vmovdqa %ymm8,  32(%rdi)
vmovdqa %ymm9,  64(%rdi)
vmovdqa %ymm10, 96(%rdi)

add $128, %rdi
add $64,  %rdx
cmp %r8,  %rdi
jb _looptop_start_345

ret
