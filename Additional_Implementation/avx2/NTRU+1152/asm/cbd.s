.global poly_cbd1
poly_cbd1:
    vmovdqa _16x5555(%rip), %ymm0
    vmovdqa _16x0303(%rip), %ymm1
    vmovdqa _16x0101(%rip), %ymm2

    vmovdqu 112(%rsi), %ymm3
    vmovdqu 256(%rsi), %ymm4

    vpsrlw $1, %ymm3, %ymm5
    vpsrlw $1, %ymm4, %ymm6

    vpand %ymm0, %ymm3, %ymm3
    vpand %ymm0, %ymm4, %ymm4
    vpand %ymm0, %ymm5, %ymm5
    vpand %ymm0, %ymm6, %ymm6

    vpaddb %ymm0, %ymm3, %ymm3
    vpaddb %ymm0, %ymm5, %ymm5

    vpsubb %ymm4, %ymm3, %ymm7
    vpsubb %ymm6, %ymm5, %ymm8

    vpsrlw $2, %ymm7, %ymm9
    vpsrlw $2, %ymm8, %ymm10

    vpand %ymm1, %ymm7, %ymm3
    vpand %ymm1, %ymm8, %ymm4
    vpand %ymm1, %ymm9, %ymm5
    vpand %ymm1, %ymm10, %ymm6

    vpsubb %ymm2, %ymm3, %ymm3
    vpsubb %ymm2, %ymm4, %ymm4
    vpsubb %ymm2, %ymm5, %ymm5
    vpsubb %ymm2, %ymm6, %ymm6

    vpsrlw $4, %ymm7, %ymm7
    vpsrlw $4, %ymm8, %ymm8
    vpsrlw $4, %ymm9, %ymm9
    vpsrlw $4, %ymm10, %ymm10

    vpand %ymm1, %ymm7, %ymm7
    vpand %ymm1, %ymm8, %ymm8
    vpand %ymm1, %ymm9, %ymm9
    vpand %ymm1, %ymm10, %ymm10

    vpsubb %ymm2, %ymm7, %ymm7
    vpsubb %ymm2, %ymm8, %ymm8
    vpsubb %ymm2, %ymm9, %ymm9
    vpsubb %ymm2, %ymm10, %ymm10

    vpunpcklbw %ymm4, %ymm3, %ymm11
    vpunpcklbw %ymm6, %ymm5, %ymm12
    vpunpcklbw %ymm8, %ymm7, %ymm13
    vpunpcklbw %ymm10, %ymm9, %ymm14

    vpunpckhbw %ymm4, %ymm3, %ymm3
    vpunpckhbw %ymm6, %ymm5, %ymm4
    vpunpckhbw %ymm8, %ymm7, %ymm5
    vpunpckhbw %ymm10, %ymm9, %ymm6

    vpunpcklwd %ymm12, %ymm11, %ymm7
    vpunpcklwd %ymm14, %ymm13, %ymm8
    vpunpckhwd %ymm12, %ymm11, %ymm9
    vpunpckhwd %ymm14, %ymm13, %ymm10

    vpunpcklwd %ymm4, %ymm3, %ymm11
    vpunpcklwd %ymm6, %ymm5, %ymm12
    vpunpckhwd %ymm4, %ymm3, %ymm13
    vpunpckhwd %ymm6, %ymm5, %ymm14

    vpunpckldq %ymm12, %ymm11, %ymm3
    vpunpckhdq %ymm12, %ymm11, %ymm4
    vpunpckldq %ymm14, %ymm13, %ymm5
    vpunpckhdq %ymm14, %ymm13, %ymm6

    vpunpckldq %ymm8, %ymm7, %ymm11
    vpunpckhdq %ymm8, %ymm7, %ymm12
    vpunpckldq %ymm10, %ymm9, %ymm13
    vpunpckhdq %ymm10, %ymm9, %ymm14

    vpmovsxbw %xmm3, %ymm7
    vpmovsxbw %xmm4, %ymm8
    vpmovsxbw %xmm5, %ymm9
    vpmovsxbw %xmm6, %ymm10

    vmovdqa  %ymm7, 1920(%rdi)
    vmovdqa  %ymm8, 1952(%rdi)
    vmovdqa  %ymm9, 1984(%rdi)
    vmovdqa %ymm10, 2016(%rdi)

    vextracti128 $1, %ymm3, %xmm7
    vextracti128 $1, %ymm4, %xmm8
    vextracti128 $1, %ymm5, %xmm9
    vextracti128 $1, %ymm6, %xmm10

    vpmovsxbw  %xmm7, %ymm7
    vpmovsxbw  %xmm8, %ymm8
    vpmovsxbw  %xmm9, %ymm9
    vpmovsxbw %xmm10, %ymm10

    vmovdqa  %ymm7, 2176(%rdi)
    vmovdqa  %ymm8, 2208(%rdi)
    vmovdqa  %ymm9, 2240(%rdi)
    vmovdqa %ymm10, 2272(%rdi)

    vpmovsxbw %xmm11, %ymm7
    vpmovsxbw %xmm12, %ymm8
    vpmovsxbw %xmm13, %ymm9
    vpmovsxbw %xmm14, %ymm10

    vmovdqu  %ymm7, 1792(%rdi)
    vmovdqa  %ymm8, 1824(%rdi)
    vmovdqu  %ymm9, 1856(%rdi)
    vmovdqa %ymm10, 1888(%rdi)

    vextracti128 $1, %ymm11, %xmm7
    vextracti128 $1, %ymm12, %xmm8
    vextracti128 $1, %ymm13, %xmm9
    vextracti128 $1, %ymm14, %xmm10

    vpmovsxbw  %xmm7, %ymm7
    vpmovsxbw  %xmm8, %ymm8
    vpmovsxbw  %xmm9, %ymm9
    vpmovsxbw %xmm10, %ymm10

    vmovdqu  %ymm7, 2048(%rdi)
    vmovdqa  %ymm8, 2080(%rdi)
    vmovdqu  %ymm9, 2112(%rdi)
    vmovdqa %ymm10, 2144(%rdi)

    lea 128(%rsi), %r8

