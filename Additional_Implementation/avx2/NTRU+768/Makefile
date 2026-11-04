CC = clang
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -mavx2 -mbmi2 -mpopcnt -maes \
  -march=native -mtune=native -O3 -fomit-frame-pointer
NISTFLAGS += -Wno-unused-result -mavx2 -mbmi2 -mpopcnt -maes \
  -march=native -mtune=native -O3 -fomit-frame-pointer
RM = /bin/rm -f

ifneq (,$(filter %mingw32 %windows-gnu,$(shell $(CC) -dumpmachine)))
MINGW_LDLIBS = -ladvapi32
endif

ifneq (,$(findstring darwin,$(shell $(CC) -dumpmachine)))
CFLAGS += -D__STDC_WANT_LIB_EXT1__=1
NISTFLAGS += -D__STDC_WANT_LIB_EXT1__=1
endif

SOURCES= asm/add.S asm/baseinv.S asm/basemul.S asm/cbd.S asm/crepmod3.S asm/invntt.S asm/ntt.S asm/pack.S asm/sotp.S consts.c kem.c poly.c symmetric.c fips202/fips202.c fips202/KeccakP-1600-AVX2.S
HEADERS= asm.h params.h api.h poly.h symmetric.h util.h fips202/fips202.h fips202/KeccakP-1600-SnP.h

.PHONY: all PQCgenKAT_kem test clean

BUILD_DIR = build

all: \
	test \
	PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) kat/aes.h kat/rng.h $(SOURCES) kat/PQCgenKAT_kem.c kat/aes.c kat/rng.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(NISTFLAGS) -I. -o $(BUILD_DIR)/PQCgenKAT_kem kat/PQCgenKAT_kem.c kat/aes.c kat/rng.c $(SOURCES)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test/test.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -I. -o $(BUILD_DIR)/test randombytes.c test/test.c $(SOURCES) $(MINGW_LDLIBS)

clean:
	$(RM) PQCkemKAT_*.req PQCkemKAT_*.rsp
	$(RM) -r $(BUILD_DIR)
