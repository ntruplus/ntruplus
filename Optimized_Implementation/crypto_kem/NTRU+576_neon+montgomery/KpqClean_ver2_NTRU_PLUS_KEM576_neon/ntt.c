#include "params.h"
#include <oqs/oqsconfig.h>
#include "reduce.h"
#include "ntt.h"
#include "poly.h"

#if defined(OQS_USE_ARM_NEON_INSTRUCTIONS) && (defined(__ARM_NEON) || defined(__ARM_NEON__))
#include <arm_neon.h>
#define NTRUPLUS_HAVE_NEON 1
#endif

const int16_t zetas[144] = {
	 -147, -1033, -1265,   708,   460,  1265,  -467,   727,
	  556,  1307,  -773,  -161,  1200, -1612,   570,  1529,
	 1135,  -556,  1120,   298,  -822, -1556,   -93,  1463,
	  532,  -377,  -909,    58,  -392,  -450,  1722,  1236,
	 -486,  -491, -1569, -1078,    36,  1289, -1443,  1628,
	 1664,  -725,  -952,    99, -1020,   353,  -599,  1119,
	  592,   839,  1622,   652,  1244,  -783, -1085,  -726,
	  566,  -284, -1369, -1292,   268,  -391,   781,  -172,
	   96, -1172,   211,   737,   473,  -445,  -234,   264,
	-1536,  1467,  -676, -1542,  -170,   635,  -705, -1332,
	 -658,   831, -1712,  1311,  1488,  -881,  1087, -1315,
	 1245,   -75,   791,    -6,  -875,  -697,   -70, -1162,
	  287,  -767,  -945,  1598,  -882,  1261,   206,   654,
	-1421,   -81,   716, -1251,   838, -1300,  1035,  -104,
	  966,  -558,   -61, -1704,   404,  -899,   862, -1593,
	-1460,   -37,  1266,   965, -1584, -1404,  -265,  -942,
	  905,  1195,  -619,   787,   118,   576,   286, -1475,
	 -194,   928,  1229, -1032,  1608,  1111, -1669,   642
};

#if defined(NTRUPLUS_HAVE_NEON)

// ---------------------------------------------------------
// KeyGen 가속을 위한 8-block 병렬 처리 헬퍼 함수들
// ---------------------------------------------------------

static inline int16x8_t fqmul_vec8(int16x8_t a, int16x8_t b) {
	int16x4_t a_lo = vget_low_s16(a);
	int16x4_t a_hi = vget_high_s16(a);
	int16x4_t b_lo = vget_low_s16(b);
	int16x4_t b_hi = vget_high_s16(b);
	int32x4_t p_lo = vmull_s16(a_lo, b_lo);
	int32x4_t p_hi = vmull_s16(a_hi, b_hi);
	return vcombine_s16(montgomery_reduce_vec4_opt(p_lo), montgomery_reduce_vec4_opt(p_hi));
}

// 벡터 모듈러 역원 (a^(q-2))
// 스칼라 fqinv와 동일한 연산 순서로 구현하여 정확성 확보
static inline int16x8_t fqinv_vec8(int16x8_t a) {
	int16x8_t t1, t2, t3;
	t1 = fqmul_vec8(a, a); t2 = fqmul_vec8(t1, t1); t2 = fqmul_vec8(t2, t2); t3 = fqmul_vec8(t2, t2);
	t1 = fqmul_vec8(t1, t2); t2 = fqmul_vec8(t1, t3); t2 = fqmul_vec8(t2, t2); t2 = fqmul_vec8(t2, a);
	t1 = fqmul_vec8(t1, t2); t2 = fqmul_vec8(t2, t2); t2 = fqmul_vec8(t2, t2); t2 = fqmul_vec8(t2, t2);
	t2 = fqmul_vec8(t2, t2); t2 = fqmul_vec8(t2, t2); t2 = fqmul_vec8(t2, t2); t2 = fqmul_vec8(t2, t1);
	return t2;
}

static inline int16x4_t barrett_reduce_vec4(int16x4_t a);
static inline int16x8_t barrett_reduce_vec8(int16x8_t a);

// ---------------------------------------------------------
// Main: 8개 블록 동시 처리 poly_baseinv
// ---------------------------------------------------------

