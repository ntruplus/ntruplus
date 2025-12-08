#include <stdint.h>
#include <oqs/oqsconfig.h>
#include "params.h"
#include "poly.h"

#include <stdio.h>

#include "ntt.h"
#include "reduce.h"
#include "symmetric.h"

#if defined(OQS_USE_ARM_NEON_INSTRUCTIONS) && (defined(__ARM_NEON) || defined(__ARM_NEON__))
#include <arm_neon.h>
#define NTRUPLUS_HAVE_NEON 1
#endif

#if defined(NTRUPLUS_HAVE_NEON)
int poly_baseinv_neon(poly *r, const poly *a);
#endif

#if defined(NTRUPLUS_HAVE_NEON)
static const int16_t cbd_shift_lo_data[8] = {0, -1, -2, -3, -4, -5, -6, -7};
static const int16_t cbd_shift_hi_data[8] = {-8, -9, -10, -11, -12, -13, -14, -15};

static inline void cbd1_expand16(int16_t out[16], uint16_t t1, uint16_t t2)
{
	const uint16x8_t ones = vdupq_n_u16(1);
	const int16x8_t shift_lo = vld1q_s16(cbd_shift_lo_data);
	const int16x8_t shift_hi = vld1q_s16(cbd_shift_hi_data);

	uint16x8_t v1 = vdupq_n_u16(t1);
	uint16x8_t v2 = vdupq_n_u16(t2);

	uint16x8_t bits1_lo = vandq_u16(vshlq_u16(v1, shift_lo), ones);
	uint16x8_t bits2_lo = vandq_u16(vshlq_u16(v2, shift_lo), ones);
	int16x8_t diff_lo = vsubq_s16(vreinterpretq_s16_u16(bits1_lo), vreinterpretq_s16_u16(bits2_lo));
	vst1q_s16(out, diff_lo);

	uint16x8_t bits1_hi = vandq_u16(vshlq_u16(v1, shift_hi), ones);
	uint16x8_t bits2_hi = vandq_u16(vshlq_u16(v2, shift_hi), ones);
	int16x8_t diff_hi = vsubq_s16(vreinterpretq_s16_u16(bits1_hi), vreinterpretq_s16_u16(bits2_hi));
	vst1q_s16(out + 8, diff_hi);
}
#endif

/*************************************************
* Name:        load16_littleendian
*
* Description: load 2 bytes into a 16-bit integer
*              in little-endian order
*
* Arguments:   - const uint8_t *x: pointer to input byte array
*
* Returns 16-bit unsigned integer loaded from x
**************************************************/
static uint16_t load16_littleendian(const uint8_t x[2])
{
	uint16_t r;
	r  = (uint32_t)x[0];
	r |= (uint32_t)x[1] << 8;;
	return r;
}

/*************************************************
* Name:        crepmod3
*
* Description: Compute modulus 3 operation
*
* Arguments: - poly *a: pointer to intput integer to be reduced
*
* Returns:     integer in {-1,0,1} congruent to a modulo 3.
**************************************************/
#if defined(NTRUPLUS_HAVE_NEON)
static inline int16x8_t crepmod3_vec(int16x8_t a)
{
	const int16x8_t vq = vdupq_n_s16(NTRUPLUS_Q);
	const int16x8_t vhalf1 = vdupq_n_s16((NTRUPLUS_Q + 1)/2);
	const int16x8_t vhalf2 = vdupq_n_s16((NTRUPLUS_Q - 1)/2);
	const int16x8_t v255 = vdupq_n_s16(255);
	const int16x8_t v15 = vdupq_n_s16(15);
	const int16x8_t v3 = vdupq_n_s16(3);
	const int16x8_t vone = vdupq_n_s16(1);

	int16x8_t sign = vshrq_n_s16(a, 15);
	a = vaddq_s16(a, vandq_s16(sign, vq));
	a = vsubq_s16(a, vhalf1);
	sign = vshrq_n_s16(a, 15);
	a = vaddq_s16(a, vandq_s16(sign, vq));
	a = vsubq_s16(a, vhalf2);

	int16x8_t tmp = vaddq_s16(vshrq_n_s16(a, 8), vandq_s16(a, v255));
	tmp = vaddq_s16(vshrq_n_s16(tmp, 4), vandq_s16(tmp, v15));
	tmp = vaddq_s16(vshrq_n_s16(tmp, 2), vandq_s16(tmp, v3));
	tmp = vaddq_s16(vshrq_n_s16(tmp, 2), vandq_s16(tmp, v3));
	tmp = vsubq_s16(tmp, vdupq_n_s16(3));

	int16x8_t tmp2 = vaddq_s16(tmp, vone);
	int16x8_t mask = vshrq_n_s16(tmp2, 15);
	mask = vandq_s16(mask, v3);
	return vaddq_s16(tmp, mask);
}
#endif

