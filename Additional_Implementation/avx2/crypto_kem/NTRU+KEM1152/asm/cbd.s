.global poly_cbd1
poly_cbd1:
    vmovdqa _16x1(%rip), %ymm0

    lea 128(%rsi), %r8

.p2align 5
_looptop_poly_cbd1_1:
    vmovdqu   (%rsi), %ymm2
    vmovdqu 144(%rsi), %ymm3

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

    vpand  %ymm0, %ymm2, %ymm2
    vpand  %ymm0, %ymm3, %ymm3
    vpand  %ymm0, %ymm8, %ymm8
    vpand  %ymm0, %ymm9, %ymm9

    vpsubw %ymm3, %ymm2, %ymm2
    vpsubw %ymm5, %ymm4, %ymm3
    vpsubw %ymm7, %ymm6, %ymm4
    vpsubw %ymm9, %ymm8, %ymm5

    vmovdqa   %ymm2,   0(%rdi)
    vmovdqa   %ymm3, 416(%rdi)
    vmovdqa   %ymm4, 448(%rdi)
    vmovdqa   %ymm5, 480(%rdi)

    add  $32, %rsi
    add  $512, %rdi
    cmp  %r8, %rsi
    jb  _looptop_poly_cbd1_1

    vmovdqu    (%rsi), %xmm2
    vmovdqu 144(%rsi), %xmm3

    vpsrld $1, %xmm2, %xmm4
    vpsrld $1, %xmm3, %xmm5
    vpsrld $2, %xmm2, %xmm6
    vpsrld $2, %xmm3, %xmm7

    vpand %xmm0, %xmm4, %xmm4
    vpand %xmm0, %xmm5, %xmm5
    vpand %xmm0, %xmm6, %xmm6
    vpand %xmm0, %xmm7, %xmm7

    vpsrld $3, %xmm2, %xmm8
    vpsrld $3, %xmm3, %xmm9
    vpsrld $4, %xmm2, %xmm10
    vpsrld $4, %xmm3, %xmm11

    vpand %xmm0, %xmm8,  %xmm8
    vpand %xmm0, %xmm9,  %xmm9
    vpand %xmm0, %xmm10, %xmm10
    vpand %xmm0, %xmm11, %xmm11

    vpsubw %xmm5,  %xmm4,  %xmm4
    vpsubw %xmm7,  %xmm6,  %xmm5
    vpsubw %xmm9,  %xmm8,  %xmm6
    vpsubw %xmm11, %xmm10, %xmm7

    vmovdqa %xmm4,  16(%rdi)
    vmovdqa %xmm5,  32(%rdi)
    vmovdqa %xmm6,  48(%rdi)
    vmovdqa %xmm7,  64(%rdi)

    vpsrld $5, %xmm2, %xmm4
    vpsrld $5, %xmm3, %xmm5
    vpsrld $6, %xmm2, %xmm6
    vpsrld $6, %xmm3, %xmm7

    vpand %xmm0, %xmm4, %xmm4
    vpand %xmm0, %xmm5, %xmm5
    vpand %xmm0, %xmm6, %xmm6
    vpand %xmm0, %xmm7, %xmm7

    vpsrld $7, %xmm2, %xmm8
    vpsrld $7, %xmm3, %xmm9
    vpsrld $8, %xmm2, %xmm10
    vpsrld $8, %xmm3, %xmm11

    vpand %xmm0, %xmm8,  %xmm8
    vpand %xmm0, %xmm9,  %xmm9
    vpand %xmm0, %xmm10, %xmm10
    vpand %xmm0, %xmm11, %xmm11

    vpsubw %xmm5,  %xmm4,  %xmm4
    vpsubw %xmm7,  %xmm6,  %xmm5
    vpsubw %xmm9,  %xmm8,  %xmm6
    vpsubw %xmm11, %xmm10, %xmm7

    vmovdqa %xmm4, 80(%rdi)
    vmovdqa %xmm5, 96(%rdi)
    vmovdqa %xmm6, 112(%rdi)
    vmovdqa %xmm7, 128(%rdi)

    vpsrld $9, %xmm2, %xmm4
    vpsrld $9, %xmm3, %xmm5
    vpsrld $10, %xmm2, %xmm6
    vpsrld $10, %xmm3, %xmm7

    vpand %xmm0, %xmm4, %xmm4
    vpand %xmm0, %xmm5, %xmm5
    vpand %xmm0, %xmm6, %xmm6
    vpand %xmm0, %xmm7, %xmm7

    vpsrld $11, %xmm2, %xmm8
    vpsrld $11, %xmm3, %xmm9
    vpsrld $12, %xmm2, %xmm10
    vpsrld $12, %xmm3, %xmm11

    vpand %xmm0, %xmm8,  %xmm8
    vpand %xmm0, %xmm9,  %xmm9
    vpand %xmm0, %xmm10, %xmm10
    vpand %xmm0, %xmm11, %xmm11

    vpsubw %xmm5,  %xmm4,  %xmm4
    vpsubw %xmm7,  %xmm6,  %xmm5
    vpsubw %xmm9,  %xmm8,  %xmm6
    vpsubw %xmm11, %xmm10, %xmm7

    vmovdqa %xmm4, 144(%rdi)
    vmovdqa %xmm5, 160(%rdi)
    vmovdqa %xmm6, 176(%rdi)
    vmovdqa %xmm7, 192(%rdi)

    vpsrld $13, %xmm2, %xmm4
    vpsrld $13, %xmm3, %xmm5
    vpsrld $14, %xmm2, %xmm6
    vpsrld $14, %xmm3, %xmm7

    vpand %xmm0, %xmm4, %xmm4
    vpand %xmm0, %xmm5, %xmm5
    vpand %xmm0, %xmm6, %xmm6
    vpand %xmm0, %xmm7, %xmm7

    vpsrld $15, %xmm2, %xmm8
    vpsrld $15, %xmm3, %xmm9

    vpand  %xmm0, %xmm2, %xmm2
    vpand  %xmm0, %xmm3, %xmm3
    vpand  %xmm0, %xmm8, %xmm8
    vpand  %xmm0, %xmm9, %xmm9

    vpsubw %xmm3, %xmm2, %xmm2
    vpsubw %xmm5, %xmm4, %xmm3
    vpsubw %xmm7, %xmm6, %xmm4
    vpsubw %xmm9, %xmm8, %xmm5

    vmovdqa   %xmm2,   0(%rdi)
    vmovdqa   %xmm3, 208(%rdi)
    vmovdqa   %xmm4, 224(%rdi)
    vmovdqa   %xmm5, 240(%rdi)

    ret

