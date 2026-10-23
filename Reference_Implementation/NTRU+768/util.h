#ifndef UTIL_H
#define UTIL_H

#include <stddef.h>
#include <stdint.h>

static inline void clear_u8(void *p, size_t n)
{
    volatile uint8_t *v = p;

    while(n-- > 0)
        *v++ = 0;
}

static inline void clear_i16(int16_t *p, size_t n)
{
    volatile int16_t *v = p;

    while(n-- > 0)
        *v++ = 0;
}

static inline void clear_i32(int32_t *p, size_t n)
{
    volatile int32_t *v = p;

    while(n-- > 0)
        *v++ = 0;
}

static inline void clear_u32(uint32_t *p, size_t n)
{
    volatile uint32_t *v = p;

    while(n-- > 0)
        *v++ = 0;
}

#endif /* UTIL_H */
