.global poly_cbd1
poly_cbd1:
    vmovdqa _16x5555(%rip), %ymm0
    vmovdqa _16x0303(%rip), %ymm1
    vmovdqa _16x0101(%rip), %ymm2

    lea 96(%rsi), %r8

.p2align 5
_looptop_poly_cbd1_1:
    vmovdqu   (%rsi), %ymm3
    vmovdqu 96(%rsi), %ymm4

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

    vperm2i128 $0x20, %ymm4, %ymm3, %ymm7
    vperm2i128 $0x20, %ymm6, %ymm5, %ymm8
    vperm2i128 $0x31, %ymm4, %ymm3, %ymm9
    vperm2i128 $0x31, %ymm6, %ymm5, %ymm10

    vperm2i128 $0x20, %ymm12, %ymm11, %ymm3
    vperm2i128 $0x20, %ymm14, %ymm13, %ymm4
    vperm2i128 $0x31, %ymm12, %ymm11, %ymm5
    vperm2i128 $0x31, %ymm14, %ymm13, %ymm6

    vpmovsxbw  %xmm3,  %ymm11
    vpmovsxbw  %xmm4,  %ymm12
    vpmovsxbw  %xmm5,  %ymm13
    vpmovsxbw  %xmm6,  %ymm14

    vmovdqa    %ymm11,   0(%rdi)
    vmovdqa    %ymm12,  64(%rdi)
    vmovdqa    %ymm13, 256(%rdi)
    vmovdqa    %ymm14, 320(%rdi)

    vpmovsxbw  %xmm7,  %ymm11
    vpmovsxbw  %xmm8,  %ymm12
    vpmovsxbw  %xmm9,  %ymm13
    vpmovsxbw  %xmm10, %ymm14

    vmovdqa    %ymm11, 128(%rdi)
    vmovdqa    %ymm12, 192(%rdi)
    vmovdqa    %ymm13, 384(%rdi)
    vmovdqa    %ymm14, 448(%rdi)

    vextracti128 $1, %ymm3, %xmm11
    vextracti128 $1, %ymm4, %xmm12
    vextracti128 $1, %ymm5, %xmm13
    vextracti128 $1, %ymm6, %xmm14

    vpmovsxbw    %xmm11, %ymm11
    vpmovsxbw    %xmm12, %ymm12
    vpmovsxbw    %xmm13, %ymm13
    vpmovsxbw    %xmm14, %ymm14

    vmovdqa      %ymm11,  32(%rdi)
    vmovdqa      %ymm12,  96(%rdi)
    vmovdqa      %ymm13, 288(%rdi)
    vmovdqa      %ymm14, 352(%rdi)

    vextracti128 $1, %ymm7,  %xmm11
    vextracti128 $1, %ymm8,  %xmm12
    vextracti128 $1, %ymm9,  %xmm13
    vextracti128 $1, %ymm10, %xmm14

    vpmovsxbw    %xmm11, %ymm11
    vpmovsxbw    %xmm12, %ymm12
    vpmovsxbw    %xmm13, %ymm13
    vpmovsxbw    %xmm14, %ymm14

    vmovdqa      %ymm11, 160(%rdi)
    vmovdqa      %ymm12, 224(%rdi)
    vmovdqa      %ymm13, 416(%rdi)
    vmovdqa      %ymm14, 480(%rdi)

    add $32,  %rsi
    add $512, %rdi
    cmp %r8,  %rsi
    jb  _looptop_poly_cbd1_1

    ret


.global poly_sotp
poly_sotp:
    vmovdqa _16x5555(%rip), %ymm0
    vmovdqa _16x0303(%rip), %ymm1
    vmovdqa _16x0101(%rip), %ymm2

    lea 96(%rsi), %r8

