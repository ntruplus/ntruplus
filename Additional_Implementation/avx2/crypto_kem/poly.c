#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "reduce.h"
#include "symmetric.h"
#include "sotp.h"

void poly_sotp(poly *e, const unsigned char *msg)
{
  unsigned char buf[128] = {0};

  poly_pack_short_partial(buf, e);
  SHA512(buf, 128, buf);
  sotp_internal(e, msg, buf);
}

void poly_sotp_inv(unsigned char *msg, poly *e)
{
  unsigned char buf[128] = {0};

  poly_pack_short_partial(buf, e);
  SHA512(buf, 128, buf);
  sotp_inv_internal(msg, e, buf);
}

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