static int16_t crepmod3(int16_t a)
{
	a += (a >> 15) & NTRUPLUS_Q;
	a -= (NTRUPLUS_Q+1)/2;
	a += (a >> 15) & NTRUPLUS_Q;
	a -= (NTRUPLUS_Q-1)/2;

	a  = (a >> 8) + (a & 255);
	a  = (a >> 4) + (a & 15);
	a  = (a >> 2) + (a & 3);
	a  = (a >> 2) + (a & 3);
	a -= 3;
	a += ((a + 1) >> 15) & 3;
	return a;
}

/*************************************************
* Name:        poly_tobytes
*
* Description: Serialization of a polynomial
*
* Arguments:   - uint8_t *r: pointer to output byte array
*                            (needs space for NTRUPLUS_POLYBYTES bytes)
*              - poly *a:    pointer to input polynomial
**************************************************/
void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a)
{
	int16_t t[4];

	for (int i = 0; i < 16; i++)
	{
		for (int j = 0; j < 9; j++)
		{
			t[0]  = a->coeffs[64*j + i];
			t[0] += (t[0] >> 15) & NTRUPLUS_Q;
			t[1]  = a->coeffs[64*j + i + 16];
			t[1] += (t[1] >> 15) & NTRUPLUS_Q;
			t[2]  = a->coeffs[64*j + i + 32];
			t[2] += (t[2] >> 15) & NTRUPLUS_Q;			
			t[3]  = a->coeffs[64*j + i + 48];
			t[3] += (t[3] >> 15) & NTRUPLUS_Q;			

			r[96*j + 2*i +  0] = t[0];
			r[96*j + 2*i +  1] = (t[0] >> 8) | (t[1] << 4);			
			r[96*j + 2*i + 32] = (t[1] >> 4);
			r[96*j + 2*i + 33] = t[2];
			r[96*j + 2*i + 64] = (t[2] >> 8) | (t[3] << 4); 
			r[96*j + 2*i + 65] = (t[3] >> 4); 
		}	
	}
}

/*************************************************
* Name:        poly_frombytes
*
* Description: De-serialization of a polynomial;
*              inverse of poly_tobytes
*
* Arguments:   - poly *r:          pointer to output polynomial
*              - const uint8_t *a: pointer to input byte array
*                                  (of NTRUPLUS_POLYBYTES bytes)
**************************************************/
void poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES])
{
	unsigned char t[6];

	for(int i = 0; i < 16; i++)
	{
		for(int j = 0; j < 9; j++)
		{
			t[0] = a[96*j + 2*i];
			t[1] = a[96*j + 2*i + 1];
			t[2] = a[96*j + 2*i + 32];
			t[3] = a[96*j + 2*i + 33];
			t[4] = a[96*j + 2*i + 64];
			t[5] = a[96*j + 2*i + 65];								

			r->coeffs[64*j + i +  0] = t[0]      | ((int16_t)t[1] & 0xf) << 8;
			r->coeffs[64*j + i + 16] = t[1] >> 4 | ((int16_t)t[2]      ) << 4;
			r->coeffs[64*j + i + 32] = t[3]      | ((int16_t)t[4] & 0xf) << 8;
			r->coeffs[64*j + i + 48] = t[4] >> 4 | ((int16_t)t[5]      ) << 4;
		}
	}
}

/*************************************************
* Name:        poly_cbd1
*
* Description: Sample a polynomial deterministically from a random,
*              with output polynomial close to centered binomial distribution
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *buf: pointer to input random
*                                     (of length NTRUPLUS_N/4 bytes)
**************************************************/
void poly_cbd1(poly *r, const uint8_t buf[NTRUPLUS_N/4])
{
	uint16_t t1, t2;

	int16_t diff[16];

	for(int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 16; j++)
		{
			t1 = load16_littleendian(buf + 32*i + 2*j);
			t2 = load16_littleendian(buf + 32*i + 2*j + 72);
			cbd1_expand16(diff, t1, t2);

			for(int k = 0; k < 16; k++)
			{
				r->coeffs[256*i + 16*k + j] = diff[k];
			}
		}
	}

	for (int j = 0; j < 4; j++)
	{
		t1 = load16_littleendian(buf + 64 + 2*j);
		t2 = load16_littleendian(buf + 64 + 2*j + 72);
		cbd1_expand16(diff, t1, t2);

		for(int k = 0; k < 16; k++)
		{
			r->coeffs[512 + 4*k + j] = diff[k];
		}
	}
}

