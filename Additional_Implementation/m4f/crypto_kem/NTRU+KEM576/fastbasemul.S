#include "macros.i"
.syntax unified
.cpu cortex-m4
.thumb

.global poly_basemul_asm
.type poly_basemul_asm, %function
.align 2
poly_basemul_asm:
	push {r4-r11, r14}

	rptr      .req r0
	aptr      .req r1
	bptr      .req r2
	zptr      .req r3
	poly0     .req r4
	poly1     .req r6
	poly2     .req r5
	poly3     .req r7
	q         .req r8
	qinv      .req r8
	zeta      .req r9
	tmp1      .req r10
	tmp2      .req r11
	tmp3      .req r12
	loop      .req r14

	movw q,    #3457
	movt qinv, #52607

    movw loop, #36
	1:
		ldr zeta, [zptr], #4

		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4
		ldr poly2, [bptr], #4
		ldr poly3, [bptr], #4

		//r[0] = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]);
		smultt tmp1, poly0, poly3       //a[1]*b[3]
		smlabb tmp1, poly1, poly3, tmp1 //a[2]*b[2]
		smlatt tmp1, poly1, poly2, tmp1 //a[3]*b[1]
		montgomery tmp1, q, qinv, tmp3

		//r[0] = montgomery_reduce(r[0]*zeta + a[0]*b[0]);
		smultb tmp1, tmp1, zeta         //r[0]*zeta
		smlabb tmp1, poly0, poly2, tmp1 //a[0]*b[0]
		montgomery tmp1, q, qinv, tmp3

		//r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
		smuadx tmp2, poly1, poly3	    // a[2]*b[3] + a[3]*b[2]
		montgomery tmp2, q, qinv, tmp3

		//r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
		smultb tmp2, tmp2, zeta           //r[1]*zeta
		smladx tmp2, poly0, poly2, tmp2   //a[0]*b[1] + a[1]*b[0]
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		//r[2] = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly3       //a[3]*b[3]
		montgomery tmp1, q, qinv, tmp3

		//r[2] = montgomery_reduce(r[2]*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]);
		smultb tmp1, tmp1, zeta         //r[2]*zeta
		smlabb tmp1, poly0, poly3, tmp1 //a[0]*b[2]
		smlatt tmp1, poly0, poly2, tmp1 //a[1]*b[1]
		smlabb tmp1, poly1, poly2, tmp1 //a[2]*b[0]
		montgomery tmp1, q, qinv, tmp3

		//r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
		smuadx tmp2, poly0, poly3	    //a[0]*b[3]+a[1]*b[2]
		smladx tmp2, poly1, poly2, tmp2 //a[2]*b[1]+a[3]*b[0]
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4
		ldr poly2, [bptr], #4
		ldr poly3, [bptr], #4

		//r[0] = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]);
		smultt tmp1, poly0, poly3       //a[1]*b[3]
		smlabb tmp1, poly1, poly3, tmp1 //a[2]*b[2]
		smlatt tmp1, poly1, poly2, tmp1 //a[3]*b[1]
		montgomery tmp1, q, qinv, tmp3

		//r[0] = montgomery_reduce(r[0]*zeta + a[0]*b[0]);
		smultb tmp1, tmp1, zeta         //r[0]*zeta
		neg tmp1, tmp1
		smlabb tmp1, poly0, poly2, tmp1 //a[0]*b[0]
		montgomery tmp1, q, qinv, tmp3

		//r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
		smuadx tmp2, poly1, poly3	    // a[2]*b[3] + a[3]*b[2]
		montgomery tmp2, q, qinv, tmp3

		//r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
		smultb tmp2, tmp2, zeta           //r[1]*zeta
		neg tmp2, tmp2
		smladx tmp2, poly0, poly2, tmp2   //a[0]*b[1] + a[1]*b[0]
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		//r[2] = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly3       //a[3]*b[3]
		montgomery tmp1, q, qinv, tmp3

		//r[2] = montgomery_reduce(r[2]*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]);
		smultb tmp1, tmp1, zeta         //r[2]*zeta
		neg tmp1, tmp1
		smlabb tmp1, poly0, poly3, tmp1 //a[0]*b[2]
		smlatt tmp1, poly0, poly2, tmp1 //a[1]*b[1]
		smlabb tmp1, poly1, poly2, tmp1 //a[2]*b[0]
		montgomery tmp1, q, qinv, tmp3

		//r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
		smuadx tmp2, poly0, poly3	    //a[0]*b[3]+a[1]*b[2]
		smladx tmp2, poly1, poly2, tmp2 //a[2]*b[1]+a[3]*b[0]
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4
		ldr poly2, [bptr], #4
		ldr poly3, [bptr], #4

		//r[0] = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]);
		smultt tmp1, poly0, poly3       //a[1]*b[3]
		smlabb tmp1, poly1, poly3, tmp1 //a[2]*b[2]
		smlatt tmp1, poly1, poly2, tmp1 //a[3]*b[1]
		montgomery tmp1, q, qinv, tmp3

		//r[0] = montgomery_reduce(r[0]*zeta + a[0]*b[0]);
		smultt tmp1, tmp1, zeta         //r[0]*zeta
		smlabb tmp1, poly0, poly2, tmp1 //a[0]*b[0]
		montgomery tmp1, q, qinv, tmp3

		//r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
		smuadx tmp2, poly1, poly3	    // a[2]*b[3] + a[3]*b[2]
		montgomery tmp2, q, qinv, tmp3

		//r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
		smultt tmp2, tmp2, zeta           //r[1]*zeta
		smladx tmp2, poly0, poly2, tmp2   //a[0]*b[1] + a[1]*b[0]
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		//r[2] = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly3       //a[3]*b[3]
		montgomery tmp1, q, qinv, tmp3

		//r[2] = montgomery_reduce(r[2]*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]);
		smultt tmp1, tmp1, zeta         //r[2]*zeta
		smlabb tmp1, poly0, poly3, tmp1 //a[0]*b[2]
		smlatt tmp1, poly0, poly2, tmp1 //a[1]*b[1]
		smlabb tmp1, poly1, poly2, tmp1 //a[2]*b[0]
		montgomery tmp1, q, qinv, tmp3

		//r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
		smuadx tmp2, poly0, poly3	    //a[0]*b[3]+a[1]*b[2]
		smladx tmp2, poly1, poly2, tmp2 //a[2]*b[1]+a[3]*b[0]
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4
		ldr poly2, [bptr], #4
		ldr poly3, [bptr], #4

		//r[0] = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]);
		smultt tmp1, poly0, poly3       //a[1]*b[3]
		smlabb tmp1, poly1, poly3, tmp1 //a[2]*b[2]
		smlatt tmp1, poly1, poly2, tmp1 //a[3]*b[1]
		montgomery tmp1, q, qinv, tmp3

		//r[0] = montgomery_reduce(r[0]*zeta + a[0]*b[0]);
		smultt tmp1, tmp1, zeta         //r[0]*zeta
		neg tmp1, tmp1
		smlabb tmp1, poly0, poly2, tmp1 //a[0]*b[0]
		montgomery tmp1, q, qinv, tmp3

		//r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
		smuadx tmp2, poly1, poly3	    // a[2]*b[3] + a[3]*b[2]
		montgomery tmp2, q, qinv, tmp3

		//r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
		smultt tmp2, tmp2, zeta           //r[1]*zeta
		neg tmp2, tmp2
		smladx tmp2, poly0, poly2, tmp2   //a[0]*b[1] + a[1]*b[0]
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		//r[2] = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly3       //a[3]*b[3]
		montgomery tmp1, q, qinv, tmp3

		//r[2] = montgomery_reduce(r[2]*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]);
		smultt tmp1, tmp1, zeta         //r[2]*zeta
		neg tmp1, tmp1
		smlabb tmp1, poly0, poly3, tmp1 //a[0]*b[2]
		smlatt tmp1, poly0, poly2, tmp1 //a[1]*b[1]
		smlabb tmp1, poly1, poly2, tmp1 //a[2]*b[0]
		montgomery tmp1, q, qinv, tmp3

		//r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
		smuadx tmp2, poly0, poly3	    //a[0]*b[3]+a[1]*b[2]
		smladx tmp2, poly1, poly2, tmp2 //a[2]*b[1]+a[3]*b[0]
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		subs.w loop, #1
	bne.w 1b

	pop {r4-r11, pc}
