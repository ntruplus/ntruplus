#include "params.h"
#include "ntt.h"

#define NTRUPLUS_QINV  0x74563281u // q^(-1) mod 2^32
#define NTRUPLUS_OMEGA 0xCA75BE64u
#define NTRUPLUS_Rinv  0xECF7EDA3u
#define NTRUPLUS_R     0x0012F51Eu
#define NTRUPLUS_Rsq   0xBFCBDDF0u

const uint32_t zetas[192] = {
	0x0012F51Eu, 0xCA88B381u, 0x8BA9CD80u, 0xECF7EDA3u, 0xACC3CB93u, 0x74563281u, 0xCD7F0013u, 0x6FD1CA89u,
	0xA252CA76u, 0xB380ECF8u, 0xBE63ACC4u, 0x0AE2BFCCu, 0x80FFED0Bu, 0x3C346DE5u, 0x08125D75u, 0xAD358A42u,
	0x2E35774Du, 0x34221071u, 0x5D745633u, 0x8A419C54u, 0x774C7F14u, 0x10708F5Eu, 0x6DE4E591u, 0x12F51D41u,
	0xC346DE4Fu, 0xF0012F52u, 0xF70A252Du, 0xC7F13082u, 0xE63ACC3Du, 0x45632810u, 0x42210709u, 0x1CA88B39u,
	0xD358A41Au, 0x7EDA28BBu, 0xAE2BFCBEu, 0x4E5902E4u, 0xC533C347u, 0x9CD7F002u, 0xDEF8F70Bu, 0x5774C7F2u,
	0xA75BE63Bu, 0x25D74564u, 0xD4034222u, 0xA6FD1CA9u, 0xF5DAD359u, 0x0ECF7EDBu, 0xFED0AE2Cu, 0x46DE4E5Au,
	0x23D76B4Eu, 0xE03B3DFCu, 0x3FFB42B9u, 0x0D1B793Au, 0x40B8D5DEu, 0x00D08842u, 0xD6F98EB4u, 0x75D158CBu,
	0x22CE03B4u, 0xBE3DC28Au, 0x4CF0D1B8u, 0x35FC004Cu, 0x47500D09u, 0xC69BF473u, 0x04975D16u, 0x4D629068u,
	0xF77BE3DDu, 0x8D5DD320u, 0xEA735FC1u, 0x98EB30F3u, 0x486C69C0u, 0xB42B8B00u, 0x76B4D62Au, 0xB3DFB68Bu,
	0xE3DC2895u, 0xD31FC4C3u, 0x5FC004BEu, 0x30F2E487u, 0x69BF472Bu, 0x8AFF2F78u, 0xD6290672u, 0xB68A2EA8u,
	0xD5DD31FDu, 0x8841C23Eu, 0x8EB30F2Fu, 0x58CA0400u, 0x42B8AFF3u, 0x7939640Cu, 0x3DFB68A3u, 0x94B29D70u,
	0x0D08841Du, 0xF472A22Du, 0x5D158CA1u, 0x906714D0u, 0xD1B79397u, 0x004BD476u, 0xC2894B2Au, 0xFC4C204Au,
	0x01A11084u, 0x7E8E5446u, 0xEBA2B195u, 0x520CE29Au, 0x1A36F273u, 0x80097A8Fu, 0xB8512966u, 0x3F89840Au,
	0x5A6B1484u, 0xEFDB4518u, 0x15C57F98u, 0xC9CB205Du, 0xAEE98FE3u, 0x420E11ECu, 0x75987973u, 0xC6501FFEu,
	0x4BAE8AC7u, 0xB148338Bu, 0x4DFA3952u, 0x57F97BBEu, 0x1EE144A6u, 0x98FE2611u, 0xFE0025EBu, 0x87972437u,
	0x685715FFu, 0x6F272C82u, 0x67BF6D15u, 0x129653AEu, 0x31D661E6u, 0x2B194080u, 0x11083848u, 0xE54459C1u,
	0x8D37E8E6u, 0x715FE5EFu, 0x9AC520CFu, 0xF6D145D5u, 0x6BF80098u, 0x661E5C91u, 0xBA63F899u, 0x83847AEEu,
	0x1D9EFDB5u, 0x144A594Fu, 0x8DBC9CB3u, 0x025EA3A9u, 0x684420E2u, 0xA3951168u, 0xE8AC6502u, 0x8338A679u,
	0xC8171ABCu, 0xA01A1109u, 0x3ADF31D7u, 0x2EBA2B1Au, 0x07FF6858u, 0xE1A36F28u, 0x9C0767C0u, 0x7B851297u,
	0x61024BAFu, 0xB5A6B149u, 0x43634DFBu, 0xA15C57FAu, 0xBBDF1EE2u, 0x6AEE98FFu, 0x539AFE01u, 0xC7598798u,
	0x94EB7CC8u, 0x24BAE8ADu, 0x3A806845u, 0x34DFA396u, 0x16701D9Fu, 0xF1EE144Bu, 0x67868DBDu, 0xAFE0025Fu,
	0xC90D8D38u, 0xF6857160u, 0xAED69AC6u, 0x767BF6D2u, 0x5D4E6BF9u, 0xF31D661Fu, 0x71ABBA64u, 0xA1108385u,
	0xA8EA01A2u, 0xD8D37E8Fu, 0x4092EBA3u, 0x69AC520Du, 0x299E1A37u, 0xE6BF800Au, 0xF7C7B852u, 0xBBA63F8Au,
	0x1EBB5A6Cu, 0x01D9EFDCu, 0xFFDA15C6u, 0x68DBC9CCu, 0x05C6AEEAu, 0x0684420Fu, 0xB7CC7599u, 0xAE8AC651u,
};
/*************************************************
* Name:        plantard_reduce
*
* Description: Plantard reduction; given a 32-bit integer a, computes
*              a 16-bit integer congruent to a * R^-1 mod q,
*              where R = -2^32.
*
* Arguments:   - int32_t a: input integer to be reduced;
*                           must lie in {-q^2*64, ..., q^2*64}
*
* Returns:     an integer in {-(q+1)/2, ..., (q-1)/2} congruent to
*              a * R^-1 mod q.
**************************************************/
static inline int16_t plantard_reduce(int32_t a)
{
	a = ((int32_t)(a*NTRUPLUS_QINV)) >> 16;
	a=((a+8)*NTRUPLUS_Q) >> 16;
	return a;
}

