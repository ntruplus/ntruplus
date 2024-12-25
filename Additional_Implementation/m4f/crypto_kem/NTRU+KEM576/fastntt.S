#include "macros.i"
.syntax unified
.cpu cortex-m4
.thumb

.macro double_radix2_ntt_first_layer a0, a1, twiddle, tmp, tmp1, q, qa
	smulwb \tmp, \twiddle, \a1
	smulwt \tmp1, \twiddle, \a1
	smlabt \tmp, \tmp, \q, \qa
	smlabt \tmp1, \tmp1, \q, \qa
	pkhtb  \tmp, \tmp1, \tmp, asr#16
	uadd16 \a1, \a0, \a1
	usub16 \a1, \a1, \tmp
	uadd16 \a0, \a0, \tmp
.endm

.macro double_radix2_ntt a0, a1, twiddle, tmp, q, qa
	smulwb \tmp, \twiddle, \a1
	smulwt \a1, \twiddle, \a1
	smlabt \tmp, \tmp, \q, \qa
	smlabt \a1, \a1, \q, \qa
	pkhtb \tmp, \a1, \tmp, asr#16
	usub16 \a1, \a0, \tmp
	uadd16 \a0, \a0, \tmp
.endm

.macro double_radix3_ntt a0, a1, a2, twiddle1, twiddle2, tmp, tmp1, q, qa, omega
	mul_twiddle_plant \a1, \twiddle1, \tmp, \q, \qa
	mul_twiddle_plant \a2, \twiddle2, \tmp, \q, \qa

	mov \twiddle1, \a1
	mov \twiddle2, \a2

	usub16 \tmp, \twiddle1, \twiddle2

	mul_twiddle_plant \tmp, \omega, \tmp1, \q, \qa

	usub16 \a2, \a0, \twiddle1
	usub16 \a1, \a0, \twiddle2
	uadd16 \a0, \a0, \twiddle1
	usub16 \a2, \a2, \tmp
	uadd16 \a1, \a1, \tmp
	uadd16 \a0, \a0, \twiddle2
 .endm

.macro double_radix3_ntt_half poly, a0, xi0, xi1, mem0, mem1, mem2, twiddle1, twiddle2, tmp, tmp1, q, qa, omega
    vmov \twiddle1, \xi0
    vmov \twiddle2, \xi1

    usub16 \tmp, \twiddle1, \twiddle2
    mul_twiddle_plant \tmp, \omega, \tmp1, \q, \qa

    usub16 \tmp1, \a0, \twiddle1
    usub16 \tmp1, \tmp1, \tmp
    str.w  \tmp1, [\poly, \mem2]

    usub16 \tmp1, \a0, \twiddle2
    uadd16 \tmp1, \tmp1, \tmp
    str.w  \tmp1, [\poly, \mem1]

    uadd16 \tmp1, \a0, \twiddle1
    uadd16 \tmp1, \tmp1, \twiddle2
    str.w  \tmp1, [\poly, \mem0]
.endm

.macro double_radix6_ntt_first_layer c0, c1, c2, c3, c4, c5, xi0, xi1, xi2, xi3, xi4, twiddle1, twiddle2, q, qa, omega, tmp, tmp1
		// layer 0
		vmov \twiddle1, \xi0
		// twiddle2 here acts as a tmp register
		double_radix2_ntt_first_layer \c0, \c3, \twiddle1, \tmp, \twiddle2, \q, \qa
		double_radix2_ntt_first_layer \c1, \c4, \twiddle1, \tmp, \twiddle2, \q, \qa
		double_radix2_ntt_first_layer \c2, \c5, \twiddle1, \tmp, \twiddle2, \q, \qa

		// layer 1
		vmov \twiddle1, \xi1
		vmov \twiddle2, \xi2
		double_radix3_ntt \c0, \c1, \c2, \twiddle1, \twiddle2, \tmp, \tmp1, \q, \qa, \omega
		vmov \twiddle1, \xi3
		vmov \twiddle2, \xi4
		double_radix3_ntt \c3, \c4, \c5, \twiddle1, \twiddle2, \tmp, \tmp1, \q, \qa, \omega
.endm

