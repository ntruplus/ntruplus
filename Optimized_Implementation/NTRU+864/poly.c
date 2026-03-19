#include <string.h>
#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "symmetric.h"

#define NTRUPLUS_R           0x0012F51Eu 
#define NTRUPLUS_RINV        0xECF7EDA3u
#define NTRUPLUS_RSQ         0xBFCBDDF0u
#define NTRUPLUS_QINV        0x74563281u

#define NTRUPLUS_OMEGA       0xCA75BE64u
#define NTRUPLUS_ZMINUSZ5INV 0x790084B4u

#define NTRUPLUS_NINV        0xFF1C82A1u
#define NTRUPLUS_2NINV       0xFE390542u

const uint32_t zetas[288] = {
	0x0012F51Eu, 0xCA88B381u, 0x8F70A253u, 0x533C346Eu, 0x40342211u, 0x708F5DAEu, 0x2152DD6Bu, 0x93A935D7u,
	0x4FD4292Du, 0x276560CAu, 0x7F84C6C2u, 0xC320F414u, 0x435058DDu, 0x044B88A1u, 0x8CC62A36u, 0x5B87713Au,
	0x1611540Du, 0xB02BD6D4u, 0x0BA052F1u, 0x35D61612u, 0x2A35C321u, 0xF8138CC7u, 0x58DCF91Du, 0x60C96C57u,
	0x0BEC2766u, 0x5FF8E416u, 0x540CBCB0u, 0x8EC6044Cu, 0x5587E2F9u, 0xC6C1DEAEu, 0x48467F85u, 0x292C5B88u,
	0xE0E5DC03u, 0xDD6ADBA4u, 0x88A08BD0u, 0xAB35B02Cu, 0xE5DC02ABu, 0xB4775F75u, 0xAD229525u, 0xD3A4788Fu,
	0xB9807B3Au, 0x0754CA50u, 0xCFB7B981u, 0x781D0755u, 0x39FBB478u, 0x5C1F1A24u, 0x2BD6D3A5u, 0x3E2152DEu,
	0x35B02BD7u, 0x7B393E22u, 0x02AA781Eu, 0x5F743049u, 0x95245C20u, 0x788EC605u, 0x0CBCAFA8u, 0x39D5CA3Du,
	0x56CA29EAu, 0x071BEAF9u, 0x13D89AA0u, 0xE30BA053u, 0x20F413D9u, 0x2306E30Cu, 0xEC7339D6u, 0xEEABF344u,
	0x0FA0071Cu, 0x3693A936u, 0x5FAD0FA1u, 0x9A9F3694u, 0xAFA72307u, 0xCA3CDF0Cu, 0x29E9EEACu, 0xEAF8138Du,
	0x05FF8E42u, 0x96C56CA3u, 0x5CA3CDF1u, 0x35058DD0u, 0x89A9F36Au, 0xBA052F06u, 0x1540CBCBu, 0xC7339D5Du,
	0xCF91CF46u, 0x0F413D8Au, 0xBEAF8139u, 0x5D616116u, 0x72306E31u, 0xCDF0BEC3u, 0x8E41507Fu, 0x6CA29E9Fu,
	0x62A35C33u, 0xCBCAFA73u, 0xF3693A94u, 0x2F05FF8Fu, 0x9EEABF35u, 0x8138CC63u, 0xCF45FAD1u, 0x3D89A9F4u,
	0x61611541u, 0x507EC734u, 0x6E30BA06u, 0xBEC27657u, 0x0071BEB0u, 0x3A935D62u, 0x5C320F42u, 0xFA72306Fu,
	0x560C96C6u, 0xFAD0FA01u, 0xBF343506u, 0xCC62A35Du, 0xADBA3E0Fu, 0x77139FBCu, 0xD0754CA5u, 0x8467F84Du,
	0x6D3A4789u, 0x152DD6AEu, 0x08BCFB7Cu, 0x2AA781D1u, 0x4C6C1DEBu, 0x5B02BD6Eu, 0xF1A23FD6u, 0x44B88A09u,
	0x07B393E3u, 0x4CA4FD43u, 0x3E0E5DC1u, 0x9FBB4776u, 0x7E2F8AB4u, 0xFB7B9808u, 0x4788EC61u, 0xD6ADBA3Fu,
	0x75F74305u, 0x3FD5587Fu, 0x1DEAD22Au, 0xBD6D3A48u, 0xB88A08BDu, 0x5DC02AA8u, 0x93E2152Eu, 0xFD4292C6u,
	0x45C1F1A3u, 0xEC6044B9u, 0x8AB35B03u, 0x9807B394u, 0xC5B87714u, 0xD2295246u, 0x43048468u, 0x587E2F8Bu,
	0x00AA9E08u, 0xD7DD0C13u, 0x0A4B16E2u, 0x77AB48A6u, 0xE2ACD6C1u, 0xE601ECE5u, 0x3B18112Fu, 0x6E8F8398u,
	0xE4F8854Cu, 0x3F50A4B2u, 0x97700AAAu, 0xD1DD7DD1u, 0xA5491708u, 0x1E23B182u, 0xF8BE2ACEu, 0xEDEE601Fu,
	0x8112E229u, 0xF8397701u, 0x1ECE4F89u, 0x3293F50Bu, 0xD0C1211Au, 0x561F8BE3u, 0xB48A5492u, 0x4E91E23Cu,
	0x8F839771u, 0xE7EED1DEu, 0x53293F51u, 0xFE131B08u, 0x5561F8BFu, 0x22F3EDEFu, 0xB4E91E24u, 0x54B75AB7u,
	0xEE601ECFu, 0x41D53294u, 0xB6E8F83Au, 0xDC4E7EEEu, 0x077AB48Bu, 0xAF5B4E92u, 0x8FF55620u, 0x22822F3Fu,
	0x91E23B19u, 0x75AB6E90u, 0x3EDEE602u, 0xE0741D54u, 0xED1DD7DEu, 0xC688FF56u, 0x31B077ACu, 0x6C0AF5B5u,
	0xB75AB6E9u, 0x16E1DC4Fu, 0x9E0741D6u, 0x0C1211A0u, 0x7C688FF6u, 0x112E2283u, 0xD6C0AF5Cu, 0xECE4F886u,
	0x822F3EDFu, 0x0AA9E075u, 0x854B75ACu, 0xA4B16E1Eu, 0x9FE131B1u, 0x2ACD6C0Bu, 0x1707C689u, 0xB18112E3u,
	0x0AF5B4EAu, 0x4F8854B8u, 0xE22822F4u, 0x7700AA9Fu, 0x1DC4E7EFu, 0x5491707Du, 0x2119FE14u, 0x8BE2ACD7u,
	0x14BC17FFu, 0x58325B16u, 0xCE757290u, 0xFCD0D417u, 0x6FABE04Fu, 0xD7585846u, 0x83D04F63u, 0x8C1B8C2Fu,
	0x455032F3u, 0xB1CCE758u, 0x2E814BC2u, 0x9D958326u, 0x16373E48u, 0x70C83D05u, 0x01C6FABFu, 0xEA4D7586u,
	0x04F626A8u, 0xB8C2E815u, 0x85845504u, 0x41FB1CCFu, 0x25B15B29u, 0x3E801C70u, 0x0D416374u, 0xA8D70C84u,
	0x1B8C2E82u, 0x2FB09D96u, 0x541FB1CDu, 0xA7A7BAB0u, 0x43E801C7u, 0xCDA4EA4Eu, 0x8A8D70C9u, 0x2F2BE9C9u,
	0x4D758585u, 0x390541FCu, 0xC8C1B8C3u, 0x37C2FB0Au, 0xAFCD0D42u, 0x3318A8D8u, 0x7EB43E81u, 0x6A7CDA4Fu,
	0xD70C83D1u, 0xBE9C8C1Cu, 0x4EA4D759u, 0x7FE39055u, 0x09D95833u, 0x3D17EB44u, 0x7BAAFCD1u, 0x04E3318Bu,
	0x2BE9C8C2u, 0x728F37C3u, 0x17FE3906u, 0x5B15B28Bu, 0x73D17EB5u, 0x4F626A7Du, 0xE04E3319u, 0x58455033u,
	0x7CDA4EA5u, 0x4BC17FE4u, 0x32F2BE9Du, 0xE75728F4u, 0x8A7A7BABu, 0xFABE04E4u, 0x3E473D18u, 0x3D04F627u,
	0xE3318A8Eu, 0x55032F2Cu, 0x26A7CDA5u, 0xE814BC18u, 0xF37C2FB1u, 0x6373E474u, 0x5B28A7A8u, 0x1C6FABE1u
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
static inline int16_t plantard_reduce(uint32_t a)
{
	int32_t t = (int32_t)(a * NTRUPLUS_QINV) >> 16;
	t = ((t+8)*NTRUPLUS_Q) >> 16;
	return t;	
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
static inline int16_t plantard_reduce_acc(uint32_t a)
{
	int32_t t = (int32_t)a >> 16;
	t = ((t+8)*NTRUPLUS_Q) >> 16;
	return t;
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
	int32_t t = (int32_t)(a * b) >> 16;
	t = ((t+8)*NTRUPLUS_Q) >> 16;
	return t;
}

#define NTRUPLUS_R_MONT            -147
#define NTRUPLUS_RSQ_MONT           867
#define NTRUPLUS_QINV_MONT        12929

const int16_t zetas_mont[288] = {
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
	 -194,   928,  1229, -1032,  1608,  1111, -1669,   642,
	-1323,   163,   309,   981,  -557,  -258,   232, -1680,
	-1657, -1233,   144,  1699,   311, -1060,   578,  1298,
	 -403,  1607,  1074,  -148,   447, -1568,  1142,  -402,
	-1412,  -623,   855,   365,   -98,  -244,   407,  1225,
	  416,   683,  -105,  1714, -1019,  1061,  1163,   638,
	  798,  1493,  -351,   396,  -542,    -9,  1616,  -139,
	 -987,  -482,   889,   238, -1513,   466, -1089,  -101,
	  849,  -426,  1589,  1487,   671,  1459,  -776,   255,
	-1014,  1144,   472, -1153,  -325,  1519,   -26, -1123,
	  324,  1230,  1547,  -593,  -428,  1192,  1072, -1564,
	  688,  -333,  1023, -1686,   841,   824,   -71,  1587,
	  522,  -323,  1148,   389,  1231,   384,  1343,   169,
	  628, -1329, -1056,  -936,    24,  -293,  1523,  -300,
	-1654,   891,  -962,   -67,   179, -1177,   844,  -509,
	-1677, -1565,  -549, -1508,  1191,  -280,   -43,   669,
	 -746,   753,   770, -1046,  1711,  1438,   690,  1083,
	 1062,  1727,  -883,   553,  1670,    66,   825,  -133,
	-1586,   637,  -680,  -917,   644,  -372, -1193, -1136
};

/*************************************************
* Name:        montgomery_reduce
*
* Description: Montgomery reduction; given a 32-bit integer a, computes
*              a 16-bit integer congruent to a * R^-1 mod q,
*              where R = 2^16.
*
* Arguments:   - int32_t a: input integer to be reduced;
*                           must lie in {-q*2^15, ..., q*2^15-1}
*
* Returns:     an integer in {-q+1, ..., q-1} congruent to
*              a * R^-1 mod q.
**************************************************/
static inline int16_t montgomery_reduce(int32_t a)
{
	int16_t t;
	
	t = (int16_t)a * NTRUPLUS_QINV_MONT;
	t = (a - (int32_t)t * NTRUPLUS_Q) >> 16;
	return t;
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
	int16_t t[2];

	for(size_t i = 0; i < NTRUPLUS_N/2; i++)
	{
		t[0] = a->coeffs[2*i];
		t[0] += (t[0] >> 15) & NTRUPLUS_Q;
		t[1] = a->coeffs[2*i+1];
		t[1] += (t[1] >> 15) & NTRUPLUS_Q;

		r[3*i+0] = (t[0] >> 0);
		r[3*i+1] = (t[0] >> 8) | (t[1] << 4);
		r[3*i+2] = (t[1] >> 4);
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
	for(size_t i = 0; i < NTRUPLUS_N/2; i++)
	{
		r->coeffs[2*i]   = ((a[3*i+0] >> 0) | ((uint16_t)a[3*i+1] << 8)) & 0xFFF;
		r->coeffs[2*i+1] = ((a[3*i+1] >> 4) | ((uint16_t)a[3*i+2] << 4)) & 0xFFF;
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
void poly_cbd1(poly *r, const unsigned char buf[NTRUPLUS_N/4])
{
	uint8_t t1, t2;

	for(size_t i = 0; i < NTRUPLUS_N / 8; i++)
	{
		t1 = buf[i];
		t2 = buf[i + NTRUPLUS_N / 8];

		for(size_t j = 0; j < 8; j++)
		{
			r->coeffs[8*i + j] = (t1 & 0x1) - (t2 & 0x1);

			t1 >>= 1;   
			t2 >>= 1;
		}
	}
}

/*************************************************
* Name:        poly_sotp_encode
*
* Description: Encode a message deterministically using SOTP and a random,
			   with output polynomial close to centered binomial distribution
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *msg: pointer to input message
*              - const uint8_t *buf: pointer to input random
**************************************************/
void poly_sotp_encode(poly *r, const uint8_t msg[NTRUPLUS_N/8], const uint8_t buf[NTRUPLUS_N/4])
{
    uint8_t tmp[NTRUPLUS_N/4];

    for(int i = 0; i < NTRUPLUS_N/8; i++)
    {
         tmp[i] = buf[i]^msg[i];
    }

    for(int i = NTRUPLUS_N/8; i < NTRUPLUS_N/4; i++)
    {
         tmp[i] = buf[i];
    }

	poly_cbd1(r, tmp);
}

/*************************************************
* Name:        poly_sotp_decode
*
* Description: Decode a message deterministically using SOTP_INV and a random
*
* Arguments:   - uint8_t *msg: pointer to output message
*              - const poly *a: pointer to iput polynomial
*              - const uint8_t *buf: pointer to input random
*
* Returns 0 (success) or 1 (failure)
**************************************************/
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N/8], const poly *a, const uint8_t buf[NTRUPLUS_N/4])
{
	uint8_t t1, t2, t3;
	uint16_t t4;
	uint32_t r = 0;
	uint8_t mask;

	for(size_t i = 0; i < NTRUPLUS_N / 8; i++)
	{
		t1 = buf[i                 ];
		t2 = buf[i + NTRUPLUS_N / 8];
		t3 = 0;

		for(size_t j = 0; j < 8; j++)
		{
			t4 = t2 & 0x1;
			t4 += a->coeffs[8*i + j];
			r |= t4;
			t4 = (t4 ^ t1) & 0x1;
			t3 ^= (uint8_t)(t4 << j);

			t1 >>= 1;
			t2 >>= 1;
		}

		msg[i] = t3;
	}

	r = r >> 1;
	r = (-(uint32_t)r) >> 31;

	mask = (uint8_t)(r - 1);

	for (size_t i = 0; i < NTRUPLUS_N / 8; i++)
		msg[i] &= mask;

	return r;
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
static inline void ntt(int16_t r[NTRUPLUS_N])
{
	int16_t t1,t2,t3;
	uint32_t T1,T2;
	uint32_t zeta[5];
	int16_t v[8];

	int index = 1;

	zeta[0] = zetas[index++];

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = plantard_mul(zeta[0], r[i + NTRUPLUS_N/2]);

		r[i + NTRUPLUS_N/2] = r[i] + r[i + NTRUPLUS_N/2] - t1;
		r[i               ] = r[i]                       + t1;
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
			T1 = r[i]*NTRUPLUS_R;
			T2 = zeta[0]*r[i + 3];

			r[i + 3] = plantard_reduce_acc(T1 - T2);
			r[i    ] = plantard_reduce_acc(T1 + T2);
		}
	}
}

/*************************************************
* Name:        poly_ntt
*
* Description: Computes number-theoretic transform (NTT)
*
* Arguments:   - poly *r: pointer to input/output polynomial
**************************************************/
void poly_ntt(poly *r)
{
	ntt(r->coeffs);
}

/*************************************************
* Name:        invntt
*
* Description: Inverse number-theoretic transform (NTT) in R_q. Transforms
*              the NTT representation in r, where each block of 4
*              coefficients corresponds to an element of Zq[X]/(X^4 - zeta_i),
*              back to the coefficient representation in R_q.
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to input/output vector;
*                                       input NTT representation in the
*                                       product ring Zq[X]/(X^4 - zeta_i),
*                                       output coefficient representation
*                                       in R_q
*
* Returns:     none.
**************************************************/
static inline void invntt(int16_t r[NTRUPLUS_N])
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
				v[k] = r[3*k+j+24*i];
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

			t1 = plantard_mul(NTRUPLUS_OMEGA, v[2] - v[0]);
			t2 = plantard_mul(zeta[3], v[4] - v[0] + t1);
			t3 = plantard_mul(zeta[4], v[4] - v[2] - t1);
			v[0] = plantard_mul((int32_t)v[0] + (int32_t)v[2] + (int32_t)v[4], NTRUPLUS_R);
			v[2] = t2;
			v[4] = t3;

			t1 = plantard_mul(NTRUPLUS_OMEGA, v[3] - v[1]);
			t2 = plantard_mul(zeta[3], v[5] - v[1] + t1);
			t3 = plantard_mul(zeta[4], v[5] - v[3] - t1);
			v[1] = plantard_mul((int32_t)v[1] + (int32_t)v[3] + (int32_t)v[5], NTRUPLUS_R);
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
			v[j] = r[144*j+i];
		}

		t1 = plantard_mul(NTRUPLUS_OMEGA, v[1] - v[0]);
		t2 = plantard_mul(zeta[0], v[2] - v[0] + t1);
		t3 = plantard_mul(zeta[1], v[2] - v[1] - t1);
		v[0] = v[0] + v[1] + v[2];
		v[1] = t2;
		v[2] = t3;

		t1 = plantard_mul(NTRUPLUS_OMEGA, v[4] - v[3]);
		t2 = plantard_mul(zeta[2], v[5] - v[3] + t1);
		t3 = plantard_mul(zeta[3], v[5] - v[4] - t1);
		v[3] = v[3] + v[4] + v[5];
		v[4] = t2;
		v[5] = t3;

		t1 = v[0] + v[3];
		t2 = plantard_mul(NTRUPLUS_ZMINUSZ5INV, v[0] - v[3]);
		v[0] = plantard_mul(NTRUPLUS_NINV, t1 - t2);
		v[3] = plantard_mul(NTRUPLUS_2NINV, t2);

		t1 = v[1] + v[4];
		t2 = plantard_mul(NTRUPLUS_ZMINUSZ5INV, v[1] - v[4]);
		v[1] = plantard_mul(NTRUPLUS_NINV, t1 - t2);
		v[4] = plantard_mul(NTRUPLUS_2NINV, t2);

		t1 = v[2] + v[5];
		t2 = plantard_mul(NTRUPLUS_ZMINUSZ5INV, v[2] - v[5]);
		v[2] = plantard_mul(NTRUPLUS_NINV, t1 - t2);
		v[5] = plantard_mul(NTRUPLUS_2NINV, t2);				

		for (int j = 0; j < 6; j++)
		{
			r[144*j+i] = v[j];
		}
	}
}