.p2align 5
_looptop_poly_cbd1_1:
    vmovdqu   (%rsi), %ymm3
    vmovdqu 144(%rsi), %ymm4

    vpsrlw $1, %ymm3, %ymm5
    vpsrlw $1, %ymm4, %ymm6

    vpand %ymm0, %ymm3, %ymm3
    vpand %ymm0, %ymm4, %ymm4
    vpand %ymm0, %ymm5, %ymm5
    vpand %ymm0, %ymm6, %ymm6

    vpaddb %ymm0, %ymm3, %ymm3
    vpaddb %ymm0, %ymm5, %ymm5

    vpsubb %ymm4, %ymm3, %ymm7
    vpsubb %ymm6, %ymm5, %ymm8

    vpsrlw $2, %ymm7, %ymm9
    vpsrlw $2, %ymm8, %ymm10

    vpand %ymm1, %ymm7, %ymm3
    vpand %ymm1, %ymm8, %ymm4
    vpand %ymm1, %ymm9, %ymm5
    vpand %ymm1, %ymm10, %ymm6

    vpsubb %ymm2, %ymm3, %ymm3
    vpsubb %ymm2, %ymm4, %ymm4
    vpsubb %ymm2, %ymm5, %ymm5
    vpsubb %ymm2, %ymm6, %ymm6

    vpsrlw $4, %ymm7, %ymm7
    vpsrlw $4, %ymm8, %ymm8
    vpsrlw $4, %ymm9, %ymm9
    vpsrlw $4, %ymm10, %ymm10

    vpand %ymm1, %ymm7, %ymm7
    vpand %ymm1, %ymm8, %ymm8
    vpand %ymm1, %ymm9, %ymm9
    vpand %ymm1, %ymm10, %ymm10

    vpsubb %ymm2, %ymm7, %ymm7
    vpsubb %ymm2, %ymm8, %ymm8
    vpsubb %ymm2, %ymm9, %ymm9
    vpsubb %ymm2, %ymm10, %ymm10

    vpunpcklbw %ymm4, %ymm3, %ymm11
    vpunpcklbw %ymm6, %ymm5, %ymm12
    vpunpcklbw %ymm8, %ymm7, %ymm13
    vpunpcklbw %ymm10, %ymm9, %ymm14

    vpunpckhbw %ymm4, %ymm3, %ymm3
    vpunpckhbw %ymm6, %ymm5, %ymm4
    vpunpckhbw %ymm8, %ymm7, %ymm5
    vpunpckhbw %ymm10, %ymm9, %ymm6

    vpunpcklwd %ymm12, %ymm11, %ymm7
    vpunpcklwd %ymm14, %ymm13, %ymm8
    vpunpckhwd %ymm12, %ymm11, %ymm9
    vpunpckhwd %ymm14, %ymm13, %ymm10

    vpunpcklwd %ymm4, %ymm3, %ymm11
    vpunpcklwd %ymm6, %ymm5, %ymm12
    vpunpckhwd %ymm4, %ymm3, %ymm13
    vpunpckhwd %ymm6, %ymm5, %ymm14

    vpunpckldq %ymm12, %ymm11, %ymm3
    vpunpckhdq %ymm12, %ymm11, %ymm4
    vpunpckldq %ymm14, %ymm13, %ymm5
    vpunpckhdq %ymm14, %ymm13, %ymm6

    vpunpckldq %ymm8, %ymm7, %ymm11
    vpunpckhdq %ymm8, %ymm7, %ymm12
    vpunpckldq %ymm10, %ymm9, %ymm13
    vpunpckhdq %ymm10, %ymm9, %ymm14

    vpmovsxbw %xmm3, %ymm7
    vpmovsxbw %xmm4, %ymm8
    vpmovsxbw %xmm5, %ymm9
    vpmovsxbw %xmm6, %ymm10

    vmovdqa  %ymm7, 128(%rdi)
    vmovdqa  %ymm8, 160(%rdi)
    vmovdqa  %ymm9, 192(%rdi)
    vmovdqa %ymm10, 224(%rdi)

    vextracti128 $1, %ymm3, %xmm7
    vextracti128 $1, %ymm4, %xmm8
    vextracti128 $1, %ymm5, %xmm9
    vextracti128 $1, %ymm6, %xmm10

    vpmovsxbw  %xmm7, %ymm7
    vpmovsxbw  %xmm8, %ymm8
    vpmovsxbw  %xmm9, %ymm9
    vpmovsxbw %xmm10, %ymm10

    vmovdqa  %ymm7, 384(%rdi)
    vmovdqa  %ymm8, 416(%rdi)
    vmovdqa  %ymm9, 448(%rdi)
    vmovdqa %ymm10, 480(%rdi)

    vpmovsxbw %xmm11, %ymm7
    vpmovsxbw %xmm12, %ymm8
    vpmovsxbw %xmm13, %ymm9
    vpmovsxbw %xmm14, %ymm10

    vmovdqa  %ymm7, 0(%rdi)
    vmovdqa  %ymm8, 32(%rdi)
    vmovdqa  %ymm9, 64(%rdi)
    vmovdqa %ymm10, 96(%rdi)

    vextracti128 $1, %ymm11, %xmm7
    vextracti128 $1, %ymm12, %xmm8
    vextracti128 $1, %ymm13, %xmm9
    vextracti128 $1, %ymm14, %xmm10

    vpmovsxbw  %xmm7, %ymm7
    vpmovsxbw  %xmm8, %ymm8
    vpmovsxbw  %xmm9, %ymm9
    vpmovsxbw %xmm10, %ymm10

    vmovdqa  %ymm7, 256(%rdi)
    vmovdqa  %ymm8, 288(%rdi)
    vmovdqa  %ymm9, 320(%rdi)
    vmovdqa %ymm10, 352(%rdi)

    add $32,  %rsi
    add $512, %rdi
    cmp %r8,  %rsi
    jb  _looptop_poly_cbd1_1

    ret


