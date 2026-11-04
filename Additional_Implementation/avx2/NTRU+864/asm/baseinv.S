#include "asm.h"

/*
 * References:
 *
 * [Sei18] Gregor Seiler,
 * "Faster AVX2 optimized NTT multiplication for Ring-LWE lattice cryptography",
 * Cryptology ePrint Archive, Paper 2018/039, 2018.
 * https://eprint.iacr.org/2018/039
 *
 * [KCP26] Jonghyun Kim, Haehyun Cho, and Jong Hwan Park,
 * "Accelerating NTRU+ Key Generation via Hierarchical Batch Inversion",
 * Cryptology ePrint Archive, Paper 2026/1191, 2026.
 * https://eprint.iacr.org/2026/1191
 */


.balign 32
NTRUPLUS_ASM_START(poly_baseinv)
push %r12
push %r13
push %r14
push %r15

//stack
mov %rsp, %r11
and $-32, %rsp
#ifdef NTRUPLUS_SUPERCOP
sub $1280, %rsp
#else
sub $1152, %rsp
#endif

//pointers
mov %rdi, %r12
mov %rsi, %rdx
mov %rsp, %r14
lea 576(%rsp), %r15
mov %r14, %rsi

//baseinv_1
vmovdqa    NTRUPLUS_ASM_SYMBOL(16xq)(%rip),  %ymm0
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15
lea NTRUPLUS_ASM_SYMBOL(zetas)+1888(%rip), %r9

lea 1728(%rdi), %r8

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_baseinv_1):

//zeta
vmovdqa   (%r9), %ymm14 //zeta*qinv
vmovdqa 32(%r9),  %ymm1 //zeta

//load
vmovdqa   (%rdx), %ymm3
vmovdqa 32(%rdx), %ymm5
vmovdqa 64(%rdx), %ymm7

//premul
vpmullw %ymm15, %ymm3, %ymm2 //a[0]*qinv
vpmullw %ymm15, %ymm5, %ymm4 //a[1]*qinv
vpmullw %ymm15, %ymm7, %ymm6 //a[2]*qinv

//mul
vpmullw  %ymm5, %ymm14,  %ymm8 //a[1]*zeta
vpmullw  %ymm7, %ymm14, %ymm10 //a[2]*zeta
vpmullw  %ymm7,  %ymm2, %ymm12 //a[0]*a[2]
vpmullw  %ymm5,  %ymm4, %ymm14 //a[1]*a[1]
vpmulhw  %ymm5,  %ymm1,  %ymm9
vpmulhw  %ymm7,  %ymm1, %ymm11
vpmulhw  %ymm7,  %ymm3, %ymm13
vpmulhw  %ymm5,  %ymm5,  %ymm1
vpmulhw  %ymm0,  %ymm8,  %ymm8
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw   %ymm8,  %ymm9,  %ymm8
vpsubw  %ymm10, %ymm11,  %ymm9
vpsubw  %ymm12, %ymm13, %ymm10
vpsubw  %ymm14,  %ymm1, %ymm11

//add
vpsubw %ymm10, %ymm11, %ymm10 //r[2] = a[1]*a[1]-a[0]*a[2]

//mul
vpmullw  %ymm3,  %ymm2, %ymm11 //a[0]*a[0]
vpmullw  %ymm9,  %ymm4, %ymm13 //a[2]*zeta*a[1]
vpmullw  %ymm9,  %ymm6,  %ymm6 //a[2]*zeta*a[2]
vpmullw  %ymm5,  %ymm2,  %ymm4 //a[1]*a[0]
vpmulhw  %ymm3,  %ymm3, %ymm12
vpmulhw  %ymm9,  %ymm5, %ymm14
vpmulhw  %ymm9,  %ymm7,  %ymm7
vpmulhw  %ymm5,  %ymm3,  %ymm5
vpmulhw  %ymm0, %ymm11, %ymm11
vpmulhw  %ymm0, %ymm13, %ymm13
vpmulhw  %ymm0,  %ymm6,  %ymm6
vpmulhw  %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm11, %ymm12, %ymm11
vpsubw  %ymm13, %ymm14, %ymm12
vpsubw   %ymm6,  %ymm7,  %ymm6
vpsubw   %ymm4,  %ymm5,  %ymm7

//add
vpsubw %ymm12, %ymm11, %ymm11 //r[0] = a[0]*a[0]-a[2]*zeta*a[1]
vpsubw  %ymm7,  %ymm6,  %ymm6 //r[1] = a[2]*zeta*a[2]-a[1]*a[0]

//premul
vpmullw %ymm15, %ymm8,  %ymm1 //a[1]*zeta*qinv
vpmullw %ymm15, %ymm9, %ymm13 //a[2]*zeta*qinv

