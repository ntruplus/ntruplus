.global poly_cbd1
poly_cbd1:
vmovdqa _16x1(%rip), %ymm0

vmovdqu  56(%rsi), %xmm2
vmovdqu 128(%rsi), %xmm3

vpsrld $15, %xmm2, %xmm4
vpsrld $15, %xmm3, %xmm5
vpsrld $14, %xmm2, %xmm6
vpsrld $14, %xmm3, %xmm7

vpand %xmm0, %xmm4, %xmm4
vpand %xmm0, %xmm5, %xmm5
vpand %xmm0, %xmm6, %xmm6
vpand %xmm0, %xmm7, %xmm7

vpsrld $13, %xmm2, %xmm8
vpsrld $13, %xmm3, %xmm9
vpsrld $12, %xmm2, %xmm10
vpsrld $12, %xmm3, %xmm11

vpand %xmm0, %xmm8,  %xmm8
vpand %xmm0, %xmm9,  %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11

vpsubw %xmm5,  %xmm4,  %xmm4
vpsubw %xmm7,  %xmm6,  %xmm6
vpsubw %xmm9,  %xmm8,  %xmm8
vpsubw %xmm11, %xmm10, %xmm10

vpunpckhqdq %xmm4, %xmm6,  %xmm15
vpunpckhqdq %xmm8, %xmm10, %xmm14

vpsrld $11, %xmm2, %xmm4
vpsrld $11, %xmm3, %xmm5
vpsrld $10, %xmm2, %xmm6
vpsrld $10, %xmm3, %xmm7

vpand %xmm0, %xmm4, %xmm4
vpand %xmm0, %xmm5, %xmm5
vpand %xmm0, %xmm6, %xmm6
vpand %xmm0, %xmm7, %xmm7

vpsrld $9, %xmm2, %xmm8
vpsrld $9, %xmm3, %xmm9
vpsrld $8, %xmm2, %xmm10
vpsrld $8, %xmm3, %xmm11

vpand %xmm0, %xmm8,  %xmm8
vpand %xmm0, %xmm9,  %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11

vpsubw %xmm5,  %xmm4,  %xmm4
vpsubw %xmm7,  %xmm6,  %xmm6
vpsubw %xmm9,  %xmm8,  %xmm8
vpsubw %xmm11, %xmm10, %xmm10

vpunpckhqdq %xmm4, %xmm6,  %xmm13
vpunpckhqdq %xmm8, %xmm10, %xmm12

vmovdqa %xmm15, 1136(%rdi)
vmovdqa %xmm14, 1120(%rdi)
vmovdqa %xmm13, 1104(%rdi)
vmovdqa %xmm12, 1088(%rdi)

vpsrld $7, %xmm2, %xmm4
vpsrld $7, %xmm3, %xmm5
vpsrld $6, %xmm2, %xmm6
vpsrld $6, %xmm3, %xmm7

vpand %xmm0, %xmm4, %xmm4
vpand %xmm0, %xmm5, %xmm5
vpand %xmm0, %xmm6, %xmm6
vpand %xmm0, %xmm7, %xmm7

vpsrld $5, %xmm2, %xmm8
vpsrld $5, %xmm3, %xmm9
vpsrld $4, %xmm2, %xmm10
vpsrld $4, %xmm3, %xmm11

vpand %xmm0, %xmm8,  %xmm8
vpand %xmm0, %xmm9,  %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11

vpsubw %xmm5,  %xmm4,  %xmm4
vpsubw %xmm7,  %xmm6,  %xmm6
vpsubw %xmm9,  %xmm8,  %xmm8
vpsubw %xmm11, %xmm10, %xmm10

vpunpckhqdq %xmm4, %xmm6,  %xmm15
vpunpckhqdq %xmm8, %xmm10, %xmm14

vpsrld $3, %xmm2, %xmm4
vpsrld $3, %xmm3, %xmm5
vpsrld $2, %xmm2, %xmm6
vpsrld $2, %xmm3, %xmm7

vpand %xmm0, %xmm4, %xmm4
vpand %xmm0, %xmm5, %xmm5
vpand %xmm0, %xmm6, %xmm6
vpand %xmm0, %xmm7, %xmm7

vpsrld $1, %xmm2, %xmm8
vpsrld $1, %xmm3, %xmm9