.global poly_sotp_encode
poly_sotp_encode:
    vmovdqa _16x5555(%rip), %ymm0
    vmovdqa _16x0303(%rip), %ymm1
    vmovdqa _16x0101(%rip), %ymm2

    vmovdqu 112(%rsi), %ymm5
    vmovdqu 112(%rdx), %ymm3
    vmovdqu 256(%rdx), %ymm4

    vpxor %ymm5, %ymm3, %ymm3

    vpsrlw $1, %ymm3, %ymm5
    vpsrlw $1, %ymm4, %ymm6

    vpand %ymm0, %ymm3, %ymm3
    vpand %ymm0, %ymm4, %ymm4
    vpand %ymm0, %ymm5, %ymm5
    vpand %ymm0, %ymm6, %ymm6

    vpaddb %ymm0, %ymm3, %ymm3
    vpaddb %ymm0, %ymm5, %ymm5

    vpsubb %ymm4, %ymm3, %ymm7
    vpsubb %ymm6, %ymm5, %ymm8

    vpsrlw $2, %ymm7, %ymm9
    vpsrlw $2, %ymm8, %ymm10

    vpand %ymm1, %ymm7, %ymm3
    vpand %ymm1, %ymm8, %ymm4
    vpand %ymm1, %ymm9, %ymm5
    vpand %ymm1, %ymm10, %ymm6

    vpsubb %ymm2, %ymm3, %ymm3
    vpsubb %ymm2, %ymm4, %ymm4
    vpsubb %ymm2, %ymm5, %ymm5
    vpsubb %ymm2, %ymm6, %ymm6

    vpsrlw $4, %ymm7, %ymm7
    vpsrlw $4, %ymm8, %ymm8
    vpsrlw $4, %ymm9, %ymm9
    vpsrlw $4, %ymm10, %ymm10

    vpand %ymm1, %ymm7, %ymm7
    vpand %ymm1, %ymm8, %ymm8
    vpand %ymm1, %ymm9, %ymm9
    vpand %ymm1, %ymm10, %ymm10

    vpsubb %ymm2, %ymm7, %ymm7
    vpsubb %ymm2, %ymm8, %ymm8
    vpsubb %ymm2, %ymm9, %ymm9
    vpsubb %ymm2, %ymm10, %ymm10

    vpunpcklbw %ymm4, %ymm3, %ymm11
    vpunpcklbw %ymm6, %ymm5, %ymm12
    vpunpcklbw %ymm8, %ymm7, %ymm13
    vpunpcklbw %ymm10, %ymm9, %ymm14

    vpunpckhbw %ymm4, %ymm3, %ymm3
    vpunpckhbw %ymm6, %ymm5, %ymm4
    vpunpckhbw %ymm8, %ymm7, %ymm5
    vpunpckhbw %ymm10, %ymm9, %ymm6

    vpunpcklwd %ymm12, %ymm11, %ymm7
    vpunpcklwd %ymm14, %ymm13, %ymm8
    vpunpckhwd %ymm12, %ymm11, %ymm9
    vpunpckhwd %ymm14, %ymm13, %ymm10

    vpunpcklwd %ymm4, %ymm3, %ymm11
    vpunpcklwd %ymm6, %ymm5, %ymm12
    vpunpckhwd %ymm4, %ymm3, %ymm13
    vpunpckhwd %ymm6, %ymm5, %ymm14

    vpunpckldq %ymm12, %ymm11, %ymm3
    vpunpckhdq %ymm12, %ymm11, %ymm4
    vpunpckldq %ymm14, %ymm13, %ymm5
    vpunpckhdq %ymm14, %ymm13, %ymm6

    vpunpckldq %ymm8, %ymm7, %ymm11
    vpunpckhdq %ymm8, %ymm7, %ymm12
    vpunpckldq %ymm10, %ymm9, %ymm13
    vpunpckhdq %ymm10, %ymm9, %ymm14

    vpmovsxbw %xmm3, %ymm7
    vpmovsxbw %xmm4, %ymm8
    vpmovsxbw %xmm5, %ymm9
    vpmovsxbw %xmm6, %ymm10

    vmovdqa  %ymm7, 1920(%rdi)
    vmovdqa  %ymm8, 1952(%rdi)
    vmovdqa  %ymm9, 1984(%rdi)
    vmovdqa %ymm10, 2016(%rdi)

    vextracti128 $1, %ymm3, %xmm7
    vextracti128 $1, %ymm4, %xmm8
    vextracti128 $1, %ymm5, %xmm9
    vextracti128 $1, %ymm6, %xmm10

    vpmovsxbw  %xmm7, %ymm7
    vpmovsxbw  %xmm8, %ymm8
    vpmovsxbw  %xmm9, %ymm9
    vpmovsxbw %xmm10, %ymm10

    vmovdqa  %ymm7, 2176(%rdi)
    vmovdqa  %ymm8, 2208(%rdi)
    vmovdqa  %ymm9, 2240(%rdi)
    vmovdqa %ymm10, 2272(%rdi)

    vpmovsxbw %xmm11, %ymm7
    vpmovsxbw %xmm12, %ymm8
    vpmovsxbw %xmm13, %ymm9
    vpmovsxbw %xmm14, %ymm10

    vmovdqu  %ymm7, 1792(%rdi)
    vmovdqa  %ymm8, 1824(%rdi)
    vmovdqu  %ymm9, 1856(%rdi)
    vmovdqa %ymm10, 1888(%rdi)

    vextracti128 $1, %ymm11, %xmm7
    vextracti128 $1, %ymm12, %xmm8
    vextracti128 $1, %ymm13, %xmm9
    vextracti128 $1, %ymm14, %xmm10

    vpmovsxbw  %xmm7, %ymm7
    vpmovsxbw  %xmm8, %ymm8
    vpmovsxbw  %xmm9, %ymm9
    vpmovsxbw %xmm10, %ymm10

    vmovdqu  %ymm7, 2048(%rdi)
    vmovdqa  %ymm8, 2080(%rdi)
    vmovdqu  %ymm9, 2112(%rdi)
    vmovdqa %ymm10, 2144(%rdi)

    lea 128(%rsi), %r8

