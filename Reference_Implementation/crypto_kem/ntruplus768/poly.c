#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "ntt.h"
#include "reduce.h"
#include "symmetric.h"
#include "util.h"
#include "sha2.h"
#include "sotp.h"



/*
.global poly_pack_uniform
poly_pack_uniform:

xor		%eax,%eax
.p2align 5
_looptop_pack_uniform:
#load
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3

vpsllw		$12,%ymm1,%ymm15
vpaddw		%ymm15,%ymm0,%ymm0
vmovdqu		%ymm0,(%rdi)

vpsllw		$8,%ymm2,%ymm15
vpsrlw		$4,%ymm1,%ymm14
vpaddw		%ymm15,%ymm14,%ymm0
vmovdqu		%ymm0,32(%rdi)

vpsllw		$4,%ymm3,%ymm15
vpsrlw		$8,%ymm2,%ymm14
vpaddw		%ymm15,%ymm14,%ymm0
vmovdqu		%ymm0,64(%rdi)

add     $96,%rdi
add     $128,%rsi

add		$64,%eax
cmp		$768,%eax
jb		_looptop_pack_uniform

ret
*/

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
	unsigned int i;
	uint16_t t0, t1;

	for(i = 0; i < NTRUPLUS_N/2; i++)
	{
		t0 = a->coeffs[2*i];
		t1 = a->coeffs[2*i+1];
		r[3*i+0] = (t0 >> 0);
		r[3*i+1] = (t0 >> 8) | (t1 << 4);
		r[3*i+2] = (t1 >> 4);
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
	unsigned int i;
	for(i = 0; i < NTRUPLUS_N/2; i++)
	{
		r->coeffs[2*i]   = ((a[3*i+0] >> 0) | ((uint16_t)a[3*i+1] << 8)) & 0xFFF;
		r->coeffs[2*i+1] = ((a[3*i+1] >> 4) | ((uint16_t)a[3*i+2] << 4)) & 0xFFF;
	}
}
/*
void poly_pack_uniform(unsigned char *buf, const poly *a)
{
  int16_t tmp[768];

  //ntt_pack(tmp, a->coeffs);

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
*/
void poly_pack_short_partial(unsigned char *buf, const poly *a)
{
	for (int i = 0; i < 128; i++)
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
	for(int i = 0; i < NTRUPLUS_N; ++i)
	{
		b->coeffs[i] = 3*a->coeffs[i];
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
/*
void poly_cbd1(poly *a, const unsigned char *buf)
{
  unsigned int i,j,k;
  uint32_t t;

  for(i = 0; i < NTRUPLUS_N/128; i++)
  {
    for(j = 0; j < 8; j++)
    {
      t = load32_littleendian(buf + 32*i + 4*j);

      for(k = 0; k < 8; k++)
      {
        a->coeffs[128*i + 16*k + 2*j] = ((t >> (2*k)) & 0x1) - ((t >> (2*k+1)) & 0x1);
      }

      t = t >> 16;
 
      for(k = 0; k < 8; k++)
      {
        a->coeffs[128*i + 16*k + 2*j + 1] = ((t >> (2*k)) & 0x1) - ((t >> (2*k+1)) & 0x1);
      }
    }
  }
}
*/

//192 192
void poly_cbd1(poly *a, const unsigned char *buf)
{
	uint8_t t1;
	uint8_t t2;

	for (int i = 0; i < 96; i++)
	{
		t1 = buf[i];
		t2 = buf[i + 96];

		for (int j = 0; j < 8; j++)
		{
			a->coeffs[8*i+j] = ((t1 >> j) & 0x1) - ((t2 >> j) & 0x1);
		}
	}
}

void poly_cbd1_m1(poly *a, const unsigned char *buf)
{
	uint8_t t1;
	uint8_t t2;

	for (int i = 0; i < 64; i++)
	{
		t1 = buf[i];
		t2 = buf[i + 64];

		for (int j = 0; j < 8; j++)
		{
			a->coeffs[8*i+j] = ((t1 >> j) & 0x1) - ((t2 >> j) & 0x1);
		}
	}
}
/*
void poly_cbd1_m1(poly *a, const unsigned char *buf)
{
  unsigned int i,j,k;
  uint32_t t;

  for(i = 0; i < 4; i++)
  {
    for(j = 0; j < 8; j++)
    {
      t = load32_littleendian(buf + 32*i + 4*j);

      for(k = 0; k < 8; k++)
      {
        a->coeffs[128*i + 16*k + 2*j] = ((t >> (2*k)) & 0x1) - ((t >> (2*k+1)) & 0x1);
      }

      t = t >> 16;
 
      for(k = 0; k < 8; k++)
      {
        a->coeffs[128*i + 16*k + 2*j + 1] = ((t >> (2*k)) & 0x1) - ((t >> (2*k+1)) & 0x1);
      }
    }
  }
}
*/
/*
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
*/
void poly_sotp(poly *e, const unsigned char *msg)
{
  unsigned char buf[128] = {0};

  poly_pack_short_partial(buf, e);
  sha512(buf, buf, 128);
  sotp_internal(e, msg, buf);
}



void poly_sotp_inv(unsigned char *msg, poly *e)
{
  unsigned char buf[128] = {0};

  poly_pack_short_partial(buf, e);
  sha512(buf, buf, 128);
  sotp_inv_internal(msg, e, buf);
}
