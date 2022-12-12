#ifndef CPUCYCLES_H
#define CPUCYCLES_H

#include <stdint.h>

#if defined(__x86_64__)

int64_t cpucycles(void)
{
	unsigned int hi, lo;

    __asm__ __volatile__ ("rdtsc\n\t" : "=a" (lo), "=d"(hi));

    return ((int64_t)lo) | (((int64_t)hi) << 32);
}

#elif defined(__aarch64__)

int64_t cpucycles(void)
{
	unsigned int result;

    asm volatile("mrs %0, PMCCNTR_EL0":"=r"(result));

    return result;
}

#else

#endif
#endif