/*************************************************
* Name:        plantard_reduce_acc
*
* Description: Plantard reduction for accumulated values; given a
*              32-bit integer a = x*qinv that is already multiplied by
*              qinv, computes a 16-bit integer congruent to x * R^-1
*              mod q, where R = -2^32. The value x must lie in the
*              range {-q^2*64, ..., q^2*64}.
*
* Arguments:   - int32_t a: value x*qinv to be reduced
*
* Returns:     an integer in {-(q+1)/2, ..., (q-1)/2} congruent to
*              x * R^-1 mod q.
**************************************************/
static inline int16_t plantard_reduce_acc(int32_t a)
{
	a = a >> 16;
	a = ((a+8)*NTRUPLUS_Q) >> 16;
	return a;
}

/*************************************************
* Name:        plantard_mul
*
* Description: Plantard multiplication; given 32-bit integers a and b,
*              where one operand is of the form x*qinv (precomputed)
*              and the other is y, computes a 16-bit integer congruent
*              to x * y * R^-1 mod q, where R = -2^32. The product x*y
*              must lie in the range {-q^2*64, ..., q^2*64}.
*
* Arguments:   - uint32_t a: first operand (x*qinv or y)
*              - uint32_t b: second operand (y or x*qinv)
*
* Returns:     an integer in {-(q+1)/2, ..., (q-1)/2} congruent to
*              x * y * R^-1 mod q.
**************************************************/
static inline int16_t plantard_mul(uint32_t a, uint32_t b)
{
	int32_t t = (int32_t)((uint32_t)a*b) >> 16;
	t = ((t+8)*NTRUPLUS_Q) >> 16;
	return t;
}

/*************************************************
* Name:        fqinv
*
* Description: Computes the multiplicative inverse of a value in the
*              finite field Z_q, using the Plantard reduction method.
*
*              The input is an ordinary field element x (no scaling),
*              and the function returns x^{-1} scaled by R^2 modulo q,
*              where R = -2^32 is the Plantard radix.
*
* Arguments:   - int16_t a: input value a = x mod q
*
* Returns:     16-bit integer congruent to x^{-1} * R^2 mod q.
**************************************************/
static inline int16_t fqinv(int16_t a)
{
    int16_t t1, t2, t3;
    uint32_t A, T1;

    A  = a*NTRUPLUS_QINV;
    t1 = plantard_reduce_acc(a*A);   // 10

    T1 = t1*NTRUPLUS_QINV;
    t2 = plantard_reduce_acc(t1*T1); // 100
    t2 = plantard_reduce(t2*t2);     // 1000
    t3 = plantard_reduce(t2*t2);     // 10000
    t1 = plantard_reduce_acc(t2*T1); // 1010

    T1 = t1*NTRUPLUS_QINV;
    t2 = plantard_reduce_acc(t3*T1); // 11010
    t2 = plantard_reduce(t2*t2);     // 110100
    t2 = plantard_reduce_acc(t2*A);  // 110101

    t1 = plantard_reduce_acc(t2*T1); // 111111

    t2 = plantard_reduce(t2*t2);     // 1101010
    t2 = plantard_reduce(t2*t2);     // 11010100
    t2 = plantard_reduce(t2*t2);     // 110101000
    t2 = plantard_reduce(t2*t2);     // 1101010000
    t2 = plantard_reduce(t2*t2);     // 11010100000
    t2 = plantard_reduce(t2*t2);     // 110101000000
    t2 = plantard_reduce(t2*t1);     // 110101111111

    return t2;
}