/*************************************************
* Name:        poly_sotp
*
* Description: Encode a message deterministically using SOTP and a random,
			   with output polynomial close to centered binomial distribution
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *msg: pointer to input message
*              - const uint8_t *buf: pointer to input random
**************************************************/
void poly_sotp(poly *r, const uint8_t *msg, const uint8_t *buf)
{
    uint8_t tmp[NTRUPLUS_N/4];

    int i = 0;
    const int xor_len = NTRUPLUS_N/8;
    for(; i + 16 <= xor_len; i += 16)
    {
        uint8x16_t b = vld1q_u8(buf + i);
        uint8x16_t m = vld1q_u8(msg + i);
        vst1q_u8(tmp + i, veorq_u8(b, m));
    }
    for(; i < xor_len; i++)
    {
        tmp[i] = buf[i]^msg[i];
    }

    const int copy_len = (NTRUPLUS_N/4) - xor_len;
    const uint8_t *buf_tail = buf + xor_len;
    uint8_t *tmp_tail = tmp + xor_len;
    int j = 0;
    for(; j + 16 <= copy_len; j += 16)
    {
        vst1q_u8(tmp_tail + j, vld1q_u8(buf_tail + j));
    }
    for(; j < copy_len; j++)
    {
        tmp_tail[j] = buf_tail[j];
    }

	poly_cbd1(r, tmp);
}

/*************************************************
* Name:        poly_sotp_inv
*
* Description: Decode a message deterministically using SOTP_INV and a random
*
* Arguments:   - uint8_t *msg: pointer to output message
*              - const poly *a: pointer to iput polynomial
*              - const uint8_t *buf: pointer to input random
*
* Returns 0 (success) or 1 (failure)
**************************************************/
int poly_sotp_inv(uint8_t *msg, const poly *a, const uint8_t *buf)
{
	uint32_t t1, t2, t3, t4;
	uint32_t r = 0;

	for(int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 16; j++)
		{
			t1 = load16_littleendian(buf + 32*i + 2*j);
			t2 = load16_littleendian(buf + 32*i + 2*j + 72);
			t3 = 0;

			for(int k = 0; k < 16; k++)
			{
				t4 = t2 & 0x1;
				t4 += a->coeffs[256*i + 16*k + j];
				r |= t4;
				t4 = (t4^t1) & 0x1;
				t3 ^= t4 << k;

				t1 >>= 1;
				t2 >>= 1;
			}

			msg[32*i + 2*j   ] = t3;
			msg[32*i + 2*j + 1] = t3 >> 8;
		}
	}

	for (int j = 0; j < 4; j++)
	{
		t1 = load16_littleendian(buf + 64 + 2*j);
		t2 = load16_littleendian(buf + 64 + 2*j + 72);
		t3 = 0;

		for(int k = 0; k < 16; k++)
		{
			t4 = t2 & 0x1;
			t4 += a->coeffs[512 + 4*k + j];
			r |= t4;
			t4 = (t4^t1) & 0x1;
			t3 ^= t4 << k;

			t1 >>= 1;
			t2 >>= 1;
		}

		msg[64 + 2*j   ] = t3;
		msg[64 + 2*j + 1] = t3 >> 8;
	}

	r = r >> 1;
	r = (-(uint64_t)r) >> 63;

	return r;
}

/*************************************************
* Name:        poly_ntt
*
* Description: Computes number-theoretic transform (NTT)
*
* Arguments:   - poly *r: pointer to output polynomial
*              - poly *a: pointer to input polynomial
**************************************************/
void poly_ntt(poly *r, const poly *a)
{
	ntt(r->coeffs, a->coeffs);
}

/*************************************************
* Name:        poly_invntt
*
* Description: Computes inverse of number-theoretic transform (NTT)
*
* Arguments:   - poly *r: pointer to output polynomial
*              - poly *a: pointer to input polynomial
**************************************************/
void poly_invntt(poly *r, const poly *a)
{
	invntt(r->coeffs, a->coeffs);
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inversion of polynomial in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to input polynomial
* 
* Returns:     integer
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
	return poly_baseinv_neon(r, a);
}