.global poly_sotp
poly_sotp:

    vmovdqa _16x1(%rip), %ymm0

    lea 128(%rdx), %r8

.p2align 5
_looptop_poly_sotp_1:

    vmovdqu    (%rsi),%ymm1
    vmovdqu    (%rdx),%ymm2
    vmovdqu 144(%rdx),%ymm3

    #msg xor g1
    vpxor %ymm1,%ymm2,%ymm2

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

    vpand  %ymm0, %ymm2, %ymm2
    vpand  %ymm0, %ymm3, %ymm3
    vpand  %ymm0, %ymm8, %ymm8
    vpand  %ymm0, %ymm9, %ymm9

    vpsubw %ymm3, %ymm2, %ymm2
    vpsubw %ymm5, %ymm4, %ymm3
    vpsubw %ymm7, %ymm6, %ymm4
    vpsubw %ymm9, %ymm8, %ymm5

    vmovdqa   %ymm2,   0(%rdi)
    vmovdqa   %ymm3, 416(%rdi)
    vmovdqa   %ymm4, 448(%rdi)
    vmovdqa   %ymm5, 480(%rdi)

    add  $32, %rsi
    add  $32, %rdx
    add  $512, %rdi
    cmp  %r8, %rdx
    jb  _looptop_poly_sotp_1

    vmovdqu    (%rsi), %xmm1    
    vmovdqu    (%rdx), %xmm2
    vmovdqu 144(%rdx), %xmm3

    #msg xor g1
    vpxor %xmm1,%xmm2,%xmm2

    vpsrld $1, %xmm2, %xmm4
    vpsrld $1, %xmm3, %xmm5
    vpsrld $2, %xmm2, %xmm6
    vpsrld $2, %xmm3, %xmm7

    vpand %xmm0, %xmm4, %xmm4
    vpand %xmm0, %xmm5, %xmm5
    vpand %xmm0, %xmm6, %xmm6
    vpand %xmm0, %xmm7, %xmm7

    vpsrld $3, %xmm2, %xmm8
    vpsrld $3, %xmm3, %xmm9
    vpsrld $4, %xmm2, %xmm10
    vpsrld $4, %xmm3, %xmm11

    vpand %xmm0, %xmm8,  %xmm8
    vpand %xmm0, %xmm9,  %xmm9
    vpand %xmm0, %xmm10, %xmm10
    vpand %xmm0, %xmm11, %xmm11

    vpsubw %xmm5,  %xmm4,  %xmm4
    vpsubw %xmm7,  %xmm6,  %xmm5
    vpsubw %xmm9,  %xmm8,  %xmm6
    vpsubw %xmm11, %xmm10, %xmm7

    vmovdqa %xmm4,  16(%rdi)
    vmovdqa %xmm5,  32(%rdi)
    vmovdqa %xmm6,  48(%rdi)
    vmovdqa %xmm7,  64(%rdi)

    vpsrld $5, %xmm2, %xmm4
    vpsrld $5, %xmm3, %xmm5
    vpsrld $6, %xmm2, %xmm6
    vpsrld $6, %xmm3, %xmm7

    vpand %xmm0, %xmm4, %xmm4
    vpand %xmm0, %xmm5, %xmm5
    vpand %xmm0, %xmm6, %xmm6
    vpand %xmm0, %xmm7, %xmm7

    vpsrld $7, %xmm2, %xmm8
    vpsrld $7, %xmm3, %xmm9
    vpsrld $8, %xmm2, %xmm10
    vpsrld $8, %xmm3, %xmm11

    vpand %xmm0, %xmm8,  %xmm8
    vpand %xmm0, %xmm9,  %xmm9
    vpand %xmm0, %xmm10, %xmm10
    vpand %xmm0, %xmm11, %xmm11

    vpsubw %xmm5,  %xmm4,  %xmm4
    vpsubw %xmm7,  %xmm6,  %xmm5
    vpsubw %xmm9,  %xmm8,  %xmm6
    vpsubw %xmm11, %xmm10, %xmm7

    vmovdqa %xmm4, 80(%rdi)
    vmovdqa %xmm5, 96(%rdi)
    vmovdqa %xmm6, 112(%rdi)
    vmovdqa %xmm7, 128(%rdi)

    vpsrld $9, %xmm2, %xmm4
    vpsrld $9, %xmm3, %xmm5
    vpsrld $10, %xmm2, %xmm6
    vpsrld $10, %xmm3, %xmm7

    vpand %xmm0, %xmm4, %xmm4
    vpand %xmm0, %xmm5, %xmm5
    vpand %xmm0, %xmm6, %xmm6
    vpand %xmm0, %xmm7, %xmm7

    vpsrld $11, %xmm2, %xmm8
    vpsrld $11, %xmm3, %xmm9
    vpsrld $12, %xmm2, %xmm10
    vpsrld $12, %xmm3, %xmm11

    vpand %xmm0, %xmm8,  %xmm8
    vpand %xmm0, %xmm9,  %xmm9
    vpand %xmm0, %xmm10, %xmm10
    vpand %xmm0, %xmm11, %xmm11

    vpsubw %xmm5,  %xmm4,  %xmm4
    vpsubw %xmm7,  %xmm6,  %xmm5
    vpsubw %xmm9,  %xmm8,  %xmm6
    vpsubw %xmm11, %xmm10, %xmm7

    vmovdqa %xmm4, 144(%rdi)
    vmovdqa %xmm5, 160(%rdi)
    vmovdqa %xmm6, 176(%rdi)
    vmovdqa %xmm7, 192(%rdi)

    vpsrld $13, %xmm2, %xmm4
    vpsrld $13, %xmm3, %xmm5
    vpsrld $14, %xmm2, %xmm6
    vpsrld $14, %xmm3, %xmm7

    vpand %xmm0, %xmm4, %xmm4
    vpand %xmm0, %xmm5, %xmm5
    vpand %xmm0, %xmm6, %xmm6
    vpand %xmm0, %xmm7, %xmm7

    vpsrld $15, %xmm2, %xmm8
    vpsrld $15, %xmm3, %xmm9

    vpand  %xmm0, %xmm2, %xmm2
    vpand  %xmm0, %xmm3, %xmm3
    vpand  %xmm0, %xmm8, %xmm8
    vpand  %xmm0, %xmm9, %xmm9

    vpsubw %xmm3, %xmm2, %xmm2
    vpsubw %xmm5, %xmm4, %xmm3
    vpsubw %xmm7, %xmm6, %xmm4
    vpsubw %xmm9, %xmm8, %xmm5

    vmovdqa   %xmm2,   0(%rdi)
    vmovdqa   %xmm3, 208(%rdi)
    vmovdqa   %xmm4, 224(%rdi)
    vmovdqa   %xmm5, 240(%rdi)

    ret

