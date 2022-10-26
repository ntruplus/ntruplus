#ifndef SHA_2_H
#define SHA_2_H

#include <stddef.h>
#include <stdint.h>

void sha512(uint8_t out[64], const uint8_t *in, size_t inlen);

#endif