/*************************************************
* Name:        poly_basemul
*
* Description: Multiplication of two polynomials in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to first input polynomial
*              - const poly *b: pointer to second input polynomial
**************************************************/
// void poly_basemul(poly *r, const poly *a, const poly *b)
// {
// 	for(int i = 0; i < NTRUPLUS_N/8; ++i)
// 	{
// 		basemul(r->coeffs + 8*i, a->coeffs + 8*i, b->coeffs + 8*i, zetas[72 + i]);
// 		basemul(r->coeffs + 8*i + 4, a->coeffs + 8*i + 4, b->coeffs + 8*i + 4, -zetas[72 + i]);
// 	}
// }
void poly_basemul(poly *r, const poly *a, const poly *b)
{
	// 8개씩(2블록) 처리하므로 루프 횟수 절반 감소
	for(int i = 0; i < NTRUPLUS_N; i += 8)
	{
		// zetas[72 + i/8] 값을 사용.
		// basemul_vec8 내부에서 두 번째 블록용 -zeta는 자동 생성함.
		basemul_vec8(r->coeffs + i, a->coeffs + i, b->coeffs + i, zetas[72 + i/8]);
	}
}

/*************************************************
* Name:        poly_basemul_add
*
* Description: Multiplication then addition of three polynomials in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to first input polynomial
*              - const poly *b: pointer to second input polynomial
*              - const poly *c: pointer to third input polynomial
**************************************************/
// void poly_basemul_add(poly *r, const poly *a, const poly *b, const poly *c)
// {
// 	for(int i = 0; i < NTRUPLUS_N/8; ++i)
// 	{
// 		basemul_add(r->coeffs + 8*i, a->coeffs + 8*i, b->coeffs + 8*i, c->coeffs + 8*i, zetas[72 + i]);
// 		basemul_add(r->coeffs + 8*i + 4, a->coeffs + 8*i + 4, b->coeffs + 8*i + 4, c->coeffs + 8*i + 4, -zetas[72 + i]);
// 	}
// }
void poly_basemul_add(poly *r, const poly *a, const poly *b, const poly *c)
{
	for(int i = 0; i < NTRUPLUS_N; i += 8)
	{
		basemul_add_vec8(r->coeffs + i, a->coeffs + i, b->coeffs + i, c->coeffs + i, zetas[72 + i/8]);
	}
}

/*************************************************
* Name:        poly_sub
*
* Description: Subtract two polynomials; no modular reduction is performed
*
* Arguments: - poly *r: pointer to output polynomial
*            - const poly *a: pointer to first input polynomial
*            - const poly *b: pointer to second input polynomial
**************************************************/
void poly_sub(poly *r, const poly *a, const poly *b)
{
	int i = 0;
	for(; i + 8 <= NTRUPLUS_N; i += 8)
	{
		int16x8_t va = vld1q_s16(a->coeffs + i);
		int16x8_t vb = vld1q_s16(b->coeffs + i);
		vst1q_s16(r->coeffs + i, vsubq_s16(va, vb));
	}
	for(; i < NTRUPLUS_N; ++i)
	{
		r->coeffs[i] = a->coeffs[i] - b->coeffs[i];
	}
}

/*************************************************
* Name:        poly_triple
*
* Description: Multiply polynomial by 3; no modular reduction is performed
*
* Arguments: - poly *r: pointer to output polynomial
*            - const poly *a: pointer to input polynomial
**************************************************/
void poly_triple(poly *r, const poly *a) 
{
	int i = 0;
	for(; i + 8 <= NTRUPLUS_N; i += 8)
	{
		int16x8_t va = vld1q_s16(a->coeffs + i);
		vst1q_s16(r->coeffs + i, vmulq_n_s16(va, 3));
	}
	for(; i < NTRUPLUS_N; ++i)
	{
		r->coeffs[i] = 3*a->coeffs[i];
	}
}

/*************************************************
* Name:        poly_crepmod3
*
* Description: Compute modulus 3 operation to polynomial
*
* Arguments: - poly *r: pointer to output polynomial
*            - const poly *a: pointer to input polynomial
**************************************************/
void poly_crepmod3(poly *r, const poly *a)
{
	int i = 0;
	for(; i + 8 <= NTRUPLUS_N; i += 8)
	{
		int16x8_t va = vld1q_s16(a->coeffs + i);
		vst1q_s16(r->coeffs + i, crepmod3_vec(va));
	}
	for(; i < NTRUPLUS_N; i++)
	{
		r->coeffs[i] = crepmod3(a->coeffs[i]);
	}
}
