#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "sha256.h"

static const uint32_t H_0[8] = {
	0x6a09e667,
	0xbb67ae85,
	0x3c6ef372,
	0xa54ff53a,
	0x510e527f,
	0x9b05688c,
	0x1f83d9ab,
	0x5be0cd19,
};


void sha256_block_data_order(uint32_t *state, const void *data, size_t num);


void sha256(uint8_t out[32], const uint8_t *in, size_t len) {
	uint32_t H[8];
	memcpy(H, H_0, sizeof(H));

	uint64_t bit_len = len * 8;
	size_t full_blocks = len / 64;
	size_t rem = len % 64;

	if (full_blocks > 0) {
		sha256_block_data_order(H, in, full_blocks);
		in += full_blocks * 64;
	}

	unsigned char buffer[64] = {0};
	memcpy(buffer, in, rem);
	buffer[rem] = 0x80;

	if (rem >= 56) {
		sha256_block_data_order(H, buffer, 1);
		memset(buffer, 0, 64);
	}


	for (int i = 0; i < 8; i++) {
		buffer[63 - i] = (bit_len >> (i * 8)) & 0xff;
	}

	sha256_block_data_order(H, buffer, 1);

	for (int i = 0; i < 8; i++) {
		out[i*4 + 0] = (H[i] >> 24) & 0xff;
		out[i*4 + 1] = (H[i] >> 16) & 0xff;
		out[i*4 + 2] = (H[i] >> 8)  & 0xff;
		out[i*4 + 3] = (H[i])       & 0xff;
	}
}
