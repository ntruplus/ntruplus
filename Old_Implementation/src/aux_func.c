#include "aux_func.h"
#include "crypto_stream.h"
#include <openssl/sha.h>

static const unsigned char n[16] = {0};

void G(poly *e, const unsigned char *msg)
{
	unsigned char buf[128] = {0};

	poly_pack_short_partial(buf, e);
	SHA512(buf, 128, buf);
	G_internal(e, msg, buf);
}

void G_inv(unsigned char *msg, poly *e)
{
	unsigned char buf[128] = {0};

	poly_pack_short_partial(buf, e);
	SHA512(buf, 128, buf);
	G_inv_internal(msg, e, buf);
}

void H(unsigned char *buf, const unsigned char *msg)
{
	SHA512(msg, MSGBYTES, buf);
	crypto_stream(buf + 32, 320, n, buf + 32);
}
