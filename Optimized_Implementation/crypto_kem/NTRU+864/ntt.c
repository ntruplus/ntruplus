#include "params.h"
#include "ntt.h"

#define NTRUPLUS_QINV  0x74563281u // q^(-1) mod 2^32
#define NTRUPLUS_OMEGA 0xCA75BE64u
#define NTRUPLUS_Rinv  0xECF7EDA3u
#define NTRUPLUS_R     0x0012F51Eu
#define NTRUPLUS_Rsq   0xBFCBDDF0u

const uint32_t zetas[288] = {
    0x0012F51Du, 0xCA88B381u, 0x8F70A253u, 0x533C346Eu, 0x40342210u, 0x708F5DAEu, 0x2152DD6Bu, 0x93A935D7u,
    0x4FD4292Cu, 0x276560CAu, 0x7F84C6C2u, 0xC320F414u, 0x435058DDu, 0x044B88A1u, 0x8CC62A36u, 0x5B87713Au,
    0x1611540Du, 0xB02BD6D4u, 0x0BA052F0u, 0x35D61611u, 0x2A35C321u, 0xF8138CC6u, 0x58DCF91Du, 0x60C96C57u,
    0x0BEC2765u, 0x5FF8E415u, 0x540CBCB0u, 0x8EC6044Cu, 0x5587E2F9u, 0xC6C1DEADu, 0x48467F85u, 0x292C5B87u,
    0xE0E5DC03u, 0xDD6ADBA4u, 0x88A08BD0u, 0xAB35B02Cu, 0xE5DC02AAu, 0xB4775F74u, 0xAD229524u, 0xD3A4788Fu,
    0xB9807B39u, 0x0754CA50u, 0xCFB7B980u, 0x781D0755u, 0x39FBB477u, 0x5C1F1A24u, 0x2BD6D3A4u, 0x3E2152DDu,
    0x35B02BD7u, 0x7B393E21u, 0x02AA781Du, 0x5F743048u, 0x95245C1Fu, 0x788EC604u, 0x0CBCAFA7u, 0x39D5CA3Du,
    0x56CA29EAu, 0x071BEAF8u, 0x13D89A9Fu, 0xE30BA053u, 0x20F413D9u, 0x2306E30Cu, 0xEC7339D6u, 0xEEABF343u,
    0x0FA0071Cu, 0x3693A936u, 0x5FAD0FA0u, 0x9A9F3694u, 0xAFA72307u, 0xCA3CDF0Cu, 0x29E9EEACu, 0xEAF8138Du,
    0x05FF8E41u, 0x96C56CA3u, 0x5CA3CDF1u, 0x35058DD0u, 0x89A9F369u, 0xBA052F06u, 0x1540CBCBu, 0xC7339D5Du,
    0xCF91CF46u, 0x0F413D8Au, 0xBEAF8139u, 0x5D616115u, 0x72306E31u, 0xCDF0BEC2u, 0x8E41507Fu, 0x6CA29E9Fu,
    0x62A35C32u, 0xCBCAFA72u, 0xF3693A93u, 0x2F05FF8Eu, 0x9EEABF34u, 0x8138CC63u, 0xCF45FAD1u, 0x3D89A9F3u,
    0x61611541u, 0x507EC734u, 0x6E30BA05u, 0xBEC27656u, 0x0071BEB0u, 0x3A935D61u, 0x5C320F41u, 0xFA72306Eu,
    0x560C96C5u, 0xFAD0FA00u, 0xBF343506u, 0xCC62A35Cu, 0xADBA3E0Eu, 0x77139FBBu, 0xD0754CA5u, 0x8467F84Cu,
    0x6D3A4789u, 0x152DD6AEu, 0x08BCFB7Cu, 0x2AA781D0u, 0x4C6C1DEBu, 0x5B02BD6Du, 0xF1A23FD5u, 0x44B88A09u,
    0x07B393E2u, 0x4CA4FD43u, 0x3E0E5DC0u, 0x9FBB4776u, 0x7E2F8AB3u, 0xFB7B9808u, 0x4788EC60u, 0xD6ADBA3Eu,
    0x75F74305u, 0x3FD5587Eu, 0x1DEAD229u, 0xBD6D3A48u, 0xB88A08BDu, 0x5DC02AA8u, 0x93E2152Eu, 0xFD4292C6u,
    0x45C1F1A2u, 0xEC6044B9u, 0x8AB35B03u, 0x9807B394u, 0xC5B87714u, 0xD2295246u, 0x43048468u, 0x587E2F8Bu,
    0x00AA9E07u, 0xD7DD0C12u, 0x0A4B16E2u, 0x77AB48A5u, 0xE2ACD6C1u, 0xE601ECE5u, 0x3B18112Eu, 0x6E8F8397u,
    0xE4F8854Bu, 0x3F50A4B1u, 0x97700AAAu, 0xD1DD7DD1u, 0xA5491708u, 0x1E23B181u, 0xF8BE2ACDu, 0xEDEE601Fu,
    0x8112E228u, 0xF8397701u, 0x1ECE4F88u, 0x3293F50Au, 0xD0C1211Au, 0x561F8BE3u, 0xB48A5491u, 0x4E91E23Bu,
    0x8F839770u, 0xE7EED1DDu, 0x53293F51u, 0xFE131B07u, 0x5561F8BEu, 0x22F3EDEEu, 0xB4E91E24u, 0x54B75AB7u,
    0xEE601ECEu, 0x41D53294u, 0xB6E8F839u, 0xDC4E7EEDu, 0x077AB48Au, 0xAF5B4E92u, 0x8FF55620u, 0x22822F3Fu,
    0x91E23B18u, 0x75AB6E90u, 0x3EDEE602u, 0xE0741D53u, 0xED1DD7DDu, 0xC688FF55u, 0x31B077ABu, 0x6C0AF5B5u,
	0xB75AB6E9u, 0x16E1DC4Eu, 0x9E0741D5u, 0x0C1211A0u, 0x7C688FF5u, 0x112E2282u, 0xD6C0AF5Bu, 0xECE4F885u,
    0x822F3EDFu, 0x0AA9E074u, 0x854B75ABu, 0xA4B16E1Eu, 0x9FE131B0u, 0x2ACD6C0Bu, 0x1707C689u, 0xB18112E2u,
    0x0AF5B4E9u, 0x4F8854B7u, 0xE22822F4u, 0x7700AA9Eu, 0x1DC4E7EFu, 0x5491707Cu, 0x2119FE13u, 0x8BE2ACD7u,
    0x14BC17FEu, 0x58325B16u, 0xCE75728Fu, 0xFCD0D416u, 0x6FABE04Eu, 0xD7585845u, 0x83D04F62u, 0x8C1B8C2Fu,
    0x455032F3u, 0xB1CCE757u, 0x2E814BC1u, 0x9D958326u, 0x16373E47u, 0x70C83D05u, 0x01C6FABEu, 0xEA4D7586u,
    0x04F626A8u, 0xB8C2E815u, 0x85845503u, 0x41FB1CCEu, 0x25B15B29u, 0x3E801C70u, 0x0D416374u, 0xA8D70C84u,
    0x1B8C2E81u, 0x2FB09D96u, 0x541FB1CDu, 0xA7A7BAB0u, 0x43E801C7u, 0xCDA4EA4Du, 0x8A8D70C8u, 0x2F2BE9C9u,
    0x4D758584u, 0x390541FBu, 0xC8C1B8C3u, 0x37C2FB0Au, 0xAFCD0D41u, 0x3318A8D7u, 0x7EB43E80u, 0x6A7CDA4Fu,
    0xD70C83D0u, 0xBE9C8C1Cu, 0x4EA4D758u, 0x7FE39054u, 0x09D95832u, 0x3D17EB44u, 0x7BAAFCD1u, 0x04E3318Bu,
    0x2BE9C8C2u, 0x728F37C3u, 0x17FE3905u, 0x5B15B28Au, 0x73D17EB4u, 0x4F626A7Du, 0xE04E3319u, 0x58455033u,
    0x7CDA4EA5u, 0x4BC17FE4u, 0x32F2BE9Du, 0xE75728F3u, 0x8A7A7BABu, 0xFABE04E3u, 0x3E473D18u, 0x3D04F627u,
    0xE3318A8Du, 0x55032F2Cu, 0x26A7CDA5u, 0xE814BC18u, 0xF37C2FB1u, 0x6373E474u, 0x5B28A7A8u, 0x1C6FABE0u
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
	int16_t t1,t2,t3;
	uint32_t T1,T2;
	uint32_t zeta[5];
	int16_t v[8];

	int index = 1;

	zeta[0] = zetas[index++];

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = plantard_mul(zeta[0], a[i + NTRUPLUS_N/2]);

		r[i + NTRUPLUS_N/2] = a[i] + a[i + NTRUPLUS_N/2] - t1;
		r[i               ] = a[i]                       + t1;
	}

	for(int start = 0; start < NTRUPLUS_N; start += 432)
	{
		zeta[0] = zetas[index++];
		zeta[1] = zetas[index++];

		for(int i = start; i < start + 144; i++)
		{
			t1 = plantard_mul(zeta[0], r[i + 144]);
			t2 = plantard_mul(zeta[1], r[i + 288]);
			t3 = plantard_mul(NTRUPLUS_OMEGA, t1 - t2);

			r[i + 288] = r[i] - t1 - t3;
			r[i + 144] = r[i] - t2 + t3;
			r[i      ] = r[i] + t1 + t2;
		}		
	}

	for (int i = 0; i < 6; i++)
	{
		zeta[0] = zetas[6+2*i];
		zeta[1] = zetas[7+2*i];
		zeta[2] = zetas[18+3*i];
		zeta[3] = zetas[19+3*i];
		zeta[4] = zetas[20+3*i];

		for (int j = 0; j < 24; j++)
		{
			for (int k = 0; k < 6; k++)
			{
				v[k] = r[24*k+j+144*i];
			}

			t1 = plantard_mul(zeta[0], v[2]);
			t2 = plantard_mul(zeta[1], v[4]);
			t3 = plantard_mul(NTRUPLUS_OMEGA, t1 - t2);

			v[4] = v[0] - t1 - t3;
			v[2] = v[0] - t2 + t3;
			v[0] = v[0] + t1 + t2;

			t1 = plantard_mul(zeta[0], v[3]);
			t2 = plantard_mul(zeta[1], v[5]);
			t3 = plantard_mul(NTRUPLUS_OMEGA, t1 - t2);

			v[5] = v[1] - t1 - t3;
			v[3] = v[1] - t2 + t3;
			v[1] = v[1] + t1 + t2;			

			t1 = plantard_mul(zeta[2], v[1]);
			v[1] = v[0] - t1;
			v[0] = v[0] + t1;

			t1 = plantard_mul(zeta[3], v[3]);
			v[3] = v[2] - t1;
			v[2] = v[2] + t1;

			t1 = plantard_mul(zeta[4], v[5]);
			v[5] = v[4] - t1;
			v[4] = v[4] + t1;

			for (int k = 0; k < 6; k++)
			{
				r[24*k+j+144*i] = v[k];
			}
		}
	}

	for (int i = 0; i < 36; i++)
	{
		zeta[0] = zetas[36+i];
		zeta[1] = zetas[72+2*i];
		zeta[2] = zetas[73+2*i];

		for (int j = 0; j < 3; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = r[3*k+j+24*i];
			}

			t1 = plantard_mul(zeta[0], v[4]);
			v[4] = v[0] - t1;
			v[0] = v[0] + t1;

			t1 = plantard_mul(zeta[0], v[5]);
			v[5] = v[1] - t1;
			v[1] = v[1] + t1;

			t1 = plantard_mul(zeta[0], v[6]);
			v[6] = v[2] - t1;
			v[2] = v[2] + t1;

			t1 = plantard_mul(zeta[0], v[7]);
			v[7] = v[3] - t1;
			v[3] = v[3] + t1;

			t1 = plantard_mul(zeta[1], v[2]);
			v[2] = v[0] - t1;
			v[0] = v[0] + t1;

			t1 = plantard_mul(zeta[1], v[3]);
			v[3] = v[1] - t1;
			v[1] = v[1] + t1;

			t1 = plantard_mul(zeta[2], v[6]);
			v[6] = v[4] - t1;
			v[4] = v[4] + t1;

			t1 = plantard_mul(zeta[2], v[7]);
			v[7] = v[5] - t1;
			v[5] = v[5] + t1;

			for (int k = 0; k < 8; k++)
			{
				r[3*k+j+24*i] = v[k];
			}
		}
	}

	index = 144;

	for(int start = 0; start < NTRUPLUS_N; start += 6)
	{
		zeta[0] = zetas[index++];

		for(int i = start; i < start + 3; i++)
		{
			T1 = r[i]*zetas[0];
			T2 = zeta[0]*r[i + 3];

			r[i + 3] = plantard_reduce_acc(T1 - T2);
			r[i    ] = plantard_reduce_acc(T1 + T2);
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
	int16_t t1,t2,t3;
	uint32_t zeta[7];
	int16_t v[8];

	for (int i = 0; i < 36; i++)
	{
		zeta[0] = zetas[287-4*i];
		zeta[1] = zetas[286-4*i];
		zeta[2] = zetas[285-4*i];
		zeta[3] = zetas[284-4*i];
		zeta[4] = zetas[143-2*i];
		zeta[5] = zetas[142-2*i];
		zeta[6] = zetas[71-i];

		for (int j = 0; j < 3; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = a[3*k+j+24*i];
			}

			t1 = v[1];

			v[1] = plantard_mul(zeta[0],  t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];

			v[3] = plantard_mul(zeta[1],  t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[5];

			v[5] = plantard_mul(zeta[2],  t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = v[7];

			v[7] = plantard_mul(zeta[3],  t1 - v[6]);
			v[6] = v[6] + t1;


			t1 = v[2];

			v[2] = plantard_mul(zeta[4],  t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];

			v[3] = plantard_mul(zeta[4],  t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];

			v[6] = plantard_mul(zeta[5],  t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = v[7];

			v[7] = plantard_mul(zeta[5],  t1 - v[5]);
			v[5] = v[5] + t1;


			t1 = v[4];

			v[4] = plantard_mul(zeta[6],  t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[5];

			v[5] = plantard_mul(zeta[6],  t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];

			v[6] = plantard_mul(zeta[6],  t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[7];

			v[7] = plantard_mul(zeta[6],  t1 - v[3]);
			v[3] = v[3] + t1;			
				
			for (int k = 0; k < 8; k++)
			{
				r[3*k+j+24*i] = v[k];
			}
		}
	}

	for (int i = 0; i < 6; i++)
	{
		zeta[0] = zetas[35-3*i];
		zeta[1] = zetas[34-3*i];
		zeta[2] = zetas[33-3*i];
		zeta[3] = zetas[16-2*i];
		zeta[4] = zetas[17-2*i];

		for (int j = 0; j < 24; j++)
		{
			for (int k = 0; k < 6; k++)
			{
				v[k] = r[24*k+j+144*i];
			}

			t1 = v[1];

			v[1] = plantard_mul(zeta[0],  t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];

			v[3] = plantard_mul(zeta[1],  t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[5];

			v[5] = plantard_mul(zeta[2],  t1 - v[4]);
			v[4] = v[4] + t1;			

			t1 = plantard_mul(NTRUPLUS_OMEGA,    v[2] - v[0]);
			t2 = plantard_mul(zeta[3], v[4] - v[0] + t1);
			t3 = plantard_mul(zeta[4], v[4] - v[2] - t1);

			v[0] = plantard_mul(v[0] + v[2] + v[4], zetas[0]);
			v[2] = t2;
			v[4] = t3;

			t1 = plantard_mul(NTRUPLUS_OMEGA,    v[3] - v[1]);
			t2 = plantard_mul(zeta[3], v[5] - v[1] + t1);
			t3 = plantard_mul(zeta[4], v[5] - v[3] - t1);

			v[1] = plantard_mul(v[1] + v[3] + v[5], zetas[0]);
			v[3] = t2;
			v[5] = t3;

			for (int k = 0; k < 6; k++)
			{
				r[24*k+j+144*i] = v[k];
			}
		}
	}

	zeta[0] = zetas[4];
	zeta[1] = zetas[5];
	zeta[2] = zetas[2];
	zeta[3] = zetas[3];

	for (int i = 0; i < 144; i++)
	{
		for (int j = 0; j < 6; j++)
		{
			v[j] = a[144*j+i];
		}

		t1 = plantard_mul(NTRUPLUS_OMEGA,    v[1] - v[0]);
		t2 = plantard_mul(zeta[0], v[2] - v[0] + t1);
		t3 = plantard_mul(zeta[1], v[2] - v[1] - t1);

		v[0] = v[0] + v[1] + v[2];
		v[1] = t2;
		v[2] = t3;

		t1 = plantard_mul(NTRUPLUS_OMEGA,    v[4] - v[3]);
		t2 = plantard_mul(zeta[2], v[5] - v[3] + t1);
		t3 = plantard_mul(zeta[3], v[5] - v[4] - t1);

		v[3] = v[3] + v[4] + v[5];
		v[4] = t2;
		v[5] = t3;

		t1 = v[0] + v[3];
		t2 = plantard_mul(2030077108, v[0] - v[3]);

		v[0] = plantard_mul(4280058529, t1 - t2);
		v[3] = plantard_mul(4265149762, t2);

		t1 = v[1] + v[4];
		t2 = plantard_mul(2030077108, v[1] - v[4]);

		v[1] = plantard_mul(4280058529, t1 - t2);
		v[4] = plantard_mul(4265149762, t2);

		t1 = v[2] + v[5];
		t2 = plantard_mul(2030077108, v[2] - v[5]);

		v[2] = plantard_mul(4280058529, t1 - t2);
		v[5] = plantard_mul(4265149762, t2);				

		for (int j = 0; j < 6; j++)
		{
			r[144*j+i] = v[j];
		}
	}
}

/*************************************************
* Name:        baseinv
*
* Description: Simultaneous inversion of polynomials in
*              Z_q[X]/(X^3 - zeta) and Z_q[X]/(X^3 + zeta), used as
*              a building block for inversion of elements in R_q in the
*              NTT domain. The input array a encodes two degree-2
*              polynomials:
*                a[0..2] for X^3 - zeta,
*                a[3..5] for X^3 + zeta.
*              On success, r[0..2] and r[3..5] contain their inverses.
*
* Arguments:   - int16_t r[6]:       pointer to the output polynomials
*              - const int16_t a[6]: pointer to the input polynomials
*              - uint32_t zeta:      parameter defining X^3 ± zeta
*
* Returns:     0 if both polynomials are invertible, 1 otherwise.
**************************************************/
int baseinv(int16_t r[6], const int16_t a[6], uint32_t zeta)
{
	int16_t t, s;
	uint32_t A0, A1, A2, T;
	uint32_t B0, B1, B2, S;

	A0 = a[0]*NTRUPLUS_QINV;
	A1 = a[1]*NTRUPLUS_QINV;
	A2 = a[2]*NTRUPLUS_QINV;

	r[0] = plantard_reduce_acc(a[1]*A2);
	r[1] = plantard_reduce_acc(a[2]*A2);
	r[2] = plantard_reduce_acc(a[1]*A1-a[0]*A2);

	r[0] = plantard_reduce_acc(a[0]*A0-r[0]*zeta);
	r[1] = plantard_reduce_acc(r[1]*zeta-a[0]*A1);

	t  = plantard_reduce_acc(r[2]*A1+r[1]*A2);
	t  = plantard_reduce_acc(t*zeta+r[0]*A0);

	if(t == 0) return 1;

	B0 = a[3]*NTRUPLUS_QINV;
	B1 = a[4]*NTRUPLUS_QINV;
	B2 = a[5]*NTRUPLUS_QINV;

	r[3] = plantard_reduce_acc(a[4]*B2);
	r[4] = plantard_reduce_acc(a[5]*B2);
	r[5] = plantard_reduce_acc(a[4]*B1-a[3]*B2);

	r[3] = plantard_reduce_acc(a[3]*B0+r[3]*zeta);
	r[4] = -plantard_reduce_acc(r[4]*zeta+a[3]*B1);

	s  = plantard_reduce_acc(r[5]*B1+r[4]*B2);
	s  = plantard_reduce_acc(-s*zeta+r[3]*B0);

	if(s == 0) return 1;	

	t = fqinv(t);
	s = fqinv(s);
	t = plantard_mul(NTRUPLUS_Rinv, t);
	s = plantard_mul(NTRUPLUS_Rinv, s);
	
	T = t*NTRUPLUS_QINV;
	S = s*NTRUPLUS_QINV;

	r[0] = plantard_reduce_acc(r[0]*T);
	r[1] = plantard_reduce_acc(r[1]*T);
	r[2] = plantard_reduce_acc(r[2]*T);
	r[3] = plantard_reduce_acc(r[3]*S);
	r[4] = plantard_reduce_acc(r[4]*S);
	r[5] = plantard_reduce_acc(r[5]*S);

	return 0;
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^3-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t c[3]: pointer to the output polynomial
*              - const int16_t a[3]: pointer to the first factor
*              - const int16_t b[3]: pointer to the second factor
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
void basemul(int16_t r[3], const int16_t a[3], const int16_t b[3], uint32_t zeta)
{
	uint32_t A0, A1, A2;

	A0 = a[0]*NTRUPLUS_QINV;
	A1 = a[1]*NTRUPLUS_QINV;
	A2 = a[2]*NTRUPLUS_QINV;

	r[0] = plantard_reduce_acc(A2*b[1]+A1*b[2]);
	r[1] = plantard_reduce_acc(A2*b[2]);

	r[0] = plantard_reduce_acc(r[0]*zeta+A0*b[0]);
	r[1] = plantard_reduce_acc(r[1]*zeta+A0*b[1]+A1*b[0]);
	r[2] = plantard_reduce_acc(A2*b[0]+A1*b[1]+A0*b[2]);

	r[0] = plantard_mul(NTRUPLUS_Rsq, r[0]);
	r[1] = plantard_mul(NTRUPLUS_Rsq, r[1]);
	r[2] = plantard_mul(NTRUPLUS_Rsq, r[2]);
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^3-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t c[3]: pointer to the output polynomial
*              - const int16_t a[3]: pointer to the first factor
*              - const int16_t b[3]: pointer to the second factor
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
void basemul_add(int16_t r[3], const int16_t a[3], const int16_t b[3], const int16_t c[3], uint32_t zeta)
{
	uint32_t A0, A1, A2;

	A0 = a[0]*NTRUPLUS_QINV;
	A1 = a[1]*NTRUPLUS_QINV;
	A2 = a[2]*NTRUPLUS_QINV;

	r[0] = plantard_reduce_acc(A2*b[1]+A1*b[2]);
	r[1] = plantard_reduce_acc(A2*b[2]);

	r[0] = plantard_reduce_acc(r[0]*zeta+A0*b[0]);
	r[1] = plantard_reduce_acc(r[1]*zeta+A0*b[1]+A1*b[0]);
	r[2] = plantard_reduce_acc(A2*b[0]+A1*b[1]+A0*b[2]);

	r[0] = plantard_reduce_acc(c[0]*NTRUPLUS_R + r[0]*NTRUPLUS_Rsq);
	r[1] = plantard_reduce_acc(c[1]*NTRUPLUS_R + r[1]*NTRUPLUS_Rsq);
	r[2] = plantard_reduce_acc(c[2]*NTRUPLUS_R + r[2]*NTRUPLUS_Rsq);
}