// 8개 블록 동시 역원 계산 (검증 포함)
int poly_baseinv_neon(poly *r, const poly *a)
{
	const int16x8_t vzero = vdupq_n_s16(0);

	for(int i = 0; i < NTRUPLUS_N; i += 32)
	{
		int16x8x4_t v = vld4q_s16(a->coeffs + i);
		int16x8_t a0 = v.val[0];
		int16x8_t a1 = v.val[1];
		int16x8_t a2 = v.val[2];
		int16x8_t a3 = v.val[3];

		int start_k = 72 + i/8;
		int16_t z_buf[4] = {zetas[start_k], zetas[start_k+1], zetas[start_k+2], zetas[start_k+3]};
		int16x4_t z_base = vld1_s16(z_buf);
		int16x4_t z_neg = vneg_s16(z_base);
		int16x8_t zeta = vzipq_s16(vcombine_s16(z_base, z_base), vcombine_s16(z_neg, z_neg)).val[0];

		// t0 = a[2]^2 - 2*a[1]*a[3]
		int16x8_t sq2 = fqmul_vec8(a2, a2);
		int16x8_t tmp = fqmul_vec8(a1, a3);
		tmp = vaddq_s16(tmp, tmp);
		tmp = barrett_reduce_vec8(tmp);
		int16x8_t t0 = vsubq_s16(sq2, tmp);
		t0 = barrett_reduce_vec8(t0);

		// t1 = a[1]^2 + (a[3]^2)*zeta - 2*a[0]*a[2]
		int16x8_t t1 = fqmul_vec8(a3, a3);
		t1 = fqmul_vec8(t1, zeta);
		int16x8_t sq1 = fqmul_vec8(a1, a1);
		t1 = vaddq_s16(t1, sq1);
		t1 = barrett_reduce_vec8(t1);
		tmp = fqmul_vec8(a0, a2);
		tmp = vaddq_s16(tmp, tmp);
		tmp = barrett_reduce_vec8(tmp);
		t1 = vsubq_s16(t1, tmp);
		t1 = barrett_reduce_vec8(t1);

		// t0 = a[0]^2 + t0*zeta
		int16x8_t sq0 = fqmul_vec8(a0, a0);
		int16x8_t tz = fqmul_vec8(t0, zeta);
		t0 = vaddq_s16(sq0, tz);
		t0 = barrett_reduce_vec8(t0);

		int16x8_t t2 = fqmul_vec8(t1, zeta);

		// Determinant t3 = t0^2 - t1*t2
		int16x8_t t3 = fqmul_vec8(t0, t0);
		tmp = fqmul_vec8(t1, t2);
		t3 = vsubq_s16(t3, tmp);
		t3 = barrett_reduce_vec8(t3);

		uint16x8_t is_zero = vceqq_s16(t3, vzero);
		uint64x2_t z64 = vreinterpretq_u64_u16(is_zero);
		if (vgetq_lane_u64(z64, 0) | vgetq_lane_u64(z64, 1)) {
			return 1;
		}

		t3 = fqinv_vec8(t3);

		int16x8_t r0 = fqmul_vec8(a0, t0);
		tmp = fqmul_vec8(a2, t2);
		r0 = vaddq_s16(r0, tmp);
		r0 = barrett_reduce_vec8(r0);
		r0 = fqmul_vec8(r0, t3);

		int16x8_t r1 = fqmul_vec8(a3, t2);
		tmp = fqmul_vec8(a1, t0);
		r1 = vaddq_s16(r1, tmp);
		r1 = barrett_reduce_vec8(r1);
		r1 = fqmul_vec8(r1, t3);
		r1 = vnegq_s16(r1);
		r1 = barrett_reduce_vec8(r1);

		int16x8_t r2 = fqmul_vec8(a2, t0);
		tmp = fqmul_vec8(a0, t1);
		r2 = vaddq_s16(r2, tmp);
		r2 = barrett_reduce_vec8(r2);
		r2 = fqmul_vec8(r2, t3);

		int16x8_t r3 = fqmul_vec8(a1, t1);
		tmp = fqmul_vec8(a3, t0);
		r3 = vaddq_s16(r3, tmp);
		r3 = barrett_reduce_vec8(r3);
		r3 = fqmul_vec8(r3, t3);
		r3 = vnegq_s16(r3);
		r3 = barrett_reduce_vec8(r3);

		int16x8x4_t res;
		res.val[0] = r0;
		res.val[1] = r1;
		res.val[2] = r2;
		res.val[3] = r3;
		vst4q_s16(r->coeffs + i, res);
	}

	return 0;
}

