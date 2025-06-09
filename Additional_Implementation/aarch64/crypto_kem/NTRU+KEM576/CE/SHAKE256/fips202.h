#ifndef FIPS202_H
#define FIPS202_H

/*
 * This file is licensed under Apache 2.0 (https://www.apache.org/licenses/LICENSE-2.0.html)
 * or may be used in the public domain.
 */

#include <stddef.h>
#include <stdint.h>

#define SHAKE128_RATE 168
#define SHAKE256_RATE 136
#define SHA3_256_RATE 136
#define SHA3_512_RATE 72

/* keccak_state represents a single Keccak‑f[1600] state as 25 64‑bit words. */
typedef struct {
    uint64_t s[25];
} keccak_state;

/* Function prototypes for SHAKE128 and SHAKE256 XOFs (non‑incremental API) */
void shake128_absorb(keccak_state *state,
                     const uint8_t *in,
                     size_t inlen);

void shake128_squeezeblocks(uint8_t *out,
                            size_t nblocks,
                            keccak_state *state);

void shake128(uint8_t *out,
              size_t outlen,
              const uint8_t *in,
              size_t inlen);

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
