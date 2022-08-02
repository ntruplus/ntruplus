INCDIR   := inc
SRCDIR   := src

CC=gcc

SOURCE = main.c ./src/*.c ./src/random/*.c ./src/asm/*.s  

HEADER = -I./$(INCDIR) -I./$(INCDIR)/random
CFLAGS  = -march=native -mtune=native -O3 -fomit-frame-pointer
LDFLAGS = -lcrypto

all: PARAM_128

PARAM_128:
	$(CC)  -c  $(SOURCE) $(HEADER) $(CFLAGS)
	$(CC)  *.o -o main $(LDFLAGS) $(CFLAGS)
	rm *.o