//mul
vpmullw %ymm10,  %ymm1, %ymm12 //r[2]*a[1]*zeta
vpmullw  %ymm6, %ymm13, %ymm14 //r[1]*a[2]*zeta
vpmullw %ymm11,  %ymm2,  %ymm4 //r[0]*a[0]
vpmulhw %ymm10,  %ymm8, %ymm13
vpmulhw  %ymm6,  %ymm9,  %ymm1
vpmulhw %ymm11,  %ymm3,  %ymm5
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14,  %ymm1, %ymm13
vpsubw   %ymm4,  %ymm5, %ymm14

//add
vpaddw %ymm12, %ymm13, %ymm12
vpaddw %ymm12, %ymm14,  %ymm8 //den = r[0]*a[0]+r[1]*a[2]*zeta+r[2]*a[1]*zeta

//store
vmovdqa %ymm11,   (%rdi)
vmovdqa  %ymm6, 32(%rdi)
vmovdqa %ymm10, 64(%rdi)

vmovdqu %ymm8, (%rsi) //den

//negative zeta
//load
vmovdqa  96(%rdx),  %ymm3
vmovdqa 128(%rdx),  %ymm5
vmovdqa 160(%rdx),  %ymm7
vmovdqa     (%r9), %ymm14 //zeta*qinv
vmovdqa   32(%r9),  %ymm1 //zeta

//premul
vpmullw %ymm15, %ymm3, %ymm2 //a[0]*qinv
vpmullw %ymm15, %ymm5, %ymm4 //a[1]*qinv
vpmullw %ymm15, %ymm7, %ymm6 //a[2]*qinv

//mul
vpmullw  %ymm5, %ymm14,  %ymm8 //a[1]*zeta
vpmullw  %ymm7, %ymm14, %ymm10 //a[2]*zeta
vpmullw  %ymm7,  %ymm2, %ymm12 //a[0]*a[2]
vpmullw  %ymm5,  %ymm4, %ymm14 //a[1]*a[1]
vpmulhw  %ymm5,  %ymm1,  %ymm9
vpmulhw  %ymm7,  %ymm1, %ymm11
vpmulhw  %ymm7,  %ymm3, %ymm13
vpmulhw  %ymm5,  %ymm5,  %ymm1
vpmulhw  %ymm0,  %ymm8,  %ymm8
vpmulhw  %ymm0, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw   %ymm8,  %ymm9,  %ymm8
vpsubw  %ymm10, %ymm11,  %ymm9
vpsubw  %ymm12, %ymm13, %ymm10
vpsubw  %ymm14,  %ymm1, %ymm11

//add
vpsubw %ymm10, %ymm11, %ymm10 //r[2] = a[1]*a[1]-a[0]*a[2]

//mul
vpmullw  %ymm3,  %ymm2, %ymm11 //a[0]*a[0]
vpmullw  %ymm9,  %ymm4, %ymm13 //a[2]*zeta*a[1]
vpmullw  %ymm9,  %ymm6,  %ymm6 //a[2]*zeta*a[2]
vpmullw  %ymm5,  %ymm2,  %ymm4 //a[1]*a[0]
vpmulhw  %ymm3,  %ymm3, %ymm12
vpmulhw  %ymm9,  %ymm5, %ymm14
vpmulhw  %ymm9,  %ymm7,  %ymm7
vpmulhw  %ymm5,  %ymm3,  %ymm5
vpmullw %ymm15,  %ymm8,  %ymm1 //a[1]*zeta*qinv
vpmulhw  %ymm0, %ymm11, %ymm11
vpmulhw  %ymm0, %ymm13, %ymm13
vpmulhw  %ymm0,  %ymm6,  %ymm6
vpmulhw  %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm11, %ymm12, %ymm11
vpsubw  %ymm13, %ymm14, %ymm12
vpmullw %ymm15,  %ymm9, %ymm13 //a[2]*zeta*qinv
vpsubw   %ymm6,  %ymm7,  %ymm6
vpsubw   %ymm4,  %ymm5,  %ymm7

//add
vpaddw %ymm12, %ymm11, %ymm11 //r[0] = a[0]*a[0]+a[2]*zeta*a[1]
vpaddw  %ymm7,  %ymm6,  %ymm6
vpsubw  %ymm6,  %ymm0,  %ymm6 //r[1] = -a[2]*zeta*a[2]-a[1]*a[0] modulo q

//mul
vpmullw %ymm10,  %ymm1, %ymm12 //r[2]*a[1]*zeta
vpmullw  %ymm6, %ymm13, %ymm14 //r[1]*a[2]*zeta
vpmullw %ymm11,  %ymm2,  %ymm4 //r[0]*a[0]
vpmulhw %ymm10,  %ymm8, %ymm13
vpmulhw  %ymm6,  %ymm9,  %ymm1
vpmulhw %ymm11,  %ymm3,  %ymm5
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14,  %ymm1, %ymm13
vpsubw   %ymm4,  %ymm5, %ymm14

