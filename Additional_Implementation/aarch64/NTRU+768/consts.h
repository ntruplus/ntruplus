#ifndef CONSTS_H
#define CONSTS_H

/* Byte offset of the first base-operation factor pair in zetas. */
#define ZETAS_MUL_OFFSET 96

/* Byte offset of the last regular forward block for reverse traversal. */
#define ZETAS_INV_START 768

#ifndef __ASSEMBLER__
#include <stdint.h>
#include "api.h"

NTRUPLUS_INTERNAL extern const int16_t zetas[416];
NTRUPLUS_INTERNAL extern const int16_t consts_inv[8];
NTRUPLUS_INTERNAL extern const uint8_t consts_reverse[16];
NTRUPLUS_INTERNAL extern const int16_t consts_base[8];
#endif

#endif
