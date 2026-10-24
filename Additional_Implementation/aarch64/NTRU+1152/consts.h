#ifndef CONSTS_H
#define CONSTS_H

/* Byte offset of the first base-operation factor pair in zetas. */
#define ZETAS_MUL_OFFSET 112
/* Byte offset of the last regular forward block for reverse traversal. */
#define ZETAS_INV_START 1168

#ifndef __ASSEMBLER__
#include <stdint.h>
#include "api.h"

NTRUPLUS_INTERNAL extern const int16_t zetas[616];
NTRUPLUS_INTERNAL extern const int16_t consts_inv[8];
NTRUPLUS_INTERNAL extern const uint8_t consts_inverse_masks[80];
NTRUPLUS_INTERNAL extern const int16_t consts_base[8];
NTRUPLUS_INTERNAL extern const uint8_t consts_shuffle[32];
#endif

#endif
