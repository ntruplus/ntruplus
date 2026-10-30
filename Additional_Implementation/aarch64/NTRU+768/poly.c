#include "util.h"
#include "poly.h"
#include <arm_neon.h>

/*
 * References:
 *
 * [BHK+21] Hanno Becker, Vincent Hwang, Matthias J. Kannwischer,
 * Bo-Yin Yang, and Shang-Yi Yang,
 * "Neon NTT: Faster Dilithium, Kyber, and Saber
 * on Cortex-A72 and Apple M1", IACR Transactions on Cryptographic
 * Hardware and Embedded Systems, 2022(1), pp. 221-244.
 * https://doi.org/10.46586/tches.v2022.i1.221-244
 *
 * [KCP26] Jonghyun Kim, Haehyun Cho, and Jong Hwan Park,
 * "Accelerating NTRU+ Key Generation via Hierarchical Batch Inversion",
 * Cryptology ePrint Archive, Paper 2026/1191, 2026.
 * https://eprint.iacr.org/2026/1191
 */

static const int16_t consts[] __attribute__((aligned(16))) = {
	  3457,  19412, -12929,   -147,  -1393,  -1571, -14891,  12929
};

/*************************************************
* Name:        fqmul
*
* Description: Computes SIMD Montgomery products with R = 2^16.
*
* Reference:   Algorithm 12 of [BHK+21].
*
* Arguments:   - int16x8_t x: input lanes in [-q+1,q-1]
*              - int16x8_t y: input lanes in [-q+1,q-1]
*              - int16x8_t con: constants with con[0] = q and
*                              con[7] = q^-1 mod R
*
* Returns:     lane-wise representatives of x*y*R^-1 modulo q
*              in [-1910,1910]
**************************************************/
static inline int16x8_t fqmul(int16x8_t x, int16x8_t y, int16x8_t con)
{
	const int16x8_t h = vqdmulhq_s16(x, y);
	int16x8_t t = vmulq_s16(x, y);

	t = vmulq_laneq_s16(t, con, 7);
	t = vqdmulhq_laneq_s16(t, con, 0);

	return vhsubq_s16(h, t);
}

/*************************************************
* Name:        fqmul_precomp
*
* Description: Computes SIMD Montgomery products with R = 2^16
*              using a precomputed factor.
*
* Reference:   Algorithm 12 of [BHK+21].
*
* Arguments:   - int16x8_t x: input lanes in [-q+1,q-1]
*              - int16x8_t y: input lanes in [-q+1,q-1]
*              - int16x8_t Y: y*q^-1 mod R
*              - int16x8_t con: constants with con[0] = q
*
* Returns:     lane-wise representatives of x*y*R^-1 modulo q
*              in [-1910,1910]
**************************************************/
static inline int16x8_t fqmul_precomp(int16x8_t x, int16x8_t y, int16x8_t Y, int16x8_t con)
{
	const int16x8_t h = vqdmulhq_s16(x, y);
	int16x8_t t = vmulq_s16(x, Y);

	t = vqdmulhq_laneq_s16(t, con, 0);

	return vhsubq_s16(h, t);
}

/*************************************************
* Name:        fqinv
*
* Description: Computes SIMD multiplicative inverses in Z_q.
*              The exponent q-2 = 3455 is evaluated using a shortest
*              addition chain of length 15 (OEIS A003313).
*
* Arguments:   - int16x8_t a:   input lanes with |a| < q
*              - int16x8_t con: vector of arithmetic constants
*
* Returns:     lane-wise multiplicative inverses of a
**************************************************/
static inline int16x8_t fqinv(int16x8_t a, int16x8_t con)
{
	const int16x8_t R3QINV = vdupq_n_s16(-16436);
	const int16x8_t R3     = vdupq_n_s16(460);

	int16x8_t t0, t1, T;

	a = fqmul_precomp(a, R3, R3QINV, con);

	t0 = fqmul(a, a, con);   // 10
	t0 = fqmul(t0, t0, con); // 100
	t0 = fqmul(t0, t0, con); // 1000
	t0 = fqmul(t0, t0, con); // 10000

	T = vmulq_laneq_s16(t0, con, 7);
	t1 = fqmul_precomp(a, t0, T, con);  // 10001
	t0 = fqmul_precomp(t0, t0, T, con); // 100000

	t0 = fqmul(t0, t0, con); // 1000000
	t0 = fqmul(t0, t0, con); // 10000000

	T = vmulq_laneq_s16(t0, con, 7);
	t1 = fqmul_precomp(t1, t0, T, con); // 10010001
	t0 = fqmul_precomp(t1, t0, T, con); // 100010001

	T = vmulq_laneq_s16(t0, con, 7);
	t1 = fqmul_precomp(t1, t0, T, con); // 110100010
	t1 = fqmul_precomp(t1, t0, T, con); // 1010110011

	T = vmulq_laneq_s16(t1, con, 7);
	t0 = fqmul_precomp(t1, t1, T, con); // 10101100110
	t0 = fqmul(t0, t0, con);            // 101011001100
	t0 = fqmul_precomp(t0, t1, T, con); // 110101111111

	return t0;
}

