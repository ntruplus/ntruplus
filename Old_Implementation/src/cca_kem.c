#include <stddef.h>
#include <openssl/sha.h>
#include "randombytes.h"
#include "crypto_stream.h"
#include "params.h"
#include "cpa_pke.h"
#include "poly.h"
#include "aux_func.h"

static const unsigned char n[16] = {0};

int cca_kem_keygen(unsigned char *pk, unsigned char *sk)
{
	unsigned char coins[N];
	poly hhat, fhat;

	int i = 0;
	do {
		randombytes(coins, 32);
		crypto_stream(coins, N, n, coins);
	} while(cpa_pke_keygen(&hhat, &fhat, coins));

	poly_pack_uniform(pk, &hhat);
	poly_pack_uniform(sk, &fhat);

	for(int i = 0; i < PUBLICKEYBYTES; i++)
	{
		sk[i + POLY_PACKED_UNIFORM_BYTES] = pk[i];
	} 
	return 0;
}

int cca_kem_encap(unsigned char *c, unsigned char *k, const unsigned char *pk)
{
	unsigned int i;
	unsigned char msg[MSGBYTES] = {0};
	unsigned char buf[352] ={0}; //key || coin

	poly hhat, chat;

	randombytes(msg, 32);
	H(buf, msg);

	poly_unpack_uniform(&hhat, pk);
	cpa_pke_encrypt(&chat, &hhat, msg, buf + 32);
	poly_pack_uniform(c, &chat);

	for (i = 0; i < SHAREDKEYBYTES; ++i)
	{
		k[i] = buf[i];
	}

	return 0;
}

int cca_kem_decap(unsigned char *k, const unsigned char *c, const unsigned char *sk)
{
	unsigned int i;
	unsigned char msg[MSGBYTES] = {0};
	unsigned char buf[352] ={0}; //key || coin

	int16_t t;
	int32_t fail;
	poly hhat, chat, fhat;

	poly_unpack_uniform(&chat, c);
	poly_unpack_uniform(&fhat, sk);
	cpa_pke_decrypt(msg, &chat, &fhat);

	H(buf, msg);

	poly_unpack_uniform(&hhat, sk + POLY_PACKED_UNIFORM_BYTES);
	cpa_pke_encrypt(&fhat, &hhat, msg, buf + 32);

	t = 0;
	for(i = 0; i < N; ++i)
	{
		t |= chat.coeffs[i] ^ fhat.coeffs[i];
	}	

	fail = (uint16_t)t;
	fail = (-fail) >> 31;
	for(i = 0; i < SHAREDKEYBYTES; ++i)
	{
		k[i] = buf[i] & ~(fail);
	}

	return fail;
}
