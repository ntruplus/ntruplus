#ifndef KECCAKF1600_H
#define KECCAKF1600_H

#include <stdint.h>

#include "params.h"
#include "api.h"

#define f1600 NTRUPLUS_NAMESPACE(f1600)

NTRUPLUS_INTERNAL void f1600(uint64_t *state, const uint64_t *round_constants);

#endif