/*************************************************
* Name:        ntt
*
* Description: Number-theoretic transform (NTT) in R_q. Transforms the
*              coefficient representation of a into a representation
*              where each block of 4 coefficients corresponds to an
*              element of Zq[X]/(X^4 - zeta_i).
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to output vector; NTT
*                                       representation of a in the
*                                       product ring Zq[X]/(X^4 - zeta_i)
*              - const int16_t a[NTRUPLUS_N]: pointer to input vector of
*                                            coefficients of a in R_q
*
* Returns:     none.
**************************************************/
void ntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
	int16_t t1, t2, t3;
	uint32_t zeta1, zeta2;
	int k = 1;

	zeta1 = zetas[k++];

	for (int i = 0; i < NTRUPLUS_N / 2; i++)
	{
		t1 = plantard_mul(zeta1, a[i + NTRUPLUS_N / 2]);

		r[i + NTRUPLUS_N / 2] = a[i] + a[i + NTRUPLUS_N / 2] - t1;
		r[i                 ] = a[i]                         + t1;
	}

	for (int start = 0; start < NTRUPLUS_N; start += 384)
	{
		zeta1 = zetas[k++];
		zeta2 = zetas[k++];

		for (int i = start; i < start + 128; i++)
		{
			t1 = plantard_mul(zeta1, r[i + 128]);
			t2 = plantard_mul(zeta2, r[i + 256]);
			t3 = plantard_mul(NTRUPLUS_OMEGA, t1 - t2);

			r[i + 256] = r[i] - t1 - t3;
			r[i + 128] = r[i] - t2 + t3;
			r[i      ] = r[i] + t1 + t2;
		}		
	}

	for (int step = 64; step >= 8; step >>= 1)
	{
		for (int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k++];

			for (int i = start; i < start + step; i++)
			{
				t1 = plantard_mul(zeta1, r[i + step]);

				r[i + step] = r[i] - t1;
				r[i       ] = r[i] + t1;
			}
		}
	}

	for (int start = 0; start < NTRUPLUS_N; start += 8)
	{
		zeta1 = zetas[k++];

		for (int i = start; i < start + 4; i++)
		{
			uint32_t T1 = zeta1 * r[i + 4];
			uint32_t T2 = r[i] * NTRUPLUS_R;
			
			r[i + 4] = plantard_reduce_acc(T2 - T1);
			r[i    ] = plantard_reduce_acc(T2 + T1);
		}
	}	
}

/*************************************************
* Name:        invntt
*
* Description: Inverse number-theoretic transform (NTT) in R_q. Transforms
*              the NTT representation of a, where each block of 4
*              coefficients corresponds to an element of Zq[X]/(X^4 - zeta_i),
*              back to the coefficient representation in R_q.
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to output vector; coefficient
*                                       representation of a in R_q
*              - const int16_t a[NTRUPLUS_N]: pointer to input vector in NTT
*                                            representation in the product
*                                            ring Zq[X]/(X^4 - zeta_i)
*
* Returns:     none.
**************************************************/
void invntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
	int16_t  t1, t2, t3;
	uint32_t zeta1, zeta2;
	int k = 191;

	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		r[i] = a[i];
	}

	for (int step = 4; step <= 32; step <<= 1)
	{
		for (int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k--];

			for (int i = start; i < start + step; i++)
			{
				t1 = r[i + step];

				r[i + step] = plantard_mul(zeta1, t1 - r[i]);
				r[i       ] = r[i] + t1;
			}
		}
	}

	for (int start = 0; start < NTRUPLUS_N; start += 128)
	{
		zeta1 = zetas[k--];

		for (int i = start; i < start + 64; i++)
		{
			t1 = r[i + 64];

			r[i + 64] = plantard_mul(zeta1, t1 - r[i]);
			r[i     ] = plantard_mul(NTRUPLUS_R, r[i] + t1);
		}
	}

	for (int start = 0; start < NTRUPLUS_N; start += 384)
	{
		zeta2 = zetas[k--];
		zeta1 = zetas[k--];

		for (int i = start; i < start + 128; i++)
		{
			t1 = plantard_mul(NTRUPLUS_OMEGA,  r[i + 128] - r[i]);
			t2 = plantard_mul(zeta1, r[i + 256] - r[i]       + t1);
			t3 = plantard_mul(zeta2, r[i + 256] - r[i + 128] - t1);
			
			r[i      ] = r[i] + r[i + 128] + r[i + 256];
			r[i + 128] = t2;			
			r[i + 256] = t3;
		}
	}

	for (int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = r[i] + r[i + NTRUPLUS_N/2];
		t2 = plantard_mul(0x790084B4u, r[i] - r[i + NTRUPLUS_N/2]);

		r[i               ] = plantard_mul(0xFEAAC3F2u, t1 - t2);
		r[i + NTRUPLUS_N/2] = plantard_mul(0xFD5587E3u, t2);	
	}
}