//add
vpaddw %ymm12, %ymm13, %ymm12
vpsubw %ymm12, %ymm14,  %ymm8 //den = r[0]*a[0]-r[1]*a[2]*zeta-r[2]*a[1]*zeta

//store
vmovdqa %ymm11,  96(%rdi)
vmovdqa  %ymm6, 128(%rdi)
vmovdqa %ymm10, 160(%rdi)

vmovdqu %ymm8, 32(%rsi) //den

add $64,  %r9
add $64,  %rsi
add $192, %rdi
add $192, %rdx

cmp %r8,  %rdi
jb  NTRUPLUS_ASM_LOCAL(looptop_baseinv_1)

//product_chain - level 0
//load
vmovdqa   0(%r14),  %ymm2
vmovdqa  32(%r14),  %ymm3
vmovdqa  64(%r14),  %ymm4
vmovdqa  96(%r14),  %ymm5
vmovdqa 128(%r14),  %ymm6
vmovdqa 160(%r14),  %ymm7
vmovdqa 192(%r14),  %ymm8
vmovdqa 224(%r14),  %ymm9
vmovdqa 256(%r14), %ymm10

//premul
vpmullw %ymm15,  %ymm8, %ymm11
vpmullw %ymm15,  %ymm9, %ymm12
vpmullw %ymm15, %ymm10, %ymm13

//mul
vpmullw %ymm11,  %ymm2, %ymm11 //pc[0] = den[0]*den[6]
vpmullw %ymm12,  %ymm3, %ymm12 //pc[1] = den[1]*den[7]
vpmullw %ymm13,  %ymm4, %ymm13 //pc[2] = den[2]*den[8]
vpmulhw  %ymm8,  %ymm2,  %ymm2
vpmulhw  %ymm9,  %ymm3,  %ymm3
vpmulhw %ymm10,  %ymm4,  %ymm4
vpmulhw  %ymm0, %ymm11, %ymm11
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm13, %ymm13
vpsubw  %ymm11,  %ymm2,  %ymm2
vpsubw  %ymm12,  %ymm3,  %ymm3
vpsubw  %ymm13,  %ymm4,  %ymm4

//load
vmovdqa 288(%r14),  %ymm8
vmovdqa 320(%r14),  %ymm9
vmovdqa 352(%r14), %ymm10

//premul
vpmullw %ymm15,  %ymm8, %ymm11
vpmullw %ymm15,  %ymm9, %ymm12
vpmullw %ymm15, %ymm10, %ymm13

//mul
vpmullw %ymm11,  %ymm5, %ymm11 //pc[3] = den[3]*den[9]
vpmullw %ymm12,  %ymm6, %ymm12 //pc[4] = den[4]*den[10]
vpmullw %ymm13,  %ymm7, %ymm13 //pc[5] = den[5]*den[11]
vpmulhw  %ymm8,  %ymm5,  %ymm5
vpmulhw  %ymm9,  %ymm6,  %ymm6
vpmulhw %ymm10,  %ymm7,  %ymm7
vpmulhw  %ymm0, %ymm11, %ymm11
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm13, %ymm13
vpsubw  %ymm11,  %ymm5,  %ymm5
vpsubw  %ymm12,  %ymm6,  %ymm6
vpsubw  %ymm13,  %ymm7,  %ymm7

//store
vmovdqa %ymm2,   0(%r15)
vmovdqa %ymm3,  32(%r15)
vmovdqa %ymm4,  64(%r15)
vmovdqa %ymm5,  96(%r15)
vmovdqa %ymm6, 128(%r15)
vmovdqa %ymm7, 160(%r15)

//load
vmovdqa 384(%r14),  %ymm8
vmovdqa 416(%r14),  %ymm9
vmovdqa 448(%r14), %ymm10

//premul
vpmullw %ymm15,  %ymm8, %ymm11
vpmullw %ymm15,  %ymm9, %ymm12
vpmullw %ymm15, %ymm10, %ymm13

//mul
vpmullw %ymm11,  %ymm2, %ymm11 //pc[6] = pc[0]*den[12]
vpmullw %ymm12,  %ymm3, %ymm12 //pc[7] = pc[1]*den[13]
vpmullw %ymm13,  %ymm4, %ymm13 //pc[8] = pc[2]*den[14]
vpmulhw  %ymm8,  %ymm2,  %ymm2
vpmulhw  %ymm9,  %ymm3,  %ymm3
vpmulhw %ymm10,  %ymm4,  %ymm4
vpmulhw  %ymm0, %ymm11, %ymm11
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm13, %ymm13
vpsubw  %ymm11,  %ymm2,  %ymm2
vpsubw  %ymm12,  %ymm3,  %ymm3
vpsubw  %ymm13,  %ymm4,  %ymm4

