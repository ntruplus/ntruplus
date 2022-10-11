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

void poly_short2(poly *a, const unsigned char buf[NTRUPLUS_N/2]) {
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

/*************************************************
* Name:        cbd1
*
* Description: Given an array of uniformly random bytes, compute
*              polynomial with coefficients distributed according to
*              a centered binomial distribution with parameter eta=2
*
* Arguments:   - poly *r:                  pointer to output polynomial
*              - const unsigned char *buf: pointer to input byte array
**************************************************/
/*
static void cbd1(poly *r, const uint8_t *buf)
{
  unsigned int i;
  __m256i f0, f1, f2, f3, f4, f5, f6, f7, f8;
  __m256i r1, r2;
  const __m256i mask55 = _mm256_set1_epi32(0x55555555);
  const __m256i mask33 = _mm256_set1_epi32(0x33333333);
  const __m256i mask03 = _mm256_set1_epi32(0x03030303);
  const __m256i mask0F = _mm256_set1_epi32(0x0F0F0F0F);

  for(i = 0; i < NTRUPLUS_N/64; i++) {
    f0 = _mm256_load_si256((__m256i *)&buf[32*i]);

    f1 = _mm256_srli_epi16(f0, 1);
    f0 = _mm256_and_si256(mask55, f0);
    f1 = _mm256_and_si256(mask55, f1);
    f0 = _mm256_add_epi8(f0, mask55);
    f1 = _mm256_sub_epi8(f0, f1);

    f2 = _mm256_srli_epi16(f1, 2);
    f3 = _mm256_srli_epi16(f1, 4);
    f4 = _mm256_srli_epi16(f1, 6);
    f5 = _mm256_srli_epi16(f1, 8);
    f6 = _mm256_srli_epi16(f1, 10);
    f7 = _mm256_srli_epi16(f1, 12);
    f8 = _mm256_srli_epi16(f1, 14);

    f1 = _mm256_and_si256(mask33, f1);
    f2 = _mm256_and_si256(mask33, f2);
    f3 = _mm256_and_si256(mask33, f3);
    f4 = _mm256_and_si256(mask33, f4);
    f5 = _mm256_and_si256(mask33, f5);
    f6 = _mm256_and_si256(mask33, f6);
    f7 = _mm256_and_si256(mask33, f7);            
    f8 = _mm256_and_si256(mask33, f8);


    f0 = _mm256_unpacklo_epi8(f1, f2);
    f1 = _mm256_unpackhi_epi8(f1, f2);

    f2 = _mm256_unpacklo_epi8(f3, f4);
    f3 = _mm256_unpackhi_epi8(f3, f4);

    f4 = _mm256_unpacklo_epi8(f5, f6);
    f5 = _mm256_unpackhi_epi8(f5, f6);

    f6 = _mm256_unpacklo_epi8(f7, f8);
    f7 = _mm256_unpackhi_epi8(f7, f8);


    f0 = _mm256_unpacklo_epi16(f0, f2);
    f2 = _mm256_unpacklo_epi16(f0, f2);

    f1 = _mm256_unpackhi_epi16(f1, f3);
    f3 = _mm256_unpackhi_epi16(f1, f3);

    f4 = _mm256_unpacklo_epi16(f4, f6);
    f6 = _mm256_unpacklo_epi16(f4, f6);

    f5 = _mm256_unpackhi_epi16(f5, f7);
    f7 = _mm256_unpackhi_epi16(f5, f7);


    f0 = _mm256_unpacklo_epi32(f0, f2);
    f2 = _mm256_unpacklo_epi32(f0, f2);

    f1 = _mm256_unpackhi_epi32(f1, f3);
    f3 = _mm256_unpackhi_epi32(f1, f3);

    f4 = _mm256_unpacklo_epi32(f4, f6);
    f6 = _mm256_unpacklo_epi32(f4, f6);

    f5 = _mm256_unpackhi_epi32(f5, f7);
    f7 = _mm256_unpackhi_epi32(f5, f7);


    f0 = _mm256_unpacklo_epi64(f0, f2);
    f2 = _mm256_unpacklo_epi64(f0, f2);

    f1 = _mm256_unpackhi_epi64(f1, f3);
    f3 = _mm256_unpackhi_epi64(f1, f3);

    f4 = _mm256_unpacklo_epi64(f4, f6);
    f6 = _mm256_unpacklo_epi32(f4, f6);

    f5 = _mm256_unpackhi_epi64(f5, f7);
    f7 = _mm256_unpackhi_epi64(f5, f7);


    f0 = _mm256_unpacklo_epi128(f0, f2);
    f2 = _mm256_unpacklo_epi128(f0, f2);

    f1 = _mm256_unpackhi_epi128(f1, f3);
    f3 = _mm256_unpacklo_epi128(f1, f3);

    f4 = _mm256_unpacklo_epi128(f4, f6);
    f6 = _mm256_unpacklo_epi128(f4, f6);

    f5 = _mm256_unpacklo_epi128(f5, f7);
    f7 = _mm256_unpacklo_epi128(f5, f7);

    f0 = _mm256_cvtepi8_epi16(_mm256_castsi256_si128(f2));
    f1 = _mm256_cvtepi8_epi16(_mm256_extracti128_si256(f2,1));
    f2 = _mm256_cvtepi8_epi16(_mm256_castsi256_si128(f3));
    f3 = _mm256_cvtepi8_epi16(_mm256_extracti128_si256(f3,1));

    _mm256_store_si256((__m256i *)&r->coeffs[64*i+ 0], f0);
    _mm256_store_si256((__m256i *)&r->coeffs[64*i+16], f2);
    _mm256_store_si256((__m256i *)&r->coeffs[64*i+32], f1);
    _mm256_store_si256((__m256i *)&r->coeffs[64*i+48], f3);
  }
}

*/