vpand %xmm0, %xmm8, %xmm8
vpand %xmm0, %xmm9, %xmm9
vpand %xmm0, %xmm2, %xmm2
vpand %xmm0, %xmm3, %xmm3

vpsubw %xmm5, %xmm4, %xmm4
vpsubw %xmm7, %xmm6, %xmm6
vpsubw %xmm9, %xmm8, %xmm8
vpsubw %xmm3, %xmm2, %xmm10

vpunpckhqdq %xmm4, %xmm6,  %xmm13
vpunpckhqdq %xmm8, %xmm10, %xmm12

vmovdqa %xmm15, 1072(%rdi)
vmovdqa %xmm14, 1056(%rdi)
vmovdqa %xmm13, 1040(%rdi)
vmovdqa %xmm12, 1024(%rdi)

lea 64(%rsi), %r8

.p2align 5
_looptop_poly_cbd1_1:
vmovdqu   (%rsi), %ymm2
vmovdqu 72(%rsi), %ymm3

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

vpsrld $9,  %ymm2, %ymm4
vpsrld $9,  %ymm3, %ymm5
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

add $32,  %rsi
add $512, %rdi
cmp %r8,  %rsi
jb  _looptop_poly_cbd1_1

ret


.global poly_sotp
poly_sotp:
vmovdqa _16x1(%rip), %ymm0

vmovdqu  56(%rsi), %xmm1
vmovdqu  56(%rdx), %xmm2
vmovdqu 128(%rdx), %xmm3

vpxor %xmm1, %xmm2, %xmm2

vpsrld $15, %xmm2, %xmm4
vpsrld $15, %xmm3, %xmm5
vpsrld $14, %xmm2, %xmm6
vpsrld $14, %xmm3, %xmm7

vpand %xmm0, %xmm4, %xmm4
vpand %xmm0, %xmm5, %xmm5
vpand %xmm0, %xmm6, %xmm6
vpand %xmm0, %xmm7, %xmm7

vpsrld $13, %xmm2, %xmm8
vpsrld $13, %xmm3, %xmm9
vpsrld $12, %xmm2, %xmm10
vpsrld $12, %xmm3, %xmm11

vpand %xmm0, %xmm8,  %xmm8
vpand %xmm0, %xmm9,  %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11

vpsubw %xmm5,  %xmm4,  %xmm4
vpsubw %xmm7,  %xmm6,  %xmm6
vpsubw %xmm9,  %xmm8,  %xmm8
vpsubw %xmm11, %xmm10, %xmm10

vpunpckhqdq   %xmm4, %xmm6,  %xmm15
vpunpckhqdq   %xmm8, %xmm10, %xmm14

vpsrld $11, %xmm2, %xmm4
vpsrld $11, %xmm3, %xmm5
vpsrld $10, %xmm2, %xmm6
vpsrld $10, %xmm3, %xmm7

vpand %xmm0, %xmm4, %xmm4
vpand %xmm0, %xmm5, %xmm5
vpand %xmm0, %xmm6, %xmm6
vpand %xmm0, %xmm7, %xmm7

vpsrld $9, %xmm2, %xmm8
vpsrld $9, %xmm3, %xmm9
vpsrld $8, %xmm2, %xmm10
vpsrld $8, %xmm3, %xmm11

vpand %xmm0, %xmm8,  %xmm8
vpand %xmm0, %xmm9,  %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11

vpsubw %xmm5,  %xmm4,  %xmm4
vpsubw %xmm7,  %xmm6,  %xmm6
vpsubw %xmm9,  %xmm8,  %xmm8
vpsubw %xmm11, %xmm10, %xmm10

vpunpckhqdq %xmm4, %xmm6,  %xmm13
vpunpckhqdq %xmm8, %xmm10, %xmm12

vmovdqa %xmm15, 1136(%rdi)
vmovdqa %xmm14, 1120(%rdi)
vmovdqa %xmm13, 1104(%rdi)
vmovdqa %xmm12, 1088(%rdi)

vpsrld $7, %xmm2, %xmm4
vpsrld $7, %xmm3, %xmm5
vpsrld $6, %xmm2, %xmm6
vpsrld $6, %xmm3, %xmm7

vpand %xmm0, %xmm4, %xmm4
vpand %xmm0, %xmm5, %xmm5
vpand %xmm0, %xmm6, %xmm6
vpand %xmm0, %xmm7, %xmm7

