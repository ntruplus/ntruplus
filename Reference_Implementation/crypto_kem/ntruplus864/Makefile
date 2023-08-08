CC=/usr/bin/gcc
CFLAGS += -O3 -fomit-frame-pointer
LDFLAGS=-lcrypto

SOURCES= aes256ctr.c kem.c ntt.c poly.c reduce.c sha512.c symmetric.c util.c verify.c sha256.c 
HEADERS= api.h kem.h ntt.h params.h poly.h reduce.h sha2.h symmetric.h util.h verify.h 

.PHONY: all PQCgenKAT_kem test clean

all: test PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) rng.h $(SOURCES) rng.c
	$(CC) $(CFLAGS) -o $@ PQCgenKAT_kem.c rng.c $(SOURCES) $(LDFLAGS)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test.c cpucycles.h
	$(CC) $(CFLAGS) -o $@ randombytes.c test.c $(SOURCES)

clean:
	-rm PQCgenKAT_kem
	-rm test