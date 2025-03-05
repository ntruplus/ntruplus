#include "macros.i"
.syntax unified
.cpu cortex-m4
.thumb

.global poly_baseinv_asm
.type poly_baseinv_asm, %function
.align 2
poly_baseinv_asm:
	push {r4-r11, r14}

	rptr      .req r0
	aptr      .req r1
	zptr      .req r2
	poly0     .req r3
	poly1     .req r4
	q         .req r5
	qinv      .req r5
	zeta      .req r6
	tmp0      .req r7
	tmp1      .req r8
	tmp2      .req r9
	tmp3      .req r10
	tmp4      .req r11
	tmp5      .req r12
	tmp6      .req r2
	loop      .req r14

	movw q,    #3457
	movt qinv, #52607

	vmov s0, zptr

    movw loop, #36
	1:
		vmov zptr, s0
		ldr zeta, [zptr], #4
		vmov s0, zptr

//round1
		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4

		//t0 = montgomery_reduce(a[2]*a[2] - (a[1]*a[3] << 1));
		smultt tmp0, poly0, poly1        //a[1]*a[3]
		neg tmp0, tmp0
		lsl tmp0, tmp0, #1
		smlabb tmp0, poly1, poly1, tmp0  //a[2]*a[2]
		montgomery tmp0, q, qinv, tmp5

		//t0 = montgomery_reduce(a[0]*a[0] + t0*zeta);
		smultb tmp0, tmp0, zeta          //t0*zeta
		smlabb tmp0, poly0, poly0, tmp0  //a[0]*a[0]
		montgomery tmp0, q, qinv, tmp5

		//t1 = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly1        //a[3]*a[3]
		montgomery tmp1, q, qinv, tmp5

		//t1 = montgomery_reduce(((a[0]*a[2]) << 1) - a[1]*a[1] - t1*zeta);
		smultb tmp1, tmp1, zeta          //t0*zeta
		smlatt tmp1, poly0, poly0, tmp1  //a[1]*a[1]
		neg tmp1, tmp1

		smulbb tmp2, poly0, poly1        //a[0]*a[2]
		lsl tmp2, tmp2, #1
		add tmp1, tmp1, tmp2
		montgomery tmp1, q, qinv, tmp5

		//t2 = montgomery_reduce(t1*t1);
		smultt tmp2, tmp1, tmp1
		montgomery tmp2, q, qinv, tmp5

		//t2 = montgomery_reduce(t0*t0 - t2*zeta);
		smultb tmp2, tmp2, zeta
		neg tmp2, tmp2
		smlatt tmp2, tmp0, tmp0, tmp2
		montgomery tmp2, q, qinv, tmp5

		lsrs tmp2, tmp2, #16
		beq reject

		//inverse 구해야함
		//t3 = fqmul(a, a);    //10
		smulbb tmp3, tmp2, tmp2
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t3, t3);  //100
		smultt tmp4, tmp3, tmp3
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t5 = fqmul(t4, t4);  //10000
		smultt tmp5, tmp4, tmp4
		montgomery tmp5, q, qinv, tmp6

		//t3 = fqmul(t3, t4);  //1010
		smultt tmp3, tmp3, tmp4
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t3, t5);  //11010
		smultt tmp4, tmp3, tmp5
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110100
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, a);   //110101
		smultb tmp4, tmp4, tmp2
		montgomery tmp4, q, qinv, tmp6

		//t3 = fqmul(t3, t4);  //111111
		smultt tmp3, tmp3, tmp4
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1101010
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //11010100
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110101000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1101010000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //11010100000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110101000000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t2 = fqmul(t4, t3);  //110101111111
		smultt tmp2, tmp3, tmp4
		montgomery tmp2, q, qinv, tmp6
		//end of inversion

		//t0 = fqmul(t0,t2);
		smultt tmp0, tmp0, tmp2
		montgomery tmp0, q, qinv, tmp6

		//t1 = fqmul(t1,t2);
		smultt tmp1, tmp1, tmp2
		montgomery tmp1, q, qinv, tmp6

		//t2 = fqmul(t1,zeta);
		smultb tmp2, tmp1, zeta
		montgomery tmp2, q, qinv, tmp6

		//r[0] = montgomery_reduce(a[0]*t0 - a[2]*t2);
		smulbt tmp3, poly1, tmp2        //a[2]*t2
		neg tmp3, tmp3
		smlabt tmp3, poly0, tmp0, tmp3  //a[2]*a[2]
		montgomery tmp3, q, qinv, tmp6

		//r[1] = montgomery_reduce(a[3]*t2 - a[1]*t0);
		smultt tmp4, poly0, tmp0        //a[1]*t0
		neg tmp4, tmp4
		smlatt tmp4, poly1, tmp2, tmp4  //a[3]*t2
		montgomery tmp4, q, qinv, tmp6

		//r[2] = montgomery_reduce(a[2]*t0 - a[0]*t1);
		smulbt tmp5, poly0, tmp1        //a[0]*t1
		neg tmp5, tmp5
		smlabt tmp5, poly1, tmp0, tmp5  //a[2]*t0
		montgomery tmp5, q, qinv, tmp6

		//r[3] = montgomery_reduce(a[1]*t1 - a[3]*t0);
		smultt tmp6, poly1, tmp0        //a[3]*t0
		neg tmp6, tmp6
		smlatt tmp6, poly0, tmp1, tmp6  //a[1]*t1
		montgomery tmp6, q, qinv, tmp0

		pkhtb tmp3, tmp4, tmp3, asr#16
		str tmp3, [rptr], #4
		pkhtb tmp5, tmp6, tmp5, asr#16
		str tmp5, [rptr], #4

