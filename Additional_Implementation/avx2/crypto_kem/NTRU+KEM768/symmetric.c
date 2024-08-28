#include <openssl/sha.h>
#include "symmetric.h"
#include "Keccak_avx2/fips202.h"

void hash_f(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_PUBLICKEYBYTES] = {0x0};

	for (int i = 0; i < NTRUPLUS_PUBLICKEYBYTES; i++)
	{
		data[i+1] = msg[i];
	}

	SHA256(data, NTRUPLUS_PUBLICKEYBYTES + 1, buf);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_POLYBYTES] = {0x1};

	for (int i = 0; i < NTRUPLUS_POLYBYTES; i++)
	{
		data[i+1] = msg[i];
	}
	
	shake256(buf,NTRUPLUS_N/4,data,NTRUPLUS_POLYBYTES+1);
}

void hash_h_kem(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES] = {0x2};

	for (int i = 0; i < NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES; i++)
	{
		data[i+1] = msg[i];
	}

	shake256(buf,NTRUPLUS_SSBYTES + NTRUPLUS_N/4,data,NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES+1);
}