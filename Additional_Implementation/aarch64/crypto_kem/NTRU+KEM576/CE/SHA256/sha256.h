#ifndef SHA256_H
#define SHA256_H

#include <stdint.h>

void sha256(uint8_t out[32], const uint8_t *in, size_t len);

#endif
