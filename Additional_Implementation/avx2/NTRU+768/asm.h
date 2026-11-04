#ifndef NTRUPLUS_ASM_H
#define NTRUPLUS_ASM_H

#ifdef __APPLE__
#define NTRUPLUS_ASM_SYMBOL(name) _##name
#define NTRUPLUS_ASM_LOCAL(name) L##name
#else
#define NTRUPLUS_ASM_SYMBOL(name) name
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

#define NTRUPLUS_ASM_START(name) ntruplus_asm_start name
#define NTRUPLUS_ASM_END(name) NTRUPLUS_ASM_SIZE(name)

#endif