.global poly_sotp_inv
poly_sotp_inv:
vmovdqa		_16x1(%rip),%ymm0
vmovdqa		_8x1(%rip),%ymm4
vmovdqa		_8x1(%rip),%ymm5

xor		 %rax,%rax
vpxor %ymm8,%ymm8,%ymm8

.p2align 5
_looptop_poly_sotp_inv_1:
vmovdqu (%rsi),%ymm1
vmovdqu (%rdx),%ymm2
vmovdqu 144(%rdx),%ymm3

vpand %ymm0,%ymm3,%ymm6
vpaddw	 %ymm6,%ymm1,%ymm7
vpor %ymm7,%ymm8,%ymm8

xor %r8,%r8
add $32,%r8
vmovdqa %ymm5,%ymm4
.p2align 5
_looptop_poly_sotp_inv_1_1:
vmovdqu (%rsi, %r8),%ymm1
vpsrld		$1,%ymm3,%ymm3
vpand %ymm0,%ymm3,%ymm6
vpaddw	 %ymm6,%ymm1,%ymm6
vpor %ymm6,%ymm8,%ymm8
vpsllvd		%ymm4,%ymm6,%ymm6
vpxor %ymm6,%ymm7,%ymm7
vpaddw %ymm5,%ymm4,%ymm4