.p2align 5
_looptop_poly_sotp_1:
    vmovdqu   (%rsi), %ymm5
    vmovdqu   (%rdx), %ymm3
    vmovdqu 96(%rdx), %ymm4

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

    vperm2i128 $0x20, %ymm4, %ymm3, %ymm7
    vperm2i128 $0x20, %ymm6, %ymm5, %ymm8
    vperm2i128 $0x31, %ymm4, %ymm3, %ymm9
    vperm2i128 $0x31, %ymm6, %ymm5, %ymm10

    vperm2i128 $0x20, %ymm12, %ymm11, %ymm3
    vperm2i128 $0x20, %ymm14, %ymm13, %ymm4
    vperm2i128 $0x31, %ymm12, %ymm11, %ymm5
    vperm2i128 $0x31, %ymm14, %ymm13, %ymm6

    vpmovsxbw  %xmm3,  %ymm11
    vpmovsxbw  %xmm4,  %ymm12
    vpmovsxbw  %xmm5,  %ymm13
    vpmovsxbw  %xmm6,  %ymm14

    vmovdqa    %ymm11,   0(%rdi)
    vmovdqa    %ymm12,  64(%rdi)
    vmovdqa    %ymm13, 256(%rdi)
    vmovdqa    %ymm14, 320(%rdi)

    vpmovsxbw  %xmm7,  %ymm11
    vpmovsxbw  %xmm8,  %ymm12
    vpmovsxbw  %xmm9,  %ymm13
    vpmovsxbw  %xmm10, %ymm14

    vmovdqa    %ymm11, 128(%rdi)
    vmovdqa    %ymm12, 192(%rdi)
    vmovdqa    %ymm13, 384(%rdi)
    vmovdqa    %ymm14, 448(%rdi)

    vextracti128 $1, %ymm3, %xmm11
    vextracti128 $1, %ymm4, %xmm12
    vextracti128 $1, %ymm5, %xmm13
    vextracti128 $1, %ymm6, %xmm14

    vpmovsxbw    %xmm11, %ymm11
    vpmovsxbw    %xmm12, %ymm12
    vpmovsxbw    %xmm13, %ymm13
    vpmovsxbw    %xmm14, %ymm14

    vmovdqa      %ymm11,  32(%rdi)
    vmovdqa      %ymm12,  96(%rdi)
    vmovdqa      %ymm13, 288(%rdi)
    vmovdqa      %ymm14, 352(%rdi)

    vextracti128 $1, %ymm7,  %xmm11
    vextracti128 $1, %ymm8,  %xmm12
    vextracti128 $1, %ymm9,  %xmm13
    vextracti128 $1, %ymm10, %xmm14

    vpmovsxbw    %xmm11, %ymm11
    vpmovsxbw    %xmm12, %ymm12
    vpmovsxbw    %xmm13, %ymm13
    vpmovsxbw    %xmm14, %ymm14

    vmovdqa      %ymm11, 160(%rdi)
    vmovdqa      %ymm12, 224(%rdi)
    vmovdqa      %ymm13, 416(%rdi)
    vmovdqa      %ymm14, 480(%rdi)

    add $32,  %rsi
    add $32,  %rdx
    add $512, %rdi
    cmp %r8,  %rsi
    jb  _looptop_poly_sotp_1

    ret



