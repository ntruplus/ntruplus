#include <openssl/sha.h>
#include "symmetric.h"
#include "crypto_stream.h"
static const unsigned char n[16] = {0};

void hash_h(unsigned char *buf, const unsigned char *msg)
{
	SHA512(msg, NTRUPLUS_SYMBYTES, buf);
	crypto_stream(buf + 32, 320, n, buf + 32);
}