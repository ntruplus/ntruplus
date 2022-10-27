#include "sha2.h"
#include "symmetric.h"
#include "crypto_stream.h"
static const unsigned char n[16] = {0};

void hash_h(unsigned char *buf, const unsigned char *msg)
{
	sha512(buf, msg, NTRUPLUS_SYMBYTES);
	crypto_stream(buf + 32, NTRUPLUS_INDCPA_COIN, n, buf + 32);
}