/*************************************************
* Name:        fqinv_batch
*
* Description: Inverts a batch of SIMD field elements using one vector fqinv.
*              Three independent product and recovery chains are combined
*              hierarchically to expose ILP while retaining Montgomery's trick.
*
* Reference:   [KCP26].
*
* Arguments:   - int16x8_t *r: input/output array of SIMD field elements
*              - int16x8_t con: vector of arithmetic constants
*
* Returns:     1 if an input is zero; otherwise 0
**************************************************/
static inline int fqinv_batch(int16x8_t *r, int16x8_t con)
{
	const int chunk = NTRUPLUS_N / (3 * 8 * NTRUPLUS_D);

	const int off0 = 0 * chunk;
	const int off1 = 1 * chunk;
	const int off2 = 2 * chunk;

	const int pc_off0 = 0 * (chunk - 1);
	const int pc_off1 = 1 * (chunk - 1);
	const int pc_off2 = 2 * (chunk - 1);

	int16x8_t pc0[NTRUPLUS_N / (8 * NTRUPLUS_D) - 3];
	int16x8_t x0 = r[off0];
	int16x8_t x1 = r[off1];
	int16x8_t x2 = r[off2];

	pc0[pc_off0] = x0;
	pc0[pc_off1] = x1;
	pc0[pc_off2] = x2;

	for (int i = 1; i < chunk - 1; i++)
	{
		const int16x8_t R0 = vmulq_laneq_s16(r[off0 + i], con, 7);
		const int16x8_t R1 = vmulq_laneq_s16(r[off1 + i], con, 7);
		const int16x8_t R2 = vmulq_laneq_s16(r[off2 + i], con, 7);

		x0 = fqmul_precomp(x0, r[off0 + i], R0, con);
		x1 = fqmul_precomp(x1, r[off1 + i], R1, con);
		x2 = fqmul_precomp(x2, r[off2 + i], R2, con);

		pc0[pc_off0 + i] = x0;
		pc0[pc_off1 + i] = x1;
		pc0[pc_off2 + i] = x2;
	}

	const int16x8_t R0 = vmulq_laneq_s16(r[off0 + chunk - 1], con, 7);
	const int16x8_t R1 = vmulq_laneq_s16(r[off1 + chunk - 1], con, 7);
	const int16x8_t R2 = vmulq_laneq_s16(r[off2 + chunk - 1], con, 7);

	x0 = fqmul_precomp(x0, r[off0 + chunk - 1], R0, con);
	x1 = fqmul_precomp(x1, r[off1 + chunk - 1], R1, con);
	x2 = fqmul_precomp(x2, r[off2 + chunk - 1], R2, con);

	const int fail0 = !vminvq_u16(vreinterpretq_u16_s16(x0));
	const int fail1 = !vminvq_u16(vreinterpretq_u16_s16(x1));
	const int fail2 = !vminvq_u16(vreinterpretq_u16_s16(x2));

	int fail = fail0 | fail1 | fail2;
	/* Preserve the single aggregate failure decision. */
	__asm__ __volatile__("" : "+r"(fail));
	ntruplus_declassify(&fail, sizeof fail);

	if (fail)
	{
		u8_clear(pc0, sizeof pc0);
		return 1;
	}

	/* Product tree: (0, 1), then 2. */
	const int16x8_t x01 = fqmul(x0, x1, con);
	const int16x8_t inv = fqinv(fqmul(x01, x2, con), con);
	const int16x8_t INV = vmulq_laneq_s16(inv, con, 7);
	const int16x8_t inv01 = fqmul_precomp(x2, inv, INV, con);
	const int16x8_t INV01 = vmulq_laneq_s16(inv01, con, 7);

	int16x8_t inv0 = fqmul_precomp(x1, inv01, INV01, con);
	int16x8_t inv1 = fqmul_precomp(x0, inv01, INV01, con);
	int16x8_t inv2 = fqmul_precomp(x01, inv, INV, con);

	for (int i = chunk - 1; i > 0; i--)
	{
		const int16x8_t r0 = r[off0 + i];
		const int16x8_t r1 = r[off1 + i];
		const int16x8_t r2 = r[off2 + i];

		const int16x8_t INV0 = vmulq_laneq_s16(inv0, con, 7);
		const int16x8_t INV1 = vmulq_laneq_s16(inv1, con, 7);
		const int16x8_t INV2 = vmulq_laneq_s16(inv2, con, 7);

		r[off0 + i] = fqmul_precomp(pc0[pc_off0 + i - 1], inv0, INV0, con);
		r[off1 + i] = fqmul_precomp(pc0[pc_off1 + i - 1], inv1, INV1, con);
		r[off2 + i] = fqmul_precomp(pc0[pc_off2 + i - 1], inv2, INV2, con);

		inv0 = fqmul_precomp(r0, inv0, INV0, con);
		inv1 = fqmul_precomp(r1, inv1, INV1, con);
		inv2 = fqmul_precomp(r2, inv2, INV2, con);
	}

	r[off0] = inv0;
	r[off1] = inv1;
	r[off2] = inv2;

	u8_clear(pc0, sizeof pc0);
	return 0;
}