/*************************************************
* Name:        baseinv
*
* Description: Simultaneous inversion of polynomials in
*              Z_q[X]/(X^4 - zeta) and Z_q[X]/(X^4 + zeta), used as
*              a building block for inversion of elements in R_q in the
*              NTT domain. The input array a encodes two degree-3
*              polynomials:
*                a[0..3] for X^4 - zeta,
*                a[4..7] for X^4 + zeta.
*              On success, r[0..3] and r[4..7] contain their inverses.
*
* Arguments:   - int16_t r[8]:       pointer to the output polynomials
*              - const int16_t a[8]: pointer to the input polynomials
*              - uint32_t zeta:      parameter defining X^4 ± zeta
*
* Returns:     0 if both polynomials are invertible, 1 otherwise.
**************************************************/
int baseinv_1(int16_t r[8], int16_t den[2], const int16_t a[8], uint32_t zeta)
{
	int16_t t0, t1, t2, t3;
	int16_t s0, s1, s2, s3;
	uint32_t A0, A1, A2, A3;
	uint32_t B0, B1, B2, B3;
	uint32_t zeta1, zeta2;

	zeta1 = zeta;
	zeta2 = -zeta;

	A0 = a[0]*NTRUPLUS_QINV;
	A1 = a[1]*NTRUPLUS_QINV;
	A2 = a[2]*NTRUPLUS_QINV;
	A3 = a[3]*NTRUPLUS_QINV;
	B0 = a[4]*NTRUPLUS_QINV;
	B1 = a[5]*NTRUPLUS_QINV;
	B2 = a[6]*NTRUPLUS_QINV;
	B3 = a[7]*NTRUPLUS_QINV;

	t0 = plantard_reduce_acc(a[2]*A2 - 2*a[1]*A3);
	s0 = plantard_reduce_acc(a[6]*B2 - 2*a[5]*B3);
	t1 = plantard_reduce_acc(a[3]*A3);
	s1 = plantard_reduce_acc(a[7]*B3);
	t0 = plantard_reduce_acc(a[0]*A0 + t0*zeta1);
	s0 = plantard_reduce_acc(a[4]*B0 + s0*zeta2);
	t1 = plantard_reduce_acc(a[1]*A1 + t1*zeta1 - 2*a[0]*A2);
	s1 = plantard_reduce_acc(a[5]*B1 + s1*zeta2 - 2*a[4]*B2);
	t2 = plantard_reduce_acc(t1*zeta1);
	s2 = plantard_reduce_acc(s1*zeta2);
	
	t3 = plantard_reduce(t0*t0 - t1*t2);
	s3 = plantard_reduce(s0*s0 - s1*s2);
	
	if(!(t3 && s3)) return 1;

	r[0] = plantard_reduce_acc(A0*t0 + A2*t2);
	r[1] = plantard_reduce_acc(A3*t2 + A1*t0);
	r[2] = plantard_reduce_acc(A2*t0 + A0*t1);
	r[3] = plantard_reduce_acc(A1*t1 + A3*t0);
	r[4] = plantard_reduce_acc(B0*s0 + B2*s2);
	r[5] = plantard_reduce_acc(B3*s2 + B1*s0);
	r[6] = plantard_reduce_acc(B2*s0 + B0*s1);
	r[7] = plantard_reduce_acc(B1*s1 + B3*s0);

	den[0] = t3; // R^-3
	den[1] = s3; // R^-3

	return 0;
}