// static inline int16x4_t montgomery_reduce_vec4(int32x4_t a)
// {
// 	int16x4_t a16 = vmovn_s32(a);
// 	int16x4_t t16 = vmul_n_s16(a16, QINV);
// 	// int32x4_t prod = vmull_s16(t16, vdup_n_s16(NTRUPLUS_Q));
// 	// int32x4_t res = vshrq_n_s32(vsubq_s32(a, prod), 16);
// 	int32x4_t res = vmlsl_n_s16(a, t16, NTRUPLUS_Q);
// 	res = vshrq_n_s32(res, 16);
// 	return vmovn_s32(res);
// }

static inline int16x4_t montgomery_reduce_vec4(int32x4_t a) {
	return montgomery_reduce_vec4_opt(a);
}

static inline int16x4_t fqmul_vec4_const(int16x4_t a, int16_t zeta) { return montgomery_reduce_vec4(vmull_s16(a, vdup_n_s16(zeta))); }

static inline int16x8_t fqmul_vec8_const(int16x8_t a, int16_t zeta) {
	return vcombine_s16(fqmul_vec4_const(vget_low_s16(a), zeta), fqmul_vec4_const(vget_high_s16(a), zeta));
}

static inline int16x4_t barrett_reduce_vec4(int16x4_t a) {
	const int32_t v = ((1 << 26) + NTRUPLUS_Q/2)/NTRUPLUS_Q;
	int32x4_t a32 = vmovl_s16(a);
	int32x4_t t = vaddq_s32(vmulq_n_s32(a32, v), vdupq_n_s32(1 << 25));
	t = vshrq_n_s32(t, 26);
	t = vmulq_n_s32(t, NTRUPLUS_Q);
	return vmovn_s32(vsubq_s32(a32, t));
}

