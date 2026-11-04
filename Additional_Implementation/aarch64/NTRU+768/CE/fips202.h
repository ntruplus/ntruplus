#ifndef FIPS202_H
#define FIPS202_H

#include <stddef.h>
#include <stdint.h>

#include "params.h"

#define f1600 NTRUPLUS_NAMESPACE(f1600)
#define shake256 NTRUPLUS_NAMESPACE(shake256)
#define shake256_absorb NTRUPLUS_NAMESPACE(shake256_absorb)
#define shake256_ctx_clone NTRUPLUS_NAMESPACE(shake256_ctx_clone)
#define shake256_ctx_release NTRUPLUS_NAMESPACE(shake256_ctx_release)
#define shake256_inc_absorb NTRUPLUS_NAMESPACE(shake256_inc_absorb)
#define shake256_inc_ctx_clone NTRUPLUS_NAMESPACE(shake256_inc_ctx_clone)
#define shake256_inc_ctx_release NTRUPLUS_NAMESPACE(shake256_inc_ctx_release)
#define shake256_inc_finalize NTRUPLUS_NAMESPACE(shake256_inc_finalize)
#define shake256_inc_init NTRUPLUS_NAMESPACE(shake256_inc_init)
#define shake256_inc_squeeze NTRUPLUS_NAMESPACE(shake256_inc_squeeze)
#define shake256_squeezeblocks NTRUPLUS_NAMESPACE(shake256_squeezeblocks)

/*
 * This file is licensed under Apache 2.0 (https://www.apache.org/licenses/LICENSE-2.0.html)
 * or may be used in the public domain.
 */

#define SHAKE256_RATE 136

/* keccak_state represents a single Keccak‑f[1600] state as 25 64‑bit words. */
typedef struct {
    uint64_t s[25];
} keccak_state;

/* Function prototypes for the SHAKE256 XOF (non-incremental API) */
void shake256_absorb(keccak_state *state,
                     const uint8_t *in,
                     size_t inlen);

void shake256_squeezeblocks(uint8_t *out,
                            size_t nblocks,
                            keccak_state *state);

void shake256(uint8_t *out,
              size_t outlen,
              const uint8_t *in,
              size_t inlen);

#endif