add $32,%r8
cmp $512,%r8
jb _looptop_poly_sotp_inv_1_1

vpxor %ymm7,%ymm2,%ymm2
vmovdqu %ymm2,(%rdi)

add		$32,%rdi
add		$32,%rdx
add		$512,%rsi
add		$512,%rax
cmp		$2048,%rax
jb		_looptop_poly_sotp_inv_1

vperm2i128	$0x01,%ymm8,%ymm8,%ymm9
por	 	%xmm9,%xmm8

vmovdqa		_8x1(%rip),%xmm4

vmovdqu (%rsi),%xmm1
vmovdqu (%rdx),%xmm2
vmovdqu 144(%rdx),%xmm3

vpand %xmm0,%xmm3,%xmm6
vpaddw	 %xmm6,%xmm1,%xmm7
vpor %xmm7,%xmm8,%xmm8

xor %r8,%r8
add $16,%r8
.p2align 5
_looptop_poly_sotp_inv_2:
vmovdqu (%rsi, %r8),%xmm1
vpsrld		$1,%xmm3,%xmm3
vpand %xmm0,%xmm3,%xmm6
vpaddw	 %xmm6,%xmm1,%xmm6
vpor %xmm6,%xmm8,%xmm8
vpsllvd		%xmm4,%xmm6,%xmm6
vpxor %xmm6,%xmm7,%xmm7
vpaddw %xmm5,%xmm4,%xmm4

add $16,%r8
cmp $256,%r8
jb _looptop_poly_sotp_inv_2

vpxor %xmm7,%xmm2,%xmm2
vmovdqu %xmm2,(%rdi)

vpshufd		$0x0E,%xmm8,%xmm9
por		 %xmm9,%xmm8
movq %xmm8,%rax

movq %rax,%rcx
shr $32,%rcx
or %rcx,%rax
movq %rax,%rcx
shr $16,%rcx
or %rcx,%rax
movzx %ax,%rax

shr $1,%rax
neg %rax
shr $63,%rax

ret
