#include <openssl/sha.h>
#include "symmetric.h"
#include "crypto_stream.h"
static const unsigned char n[16] = {0};

void hash_h(unsigned char *buf, const unsigned char *msg)
{
	SHA512(msg, NTRUPLUS_N/8, buf);
	crypto_stream(buf + 32, NTRUPLUS_N/4, n, buf + 32);
}

void hash_g(unsigned char *buf, const unsigned char *msg)
{
	SHA512(msg, NTRUPLUS_POLYBYTES, buf);
	crypto_stream(buf, NTRUPLUS_N/4, n, buf);
}