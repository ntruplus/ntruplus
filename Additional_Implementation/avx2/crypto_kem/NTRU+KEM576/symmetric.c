#include "symmetric.h"
#include "Keccak_avx2/fips202.h"
#include <string.h>

extern void sha256_transform_rorx(void *input_data, uint32_t digest[8], uint64_t num_blks);

#define SHA256_DIGEST_LENGTH 32
#define SHA256_BLOCK_SIZE 64

static const uint32_t sha256_initial_state[8] = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
};

static uint8_t* SHA256(const uint8_t *data, size_t len, uint8_t *out) {
    size_t total_len = len + 1 + 8;
    size_t pad_len = (SHA256_BLOCK_SIZE - (total_len % SHA256_BLOCK_SIZE)) % SHA256_BLOCK_SIZE;
    size_t msg_len = len + 1 + pad_len + 8;

    uint8_t *msg = (uint8_t *)calloc(1, msg_len);
    if (!msg) return NULL;

    memcpy(msg, data, len);
    msg[len] = 0x80;

    uint64_t bit_len = (uint64_t)len * 8;
    for (int i = 0; i < 8; i++) {
        msg[msg_len - 1 - i] = (bit_len >> (i * 8)) & 0xff;
    }

    uint32_t digest[8];
    memcpy(digest, sha256_initial_state, sizeof(digest));

    sha256_transform_rorx(msg, digest, msg_len / SHA256_BLOCK_SIZE);

    for (int i = 0; i < 8; i++) {
        uint32_t be = __builtin_bswap32(digest[i]);
        memcpy(out + i * 4, &be, 4);
    }

    free(msg);
    return out;
}

void hash_f(uint8_t *buf, const uint8_t *msg) {
    uint8_t data[1 + NTRUPLUS_PUBLICKEYBYTES] = {0x0};
    for (int i = 0; i < NTRUPLUS_PUBLICKEYBYTES; i++) {
        data[i+1] = msg[i];
    }
    SHA256(data, NTRUPLUS_PUBLICKEYBYTES + 1, buf);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_POLYBYTES] = {0x1};

	for (int i = 0; i < NTRUPLUS_POLYBYTES; i++)
	{
		data[i+1] = msg[i];
	}
	
	shake256(buf,NTRUPLUS_N/4,data,NTRUPLUS_POLYBYTES+1);
}

void hash_h_kem(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES] = {0x2};

	for (int i = 0; i < NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES; i++)
	{
		data[i+1] = msg[i];
	}

	shake256(buf,NTRUPLUS_SSBYTES + NTRUPLUS_N/4,data,NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES+1);
}