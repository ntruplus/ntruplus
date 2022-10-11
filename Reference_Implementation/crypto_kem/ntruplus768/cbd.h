#ifndef CBD_H
#define CBD_H

#include <stdint.h>
#include "params.h"
#include "poly.h"

void cbd1(poly *r, const uint8_t buf[NTRUPLUS_N]);

#endif