//round2
		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4

		//t0 = montgomery_reduce(a[2]*a[2] - (a[1]*a[3] << 1));
		smultt tmp0, poly0, poly1        //a[1]*a[3]
		neg tmp0, tmp0
		lsl tmp0, tmp0, #1
		smlabb tmp0, poly1, poly1, tmp0  //a[2]*a[2]
		montgomery tmp0, q, qinv, tmp5

		//t0 = montgomery_reduce(a[0]*a[0] + t0*zeta);
		smultb tmp0, tmp0, zeta          //t0*zeta
		neg tmp0, tmp0
		smlabb tmp0, poly0, poly0, tmp0  //a[0]*a[0]
		montgomery tmp0, q, qinv, tmp5

		//t1 = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly1        //a[3]*a[3]
		montgomery tmp1, q, qinv, tmp5

		//t1 = montgomery_reduce(((a[0]*a[2]) << 1) - a[1]*a[1] - t1*zeta);
	    smulbb tmp2, poly0, poly1         // a[0] * a[2]
		smultt tmp3, poly0, poly0         // a[1] * a[1]
	    lsl tmp2, tmp2, #1                // ((a[0]*a[2]) << 1)
	    smlatb tmp1, tmp1, zeta, tmp2     // ((a[0]*a[2]) << 1) - t1*zeta
	    sub tmp1, tmp1, tmp3              // ((a[0]*a[2]) << 1) - a[1]*a[1] - t1*zeta
		montgomery tmp1, q, qinv, tmp5

		//t2 = montgomery_reduce(t1*t1);
		smultt tmp2, tmp1, tmp1
		montgomery tmp2, q, qinv, tmp5

		//t2 = montgomery_reduce(t0*t0 - t2*zeta);
		smultb tmp2, tmp2, zeta
		smlatt tmp2, tmp0, tmp0, tmp2
		montgomery tmp2, q, qinv, tmp5

		lsrs tmp2, tmp2, #16
		beq reject

		//inverse 구해야함
		//t3 = fqmul(a, a);    //10
		smulbb tmp3, tmp2, tmp2
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t3, t3);  //100
		smultt tmp4, tmp3, tmp3
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t5 = fqmul(t4, t4);  //10000
		smultt tmp5, tmp4, tmp4
		montgomery tmp5, q, qinv, tmp6

		//t3 = fqmul(t3, t4);  //1010
		smultt tmp3, tmp3, tmp4
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t3, t5);  //11010
		smultt tmp4, tmp3, tmp5
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110100
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, a);   //110101
		smultb tmp4, tmp4, tmp2
		montgomery tmp4, q, qinv, tmp6

		//t3 = fqmul(t3, t4);  //111111
		smultt tmp3, tmp3, tmp4
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1101010
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //11010100
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110101000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1101010000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //11010100000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110101000000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t2 = fqmul(t4, t3);  //110101111111
		smultt tmp2, tmp3, tmp4
		montgomery tmp2, q, qinv, tmp6
		//end of inversion

		//t0 = fqmul(t0,t2);
		smultt tmp0, tmp0, tmp2
		montgomery tmp0, q, qinv, tmp6

		//t1 = fqmul(t1,t2);
		smultt tmp1, tmp1, tmp2
		montgomery tmp1, q, qinv, tmp6

		//t2 = fqmul(t1,zeta);
		smultb tmp2, tmp1, zeta
		montgomery tmp2, q, qinv, tmp6

		//r[0] = montgomery_reduce(a[0]*t0 - a[2]*t2);
		smulbt tmp3, poly1, tmp2        //a[2]*t2
		smlabt tmp3, poly0, tmp0, tmp3  //a[2]*a[2]
		montgomery tmp3, q, qinv, tmp6

		//r[1] = montgomery_reduce(a[3]*t2 - a[1]*t0);
		smultt tmp4, poly0, tmp0        //a[1]*t0
		smlatt tmp4, poly1, tmp2, tmp4  //a[3]*t2
		neg tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//r[2] = montgomery_reduce(a[2]*t0 - a[0]*t1);
		smulbt tmp5, poly0, tmp1        //a[0]*t1
		neg tmp5, tmp5
		smlabt tmp5, poly1, tmp0, tmp5  //a[2]*t0
		montgomery tmp5, q, qinv, tmp6

		//r[3] = montgomery_reduce(a[1]*t1 - a[3]*t0);
		smultt tmp6, poly1, tmp0        //a[3]*t0
		neg tmp6, tmp6
		smlatt tmp6, poly0, tmp1, tmp6  //a[1]*t1
		montgomery tmp6, q, qinv, tmp0

		pkhtb tmp3, tmp4, tmp3, asr#16
		str tmp3, [rptr], #4
		pkhtb tmp5, tmp6, tmp5, asr#16
		str tmp5, [rptr], #4