vpsrld $5, %xmm2, %xmm8
vpsrld $5, %xmm3, %xmm9
vpsrld $4, %xmm2, %xmm10
vpsrld $4, %xmm3, %xmm11

vpand %xmm0, %xmm8, %xmm8
vpand %xmm0, %xmm9, %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11

vpsubw %xmm5,  %xmm4,  %xmm4
vpsubw %xmm7,  %xmm6,  %xmm6
vpsubw %xmm9,  %xmm8,  %xmm8
vpsubw %xmm11, %xmm10, %xmm10

vpunpckhqdq %xmm4, %xmm6,  %xmm15
vpunpckhqdq %xmm8, %xmm10, %xmm14

vpsrld $3, %xmm2, %xmm4
vpsrld $3, %xmm3, %xmm5
vpsrld $2, %xmm2, %xmm6
vpsrld $2, %xmm3, %xmm7

vpand %xmm0, %xmm4, %xmm4
vpand %xmm0, %xmm5, %xmm5
vpand %xmm0, %xmm6, %xmm6
vpand %xmm0, %xmm7, %xmm7

vpsrld $1, %xmm2, %xmm8
vpsrld $1, %xmm3, %xmm9

vpand %xmm0, %xmm8, %xmm8
vpand %xmm0, %xmm9, %xmm9
vpand %xmm0, %xmm2, %xmm2
vpand %xmm0, %xmm3, %xmm3

vpsubw %xmm5, %xmm4, %xmm4
vpsubw %xmm7, %xmm6, %xmm6
vpsubw %xmm9, %xmm8, %xmm8
vpsubw %xmm3, %xmm2, %xmm10

vpunpckhqdq %xmm4, %xmm6,  %xmm13
vpunpckhqdq %xmm8, %xmm10, %xmm12

vmovdqa %xmm15, 1072(%rdi)
vmovdqa %xmm14, 1056(%rdi)
vmovdqa %xmm13, 1040(%rdi)
vmovdqa %xmm12, 1024(%rdi)

lea 64(%rdx), %r8

.p2align 5
_looptop_poly_sotp:
vmovdqu   (%rsi), %ymm1
vmovdqu   (%rdx), %ymm2
vmovdqu 72(%rdx), %ymm3

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

vmovdqu  56(%rdx), %xmm3
vmovdqu 128(%rdx), %xmm4

vmovdqu 1016(%rsi), %xmm5
vmovdqa 1024(%rsi), %xmm6
vmovdqu 1032(%rsi), %xmm7
vmovdqu 1040(%rsi), %xmm8

vmovdqa     %xmm4, %xmm9
vpsrld  $1, %xmm4, %xmm10
vpsrld  $2, %xmm4, %xmm11
vpsrld  $3, %xmm4, %xmm12

vpand %xmm0, %xmm9,  %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11
vpand %xmm0, %xmm12, %xmm12

vpaddw %xmm9,  %xmm5, %xmm5
vpaddw %xmm10, %xmm6, %xmm6
vpaddw %xmm11, %xmm7, %xmm7
vpaddw %xmm12, %xmm8, %xmm8

vpor %xmm5, %xmm1, %xmm1
vpor %xmm6, %xmm1, %xmm1
vpor %xmm7, %xmm1, %xmm1
vpor %xmm8, %xmm1, %xmm1

vpslld $1, %xmm6, %xmm6
vpslld $2, %xmm7, %xmm7
vpslld $3, %xmm8, %xmm8

vpxor %xmm5, %xmm2, %xmm2
vpxor %xmm6, %xmm2, %xmm2
vpxor %xmm7, %xmm2, %xmm2
vpxor %xmm8, %xmm2, %xmm2

vmovdqu 1048(%rsi), %xmm5
vmovdqu 1056(%rsi), %xmm6
vmovdqu 1064(%rsi), %xmm7
vmovdqu 1072(%rsi), %xmm8

vpsrld $4, %xmm4, %xmm9
vpsrld $5, %xmm4, %xmm10
vpsrld $6, %xmm4, %xmm11
vpsrld $7, %xmm4, %xmm12

vpand %xmm0, %xmm9,  %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11
vpand %xmm0, %xmm12, %xmm12

vpaddw %xmm9,  %xmm5, %xmm5
vpaddw %xmm10, %xmm6, %xmm6
vpaddw %xmm11, %xmm7, %xmm7
vpaddw %xmm12, %xmm8, %xmm8

