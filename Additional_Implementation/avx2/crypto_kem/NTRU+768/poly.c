#include <immintrin.h>

#include "params.h"
#include "poly.h"

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
    const __m256i ymm0 = _mm256_set1_epi8((char)0x55);
    const __m256i ymm1 = _mm256_set1_epi8((char)0xff);
    const __m256i ymm2 = _mm256_set1_epi8((char)0x01);
    const __m256i mask1 = _mm256_set1_epi16((int16_t)0x00ff);
    const __m256i mask2 = _mm256_set1_epi16((int16_t)0xff00);
          __m256i ymmf = _mm256_set1_epi8((char)0xff);

    __m256i ymm3, ymm4, ymm5, ymm6, ymm7, ymm8, ymm9, ymma, ymmb, ymmc, ymmd, ymme;
    __m256i t0, t1, t2, t3;
    __m256i a0, a1, a2, a3, a4, a5, a6, a7;


    for (size_t i = 0; i < NTRUPLUS_N / 256; i++) 
    {
        ymm7 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i +  0]);
        ymm8 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 64]);
        ymm9 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 128]);
        ymma = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 192]);    
        ymmb = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 16]);
        ymmc = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 80]);
        ymmd = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 144]);
        ymme = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 208]);

        ymm3 = _mm256_packs_epi16(ymm7, ymm8);      
        ymm4 = _mm256_packs_epi16(ymm9, ymma);
        ymm5 = _mm256_packs_epi16(ymmb, ymmc);
        ymm6 = _mm256_packs_epi16(ymmd, ymme);

        ymm7 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 32]);
        ymm8 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 96]);
        ymm9 = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 160]);
        ymma = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 224]);
        ymmb = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 48]);
        ymmc = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 112]);
        ymmd = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 176]);
        ymme = _mm256_load_si256((const __m256i *)&a->coeffs[256*i + 240]);

        ymm7 = _mm256_packs_epi16(ymm7, ymm8);
        ymm8 = _mm256_packs_epi16(ymm9, ymma);
        ymm9 = _mm256_packs_epi16(ymmb, ymmc);
        ymma = _mm256_packs_epi16(ymmd, ymme);

        ymmb = _mm256_permute2x128_si256(ymm3, ymm4, 0x20);
        ymmc = _mm256_permute2x128_si256(ymm3, ymm4, 0x31);
        ymmd = _mm256_permute2x128_si256(ymm5, ymm6, 0x20);
        ymme = _mm256_permute2x128_si256(ymm5, ymm6, 0x31);
        ymm3 = _mm256_permute2x128_si256(ymm7, ymm8, 0x20);
        ymm4 = _mm256_permute2x128_si256(ymm7, ymm8, 0x31);
        ymm5 = _mm256_permute2x128_si256(ymm9, ymma, 0x20);
        ymm6 = _mm256_permute2x128_si256(ymm9, ymma, 0x31);

        ymm7 = _mm256_slli_epi64(ymm3, 32);
        ymm8 = _mm256_srli_epi64(ymmb, 32);
        ymm9 = _mm256_slli_epi64(ymm4, 32);
        ymma = _mm256_srli_epi64(ymmc, 32);

        ymm7 = _mm256_blend_epi32(ymmb, ymm7, 0xaa);
        ymm8 = _mm256_blend_epi32(ymm3, ymm8, 0x55);
        ymm9 = _mm256_blend_epi32(ymmc, ymm9, 0xaa);
        ymma = _mm256_blend_epi32(ymm4, ymma, 0x55);

        ymmb = _mm256_slli_epi64(ymm5, 32);
        ymmc = _mm256_srli_epi64(ymmd, 32);
        ymm3 = _mm256_slli_epi64(ymm6, 32);
        ymm4 = _mm256_srli_epi64(ymme, 32);

        ymmb = _mm256_blend_epi32(ymmd, ymmb, 0xaa);
        ymmc = _mm256_blend_epi32(ymm5, ymmc, 0x55);
        ymmd = _mm256_blend_epi32(ymme, ymm3, 0xaa);
        ymme = _mm256_blend_epi32(ymm6, ymm4, 0x55);

        ymm3 = _mm256_slli_epi32(ymmb, 16);
        ymm4 = _mm256_srli_epi32(ymm7, 16);
        ymm5 = _mm256_slli_epi32(ymmc, 16);
        ymm6 = _mm256_srli_epi32(ymm8, 16);

        ymm3 = _mm256_blend_epi16(ymm7, ymm3, 0xaa);
        ymm4 = _mm256_blend_epi16(ymmb, ymm4, 0x55);
        ymm5 = _mm256_blend_epi16(ymm8, ymm5, 0xaa);
        ymm6 = _mm256_blend_epi16(ymmc, ymm6, 0x55);

        ymm7 = _mm256_slli_epi32(ymmd, 16);
        ymm8 = _mm256_srli_epi32(ymm9, 16);
        ymmb = _mm256_slli_epi32(ymme, 16);
        ymmc = _mm256_srli_epi32(ymma, 16);

        ymm7 = _mm256_blend_epi16(ymm9, ymm7, 0xaa);
        ymm8 = _mm256_blend_epi16(ymmd, ymm8, 0x55);
        ymm9 = _mm256_blend_epi16(ymma, ymmb, 0xaa);
        ymma = _mm256_blend_epi16(ymme, ymmc, 0x55);

        ymmb = _mm256_and_si256(ymm3, mask1);
        ymmc = _mm256_slli_epi16(ymm7, 8);
        ymm3 = _mm256_srli_epi16(ymm3, 8);
        ymm7 = _mm256_and_si256(ymm7, mask2);

        ymmd = _mm256_and_si256(ymm4, mask1);
        ymme = _mm256_slli_epi16(ymm8, 8);
        ymm4 = _mm256_srli_epi16(ymm4, 8);
        ymm8 = _mm256_and_si256(ymm8, mask2);

        a0 = _mm256_xor_si256(ymmb, ymmc);
        a1 = _mm256_xor_si256(ymm3, ymm7);
        a2 = _mm256_xor_si256(ymmd, ymme);
        a3 = _mm256_xor_si256(ymm4, ymm8);

        t0 = _mm256_and_si256(ymm5, mask1);
        t2 = _mm256_slli_epi16(ymm9, 8);
        ymm5 = _mm256_srli_epi16(ymm5, 8);
        ymm9 = _mm256_and_si256(ymm9, mask2);

        t1 = _mm256_and_si256(ymm6, mask1);
        t3 = _mm256_slli_epi16(ymma, 8);
        ymm6 = _mm256_srli_epi16(ymm6, 8);
        ymma = _mm256_and_si256(ymma, mask2);

        a4 = _mm256_xor_si256(t0, t2);
        a5 = _mm256_xor_si256(ymm5, ymm9);
        a6 = _mm256_xor_si256(t1, t3);        
        a7 = _mm256_xor_si256(ymm6, ymma);

        ymm7 = a0;
        ymm8 = a1;
        ymm9 = a2;
        ymma = a3;
        ymmb = a4;
        ymmc = a5;
        ymmd = a6;
        ymme = a7;

        ymm3 = _mm256_add_epi8(ymm7, ymm2);
        ymm4 = _mm256_add_epi8(ymm8, ymm2);
        ymm5 = _mm256_add_epi8(ymm9, ymm2);
        ymm6 = _mm256_add_epi8(ymma, ymm2);
        ymm7 = _mm256_add_epi8(ymmb, ymm2);
        ymm8 = _mm256_add_epi8(ymmc, ymm2);
        ymm9 = _mm256_add_epi8(ymmd, ymm2);
        ymma = _mm256_add_epi8(ymme, ymm2);

        ymm5 = _mm256_slli_epi16(ymm5, 2);
        ymm6 = _mm256_slli_epi16(ymm6, 2);
        ymm7 = _mm256_slli_epi16(ymm7, 4);
        ymm8 = _mm256_slli_epi16(ymm8, 4);
        ymm9 = _mm256_slli_epi16(ymm9, 6);
        ymma = _mm256_slli_epi16(ymma, 6);

        ymm5 = _mm256_xor_si256(ymm3, ymm5);
        ymm6 = _mm256_xor_si256(ymm4, ymm6);
        ymm7 = _mm256_xor_si256(ymm7, ymm9);
        ymm8 = _mm256_xor_si256(ymm8, ymma);

        ymm3 = _mm256_xor_si256(ymm5, ymm7);
        ymm4 = _mm256_xor_si256(ymm6, ymm8);

        ymm5 = _mm256_loadu_si256((const __m256i *)&buf[32*i]);
        ymm6 = _mm256_loadu_si256((const __m256i *)&buf[32*i + NTRUPLUS_N / 8]);

        ymm7 = _mm256_srli_epi16(ymm6, 1);

        ymm6 = _mm256_and_si256(ymm6, ymm0);
        ymm7 = _mm256_and_si256(ymm7, ymm0);

        ymm3 = _mm256_add_epi8(ymm3, ymm6);
        ymm4 = _mm256_add_epi8(ymm4, ymm7);

        //handling error
        ymm6 = _mm256_srli_epi16(ymm3, 1);
        ymm7 = _mm256_srli_epi16(ymm4, 1);

        ymm6 = _mm256_xor_si256(ymm3, ymm6);
        ymm7 = _mm256_xor_si256(ymm4, ymm7);

        ymm6 = _mm256_and_si256(ymm6, ymm7);
        ymmf = _mm256_and_si256(ymmf, ymm6);

        //extract bits
        ymm3 = _mm256_and_si256(ymm3, ymm0);
        ymm4 = _mm256_and_si256(ymm4, ymm0);
        ymm4 = _mm256_slli_epi16(ymm4, 1);

        ymm3 = _mm256_xor_si256(ymm3, ymm4);
        ymm3 = _mm256_xor_si256(ymm3, ymm1);
        
        ymm3 = _mm256_xor_si256(ymm3, ymm5);

        _mm256_storeu_si256((__m256i *)&msg[32*i], ymm3);
    }

    ymmf = _mm256_xor_si256(ymmf, ymm1);
    ymmf = _mm256_and_si256(ymmf, ymm0);

    return !_mm256_testz_si256(ymmf, ymmf);
}
