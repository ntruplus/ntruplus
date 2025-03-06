CC =gcc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer
NISTFLAGS += -Wno-unused-result -O3 -fomit-frame-pointer
RM = /bin/rm

LDFLAGS=-lcrypto

SOURCES= pke.c poly.c ntt.c sha2.c symmetric.c fips202.c
HEADERS= api.h params.h poly.h ntt.h sha2.h symmetric.h fips202.h

.PHONY: all PQCgenKAT_encrypt test clean

all: \
	test \
	PQCgenKAT_encrypt

PQCgenKAT_encrypt: $(HEADERS) rng.h $(SOURCES) PQCgenKAT_encrypt.c rng.c 
	$(CC) $(NISTFLAGS) -o $@ PQCgenKAT_encrypt.c rng.c $(SOURCES) $(LDFLAGS)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test.c
	$(CC) $(CFLAGS) -o $@ randombytes.c test.c $(SOURCES)

clean:
	-$(RM) PQCgenKAT_encrypt
	-$(RM) test