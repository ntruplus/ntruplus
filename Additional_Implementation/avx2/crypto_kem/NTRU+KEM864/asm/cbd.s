
.global poly_cbd1
poly_cbd1:
    vmovdqa _16x1(%rip), %ymm0
    
    vmovdqu  88(%rsi), %xmm2
    vmovdqu 196(%rsi), %xmm3

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

    vpand %xmm0, %xmm8, %xmm8
    vpand %xmm0, %xmm9, %xmm9
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

    vpunpckhqdq   %xmm4, %xmm6,  %xmm13
    vpunpckhqdq   %xmm8, %xmm10, %xmm12

    vmovdqa %xmm15, 1648(%rdi)
    vmovdqa %xmm14, 1632(%rdi)
    vmovdqa %xmm13, 1616(%rdi)
    vmovdqa %xmm12, 1600(%rdi)

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

    vpunpckhqdq   %xmm4, %xmm6,  %xmm15
    vpunpckhqdq   %xmm8, %xmm10, %xmm14

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

    vmovdqa %xmm15,  1584(%rdi)
    vmovdqa %xmm14,  1568(%rdi)
    vmovdqa %xmm13,  1552(%rdi)
    vmovdqa %xmm12,  1536(%rdi)

    lea 96(%rsi), %r8

.p2align 5
_looptop_poly_cbd1_1:
    vmovdqu    (%rsi), %ymm2
    vmovdqu 108(%rsi), %ymm3

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

    add $128, %rdi
    add $8,%rsi

    vpbroadcastd (%rsi), %ymm2
    vpbroadcastd 108(%rsi), %ymm3
    
    vpand       %ymm0,%ymm2,%ymm4
    vpand       %ymm0,%ymm3,%ymm5
    vpsubw      %ymm5,%ymm4,%ymm1
    movq        %xmm1,%rax
    mov         %eax,(%rdi)
    
    xor         %r8,%r8
    add         $4,%r8
    _looptop_poly_cbd1_3:
    vpsrld		$1,%ymm2,%ymm2
    vpsrld		$1,%ymm3,%ymm3
    vpand       %ymm0,%ymm2,%ymm4
    vpand       %ymm0,%ymm3,%ymm5
    vpsubw      %ymm5,%ymm4,%ymm1
    movq        %xmm1,%rax
    mov         %eax,(%rdi,%r8)
    
    add         $4,%r8
    cmp         $64,%r8
    jb          _looptop_poly_cbd1_3
    
    ret    
    
    ret

/*
.global poly_cbd1
poly_cbd1:

vmovdqa		_16x1(%rip),%ymm0
xor		    %rax,%rax
.p2align 5
_looptop_poly_cbd1_1:
vmovdqu  	(%rsi),%ymm2
vmovdqu  	108(%rsi),%ymm3

vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
vmovdqa     %ymm1,(%rdi)

xor         %r8,%r8
add         $32,%r8
_looptop_poly_cbd1_1_1:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
vmovdqa     %ymm1,(%rdi,%r8)

add         $32,%r8
cmp         $512,%r8
jb          _looptop_poly_cbd1_1_1

add		$32,%rsi
add		$512,%rdi
add		$512,%rax
cmp		$1536,%rax
jb		_looptop_poly_cbd1_1

movq         (%rsi),%mm2
movq       108(%rsi),%mm3

movq    _16x1(%rip),%mm4
movq    _16x1(%rip),%mm5
pand        %mm2,%mm4
pand        %mm3,%mm5
psubw       %mm5,%mm4
movq        %mm4,(%rdi)

xor         %r8,%r8
add         $8,%r8
_looptop_poly_cbd1_2:
psrlw 		$1,%mm2
psrlw		$1,%mm3

movq    _16x1(%rip),%mm4
movq    _16x1(%rip),%mm5
pand        %mm2,%mm4
pand        %mm3,%mm5
psubw       %mm5,%mm4
movq        %mm4,(%rdi,%r8)
add         $8,%r8
cmp         $128,%r8
jb          _looptop_poly_cbd1_2

add		$8,%rsi
add		$128,%rdi 

vpbroadcastd (%rsi), %ymm2
vpbroadcastd 108(%rsi), %ymm3

vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
movq        %xmm1,%rax
mov         %eax,(%rdi)

xor         %r8,%r8
add         $4,%r8
_looptop_poly_cbd1_3:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
movq        %xmm1,%rax
mov         %eax,(%rdi,%r8)

add         $4,%r8
cmp         $64,%r8
jb          _looptop_poly_cbd1_3

ret
*/
.global poly_sotp
poly_sotp:

vmovdqa		_16x1(%rip),%ymm0
xor		    %rax,%rax
.p2align 5
_looptop_poly_sotp_1:
vmovdqu  	  (%rsi),%ymm1
vmovdqu   	  (%rdx),%ymm2
vmovdqu     108(%rdx),%ymm3

#msg xor g1
vpxor       %ymm1,%ymm2,%ymm2

vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
vmovdqa     %ymm1,(%rdi)

xor         %r8,%r8
add         $32,%r8
_looptop_poly_sotp_1_1:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
vmovdqa     %ymm1,(%rdi,%r8)

add         $32,%r8
cmp         $512,%r8
jb          _looptop_poly_sotp_1_1

add		$32,%rsi
add		$32,%rdx
add		$512,%rdi
add		$512,%rax
cmp		$1536,%rax
jb		_looptop_poly_sotp_1

movq         (%rsi),%mm1
movq         (%rdx),%mm2
movq       108(%rdx),%mm3

#msg xor g1
pxor        %mm1,%mm2

movq        _16x1(%rip),%mm4
movq        %mm4,%mm5
pand        %mm2,%mm4
pand        %mm3,%mm5
psubw       %mm5,%mm4
movq        %mm4,(%rdi)