static inline int16x8_t barrett_reduce_vec8(int16x8_t a) {
	return vcombine_s16(barrett_reduce_vec4(vget_low_s16(a)), barrett_reduce_vec4(vget_high_s16(a)));
}
// 8개 계수(2블록)에 대한 basemul 연산
// r: 결과 포인터, a, b: 입력 포인터
// zeta: 첫 번째 블록용 제타 (두 번째 블록은 -zeta가 자동 적용됨)
void basemul_vec8(int16_t *r, const int16_t *a, const int16_t *b, int16_t zeta) {
    int16x4_t a_lo = vld1_s16(a);
    int16x4_t a_hi = vld1_s16(a + 4);
    int16x4_t b_lo = vld1_s16(b);
    int16x4_t b_hi = vld1_s16(b + 4);
    int16x4_t z_vec_lo = vdup_n_s16(zeta);
    int16x4_t z_vec_hi = vdup_n_s16(-zeta);
    int32x4_t acc_H_lo = vdupq_n_s32(0);
    int32x4_t acc_H_hi = vdupq_n_s32(0);
    int32x4_t acc_L_lo = vdupq_n_s32(0);
    int32x4_t acc_L_hi = vdupq_n_s32(0);

    int16x4_t a0_lo = vdup_lane_s16(a_lo, 0);
    int16x4_t a0_hi = vdup_lane_s16(a_hi, 0);
    acc_L_lo = vmlal_s16(acc_L_lo, a0_lo, b_lo);
    acc_L_hi = vmlal_s16(acc_L_hi, a0_hi, b_hi);

    int16x4_t b_rot1_lo = vext_s16(b_lo, b_lo, 3);
    int16x4_t b_rot1_hi = vext_s16(b_hi, b_hi, 3);
    int16x4_t a1_lo = vdup_lane_s16(a_lo, 1);
    int16x4_t a1_hi = vdup_lane_s16(a_hi, 1);
    int32x4_t p_lo = vmull_s16(a1_lo, b_rot1_lo);
    int32x4_t p_hi = vmull_s16(a1_hi, b_rot1_hi);
    static const int32_t mask_h1[4] = {-1, 0, 0, 0};
    int32x4_t mh1 = vld1q_s32(mask_h1);
    acc_H_lo = vaddq_s32(acc_H_lo, vandq_s32(p_lo, mh1));
    acc_H_hi = vaddq_s32(acc_H_hi, vandq_s32(p_hi, mh1));
    acc_L_lo = vaddq_s32(acc_L_lo, vbicq_s32(p_lo, mh1));
    acc_L_hi = vaddq_s32(acc_L_hi, vbicq_s32(p_hi, mh1));

    int16x4_t b_rot2_lo = vext_s16(b_lo, b_lo, 2);
    int16x4_t b_rot2_hi = vext_s16(b_hi, b_hi, 2);
    int16x4_t a2_lo = vdup_lane_s16(a_lo, 2);
    int16x4_t a2_hi = vdup_lane_s16(a_hi, 2);
    p_lo = vmull_s16(a2_lo, b_rot2_lo);
    p_hi = vmull_s16(a2_hi, b_rot2_hi);
    static const int32_t mask_h2[4] = {-1, -1, 0, 0};
    int32x4_t mh2 = vld1q_s32(mask_h2);
    acc_H_lo = vaddq_s32(acc_H_lo, vandq_s32(p_lo, mh2));
    acc_H_hi = vaddq_s32(acc_H_hi, vandq_s32(p_hi, mh2));
    acc_L_lo = vaddq_s32(acc_L_lo, vbicq_s32(p_lo, mh2));
    acc_L_hi = vaddq_s32(acc_L_hi, vbicq_s32(p_hi, mh2));

    int16x4_t b_rot3_lo = vext_s16(b_lo, b_lo, 1);
    int16x4_t b_rot3_hi = vext_s16(b_hi, b_hi, 1);
    int16x4_t a3_lo = vdup_lane_s16(a_lo, 3);
    int16x4_t a3_hi = vdup_lane_s16(a_hi, 3);
    p_lo = vmull_s16(a3_lo, b_rot3_lo);
    p_hi = vmull_s16(a3_hi, b_rot3_hi);
    static const int32_t mask_h3[4] = {-1, -1, -1, 0};
    int32x4_t mh3 = vld1q_s32(mask_h3);
    acc_H_lo = vaddq_s32(acc_H_lo, vandq_s32(p_lo, mh3));
    acc_H_hi = vaddq_s32(acc_H_hi, vandq_s32(p_hi, mh3));
    acc_L_lo = vaddq_s32(acc_L_lo, vbicq_s32(p_lo, mh3));
    acc_L_hi = vaddq_s32(acc_L_hi, vbicq_s32(p_hi, mh3));

    int16x4_t h_red_lo = montgomery_reduce_vec4_opt(acc_H_lo);
    int16x4_t h_red_hi = montgomery_reduce_vec4_opt(acc_H_hi);
    acc_L_lo = vmlal_s16(acc_L_lo, h_red_lo, z_vec_lo);
    acc_L_hi = vmlal_s16(acc_L_hi, h_red_hi, z_vec_hi);
    int16x4_t res_lo = montgomery_reduce_vec4_opt(acc_L_lo);
    int16x4_t res_hi = montgomery_reduce_vec4_opt(acc_L_hi);
    vst1_s16(r, res_lo);
    vst1_s16(r + 4, res_hi);
}

