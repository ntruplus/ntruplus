#include "poly.h"

NTRUPLUS_INTERNAL NTRUPLUS_SYSV
extern void poly_ntt_pack(poly *b, const poly *a);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
extern void poly_ntt_unpack(poly *b, const poly *a);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
extern int poly_frombytes_raw(poly *r,
                             const uint8_t a[NTRUPLUS_POLYBYTES]);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
extern void poly_tobytes_raw(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a);

void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a)
{
    poly tmp;
    poly_ntt_pack(&tmp, a);
    poly_tobytes_raw(r, &tmp);
}

int poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES])
{
    const int fail = poly_frombytes_raw(r, a);
    poly_ntt_unpack(r, r);
    return fail;
}
