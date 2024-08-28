CC =gcc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer
NISTFLAGS += -Wno-unused-result -O3 -fomit-frame-pointer
RM = /bin/rm

LDFLAGS=-lcrypto

SOURCES= pke.c poly.c ntt.c sha2.c symmetric.c reduce.c verify.c fips202.c
HEADERS= params.h pke.h poly.h ntt.h sha2.h symmetric.h reduce.h verify.h fips202.h

.PHONY: all PQCgenKAT_encrypt test clean

all: \
	test \
	PQCgenKAT_encrypt

PQCgenKAT_encrypt: $(HEADERS) rng.h $(SOURCES) rng.c
	$(CC) $(NISTFLAGS) -o $@ PQCgenKAT_encrypt.c rng.c $(SOURCES) $(LDFLAGS)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test.c cpucycles.h
	$(CC) $(CFLAGS) -o $@ randombytes.c test.c $(SOURCES)

clean:
	-$(RM) PQCgenKAT_encrypt
	-$(RM) test