//load
vmovdqa 480(%r14),  %ymm8
vmovdqa 512(%r14),  %ymm9
vmovdqa 544(%r14), %ymm10

//premul
vpmullw %ymm15,  %ymm8, %ymm11
vpmullw %ymm15,  %ymm9, %ymm12
vpmullw %ymm15, %ymm10, %ymm13

//mul
vpmullw %ymm11,  %ymm5, %ymm11 //pc[9] = pc[3]*den[15]
vpmullw %ymm12,  %ymm6, %ymm12 //pc[10] = pc[4]*den[16]
vpmullw %ymm13,  %ymm7, %ymm13 //pc[11] = pc[5]*den[17]
vpmulhw  %ymm8,  %ymm5,  %ymm5
vpmulhw  %ymm9,  %ymm6,  %ymm6
vpmulhw %ymm10,  %ymm7,  %ymm7
vpmulhw  %ymm0, %ymm11, %ymm11
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm13, %ymm13
vpsubw  %ymm11,  %ymm5,  %ymm5
vpsubw  %ymm12,  %ymm6,  %ymm6
vpsubw  %ymm13,  %ymm7,  %ymm7

//store
vmovdqa %ymm2, 192(%r15)
vmovdqa %ymm3, 224(%r15)
vmovdqa %ymm4, 256(%r15)
vmovdqa %ymm5, 288(%r15)
vmovdqa %ymm6, 320(%r15)
vmovdqa %ymm7, 352(%r15)

//product_chain - level 1
//premul
vpmullw %ymm15, %ymm3, %ymm11
vpmullw %ymm15, %ymm5, %ymm12
vpmullw %ymm15, %ymm7, %ymm13

//mul
vpmullw %ymm11,  %ymm2, %ymm11 //tree[0] = pc[6]*pc[7]
vpmullw %ymm12,  %ymm4, %ymm12 //tree[1] = pc[8]*pc[9]
vpmullw %ymm13,  %ymm6, %ymm13 //tree[2] = pc[10]*pc[11]
vpmulhw  %ymm3,  %ymm2,  %ymm8
vpmulhw  %ymm5,  %ymm4,  %ymm9
vpmulhw  %ymm7,  %ymm6, %ymm10
vpmulhw  %ymm0, %ymm11, %ymm11
vpmulhw  %ymm0, %ymm12, %ymm12
vpmulhw  %ymm0, %ymm13, %ymm13
vpsubw  %ymm11,  %ymm8,  %ymm8
vpsubw  %ymm12,  %ymm9,  %ymm9
vpsubw  %ymm13, %ymm10, %ymm10

//product_chain - level 2
//premul
vpmullw %ymm15,  %ymm9, %ymm14
vpmullw %ymm15, %ymm10,  %ymm1

//mul
vpmullw %ymm14,  %ymm8, %ymm14 //tree[3] = tree[0]*tree[1]
vpmulhw  %ymm9,  %ymm8, %ymm11
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14, %ymm11, %ymm11

//mul
vpmullw  %ymm1, %ymm11,  %ymm1 //tree[4] = tree[3]*tree[2]
vpmulhw %ymm10, %ymm11, %ymm12
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpsubw   %ymm1, %ymm12, %ymm12

//store
vmovdqa  %ymm8, 384(%r15)
vmovdqa  %ymm9, 416(%r15)
vmovdqa %ymm10, 448(%r15)
vmovdqa %ymm11, 480(%r15)
vmovdqa %ymm12, 512(%r15)

//check_zero
vpxor    %ymm2,  %ymm2, %ymm2
vpcmpeqw %ymm2, %ymm12, %ymm2
vptest %ymm2, %ymm2
setnz %r13b
movzbl %r13b, %r13d
#ifdef NTRUPLUS_SUPERCOP
//declassify the failure flag before branching
movl %r13d, 1120(%rsp)

//request
movq $1296236546, 1128(%rsp) //VALGRIND_MAKE_MEM_DEFINED
lea 1120(%rsp), %rax
movq %rax, 1136(%rsp)        //address
movq $4, 1144(%rsp)          //size
movq $0, 1152(%rsp)
movq $0, 1160(%rsp)
movq $0, 1168(%rsp)
lea 1128(%rsp), %rax

//execute request
xor %edx, %edx
rolq $3, %rdi
rolq $13, %rdi
rolq $61, %rdi
rolq $51, %rdi
xchgq %rbx, %rbx
movl 1120(%rsp), %r13d
#endif
test %r13d, %r13d
jnz NTRUPLUS_ASM_LOCAL(baseinv_fail)

//fqinv
//load
vmovdqa 512(%r15), %ymm2

//premul
vpmullw %ymm15, %ymm2, %ymm14

