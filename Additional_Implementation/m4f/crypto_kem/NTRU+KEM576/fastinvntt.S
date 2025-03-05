#include "macros.i"
.syntax unified
.cpu cortex-m4
.thumb

.macro double_radix2_invntt a0, a1, twiddle, tmp, q, qa
	usub16 \tmp, \a0, \a1
	uadd16 \a0, \a0, \a1

	smulwb \a1, \twiddle, \tmp
	smulwt \tmp, \twiddle, \tmp
	smlabt \a1, \a1, \q, \qa
	smlabt \tmp, \tmp, \q, \qa
	pkhtb \a1, \tmp, \a1, asr#16
.endm

.macro double_radix2_invntt_last_layer a0, a1, twiddle1, twiddle2, twiddle3, tmp, q, qa
	usub16 \tmp, \a0, \a1 //t2
	uadd16 \a0, \a0, \a1 //t1

	smulwb \a1, \twiddle1, \tmp
	smulwt \tmp, \twiddle1, \tmp
	smlabt \a1, \a1, \q, \qa
	smlabt \tmp, \tmp, \q, \qa
	pkhtb \a1, \tmp, \a1, asr#16

	usub16 \a0, \a0, \a1
	mul_twiddle_plant \a0, \twiddle2, \tmp, \q, \qa
	mul_twiddle_plant \a1, \twiddle3, \tmp, \q, \qa
.endm

.macro double_radix3_invntt a0, a1, a2, twiddle1, twiddle2, tmp, tmp1, q, qa, omega
	usub16 \tmp, \a1, \a2

	mul_twiddle_plant \tmp, \omega, \tmp1, \q, \qa

	uadd16 \tmp1, \a1, \a2
	usub16 \a1, \a0, \a1
	usub16 \a2, \a0, \a2
	usub16 \a1, \a1, \tmp
	uadd16 \a2, \a2, \tmp
	uadd16 \a0, \a0, \tmp1

	mul_twiddle_plant \a1, \twiddle1, \tmp, \q, \qa
	mul_twiddle_plant \a2, \twiddle2, \tmp, \q, \qa
 .endm

.macro double_radix8_invntt c0, c1, c2, c3, c4, c5, c6, c7, xi0, xi1, xi2, xi3, xi4, xi5, xi6, twiddle1, twiddle2, q, qa, tmp
	// layer 2
	vmov \twiddle1, \xi0
	vmov \twiddle2, \xi1
	double_radix2_invntt \c0, \c1, \twiddle1, \tmp, \q, \qa
	double_radix2_invntt \c2, \c3, \twiddle2, \tmp, \q, \qa

	vmov \twiddle1, \xi2
	vmov \twiddle2, \xi3
	double_radix2_invntt \c4, \c5, \twiddle1, \tmp, \q, \qa
	double_radix2_invntt \c6, \c7, \twiddle2, \tmp, \q, \qa

	// layer 1
	vmov \twiddle1, \xi4
	vmov \twiddle2, \xi5
	double_radix2_invntt \c0, \c2, \twiddle1, \tmp, \q, \qa
	double_radix2_invntt \c1, \c3, \twiddle1, \tmp, \q, \qa
	double_radix2_invntt \c4, \c6, \twiddle2, \tmp, \q, \qa
	double_radix2_invntt \c5, \c7, \twiddle2, \tmp, \q, \qa

	// layer 2
	vmov \twiddle1, \xi6
	double_radix2_invntt \c0, \c4, \twiddle1, \tmp, \q, \qa
	double_radix2_invntt \c1, \c5, \twiddle1, \tmp, \q, \qa
	double_radix2_invntt \c2, \c6, \twiddle1, \tmp, \q, \qa
	double_radix2_invntt \c3, \c7, \twiddle1, \tmp, \q, \qa
.endm

