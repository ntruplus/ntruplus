#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "ntt.h"
#include "reduce.h"
#include "cbd.h"
#include "symmetric.h"



void poly_pack_uniform(unsigned char *buf, const poly *a)
{
	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		buf[3*i    ] = (a->coeffs[2*i    ] >> 4); 
		buf[3*i + 1] = ((a->coeffs[2*i    ] & 0xF) << 4) | ((a->coeffs[2*i + 1] >> 8) & 0xF);
		buf[3*i + 2] = (a->coeffs[2*i + 1]);
	}
}

void poly_unpack_uniform(poly *a, const unsigned char *buf) 
{
	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		a->coeffs[2*i    ] =  buf[3*i    ]        << 4 | buf[3*i + 1] >> 4;
		a->coeffs[2*i + 1] = (buf[3*i + 1] & 0xF) << 8 | buf[3*i + 2];
	}
}

void poly_pack_short_partial(unsigned char *buf, const poly *a)
{
	for (int i = 0; i < NTRUPLUS_N / 4; i++)
	{
		buf[i]  = (a->coeffs[4*i    ] + 1) << 6;
		buf[i] |= (a->coeffs[4*i + 1] + 1) << 4;
		buf[i] |= (a->coeffs[4*i + 2] + 1) << 2;
		buf[i] |= (a->coeffs[4*i + 3] + 1);
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
 	int k = 0;
	for(int i = 0; i < NTRUPLUS_N/6; i++)	{
		basemul(r->coeffs + 6*i    , a->coeffs + 6*i    , b->coeffs + 6*i    , zetas_mul[k++]);
		basemul(r->coeffs + 6*i + 2, a->coeffs + 6*i + 2, b->coeffs + 6*i + 2, zetas_mul[k++]);
		basemul(r->coeffs + 6*i + 4, a->coeffs + 6*i + 4, b->coeffs + 6*i + 4, zetas_mul[k++]); //need to improve
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
	int result = 0;
	int k = 0;
	for(i = 0; i < NTRUPLUS_N/6; i++)
	{
		//zeta = zetas[127 + 2*i];
		result += baseinv(r->coeffs + 6*i    , a->coeffs + 6*i    , zetas_mul[k++]);
		result += baseinv(r->coeffs + 6*i + 2, a->coeffs + 6*i + 2, zetas_mul[k++]);
		result += baseinv(r->coeffs + 6*i + 4, a->coeffs + 6*i + 4, zetas_mul[k++]); //need to improve
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

void poly_triple(poly *b, const poly *a) 
{
	for(int i = 0; i < NTRUPLUS_N; ++i) b->coeffs[i] = 3*a->coeffs[i];
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

void poly_cbd1(poly *a, const unsigned char *buf)
{
  unsigned int i;
  unsigned char t;
  const uint16_t L = 0x9;

  for(i = 0; i < NTRUPLUS_N/4; i++) {
    t = buf[i];
    a->coeffs[4*i + 0]  = (L >> (t & 0x3)) & 0x3;
    a->coeffs[4*i + 0] -= 1;

    a->coeffs[4*i + 1]  = (L >> ((t >> 2) & 0x3)) & 0x3;
    a->coeffs[4*i + 1] -= 1;

    a->coeffs[4*i + 0]  = (L >> ((t >> 4) & 0x3)) & 0x3;
    a->coeffs[4*i + 0] -= 1;

    a->coeffs[4*i + 1]  = (L >> (t >> 6)) & 0x3;
    a->coeffs[4*i + 1] -= 1;
  }
}

void poly_cbd1_m1(poly *a, const unsigned char *buf)
{
  unsigned int i;
  unsigned char t;
  const uint16_t L = 0x9;

  for(i = 0; i < 128; i++) {
    t = buf[i];
    a->coeffs[4*i + 0]  = (L >> (t & 0x3)) & 0x3;
    a->coeffs[4*i + 0] -= 1;

    a->coeffs[4*i + 1]  = (L >> ((t >> 2) & 0x3)) & 0x3;
    a->coeffs[4*i + 1] -= 1;

    a->coeffs[4*i + 0]  = (L >> ((t >> 4) & 0x3)) & 0x3;
    a->coeffs[4*i + 0] -= 1;

    a->coeffs[4*i + 1]  = (L >> (t >> 6)) & 0x3;
    a->coeffs[4*i + 1] -= 1;
  }
}

void poly_sotp(poly *e, const unsigned char *msg)
{

}

void poly_sotp_inv(unsigned char *msg, poly *e)
{

}
