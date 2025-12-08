#ifndef VERIFY_H
#define VERIFY_H

#include <stddef.h>
#include <stdint.h>
#include "params.h"

#define NTRUPLUS_NAMESPACE(s) kpqclean_ntruplus576_opt_##s

#define verify NTRUPLUS_NAMESPACE(verify)
int verify(const uint8_t *a, const uint8_t *b, size_t len);

#endif