void fqinv_batch(int16_t *r)
{
    int16_t  t[NTRUPLUS_N / 4];
    uint32_t R[NTRUPLUS_N / 4];

	int16_t inv;
	uint32_t INV;

    t[0] = r[0];

	for (int i = 1; i < NTRUPLUS_N / 4; i++)
	{
        R[i] = (uint32_t)r[i] * NTRUPLUS_QINV;
		t[i] = plantard_mul(t[i - 1], R[i]);
    }

    inv  = fqinv(t[NTRUPLUS_N / 4 - 1]);
	inv = plantard_mul(NTRUPLUS_Rinv, inv);

    for (int i = NTRUPLUS_N / 4 - 1; i > 0; i--)
	{
	    INV = (uint32_t)inv * NTRUPLUS_QINV;
		r[i] = plantard_mul(t[i - 1], INV); // R^5
        inv = plantard_mul(inv, R[i]);
    }

    r[0] = inv;
}

int baseinv_2(int16_t r[8], int16_t den[2])
{
	uint32_t T, S;

	T = den[0]*NTRUPLUS_QINV;
	S = den[1]*NTRUPLUS_QINV;

	r[0] =  plantard_reduce_acc(r[0]*T);
	r[1] = -plantard_reduce_acc(r[1]*T);
	r[2] =  plantard_reduce_acc(r[2]*T);
	r[3] = -plantard_reduce_acc(r[3]*T);
	r[4] =  plantard_reduce_acc(r[4]*S);
	r[5] = -plantard_reduce_acc(r[5]*S);
	r[6] =  plantard_reduce_acc(r[6]*S);
	r[7] = -plantard_reduce_acc(r[7]*S);

	return 0;
}

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
void basemul(int16_t r[4], const int16_t a[4], const int16_t b[4], uint32_t zeta)
{
	uint32_t A0, A1, A2, A3;

	A0 = a[0]*NTRUPLUS_QINV;
	A1 = a[1]*NTRUPLUS_QINV;
	A2 = a[2]*NTRUPLUS_QINV;
	A3 = a[3]*NTRUPLUS_QINV;

	r[0] = plantard_reduce_acc(A1*b[3]+A2*b[2]+A3*b[1]);
	r[1] = plantard_reduce_acc(A2*b[3]+A3*b[2]);
	r[2] = plantard_reduce_acc(A3*b[3]);

	r[0] = plantard_reduce_acc(r[0]*zeta+A0*b[0]);
	r[1] = plantard_reduce_acc(r[1]*zeta+A0*b[1]+A1*b[0]);
	r[2] = plantard_reduce_acc(r[2]*zeta+A0*b[2]+A1*b[1]+A2*b[0]);
	r[3] = plantard_reduce_acc(A0*b[3]+A1*b[2]+A2*b[1]+A3*b[0]);

	r[0] = plantard_mul(NTRUPLUS_Rsq, r[0]);
	r[1] = plantard_mul(NTRUPLUS_Rsq, r[1]);
	r[2] = plantard_mul(NTRUPLUS_Rsq, r[2]);
	r[3] = plantard_mul(NTRUPLUS_Rsq, r[3]);
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
void basemul_add(int16_t r[4], const int16_t a[4], const int16_t b[4], const int16_t c[4], uint32_t zeta)
{
	uint32_t A0, A1, A2, A3;

	A0 = a[0]*NTRUPLUS_QINV;
	A1 = a[1]*NTRUPLUS_QINV;
	A2 = a[2]*NTRUPLUS_QINV;
	A3 = a[3]*NTRUPLUS_QINV;

	r[0] = plantard_reduce_acc(A1*b[3]+A2*b[2]+A3*b[1]);
	r[1] = plantard_reduce_acc(A2*b[3]+A3*b[2]);
	r[2] = plantard_reduce_acc(A3*b[3]);

	r[0] = plantard_reduce_acc(r[0]*zeta+A0*b[0]);
	r[1] = plantard_reduce_acc(r[1]*zeta+A0*b[1]+A1*b[0]);
	r[2] = plantard_reduce_acc(r[2]*zeta+A0*b[2]+A1*b[1]+A2*b[0]);
	r[3] = plantard_reduce_acc(A0*b[3]+A1*b[2]+A2*b[1]+A3*b[0]);

	r[0] = plantard_reduce_acc(c[0]*NTRUPLUS_R + r[0]*NTRUPLUS_Rsq);
	r[1] = plantard_reduce_acc(c[1]*NTRUPLUS_R + r[1]*NTRUPLUS_Rsq);
	r[2] = plantard_reduce_acc(c[2]*NTRUPLUS_R + r[2]*NTRUPLUS_Rsq);
	r[3] = plantard_reduce_acc(c[3]*NTRUPLUS_R + r[3]*NTRUPLUS_Rsq);
}
