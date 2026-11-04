/* Based on the public domain implementation in
 * crypto_hash/keccakc512/simple/ from http://bench.cr.yp.to/supercop.html
 * by Ronny Van Keer
 * and the public domain "TweetFips202" implementation
 * from https://twitter.com/tweetfips202
 * by Gilles Van Assche, Daniel J. Bernstein, and Peter Schwabe */

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include "fips202.h"
#include "keccakf1600.h"
#include "util.h"

#define NROUNDS 24

/*************************************************
 * Name:        load64
 *
 * Description: Load 8 bytes into uint64_t in little-endian order
 *
 * Arguments:   - const uint8_t *x: pointer to input byte array
 *
 * Returns the loaded 64-bit unsigned integer
 **************************************************/
static uint64_t load64(const uint8_t *x) {
    uint64_t r = 0;
    for (size_t i = 0; i < 8; ++i) {
        r |= (uint64_t)x[i] << 8 * i;
    }

    return r;
}

/*************************************************
 * Name:        store64
 *
 * Description: Store a 64-bit integer to a byte array in little-endian order
 *
 * Arguments:   - uint8_t *x: pointer to the output byte array
 *              - uint64_t u: input 64-bit unsigned integer
 **************************************************/
static void store64(uint8_t *x, uint64_t u) {
    for (size_t i = 0; i < 8; ++i) {
        x[i] = (uint8_t) (u >> 8 * i);
    }
}

/* Keccak round constants */
static const uint64_t KeccakF_RoundConstants[NROUNDS] = {
    0x0000000000000001ULL, 0x0000000000008082ULL,
    0x800000000000808aULL, 0x8000000080008000ULL,
    0x000000000000808bULL, 0x0000000080000001ULL,
    0x8000000080008081ULL, 0x8000000000008009ULL,
    0x000000000000008aULL, 0x0000000000000088ULL,
    0x0000000080008009ULL, 0x000000008000000aULL,
    0x000000008000808bULL, 0x800000000000008bULL,
    0x8000000000008089ULL, 0x8000000000008003ULL,
    0x8000000000008002ULL, 0x8000000000000080ULL,
    0x000000000000800aULL, 0x800000008000000aULL,
    0x8000000080008081ULL, 0x8000000000008080ULL,
    0x0000000080000001ULL, 0x8000000080008008ULL
};

/*************************************************
 * Name:        keccak_absorb
 *
 * Description: Absorb step of Keccak;
 *              non-incremental, starts by zeroeing the state.
 *
 * Arguments:   - uint64_t *s: pointer to (uninitialized) output Keccak state
 *              - uint32_t r: rate in bytes (e.g., 136 for SHAKE256)
 *              - const uint8_t *m: pointer to input to be absorbed into s
 *              - size_t mlen: length of input in bytes
 *              - uint8_t p: domain-separation byte for different
 *                                 Keccak-derived functions
 **************************************************/
static void keccak_absorb(uint64_t *s, uint32_t r, const uint8_t *m,
                          size_t mlen, uint8_t p) {
    size_t i;
    uint8_t t[200];

    /* Zero state */
    for (i = 0; i < 25; ++i) {
        s[i] = 0;
    }

    while (mlen >= r) {
        for (i = 0; i < r / 8; ++i) {
            s[i] ^= load64(m + 8 * i);
        }

        f1600(s, KeccakF_RoundConstants);
        mlen -= r;
        m += r;
    }

    for (i = 0; i < r; ++i) {
        t[i] = 0;
    }
    for (i = 0; i < mlen; ++i) {
        t[i] = m[i];
    }
    t[i] = p;
    t[r - 1] |= 128;
    for (i = 0; i < r / 8; ++i) {
        s[i] ^= load64(t + 8 * i);
    }
    u8_clear(t, sizeof t);
}

/*************************************************
 * Name:        keccak_squeezeblocks
 *
 * Description: Squeeze step of Keccak. Squeezes full blocks of r bytes each.
 *              Modifies the state. Can be called multiple times to keep
 *              squeezing, i.e., is incremental.
 *
 * Arguments:   - uint8_t *h: pointer to output blocks
 *              - size_t nblocks: number of blocks to be
 *                                                squeezed (written to h)
 *              - uint64_t *s: pointer to input/output Keccak state
 *              - uint32_t r: rate in bytes (e.g., 136 for SHAKE256)
 **************************************************/
