#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "symmetric.h"

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
