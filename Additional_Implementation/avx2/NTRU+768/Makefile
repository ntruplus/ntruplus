CC = clang
CFLAGS += -Wall -Wextra -Wpedantic -Wmissing-prototypes -Wredundant-decls \
  -Wshadow -Wpointer-arith -mavx2 -mbmi2 -mpopcnt -maes \
  -march=native -mtune=native -O3 -fomit-frame-pointer
NISTFLAGS += -Wno-unused-result -mavx2 -mbmi2 -mpopcnt -maes \
  -march=native -mtune=native -O3 -fomit-frame-pointer
RM = /bin/rm -f

ifneq (,$(findstring mingw,$(shell $(CC) -dumpmachine)))
MINGW_ASFLAGS = -Wa,--defsym,no_type=1,--defsym,no_size=1,--defsym,no_gnu_stack=1
MINGW_LDLIBS = -ladvapi32
endif

SOURCES= asm/add.s asm/baseinv.s asm/basemul.s asm/cbd.s asm/crepmod3.s asm/invntt.s asm/ntt.s asm/pack.s consts.c kem.c poly.c symmetric.c fips202/fips202.c fips202/KeccakP-1600-AVX2.s
HEADERS= params.h api.h poly.h symmetric.h util.h fips202/fips202.h fips202/KeccakP-1600-SnP.h

.PHONY: all PQCgenKAT_kem test clean

BUILD_DIR = build

all: \
	test \
	PQCgenKAT_kem

PQCgenKAT_kem: $(HEADERS) kat/aes.h kat/rng.h $(SOURCES) kat/PQCgenKAT_kem.c kat/aes.c kat/rng.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(NISTFLAGS) $(MINGW_ASFLAGS) -I. -o $(BUILD_DIR)/PQCgenKAT_kem kat/PQCgenKAT_kem.c kat/aes.c kat/rng.c $(SOURCES)

test: $(HEADERS) randombytes.h $(SOURCES) randombytes.c test/test.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(MINGW_ASFLAGS) -I. -o $(BUILD_DIR)/test randombytes.c test/test.c $(SOURCES) $(MINGW_LDLIBS)

clean:
	$(RM) PQCkemKAT_*.req PQCkemKAT_*.rsp
	$(RM) -r $(BUILD_DIR)
