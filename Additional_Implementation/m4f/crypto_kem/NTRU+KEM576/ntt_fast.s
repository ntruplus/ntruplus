.syntax unified
.cpu cortex-m4
.thumb

.macro mul_twiddle_plant a, twiddle, tmp, q, qa
	smulwb \tmp, \twiddle, \a
	smulwt \a,   \twiddle, \a
	smlabt \tmp, \tmp, \q, \qa
	smlabt \a, \a, \q, \qa
	pkhtb \a, \a, \tmp, asr#16
.endm

.macro load3 a, a0, a1, a2, mem0, mem1, mem2
	ldr.w \a0, [\a, \mem0]
	ldr.w \a1, [\a, \mem1]
	ldr.w \a2, [\a, \mem2]
.endm

.macro load4 a, a0, a1, a2, a3, mem0, mem1, mem2, mem3
	ldr.w \a0, [\a, \mem0]
	ldr.w \a1, [\a, \mem1]
	ldr.w \a2, [\a, \mem2]
	ldr.w \a3, [\a, \mem3]
.endm

.macro double_radix2_plant_first_layer a0, a1, twiddle, tmp, tmp1, q, qa
	smulwb \tmp, \twiddle, \a1
	smulwt \tmp1, \twiddle, \a1
	smlabt \tmp, \tmp, \q, \qa
	smlabt \tmp1, \tmp1, \q, \qa
	pkhtb  \tmp, \tmp1, \tmp, asr#16
	uadd16 \a1, \a0, \a1
	usub16 \a1, \a1, \tmp
	uadd16 \a0, \a0, \tmp
.endm

.macro double_radix2_plant a0, a1, twiddle, tmp, q, qa
	smulwb \tmp, \twiddle, \a1
	smulwt \a1, \twiddle, \a1
	smlabt \tmp, \tmp, \q, \qa
	smlabt \a1, \a1, \q, \qa
	pkhtb \tmp, \a1, \tmp, asr#16
	usub16 \a1, \a0, \tmp
	uadd16 \a0, \a0, \tmp
.endm

.macro double_radix3_plant a0, a1, a2, twiddle1, twiddle2, tmp, tmp1, q, qa, omega
	mul_twiddle_plant \a1, \twiddle1, \tmp, \q, \qa
	mul_twiddle_plant \a2, \twiddle2, \tmp, \q, \qa

	mov \twiddle1, \a1
	mov \twiddle2, \a2

	usub16 \tmp, \twiddle1, \twiddle2

	mul_twiddle_plant \tmp, \omega, \tmp1, \q, \qa

	usub16 \a2, \a0, \twiddle1
	usub16 \a2, \a2, \tmp
	usub16 \a1, \a0, \twiddle2
	uadd16 \a1, \a1, \tmp
	uadd16 \a0, \a0, \twiddle1
	uadd16 \a0, \a0, \twiddle2
.endm

.macro _2_layer_radix2_radix3_16_plant_fp_first_layer c0, c1, c2, c3, c4, c5, xi0, xi1, xi2, xi3, xi4, twiddle1, twiddle2, q, qa, omega, tmp, tmp1
		// layer 0
		vmov \twiddle1, \xi0
		// twiddle2 here acts as a tmp register
		double_radix2_plant_first_layer \c0, \c3, \twiddle1, \tmp, \twiddle2, \q, \qa
		double_radix2_plant_first_layer \c1, \c4, \twiddle1, \tmp, \twiddle2, \q, \qa
		double_radix2_plant_first_layer \c2, \c5, \twiddle1, \tmp, \twiddle2, \q, \qa

		// layer 1
		vmov \twiddle1, \xi1
		vmov \twiddle2, \xi2
		double_radix3_plant \c0, \c1, \c2, \twiddle1, \twiddle2, \tmp, \tmp1, \q, \qa, \omega
		vmov \twiddle1, \xi3
		vmov \twiddle2, \xi4
		double_radix3_plant \c3, \c4, \c5, \twiddle1, \twiddle2, \tmp, \tmp1, \q, \qa, \omega
.endm

