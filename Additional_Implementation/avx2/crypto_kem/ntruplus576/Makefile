CC=/usr/bin/gcc
CFLAGS += -O3 -march=native -fomit-frame-pointer
LDFLAGS=-lcrypto

#SOURCES= cbd.c fips202.c indcpa.c kem.c ntt.c poly.c polyvec.c PQCgenKAT_kem.c reduce.c rng.c verify.c symmetric-shake.c
#HEADERS= api.h cbd.h fips202.h indcpa.h ntt.h params.h poly.h polyvec.h reduce.h rng.h verify.h symmetric.h
#
SOURCES= kem.c rng.c  symmetric.c aes256ctr.c verify.c asm/*.s consts.c poly.c
HEADERS= api.h params.h poly.h reduce.h rng.h verify.h symmetric.h crypto_stream.h
PQCgenKAT_kem: $(HEADERS) $(SOURCES) PQCgenKAT_kem.c
	$(CC) $(CFLAGS) -o $@ PQCgenKAT_kem.c $(SOURCES) $(LDFLAGS)

main: $(HEADERS) $(SOURCES) main.c
	$(CC) $(CFLAGS) -o $@ main.c $(SOURCES) $(LDFLAGS)
#fastrandombytes.c kernelrandombytes.c 
.PHONY: clean

clean:
	-rm PQCgenKAT_kem
	-rm main
