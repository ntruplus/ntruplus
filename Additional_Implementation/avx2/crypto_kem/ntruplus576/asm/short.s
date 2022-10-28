.global poly_cbd1
poly_cbd1:

vmovdqa		_16x1(%rip),%ymm0
xor		    %rax,%rax
.p2align 5
_looptop_poly_cbd1_1:
vmovdqu  	(%rsi),%ymm2
vmovdqu  	72(%rsi),%ymm3

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
cmp		$1024,%rax
jb		_looptop_poly_cbd1_1

movq         (%rsi),%mm2
movq       72(%rsi),%mm3

movq    _4x1(%rip),%mm4
movq    _4x1(%rip),%mm5
pand        %mm2,%mm4
pand        %mm3,%mm5
psubw       %mm5,%mm4
movq        %mm4,(%rdi)

xor         %r8,%r8
add         $8,%r8
_looptop_poly_cbd1_2:
psrlw 		$1,%mm2
psrlw		$1,%mm3

movq    _4x1(%rip),%mm4
movq    _4x1(%rip),%mm5
pand        %mm2,%mm4
pand        %mm3,%mm5
psubw       %mm5,%mm4
movq        %mm4,(%rdi,%r8)
add         $8,%r8
cmp         $128,%r8
jb          _looptop_poly_cbd1_2

ret

.global poly_sotp
poly_sotp:

vmovdqa		_16x1(%rip),%ymm0
xor		    %rax,%rax
.p2align 5
_looptop_poly_sotp_1:
vmovdqu  	  (%rsi),%ymm1
vmovdqu   	  (%rdx),%ymm2
vmovdqu     72(%rdx),%ymm3

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
cmp		$1024,%rax
jb		_looptop_poly_sotp_1

movq         (%rsi),%mm1
movq         (%rdx),%mm2
movq       72(%rdx),%mm3

#msg xor g1
pxor        %mm1,%mm2

movq    _4x1(%rip),%mm4
movq    _4x1(%rip),%mm5
pand        %mm2,%mm4
pand        %mm3,%mm5
psubw       %mm5,%mm4
movq        %mm4,(%rdi)

xor         %r8,%r8
add         $8,%r8
_looptop_poly_sotp_2:
psrlw 		$1,%mm2
psrlw		$1,%mm3

movq    _4x1(%rip),%mm4
movq    _4x1(%rip),%mm5
pand        %mm2,%mm4
pand        %mm3,%mm5
psubw       %mm5,%mm4
movq        %mm4,(%rdi,%r8)
add         $8,%r8
cmp         $128,%r8
jb          _looptop_poly_sotp_2

ret

.global poly_sotp_inv
poly_sotp_inv:
vmovdqa		_16x1(%rip),%ymm0
vmovdqa		_8x1(%rip),%ymm4
vmovdqa		_8x1(%rip),%ymm5

xor		    %rax,%rax
.p2align 5
_looptop_poly_sotp_inv_1:
vmovdqu       (%rsi),%ymm1
vmovdqu       (%rdx),%ymm2
vmovdqu     72(%rdx),%ymm3

vpand       %ymm0,%ymm3,%ymm6
vpaddw	    %ymm6,%ymm1,%ymm6
vpand       %ymm0,%ymm6,%ymm7

xor         %r8,%r8
add         $32,%r8
.p2align 5
_looptop_poly_sotp_inv_1_1:
vmovdqu     (%rsi, %r8),%ymm1
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm3,%ymm6
vpaddw	    %ymm6,%ymm1,%ymm6
vpand       %ymm0,%ymm6,%ymm6
vpsllvd		%ymm4,%ymm6,%ymm6
vpxor       %ymm6,%ymm7,%ymm7
vpaddw      %ymm5,%ymm4,%ymm4

add         $32,%r8
cmp         $512,%r8
jb          _looptop_poly_sotp_inv_1_1

vpxor       %ymm7,%ymm2,%ymm2
vmovdqu     %ymm2,(%rdi)

add		$32,%rsi
add		$32,%rdx
add		$512,%rdi
add		$512,%rax
cmp		$1024,%rax
jb		_looptop_poly_sotp_inv_1

movq        _4x1(%rip),%mm4

movq        (%rsi),%mm1
movq        (%rdx),%mm2
movq        72(%rdx),%mm3

movq        _4x1(%rip),%mm6
pand         %mm3,%mm6
paddw	    %mm1,%mm6
movq        _4x1(%rip),%mm7
pand	    %mm6,%mm7

xor         %r8,%r8
add         $8,%r8
.p2align 5
_looptop_poly_sotp_inv_2:
movq        (%rsi,%r8),%mm1
psrlw 		$1,%mm3
movq        _4x1(%rip),%mm6
pand        %mm3,%mm6
paddw	    %mm1,%mm6
movq        _4x1(%rip),%mm6
pand        %mm3,%mm6

psllw       %mm4,%mm6
pxor        %mm6,%mm7
paddw       %mm5,%mm4

add         $8,%r8
cmp         $128,%r8
jb          _looptop_poly_sotp_inv_2

pxor         %mm7,%mm2
movq        %mm2,(%rdi)

ret
