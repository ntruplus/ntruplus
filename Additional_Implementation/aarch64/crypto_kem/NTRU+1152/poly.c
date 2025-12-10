#include "poly.h"
#include <arm_neon.h>

static const int16_t zetas_mul[] __attribute__((aligned(16))) = {
    0x0d81, 0x4bd4, 0xcd7f, 0xff6d, 0xfa8f, 0xf9dd, 0xc5d5, 0x0000,
    0xfad5, 0x00a3, 0x0135, 0x03d5, 0xfdd3, 0xfefe, 0x00e8, 0xf970,
    0x052b, 0xff5d, 0xfecb, 0xfc2b, 0x022d, 0x0102, 0xff18, 0x0690,
    0xf987, 0xfb2f, 0x0090, 0x06a3, 0x0137, 0xfbdc, 0x0242, 0x0512,
    0x0679, 0x04d1, 0xff70, 0xf95d, 0xfec9, 0x0424, 0xfdbe, 0xfaee,
    0xfe6d, 0x0647, 0x0432, 0xff6c, 0x01bf, 0xf9e0, 0x0476, 0xfe6e,
    0x0193, 0xf9b9, 0xfbce, 0x0094, 0xfe41, 0x0620, 0xfb8a, 0x0192,
    0xfa7c, 0xfd91, 0x0357, 0x016d, 0xff9e, 0xff0c, 0x0197, 0x04c9,
    0x0584, 0x026f, 0xfca9, 0xfe93, 0x0062, 0x00f4, 0xfe69, 0xfb37,
    0x01a0, 0x02ab, 0xff97, 0x06b2, 0xfc05, 0x0425, 0x048b, 0x027e,
    0xfe60, 0xfd55, 0x0069, 0xf94e, 0x03fb, 0xfbdb, 0xfb75, 0xfd82,
    0x031e, 0x05d5, 0xfea1, 0x018c, 0xfde2, 0xfff7, 0x0650, 0xff75,
    0xfce2, 0xfa2b, 0x015f, 0xfe74, 0x021e, 0x0009, 0xf9b0, 0x008b,
    0xfc25, 0xfe1e, 0x0379, 0x00ee, 0xfa17, 0x01d2, 0xfbbf, 0xff9b,
    0x03db, 0x01e2, 0xfc87, 0xff12, 0x05e9, 0xfe2e, 0x0441, 0x0065,
    0x0351, 0xfe56, 0x0635, 0x05cf, 0x029f, 0x05b3, 0xfcf8, 0x00ff,
    0xfcaf, 0x01aa, 0xf9cb, 0xfa31, 0xfd61, 0xfa4d, 0x0308, 0xff01,
    0xfc0a, 0x0478, 0x01d8, 0xfb7f, 0xfebb, 0x05ef, 0xffe6, 0xfb9d,
    0x03f6, 0xfb88, 0xfe28, 0x0481, 0x0145, 0xfa11, 0x001a, 0x0463,
    0x0144, 0x04ce, 0x060b, 0xfdaf, 0xfe54, 0x04a8, 0x0430, 0xf9e4,
    0xfebc, 0xfb32, 0xf9f5, 0x0251, 0x01ac, 0xfb58, 0xfbd0, 0x061c,
    0x02b0, 0xfeb3, 0x03ff, 0xf96a, 0x0349, 0x0338, 0xffb9, 0x0633,
    0xfd50, 0x014d, 0xfc01, 0x0696, 0xfcb7, 0xfcc8, 0x0047, 0xf9cd,
    0x020a, 0xfebd, 0x047c, 0x0185, 0x04cf, 0x0180, 0x053f, 0x00a9,
    0xfdf6, 0x0143, 0xfb84, 0xfe7b, 0xfb31, 0xfe80, 0xfac1, 0xff57,
    0x0274, 0xfacf, 0xfbe0, 0xfc58, 0x0018, 0xfedb, 0x05f3, 0xfed4,
    0xfd8c, 0x0531, 0x0420, 0x03a8, 0xffe8, 0x0125, 0xfa0d, 0x012c,
    0xf98a, 0x037b, 0xfc3e, 0xffbd, 0x00b3, 0xfb67, 0x034c, 0xfe03,
    0x0676, 0xfc85, 0x03c2, 0x0043, 0xff4d, 0x0499, 0xfcb4, 0x01fd,
    0xf973, 0xf9e3, 0xfddb, 0xfa1c, 0x04a7, 0xfee8, 0xffd5, 0x029d,
    0x068d, 0x061d, 0x0225, 0x05e4, 0xfb59, 0x0118, 0x002b, 0xfd63,
    0xfd16, 0x02f1, 0x0302, 0xfbea, 0x06af, 0x059e, 0x02b2, 0x043b,
    0x02ea, 0xfd0f, 0xfcfe, 0x0416, 0xf951, 0xfa62, 0xfd4e, 0xfbc5,
    0x0426, 0x06bf, 0xfc8d, 0x0229, 0x0686, 0x0042, 0x0339, 0xff7b,
    0xfbda, 0xf941, 0x0373, 0xfdd7, 0xf97a, 0xffbe, 0xfcc7, 0x0085,
    0xf9ce, 0x027d, 0xfd58, 0xfc6b, 0x0284, 0xfe8c, 0xfb57, 0xfb90,
    0x0632, 0xfd83, 0x02a8, 0x0395, 0xfd7c, 0x0174, 0x04a9, 0x0470,
};

