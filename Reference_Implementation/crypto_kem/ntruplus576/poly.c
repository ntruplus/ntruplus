#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "ntt.h"
#include "reduce.h"
#include "symmetric.h"
#include "util.h"
#include "sha2.h"
#include "sotp.h"

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
			t[0] = a->coeffs[64*j + i];
			t[1] = a->coeffs[64*j + i + 16];
			t[2] = a->coeffs[64*j + i + 32];
			t[3] = a->coeffs[64*j + i + 48];

			r[96*j + 2*i + 0] = (t[0] >> 0);
			r[96*j + 2*i + 1] = (t[0] >> 8) + (t[1] << 4);			
			r[96*j + 2*i + 32] = (t[1] >> 4);
			r[96*j + 2*i + 33] = (t[2] >> 0);
			r[96*j + 2*i + 64] = (t[2] >> 8) + (t[3] << 4); 
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

			r->coeffs[64*j + i + 0]   = t[0];
			r->coeffs[64*j + i + 0] += ((int16_t)t[1] & 0xf) << 8;
			r->coeffs[64*j + i + 16]  = t[1] >> 4;
			r->coeffs[64*j + i + 16] += (int16_t)t[2] << 4;
			r->coeffs[64*j + i + 32]  = t[3];
			r->coeffs[64*j + i + 32] += ((int16_t)t[4] & 0xf) << 8;
			r->coeffs[64*j + i + 48]  = t[4] >> 4;
			r->coeffs[64*j + i + 48] += (int16_t)t[5] << 4;
		}
	}
}
void poly_pack_short_partial(unsigned char *buf, const poly *a)
{
	int16_t t[8];

	for(int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 16; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				t[k] = a->coeffs[128*i + 16*k + j] + 1;
			}

			buf[32*i + 2*j + 0] =  t[3] << 6;
			buf[32*i + 2*j + 0] |= t[2] << 4;
			buf[32*i + 2*j + 0] |= t[1] << 2;
			buf[32*i + 2*j + 0] |= t[0] << 0;

			buf[32*i + 2*j + 1] =  t[7] << 6;
			buf[32*i + 2*j + 1] |= t[6] << 4;
			buf[32*i + 2*j + 1] |= t[5] << 2;
			buf[32*i + 2*j + 1] |= t[4] << 0;
		}
	}

	for (int j = 0; j < 8; j++)
	{
		for (int k = 0; k < 8; k++)
		{
			t[k] = a->coeffs[256 + 8*k + j] + 1;
		}

		buf[64 + 2*j + 0] =  t[3] << 6;
		buf[64 + 2*j + 0] |= t[2] << 4;
		buf[64 + 2*j + 0] |= t[1] << 2;
		buf[64 + 2*j + 0] |= t[0] << 0;

		buf[64 + 2*j + 1] =  t[7] << 6;
		buf[64 + 2*j + 1] |= t[6] << 4;
		buf[64 + 2*j + 1] |= t[5] << 2;
		buf[64 + 2*j + 1] |= t[4] << 0;
	}
}

/*************************************************
* Name:        poly_ntt
*
* Description: Computes negacyclic number-theoretic transform (NTT) of
*              a polynomial in place;
*              inputs assumed to be in normal order, output in bitreversed order
*
* Arguments:   - uint16_t *r: pointer to in/output polynomial
**************************************************/
void poly_ntt(poly *r)
{
  ntt(r->coeffs);
  poly_reduce(r);
}

/*************************************************
* Name:        poly_invntt
*
* Description: Computes inverse of negacyclic number-theoretic transform (NTT)
*              of a polynomial in place;
*              inputs assumed to be in bitreversed order, output in normal order
*
* Arguments:   - uint16_t *a: pointer to in/output polynomial
**************************************************/
void poly_invntt(poly *r)
{
  invntt(r->coeffs);
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
	unsigned int i;
	for(i = 0; i < NTRUPLUS_N; i++)
	{
		r->coeffs[i] = fqmul(a->coeffs[i], b->coeffs[i]);
	}
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inverse of polynomial in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to input polynomial
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
	unsigned int i;
	int t;
	int result = 0;
	for(i = 0; i < NTRUPLUS_N; i++)
	{
		r->coeffs[i] = fqinv(a->coeffs[i]);
		t = (uint16_t)r->coeffs[i];
		t = (uint32_t)(-t) >> 31;
		result += t - 1;
	}

	return result;
}