void basemul_add_vec8(int16_t *r, const int16_t *a, const int16_t *b, const int16_t *c, int16_t zeta) {
    int16x4_t a_lo = vld1_s16(a);
    int16x4_t a_hi = vld1_s16(a + 4);
    int16x4_t b_lo = vld1_s16(b);
    int16x4_t b_hi = vld1_s16(b + 4);
    int16x4_t c_lo = vld1_s16(c);
    int16x4_t c_hi = vld1_s16(c + 4);
    int16x4_t z_vec_lo = vdup_n_s16(zeta);
    int16x4_t z_vec_hi = vdup_n_s16(-zeta);
    int32x4_t acc_L_lo = vmull_n_s16(c_lo, -147);
    int32x4_t acc_L_hi = vmull_n_s16(c_hi, -147);
    int32x4_t acc_H_lo = vdupq_n_s32(0);
    int32x4_t acc_H_hi = vdupq_n_s32(0);

    int16x4_t a0_lo = vdup_lane_s16(a_lo, 0);
    int16x4_t a0_hi = vdup_lane_s16(a_hi, 0);
    acc_L_lo = vmlal_s16(acc_L_lo, a0_lo, b_lo);
    acc_L_hi = vmlal_s16(acc_L_hi, a0_hi, b_hi);

    int16x4_t b_rot1_lo = vext_s16(b_lo, b_lo, 3);
    int16x4_t b_rot1_hi = vext_s16(b_hi, b_hi, 3);
    int16x4_t a1_lo = vdup_lane_s16(a_lo, 1);
    int16x4_t a1_hi = vdup_lane_s16(a_hi, 1);
    int32x4_t p_lo = vmull_s16(a1_lo, b_rot1_lo);
    int32x4_t p_hi = vmull_s16(a1_hi, b_rot1_hi);
    static const int32_t mask_h1[4] = {-1, 0, 0, 0};
    int32x4_t mh1 = vld1q_s32(mask_h1);
    acc_H_lo = vaddq_s32(acc_H_lo, vandq_s32(p_lo, mh1));
    acc_H_hi = vaddq_s32(acc_H_hi, vandq_s32(p_hi, mh1));
    acc_L_lo = vaddq_s32(acc_L_lo, vbicq_s32(p_lo, mh1));
    acc_L_hi = vaddq_s32(acc_L_hi, vbicq_s32(p_hi, mh1));

    int16x4_t b_rot2_lo = vext_s16(b_lo, b_lo, 2);
    int16x4_t b_rot2_hi = vext_s16(b_hi, b_hi, 2);
    int16x4_t a2_lo = vdup_lane_s16(a_lo, 2);
    int16x4_t a2_hi = vdup_lane_s16(a_hi, 2);
    p_lo = vmull_s16(a2_lo, b_rot2_lo);
    p_hi = vmull_s16(a2_hi, b_rot2_hi);
    static const int32_t mask_h2[4] = {-1, -1, 0, 0};
    int32x4_t mh2 = vld1q_s32(mask_h2);
    acc_H_lo = vaddq_s32(acc_H_lo, vandq_s32(p_lo, mh2));
    acc_H_hi = vaddq_s32(acc_H_hi, vandq_s32(p_hi, mh2));
    acc_L_lo = vaddq_s32(acc_L_lo, vbicq_s32(p_lo, mh2));
    acc_L_hi = vaddq_s32(acc_L_hi, vbicq_s32(p_hi, mh2));

    int16x4_t b_rot3_lo = vext_s16(b_lo, b_lo, 1);
    int16x4_t b_rot3_hi = vext_s16(b_hi, b_hi, 1);
    int16x4_t a3_lo = vdup_lane_s16(a_lo, 3);
    int16x4_t a3_hi = vdup_lane_s16(a_hi, 3);
    p_lo = vmull_s16(a3_lo, b_rot3_lo);
    p_hi = vmull_s16(a3_hi, b_rot3_hi);
    static const int32_t mask_h3[4] = {-1, -1, -1, 0};
    int32x4_t mh3 = vld1q_s32(mask_h3);
    acc_H_lo = vaddq_s32(acc_H_lo, vandq_s32(p_lo, mh3));
    acc_H_hi = vaddq_s32(acc_H_hi, vandq_s32(p_hi, mh3));
    acc_L_lo = vaddq_s32(acc_L_lo, vbicq_s32(p_lo, mh3));
    acc_L_hi = vaddq_s32(acc_L_hi, vbicq_s32(p_hi, mh3));

    int16x4_t h_red_lo = montgomery_reduce_vec4_opt(acc_H_lo);
    int16x4_t h_red_hi = montgomery_reduce_vec4_opt(acc_H_hi);
    acc_L_lo = vmlal_s16(acc_L_lo, h_red_lo, z_vec_lo);
    acc_L_hi = vmlal_s16(acc_L_hi, h_red_hi, z_vec_hi);
    int16x4_t res_lo = montgomery_reduce_vec4_opt(acc_L_lo);
    int16x4_t res_hi = montgomery_reduce_vec4_opt(acc_L_hi);
    vst1_s16(r, res_lo);
    vst1_s16(r + 4, res_hi);
}