xor         %r8,%r8
add         $8,%r8
_looptop_poly_sotp_2:
psrlw 		$1,%mm2
psrlw		$1,%mm3

movq        _16x1(%rip),%mm4
movq        %mm4,%mm5
pand        %mm2,%mm4
pand        %mm3,%mm5
psubw       %mm5,%mm4
movq        %mm4,(%rdi,%r8)
add         $8,%r8
cmp         $128,%r8
jb          _looptop_poly_sotp_2

add		$8,%rsi
add		$8,%rdx
add		$128,%rdi 

vpbroadcastd (%rsi),%ymm1
vpbroadcastd (%rdx), %ymm2
vpbroadcastd 108(%rdx), %ymm3

#msg xor g1
vpxor       %ymm1,%ymm2,%ymm2

vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
movq        %xmm1,%rax
mov         %eax,(%rdi)

xor         %r8,%r8
add         $4,%r8
_looptop_poly_sotp_3:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
movq        %xmm1,%rax
mov         %eax,(%rdi,%r8)

add         $4,%r8
cmp         $64,%r8
jb          _looptop_poly_sotp_3

ret

.global poly_sotp_inv
poly_sotp_inv:
vmovdqa		_16x1(%rip),%ymm0
vmovdqa		_8x1(%rip),%ymm4
vmovdqa		_8x1(%rip),%ymm5

xor		    %rax,%rax
vpxor       %ymm8,%ymm8,%ymm8

.p2align 5
_looptop_poly_sotp_inv_1:
vmovdqu       (%rsi),%ymm1
vmovdqu       (%rdx),%ymm2
vmovdqu     108(%rdx),%ymm3

vpand       %ymm0,%ymm3,%ymm6
vpaddw	    %ymm6,%ymm1,%ymm7
vpor        %ymm7,%ymm8,%ymm8

xor         %r8,%r8
add         $32,%r8
vmovdqa     %ymm5,%ymm4
.p2align 5
_looptop_poly_sotp_inv_1_1:
vmovdqu     (%rsi, %r8),%ymm1
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm3,%ymm6
vpaddw	    %ymm6,%ymm1,%ymm6
vpor        %ymm6,%ymm8,%ymm8
vpsllvd		%ymm4,%ymm6,%ymm6
vpxor       %ymm6,%ymm7,%ymm7
vpaddw      %ymm5,%ymm4,%ymm4

add         $32,%r8
cmp         $512,%r8
jb          _looptop_poly_sotp_inv_1_1

vpxor       %ymm7,%ymm2,%ymm2
vmovdqu     %ymm2,(%rdi)

add		$32,%rdi
add		$32,%rdx
add		$512,%rsi
add		$512,%rax
cmp		$1536,%rax
jb		_looptop_poly_sotp_inv_1

vperm2i128	$0x01,%ymm8,%ymm8,%ymm9
por	    	%xmm9,%xmm8
vpshufd		$0x0E,%xmm8,%xmm9
por		    %xmm9,%xmm8
movq        %xmm8,%rax

#mmx
pxor        %mm5,%mm5

movq        (%rsi),%mm1
movq        108(%rdx),%mm3

movq        _16x1(%rip),%mm7
pand        %mm3,%mm7
paddw	    %mm1,%mm7
por         %mm7,%mm5

xor         %r8,%r8
add         $8,%r8
movq        _4x01(%rip),%mm2
movq        _4x01(%rip),%mm4
.p2align 5
_looptop_poly_sotp_inv_2:
movq        (%rsi,%r8),%mm1
psrlw 		$1,%mm3
movq        _16x1(%rip),%mm6
pand        %mm3,%mm6
paddw	    %mm1,%mm6
por         %mm6,%mm5
psllw       %mm4,%mm6
pxor        %mm6,%mm7
paddw       %mm2,%mm4

add         $8,%r8
cmp         $128,%r8
jb          _looptop_poly_sotp_inv_2

movq        (%rdx),%mm2
pxor         %mm7,%mm2
movq        %mm2,(%rdi)

movq        %mm5,%rcx
xor         %rcx,%rax
movq        %rax,%rcx
shr         $32,%rcx
or          %rcx,%rax

add		$128,%rsi
add		$8,%rdx
add		$8,%rdi 

vpxor       %ymm8,%ymm8,%ymm8

vpbroadcastd (%rsi),%ymm1
vpbroadcastd (%rdx), %ymm2
vpbroadcastd 108(%rdx), %ymm3

vpand       %ymm0,%ymm3,%ymm6
vpaddw	    %ymm6,%ymm1,%ymm6
vpand       %ymm0,%ymm6,%ymm7

xor         %r8,%r8
add         $4,%r8
vmovdqa     %ymm5,%ymm4
.p2align 5
_looptop_poly_sotp_inv_3:
vpbroadcastd (%rsi, %r8),%ymm1
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm3,%ymm6
vpaddw	    %ymm6,%ymm1,%ymm6
vpor        %ymm8,%ymm6,%ymm8
vpsllvd		%ymm4,%ymm6,%ymm6
vpxor       %ymm6,%ymm7,%ymm7
vpaddw      %ymm5,%ymm4,%ymm4

add         $4,%r8
cmp         $64,%r8
jb          _looptop_poly_sotp_inv_3

vpxor       %ymm7,%ymm2,%ymm2
movq        %xmm2,%rcx
mov         %ecx,(%rdi)

movq        %xmm8,%rcx
mov         %ecx,%edx

xor         %rdx,%rax
movq        %rax,%rdx
shr         $16,%rdx
or          %rdx,%rax
movzx       %ax,%rax

shr         $1,%rax
neg         %rax
shr         $63,%rax

ret
