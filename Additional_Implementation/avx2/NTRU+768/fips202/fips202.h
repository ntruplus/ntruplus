#ifndef FIPS202_H
#define FIPS202_H

#include <stddef.h>
#include <stdint.h>
#include "api.h"

#ifdef __cplusplus
extern "C" {
#endif

/* One-shot SHAKE256; input and output may overlap and be unaligned. */
#define shake256 fips202avx_shake256
NTRUPLUS_INTERNAL void shake256(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen);

#ifdef __cplusplus
}
#endif

#endif