.macro _2_layer_radix3_radix2_16_plant_fp c0, c1, c2, c3, c4, c5, xi0, xi1, xi2, xi3, xi4, twiddle1, twiddle2, q, qa, omega, tmp, tmp1
		// layer 2
		vmov \twiddle1, \xi0
		vmov \twiddle2, \xi1
		double_radix3_plant \c0, \c2, \c4, \twiddle1, \twiddle2, \tmp, \tmp1, \q, \qa, \omega

		vmov \twiddle1, \xi0
		vmov \twiddle2, \xi1
		double_radix3_plant \c1, \c3, \c5, \twiddle1, \twiddle2, \tmp, \tmp1, \q, \qa, \omega

		// layer 3
		vmov \twiddle1, \xi2
		double_radix2_plant \c0, \c1, \twiddle1, \tmp, \q, \qa
		vmov \twiddle1, \xi3
		double_radix2_plant \c2, \c3, \twiddle1, \tmp, \q, \qa
		vmov \twiddle1, \xi4
		double_radix2_plant \c4, \c5, \twiddle1, \tmp, \q, \qa
.endm

.global ntt_fast
.type ntt_fast, %function
.align 2
ntt_fast:
	push {r4-r11, r14}
	vpush.w {s16-s25}
	poly         .req r0
	twiddle_ptr  .req r1
	poly0        .req r2
	poly1        .req r3
	poly2        .req r4
	poly3        .req r5
	poly4        .req r6
	poly5        .req r7
	twiddle1     .req r8
	twiddle2     .req r9
	tmp1        .req r10
	tmp2        .req r11
	plantconst   .req r10
	q            .req r12
	qa           .req r1
	omega        .req r11
	tmp          .req r14

	movt q, #3457

	# LAYER 0+1
	.equ distance, 576
	.equ offset, 128
	.equ strincr, 4
	// pre-load 17 twiddle factors to 17 FPU registers
	// s0-s11 used to temporary store 12 16-bit polys.
	vldm twiddle_ptr!, {s12-s16}
	vmov s23, twiddle_ptr
	movw qa, #27656
	movw omega, #0xBE64
	movt omega, #0xCA75
	add.w tmp, poly, #distance/3
	// s23: twiddle addr
	// s24: tmp
	vmov s24, tmp

	1:
		// load a2, a5, a8, a11, a14, a17
		load3 poly, poly0, poly1, poly2, #0, #distance/3, #2*distance/3
		load3 poly, poly3, poly4, poly5, #distance, #4*distance/3, #5*distance/3

		// 6-NTT on a1, a4, a7, a10, a13, a16
		_2_layer_radix2_radix3_16_plant_fp_first_layer poly0, poly1, poly2, poly3, poly4, poly5, s12, s13, s14, s15, s16, twiddle1, twiddle2, q, qa, omega, tmp, tmp1

		str.w poly1, [poly, #1*distance/3]
		str.w poly2, [poly, #2*distance/3]
		str.w poly3, [poly, #3*distance/3]
		str.w poly4, [poly, #4*distance/3]
		str.w poly5, [poly, #5*distance/3]
		str.w poly0, [poly], #4

//		add poly, poly, #4

		vmov tmp, s24
		cmp.w poly, tmp
	bne.w 1b

	sub.w poly, #distance/3

	# LAYER 2+3+4
	.equ distance, 96
	.equ offset, 16
	.equ strincr, 4

	add.w tmp, poly, #1152
	vmov s24, tmp

	2:
		vmov twiddle_ptr, s23
		vldm twiddle_ptr!, {s12-s22}
		vmov s23, twiddle_ptr

		add.w tmp, poly, #16
		vmov s25, tmp

		3:
			movw qa, #27656
			movw omega, #0xBE64
			movt omega, #0xCA75

			// load a1, a3, a5, a7, a9, a11
			load3 poly, poly0, poly1, poly2, #offset, #distance/3+offset, #2*distance/3+offset
			load3 poly, poly3, poly4, poly5, #distance+offset, #4*distance/3+offset, #5*distance/3+offset

			_2_layer_radix3_radix2_16_plant_fp poly0, poly1, poly2, poly3, poly4, poly5, s12, s13, s14, s15, s16, twiddle1, twiddle2, q, qa, omega, tmp, tmp1


			// s17-s22 left
			// multiply coeffs by layer 8 twiddles for later use
			vmov twiddle1, s17
			vmov twiddle2, s18
			mul_twiddle_plant poly0, twiddle1, tmp, q, qa
			mul_twiddle_plant poly1, twiddle2, tmp, q, qa

			vmov twiddle1, s19
			vmov twiddle2, s20
			mul_twiddle_plant poly2, twiddle1, tmp, q, qa
			mul_twiddle_plant poly3, twiddle2, tmp, q, qa

			vmov twiddle1, s21
			vmov twiddle2, s22
			mul_twiddle_plant poly4, twiddle1, tmp, q, qa
			mul_twiddle_plant poly5, twiddle2, tmp, q, qa

			vmov s0, poly0 // a1
			vmov s1, poly1 // a3
			vmov s2, poly2 // a5
			vmov s3, poly3 // a7
			vmov s4, poly4 // a9
			vmov s5, poly5 // a11

			// load a0, a2, a4, a6, a8, a10
			load3 poly, poly0, poly1, poly2, #0, #distance/3, #2*distance/3
			load3 poly, poly3, poly4, poly5, #distance, #4*distance/3, #5*distance/3

			_2_layer_radix3_radix2_16_plant_fp poly0, poly1, poly2, poly3, poly4, poly5, s12, s13, s14, s15, s16, twiddle1, twiddle2, q, qa, omega, tmp, tmp1

			// layer 3 - 1
			// addsub: (a2, a6, a10), (a3, a7, a11)
			vmov twiddle1, s1 // load a3
			uadd16 tmp, poly1, twiddle1
			usub16 poly1, poly1, twiddle1
			str.w tmp, [poly, #1*distance/3]
			str.w poly1, [poly, #1*distance/3+offset]

			vmov twiddle1, s3 // load a7
			uadd16 tmp, poly3, twiddle1
			usub16 poly3, poly3, twiddle1
			str.w tmp, [poly, #3*distance/3]
			str.w poly3, [poly, #3*distance/3+offset]

			vmov twiddle1, s5 // load a11
			uadd16 tmp, poly5, twiddle1
			usub16 poly5, poly5, twiddle1
			str.w tmp, [poly, #5*distance/3]
			str.w poly5, [poly, #5*distance/3+offset]

			// layer 3 - 2
			// addsub: (a0, a4, a8), (a1, a5, a9)
			vmov poly3, s2 // load a5
			uadd16 tmp, poly2, poly3
			usub16 twiddle1, poly2, poly3
			str.w tmp, [poly, #2*distance/3]
			str.w twiddle1, [poly, #2*distance/3+offset]

			vmov poly5, s4 // load a9
			uadd16 tmp, poly4, poly5
			usub16 twiddle1, poly4, poly5
			str.w tmp, [poly, #4*distance/3]
			str.w twiddle1, [poly, #4*distance/3+offset]

			vmov poly1, s0 // load a1
			uadd16 tmp, poly0, poly1
			usub16 twiddle1, poly0, poly1
			str.w twiddle1, [poly, #offset]
			str.w tmp, [poly], #4

			vmov tmp, s25
			cmp.w poly, tmp

		bne.w 3b

		add poly, #176
		vmov tmp, s24
		cmp.w poly, tmp
	bne.w 2b

	sub poly, #1152


	# LAYER 5
	add.w tmp, poly, #1152
	vmov s24, tmp

	4:
		vmov twiddle_ptr, s23
		vldm twiddle_ptr!, {s12}
		vmov s23, twiddle_ptr

		movw qa, #27656

		load4 poly, poly0, poly1, poly2, poly3, #0,  #4, #8, #12
		load4 poly, poly4, poly5, tmp1, tmp2, #16, #20, #24, #28

		vmov twiddle1, s12

		double_radix2_plant poly0, poly2, twiddle1, tmp, q, qa
		double_radix2_plant poly1, poly3, twiddle1, tmp, q, qa


		str.w poly0, [poly, #0]
		str.w poly1, [poly, #4]
		str.w poly2, [poly, #8]
		str.w poly3, [poly, #12]

		add poly, #16

		vmov tmp, s24
		cmp.w poly, tmp
	bne.w 4b

	sub poly, #1152

	vpop.w {s16-s25}
	pop {r4-r11, pc}