.global invntt_fast
.type invntt_fast, %function
.align 2
invntt_fast:
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
	vmov s29, twiddle_ptr
	add.w tmp, poly, #1152
	vmov s30, tmp

	1:
		vmov twiddle_ptr, s29
		vldm twiddle_ptr!, {s12-s18}
		vmov s29, twiddle_ptr
		movw qa, #27656

		add.w tmp, poly, #8
		vmov s31, tmp

		2:
			// load a0, a1, a2, a3, a4, a5, a6, a7
			load4 poly, poly0, poly1, poly2, poly3, #0,  #8,  #16, #24
			load4 poly, poly4, poly5, poly6, poly7, #32, #40, #48, #56

			double_radix8_invntt poly0, poly1, poly2, poly3, poly4, poly5, poly6, poly7, s12, s13, s14, s15, s16, s17, s18, twiddle1, twiddle2, q, qa, tmp

			movw twiddle1, #62750
			movt twiddle1, #18
			fullplant poly0, poly1, poly2, poly3, tmp, q, qa, twiddle1

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
		bne.w 2b

		add poly, #56
		vmov tmp, s30
		cmp.w poly, tmp
	bne.w 1b

	sub poly, #1152

	# LAYER 0+1+2
	add.w tmp, poly, #1152
	vmov s30, tmp
	3:
		vmov twiddle_ptr, s29
		vldm twiddle_ptr!, {s12-s19}
		vmov s29, twiddle_ptr
		movw qa, #27656
		movw omega, #0xBE64
		movt omega, #0xCA75

		add.w tmp, poly, #64
		vmov s31, tmp
		4:
			//a3, a4, a5
			//a6, a7, a8
			load3 poly, poly0, poly1, poly2, #192, #256, #320
			load3 poly, poly3, poly4, poly5, #384, #448, #512

			vmov twiddle1, s14
			vmov twiddle2, s15
			double_radix3_invntt poly0, poly1, poly2, twiddle1, twiddle2, tmp, tmp1, q, qa, omega

			vmov twiddle1, s16
			vmov twiddle2, s17
			double_radix3_invntt poly3, poly4, poly5, twiddle1, twiddle2, tmp, tmp1, q, qa, omega

			vmov s0, poly0
			vmov s1, poly1
			vmov s2, poly2
			vmov s3, poly3
			vmov s4, poly4
			vmov s5, poly5

			//a0, a1, a2
			load3 poly, poly0, poly1, poly2, #0,   #64,  #128

			vmov twiddle1, s12
			vmov twiddle2, s13
			double_radix3_invntt poly0, poly1, poly2, twiddle1, twiddle2, tmp, tmp1, q, qa, omega

			vmov twiddle1, s18
			vmov twiddle2, s19

			vmov poly3,s0
			vmov poly4,s3
			double_radix3_invntt poly0, poly3, poly4, twiddle1, twiddle2, tmp, tmp1, q, qa, omega

			str.w poly4, [poly, #384]
			str.w poly3, [poly, #192]

			vmov poly3,s1
			vmov poly4,s4
			double_radix3_invntt poly1, poly3, poly4, twiddle1, twiddle2, tmp, tmp1, q, qa, omega

			str.w poly4, [poly, #448]
			str.w poly3, [poly, #256]

			vmov poly3,s2
			vmov poly4,s5
			double_radix3_invntt poly2, poly3, poly4, twiddle1, twiddle2, tmp, tmp1, q, qa, omega

			str.w poly4, [poly, #512]
			str.w poly3, [poly, #320]

			movw twiddle1, #62750
			movt twiddle1, #18
			fullplant poly0, poly1, poly2, poly3, tmp, q, qa, twiddle1

			str.w poly2, [poly, #128]
			str.w poly1, [poly, #64]
			str.w poly0, [poly], #4

			vmov tmp, s31
			cmp.w poly, tmp
		bne.w 4b

		add poly, #512

		vmov tmp, s30
		cmp.w poly, tmp
	bne.w 3b

	sub poly, #1152

	# LAYER 0
	movw qa, #27656
	movw twiddle1, #33972
	movt twiddle1, #30976
	movw twiddle2, #64285
	movt twiddle2, #1345
	movw tmp1, #63034
	movt tmp1, #2691

	add.w tmp, poly, #192
	vmov s30, tmp
	5:
		load3 poly, poly0, poly1, poly2, #0,   #192, #384
		load3 poly, poly3, poly4, poly5, #576, #768, #960

		double_radix2_invntt_last_layer poly0, poly3, twiddle1, twiddle2, tmp1, tmp, q, qa
		double_radix2_invntt_last_layer poly1, poly4, twiddle1, twiddle2, tmp1, tmp, q, qa
		double_radix2_invntt_last_layer poly2, poly5, twiddle1, twiddle2, tmp1, tmp, q, qa

		str.w poly5, [poly, #960]
		str.w poly4, [poly, #768]
		str.w poly3, [poly, #576]
		str.w poly2, [poly, #384]
		str.w poly1, [poly, #192]
		str.w poly0, [poly], #4

		vmov tmp, s30
		cmp.w poly, tmp
	bne.w 5b

	vpop.w {s16-s25}
	pop {r4-r11, pc}
