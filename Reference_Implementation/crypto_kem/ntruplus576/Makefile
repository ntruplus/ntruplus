CC=/usr/bin/gcc
CFLAGS += -O3 -fomit-frame-pointer
LDFLAGS=-lcrypto

SOURCES= aes256ctr.c kem.c ntt.c poly.c reduce.c rng.c sha512.c symmetric.c util.c verify.c sha256.c
HEADERS= api.h kem.h ntt.h params.h poly.h reduce.h rng.h sha2.h symmetric.h util.h verify.h

.PHONY: all PQCgenKAT_kem test clean

all: test PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -o $@ PQCgenKAT_kem.c $(SOURCES) $(LDFLAGS)

test: $(HEADERS) $(SOURCES) test.c  cpucycles.h
	$(CC) $(CFLAGS) -o $@ test.c $(SOURCES) $(LDFLAGS)

clean:
	-rm PQCgenKAT_kem
	-rm test