//mul
vpmullw %ymm14,  %ymm2, %ymm14 //t0 = a*a
vpmulhw  %ymm2,  %ymm2,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm3,  %ymm3

//scale
vpsllw $4, %ymm3, %ymm3 //t0 = 16*t0

//premul
vpmullw %ymm15, %ymm3, %ymm14

//mul
vpmullw %ymm14,  %ymm3, %ymm14 //t0 = t0*t0
vpmulhw  %ymm3,  %ymm3,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm3,  %ymm3

//premul
vpmullw %ymm15, %ymm3, %ymm14

//mul
vpmullw %ymm14,  %ymm3, %ymm14 //t0 = t0*t0
vpmulhw  %ymm3,  %ymm3,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm3,  %ymm3

//premul
vpmullw %ymm15, %ymm3, %ymm14

//mul
vpmullw %ymm14,  %ymm3, %ymm14 //t0 = t0*t0
vpmulhw  %ymm3,  %ymm3,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm3,  %ymm3

//premul
vpmullw %ymm15, %ymm3, %ymm5

//mul
vpmullw  %ymm5,  %ymm2, %ymm14 //t1 = a*t0
vpmullw  %ymm5,  %ymm3,  %ymm1 //t0 = t0*t0
vpmulhw  %ymm3,  %ymm2,  %ymm4
vpmulhw  %ymm3,  %ymm3,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpsubw  %ymm14,  %ymm4,  %ymm4
vpsubw   %ymm1,  %ymm3,  %ymm3

//premul
vpmullw %ymm15, %ymm3, %ymm14

//mul
vpmullw %ymm14,  %ymm3, %ymm14 //t0 = t0*t0
vpmulhw  %ymm3,  %ymm3,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm3,  %ymm3

//premul
vpmullw %ymm15, %ymm3, %ymm14

//mul
vpmullw %ymm14,  %ymm3, %ymm14 //t0 = t0*t0
vpmulhw  %ymm3,  %ymm3,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm3,  %ymm3

//premul
vpmullw %ymm15, %ymm3, %ymm5

//mul
vpmullw  %ymm5,  %ymm4, %ymm14 //t1 = t1*t0
vpmulhw  %ymm3,  %ymm4,  %ymm4
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm4,  %ymm4

//mul
vpmullw  %ymm5,  %ymm4, %ymm14 //t0 = t1*t0
vpmulhw  %ymm3,  %ymm4,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm3,  %ymm3

//premul
vpmullw %ymm15, %ymm3, %ymm5

//mul
vpmullw  %ymm5,  %ymm4, %ymm14 //t1 = t1*t0
vpmulhw  %ymm3,  %ymm4,  %ymm4
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm4,  %ymm4

//mul
vpmullw  %ymm5,  %ymm4, %ymm14 //t1 = t1*t0
vpmulhw  %ymm3,  %ymm4,  %ymm4
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm4,  %ymm4

//premul
vpmullw %ymm15, %ymm4, %ymm5

//mul
vpmullw  %ymm5,  %ymm4, %ymm14 //t0 = t1*t1
vpmulhw  %ymm4,  %ymm4,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm3,  %ymm3

//premul
vpmullw %ymm15, %ymm3, %ymm14

//mul
vpmullw %ymm14,  %ymm3, %ymm14 //t0 = t0*t0
vpmulhw  %ymm3,  %ymm3,  %ymm3
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm3,  %ymm3

//mul
vpmullw  %ymm5,  %ymm3, %ymm14 //inv = t0*t1
vpmulhw  %ymm4,  %ymm3,  %ymm2
vpmulhw  %ymm0, %ymm14, %ymm14
vpsubw  %ymm14,  %ymm2,  %ymm2

//recover_inv - level 2
//load
vmovdqa 448(%r15), %ymm4
vmovdqa 480(%r15), %ymm5

//premul
vpmullw %ymm15, %ymm2, %ymm3

//mul
vpmullw %ymm3, %ymm4, %ymm8 //t = tree[2]*inv
vpmullw %ymm3, %ymm5, %ymm9 //tree_inv[2] = tree[3]*inv
vpmulhw %ymm2, %ymm4, %ymm6
vpmulhw %ymm2, %ymm5, %ymm7
vpmulhw %ymm0, %ymm8, %ymm8
vpmulhw %ymm0, %ymm9, %ymm9
vpsubw  %ymm8, %ymm6, %ymm6
vpsubw  %ymm9, %ymm7, %ymm7

//load
vmovdqa 416(%r15), %ymm8
vmovdqa 384(%r15), %ymm9

//premul
vpmullw %ymm15, %ymm6, %ymm10

