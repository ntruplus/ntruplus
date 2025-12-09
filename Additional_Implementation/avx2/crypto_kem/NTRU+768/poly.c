#include <immintrin.h>

#include "params.h"
#include "poly.h"
#include "consts.h"

static inline void poly_baseinv_1(poly *r, __m256i den[12], const poly *a)
{
    __m256i ymm0, ymm1, ymm2, ymm3, ymm4, ymm5, ymm6, ymm7; 
    __m256i ymm8, ymm9, ymma, ymmb, ymmc, ymmd, ymme, ymmf;

    ymmf = _mm256_load_si256((const __m256i *)_16xqinv);
    ymm0 = _mm256_load_si256((const __m256i *)_16xq);

    for(size_t i = 0; i < 6; i++)
    {
        //zeta
        ymme = _mm256_load_si256((const __m256i *)&zetas[32*i + 624]); //zeta*qinv
        ymm1 = _mm256_load_si256((const __m256i *)&zetas[32*i + 640]); //zeta

        //load
        ymm2 = _mm256_load_si256((const __m256i *)&a->coeffs[128*i +  0]); //a[0]
        ymm3 = _mm256_load_si256((const __m256i *)&a->coeffs[128*i + 16]); //a[1]
        ymm4 = _mm256_load_si256((const __m256i *)&a->coeffs[128*i + 32]); //a[2]
        ymm5 = _mm256_load_si256((const __m256i *)&a->coeffs[128*i + 48]); //a[3]

        //premul
        ymmc = _mm256_mullo_epi16(ymm2, ymmf); //a[0]
        ymmd = _mm256_mullo_epi16(ymm3, ymmf); //a[1]

        //mul
        ymmb = _mm256_mullo_epi16(ymm2, ymmc); //a[0]*a[0]
        ymmc = _mm256_mullo_epi16(ymm4, ymmc); //a[0]*a[2]
        ymmd = _mm256_mullo_epi16(ymm3, ymmd); //a[1]*a[1]
        ymm6 = _mm256_mulhi_epi16(ymm2, ymm2);
        ymm7 = _mm256_mulhi_epi16(ymm4, ymm2);
        ymm8 = _mm256_mulhi_epi16(ymm3, ymm3);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymmc = _mm256_mulhi_epi16(ymmc, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymm6 = _mm256_sub_epi16(ymm6, ymmb); //a[0]*a[0]
        ymm7 = _mm256_sub_epi16(ymm7, ymmc); //a[0]*a[2]
        ymm8 = _mm256_sub_epi16(ymm8, ymmd); //a[1]*a[1]

        //add
        ymm7 = _mm256_add_epi16(ymm7, ymm7);
        ymm7 = _mm256_sub_epi16(ymm7, ymm8);

        //premul
        ymmc = _mm256_mullo_epi16(ymm4, ymmf); // a[2]
        ymmd = _mm256_mullo_epi16(ymm5, ymmf); // a[3]
        
        //mul
        ymmb = _mm256_mullo_epi16(ymm4, ymmc); //a[2]*a[2]
        ymmc = _mm256_mullo_epi16(ymm5, ymmd); //a[3]*a[3]
        ymmd = _mm256_mullo_epi16(ymm3, ymmd); //a[3]*a[1]
        ymm8 = _mm256_mulhi_epi16(ymm4, ymm4);
        ymm9 = _mm256_mulhi_epi16(ymm5, ymm5);
        ymma = _mm256_mulhi_epi16(ymm3, ymm5);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymmc = _mm256_mulhi_epi16(ymmc, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymm8 = _mm256_sub_epi16(ymm8, ymmb); //a[2]*a[2]
        ymm9 = _mm256_sub_epi16(ymm9, ymmc); //a[3]*a[3]
        ymma = _mm256_sub_epi16(ymma, ymmd); //a[3]*a[1]

        //add
        ymma = _mm256_add_epi16(ymma, ymma);
        ymm8 = _mm256_sub_epi16(ymm8, ymma);

        //mul
        ymmc = _mm256_mullo_epi16(ymm8, ymme);
        ymmd = _mm256_mullo_epi16(ymm9, ymme);
        ymm8 = _mm256_mulhi_epi16(ymm8, ymm1);
        ymm9 = _mm256_mulhi_epi16(ymm9, ymm1);

        //reduce
        ymmc = _mm256_mulhi_epi16(ymmc, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymm8 = _mm256_sub_epi16(ymm8, ymmc);
        ymm9 = _mm256_sub_epi16(ymm9, ymmd);

        //update
        ymm6 = _mm256_add_epi16(ymm6, ymm8); //t0
        ymm7 = _mm256_sub_epi16(ymm7, ymm9); //t1

        //premul
        ymmc = _mm256_mullo_epi16(ymm6, ymmf);
        ymmd = _mm256_mullo_epi16(ymm7, ymmf);

        //mul
        ymma = _mm256_mullo_epi16(ymm6, ymmc); 
        ymmb = _mm256_mullo_epi16(ymm7, ymmd);
        ymm8 = _mm256_mulhi_epi16(ymm6, ymm6);
        ymm9 = _mm256_mulhi_epi16(ymm7, ymm7);

        //reduce
        ymma = _mm256_mulhi_epi16(ymma, ymm0);
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymm8 = _mm256_sub_epi16(ymm8, ymma);
        ymm9 = _mm256_sub_epi16(ymm9, ymmb);

        //mul
        ymmb = _mm256_mullo_epi16(ymm9, ymme); 
        ymm9 = _mm256_mulhi_epi16(ymm9, ymm1);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymm9 = _mm256_sub_epi16(ymm9, ymmb);

        //add
        ymm8 = _mm256_sub_epi16(ymm8, ymm9); 

        //mul
        ymmb = _mm256_mullo_epi16(ymm4, ymme); 
        ymme = _mm256_mullo_epi16(ymm5, ymme);
        ymm9 = _mm256_mulhi_epi16(ymm4, ymm1);
        ymm1 = _mm256_mulhi_epi16(ymm5, ymm1);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymm9 = _mm256_sub_epi16(ymm9, ymmb); //a[2]*zeta
        ymm1 = _mm256_sub_epi16(ymm1, ymme); //a[3]*zeta

        //mul
        ymmb = _mm256_mullo_epi16(ymm9, ymmd); 
        ymme = _mm256_mullo_epi16(ymm1, ymmd);
        ymm9 = _mm256_mulhi_epi16(ymm9, ymm7);
        ymm1 = _mm256_mulhi_epi16(ymm1, ymm7);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymm9 = _mm256_sub_epi16(ymm9, ymmb); //a[2]*t1*zeta
        ymm1 = _mm256_sub_epi16(ymm1, ymme); //a[3]*t1*zeta

        //mul
        ymme = _mm256_mullo_epi16(ymm2, ymmd); 
        ymmd = _mm256_mullo_epi16(ymm3, ymmd);
        ymmb = _mm256_mulhi_epi16(ymm2, ymm7);
        ymm7 = _mm256_mulhi_epi16(ymm3, ymm7);

        //reduce
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymmb = _mm256_sub_epi16(ymmb, ymme); //a[0]*t1
        ymm7 = _mm256_sub_epi16(ymm7, ymmd); //a[1]*t1

        //mul
        ymme = _mm256_mullo_epi16(ymm2, ymmc); 
        ymmd = _mm256_mullo_epi16(ymm3, ymmc);
        ymm2 = _mm256_mulhi_epi16(ymm2, ymm6);
        ymm3 = _mm256_mulhi_epi16(ymm3, ymm6);

        //reduce
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymm2 = _mm256_sub_epi16(ymm2, ymme); //a[0]*t0
        ymm3 = _mm256_sub_epi16(ymm3, ymmd); //a[1]*t0

        //mul
        ymmd = _mm256_mullo_epi16(ymm4, ymmc); 
        ymme = _mm256_mullo_epi16(ymm5, ymmc);
        ymm4 = _mm256_mulhi_epi16(ymm4, ymm6);
        ymm5 = _mm256_mulhi_epi16(ymm5, ymm6);

        //reduce
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymm4 = _mm256_sub_epi16(ymm4, ymmd); //a[2]*t0
        ymm5 = _mm256_sub_epi16(ymm5, ymme); //a[3]*t0

        //add
        ymm2 = _mm256_sub_epi16(ymm2, ymm9);
        ymm3 = _mm256_sub_epi16(ymm3, ymm1);
        ymm4 = _mm256_sub_epi16(ymm4, ymmb);
        ymm5 = _mm256_sub_epi16(ymm5, ymm7);

        //store        
        _mm256_store_si256((__m256i *)&r->coeffs[128*i +  0], ymm2); //a[0]
        _mm256_store_si256((__m256i *)&r->coeffs[128*i + 16], ymm3); //a[1]
        _mm256_store_si256((__m256i *)&r->coeffs[128*i + 32], ymm4); //a[2]
        _mm256_store_si256((__m256i *)&r->coeffs[128*i + 48], ymm5); //a[3]

        //denominator
        den[2*i] = ymm8;

        //zeta
        ymme = _mm256_load_si256((const __m256i *)&zetas[32*i + 624]); //zeta*qinv
        ymm1 = _mm256_load_si256((const __m256i *)&zetas[32*i + 640]); //zeta

        //load
        ymm2 = _mm256_load_si256((const __m256i *)&a->coeffs[128*i +  64]); //a[0]
        ymm3 = _mm256_load_si256((const __m256i *)&a->coeffs[128*i +  80]); //a[1]
        ymm4 = _mm256_load_si256((const __m256i *)&a->coeffs[128*i +  96]); //a[2]
        ymm5 = _mm256_load_si256((const __m256i *)&a->coeffs[128*i + 112]); //a[3]

        //premul
        ymmc = _mm256_mullo_epi16(ymm2, ymmf); //a[0]
        ymmd = _mm256_mullo_epi16(ymm3, ymmf); //a[1]

        //mul
        ymmb = _mm256_mullo_epi16(ymm2, ymmc); //a[0]*a[0]
        ymmc = _mm256_mullo_epi16(ymm4, ymmc); //a[0]*a[2]
        ymmd = _mm256_mullo_epi16(ymm3, ymmd); //a[1]*a[1]
        ymm6 = _mm256_mulhi_epi16(ymm2, ymm2);
        ymm7 = _mm256_mulhi_epi16(ymm4, ymm2);
        ymm8 = _mm256_mulhi_epi16(ymm3, ymm3);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymmc = _mm256_mulhi_epi16(ymmc, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymm6 = _mm256_sub_epi16(ymm6, ymmb); //a[0]*a[0]
        ymm7 = _mm256_sub_epi16(ymm7, ymmc); //a[0]*a[2]
        ymm8 = _mm256_sub_epi16(ymm8, ymmd); //a[1]*a[1]

        //add
        ymm7 = _mm256_add_epi16(ymm7, ymm7);
        ymm7 = _mm256_sub_epi16(ymm7, ymm8);

        //premul
        ymmc = _mm256_mullo_epi16(ymm4, ymmf); // a[2]
        ymmd = _mm256_mullo_epi16(ymm5, ymmf); // a[3]
        
        //mul
        ymmb = _mm256_mullo_epi16(ymm4, ymmc); //a[2]*a[2]
        ymmc = _mm256_mullo_epi16(ymm5, ymmd); //a[3]*a[3]
        ymmd = _mm256_mullo_epi16(ymm3, ymmd); //a[3]*a[1]
        ymm8 = _mm256_mulhi_epi16(ymm4, ymm4);
        ymm9 = _mm256_mulhi_epi16(ymm5, ymm5);
        ymma = _mm256_mulhi_epi16(ymm3, ymm5);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymmc = _mm256_mulhi_epi16(ymmc, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymm8 = _mm256_sub_epi16(ymm8, ymmb); //a[2]*a[2]
        ymm9 = _mm256_sub_epi16(ymm9, ymmc); //a[3]*a[3]
        ymma = _mm256_sub_epi16(ymma, ymmd); //a[3]*a[1]

        //add
        ymma = _mm256_add_epi16(ymma, ymma);
        ymm8 = _mm256_sub_epi16(ymm8, ymma);

        //mul
        ymmc = _mm256_mullo_epi16(ymm8, ymme);
        ymmd = _mm256_mullo_epi16(ymm9, ymme);
        ymm8 = _mm256_mulhi_epi16(ymm8, ymm1);
        ymm9 = _mm256_mulhi_epi16(ymm9, ymm1);

        //reduce
        ymmc = _mm256_mulhi_epi16(ymmc, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymm8 = _mm256_sub_epi16(ymm8, ymmc);
        ymm9 = _mm256_sub_epi16(ymm9, ymmd);

        //update
        ymm6 = _mm256_sub_epi16(ymm6, ymm8); //t0
        ymm7 = _mm256_add_epi16(ymm7, ymm9); //t1

        //premul
        ymmc = _mm256_mullo_epi16(ymm6, ymmf);
        ymmd = _mm256_mullo_epi16(ymm7, ymmf);

        //mul
        ymma = _mm256_mullo_epi16(ymm6, ymmc); 
        ymmb = _mm256_mullo_epi16(ymm7, ymmd);
        ymm8 = _mm256_mulhi_epi16(ymm6, ymm6);
        ymm9 = _mm256_mulhi_epi16(ymm7, ymm7);

        //reduce
        ymma = _mm256_mulhi_epi16(ymma, ymm0);
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymm8 = _mm256_sub_epi16(ymm8, ymma);
        ymm9 = _mm256_sub_epi16(ymm9, ymmb);

        //mul
        ymmb = _mm256_mullo_epi16(ymm9, ymme); 
        ymm9 = _mm256_mulhi_epi16(ymm9, ymm1);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymm9 = _mm256_sub_epi16(ymm9, ymmb);

        //add
        ymm8 = _mm256_add_epi16( ymm8, ymm9); 

        //mul
        ymmb = _mm256_mullo_epi16(ymm4, ymme); 
        ymme = _mm256_mullo_epi16(ymm5, ymme);
        ymm9 = _mm256_mulhi_epi16(ymm4, ymm1);
        ymm1 = _mm256_mulhi_epi16(ymm5, ymm1);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymm9 = _mm256_sub_epi16(ymm9, ymmb); //a[2]*zeta
        ymm1 = _mm256_sub_epi16(ymm1, ymme); //a[3]*zeta

        //mul
        ymmb = _mm256_mullo_epi16(ymm9, ymmd); 
        ymme = _mm256_mullo_epi16(ymm1, ymmd);
        ymm9 = _mm256_mulhi_epi16(ymm9, ymm7);
        ymm1 = _mm256_mulhi_epi16(ymm1, ymm7);

        //reduce
        ymmb = _mm256_mulhi_epi16(ymmb, ymm0);
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymm9 = _mm256_sub_epi16(ymm9, ymmb); //a[2]*t1*zeta
        ymm1 = _mm256_sub_epi16(ymm1, ymme); //a[3]*t1*zeta

        //mul
        ymme = _mm256_mullo_epi16(ymm2, ymmd); 
        ymmd = _mm256_mullo_epi16(ymm3, ymmd);
        ymmb = _mm256_mulhi_epi16(ymm2, ymm7);
        ymm7 = _mm256_mulhi_epi16(ymm3, ymm7);

        //reduce
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymmb = _mm256_sub_epi16(ymmb, ymme); //a[0]*t1
        ymm7 = _mm256_sub_epi16(ymm7, ymmd); //a[1]*t1

        //mul
        ymme = _mm256_mullo_epi16(ymm2, ymmc); 
        ymmd = _mm256_mullo_epi16(ymm3, ymmc);
        ymm2 = _mm256_mulhi_epi16(ymm2, ymm6);
        ymm3 = _mm256_mulhi_epi16(ymm3, ymm6);

        //reduce
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymm2 = _mm256_sub_epi16(ymm2, ymme); //a[0]*t0
        ymm3 = _mm256_sub_epi16(ymm3, ymmd); //a[1]*t0

        //mul
        ymmd = _mm256_mullo_epi16(ymm4, ymmc); 
        ymme = _mm256_mullo_epi16(ymm5, ymmc);
        ymm4 = _mm256_mulhi_epi16(ymm4, ymm6);
        ymm5 = _mm256_mulhi_epi16(ymm5, ymm6);

        //reduce
        ymmd = _mm256_mulhi_epi16(ymmd, ymm0);
        ymme = _mm256_mulhi_epi16(ymme, ymm0);
        ymm4 = _mm256_sub_epi16(ymm4, ymmd); //a[2]*t0
        ymm5 = _mm256_sub_epi16(ymm5, ymme); //a[3]*t0

        //add
        ymm2 = _mm256_add_epi16(ymm2, ymm9);
        ymm3 = _mm256_add_epi16(ymm3, ymm1);
        ymm4 = _mm256_sub_epi16(ymm4, ymmb);
        ymm5 = _mm256_sub_epi16(ymm5, ymm7);

        //store        
        _mm256_store_si256((__m256i *)&r->coeffs[128*i +  64], ymm2); //a[0]
        _mm256_store_si256((__m256i *)&r->coeffs[128*i +  80], ymm3); //a[1]
        _mm256_store_si256((__m256i *)&r->coeffs[128*i +  96], ymm4); //a[2]
        _mm256_store_si256((__m256i *)&r->coeffs[128*i + 112], ymm5); //a[3]

        //denominator
        den[2*i+1] = ymm8;
    }
}


static inline __m256i fqinv_avx2(__m256i r)
{
    const __m256i qinv = _mm256_load_si256((const __m256i *)_16xqinv);
    const __m256i q    = _mm256_load_si256((const __m256i *)_16xq);

    __m256i l, h;
    __m256i R;
    __m256i t1, t2, t3;
    __m256i T1, T2;

    // 10 
    R  = _mm256_mullo_epi16(r, qinv);

    l  = _mm256_mullo_epi16(r, R);
    h  = _mm256_mulhi_epi16(r, r);
    l  = _mm256_mulhi_epi16(l, q);
    t1 = _mm256_sub_epi16(h, l);

    // 100 
    T1 = _mm256_mullo_epi16(t1, qinv);

    l  = _mm256_mullo_epi16(t1, T1);
    h  = _mm256_mulhi_epi16(t1, t1);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 1000 
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t2, T2);
    h  = _mm256_mulhi_epi16(t2, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 10000 
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t2, T2);
    h  = _mm256_mulhi_epi16(t2, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t3 = _mm256_sub_epi16(h, l);

    // 1010 
    l  = _mm256_mullo_epi16(t2, T1);
    h  = _mm256_mulhi_epi16(t2, t1);
    l  = _mm256_mulhi_epi16(l, q);
    t1 = _mm256_sub_epi16(h, l);

    // 11010 
    T1 = _mm256_mullo_epi16(t1, qinv);

    l  = _mm256_mullo_epi16(t3, T1);
    h  = _mm256_mulhi_epi16(t3, t1);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 110100 
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t2, T2);
    h  = _mm256_mulhi_epi16(t2, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 110101 
    l  = _mm256_mullo_epi16(t2, R);
    h  = _mm256_mulhi_epi16(t2, r);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 111111 
    l  = _mm256_mullo_epi16(t2, T1);
    h  = _mm256_mulhi_epi16(t2, t1);
    l  = _mm256_mulhi_epi16(l, q);
    t1 = _mm256_sub_epi16(h, l);

    // 1101010 
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t2, T2);
    h  = _mm256_mulhi_epi16(t2, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 11010100 
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t2, T2);
    h  = _mm256_mulhi_epi16(t2, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 110101000 
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t2, T2);
    h  = _mm256_mulhi_epi16(t2, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 1101010000 
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t2, T2);
    h  = _mm256_mulhi_epi16(t2, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 11010100000
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t2, T2);
    h  = _mm256_mulhi_epi16(t2, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 110101000000 
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t2, T2);
    h  = _mm256_mulhi_epi16(t2, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    // 110101111111 
    T2 = _mm256_mullo_epi16(t2, qinv);

    l  = _mm256_mullo_epi16(t1, T2);
    h  = _mm256_mulhi_epi16(t1, t2);
    l  = _mm256_mulhi_epi16(l, q);
    t2 = _mm256_sub_epi16(h, l);

    return t2;
}


static inline int poly_fqinv_batch(__m256i r[12], const __m256i a[12])
{
    const __m256i qinv = _mm256_load_si256((const __m256i *)_16xqinv);
    const __m256i q = _mm256_load_si256((const __m256i *)_16xq);

    __m256i t[12];
    __m256i A[12];

    __m256i l, h;
    __m256i inv, INV;

    __m256i mask_zero;

    for (int i = 1; i < 12; i++) {
        A[i] = _mm256_mullo_epi16(a[i], qinv);
    }

    t[0] = a[0];

    for (int i = 1; i < 12; i++) {
        l    = _mm256_mullo_epi16(t[i - 1], A[i]);
        h    = _mm256_mulhi_epi16(t[i - 1], a[i]);
        l    = _mm256_mulhi_epi16(l, q);
        t[i] = _mm256_sub_epi16(h, l);
    }

    inv = fqinv_avx2(t[11]);

    for (int i = 11; i > 0; i--) {
        INV = _mm256_mullo_epi16(inv, qinv);

        l    = _mm256_mullo_epi16(t[i - 1], INV);
        h    = _mm256_mulhi_epi16(t[i - 1], inv);
        l    = _mm256_mulhi_epi16(l, q);
        r[i] = _mm256_sub_epi16(h, l);

        l    = _mm256_mullo_epi16(inv, A[i]);
        h    = _mm256_mulhi_epi16(inv, a[i]);
        l    = _mm256_mulhi_epi16(l, q);
        inv  = _mm256_sub_epi16(h, l);
    }

    r[0] = inv;

    mask_zero = _mm256_cmpeq_epi16(inv, _mm256_setzero_si256());
    
    if (_mm256_movemask_epi8(mask_zero) != 0) {
        return 1;
    }

    return 0;
}

static inline void poly_baseinv_2(poly *r, const __m256i den[12])
{
    __m256i l, h, t, T;

    const __m256i qinv     = _mm256_load_si256((const __m256i *)_16xqinv);
    const __m256i q        = _mm256_load_si256((const __m256i *)_16xq);
    const __m256i Rinvqinv = _mm256_load_si256((const __m256i *)_16xRinvqinv);
    const __m256i Rinv     = _mm256_load_si256((const __m256i *)_16xRinv);

    for (size_t i = 0; i < 12; i++) {
        __m256i r0 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i +  0]);
        __m256i r1 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i + 16]);
        __m256i r2 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i + 32]);
        __m256i r3 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i + 48]);

        l = _mm256_mullo_epi16(den[i], Rinvqinv);
        h = _mm256_mulhi_epi16(den[i], Rinv);
        l = _mm256_mulhi_epi16(l, q);
        t = _mm256_sub_epi16(h, l);

        T = _mm256_mullo_epi16(t, qinv);

        l  = _mm256_mullo_epi16(r0, T);
        h  = _mm256_mulhi_epi16(r0, t);
        l  = _mm256_mulhi_epi16(l, q);
        r0 = _mm256_sub_epi16(h, l);

        l  = _mm256_mullo_epi16(r1, T);
        h  = _mm256_mulhi_epi16(r1, t);
        l  = _mm256_mulhi_epi16(l, q);
        r1 = _mm256_sub_epi16(l, h);

        l  = _mm256_mullo_epi16(r2, T);
        h  = _mm256_mulhi_epi16(r2, t);
        l  = _mm256_mulhi_epi16(l, q);
        r2 = _mm256_sub_epi16(h, l);

        l  = _mm256_mullo_epi16(r3, T);
        h  = _mm256_mulhi_epi16(r3, t);
        l  = _mm256_mulhi_epi16(l, q);
        r3 = _mm256_sub_epi16(l, h);

        _mm256_store_si256((__m256i *)&r->coeffs[64*i +  0], r0);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 16], r1);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 32], r2);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 48], r3);
    }
}

int  poly_baseinv(poly *r, const poly *a)
{
    __m256i den1[12];
    __m256i den2[12];

    poly_baseinv_1(r, den1, a);

    if(poly_fqinv_batch(den2, den1)) return 1;

    poly_baseinv_2(r, den2);

    return 0;
}

/*************************************************
* Name:        poly_sotp_decode
*
* Description: Decode a message deterministically using SOTP_INV and a random
*
* Arguments:   - uint8_t *msg: pointer to output message
*              - const poly *a: pointer to iput polynomial
*              - const uint8_t *buf: pointer to input random
*
* Returns 0 (success) or 1 (failure)
**************************************************/
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N/8], const poly *a, const uint8_t buf[NTRUPLUS_N/4])
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
