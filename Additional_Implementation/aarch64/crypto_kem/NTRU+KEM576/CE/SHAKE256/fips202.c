#include "fips202.h"
#include <stddef.h>
#include <stdint.h>

#ifdef __ARM_FEATURE_CRYPTO
/* On ARM platforms with crypto extensions, use the assembly-implemented f1600 */
extern void f1600(uint64_t *state, const uint64_t *roundConstants);
#else
/* Otherwise, you would provide a reference implementation here. */
#endif

#define NROUNDS 24

static const uint64_t KeccakF_RoundConstants[NROUNDS] = {
    0x0000000000000001ULL,
    0x0000000000008082ULL,
    0x800000000000808aULL,
    0x8000000080008000ULL,
    0x000000000000808bULL,
    0x0000000080000001ULL,
    0x8000000080008081ULL,
    0x8000000000008009ULL,
    0x000000000000008aULL,
    0x0000000000000088ULL,
    0x0000000080008009ULL,
    0x000000008000000aULL,
    0x000000008000808bULL,
    0x800000000000008bULL,
    0x8000000000008089ULL,
    0x8000000000008003ULL,
    0x8000000000008002ULL,
    0x8000000000000080ULL,
    0x000000000000800aULL,
    0x800000008000000aULL,
    0x8000000080008081ULL,
    0x8000000000008080ULL,
    0x0000000080000001ULL,
    0x8000000080008008ULL
};

#ifdef __ARM_FEATURE_CRYPTO
static inline void KeccakF1600_StatePermute(uint64_t state[25]) {
    f1600(state, KeccakF_RoundConstants);
}
#else
static void KeccakF1600_StatePermute(uint64_t state[25]) {
    /* Reference (software) implementation omitted for brevity.
       You can insert a portable version of the Keccak‑f[1600] permutation here. */
}
#endif

/* Helper function: load 8 bytes as a little‑endian 64‑bit integer */
static uint64_t load64(const uint8_t *x) {
    uint64_t r = 0;
    for (unsigned int i = 0; i < 8; i++) {
        r |= ((uint64_t)x[i]) << (8 * i);
    }
    return r;
}

/* Helper function: store a 64‑bit integer into 8 bytes (little‑endian) */
static void store64(uint8_t *x, uint64_t u) {
    for (unsigned int i = 0; i < 8; i++) {
        x[i] = (uint8_t)(u >> (8 * i));
    }
}

/* Absorb input into the state (non‑incremental), with padding */
static void keccak_absorb(uint64_t state[25], unsigned int r,
                            const uint8_t *in, size_t inlen, uint8_t p) {
    for (unsigned int i = 0; i < 25; i++){
        state[i] = 0;
    }
    while (inlen >= r) {
        for (unsigned int i = 0; i < r / 8; i++){
            state[i] ^= load64(in + 8 * i);
        }
        in += r;
        inlen -= r;
        KeccakF1600_StatePermute(state);
    }
    unsigned int i;
    for (i = 0; i < inlen; i++){
        state[i / 8] ^= ((uint64_t)in[i]) << (8 * (i % 8));
    }
    state[i / 8] ^= ((uint64_t)p) << (8 * (i % 8));
    state[(r - 1) / 8] ^= 1ULL << 63;
}

/* Squeeze full blocks from the state */
static void keccak_squeezeblocks(uint8_t *out, size_t nblocks, unsigned int r, uint64_t state[25]) {
    while (nblocks--) {
        KeccakF1600_StatePermute(state);
        for (unsigned int i = 0; i < r / 8; i++){
            store64(out + 8 * i, state[i]);
        }
        out += r;
    }
}

/* SHAKE128 functions */
void shake128_absorb(keccak_state *state, const uint8_t *in, size_t inlen) {
    keccak_absorb(state->s, SHAKE128_RATE, in, inlen, 0x1F);
}

void shake128_squeezeblocks(uint8_t *out, size_t nblocks, keccak_state *state) {
    keccak_squeezeblocks(out, nblocks, SHAKE128_RATE, state->s);
}

void shake128(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen) {
    keccak_state state;
    shake128_absorb(&state, in, inlen);
    size_t nblocks = outlen / SHAKE128_RATE;
    shake128_squeezeblocks(out, nblocks, &state);
    out += nblocks * SHAKE128_RATE;
    outlen -= nblocks * SHAKE128_RATE;
    if (outlen > 0) {
        uint8_t temp[SHAKE128_RATE];
        shake128_squeezeblocks(temp, 1, &state);
        for (size_t i = 0; i < outlen; i++) {
            out[i] = temp[i];
        }
    }
}

/* SHAKE256 functions */
void shake256_absorb(keccak_state *state, const uint8_t *in, size_t inlen) {
    keccak_absorb(state->s, SHAKE256_RATE, in, inlen, 0x1F);
}

void shake256_squeezeblocks(uint8_t *out, size_t nblocks, keccak_state *state) {
    keccak_squeezeblocks(out, nblocks, SHAKE256_RATE, state->s);
}

void shake256(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen) {
    keccak_state state;
    shake256_absorb(&state, in, inlen);
    size_t nblocks = outlen / SHAKE256_RATE;
    shake256_squeezeblocks(out, nblocks, &state);
    out += nblocks * SHAKE256_RATE;
    outlen -= nblocks * SHAKE256_RATE;
    if (outlen > 0) {
        uint8_t temp[SHAKE256_RATE];
        shake256_squeezeblocks(temp, 1, &state);
        for (size_t i = 0; i < outlen; i++) {
            out[i] = temp[i];
        }
    }
}