//mul
vpmullw %ymm10,  %ymm8, %ymm14 //tree_inv[0] = tree[1]*t
vpmullw %ymm10,  %ymm9,  %ymm1 //tree_inv[1] = tree[0]*t
vpmulhw  %ymm6,  %ymm8, %ymm11
vpmulhw  %ymm6,  %ymm9, %ymm12
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpsubw  %ymm14, %ymm11, %ymm11
vpsubw   %ymm1, %ymm12, %ymm12

//recover_inv - level 1
//load
vmovdqa     %ymm7, %ymm13
vmovdqa 192(%r15),  %ymm2
vmovdqa 224(%r15),  %ymm3
vmovdqa 256(%r15),  %ymm4
vmovdqa 288(%r15),  %ymm5
vmovdqa 320(%r15),  %ymm6
vmovdqa 352(%r15),  %ymm7

//premul
vpmullw %ymm15, %ymm11,  %ymm8
vpmullw %ymm15, %ymm12,  %ymm9
vpmullw %ymm15, %ymm13, %ymm10

//mul
vpmullw  %ymm8,  %ymm2, %ymm14 //acc[0] = pc[6]*tree_inv[0]
vpmullw  %ymm8,  %ymm3,  %ymm1 //acc[1] = pc[7]*tree_inv[0]
vpmullw  %ymm9,  %ymm4,  %ymm8 //acc[2] = pc[8]*tree_inv[1]
vpmulhw %ymm11,  %ymm2,  %ymm2
vpmulhw %ymm11,  %ymm3,  %ymm3
vpmulhw %ymm12,  %ymm4,  %ymm4
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0,  %ymm8,  %ymm8
vpsubw  %ymm14,  %ymm2,  %ymm2
vpsubw   %ymm1,  %ymm3,  %ymm3
vpsubw   %ymm8,  %ymm4,  %ymm4

//mul
vpmullw  %ymm9,  %ymm5, %ymm14 //acc[3] = pc[9]*tree_inv[1]
vpmullw %ymm10,  %ymm6,  %ymm1 //acc[4] = pc[10]*tree_inv[2]
vpmullw %ymm10,  %ymm7,  %ymm8 //acc[5] = pc[11]*tree_inv[2]
vpmulhw %ymm12,  %ymm5,  %ymm5
vpmulhw %ymm13,  %ymm6,  %ymm6
vpmulhw %ymm13,  %ymm7,  %ymm7
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0,  %ymm8,  %ymm8
vpsubw  %ymm14,  %ymm5,  %ymm5
vpsubw   %ymm1,  %ymm6,  %ymm6
vpsubw   %ymm8,  %ymm7,  %ymm7

//recover_inv - level 0
//load
vmovdqa  0(%r15),  %ymm8
vmovdqa 32(%r15),  %ymm9
vmovdqa 64(%r15), %ymm10

//premul
vpmullw %ymm15, %ymm3, %ymm11
vpmullw %ymm15, %ymm2, %ymm12
vpmullw %ymm15, %ymm5, %ymm13

//mul
vpmullw %ymm11,  %ymm8, %ymm14 //den[12] = pc[0]*acc[1]
vpmullw %ymm12,  %ymm9,  %ymm1 //den[13] = pc[1]*acc[0]
vpmullw %ymm13, %ymm10, %ymm15 //den[14] = pc[2]*acc[3]
vpmulhw  %ymm3,  %ymm8,  %ymm8
vpmulhw  %ymm2,  %ymm9,  %ymm9
vpmulhw  %ymm5, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14,  %ymm8,  %ymm8
vpsubw   %ymm1,  %ymm9,  %ymm9
vpsubw  %ymm15, %ymm10, %ymm10

//load original denominators
vmovdqa 384(%r14), %ymm14
vmovdqa 416(%r14),  %ymm1
vmovdqa 448(%r14), %ymm15

//store inverses
vmovdqa  %ymm8, 384(%r14)
vmovdqa  %ymm9, 416(%r14)
vmovdqa %ymm10, 448(%r14)

//mul
vpmulhw  %ymm3, %ymm14,  %ymm3 //acc[1] = old_den[12]*acc[1]
vpmulhw  %ymm2,  %ymm1,  %ymm2 //acc[0] = old_den[13]*acc[0]
vpmulhw  %ymm5, %ymm15,  %ymm5 //acc[3] = old_den[14]*acc[3]
vpmullw %ymm11, %ymm14, %ymm14
vpmullw %ymm12,  %ymm1,  %ymm1
vpmullw %ymm13, %ymm15, %ymm15
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14,  %ymm3,  %ymm3
vpsubw   %ymm1,  %ymm2,  %ymm2
vpsubw  %ymm15,  %ymm5,  %ymm5

//qinv
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15

//load
vmovdqa  96(%r15),  %ymm8
vmovdqa 128(%r15),  %ymm9
vmovdqa 160(%r15), %ymm10

//premul
vpmullw %ymm15, %ymm4, %ymm11
vpmullw %ymm15, %ymm7, %ymm12
vpmullw %ymm15, %ymm6, %ymm13