.macro double_radix8_ntt c0, c1, c2, c3, c4, c5, c6, c7, xi0, xi1, xi2, xi3, xi4, xi5, xi6, twiddle1, twiddle2, q, qa, tmp
	// layer 0
	vmov \twiddle1, \xi0
	double_radix2_ntt \c0, \c4, \twiddle1, \tmp, \q, \qa
	double_radix2_ntt \c1, \c5, \twiddle1, \tmp, \q, \qa
	double_radix2_ntt \c2, \c6, \twiddle1, \tmp, \q, \qa
	double_radix2_ntt \c3, \c7, \twiddle1, \tmp, \q, \qa

	// layer 1
	vmov \twiddle1, \xi1
	vmov \twiddle2, \xi2
	double_radix2_ntt \c0, \c2, \twiddle1, \tmp, \q, \qa
	double_radix2_ntt \c1, \c3, \twiddle1, \tmp, \q, \qa
	double_radix2_ntt \c4, \c6, \twiddle2, \tmp, \q, \qa
	double_radix2_ntt \c5, \c7, \twiddle2, \tmp, \q, \qa

	// layer 2
	vmov \twiddle1, \xi3
	vmov \twiddle2, \xi4
	double_radix2_ntt \c0, \c1, \twiddle1, \tmp, \q, \qa
	double_radix2_ntt \c2, \c3, \twiddle2, \tmp, \q, \qa

	vmov \twiddle1, \xi5
	vmov \twiddle2, \xi6
	double_radix2_ntt \c4, \c5, \twiddle1, \tmp, \q, \qa
	double_radix2_ntt \c6, \c7, \twiddle2, \tmp, \q, \qa
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
	poly6        .req r8
	poly7        .req r9
	twiddle1     .req r10
	twiddle2     .req r11
	tmp1         .req r8
	tmp2         .req r9
	q            .req r12
	qa           .req r1
	omega        .req r9
	tmp          .req r14

	movt q, #3457

	# LAYER 0+1+2
	vldm twiddle_ptr!, {s12-s28}
	vmov s29, twiddle_ptr
	movw qa, #27656
	movw omega, #0xBE64
	movt omega, #0xCA75
	add.w tmp, poly, #64
	vmov s30, tmp

	1:
		// load a1, a4, a7, a10, a13, a16
		load3 poly, poly0, poly1, poly2, #64,  #256, #448
		load3 poly, poly3, poly4, poly5, #640, #832, #1024

		// 6-NTT on a1, a4, a7, a10, a13, a16
		double_radix6_ntt_first_layer poly0, poly1, poly2, poly3, poly4, poly5, s12, s13, s14, s15, s16, twiddle1, twiddle2, q, qa, omega, tmp, tmp1

		// 3-NTT on a(a0, a1, a2) & (a3, a4, a5)
		vmov twiddle1, s17
		vmov twiddle2, s19
		mul_twiddle_plant poly0, twiddle1, tmp, q, qa
		mul_twiddle_plant poly1, twiddle2, tmp, q, qa

		// 3-NTT on a(a6, a7, a8) & (a9, a10, a11)
		vmov twiddle1, s21
		vmov twiddle2, s23
		mul_twiddle_plant poly2, twiddle1, tmp, q, qa
		mul_twiddle_plant poly3, twiddle2, tmp, q, qa

		// 3-NTT on a(a12, a13, a14) & (a15, a16, a17)
		vmov twiddle1, s25
		vmov twiddle2, s27
		mul_twiddle_plant poly4, twiddle1, tmp, q, qa
		mul_twiddle_plant poly5, twiddle2, tmp, q, qa

		vmov s0, poly0 // a1
		vmov s1, poly1 // a4
		vmov s2, poly2 // a7
		vmov s3, poly3 // a10
		vmov s4, poly4 // a13
		vmov s5, poly5 // a16

		// load a2, a5, a8, a11, a14, a17
		load3 poly, poly0, poly1, poly2, #128, #320, #512
		load3 poly, poly3, poly4, poly5, #704, #896, #1088

		// 6-NTT on a2, a5, a8, a11, a14, a17
		double_radix6_ntt_first_layer poly0, poly1, poly2, poly3, poly4, poly5, s12, s13, s14, s15, s16, twiddle1, twiddle2, q, qa, omega, tmp, tmp1

		// 3-NTT on a(a0, a1, a2) & (a3, a4, a5)
		vmov twiddle1, s18
		vmov twiddle2, s20
		mul_twiddle_plant poly0, twiddle1, tmp, q, qa
		mul_twiddle_plant poly1, twiddle2, tmp, q, qa

		// 3-NTT on a(a6, a7, a8) & (a9, a10, a11)
		vmov twiddle1, s22
		vmov twiddle2, s24
		mul_twiddle_plant poly2, twiddle1, tmp, q, qa
		mul_twiddle_plant poly3, twiddle2, tmp, q, qa

		// 3-NTT on a(a12, a13, a14) & (a15, a16, a17)
		vmov twiddle1, s26
		vmov twiddle2, s28
		mul_twiddle_plant poly4, twiddle1, tmp, q, qa
		mul_twiddle_plant poly5, twiddle2, tmp, q, qa

		vmov s6, poly0 // a2
		vmov s7, poly1 // a5
		vmov s8, poly2 // a8
		vmov s9, poly3 // a11
		vmov s10, poly4 // a14
		vmov s11, poly5 // a17

		// load a0, a3, a6, a9, a12, a15
		load3 poly, poly0, poly1, poly2, #0,   #192, #384
		load3 poly, poly3, poly4, poly5, #576, #768, #960

		// 6-NTT on a1, a4, a7, a10, a13, a16
		double_radix6_ntt_first_layer poly0, poly1, poly2, poly3, poly4, poly5, s12, s13, s14, s15, s16, twiddle1, twiddle2, q, qa, omega, tmp, tmp1

		// 3-NTT
		double_radix3_ntt_half poly, poly0, s0, s6,  #0,   #64,  #128,  twiddle1, twiddle2, tmp, tmp1, q, qa, omega
		double_radix3_ntt_half poly, poly1, s1, s7,  #192, #256, #320,  twiddle1, twiddle2, tmp, tmp1, q, qa, omega
		double_radix3_ntt_half poly, poly2, s2, s8,  #384, #448, #512,  twiddle1, twiddle2, tmp, tmp1, q, qa, omega
		double_radix3_ntt_half poly, poly3, s3, s9,  #576, #640, #704,  twiddle1, twiddle2, tmp, tmp1, q, qa, omega
		double_radix3_ntt_half poly, poly4, s4, s10, #768, #832, #896,  twiddle1, twiddle2, tmp, tmp1, q, qa, omega
		double_radix3_ntt_half poly, poly5, s5, s11, #960, #1024,#1088, twiddle1, twiddle2, tmp, tmp1, q, qa, omega

		add poly, #4

		vmov tmp, s30
		cmp.w poly, tmp
	bne.w 1b

	sub.w poly, #64

	# LAYER 3+4+5
	add.w tmp, poly, #1152
	vmov s30, tmp

	2:
		vmov twiddle_ptr, s29
		vldm twiddle_ptr!, {s12-s18}
		vmov s29, twiddle_ptr
		movw qa, #27656

		add.w tmp, poly, #8
		vmov s31, tmp

		3:
			// load a0, a2, a4, a6, a8, a10, a12, a14
			load4 poly, poly0, poly1, poly2, poly3, #0,  #8,  #16, #24
			load4 poly, poly4, poly5, poly6, poly7, #32, #40, #48, #56

			double_radix8_ntt poly0, poly1, poly2, poly3, poly4, poly5, poly6, poly7, s12, s13, s14, s15, s16, s17, s18, twiddle1, twiddle2, q, qa, tmp

			movw twiddle1, #62750
			movt twiddle1, #18
			fullplant poly0, poly1, poly2, poly3, tmp, q, qa, twiddle1
			fullplant poly4, poly5, poly6, poly7, tmp, q, qa, twiddle1

			str.w poly7, [poly, #56]
			str.w poly6, [poly, #48]
			str.w poly5, [poly, #40]
			str.w poly4, [poly, #32]
			str.w poly3, [poly, #24]
			str.w poly2, [poly, #16]
			str.w poly1, [poly, #8]
			str.w poly0, [poly], #4

			vmov tmp, s31
			cmp.w poly, tmp
		bne.w 3b

		add poly, #56
		vmov tmp, s30
		cmp.w poly, tmp
	bne.w 2b

	vpop.w {s16-s25}
	pop {r4-r11, pc}