//round3
		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4

		//t0 = montgomery_reduce(a[2]*a[2] - (a[1]*a[3] << 1));
		smultt tmp0, poly0, poly1        //a[1]*a[3]
		neg tmp0, tmp0
		lsl tmp0, tmp0, #1
		smlabb tmp0, poly1, poly1, tmp0  //a[2]*a[2]
		montgomery tmp0, q, qinv, tmp5

		//t0 = montgomery_reduce(a[0]*a[0] + t0*zeta);
		smultt tmp0, tmp0, zeta          //t0*zeta
		smlabb tmp0, poly0, poly0, tmp0  //a[0]*a[0]
		montgomery tmp0, q, qinv, tmp5

		//t1 = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly1        //a[3]*a[3]
		montgomery tmp1, q, qinv, tmp5

		//t1 = montgomery_reduce(((a[0]*a[2]) << 1) - a[1]*a[1] - t1*zeta);
		smultt tmp1, tmp1, zeta          //t0*zeta
		smlatt tmp1, poly0, poly0, tmp1  //a[1]*a[1]
		neg tmp1, tmp1

		smulbb tmp2, poly0, poly1        //a[0]*a[2]
		lsl tmp2, tmp2, #1
		add tmp1, tmp1, tmp2
		montgomery tmp1, q, qinv, tmp5

		//t2 = montgomery_reduce(t1*t1);
		smultt tmp2, tmp1, tmp1
		montgomery tmp2, q, qinv, tmp5

		//t2 = montgomery_reduce(t0*t0 - t2*zeta);
		smultt tmp2, tmp2, zeta
		neg tmp2, tmp2
		smlatt tmp2, tmp0, tmp0, tmp2
		montgomery tmp2, q, qinv, tmp5

		lsrs tmp2, tmp2, #16
		beq reject


		//inverse 구해야함
		//t3 = fqmul(a, a);    //10
		smulbb tmp3, tmp2, tmp2
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t3, t3);  //100
		smultt tmp4, tmp3, tmp3
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t5 = fqmul(t4, t4);  //10000
		smultt tmp5, tmp4, tmp4
		montgomery tmp5, q, qinv, tmp6

		//t3 = fqmul(t3, t4);  //1010
		smultt tmp3, tmp3, tmp4
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t3, t5);  //11010
		smultt tmp4, tmp3, tmp5
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110100
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, a);   //110101
		smultb tmp4, tmp4, tmp2
		montgomery tmp4, q, qinv, tmp6

		//t3 = fqmul(t3, t4);  //111111
		smultt tmp3, tmp3, tmp4
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1101010
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //11010100
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110101000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1101010000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //11010100000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110101000000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t2 = fqmul(t4, t3);  //110101111111
		smultt tmp2, tmp3, tmp4
		montgomery tmp2, q, qinv, tmp6
		//end of inversion

		//t0 = fqmul(t0,t2);
		smultt tmp0, tmp0, tmp2
		montgomery tmp0, q, qinv, tmp6

		//t1 = fqmul(t1,t2);
		smultt tmp1, tmp1, tmp2
		montgomery tmp1, q, qinv, tmp6

		//t2 = fqmul(t1,zeta);
		smultt tmp2, tmp1, zeta
		montgomery tmp2, q, qinv, tmp6

		//r[0] = montgomery_reduce(a[0]*t0 - a[2]*t2);
		smulbt tmp3, poly1, tmp2        //a[2]*t2
		neg tmp3, tmp3
		smlabt tmp3, poly0, tmp0, tmp3  //a[2]*a[2]
		montgomery tmp3, q, qinv, tmp6

		//r[1] = montgomery_reduce(a[3]*t2 - a[1]*t0);
		smultt tmp4, poly0, tmp0        //a[1]*t0
		neg tmp4, tmp4
		smlatt tmp4, poly1, tmp2, tmp4  //a[3]*t2
		montgomery tmp4, q, qinv, tmp6

		//r[2] = montgomery_reduce(a[2]*t0 - a[0]*t1);
		smulbt tmp5, poly0, tmp1        //a[0]*t1
		neg tmp5, tmp5
		smlabt tmp5, poly1, tmp0, tmp5  //a[2]*t0
		montgomery tmp5, q, qinv, tmp6

		//r[3] = montgomery_reduce(a[1]*t1 - a[3]*t0);
		smultt tmp6, poly1, tmp0        //a[3]*t0
		neg tmp6, tmp6
		smlatt tmp6, poly0, tmp1, tmp6  //a[1]*t1
		montgomery tmp6, q, qinv, tmp0

		pkhtb tmp3, tmp4, tmp3, asr#16
		str tmp3, [rptr], #4
		pkhtb tmp5, tmp6, tmp5, asr#16
		str tmp5, [rptr], #4