//mul
vpmullw %ymm11,  %ymm8, %ymm14 //den[15] = pc[3]*acc[2]
vpmullw %ymm12,  %ymm9,  %ymm1 //den[16] = pc[4]*acc[5]
vpmullw %ymm13, %ymm10, %ymm15 //den[17] = pc[5]*acc[4]
vpmulhw  %ymm4,  %ymm8,  %ymm8
vpmulhw  %ymm7,  %ymm9,  %ymm9
vpmulhw  %ymm6, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14,  %ymm8,  %ymm8
vpsubw   %ymm1,  %ymm9,  %ymm9
vpsubw  %ymm15, %ymm10, %ymm10

//load original denominators
vmovdqa 480(%r14), %ymm14
vmovdqa 512(%r14),  %ymm1
vmovdqa 544(%r14), %ymm15

//store inverses
vmovdqa  %ymm8, 480(%r14)
vmovdqa  %ymm9, 512(%r14)
vmovdqa %ymm10, 544(%r14)

//mul
vpmulhw  %ymm4, %ymm14,  %ymm4 //acc[2] = old_den[15]*acc[2]
vpmulhw  %ymm7,  %ymm1,  %ymm7 //acc[5] = old_den[16]*acc[5]
vpmulhw  %ymm6, %ymm15,  %ymm6 //acc[4] = old_den[17]*acc[4]
vpmullw %ymm11, %ymm14, %ymm14
vpmullw %ymm12,  %ymm1,  %ymm1
vpmullw %ymm13, %ymm15, %ymm15
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14,  %ymm4,  %ymm4
vpsubw   %ymm1,  %ymm7,  %ymm7
vpsubw  %ymm15,  %ymm6,  %ymm6

//qinv
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15

//load
vmovdqa  0(%r14),  %ymm8
vmovdqa 32(%r14),  %ymm9
vmovdqa 64(%r14), %ymm10

//premul
vpmullw %ymm15, %ymm3, %ymm11
vpmullw %ymm15, %ymm2, %ymm12
vpmullw %ymm15, %ymm5, %ymm13

//mul
vpmullw %ymm11,  %ymm8, %ymm14 //den[6] = den[0]*acc[1]
vpmullw %ymm12,  %ymm9,  %ymm1 //den[7] = den[1]*acc[0]
vpmullw %ymm13, %ymm10, %ymm15 //den[8] = den[2]*acc[3]
vpmulhw  %ymm3,  %ymm8,  %ymm8
vpmulhw  %ymm2,  %ymm9,  %ymm9
vpmulhw  %ymm5, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14,  %ymm8,  %ymm8
vpsubw   %ymm1,  %ymm9,  %ymm9
vpsubw  %ymm15, %ymm10, %ymm10

//load original denominators
vmovdqa 192(%r14), %ymm14
vmovdqa 224(%r14),  %ymm1
vmovdqa 256(%r14), %ymm15

//store inverses
vmovdqa  %ymm8, 192(%r14)
vmovdqa  %ymm9, 224(%r14)
vmovdqa %ymm10, 256(%r14)

//mul
vpmulhw  %ymm3, %ymm14,  %ymm3 //acc[1] = old_den[6]*acc[1]
vpmulhw  %ymm2,  %ymm1,  %ymm2 //acc[0] = old_den[7]*acc[0]
vpmulhw  %ymm5, %ymm15,  %ymm5 //acc[3] = old_den[8]*acc[3]
vpmullw %ymm11, %ymm14, %ymm14
vpmullw %ymm12,  %ymm1,  %ymm1
vpmullw %ymm13, %ymm15, %ymm15
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14,  %ymm3,  %ymm3
vpsubw   %ymm1,  %ymm2,  %ymm2
vpsubw  %ymm15,  %ymm5,  %ymm5

//qinv
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15

//load
vmovdqa  96(%r14),  %ymm8
vmovdqa 128(%r14),  %ymm9
vmovdqa 160(%r14), %ymm10

//premul
vpmullw %ymm15, %ymm4, %ymm11
vpmullw %ymm15, %ymm7, %ymm12
vpmullw %ymm15, %ymm6, %ymm13

//mul
vpmullw %ymm11,  %ymm8, %ymm14 //den[9] = den[3]*acc[2]
vpmullw %ymm12,  %ymm9,  %ymm1 //den[10] = den[4]*acc[5]
vpmullw %ymm13, %ymm10, %ymm15 //den[11] = den[5]*acc[4]
vpmulhw  %ymm4,  %ymm8,  %ymm8
vpmulhw  %ymm7,  %ymm9,  %ymm9
vpmulhw  %ymm6, %ymm10, %ymm10
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14,  %ymm8,  %ymm8
vpsubw   %ymm1,  %ymm9,  %ymm9
vpsubw  %ymm15, %ymm10, %ymm10

