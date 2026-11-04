#ifndef CONSTS_H
#define CONSTS_H

#include <stdint.h>

#include "params.h"
#include "api.h"

#define consts_base NTRUPLUS_NAMESPACE(consts_base)
#define consts_inv NTRUPLUS_NAMESPACE(consts_inv)
#define consts_inverse_masks NTRUPLUS_NAMESPACE(consts_inverse_masks)
#define consts_reverse NTRUPLUS_NAMESPACE(consts_reverse)
#define consts_shuffle NTRUPLUS_NAMESPACE(consts_shuffle)
#define zetas NTRUPLUS_NAMESPACE(zetas)

NTRUPLUS_INTERNAL extern const int16_t zetas[616];
NTRUPLUS_INTERNAL extern const int16_t consts_inv[8];
NTRUPLUS_INTERNAL extern const uint8_t consts_inverse_masks[80];
NTRUPLUS_INTERNAL extern const int16_t consts_base[8];
NTRUPLUS_INTERNAL extern const uint8_t consts_shuffle[32];

#endif
