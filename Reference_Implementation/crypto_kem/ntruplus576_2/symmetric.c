#include "sha2.h"
#include "aes256ctr.h"
#include "symmetric.h"

static const unsigned char n[16] = {0};

void hash_h(unsigned char *buf, const unsigned char *msg)
{
	sha512(buf, msg, NTRUPLUS_N/8);
  aes256ctr_prf(buf + 32, NTRUPLUS_N/4, buf + 32, n);
}

void hash_g(unsigned char *buf, const unsigned char *msg)
{
	sha256(buf, msg, NTRUPLUS_POLYBYTES);
  aes256ctr_prf(buf, NTRUPLUS_N/4, buf, n);
}