//load original denominators
vmovdqa 288(%r14), %ymm14
vmovdqa 320(%r14),  %ymm1
vmovdqa 352(%r14), %ymm15

//store inverses
vmovdqa  %ymm8, 288(%r14)
vmovdqa  %ymm9, 320(%r14)
vmovdqa %ymm10, 352(%r14)

//mul
vpmulhw  %ymm4, %ymm14,  %ymm4 //acc[2] = old_den[9]*acc[2]
vpmulhw  %ymm7,  %ymm1,  %ymm7 //acc[5] = old_den[10]*acc[5]
vpmulhw  %ymm6, %ymm15,  %ymm6 //acc[4] = old_den[11]*acc[4]
vpmullw %ymm11, %ymm14, %ymm14
vpmullw %ymm12,  %ymm1,  %ymm1
vpmullw %ymm13, %ymm15, %ymm15
vpmulhw  %ymm0, %ymm14, %ymm14
vpmulhw  %ymm0,  %ymm1,  %ymm1
vpmulhw  %ymm0, %ymm15, %ymm15
vpsubw  %ymm14,  %ymm4,  %ymm4
vpsubw   %ymm1,  %ymm7,  %ymm7
vpsubw  %ymm15,  %ymm6,  %ymm6

//qinv
vmovdqa NTRUPLUS_ASM_SYMBOL(16xqinv)(%rip), %ymm15

//store
vmovdqa %ymm3,   0(%r14)
vmovdqa %ymm2,  32(%r14)
vmovdqa %ymm5,  64(%r14)
vmovdqa %ymm4,  96(%r14)
vmovdqa %ymm7, 128(%r14)
vmovdqa %ymm6, 160(%r14)

//finish
mov %r12, %rdi
mov %r14, %rsi
lea 576(%r14), %rdx

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_baseinv_finish):

//load
vmovdqa (%rsi), %ymm2

vmovdqa   (%rdi), %ymm4
vmovdqa 32(%rdi), %ymm5
vmovdqa 64(%rdi), %ymm6

//premul
vpmullw %ymm15, %ymm2, %ymm3

//mul
vpmullw  %ymm3,  %ymm4,  %ymm8 //r[0] = r[0]*den[i]
vpmullw  %ymm3,  %ymm5,  %ymm9 //r[1] = r[1]*den[i]
vpmullw  %ymm3,  %ymm6, %ymm10 //r[2] = r[2]*den[i]
vpmulhw  %ymm2,  %ymm4,  %ymm4
vpmulhw  %ymm2,  %ymm5,  %ymm5
vpmulhw  %ymm2,  %ymm6,  %ymm6
vpmulhw  %ymm0,  %ymm8,  %ymm8
vpmulhw  %ymm0,  %ymm9,  %ymm9
vpmulhw  %ymm0, %ymm10, %ymm10
vpsubw   %ymm8,  %ymm4,  %ymm4
vpsubw   %ymm9,  %ymm5,  %ymm5
vpsubw  %ymm10,  %ymm6,  %ymm6

//store
vmovdqa %ymm4,   (%rdi)
vmovdqa %ymm5, 32(%rdi)
vmovdqa %ymm6, 64(%rdi)

add $96, %rdi
add $32, %rsi
cmp %rdx, %rsi
jb NTRUPLUS_ASM_LOCAL(looptop_baseinv_finish)
jmp NTRUPLUS_ASM_LOCAL(baseinv_clear_stack)

NTRUPLUS_ASM_LOCAL(baseinv_fail):

//clear_output
vpxor %ymm2, %ymm2, %ymm2
mov %r12, %rdi
lea 1728(%r12), %rdx

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_output):

//store
vmovdqa %ymm2, (%rdi)

add $32, %rdi
cmp %rdx, %rdi
jb NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_output)

NTRUPLUS_ASM_LOCAL(baseinv_clear_stack):

//clear_stack
vpxor %ymm2, %ymm2, %ymm2
mov %rsp, %rdi
#ifdef NTRUPLUS_SUPERCOP
lea 1280(%rsp), %rdx
#else
lea 1152(%rsp), %rdx
#endif

.balign 32
NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_stack):

//store
vmovdqa %ymm2,   (%rdi)
vmovdqa %ymm2, 32(%rdi)
vmovdqa %ymm2, 64(%rdi)
vmovdqa %ymm2, 96(%rdi)

add $128, %rdi
cmp %rdx, %rdi
jb NTRUPLUS_ASM_LOCAL(looptop_baseinv_clear_stack)

mov %r13d, %eax
mov %r11, %rsp
pop %r15
pop %r14
pop %r13
pop %r12
ret
NTRUPLUS_ASM_END(poly_baseinv)


NTRUPLUS_ASM_GNU_STACK