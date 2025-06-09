CC =gcc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer
NISTFLAGS += -Wno-unused-result -O3 -fomit-frame-pointer
RM = /bin/rm

LDFLAGS=-lcrypto

SOURCES= kem.c poly.c symmetric.c asm/add.s asm/ntt.s asm/base.s asm/crepmod3.s asm/pack.s asm/cbd.s
HEADERS= api.h params.h poly.h symmetric.h

HAS_SHA256_CE := 1
HAS_SHAKE256_ASM := 1

ifeq ($(HAS_SHA256_CE), 1)
	SOURCES+=CE/SHA256/sha256-armv8-aarch64.S CE/SHA256/sha256.c
	HEADERS+=CE/SHA256/sha256.h
	CFLAGS += -DSUPPORTS_SHA256_ASM
else
	SOURCES+=NO_CE/SHA256/sha2.c 
	HEADERS+=NO_CE/SHA256/sha2.h
endif

ifeq ($(HAS_SHAKE256_ASM), 1)
	SOURCES+=CE/SHAKE256/fips202.c CE/SHAKE256/f1600.S
	HEADERS+=CE/SHAKE256/fips202.h
	CFLAGS += -DSUPPORTS_SHAKE256_ASM
else
	SOURCES+=NO_CE/SHAKE256/fips202.c
	HEADERS+=NO_CE/SHAKE256/fips202.h
endif

.PHONY: all PQCgenKAT_kem test clean

all: \
	test \
	PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) rng.h $(SOURCES) PQCgenKAT_kem.c rng.c
	$(CC) $(NISTFLAGS) -o $@ PQCgenKAT_kem.c rng.c $(SOURCES) $(LDFLAGS)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test.c cpucycles.h
	$(CC) $(CFLAGS) -o $@ randombytes.c test.c $(SOURCES)

clean:
	-$(RM) PQCgenKAT_kem
	-$(RM) test