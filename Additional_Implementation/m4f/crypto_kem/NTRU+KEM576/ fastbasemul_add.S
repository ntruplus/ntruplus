#include "macros.i"
.syntax unified
.cpu cortex-m4
.thumb

.global poly_basemul_add_asm
.type poly_basemul_add_asm, %function
.align 2
poly_basemul_add_asm:
	push {r4-r11, r14}

	rptr      .req r0
	aptr      .req r1
	bptr      .req r2
	zptr      .req r3
	poly0     .req r4
	poly1     .req r5
	poly2     .req r6
	poly3     .req r7
	poly4     .req r8
	q         .req r9
	qinv      .req r9
	zeta      .req r10
	tmp1      .req r11
	tmp2      .req r12
	tmp3      .req r14
	tmp4      .req r3

	movw q,    #3457
	movt qinv, #52607


	vmov s0, zptr

	add.w tmp1, aptr, #1152
	vmov s1, tmp1

	1:
		vmov zptr, s0
		ldr zeta, [zptr], #4
		vmov s0, zptr

		movw tmp4, #0xFF6D

		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4
		ldr poly2, [bptr], #4
		ldr poly3, [bptr], #4

		ldr poly4, [rptr]

		//r[0] = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]);
		smultt tmp1, poly0, poly3       //a[1]*b[3]
		smlabb tmp1, poly1, poly3, tmp1 //a[2]*b[2]
		smlatt tmp1, poly1, poly2, tmp1 //a[3]*b[1]
		montgomery tmp1, q, qinv, tmp3

		//r[0] = montgomery_reduce(r[0]*zeta + a[0]*b[0]);
		smultb tmp1, tmp1, zeta         //r[0]*zeta
		smlabb tmp1, poly0, poly2, tmp1 //a[0]*b[0]
		smlabb tmp1, poly4, tmp4, tmp1 //c[0]*(-147)
		montgomery tmp1, q, qinv, tmp3

		//r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
		smuadx tmp2, poly1, poly3	    // a[2]*b[3] + a[3]*b[2]
		montgomery tmp2, q, qinv, tmp3

		//r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
		smultb tmp2, tmp2, zeta           //r[1]*zeta
		smladx tmp2, poly0, poly2, tmp2   //a[0]*b[1] + a[1]*b[0]
		smlatb tmp2, poly4, tmp4, tmp2 //c[1]*(-147)
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		ldr poly4, [rptr]

		//r[2] = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly3       //a[3]*b[3]
		montgomery tmp1, q, qinv, tmp3

		//r[2] = montgomery_reduce(r[2]*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]);
		smultb tmp1, tmp1, zeta         //r[2]*zeta
		smlabb tmp1, poly0, poly3, tmp1 //a[0]*b[2]
		smlatt tmp1, poly0, poly2, tmp1 //a[1]*b[1]
		smlabb tmp1, poly1, poly2, tmp1 //a[2]*b[0]
		smlabb tmp1, poly4, tmp4, tmp1 //c[2]*(-147)
		montgomery tmp1, q, qinv, tmp3

		//r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
		smuadx tmp2, poly0, poly3	    //a[0]*b[3]+a[1]*b[2]
		smladx tmp2, poly1, poly2, tmp2 //a[2]*b[1]+a[3]*b[0]
		smlatb tmp2, poly4, tmp4, tmp2 //c[3]*(-147)
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4


		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4
		ldr poly2, [bptr], #4
		ldr poly3, [bptr], #4

		ldr poly4, [rptr]

		//r[0] = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]);
		smultt tmp1, poly0, poly3       //a[1]*b[3]
		smlabb tmp1, poly1, poly3, tmp1 //a[2]*b[2]
		smlatt tmp1, poly1, poly2, tmp1 //a[3]*b[1]
		montgomery tmp1, q, qinv, tmp3

		//r[0] = montgomery_reduce(r[0]*zeta + a[0]*b[0]);
		smultb tmp1, tmp1, zeta         //r[0]*zeta
		neg tmp1, tmp1
		smlabb tmp1, poly0, poly2, tmp1 //a[0]*b[0]
		smlabb tmp1, poly4, tmp4, tmp1 //c[0]*(-147)
		montgomery tmp1, q, qinv, tmp3

		//r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
		smuadx tmp2, poly1, poly3	    // a[2]*b[3] + a[3]*b[2]
		montgomery tmp2, q, qinv, tmp3

		//r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
		smultb tmp2, tmp2, zeta           //r[1]*zeta
		neg tmp2, tmp2
		smladx tmp2, poly0, poly2, tmp2   //a[0]*b[1] + a[1]*b[0]
		smlatb tmp2, poly4, tmp4, tmp2 //c[1]*(-147)
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		ldr poly4, [rptr]

		//r[2] = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly3       //a[3]*b[3]
		montgomery tmp1, q, qinv, tmp3

		//r[2] = montgomery_reduce(r[2]*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]);
		smultb tmp1, tmp1, zeta         //r[2]*zeta
		neg tmp1, tmp1
		smlabb tmp1, poly0, poly3, tmp1 //a[0]*b[2]
		smlatt tmp1, poly0, poly2, tmp1 //a[1]*b[1]
		smlabb tmp1, poly1, poly2, tmp1 //a[2]*b[0]
		smlabb tmp1, poly4, tmp4, tmp1 //c[2]*(-147)
		montgomery tmp1, q, qinv, tmp3

		//r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
		smuadx tmp2, poly0, poly3	    //a[0]*b[3]+a[1]*b[2]
		smladx tmp2, poly1, poly2, tmp2 //a[2]*b[1]+a[3]*b[0]
		smlatb tmp2, poly4, tmp4, tmp2 //c[3]*(-147)
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4
		ldr poly2, [bptr], #4
		ldr poly3, [bptr], #4

		ldr poly4, [rptr]

		//r[0] = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]);
		smultt tmp1, poly0, poly3       //a[1]*b[3]
		smlabb tmp1, poly1, poly3, tmp1 //a[2]*b[2]
		smlatt tmp1, poly1, poly2, tmp1 //a[3]*b[1]
		montgomery tmp1, q, qinv, tmp3

		//r[0] = montgomery_reduce(r[0]*zeta + a[0]*b[0]);
		smultt tmp1, tmp1, zeta         //r[0]*zeta
		smlabb tmp1, poly0, poly2, tmp1 //a[0]*b[0]
		smlabb tmp1, poly4, tmp4, tmp1 //c[0]*(-147)
		montgomery tmp1, q, qinv, tmp3

		//r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
		smuadx tmp2, poly1, poly3	    // a[2]*b[3] + a[3]*b[2]
		montgomery tmp2, q, qinv, tmp3

		//r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
		smultt tmp2, tmp2, zeta           //r[1]*zeta
		smladx tmp2, poly0, poly2, tmp2   //a[0]*b[1] + a[1]*b[0]
		smlatb tmp2, poly4, tmp4, tmp2 //c[1]*(-147)
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		ldr poly4, [rptr]

		//r[2] = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly3       //a[3]*b[3]
		montgomery tmp1, q, qinv, tmp3

		//r[2] = montgomery_reduce(r[2]*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]);
		smultt tmp1, tmp1, zeta         //r[2]*zeta
		smlabb tmp1, poly0, poly3, tmp1 //a[0]*b[2]
		smlatt tmp1, poly0, poly2, tmp1 //a[1]*b[1]
		smlabb tmp1, poly1, poly2, tmp1 //a[2]*b[0]
		smlabb tmp1, poly4, tmp4, tmp1 //c[2]*(-147)
		montgomery tmp1, q, qinv, tmp3

		//r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
		smuadx tmp2, poly0, poly3	    //a[0]*b[3]+a[1]*b[2]
		smladx tmp2, poly1, poly2, tmp2 //a[2]*b[1]+a[3]*b[0]
		smlatb tmp2, poly4, tmp4, tmp2 //c[3]*(-147)
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4
		ldr poly2, [bptr], #4
		ldr poly3, [bptr], #4

		ldr poly4, [rptr]

		//r[0] = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]);
		smultt tmp1, poly0, poly3       //a[1]*b[3]
		smlabb tmp1, poly1, poly3, tmp1 //a[2]*b[2]
		smlatt tmp1, poly1, poly2, tmp1 //a[3]*b[1]
		montgomery tmp1, q, qinv, tmp3

		//r[0] = montgomery_reduce(r[0]*zeta + a[0]*b[0]);
		smultt tmp1, tmp1, zeta         //r[0]*zeta
		neg tmp1, tmp1
		smlabb tmp1, poly0, poly2, tmp1 //a[0]*b[0]
		smlabb tmp1, poly4, tmp4, tmp1 //c[0]*(-147)
		montgomery tmp1, q, qinv, tmp3

		//r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
		smuadx tmp2, poly1, poly3	    // a[2]*b[3] + a[3]*b[2]
		montgomery tmp2, q, qinv, tmp3

		//r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
		smultt tmp2, tmp2, zeta           //r[1]*zeta
		neg tmp2, tmp2
		smladx tmp2, poly0, poly2, tmp2   //a[0]*b[1] + a[1]*b[0]
		smlatb tmp2, poly4, tmp4, tmp2 //c[1]*(-147)
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		ldr poly4, [rptr]

		//r[2] = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly3       //a[3]*b[3]
		montgomery tmp1, q, qinv, tmp3

		//r[2] = montgomery_reduce(r[2]*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]);
		smultt tmp1, tmp1, zeta         //r[2]*zeta
		neg tmp1, tmp1
		smlabb tmp1, poly0, poly3, tmp1 //a[0]*b[2]
		smlatt tmp1, poly0, poly2, tmp1 //a[1]*b[1]
		smlabb tmp1, poly1, poly2, tmp1 //a[2]*b[0]
		smlabb tmp1, poly4, tmp4, tmp1 //c[2]*(-147)
		montgomery tmp1, q, qinv, tmp3

		//r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
		smuadx tmp2, poly0, poly3	    //a[0]*b[3]+a[1]*b[2]
		smladx tmp2, poly1, poly2, tmp2 //a[2]*b[1]+a[3]*b[0]
		smlatb tmp2, poly4, tmp4, tmp2 //c[3]*(-147)
		montgomery tmp2, q, qinv, tmp3

		pkhtb tmp1, tmp2, tmp1, asr#16
		str tmp1, [rptr], #4

		vmov tmp1, s1
		cmp.w aptr, tmp1

	bne.w 1b

	pop {r4-r11, pc}