//round4
		ldr poly0, [aptr], #4
		ldr poly1, [aptr], #4

		//t0 = montgomery_reduce(a[2]*a[2] - (a[1]*a[3] << 1));
		smultt tmp0, poly0, poly1        //a[1]*a[3]
		neg tmp0, tmp0
		lsl tmp0, tmp0, #1
		smlabb tmp0, poly1, poly1, tmp0  //a[2]*a[2]
		montgomery tmp0, q, qinv, tmp5

		//t0 = montgomery_reduce(a[0]*a[0] + t0*zeta);
		smultt tmp0, tmp0, zeta          //t0*zeta
		neg tmp0, tmp0
		smlabb tmp0, poly0, poly0, tmp0  //a[0]*a[0]
		montgomery tmp0, q, qinv, tmp5

		//t1 = montgomery_reduce(a[3]*a[3]);
		smultt tmp1, poly1, poly1        //a[3]*a[3]
		montgomery tmp1, q, qinv, tmp5

		//t1 = montgomery_reduce(((a[0]*a[2]) << 1) - a[1]*a[1] - t1*zeta);
	    smulbb tmp2, poly0, poly1         // a[0] * a[2]
		smultt tmp3, poly0, poly0         // a[1] * a[1]
	    lsl tmp2, tmp2, #1                // ((a[0]*a[2]) << 1)
	    smlatt tmp1, tmp1, zeta, tmp2     // ((a[0]*a[2]) << 1) - t1*zeta
	    sub tmp1, tmp1, tmp3              // ((a[0]*a[2]) << 1) - a[1]*a[1] - t1*zeta
		montgomery tmp1, q, qinv, tmp5

		//t2 = montgomery_reduce(t1*t1);
		smultt tmp2, tmp1, tmp1
		montgomery tmp2, q, qinv, tmp5

		//t2 = montgomery_reduce(t0*t0 - t2*zeta);
		smultt tmp2, tmp2, zeta
		smlatt tmp2, tmp0, tmp0, tmp2
		montgomery tmp2, q, qinv, tmp5

		lsrs tmp2, tmp2, #16
		beq reject

		//inverse 구해야함
		//t3 = fqmul(a, a);    //10
		smulbb tmp3, tmp2, tmp2
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t3, t3);  //100
		smultt tmp4, tmp3, tmp3
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t5 = fqmul(t4, t4);  //10000
		smultt tmp5, tmp4, tmp4
		montgomery tmp5, q, qinv, tmp6

		//t3 = fqmul(t3, t4);  //1010
		smultt tmp3, tmp3, tmp4
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t3, t5);  //11010
		smultt tmp4, tmp3, tmp5
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110100
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, a);   //110101
		smultb tmp4, tmp4, tmp2
		montgomery tmp4, q, qinv, tmp6

		//t3 = fqmul(t3, t4);  //111111
		smultt tmp3, tmp3, tmp4
		montgomery tmp3, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1101010
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //11010100
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110101000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //1101010000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //11010100000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t4 = fqmul(t4, t4);  //110101000000
		smultt tmp4, tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//t2 = fqmul(t4, t3);  //110101111111
		smultt tmp2, tmp3, tmp4
		montgomery tmp2, q, qinv, tmp6
		//end of inversion

		//t0 = fqmul(t0,t2);
		smultt tmp0, tmp0, tmp2
		montgomery tmp0, q, qinv, tmp6

		//t1 = fqmul(t1,t2);
		smultt tmp1, tmp1, tmp2
		montgomery tmp1, q, qinv, tmp6

		//t2 = fqmul(t1,zeta);
		smultt tmp2, tmp1, zeta
		montgomery tmp2, q, qinv, tmp6

		//r[0] = montgomery_reduce(a[0]*t0 - a[2]*t2);
		smulbt tmp3, poly1, tmp2        //a[2]*t2
		smlabt tmp3, poly0, tmp0, tmp3  //a[2]*a[2]
		montgomery tmp3, q, qinv, tmp6

		//r[1] = montgomery_reduce(a[3]*t2 - a[1]*t0);
		smultt tmp4, poly0, tmp0        //a[1]*t0
		smlatt tmp4, poly1, tmp2, tmp4  //a[3]*t2
		neg tmp4, tmp4
		montgomery tmp4, q, qinv, tmp6

		//r[2] = montgomery_reduce(a[2]*t0 - a[0]*t1);
		smulbt tmp5, poly0, tmp1        //a[0]*t1
		neg tmp5, tmp5
		smlabt tmp5, poly1, tmp0, tmp5  //a[2]*t0
		montgomery tmp5, q, qinv, tmp6

		//r[3] = montgomery_reduce(a[1]*t1 - a[3]*t0);
		smultt tmp6, poly1, tmp0        //a[3]*t0
		neg tmp6, tmp6
		smlatt tmp6, poly0, tmp1, tmp6  //a[1]*t1
		montgomery tmp6, q, qinv, tmp0

		pkhtb tmp3, tmp4, tmp3, asr#16
		str tmp3, [rptr], #4
		pkhtb tmp5, tmp6, tmp5, asr#16
		str tmp5, [rptr], #4

		subs.w loop, #1
	bne.w 1b

	mov r0, #0
	pop {r4-r11, pc}

reject:

	mov r0, #1
	pop {r4-r11, pc}