/*************************************************
* Name:        poly_invntt
*
* Description: Computes inverse of number-theoretic transform (NTT)
*
* Arguments:   - poly *r: pointer to input/output polynomial
**************************************************/
void poly_invntt(poly *r)
{
	invntt(r->coeffs);
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
static inline int baseinv_1(int16_t r[6], int16_t den[2], const int16_t a[6], uint32_t zeta)
{
	int16_t t0, t1, t2;
	int16_t s0, s1, s2;
	uint32_t A0, A1, A2;
	uint32_t B0, B1, B2;

	A0 = (int32_t)a[0]*NTRUPLUS_QINV;
	A1 = (int32_t)a[1]*NTRUPLUS_QINV;
	A2 = (int32_t)a[2]*NTRUPLUS_QINV;
	B0 = (int32_t)a[3]*NTRUPLUS_QINV;
	B1 = (int32_t)a[4]*NTRUPLUS_QINV;
	B2 = (int32_t)a[5]*NTRUPLUS_QINV;

	t0 = plantard_reduce_acc(a[1]*A2);
	s0 = plantard_reduce_acc(a[4]*B2);
	t1 = plantard_reduce_acc(a[2]*A2);
	s1 = plantard_reduce_acc(a[5]*B2);
	t2 = plantard_reduce_acc(a[1]*A1-a[0]*A2);
	s2 = plantard_reduce_acc(a[4]*B1-a[3]*B2);

	t0 = plantard_reduce_acc(a[0]*A0-t0*zeta);
	s0 = plantard_reduce_acc(a[3]*B0+s0*zeta);
	t1 = plantard_reduce_acc(t1*zeta-a[0]*A1);
	s1 = -plantard_reduce_acc(s1*zeta+a[3]*B1);

	r[0] = t0; r[1] = t1, r[2] = t2;
	r[3] = s0; r[4] = s1, r[5] = s2;

	t2  = plantard_reduce_acc(t2*A1+t1*A2);
	s2  = plantard_reduce_acc(s2*B1+s1*B2);
	t2  = plantard_reduce_acc(t2*zeta+t0*A0);
	s2  = plantard_reduce_acc(s0*B0-s2*zeta);

	if(!(t2 && s2)) return 1;

	den[0] = t2;
	den[1] = s2;

	return 0;
}

/*************************************************
* Name:        fqinv
*
* Description: Computes the multiplicative inverse of a value in the
*              finite field Z_q.
*
* Arguments:   - int16_t a: input value a mod q
*
* Returns:     16-bit integer congruent to a^{-1} mod q.
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

	t2 = plantard_mul(NTRUPLUS_RINV, t2);

    return t2;
}

static inline void fqinv_batch(int16_t *r)
{
    const int chunk = NTRUPLUS_N / (NTRUPLUS_D * 8);
    const int off0  = 0 * chunk;
    const int off1  = 1 * chunk;
    const int off2  = 2 * chunk;
    const int off3  = 3 * chunk;
    const int off4  = 4 * chunk;
    const int off5  = 5 * chunk;
    const int off6  = 6 * chunk;
    const int off7  = 7 * chunk;

    int16_t  pc0[NTRUPLUS_N / NTRUPLUS_D];
    uint32_t R[NTRUPLUS_N / NTRUPLUS_D];

    pc0[off0] = r[off0];
    pc0[off1] = r[off1];
    pc0[off2] = r[off2];
    pc0[off3] = r[off3];
    pc0[off4] = r[off4];
    pc0[off5] = r[off5];
    pc0[off6] = r[off6];
    pc0[off7] = r[off7];

    for (int i = 1; i < chunk; i++)
    {
        R[off0 + i] = (uint32_t)r[off0 + i] * NTRUPLUS_QINV;
        R[off1 + i] = (uint32_t)r[off1 + i] * NTRUPLUS_QINV;
        R[off2 + i] = (uint32_t)r[off2 + i] * NTRUPLUS_QINV;
        R[off3 + i] = (uint32_t)r[off3 + i] * NTRUPLUS_QINV;
        R[off4 + i] = (uint32_t)r[off4 + i] * NTRUPLUS_QINV;
        R[off5 + i] = (uint32_t)r[off5 + i] * NTRUPLUS_QINV;
        R[off6 + i] = (uint32_t)r[off6 + i] * NTRUPLUS_QINV;
        R[off7 + i] = (uint32_t)r[off7 + i] * NTRUPLUS_QINV;

		pc0[off0 + i] = plantard_mul(pc0[off0 + i - 1], R[off0 + i]);
        pc0[off1 + i] = plantard_mul(pc0[off1 + i - 1], R[off1 + i]);
        pc0[off2 + i] = plantard_mul(pc0[off2 + i - 1], R[off2 + i]);
        pc0[off3 + i] = plantard_mul(pc0[off3 + i - 1], R[off3 + i]);
		pc0[off4 + i] = plantard_mul(pc0[off4 + i - 1], R[off4 + i]);
        pc0[off5 + i] = plantard_mul(pc0[off5 + i - 1], R[off5 + i]);
        pc0[off6 + i] = plantard_mul(pc0[off6 + i - 1], R[off6 + i]);
        pc0[off7 + i] = plantard_mul(pc0[off7 + i - 1], R[off7 + i]);
    }

    // product chain - level 1
    int16_t  r1[8];
    uint32_t R1[8];

    r1[0] = pc0[off0 + chunk - 1];
    r1[1] = pc0[off1 + chunk - 1];
    r1[2] = pc0[off2 + chunk - 1];
    r1[3] = pc0[off3 + chunk - 1];
    r1[4] = pc0[off4 + chunk - 1];
    r1[5] = pc0[off5 + chunk - 1];
    r1[6] = pc0[off6 + chunk - 1];
    r1[7] = pc0[off7 + chunk - 1];

    R1[0] = (uint32_t)r1[0] * NTRUPLUS_QINV;
    R1[1] = (uint32_t)r1[1] * NTRUPLUS_QINV;
    R1[2] = (uint32_t)r1[2] * NTRUPLUS_QINV;
    R1[3] = (uint32_t)r1[3] * NTRUPLUS_QINV;
    R1[4] = (uint32_t)r1[4] * NTRUPLUS_QINV;
    R1[5] = (uint32_t)r1[5] * NTRUPLUS_QINV;
    R1[6] = (uint32_t)r1[6] * NTRUPLUS_QINV;
    R1[7] = (uint32_t)r1[7] * NTRUPLUS_QINV;

    int16_t  r2[4];
    uint32_t R2[4];

    r2[0] = plantard_mul(r1[0], R1[1]);
    r2[1] = plantard_mul(r1[2], R1[3]);
    r2[2] = plantard_mul(r1[4], R1[5]);
    r2[3] = plantard_mul(r1[6], R1[7]);

	R2[0] = (uint32_t)r2[0] * NTRUPLUS_QINV;
	R2[1] = (uint32_t)r2[1] * NTRUPLUS_QINV;
	R2[2] = (uint32_t)r2[2] * NTRUPLUS_QINV;
	R2[3] = (uint32_t)r2[3] * NTRUPLUS_QINV;

    // product chain - level 2
    int16_t  r3[2];
    uint32_t R3[2];

    r3[0] = plantard_mul(r2[0], R2[1]);
    r3[1] = plantard_mul(r2[2], R2[3]);

	R3[0] = (uint32_t)r3[0] * NTRUPLUS_QINV;
	R3[1] = (uint32_t)r3[1] * NTRUPLUS_QINV;

    // product chain - level 3
    int16_t inv = plantard_mul(r3[0], R3[1]);

    //fqinv
    inv = fqinv(inv);

    // derive_fqinv - level 3
    int16_t inv2[2];

    inv2[1] = plantard_mul(inv, R3[0]);
    
    inv2[0] = plantard_mul(inv, R3[1]);

    // derive_fqinv - level 2
    int16_t inv1[4];

    inv1[1] = plantard_mul(inv2[0], R2[0]);
    inv1[3] = plantard_mul(inv2[1], R2[2]);

    inv1[0] = plantard_mul(inv2[0], R2[1]);
    inv1[2] = plantard_mul(inv2[1], R2[3]);

    // derive_fqinv - level 1
    int16_t inv0[8];

    inv0[1] = plantard_mul(inv1[0], R1[0]);
    inv0[3] = plantard_mul(inv1[1], R1[2]);
    inv0[5] = plantard_mul(inv1[2], R1[4]);
    inv0[7] = plantard_mul(inv1[3], R1[6]);

    inv0[0] = plantard_mul(inv1[0], R1[1]);
    inv0[2] = plantard_mul(inv1[1], R1[3]);
    inv0[4] = plantard_mul(inv1[2], R1[5]);
    inv0[6] = plantard_mul(inv1[3], R1[7]);

    for (int i = chunk - 1; i > 0; i--)
    {
		r[off0 + i] = plantard_reduce(pc0[off0 + i - 1]*inv0[0]);
		r[off1 + i] = plantard_reduce(pc0[off1 + i - 1]*inv0[1]);
		r[off2 + i] = plantard_reduce(pc0[off2 + i - 1]*inv0[2]);
		r[off3 + i] = plantard_reduce(pc0[off3 + i - 1]*inv0[3]);
		r[off4 + i] = plantard_reduce(pc0[off4 + i - 1]*inv0[4]);
		r[off5 + i] = plantard_reduce(pc0[off5 + i - 1]*inv0[5]);
		r[off6 + i] = plantard_reduce(pc0[off6 + i - 1]*inv0[6]);
		r[off7 + i] = plantard_reduce(pc0[off7 + i - 1]*inv0[7]);

		inv0[0] = plantard_mul(inv0[0], R[off0 + i]);
        inv0[1] = plantard_mul(inv0[1], R[off1 + i]);
        inv0[2] = plantard_mul(inv0[2], R[off2 + i]);
        inv0[3] = plantard_mul(inv0[3], R[off3 + i]);
		inv0[4] = plantard_mul(inv0[4], R[off4 + i]);
        inv0[5] = plantard_mul(inv0[5], R[off5 + i]);
        inv0[6] = plantard_mul(inv0[6], R[off6 + i]);
        inv0[7] = plantard_mul(inv0[7], R[off7 + i]);
    }

    r[off0] = inv0[0];
    r[off1] = inv0[1];
    r[off2] = inv0[2];
    r[off3] = inv0[3];
    r[off4] = inv0[4];
    r[off5] = inv0[5];
    r[off6] = inv0[6];
    r[off7] = inv0[7];
}

static inline void baseinv_2(int16_t r[6], int16_t den[1])
{
	uint32_t T;
	
	T = den[0]*NTRUPLUS_QINV;

	r[0] = plantard_reduce_acc(r[0]*T);
	r[1] = plantard_reduce_acc(r[1]*T);
	r[2] = plantard_reduce_acc(r[2]*T);
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
	int16_t den[NTRUPLUS_N / 3];

	for(int i = 0; i < NTRUPLUS_N/6; ++i)
	{
		if(baseinv_1(r->coeffs + 6*i, den + 2*i, a->coeffs + 6*i, zetas[144 + i]))
		{
			memset(r->coeffs, 0, NTRUPLUS_N*sizeof(int16_t));

			return 1;
		}
	}

	fqinv_batch(den);

	for(int i = 0; i < NTRUPLUS_N/3; ++i)
		baseinv_2(r->coeffs + 3*i, den + i);

	return 0;
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^3 - zeta),
*              used for multiplication of elements in R_q in the NTT domain.
*
* Arguments:   - int16_t r[3]:        pointer to the output polynomial
*              - const int16_t a[3]:  pointer to the first factor
*              - const int16_t b[3]:  pointer to the second factor
*              - const int16_t zeta:  parameter defining X^3 - zeta
*
* Returns:     none.
**************************************************/
static inline void basemul(int16_t r[3], const int16_t a[3], const int16_t b[3], int16_t zeta)
{
	r[0] = montgomery_reduce(a[2]*b[1]+a[1]*b[2]); // R^-1
	r[1] = montgomery_reduce(a[2]*b[2]);		   // R^-1

	r[0] = montgomery_reduce(r[0]*zeta+a[0]*b[0]);		 	 // R^-1
	r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]); // R^-1
	r[2] = montgomery_reduce(a[2]*b[0]+a[1]*b[1]+a[0]*b[2]); // R^-1
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
void poly_basemul(poly *r, const poly *a, const poly *b)
{
	for(int i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); i++)
	{
		basemul(r->coeffs+6*i,   a->coeffs+6*i,   b->coeffs+6*i,    zetas_mont[144+i]);
		basemul(r->coeffs+6*i+3, a->coeffs+6*i+3, b->coeffs+6*i+3, -zetas_mont[144+i]);
	}

	for(int i = 0; i < NTRUPLUS_N; i++)
		r->coeffs[i] = montgomery_reduce(r->coeffs[i]*NTRUPLUS_RSQ_MONT);	
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
void poly_basemul_add(poly *r, const poly *a, const poly *b, const poly *c)
{
	for(int i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); i++)
	{
		basemul(r->coeffs+6*i,   a->coeffs+6*i,   b->coeffs+6*i,    zetas_mont[144+i]);
		basemul(r->coeffs+6*i+3, a->coeffs+6*i+3, b->coeffs+6*i+3, -zetas_mont[144+i]);
	}

	for(int i = 0; i < NTRUPLUS_N; i++)
		r->coeffs[i] = montgomery_reduce(c->coeffs[i]*NTRUPLUS_R_MONT + r->coeffs[i]*NTRUPLUS_RSQ_MONT);	
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
	for(int i = 0; i < NTRUPLUS_N; ++i)
		r->coeffs[i] = a->coeffs[i] - b->coeffs[i];
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
	for(int i = 0; i < NTRUPLUS_N; ++i)
		r->coeffs[i] = 3*a->coeffs[i];
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
static inline int16_t crepmod3(int16_t a)
{
	int16_t t;
	const int16_t v = ((1<<15) + 3/2)/3;

	a += (a >> 15) & NTRUPLUS_Q;
	a -= (NTRUPLUS_Q+1)/2;
	a += (a >> 15) & NTRUPLUS_Q;
	a -= (NTRUPLUS_Q-1)/2;

	t  = ((int32_t)v*a + (1<<14)) >> 15;
	t *= 3;
	return a - t;
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
	for(int i = 0; i < NTRUPLUS_N; i++)
		r->coeffs[i] = crepmod3(a->coeffs[i]);
}
