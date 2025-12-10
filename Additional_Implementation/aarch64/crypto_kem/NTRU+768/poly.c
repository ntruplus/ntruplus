#include "poly.h"
#include <arm_neon.h>

static const int16_t zetas_mul[] __attribute__((aligned(16))) = {
    0x0d81, 0x4bd4, 0xcd7f, 0xff6d, 0xfa8f, 0xf9dd, 0xc5d5, 0x0000,
    0x00df, 0x0472, 0xfbdd, 0xfe73, 0xff49, 0x0677, 0x022f, 0xf976,
    0xff21, 0xfb8e, 0x0423, 0x018d, 0x00b7, 0xf989, 0xfdd1, 0x068a,
    0x0115, 0x03a5, 0x06bb, 0x01b5, 0xfa16, 0x00f2, 0x0668, 0x01b0,
    0xfeeb, 0xfc5b, 0xf945, 0xfe4b, 0x05ea, 0xff0e, 0xf998, 0xfe50,
    0xf9d1, 0x02b8, 0x0306, 0x0687, 0x039f, 0x0202, 0x0200, 0x01e9,
    0x062f, 0xfd48, 0xfcfa, 0xf979, 0xfc61, 0xfdfe, 0xfe00, 0xfe17,
    0x0129, 0x0259, 0x05c1, 0x046a, 0x052a, 0x0367, 0x02f8, 0x04bc,
    0xfed7, 0xfda7, 0xfa3f, 0xfb96, 0xfad6, 0xfc99, 0xfd08, 0xfb44,
    0xfec8, 0xfea0, 0x01bb, 0x03af, 0x0008, 0x04e2, 0xff9c, 0x067c,
    0x0138, 0x0160, 0xfe45, 0xfc51, 0xfff8, 0xfb1e, 0x0064, 0xf984,
    0xffe1, 0x04b6, 0xfac3, 0xfb21, 0x01bc, 0x00eb, 0x0554, 0xfb47,
    0x001f, 0xfb4a, 0x053d, 0x04df, 0xfe44, 0xff15, 0xfaac, 0x04b9,
    0x0169, 0x00e6, 0x02a1, 0x0246, 0x0581, 0x05dd, 0x0579, 0x00fb,
    0xfe97, 0xff1a, 0xfd5f, 0xfdba, 0xfa7f, 0xfa23, 0xfa87, 0xff05,
    0x03fe, 0xfbd9, 0x041d, 0x04a4, 0x01a1, 0xfa91, 0xffe5, 0xf9a6,
    0xfc02, 0x0427, 0xfbe3, 0xfb5c, 0xfe5f, 0x056f, 0x001b, 0x065a,
    0x0695, 0xfec5, 0x0580, 0xfb20, 0x0190, 0x0112, 0xf9f9, 0x0020,
    0xf96b, 0x013b, 0xfa80, 0x04e0, 0xfe70, 0xfeee, 0x0607, 0xffe0,
    0xf9f2, 0x05fb, 0xfaa9, 0xff84, 0x05b2, 0x0563, 0xfc54, 0xf96f,
    0x060e, 0xfa05, 0x0557, 0x007c, 0xfa4e, 0xfa9d, 0x03ac, 0x0691,
    0x0016, 0x06ad, 0xfeed, 0x0454, 0x0162, 0xf940, 0xfc38, 0x035a,
    0xffea, 0xf953, 0x0113, 0xfbac, 0xfe9e, 0x06c0, 0x03c8, 0xfca6,
    0x04c5, 0xff26, 0x0126, 0xfd24, 0xfbb9, 0x037c, 0x0634, 0xfcf5,
    0xfb3b, 0x00da, 0xfeda, 0x02dc, 0x0447, 0xfc84, 0xf9cc, 0x030b,
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

static inline int poly_fqinv_batch(int16x8_t r[24], const int16x8_t a[24])
{
    int16x8_t zeta = vld1q_s16(zetas_mul);

    int16x8_t c[24];

    int16x8_t inv, t;

    c[0] = a[0];

    for (int i = 1; i < 24; i++) {
        c[i] = fqmul_neon(c[i - 1], a[i], zeta);
    }

    inv = fqinv_neon(c[23]);

    t   = vqrdmulhq_laneq_s16(inv, zeta, 6);
    inv = vmulq_laneq_s16(inv, zeta, 5);
    inv = vmlsq_laneq_s16(inv, t, zeta, 0);

    for (int i = 23; i > 0; i--)
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

    for (int i = 0; i < 24; i++)
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
    int16x8_t den1[24];
    int16x8_t den2[24];

    poly_baseinv_1(r, den1, a);

    if(poly_fqinv_batch(den2, den1)) return 1;

    poly_baseinv_2(r, den2);

    return 0;
}