void poly_reduce(poly *a)
{
	for(int i = 0; i < NTRUPLUS_N; i++) a->coeffs[i] = fqred16(a->coeffs[i]);
}


void poly_freeze(poly *a)
{
	poly_reduce(a);
	for(int i = 0; i < NTRUPLUS_N; i++) a->coeffs[i] = fqcsubq(a->coeffs[i]);
}

void poly_add(poly *c, const poly *a, const poly *b)
{
	for(int i = 0; i < NTRUPLUS_N; ++i) c->coeffs[i] = a->coeffs[i] + b->coeffs[i];
}

void poly_triple(poly *r) 
{
	for(int i = 0; i < NTRUPLUS_N; ++i)
	{
		r->coeffs[i] = 3*r->coeffs[i];
	}
}

// Assumes -Q < a < Q
static int16_t crepmod3(int16_t a) {
  a += (a >> 15) & NTRUPLUS_Q;
  a -= (NTRUPLUS_Q-1)/2;
  a += (a >> 15) & NTRUPLUS_Q;
  a -= (NTRUPLUS_Q+1)/2;

  a  = (a >> 8) + (a & 255);
  a  = (a >> 4) + (a & 15);
  a  = (a >> 2) + (a & 3);
  a  = (a >> 2) + (a & 3);
  a -= 3;
  a += ((a + 1) >> 15) & 3;
  return a;
}

void poly_crepmod3(poly *b, const poly *a)
{
  unsigned int i;

  for(i = 0; i < NTRUPLUS_N; ++i)
    b->coeffs[i] = crepmod3(a->coeffs[i]);
}

void poly_cbd1(poly *a, const unsigned char buf[144])
{
	uint32_t t1, t2;

	for(int i = 0; i < 4; i++)
	{
		for(int j = 0; j < 8; j++)
		{
			t1 = load32_littleendian(buf + 32*i + 4*j);
			t2 = t1 >> 1;

			for (int k = 0; k < 2; k++)
			{
				for(int l = 0; l < 8; l++)
				{
					a->coeffs[128*i + 16*l + 2*j + k] = (t1 & 0x1) - (t2 & 0x1);

					t1 >>= 2;
					t2 >>= 2;
				}
			}
		}
	}

	for(int j = 0; j < 4; j++)
	{
		t1 = load32_littleendian(buf + 128 + 4*j);
		t2 = t1 >> 1;

		for (int k = 0; k < 2; k++)
		{
			for(int l = 0; l < 8; l++)
			{
				a->coeffs[512 + 8*l + 2*j + k] = (t1 & 0x1) - (t2 & 0x1);

				t1 >>= 2;
				t2 >>= 2;
			}
		}
	}
}

void poly_cbd1_m1(poly *a, const unsigned char buf[80])
{
	uint32_t t1, t2;

	for(int i = 0; i < 2; i++)
	{
		for(int j = 0; j < 8; j++)
		{
			t1 = load32_littleendian(buf + 32*i + 4*j);
			t2 = t1 >> 1;

			for (int k = 0; k < 2; k++)
			{
				for(int l = 0; l < 8; l++)
				{
					a->coeffs[128*i + 16*l + 2*j + k] = (t1 & 0x1) - (t2 & 0x1);

					t1 >>= 2;
					t2 >>= 2;
				}
			}
		}
	}

	for(int j = 0; j < 4; j++)
	{
		t1 = load32_littleendian(buf + 64 + 4*j);
		t2 = t1 >> 1;

		for (int k = 0; k < 2; k++)
		{
			for(int l = 0; l < 8; l++)
			{
				a->coeffs[256 + 8*l + 2*j + k] = (t1 & 0x1) - (t2 & 0x1);

				t1 >>= 2;
				t2 >>= 2;
			}
		}
	}
}

void poly_sotp(poly *e, const unsigned char *msg)
{
  unsigned char buf[80] = {0};

  poly_pack_short_partial(buf, e);
  sha512(buf, buf, 80);
  sotp_internal(e, msg, buf);
}

void poly_sotp_inv(unsigned char *msg, poly *e)
{
  unsigned char buf[80] = {0};

  poly_pack_short_partial(buf, e);
  sha512(buf, buf, 80);
  sotp_inv_internal(msg, e, buf);
}
