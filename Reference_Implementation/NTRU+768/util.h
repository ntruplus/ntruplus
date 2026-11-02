#ifndef UTIL_H
#define UTIL_H

#include <stddef.h>
#include <stdint.h>

#ifdef NTRUPLUS_SUPERCOP
#include "crypto_declassify.h"
#define ntruplus_declassify crypto_declassify
#else
#define ntruplus_declassify(x, xlen) ((void)(x), (void)(xlen))
#endif

/*************************************************
* Name:        u8_verify
*
* Description: Compare two byte arrays in constant time.
*
* Arguments:   - const uint8_t *a: first byte array
*              - const uint8_t *b: second byte array
*              - size_t len: length of the arrays
*
* Returns:     0 if the arrays are equal, 1 otherwise.
**************************************************/
static inline int u8_verify(const uint8_t *a, const uint8_t *b, size_t len)
{
    uint8_t acc = 0;

    for (size_t i = 0; i < len; i++)
        acc |= (uint8_t)(a[i] ^ b[i]);

    return (-(uint64_t)acc) >> 63;
}

/*************************************************
* Name:        u8_clear
*
* Description: Clear bytes without allowing dead-store elimination.
*
* Arguments:   - void *p: output bytes
*              - size_t n: number of bytes
*
* Returns:     none.
**************************************************/
static inline void u8_clear(void *p, size_t n)
{
    volatile uint8_t *v = p;

    while (n-- > 0)
        *v++ = 0;
}

/*************************************************
* Name:        i16_clear
*
* Description: Clear signed 16-bit elements without dead-store elimination.
*
* Arguments:   - int16_t *p: output elements
*              - size_t n: number of elements
*
* Returns:     none.
**************************************************/
static inline void i16_clear(int16_t *p, size_t n)
{
    volatile int16_t *v = p;

    while (n-- > 0)
        *v++ = 0;
}

#endif
