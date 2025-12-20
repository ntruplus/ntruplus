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

const uint32_t zetas_2[288] = {
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
	0xE3318A8Eu, 0x55032F2Cu, 0x26A7CDA5u, 0xE814BC18u, 0xF37C2FB1u, 0x6373E474u, 0x5B28A7A8u, 0x1C6FABE1u,
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

	zeta1 = zetas_2[k++];

	for (int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = plantard_mul(zeta1, a[i + NTRUPLUS_N/2]);

		r[i + NTRUPLUS_N/2] = a[i] + a[i + NTRUPLUS_N/2] - t1;
		r[i               ] = a[i]                       + t1;
	}

	for (int step = NTRUPLUS_N/6; step >= 48; step = step/3)
	{
		for (int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta1 = zetas_2[k++];
			zeta2 = zetas_2[k++];

			for (int i = start; i < start + step; i++)
			{
				t1 = plantard_mul(zeta1, r[i +   step]);
				t2 = plantard_mul(zeta2, r[i + 2*step]);
				t3 = plantard_mul(NTRUPLUS_OMEGA, t1 - t2);
	
				r[i + 2*step] = r[i] - t1 - t3;
				r[i +   step] = r[i] - t2 + t3;
				r[i         ] = r[i] + t1 + t2;
			}
		}
	}

	for (int step = 24; step >= 6; step >>= 1)
	{
		for (int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas_2[k++];

			for (int i = start; i < start + step; i++)
			{
				t1 = plantard_mul(zeta1, r[i + step]);
				
				r[i + step] = r[i] - t1;
				r[i       ] = r[i] + t1;
			}
		}
	}

	for (int start = 0; start < NTRUPLUS_N; start += 6)
	{
		zeta1 = zetas_2[k++];

		for (int i = start; i < start + 3; i++)
		{
			uint32_t T1 = zeta1 * r[i + 3];
			uint32_t T2 = r[i] * NTRUPLUS_R;
			
			r[i + 3] = plantard_reduce_acc(T2 - T1);
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
	int16_t t1,t2,t3;
	uint32_t zeta1,zeta2;
	int k = 287;

	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		r[i] = a[i];
	}

	for (int step = 3; step <= 12; step <<= 1)
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

	for (int start = 0; start < NTRUPLUS_N; start += 48)
	{
		zeta1 = zetas[k--];

		for (int i = start; i < start + 24; i++)
		{
			t1 = r[i + 24];

			r[i + 24] = plantard_mul(zeta1, t1 - r[i]);
			r[i     ] = plantard_mul(NTRUPLUS_R, r[i] + t1);
		}
	}

	for (int step = 48; step <= NTRUPLUS_N/6; step = 3*step)
	{
		for (int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta2 = zetas[k--];
			zeta1 = zetas[k--];

			for (int i = start; i < start + step; i++)
			{
				t1 = plantard_mul(NTRUPLUS_OMEGA,  r[i +   step] - r[i]);
				t2 = plantard_mul(zeta1, r[i + 2*step] - r[i]        + t1);
				t3 = plantard_mul(zeta2, r[i + 2*step] - r[i + step] - t1);

				r[i         ] = r[i] + r[i + step] + r[i + 2*step];
				r[i +   step] = t2;			
				r[i + 2*step] = t3;
			}
		}
	}
	
	for (int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = r[i] + r[i + NTRUPLUS_N/2];
		t2 = plantard_mul(2030077108, r[i] - r[i + NTRUPLUS_N/2]);

		r[i               ] = plantard_mul(4280058529, t1 - t2);
		r[i + NTRUPLUS_N/2] = plantard_mul(4265149762, t2);
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
int baseinv_1(int16_t r[6], int16_t den[2], const int16_t a[6], uint32_t zeta)
{
	int16_t t, s;
	uint32_t A0, A1, A2;
	uint32_t B0, B1, B2;

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

	den[0] = t;
	den[1] = s;

	return 0;
}

void fqinv_batch(int16_t *r)
{
    int16_t  t[NTRUPLUS_N / 3];
    uint32_t R[NTRUPLUS_N / 3];

	int16_t inv;
	uint32_t INV;

    t[0] = r[0];

	for (int i = 1; i < NTRUPLUS_N / 3; i++)
	{
        R[i] = (uint32_t)r[i] * NTRUPLUS_QINV;
		t[i] = plantard_mul(t[i - 1], R[i]);
    }

    inv  = fqinv(t[NTRUPLUS_N / 3 - 1]);
	inv = plantard_mul(NTRUPLUS_Rinv, inv);

    for (int i = NTRUPLUS_N / 3 - 1; i > 0; i--)
	{
	    INV = (uint32_t)inv * NTRUPLUS_QINV;
		r[i] = plantard_mul(t[i - 1], INV); // R^5
        inv = plantard_mul(inv, R[i]);
    }

    r[0] = inv;
}

int baseinv_2(int16_t r[6], int16_t den[2])
{
	uint32_t T, S;
	
	T = den[0]*NTRUPLUS_QINV;
	S = den[1]*NTRUPLUS_QINV;

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