extern void poly_baseinv_1(poly *r, int16x8_t *den, const poly *a);

static inline void poly_baseinv_2(poly *r, const int16x8_t *den, int16x8_t con)
{
	int16_t *rp = r->coeffs;

	for (int i = 0; i < 24; i++)
	{
		const int16x8_t pden = den[i];
		const int16x8_t mden = vnegq_s16(pden);
		const int16x8_t PDEN = vmulq_laneq_s16(pden, con, 7);
		const int16x8_t MDEN = vnegq_s16(PDEN);

		const int offset = i * 32;

		int16x8_t r0 = vld1q_s16(rp + offset +  0);
		int16x8_t r1 = vld1q_s16(rp + offset +  8);
		int16x8_t r2 = vld1q_s16(rp + offset + 16);
		int16x8_t r3 = vld1q_s16(rp + offset + 24);

		r0 = fqmul_precomp(r0, pden, PDEN, con);
		r1 = fqmul_precomp(r1, mden, MDEN, con);
		r2 = fqmul_precomp(r2, pden, PDEN, con);
		r3 = fqmul_precomp(r3, mden, MDEN, con);

		vst1q_s16(rp + offset +  0, r0);
		vst1q_s16(rp + offset +  8, r1);
		vst1q_s16(rp + offset + 16, r2);
		vst1q_s16(rp + offset + 24, r3);
	}
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inversion of polynomial in NTT domain. poly_baseinv_1 exposes
*              all base denominators, fqinv_batch inverts them in batches,
*              and poly_baseinv_2 applies the inverses to complete each base
*              inverse.
*
* Reference:   [KCP26].
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to input polynomial
*
* Returns:     1 if the polynomial is not invertible; otherwise 0
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
	const int16x8_t con = vld1q_s16(consts);
	int16x8_t den[24] __attribute__((aligned(16)));

	poly_baseinv_1(r, den, a);

	const int fail = fqinv_batch(den, con);

	if (fail)
	{
		u8_clear(r->coeffs, sizeof r->coeffs);
	}
	else
	{
		poly_baseinv_2(r, den, con);
	}

	u8_clear(den, sizeof den);
	return fail;
}
