#include "sha2.h"
#include "symmetric.h"
#include "crypto_stream.h"
static const unsigned char n[16] = {0};

void hash_h(unsigned char *buf, const unsigned char *msg)
{
	sha512(buf, msg, NTRUPLUS_SYMBYTES);
	crypto_stream(buf + 32, 512, n, buf + 32);
}

void hash_g(unsigned char *buf, const unsigned char *msg)
{
	sha512(buf, msg, NTRUPLUS_POLYBYTES);
	crypto_stream(buf, NTRUPLUS_N/4, n, buf);
}
	