// 헬퍼: 32비트 몽고메리 감산 (int32x4_t -> int16x4_t)
inline int16x4_t montgomery_reduce_vec4_opt(int32x4_t a) {
	int16x4_t a16 = vmovn_s32(a);
	int16x4_t t16 = vmul_n_s16(a16, QINV);
	int32x4_t res = vmlsl_n_s16(a, t16, NTRUPLUS_Q);
	return vmovn_s32(vshrq_n_s32(res, 16));
}


/*************************************************
* Name:        fqmul
*
* Description: Multiplication followed by Montgomery reduction
*
* Arguments:   - int16_t a: first factor
*              - int16_t b: second factor
*
* Returns 16-bit integer congruent to a*b*R^{-1} mod q
**************************************************/
static int16_t fqmul(int16_t a, int16_t b)
{
	return montgomery_reduce((int32_t)a*b);
}

/*************************************************
* Name:        fqinv
*
* Description: Inversion
*
* Arguments:   - int16_t a: first factor a = x mod q
*
* Returns 16-bit integer congruent to x^{-1} * R^2 mod q
**************************************************/
static int16_t fqinv(int16_t a)
{
	int16_t t1,t2,t3;

	t1 = fqmul(a, a);    //10
	t2 = fqmul(t1, t1);  //100
	t2 = fqmul(t2, t2);  //1000
	t3 = fqmul(t2, t2);  //10000

	t1 = fqmul(t1, t2);  //1010

	t2 = fqmul(t1, t3);  //11010
	t2 = fqmul(t2, t2);  //110100
	t2 = fqmul(t2, a);   //110101

	t1 = fqmul(t1, t2);  //111111

	t2 = fqmul(t2, t2);  //1101010
	t2 = fqmul(t2, t2);  //11010100
	t2 = fqmul(t2, t2);  //110101000
	t2 = fqmul(t2, t2);  //1101010000
	t2 = fqmul(t2, t2);  //11010100000
	t2 = fqmul(t2, t2);  //110101000000
	t2 = fqmul(t2, t1);  //110101111111

	return t2;
}

/*************************************************
* Name:        ntt
*
* Description: number-theoretic transform (NTT) in Rq.
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to output vector of elements of Zq
*              - int16_t a[NTRUPLUS_N]: pointer to input vector of elements of Zq
**************************************************/
void ntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
int k = 1;
    int16_t zeta1 = zetas[k++];
    for(int i = 0; i < NTRUPLUS_N/2; i += 8) {
       int16x8_t a0 = vld1q_s16(a + i);
       int16x8_t a1 = vld1q_s16(a + i + NTRUPLUS_N/2);
       int16x8_t t1 = fqmul_vec8_const(a1, zeta1);
       vst1q_s16(r + i + NTRUPLUS_N/2, vsubq_s16(vaddq_s16(a0, a1), t1));
       vst1q_s16(r + i, vaddq_s16(a0, t1));
    }
    for(int step = NTRUPLUS_N/6; step >= 32; step = step/3) {
       for(int start = 0; start < NTRUPLUS_N; start += 3*step) {
          int16_t zeta_a = zetas[k++];
          int16_t zeta_b = zetas[k++];
          for(int i = start; i < start + step; i += 8) {
             int16x8_t r0 = vld1q_s16(r + i);
             int16x8_t r1 = vld1q_s16(r + i + step);
             int16x8_t r2 = vld1q_s16(r + i + 2*step);
             int16x8_t t1 = fqmul_vec8_const(r1, zeta_a);
             int16x8_t t2 = fqmul_vec8_const(r2, zeta_b);
             int16x8_t diff = vsubq_s16(t1, t2);
             int16x8_t t3 = fqmul_vec8_const(diff, -886);
             vst1q_s16(r + i + 2*step, vsubq_s16(vsubq_s16(r0, t1), t3));
             vst1q_s16(r + i +   step, vaddq_s16(vsubq_s16(r0, t2), t3));
             vst1q_s16(r + i, vaddq_s16(r0, vaddq_s16(t1, t2)));
          }
       }
    }
    for(int step = 16; step >= 4; step >>= 1) {
       for(int start = 0; start < NTRUPLUS_N; start += (step << 1)) {
          int16_t zeta = zetas[k++];
          for(int i = start; i < start + step; i += (step >= 8 ? 8 : 4)) {
             if (step >= 8) {
                 int16x8_t r0 = vld1q_s16(r + i);
                 int16x8_t r1 = vld1q_s16(r + i + step);
                 int16x8_t t1 = fqmul_vec8_const(r1, zeta);
                 vst1q_s16(r + i, barrett_reduce_vec8(vaddq_s16(r0, t1)));
                 vst1q_s16(r + i + step, barrett_reduce_vec8(vsubq_s16(r0, t1)));
             } else {
                 int16x4_t r0 = vld1_s16(r + i);
                 int16x4_t r1 = vld1_s16(r + i + step);
                 int16x4_t t1 = fqmul_vec4_const(r1, zeta);
                 vst1_s16(r + i, barrett_reduce_vec4(vadd_s16(r0, t1)));
                 vst1_s16(r + i + step, barrett_reduce_vec4(vsub_s16(r0, t1)));
             }
          }
       }
    }
}

