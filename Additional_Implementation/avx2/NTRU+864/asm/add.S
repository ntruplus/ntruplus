.global poly_sub
#ifdef __ELF__
.type poly_sub, @function
#endif
poly_sub:
    lea 1728(%rsi), %r8

.p2align 5
.Llooptop_sub:
    vmovdqa    (%rsi), %ymm0
    vmovdqa  32(%rsi), %ymm1
    vmovdqa  64(%rsi), %ymm2
    vmovdqa  96(%rsi), %ymm3
    vmovdqa 128(%rsi), %ymm4
    vmovdqa 160(%rsi), %ymm5

    vpsubw    (%rdx), %ymm0, %ymm0
    vpsubw  32(%rdx), %ymm1, %ymm1
    vpsubw  64(%rdx), %ymm2, %ymm2
    vpsubw  96(%rdx), %ymm3, %ymm3
    vpsubw 128(%rdx), %ymm4, %ymm4
    vpsubw 160(%rdx), %ymm5, %ymm5

    vmovdqa %ymm0,    (%rdi)
    vmovdqa %ymm1,  32(%rdi)
    vmovdqa %ymm2,  64(%rdi)
    vmovdqa %ymm3,  96(%rdi)
    vmovdqa %ymm4, 128(%rdi)
    vmovdqa %ymm5, 160(%rdi)

    add $192, %rsi
    add $192, %rdx
    add $192, %rdi
    cmp %r8,  %rsi
    jb  .Llooptop_sub

    ret
#ifdef __ELF__
.size poly_sub, .-poly_sub
#endif


#ifdef __ELF__
.section .note.GNU-stack,"",@progbits
#endif
