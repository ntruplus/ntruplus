CC =clang
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer
NISTFLAGS += -Wno-unused-result -O3 -fomit-frame-pointer
RM = /bin/rm -f

ifneq (,$(findstring darwin,$(shell $(CC) -dumpmachine)))
CFLAGS += -D__STDC_WANT_LIB_EXT1__=1
NISTFLAGS += -D__STDC_WANT_LIB_EXT1__=1
else
ASFLAGS += -Wa,--noexecstack
endif

SOURCES= kem.c symmetric.c poly.c asm/add.S asm/ntt.S asm/basemul.S asm/baseinv.S consts.c asm/crepmod3.S asm/pack.S asm/cbd.S fips202/fips202.c
HEADERS= asm.h api.h params.h poly.h symmetric.h util.h consts.h fips202/fips202.h fips202/keccakf1600.h


# Select the backend from the compiler target's SHA3 support.
ifeq ($(shell printf '\n' | $(CC) $(CFLAGS) -dM -E -x c - 2>/dev/null | grep -c ' __ARM_FEATURE_SHA3 '),1)
SOURCES += fips202/keccakf1600_sha3.S
else
SOURCES += fips202/keccakf1600.c
endif

.PHONY: all PQCgenKAT_kem test clean

BUILD_DIR = build

all: \
	test \
	PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) kat/aes.h kat/rng.h $(SOURCES) kat/PQCgenKAT_kem.c kat/aes.c kat/rng.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(NISTFLAGS) $(ASFLAGS) -I. -o $(BUILD_DIR)/PQCgenKAT_kem kat/PQCgenKAT_kem.c kat/aes.c kat/rng.c $(SOURCES)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test/test.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(ASFLAGS) -I. -o $(BUILD_DIR)/test randombytes.c test/test.c $(SOURCES)

clean:
	$(RM) PQCkemKAT_*.req PQCkemKAT_*.rsp
	$(RM) -r $(BUILD_DIR)