/*************************************************
* Name:        invntt
*
* Description: inverse number-theoretic transform in Rq and
*              multiplication by Montgomery factor R = 2^16.
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to output vector of elements of Zq
*              - int16_t a[NTRUPLUS_N]: pointer to input vector of elements of Zq
**************************************************/
void invntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N]) {
	int k = 143;
	for(int i = 0; i < NTRUPLUS_N; i += 8) {
		vst1q_s16(r + i, vld1q_s16(a + i));
	}
	for(int step = 4; step <= 16; step <<= 1) {
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1)) {
			int16_t zeta = zetas[k--];
			for(int i = start; i < start + step; i += (step >= 8 ? 8 : 4)) {
				if (step >= 8) {
					int16x8_t r0 = vld1q_s16(r + i);
					int16x8_t r1 = vld1q_s16(r + i + step);
					int16x8_t sum = vaddq_s16(r0, r1);
					int16x8_t diff = vsubq_s16(r1, r0);
					vst1q_s16(r + i, barrett_reduce_vec8(sum));
					vst1q_s16(r + i + step, fqmul_vec8_const(diff, zeta));
				} else {
					int16x4_t r0 = vld1_s16(r + i);
					int16x4_t r1 = vld1_s16(r + i + step);
					int16x4_t sum = vadd_s16(r0, r1);
					int16x4_t diff = vsub_s16(r1, r0);
					vst1_s16(r + i, barrett_reduce_vec4(sum));
					vst1_s16(r + i + step, fqmul_vec4_const(diff, zeta));
				}
			}
		}
	}

	for(int step = 32; step <= NTRUPLUS_N/6; step = 3*step)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			int16_t zeta2 = zetas[k--];
			int16_t zeta1 = zetas[k--];

			for(int i = start; i < start + step; i += 8)
			{
				int16x8_t r0 = vld1q_s16(r + i);
				int16x8_t r1 = vld1q_s16(r + i + step);
				int16x8_t r2 = vld1q_s16(r + i + 2*step);
				int16x8_t diff1 = vsubq_s16(r1, r0);
				int16x8_t t1 = fqmul_vec8_const(diff1, -886);
				int16x8_t t2 = fqmul_vec8_const(vaddq_s16(vsubq_s16(r2, r0), t1), zeta1);
				int16x8_t t3 = fqmul_vec8_const(vsubq_s16(vsubq_s16(r2, r1), t1), zeta2);

				vst1q_s16(r + i, barrett_reduce_vec8(vaddq_s16(vaddq_s16(r0, r1), r2)));
				vst1q_s16(r + i + step, t2);
				vst1q_s16(r + i + 2*step, t3);
			}
		}
	}

	for(int i = 0; i < NTRUPLUS_N/2; i += 8)
	{
		int16x8_t r0 = vld1q_s16(r + i);
		int16x8_t r1 = vld1q_s16(r + i + NTRUPLUS_N/2);
		int16x8_t t1 = vaddq_s16(r0, r1);
		int16x8_t diff = vsubq_s16(r0, r1);
		int16x8_t t2 = fqmul_vec8_const(diff, -1665);
		int16x8_t out0 = fqmul_vec8_const(vsubq_s16(t1, t2), -66);
		int16x8_t out1 = fqmul_vec8_const(t2, -132);

		vst1q_s16(r + i, out0);
		vst1q_s16(r + i + NTRUPLUS_N/2, out1);
	}
}
#endif


