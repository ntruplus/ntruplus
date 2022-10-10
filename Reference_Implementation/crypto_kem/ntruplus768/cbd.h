#ifndef CBD_H
#define CBD_H

#include <stdint.h>
#include "params.h"
#include "poly.h"

void cbd1(poly *r, const uint8_t buf[KYBER_ETA1*KYBER_N/4]);

#endif
