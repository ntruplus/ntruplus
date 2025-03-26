CC =gcc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer
NISTFLAGS += -Wno-unused-result -O3 -fomit-frame-pointer
RM = /bin/rm

LDFLAGS=-lcrypto

SOURCES= kem.c poly.c ntt.c symmetric.c asm/add.s  asm/crepmod3.s reduce.c verify.c fips202.c asm/ntt.s asm/shuffle.s asm/basemul.s asm/baseinv.s asm/cbd.s asm/pack.s 
HEADERS= api.h params.h poly.h ntt.h symmetric.h reduce.h verify.h fips202.h

ifeq ($(shell uname), Darwin)
SOURCES+=asm/sha256-armv8-aarch64.S sha256.c
HEADERS+=sha256.h 
else
SOURCES+=sha2.c
HEADERS+=sha2.h 
endif


.PHONY: all PQCgenKAT_kem test clean

all: \
	test \
	PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) rng.h $(SOURCES) PQCgenKAT_kem.c rng.c
	$(CC) $(NISTFLAGS) -o $@ PQCgenKAT_kem.c rng.c $(SOURCES) $(LDFLAGS)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test.c 
	$(CC) $(CFLAGS) -o $@ randombytes.c test.c $(SOURCES)

clean:
	-$(RM) PQCgenKAT_kem
	-$(RM) test