static void keccak_squeezeblocks(uint8_t *h, size_t nblocks,
                                 uint64_t *s, uint32_t r) {
    while (nblocks > 0) {
        f1600(s, KeccakF_RoundConstants);
        for (size_t i = 0; i < (r >> 3); i++) {
            store64(h + 8 * i, s[i]);
        }
        h += r;
        nblocks--;
    }
}

/*************************************************
 * Name:        keccak_inc_init
 *
 * Description: Initializes the incremental Keccak state to zero.
 *
 * Arguments:   - uint64_t *s_inc: pointer to input/output incremental state
 *                First 25 values represent Keccak state.
 *                26th value represents either the number of absorbed bytes
 *                that have not been permuted, or not-yet-squeezed bytes.
 **************************************************/
static void keccak_inc_init(uint64_t *s_inc) {
    size_t i;

    for (i = 0; i < 25; ++i) {
        s_inc[i] = 0;
    }
    s_inc[25] = 0;
}

/*************************************************
 * Name:        keccak_inc_absorb
 *
 * Description: Incremental keccak absorb
 *              Preceded by keccak_inc_init, succeeded by keccak_inc_finalize
 *
 * Arguments:   - uint64_t *s_inc: pointer to input/output incremental state
 *                First 25 values represent Keccak state.
 *                26th value represents either the number of absorbed bytes
 *                that have not been permuted, or not-yet-squeezed bytes.
 *              - uint32_t r: rate in bytes (e.g., 136 for SHAKE256)
 *              - const uint8_t *m: pointer to input to be absorbed into s
 *              - size_t mlen: length of input in bytes
 **************************************************/
static void keccak_inc_absorb(uint64_t *s_inc, uint32_t r, const uint8_t *m,
                              size_t mlen) {
    size_t i;

    /* Recall that s_inc[25] is the non-absorbed bytes xored into the state */
    while (mlen + s_inc[25] >= r) {
        for (i = 0; i < r - (uint32_t)s_inc[25]; i++) {
            /* Take the i'th byte from message
               xor with the s_inc[25] + i'th byte of the state; little-endian */
            s_inc[(s_inc[25] + i) >> 3] ^= (uint64_t)m[i] << (8 * ((s_inc[25] + i) & 0x07));
        }
        mlen -= (size_t)(r - s_inc[25]);
        m += r - s_inc[25];
        s_inc[25] = 0;

        f1600(s_inc, KeccakF_RoundConstants);
    }

    for (i = 0; i < mlen; i++) {
        s_inc[(s_inc[25] + i) >> 3] ^= (uint64_t)m[i] << (8 * ((s_inc[25] + i) & 0x07));
    }
    s_inc[25] += mlen;
}

/*************************************************
 * Name:        keccak_inc_finalize
 *
 * Description: Finalizes Keccak absorb phase, prepares for squeezing
 *
 * Arguments:   - uint64_t *s_inc: pointer to input/output incremental state
 *                First 25 values represent Keccak state.
 *                26th value represents either the number of absorbed bytes
 *                that have not been permuted, or not-yet-squeezed bytes.
 *              - uint32_t r: rate in bytes (e.g., 136 for SHAKE256)
 *              - uint8_t p: domain-separation byte for different
 *                                 Keccak-derived functions
 **************************************************/
static void keccak_inc_finalize(uint64_t *s_inc, uint32_t r, uint8_t p) {
    /* After keccak_inc_absorb, we are guaranteed that s_inc[25] < r,
       so we can always use one more byte for p in the current state. */
    s_inc[s_inc[25] >> 3] ^= (uint64_t)p << (8 * (s_inc[25] & 0x07));
    s_inc[(r - 1) >> 3] ^= (uint64_t)128 << (8 * ((r - 1) & 0x07));
    s_inc[25] = 0;
}

/*************************************************
 * Name:        keccak_inc_squeeze
 *
 * Description: Incremental Keccak squeeze; can be called on byte-level
 *
 * Arguments:   - uint8_t *h: pointer to output bytes
 *              - size_t outlen: number of bytes to be squeezed
 *              - uint64_t *s_inc: pointer to input/output incremental state
 *                First 25 values represent Keccak state.
 *                26th value represents either the number of absorbed bytes
 *                that have not been permuted, or not-yet-squeezed bytes.
 *              - uint32_t r: rate in bytes (e.g., 136 for SHAKE256)
 **************************************************/
