CC = gcc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -mavx2 -mbmi2 -mpopcnt -maes \
  -march=native -mtune=native -O3 -fomit-frame-pointer
NISTFLAGS += -Wno-unused-result -mavx2 -mbmi2 -mpopcnt -maes \
  -march=native -mtune=native -O3 -fomit-frame-pointer
RM = /bin/rm

LDFLAGS=-lcrypto

SOURCES= asm/add.s asm/baseinv.s asm/basemul.s asm/cbd.s asm/invntt.s asm/ntt.s asm/pack.s asm/crepmod3.s consts.c kem.c symmetric.c verify.c Keccak_avx2/fips202.c Keccak_avx2/KeccakP-1600-AVX2.s
HEADERS= params.h api.h poly.h symmetric.h verify.h Keccak_avx2/fips202.h Keccak_avx2/KeccakP-1600-SnP.h

.PHONY: all PQCgenKAT_kem test clean

all: \
	test \
	PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) rng.h $(SOURCES) rng.c
	$(CC) $(NISTFLAGS) -o $@ PQCgenKAT_kem.c rng.c $(SOURCES) $(LDFLAGS)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test.c
	$(CC) $(CFLAGS) -o $@ randombytes.c test.c $(SOURCES) $(LDFLAGS)

clean:
	-$(RM) PQCgenKAT_kem
	-$(RM) test