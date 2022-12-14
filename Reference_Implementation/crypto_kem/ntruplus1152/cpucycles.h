#ifndef CPUCYCLES_H
#define CPUCYCLES_H

#include <stdint.h>

#if defined(__x86_64__)

static inline uint64_t cpucycles1(void) {
  uint64_t result;

  __asm__ volatile ("rdtsc; shlq $32,%%rdx; orq %%rdx,%%rax"
    : "=a" (result) : : "%rdx");

  return result;
}

static inline uint64_t cpucycles2(void) {
  uint64_t result;

  __asm__ volatile ("rdtsc; shlq $32,%%rdx; orq %%rdx,%%rax"
    : "=a" (result) : : "%rdx");

  return result;
}

#elif defined(__aarch64__)

static inline uint64_t cpucycles1(void)
{
	uint64_t result;
	uint64_t zero;

    asm volatile ("msr PMCCNTR_EL0, %0" :  : "r" (zero));
    asm volatile("mrs %0, PMCCNTR_EL0":"=r"(result));

    return result;
}

static inline uint64_t cpucycles2(void)
{
	uint64_t result;

    asm volatile("mrs %0, PMCCNTR_EL0":"=r"(result));

    return result;
}

#else

#endif
#endif