static inline int16x8_t fqmul_neon(int16x8_t x, int16x8_t y, int16x8_t zeta)
{
    int32x4_t l, h;
    int16x8_t t;

    l  = vmull_s16(vget_low_s16(x), vget_low_s16(y));
    h  = vmull_high_s16(x, y);

    t  = vuzp1q_s16(vreinterpretq_s16_s32(l),
                    vreinterpretq_s16_s32(h));
    t  = vmulq_laneq_s16(t, zeta, 2);

    l  = vmlal_lane_s16(l, vget_low_s16(t), vget_low_s16(zeta), 0);
    h  = vmlal_high_lane_s16(h, t, vget_low_s16(zeta), 0);

    return vuzp2q_s16(vreinterpretq_s16_s32(l),
                      vreinterpretq_s16_s32(h));
}

static inline int16x8_t fqinv_neon(int16x8_t a)
{
    int16x8_t t1, t2, t3;
    int16x8_t zeta = vld1q_s16(zetas_mul); // Plantard/Montgomery 상수들

    t1 = fqmul_neon(a,  a,  zeta); // 10
    t2 = fqmul_neon(t1, t1, zeta); // 100
    t2 = fqmul_neon(t2, t2, zeta); // 1000
    t3 = fqmul_neon(t2, t2, zeta); // 10000

    t1 = fqmul_neon(t1, t2, zeta); // 1010

    t2 = fqmul_neon(t1, t3, zeta); // 11010
    t2 = fqmul_neon(t2, t2, zeta); // 110100
    t2 = fqmul_neon(t2, a,  zeta); // 110101

    t1 = fqmul_neon(t1, t2, zeta); // 111111

    t2 = fqmul_neon(t2, t2, zeta); // 1101010
    t2 = fqmul_neon(t2, t2, zeta); // 11010100
    t2 = fqmul_neon(t2, t2, zeta); // 110101000
    t2 = fqmul_neon(t2, t2, zeta); // 1101010000
    t2 = fqmul_neon(t2, t2, zeta); // 11010100000
    t2 = fqmul_neon(t2, t2, zeta); // 110101000000
    t2 = fqmul_neon(t2, t1, zeta); // 110101111111

    return t2;
}

static inline int poly_fqinv_batch(int16x8_t r[36], const int16x8_t a[36])
{
    int16x8_t zeta = vld1q_s16(zetas_mul);

    int16x8_t c[36];

    int16x8_t inv, t;

    c[0] = a[0];

    for (int i = 1; i < 36; i++) {
        c[i] = fqmul_neon(c[i - 1], a[i], zeta);
    }

    inv = fqinv_neon(c[35]);

    t   = vqrdmulhq_laneq_s16(inv, zeta, 6);
    inv = vmulq_laneq_s16(inv, zeta, 5);
    inv = vmlsq_laneq_s16(inv, t, zeta, 0);

    for (int i = 35; i > 0; i--)
    {
        r[i] = fqmul_neon(c[i - 1], inv, zeta);
        inv = fqmul_neon(inv, a[i], zeta);
    }

    r[0] = inv;

    uint16x4_t lo = vget_low_u16(inv);
    uint16x4_t hi = vget_high_u16(inv);
    uint16x4_t m1 = vpmin_u16(lo, hi);
    uint16x4_t m2 = vpmin_u16(m1, m1);
    uint16x4_t m3 = vpmin_u16(m2, m2);
    uint16_t min_all = vget_lane_u16(m3, 0);

    if (min_all == 0) {
        return 1;
    }

    return 0;
}

void poly_baseinv_1(poly *r, int16x8_t* den, const poly* a);
static void poly_baseinv_2(poly *r, int16x8_t *den)
{
    int16_t  *rp   = r->coeffs;
    int16x8_t zeta = vld1q_s16(zetas_mul);

    for (int i = 0; i < 36; i++)
    {
        int16x8_t pden = den[i];
        int16x8_t mden = vnegq_s16(den[i]);

        int offset = i * 32;

        int16x8_t r0 = vld1q_s16(rp + offset +  0);
        int16x8_t r1 = vld1q_s16(rp + offset +  8);
        int16x8_t r2 = vld1q_s16(rp + offset + 16);
        int16x8_t r3 = vld1q_s16(rp + offset + 24);

        r0 = fqmul_neon(r0, pden, zeta);
        r1 = fqmul_neon(r1, mden, zeta);
        r2 = fqmul_neon(r2, pden, zeta);
        r3 = fqmul_neon(r3, mden, zeta);

        vst1q_s16(rp + offset +  0, r0);
        vst1q_s16(rp + offset +  8, r1);
        vst1q_s16(rp + offset + 16, r2);
        vst1q_s16(rp + offset + 24, r3);
    }
}

int  poly_baseinv(poly *r, const poly *a)
{
    int16x8_t den1[36];
    int16x8_t den2[36];

    poly_baseinv_1(r, den1, a);

    if(poly_fqinv_batch(den2, den1)) return 1;

    poly_baseinv_2(r, den2);

    return 0;
}
