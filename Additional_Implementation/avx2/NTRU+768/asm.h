#ifndef NTRUPLUS_ASM_H
#define NTRUPLUS_ASM_H

#include <params.h>

#ifdef __APPLE__
#define NTRUPLUS_ASM_CONCAT_(a, b) a##b
#define NTRUPLUS_ASM_CONCAT(a, b) NTRUPLUS_ASM_CONCAT_(a, b)
#define NTRUPLUS_ASM_SYMBOL(name) NTRUPLUS_ASM_CONCAT(_, NTRUPLUS_NAMESPACE(name))
#define NTRUPLUS_ASM_LOCAL(name) L##name
#else
#define NTRUPLUS_ASM_SYMBOL(name) NTRUPLUS_NAMESPACE(name)
#define NTRUPLUS_ASM_LOCAL(name) .L##name
#endif

#define NTRUPLUS_ASM_GLOBAL(name) .global NTRUPLUS_ASM_SYMBOL(name)

#ifdef __ELF__
#define NTRUPLUS_ASM_TYPE(name) .type NTRUPLUS_ASM_SYMBOL(name), %function
#define NTRUPLUS_ASM_SIZE(name) .size NTRUPLUS_ASM_SYMBOL(name), .-NTRUPLUS_ASM_SYMBOL(name)
#define NTRUPLUS_ASM_GNU_STACK .section .note.GNU-stack,"",%progbits
#else
#define NTRUPLUS_ASM_TYPE(name)
#define NTRUPLUS_ASM_SIZE(name)
#define NTRUPLUS_ASM_GNU_STACK
#endif

.macro ntruplus_asm_start name
#ifdef __APPLE__
.global _\name
_\name:
#else
.global \name
#ifdef __ELF__
.type \name, %function
#endif
\name:
#endif
.endm

#define NTRUPLUS_ASM_START(name) ntruplus_asm_start NTRUPLUS_NAMESPACE(name)
#define NTRUPLUS_ASM_END(name) NTRUPLUS_ASM_SIZE(name)

#ifdef __aarch64__
.macro ntruplus_asm_load_address dst, sym, offset=0
#ifdef __APPLE__
adrp \dst, \sym+\offset@PAGE
add \dst, \dst, \sym+\offset@PAGEOFF
#else
adrp \dst, \sym+\offset
add \dst, \dst, :lo12:\sym+\offset
#endif
.endm

#define NTRUPLUS_ASM_LOAD_ADDRESS(dst, name, offset) ntruplus_asm_load_address dst, NTRUPLUS_ASM_SYMBOL(name), offset
#endif

#endif
