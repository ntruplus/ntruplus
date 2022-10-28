#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "reduce.h"
#include "symmetric.h"
#include "sotp.h"
/*
void poly_sotp(poly *e, const unsigned char *msg, const unsigned char *buf)
{
    uint8_t tmp[NTRUPLUS_N/4];
    uint32_t t1, t2;

    for(int i = 0; i < NTRUPLUS_N/8; i++)
    {
         tmp[i] = buf[i]^msg[i];
    }

    for(int i = NTRUPLUS_N/8; i < NTRUPLUS_N/4; i++)
    {
         tmp[i] = buf[i];
    }

    for(int i = 0; i < 18; i++)
    {
        t1 = load32_littleendian(tmp + 4*i);
        t2 = load32_littleendian(buf + 4*i + 72);

        for (int j = 0; j < 32; j++)
        {
            e->coeffs[32*i + j] = (t1 & 0x1) - (t2 & 0x1);

            t1 = t1 >> 1;
            t2 = t2 >> 1;
        }
    }
}
*/
/*
void poly_sotp_inv(unsigned char *msg, const poly *e, const unsigned char *buf)
{
    uint8_t tmp[64];
	uint32_t t1, t2, t3;

    for(int i = 0; i < 18; i++)
    {
        t1 = load32_littleendian(buf + 4*i);
        t2 = load32_littleendian(buf + 4*i + 72);
        t3 = 0;

        for (int j = 0; j < 32; j++)
        {
            t3 ^= (((e->coeffs[32*i + j] + (t2 & 0x1)) & 0x1)^(t1 & 0x1)) << j;

            t1 = t1 >> 1;
            t2 = t2 >> 1;
        }
        
        msg[4*i] = t3;
        msg[4*i+1] = t3 >> 8;
        msg[4*i+2] = t3 >> 16;
        msg[4*i+3] = t3 >> 24;
    }
}
*/
static int16_t crepmod3(int16_t a)
{
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
  {
    b->coeffs[i] = crepmod3(a->coeffs[i]);
  }
}

/*************************************************
* Name:        load32_littleendian
*
* Description: load 4 bytes into a 32-bit integer
*              in little-endian order
*
* Arguments:   - const uint8_t *x: pointer to input byte array
*
* Returns 32-bit unsigned integer loaded from x
**************************************************/
uint32_t load32_littleendian(const uint8_t x[4])
{
  uint32_t r;
  r  = (uint32_t)x[0];
  r |= (uint32_t)x[1] << 8;
  r |= (uint32_t)x[2] << 16;
  r |= (uint32_t)x[3] << 24;
  return r;
}
/*void poly_short2(poly *a, const unsigned char buf[NTRUPLUS_N/2]) {
  unsigned int i;
  unsigned char t;
  const uint16_t L = 0x9;

  for(i = 0; i < NTRUPLUS_N/4; ++i) {
    t = buf[i];
    a->coeffs[4*i + 0]  = (L >> (t & 0x3)) & 0x3;
    a->coeffs[4*i + 0] -= 1;

    a->coeffs[4*i + 1]  = (L >> ((t >> 2) & 0x3)) & 0x3;
    a->coeffs[4*i + 1] -= 1;

    a->coeffs[4*i + 2]  = (L >> ((t >> 4) & 0x3)) & 0x3;
    a->coeffs[4*i + 2] -= 1;

    a->coeffs[4*i + 3]  = (L >> ((t >> 6) & 0x3)) & 0x3;
    a->coeffs[4*i + 3] -= 1;
  }
}

void poly_short3(poly *a, const unsigned char buf[NTRUPLUS_N/2]) {
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