static void keccak_inc_squeeze(uint8_t *h, size_t outlen,
                               uint64_t *s_inc, uint32_t r) {
    size_t i;

    /* First consume any bytes we still have sitting around */
    for (i = 0; i < outlen && i < s_inc[25]; i++) {
        /* There are s_inc[25] bytes left, so r - s_inc[25] is the first
           available byte. We consume from there, i.e., up to r. */
        h[i] = (uint8_t)(s_inc[(r - s_inc[25] + i) >> 3] >> (8 * ((r - s_inc[25] + i) & 0x07)));
    }
    h += i;
    outlen -= i;
    s_inc[25] -= i;

    /* Then squeeze the remaining necessary blocks */
    while (outlen > 0) {
        f1600(s_inc, KeccakF_RoundConstants);

        for (i = 0; i < outlen && i < r; i++) {
            h[i] = (uint8_t)(s_inc[i >> 3] >> (8 * (i & 0x07)));
        }
        h += i;
        outlen -= i;
        s_inc[25] = r - i;
    }
}

void shake256_inc_init(shake256incctx *state) {
    keccak_inc_init(state->ctx);
}

void shake256_inc_absorb(shake256incctx *state, const uint8_t *input, size_t inlen) {
    keccak_inc_absorb(state->ctx, SHAKE256_RATE, input, inlen);
}

void shake256_inc_finalize(shake256incctx *state) {
    keccak_inc_finalize(state->ctx, SHAKE256_RATE, 0x1F);
}

void shake256_inc_squeeze(uint8_t *output, size_t outlen, shake256incctx *state) {
    keccak_inc_squeeze(output, outlen, state->ctx, SHAKE256_RATE);
}

void shake256_inc_ctx_clone(shake256incctx *dest, const shake256incctx *src) {
    memcpy(dest->ctx, src->ctx, PQC_SHAKEINCCTX_BYTES);
}

void shake256_inc_ctx_release(shake256incctx *state) {
    u8_clear(state->ctx, PQC_SHAKEINCCTX_BYTES);
}

/*************************************************
 * Name:        shake256_absorb
 *
 * Description: Absorb step of the SHAKE256 XOF.
 *              non-incremental, starts by zeroeing the state.
 *
 * Arguments:   - shake256ctx *state: pointer to (uninitialized) output Keccak state
 *              - const uint8_t *input: pointer to input to be absorbed
 *                                            into s
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake256_absorb(shake256ctx *state, const uint8_t *input, size_t inlen) {
    keccak_absorb(state->ctx, SHAKE256_RATE, input, inlen, 0x1F);
}

/*************************************************
 * Name:        shake256_squeezeblocks
 *
 * Description: Squeeze step of SHAKE256 XOF. Squeezes full blocks of
 *              SHAKE256_RATE bytes each. Modifies the state. Can be called
 *              multiple times to keep squeezing, i.e., is incremental.
 *
 * Arguments:   - uint8_t *output: pointer to output blocks
 *              - size_t nblocks: number of blocks to be squeezed
 *                                (written to output)
 *              - shake256ctx *state: pointer to input/output Keccak state
 **************************************************/
void shake256_squeezeblocks(uint8_t *output, size_t nblocks, shake256ctx *state) {
    keccak_squeezeblocks(output, nblocks, state->ctx, SHAKE256_RATE);
}

void shake256_ctx_clone(shake256ctx *dest, const shake256ctx *src) {
    memcpy(dest->ctx, src->ctx, PQC_SHAKECTX_BYTES);
}

/** Clear the state. */
void shake256_ctx_release(shake256ctx *state) {
    u8_clear(state->ctx, PQC_SHAKECTX_BYTES);
}

/*************************************************
 * Name:        shake256
 *
 * Description: SHAKE256 XOF with non-incremental API
 *
 * Arguments:   - uint8_t *output: pointer to output
 *              - size_t outlen: requested output length in bytes
 *              - const uint8_t *input: pointer to input
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake256(uint8_t *output, size_t outlen,
              const uint8_t *input, size_t inlen) {
    size_t nblocks = outlen / SHAKE256_RATE;
    uint8_t t[SHAKE256_RATE];
    shake256ctx s;

    shake256_absorb(&s, input, inlen);
    shake256_squeezeblocks(output, nblocks, &s);

    output += nblocks * SHAKE256_RATE;
    outlen -= nblocks * SHAKE256_RATE;

    if (outlen) {
        shake256_squeezeblocks(t, 1, &s);
        for (size_t i = 0; i < outlen; ++i) {
            output[i] = t[i];
        }
    }
    u8_clear(t, sizeof(t));
    shake256_ctx_release(&s);
}
