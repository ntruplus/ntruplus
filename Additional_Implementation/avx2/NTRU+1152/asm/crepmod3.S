#include "asm.h"

/*************************************************
* Name:        poly_crepmod3
*
* Description: Centers coefficients modulo q and reduces them modulo 3.
*
* Arguments:   - poly *r: pointer to the input/output polynomial;
*                         input coefficients must lie in [-q+1,q-1]
*
* Returns:     none. Output coefficients lie in {-1,0,1}.
**************************************************/
NTRUPLUS_ASM_START(poly_crepmod3)
vmovdqa      NTRUPLUS_ASM_SYMBOL(_16xq26)(%rip), %ymm0
vmovdqa NTRUPLUS_ASM_SYMBOL(_16xq26round)(%rip), %ymm1
vmovdqa       NTRUPLUS_ASM_SYMBOL(_16xv2)(%rip), %ymm2
vmovdqa        NTRUPLUS_ASM_SYMBOL(_16x3)(%rip), %ymm3

lea 2304(%rdi), %r8

.p2align 5
NTRUPLUS_ASM_LOCAL(looptop_crepmod3):
vmovdqa    (%rdi), %ymm4
vmovdqa  32(%rdi), %ymm5
vmovdqa  64(%rdi), %ymm6
vmovdqa  96(%rdi), %ymm7

//reduceq
vpmulhw %ymm0, %ymm4, %ymm8
vpmulhw %ymm0, %ymm5, %ymm9
vpmulhw %ymm0, %ymm6, %ymm10
vpmulhw %ymm0, %ymm7, %ymm11

vpaddw %ymm1, %ymm8,  %ymm8
vpaddw %ymm1, %ymm9,  %ymm9
vpaddw %ymm1, %ymm10, %ymm10
vpaddw %ymm1, %ymm11, %ymm11

vpsraw $10, %ymm8,  %ymm8
vpsraw $10, %ymm9,  %ymm9
vpsraw $10, %ymm10, %ymm10
vpsraw $10, %ymm11, %ymm11

// q = 1 (mod 3)
vpsubw %ymm8,  %ymm4, %ymm4
vpsubw %ymm9,  %ymm5, %ymm5
vpsubw %ymm10, %ymm6, %ymm6
vpsubw %ymm11, %ymm7, %ymm7

//reduce3
vpmulhrsw %ymm2, %ymm4, %ymm8
vpmulhrsw %ymm2, %ymm5, %ymm9
vpmulhrsw %ymm2, %ymm6, %ymm10
vpmulhrsw %ymm2, %ymm7, %ymm11

vpmullw %ymm3, %ymm8,  %ymm8
vpmullw %ymm3, %ymm9,  %ymm9
vpmullw %ymm3, %ymm10, %ymm10
vpmullw %ymm3, %ymm11, %ymm11

vpsubw %ymm8,  %ymm4, %ymm4
vpsubw %ymm9,  %ymm5, %ymm5
vpsubw %ymm10, %ymm6, %ymm6
vpsubw %ymm11, %ymm7, %ymm7

vmovdqa %ymm4,    (%rdi)
vmovdqa %ymm5,  32(%rdi)
vmovdqa %ymm6,  64(%rdi)
vmovdqa %ymm7,  96(%rdi)

add $128, %rdi
cmp %r8,  %rdi
jb  NTRUPLUS_ASM_LOCAL(looptop_crepmod3)

ret
NTRUPLUS_ASM_END(poly_crepmod3)


NTRUPLUS_ASM_GNU_STACK
