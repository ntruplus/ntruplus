#ifndef CONSTS_H
#define CONSTS_H

#include <stdint.h>

#include "params.h"
#include "api.h"

#define _16x0101 NTRUPLUS_NAMESPACE(16x0101)
#define _16x0303 NTRUPLUS_NAMESPACE(16x0303)
#define _16x1 NTRUPLUS_NAMESPACE(16x1)
#define _16x3 NTRUPLUS_NAMESPACE(16x3)
#define _16x5555 NTRUPLUS_NAMESPACE(16x5555)
#define _16xNinv_scale NTRUPLUS_NAMESPACE(16xNinv_scale)
#define _16xNinv_scaleqinv NTRUPLUS_NAMESPACE(16xNinv_scaleqinv)
#define _16xR2 NTRUPLUS_NAMESPACE(16xR2)
#define _16xR2qinv NTRUPLUS_NAMESPACE(16xR2qinv)
#define _16xRinv NTRUPLUS_NAMESPACE(16xRinv)
#define _16xRinvqinv NTRUPLUS_NAMESPACE(16xRinvqinv)
#define _16xq NTRUPLUS_NAMESPACE(16xq)
#define _16xq26 NTRUPLUS_NAMESPACE(16xq26)
#define _16xq26round NTRUPLUS_NAMESPACE(16xq26round)
#define _16xqinv NTRUPLUS_NAMESPACE(16xqinv)
#define _16xqm1 NTRUPLUS_NAMESPACE(16xqm1)
#define _16xv NTRUPLUS_NAMESPACE(16xv)
#define _16xv2 NTRUPLUS_NAMESPACE(16xv2)
#define _16xw NTRUPLUS_NAMESPACE(16xw)
#define _16xwqinv NTRUPLUS_NAMESPACE(16xwqinv)
#define _16xzeta1 NTRUPLUS_NAMESPACE(16xzeta1)
#define _low_mask NTRUPLUS_NAMESPACE(low_mask)
#define zetas NTRUPLUS_NAMESPACE(zetas)
#define zetas_inv NTRUPLUS_NAMESPACE(zetas_inv)

NTRUPLUS_INTERNAL extern const int16_t zetas[1232];
NTRUPLUS_INTERNAL extern const int16_t zetas_inv[1224];

NTRUPLUS_INTERNAL extern const int16_t _low_mask[16];
NTRUPLUS_INTERNAL extern const int16_t _16xv[16];
NTRUPLUS_INTERNAL extern const int16_t _16xv2[16];
NTRUPLUS_INTERNAL extern const int16_t _16xq26[16];
NTRUPLUS_INTERNAL extern const int16_t _16xq26round[16];
NTRUPLUS_INTERNAL extern const int16_t _16x1[16];
NTRUPLUS_INTERNAL extern const int16_t _16x3[16];
NTRUPLUS_INTERNAL extern const int16_t _16xq[16];
NTRUPLUS_INTERNAL extern const int16_t _16xqm1[16];
NTRUPLUS_INTERNAL extern const int16_t _16xzeta1[16];
NTRUPLUS_INTERNAL extern const int16_t _16xqinv[16];
NTRUPLUS_INTERNAL extern const int16_t _16xw[16];
NTRUPLUS_INTERNAL extern const int16_t _16xwqinv[16];
NTRUPLUS_INTERNAL extern const int16_t _16xR2[16];
NTRUPLUS_INTERNAL extern const int16_t _16xR2qinv[16];
NTRUPLUS_INTERNAL extern const int16_t _16xRinv[16];
NTRUPLUS_INTERNAL extern const int16_t _16xRinvqinv[16];
NTRUPLUS_INTERNAL extern const int16_t _16xNinv_scale[16];
NTRUPLUS_INTERNAL extern const int16_t _16xNinv_scaleqinv[16];

NTRUPLUS_INTERNAL extern const int16_t _16x5555[16];
NTRUPLUS_INTERNAL extern const int16_t _16x0303[16];
NTRUPLUS_INTERNAL extern const int16_t _16x0101[16];

#endif