.p2align 5
_looptop_poly_sotp_1:
    vmovdqu   (%rsi), %ymm5
    vmovdqu   (%rdx), %ymm3
    vmovdqu 144(%rdx), %ymm4

    vpxor %ymm5, %ymm3, %ymm3

    vpsrlw $1, %ymm3, %ymm5
    vpsrlw $1, %ymm4, %ymm6

    vpand %ymm0, %ymm3, %ymm3
    vpand %ymm0, %ymm4, %ymm4
    vpand %ymm0, %ymm5, %ymm5
    vpand %ymm0, %ymm6, %ymm6

    vpaddb %ymm0, %ymm3, %ymm3
    vpaddb %ymm0, %ymm5, %ymm5

    vpsubb %ymm4, %ymm3, %ymm7
    vpsubb %ymm6, %ymm5, %ymm8

    vpsrlw $2, %ymm7, %ymm9
    vpsrlw $2, %ymm8, %ymm10

    vpand %ymm1, %ymm7, %ymm3
    vpand %ymm1, %ymm8, %ymm4
    vpand %ymm1, %ymm9, %ymm5
    vpand %ymm1, %ymm10, %ymm6

    vpsubb %ymm2, %ymm3, %ymm3
    vpsubb %ymm2, %ymm4, %ymm4
    vpsubb %ymm2, %ymm5, %ymm5
    vpsubb %ymm2, %ymm6, %ymm6

    vpsrlw $4, %ymm7, %ymm7
    vpsrlw $4, %ymm8, %ymm8
    vpsrlw $4, %ymm9, %ymm9
    vpsrlw $4, %ymm10, %ymm10

    vpand %ymm1, %ymm7, %ymm7
    vpand %ymm1, %ymm8, %ymm8
    vpand %ymm1, %ymm9, %ymm9
    vpand %ymm1, %ymm10, %ymm10

    vpsubb %ymm2, %ymm7, %ymm7
    vpsubb %ymm2, %ymm8, %ymm8
    vpsubb %ymm2, %ymm9, %ymm9
    vpsubb %ymm2, %ymm10, %ymm10

    vpunpcklbw %ymm4, %ymm3, %ymm11
    vpunpcklbw %ymm6, %ymm5, %ymm12
    vpunpcklbw %ymm8, %ymm7, %ymm13
    vpunpcklbw %ymm10, %ymm9, %ymm14

    vpunpckhbw %ymm4, %ymm3, %ymm3
    vpunpckhbw %ymm6, %ymm5, %ymm4
    vpunpckhbw %ymm8, %ymm7, %ymm5
    vpunpckhbw %ymm10, %ymm9, %ymm6

    vpunpcklwd %ymm12, %ymm11, %ymm7
    vpunpcklwd %ymm14, %ymm13, %ymm8
    vpunpckhwd %ymm12, %ymm11, %ymm9
    vpunpckhwd %ymm14, %ymm13, %ymm10

    vpunpcklwd %ymm4, %ymm3, %ymm11
    vpunpcklwd %ymm6, %ymm5, %ymm12
    vpunpckhwd %ymm4, %ymm3, %ymm13
    vpunpckhwd %ymm6, %ymm5, %ymm14

    vpunpckldq %ymm12, %ymm11, %ymm3
    vpunpckhdq %ymm12, %ymm11, %ymm4
    vpunpckldq %ymm14, %ymm13, %ymm5
    vpunpckhdq %ymm14, %ymm13, %ymm6

    vpunpckldq %ymm8, %ymm7, %ymm11
    vpunpckhdq %ymm8, %ymm7, %ymm12
    vpunpckldq %ymm10, %ymm9, %ymm13
    vpunpckhdq %ymm10, %ymm9, %ymm14

    vpmovsxbw %xmm3, %ymm7
    vpmovsxbw %xmm4, %ymm8
    vpmovsxbw %xmm5, %ymm9
    vpmovsxbw %xmm6, %ymm10

    vmovdqa  %ymm7, 128(%rdi)
    vmovdqa  %ymm8, 160(%rdi)
    vmovdqa  %ymm9, 192(%rdi)
    vmovdqa %ymm10, 224(%rdi)

    vextracti128 $1, %ymm3, %xmm7
    vextracti128 $1, %ymm4, %xmm8
    vextracti128 $1, %ymm5, %xmm9
    vextracti128 $1, %ymm6, %xmm10

    vpmovsxbw  %xmm7, %ymm7
    vpmovsxbw  %xmm8, %ymm8
    vpmovsxbw  %xmm9, %ymm9
    vpmovsxbw %xmm10, %ymm10

    vmovdqa  %ymm7, 384(%rdi)
    vmovdqa  %ymm8, 416(%rdi)
    vmovdqa  %ymm9, 448(%rdi)
    vmovdqa %ymm10, 480(%rdi)

    vpmovsxbw %xmm11, %ymm7
    vpmovsxbw %xmm12, %ymm8
    vpmovsxbw %xmm13, %ymm9
    vpmovsxbw %xmm14, %ymm10

    vmovdqa  %ymm7, 0(%rdi)
    vmovdqa  %ymm8, 32(%rdi)
    vmovdqa  %ymm9, 64(%rdi)
    vmovdqa %ymm10, 96(%rdi)

    vextracti128 $1, %ymm11, %xmm7
    vextracti128 $1, %ymm12, %xmm8
    vextracti128 $1, %ymm13, %xmm9
    vextracti128 $1, %ymm14, %xmm10

    vpmovsxbw  %xmm7, %ymm7
    vpmovsxbw  %xmm8, %ymm8
    vpmovsxbw  %xmm9, %ymm9
    vpmovsxbw %xmm10, %ymm10

    vmovdqa  %ymm7, 256(%rdi)
    vmovdqa  %ymm8, 288(%rdi)
    vmovdqa  %ymm9, 320(%rdi)
    vmovdqa %ymm10, 352(%rdi)

    add $32,  %rsi
    add $32,  %rdx    
    add $512, %rdi
    cmp %r8,  %rsi
    jb  _looptop_poly_sotp_1

    ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
