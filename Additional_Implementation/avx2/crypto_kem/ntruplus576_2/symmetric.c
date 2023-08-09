#include <openssl/sha.h>
#include "symmetric.h"
#include "aes256ctr.h"

void hash_h(unsigned char *buf, const unsigned char *msg)
{
	SHA512(msg, NTRUPLUS_N/8, buf);
	aes256ctr_prf(buf + NTRUPLUS_SYMBYTES, NTRUPLUS_N/4, buf + NTRUPLUS_SYMBYTES, 0);
}

void hash_g(unsigned char *buf, const unsigned char *msg)
{
	SHA256(msg, NTRUPLUS_POLYBYTES, buf);
	aes256ctr_prf(buf, NTRUPLUS_N/4, buf, 0);
}