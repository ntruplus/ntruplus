#include "poly.h"
#include <stddef.h>

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
* Name:        poly_sotp
*
* Description: Encode a message deterministically using SOTP and a random,
			   with output polynomial close to centered binomial distribution
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *msg: pointer to input message
*              - const uint8_t *buf: pointer to input random
**************************************************/
void poly_sotp(poly *r, const uint8_t msg[NTRUPLUS_N/8], const uint8_t buf[NTRUPLUS_N/4])
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
int poly_sotp_inv(uint8_t msg[NTRUPLUS_N/8], const poly *a, const uint8_t buf[NTRUPLUS_N/4])
{
	uint8_t t1, t2, t3;
	uint16_t t4;
	uint32_t r = 0;

	for(size_t i = 0; i < NTRUPLUS_N / 8; i++)
	{
		t1 = buf[i                 ];
		t2 = buf[i + NTRUPLUS_N / 8];
		t3 = 0;

		for(int j = 0; j < 8; j++)
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

	return r;
}