/*
.global poly_sotp
poly_sotp:
vmovdqa _16x1(%rip), %ymm0

lea 96(%rdx), %r8

.p2align 5
_looptop_poly_sotp:
vmovdqu   (%rsi), %ymm1
vmovdqu   (%rdx), %ymm2
vmovdqu 96(%rdx), %ymm3

vpxor %ymm1, %ymm2, %ymm2

vpsrld $1, %ymm2, %ymm4
vpsrld $1, %ymm3, %ymm5
vpsrld $2, %ymm2, %ymm6
vpsrld $2, %ymm3, %ymm7

vpand %ymm0, %ymm4, %ymm4
vpand %ymm0, %ymm5, %ymm5
vpand %ymm0, %ymm6, %ymm6
vpand %ymm0, %ymm7, %ymm7

vpsrld $3, %ymm2, %ymm8
vpsrld $3, %ymm3, %ymm9
vpsrld $4, %ymm2, %ymm10
vpsrld $4, %ymm3, %ymm11

vpand %ymm0, %ymm8,  %ymm8
vpand %ymm0, %ymm9,  %ymm9
vpand %ymm0, %ymm10, %ymm10
vpand %ymm0, %ymm11, %ymm11

vpsubw %ymm5,  %ymm4,  %ymm4
vpsubw %ymm7,  %ymm6,  %ymm5
vpsubw %ymm9,  %ymm8,  %ymm6
vpsubw %ymm11, %ymm10, %ymm7

vmovdqa %ymm4,  32(%rdi)
vmovdqa %ymm5,  64(%rdi)
vmovdqa %ymm6,  96(%rdi)
vmovdqa %ymm7, 128(%rdi)

vpsrld $5, %ymm2, %ymm4
vpsrld $5, %ymm3, %ymm5
vpsrld $6, %ymm2, %ymm6
vpsrld $6, %ymm3, %ymm7

vpand %ymm0, %ymm4, %ymm4
vpand %ymm0, %ymm5, %ymm5
vpand %ymm0, %ymm6, %ymm6
vpand %ymm0, %ymm7, %ymm7

vpsrld $7, %ymm2, %ymm8
vpsrld $7, %ymm3, %ymm9
vpsrld $8, %ymm2, %ymm10
vpsrld $8, %ymm3, %ymm11

vpand %ymm0, %ymm8,  %ymm8
vpand %ymm0, %ymm9,  %ymm9
vpand %ymm0, %ymm10, %ymm10
vpand %ymm0, %ymm11, %ymm11

vpsubw %ymm5,  %ymm4,  %ymm4
vpsubw %ymm7,  %ymm6,  %ymm5
vpsubw %ymm9,  %ymm8,  %ymm6
vpsubw %ymm11, %ymm10, %ymm7

vmovdqa %ymm4, 160(%rdi)
vmovdqa %ymm5, 192(%rdi)
vmovdqa %ymm6, 224(%rdi)
vmovdqa %ymm7, 256(%rdi)

vpsrld $9, %ymm2, %ymm4
vpsrld $9, %ymm3, %ymm5
vpsrld $10, %ymm2, %ymm6
vpsrld $10, %ymm3, %ymm7

vpand %ymm0, %ymm4, %ymm4
vpand %ymm0, %ymm5, %ymm5
vpand %ymm0, %ymm6, %ymm6
vpand %ymm0, %ymm7, %ymm7

vpsrld $11, %ymm2, %ymm8
vpsrld $11, %ymm3, %ymm9
vpsrld $12, %ymm2, %ymm10
vpsrld $12, %ymm3, %ymm11

vpand %ymm0, %ymm8,  %ymm8
vpand %ymm0, %ymm9,  %ymm9
vpand %ymm0, %ymm10, %ymm10
vpand %ymm0, %ymm11, %ymm11

vpsubw %ymm5,  %ymm4,  %ymm4
vpsubw %ymm7,  %ymm6,  %ymm5
vpsubw %ymm9,  %ymm8,  %ymm6
vpsubw %ymm11, %ymm10, %ymm7

vmovdqa %ymm4, 288(%rdi)
vmovdqa %ymm5, 320(%rdi)
vmovdqa %ymm6, 352(%rdi)
vmovdqa %ymm7, 384(%rdi)

vpsrld $13, %ymm2, %ymm4
vpsrld $13, %ymm3, %ymm5
vpsrld $14, %ymm2, %ymm6
vpsrld $14, %ymm3, %ymm7

vpand %ymm0, %ymm4, %ymm4
vpand %ymm0, %ymm5, %ymm5
vpand %ymm0, %ymm6, %ymm6
vpand %ymm0, %ymm7, %ymm7

vpsrld $15, %ymm2, %ymm8
vpsrld $15, %ymm3, %ymm9

vpand %ymm0, %ymm2, %ymm2
vpand %ymm0, %ymm3, %ymm3
vpand %ymm0, %ymm8, %ymm8
vpand %ymm0, %ymm9, %ymm9

vpsubw %ymm3, %ymm2, %ymm2
vpsubw %ymm5, %ymm4, %ymm3
vpsubw %ymm7, %ymm6, %ymm4
vpsubw %ymm9, %ymm8, %ymm5

vmovdqa %ymm2,    (%rdi)
vmovdqa %ymm3, 416(%rdi)
vmovdqa %ymm4, 448(%rdi)
vmovdqa %ymm5, 480(%rdi)

add $32,  %rdx
add $32,  %rsi
add $512, %rdi
cmp %r8,  %rdx
jb  _looptop_poly_sotp

ret


.global poly_sotp_inv
poly_sotp_inv:
vmovdqa _16x1(%rip), %ymm0
vpxor         %ymm1, %ymm1, %ymm1
vpxor         %ymm2, %ymm2, %ymm2

lea 1536(%rsi), %r8

.p2align 5
_looptop_poly_sotp_inv_1:
vpxor      %ymm2, %ymm2, %ymm2
vmovdqu   (%rdx), %ymm3
vmovdqu 96(%rdx), %ymm4

vmovdqa   (%rsi), %ymm5
vmovdqa 32(%rsi), %ymm6
vmovdqa 64(%rsi), %ymm7
vmovdqa 96(%rsi), %ymm8

vmovdqa     %ymm4, %ymm9
vpsrld  $1, %ymm4, %ymm10
vpsrld  $2, %ymm4, %ymm11
vpsrld  $3, %ymm4, %ymm12

vpand %ymm0, %ymm9,  %ymm9
vpand %ymm0, %ymm10, %ymm10
vpand %ymm0, %ymm11, %ymm11
vpand %ymm0, %ymm12, %ymm12

vpaddw %ymm9,  %ymm5, %ymm5
vpaddw %ymm10, %ymm6, %ymm6
vpaddw %ymm11, %ymm7, %ymm7
vpaddw %ymm12, %ymm8, %ymm8

vpor %ymm5, %ymm1, %ymm1
vpor %ymm6, %ymm1, %ymm1
vpor %ymm7, %ymm1, %ymm1
vpor %ymm8, %ymm1, %ymm1

vpslld $1, %ymm6, %ymm6
vpslld $2, %ymm7, %ymm7
vpslld $3, %ymm8, %ymm8

vpxor %ymm5, %ymm2, %ymm2
vpxor %ymm6, %ymm2, %ymm2
vpxor %ymm7, %ymm2, %ymm2
vpxor %ymm8, %ymm2, %ymm2

vmovdqa 128(%rsi), %ymm5
vmovdqa 160(%rsi), %ymm6
vmovdqa 192(%rsi), %ymm7
vmovdqa 224(%rsi), %ymm8

vpsrld  $4, %ymm4, %ymm9
vpsrld  $5, %ymm4, %ymm10
vpsrld  $6, %ymm4, %ymm11
vpsrld  $7, %ymm4, %ymm12

vpand %ymm0, %ymm9,  %ymm9
vpand %ymm0, %ymm10, %ymm10
vpand %ymm0, %ymm11, %ymm11
vpand %ymm0, %ymm12, %ymm12

vpaddw %ymm9,  %ymm5, %ymm5
vpaddw %ymm10, %ymm6, %ymm6
vpaddw %ymm11, %ymm7, %ymm7
vpaddw %ymm12, %ymm8, %ymm8

vpor %ymm5, %ymm1, %ymm1
vpor %ymm6, %ymm1, %ymm1
vpor %ymm7, %ymm1, %ymm1
vpor %ymm8, %ymm1, %ymm1

vpslld $4, %ymm5, %ymm5
vpslld $5, %ymm6, %ymm6
vpslld $6, %ymm7, %ymm7
vpslld $7, %ymm8, %ymm8

vpxor %ymm5, %ymm2, %ymm2
vpxor %ymm6, %ymm2, %ymm2
vpxor %ymm7, %ymm2, %ymm2
vpxor %ymm8, %ymm2, %ymm2

vmovdqa 256(%rsi), %ymm5
vmovdqa 288(%rsi), %ymm6
vmovdqa 320(%rsi), %ymm7
vmovdqa 352(%rsi), %ymm8

vpsrld  $8,  %ymm4, %ymm9
vpsrld  $9,  %ymm4, %ymm10
vpsrld  $10, %ymm4, %ymm11
vpsrld  $11, %ymm4, %ymm12

vpand %ymm0, %ymm9,  %ymm9
vpand %ymm0, %ymm10, %ymm10
vpand %ymm0, %ymm11, %ymm11
vpand %ymm0, %ymm12, %ymm12

vpaddw %ymm9,  %ymm5, %ymm5
vpaddw %ymm10, %ymm6, %ymm6
vpaddw %ymm11, %ymm7, %ymm7
vpaddw %ymm12, %ymm8, %ymm8

vpor %ymm5, %ymm1, %ymm1
vpor %ymm6, %ymm1, %ymm1
vpor %ymm7, %ymm1, %ymm1
vpor %ymm8, %ymm1, %ymm1

vpslld $8,  %ymm5, %ymm5
vpslld $9,  %ymm6, %ymm6
vpslld $10, %ymm7, %ymm7
vpslld $11, %ymm8, %ymm8

vpxor %ymm5, %ymm2, %ymm2
vpxor %ymm6, %ymm2, %ymm2
vpxor %ymm7, %ymm2, %ymm2
vpxor %ymm8, %ymm2, %ymm2

vmovdqa 384(%rsi), %ymm5
vmovdqa 416(%rsi), %ymm6
vmovdqa 448(%rsi), %ymm7
vmovdqa 480(%rsi), %ymm8

vpsrld $12, %ymm4, %ymm9
vpsrld $13, %ymm4, %ymm10
vpsrld $14, %ymm4, %ymm11
vpsrld $15, %ymm4, %ymm12

vpand %ymm0, %ymm9,  %ymm9
vpand %ymm0, %ymm10, %ymm10
vpand %ymm0, %ymm11, %ymm11
vpand %ymm0, %ymm12, %ymm12

vpaddw %ymm9,  %ymm5, %ymm5
vpaddw %ymm10, %ymm6, %ymm6
vpaddw %ymm11, %ymm7, %ymm7
vpaddw %ymm12, %ymm8, %ymm8

vpor %ymm5, %ymm1, %ymm1
vpor %ymm6, %ymm1, %ymm1
vpor %ymm7, %ymm1, %ymm1
vpor %ymm8, %ymm1, %ymm1

vpslld $12, %ymm5, %ymm5
vpslld $13, %ymm6, %ymm6
vpslld $14, %ymm7, %ymm7
vpslld $15, %ymm8, %ymm8

vpxor %ymm5, %ymm2, %ymm2
vpxor %ymm6, %ymm2, %ymm2
vpxor %ymm7, %ymm2, %ymm2
vpxor %ymm8, %ymm2, %ymm2

vpxor   %ymm3, %ymm2, %ymm2
vmovdqu %ymm2, (%rdi)

add $512, %rsi
add $32,  %rdi
add $32,  %rdx
cmp %r8,  %rsi
jb  _looptop_poly_sotp_inv_1

vpsrlw $1,    %ymm1, %ymm1
xor    %rax,  %rax
vptest %ymm1, %ymm1
setnz  %al

ret
*/
.section .note.GNU-stack,"",@progbits
