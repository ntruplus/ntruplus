#ifndef CONSTS_H
#define CONSTS_H

/* Byte offset of the first base-operation factor pair in zetas. */
#define ZETAS_MUL_OFFSET 96

#ifndef __ASSEMBLER__
#include <stdint.h>
#include "api.h"

NTRUPLUS_INTERNAL extern const int16_t zetas[416];
NTRUPLUS_INTERNAL extern const int16_t zetas_inv[416];
NTRUPLUS_INTERNAL extern const int16_t consts_base[8];
#endif

#endif
