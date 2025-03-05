#ifndef MACROS_I
#define MACROS_I

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

.macro doubleplant a, tmp, q, qa, plantconst
	smulwb \tmp, \plantconst, \a
	smulwt \a, \plantconst, \a
	smlabt \tmp, \tmp, \q, \qa
	smlabt \a, \a, \q, \qa
	pkhtb \a, \a, \tmp, asr#16
.endm

.macro fullplant a0, a1, a2, a3, tmp, q, qa, plantconst
	doubleplant \a0, \tmp, \q, \qa, \plantconst
	doubleplant \a1, \tmp, \q, \qa, \plantconst
	doubleplant \a2, \tmp, \q, \qa, \plantconst
	doubleplant \a3, \tmp, \q, \qa, \plantconst
.endm

.macro mul_twiddle_plant a, twiddle, tmp, q, qa
	smulwb \tmp, \twiddle, \a
	smulwt \a,   \twiddle, \a
	smlabt \tmp, \tmp, \q, \qa
	smlabt \a, \a, \q, \qa
	pkhtb \a, \a, \tmp, asr#16
.endm

//qinv = -q^(-1) % 2^16
.macro montgomery a, q, qinv, tmp
  smulbt \tmp, \a, \qinv
  smlabb \a, \q, \tmp, \a
.endm

#endif /* MACROS_I */