vpor %xmm5, %xmm1, %xmm1
vpor %xmm6, %xmm1, %xmm1
vpor %xmm7, %xmm1, %xmm1
vpor %xmm8, %xmm1, %xmm1

vpslld $4, %xmm5, %xmm5
vpslld $5, %xmm6, %xmm6
vpslld $6, %xmm7, %xmm7
vpslld $7, %xmm8, %xmm8

vpxor %xmm5, %xmm2, %xmm2
vpxor %xmm6, %xmm2, %xmm2
vpxor %xmm7, %xmm2, %xmm2
vpxor %xmm8, %xmm2, %xmm2

vmovdqu 1080(%rsi), %xmm5
vmovdqu 1088(%rsi), %xmm6
vmovdqu 1096(%rsi), %xmm7
vmovdqu 1104(%rsi), %xmm8

vpsrld $8, %xmm4, %xmm9
vpsrld $9, %xmm4, %xmm10
vpsrld $10, %xmm4, %xmm11
vpsrld $11, %xmm4, %xmm12

vpand %xmm0, %xmm9,  %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11
vpand %xmm0, %xmm12, %xmm12

vpaddw %xmm9,  %xmm5, %xmm5
vpaddw %xmm10, %xmm6, %xmm6
vpaddw %xmm11, %xmm7, %xmm7
vpaddw %xmm12, %xmm8, %xmm8

vpor %xmm5, %xmm1, %xmm1
vpor %xmm6, %xmm1, %xmm1
vpor %xmm7, %xmm1, %xmm1
vpor %xmm8, %xmm1, %xmm1

vpslld $8, %xmm5, %xmm5
vpslld $9, %xmm6, %xmm6
vpslld $10, %xmm7, %xmm7
vpslld $11, %xmm8, %xmm8

vpxor %xmm5, %xmm2, %xmm2
vpxor %xmm6, %xmm2, %xmm2
vpxor %xmm7, %xmm2, %xmm2
vpxor %xmm8, %xmm2, %xmm2

vmovdqu 1112(%rsi), %xmm5
vmovdqu 1120(%rsi), %xmm6
vmovdqu 1128(%rsi), %xmm7
vmovdqu 1136(%rsi), %xmm8

vpsrld $12, %xmm4, %xmm9
vpsrld $13, %xmm4, %xmm10
vpsrld $14, %xmm4, %xmm11
vpsrld $15, %xmm4, %xmm12

vpand %xmm0, %xmm9,  %xmm9
vpand %xmm0, %xmm10, %xmm10
vpand %xmm0, %xmm11, %xmm11
vpand %xmm0, %xmm12, %xmm12

vpaddw %xmm9,  %xmm5, %xmm5
vpaddw %xmm10, %xmm6, %xmm6
vpaddw %xmm11, %xmm7, %xmm7
vpaddw %xmm12, %xmm8, %xmm8

vpor %xmm5, %xmm1, %xmm1
vpor %xmm6, %xmm1, %xmm1
vpor %xmm7, %xmm1, %xmm1
vpor %xmm8, %xmm1, %xmm1

vpslld $12, %xmm5, %xmm5
vpslld $13, %xmm6, %xmm6
vpslld $14, %xmm7, %xmm7
vpslld $15, %xmm8, %xmm8

vpxor %xmm5, %xmm2, %xmm2
vpxor %xmm6, %xmm2, %xmm2
vpxor %xmm7, %xmm2, %xmm2
vpxor %xmm8, %xmm2, %xmm2

vpxor   %xmm3, %xmm2, %xmm2
vmovdqu %xmm2,56(%rdi)

vpunpckhqdq %xmm1, %xmm1, %xmm1

lea 1024(%rsi), %r8

.p2align 5
_looptop_poly_sotp_inv_1:
vpxor      %ymm2, %ymm2, %ymm2
vmovdqu   (%rdx), %ymm3
vmovdqu 72(%rdx), %ymm4

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

vpsrld $4, %ymm4, %ymm9
vpsrld $5, %ymm4, %ymm10
vpsrld $6, %ymm4, %ymm11
vpsrld $7, %ymm4, %ymm12

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

vpsrld $8,  %ymm4, %ymm9
vpsrld $9,  %ymm4, %ymm10
vpsrld $10, %ymm4, %ymm11
vpsrld $11, %ymm4, %ymm12

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