/*************************************************
* Name:        baseinv
*
* Description: Inversion of polynomial in Zq[X]/(X^4-zeta)
*              used for inversion of element in Rq in NTT domain
*
* Arguments:   - int16_t r[4]: pointer to the output polynomial
*              - const int16_t a[4]: pointer to the input polynomial
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
// int baseinv(int16_t r[4], const int16_t a[4], int16_t zeta)
// {
// 	int16_t t0, t1, t2, t3;
//
// 	t0 = montgomery_reduce(a[2]*a[2] - (a[1]*a[3] << 1));
// 	t1 = montgomery_reduce(a[3]*a[3]);
// 	t0 = montgomery_reduce(a[0]*a[0] + t0*zeta);
// 	t1 = montgomery_reduce(a[1]*a[1] + t1*zeta - ((a[0]*a[2]) << 1));
// 	t2 = montgomery_reduce(t1*zeta);
//
// 	t3 = montgomery_reduce(t0*t0 - t1*t2);
//
// 	if(t3 == 0) return 1;
//
// 	r[0] = montgomery_reduce(a[0]*t0 + a[2]*t2);
// 	r[1] = montgomery_reduce(a[3]*t2 + a[1]*t0);
// 	r[2] = montgomery_reduce(a[2]*t0 + a[0]*t1);
// 	r[3] = montgomery_reduce(a[1]*t1 + a[3]*t0);
//
// 	t3 = fqinv(t3);
//
// 	r[0] =  montgomery_reduce(r[0]*t3);
// 	r[1] = -montgomery_reduce(r[1]*t3);
// 	r[2] =  montgomery_reduce(r[2]*t3);
// 	r[3] = -montgomery_reduce(r[3]*t3);
//
// 	return 0;
// }

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^4-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t r[4]: pointer to the output polynomial
*              - const int16_t a[4]: pointer to the first factor
*              - const int16_t b[4]: pointer to the second factor
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
void basemul(int16_t r[4], const int16_t a[4], const int16_t b[4], int16_t zeta)
{
	r[0] = montgomery_reduce(a[1]*b[3]+a[2]*b[2]+a[3]*b[1]);
	r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
	r[2] = montgomery_reduce(a[3]*b[3]);

	r[0] = montgomery_reduce(r[0]*zeta+a[0]*b[0]);
	r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
	r[2] = montgomery_reduce(r[2]*zeta+a[0]*b[2]+a[1]*b[1]+a[2]*b[0]);
	r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
}

/*************************************************
* Name:        basemul_add
*
* Description: Multiplication then addition of polynomials in Zq[X]/(X^4-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t c[4]: pointer to the output polynomial
*              - const int16_t a[4]: pointer to the first factor
*              - const int16_t b[4]: pointer to the second factor
*              - const int16_t c[4]: pointer to the third factor
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
void basemul_add(int16_t r[4], const int16_t a[4], const int16_t b[4], const int16_t c[4], int16_t zeta)
{
	r[0] = montgomery_reduce(a[1]*b[3]+a[2]*b[2]+a[3]*b[1]);
	r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
	r[2] = montgomery_reduce(a[3]*b[3]);

	r[0] = montgomery_reduce(c[0]*(-147)+r[0]*zeta+a[0]*b[0]);
	r[1] = montgomery_reduce(c[1]*(-147)+r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
	r[2] = montgomery_reduce(c[2]*(-147)+r[2]*zeta+a[0]*b[2]+a[1]*b[1]+a[2]*b[0]);
	r[3] = montgomery_reduce(c[3]*(-147)+a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
}
