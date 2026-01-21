CC =gcc
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -O3 -fomit-frame-pointer
NISTFLAGS += -Wno-unused-result -O3 -fomit-frame-pointer
RM = /bin/rm -f

SOURCES= kem.c poly.c ntt.c symmetric.c fips202/fips202.c
HEADERS= api.h params.h poly.h ntt.h symmetric.h fips202/fips202.h

.PHONY: all PQCgenKAT_kem test clean

all: \
	test \
	PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) rng.h $(SOURCES) PQCgenKAT_kem.c aes.c rng.c
	$(CC) $(NISTFLAGS) -o $@ PQCgenKAT_kem.c aes.c rng.c $(SOURCES)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test.c 
	$(CC) $(CFLAGS) -o $@ randombytes.c test.c $(SOURCES)

clean:
	$(RM) PQCgenKAT_kem
	$(RM) PQCkemKAT_*.req PQCkemKAT_*.rsp
	$(RM) test
