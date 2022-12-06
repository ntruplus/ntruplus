CC=/usr/bin/gcc
CFLAGS += -O3 -march=native -fomit-frame-pointer
LDFLAGS=-lcrypto

SOURCES= asm/add.s asm/baseinv.s asm/basemul.s asm/cbd.s asm/invntt.s asm/ntt.s asm/pack.s asm/reduce.s aes256ctr.c consts.c kem.c poly.c rng.c symmetric.c verify.c
HEADERS= api.h kem.h params.h poly.h rng.h symmetric.h verify.h

.PHONY: all PQCgenKAT_kem test clean

all: test PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -o $@ PQCgenKAT_kem.c $(SOURCES) $(LDFLAGS)

test: $(HEADERS) $(SOURCES) test.c
	$(CC) $(CFLAGS) -o $@ test.c $(SOURCES) $(LDFLAGS)

clean:
	-rm PQCgenKAT_kem
	-rm test
