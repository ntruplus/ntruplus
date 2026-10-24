#ifndef CONSTS_H
#define CONSTS_H

/* Byte offset of the first base-operation factor pair in zetas. */
#define ZETAS_MUL_OFFSET 112

#ifndef __ASSEMBLER__
#include <stdint.h>
#include "api.h"

NTRUPLUS_INTERNAL extern const int16_t zetas[616];
NTRUPLUS_INTERNAL extern const int16_t zetas_inv[618];
NTRUPLUS_INTERNAL extern const int16_t consts_base[8];
NTRUPLUS_INTERNAL extern const uint8_t consts_shuffle[32];
#endif

#endif
