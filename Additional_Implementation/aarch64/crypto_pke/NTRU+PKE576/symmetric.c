#include "symmetric.h"


#ifdef SUPPORTS_SHAKE256_ASM
#include "CE/SHAKE256/fips202.h"
#else
#include "NO_CE/SHAKE256/fips202.h"
#endif

#ifdef SUPPORTS_SHA256_ASM
#include "CE/SHA256/sha256.h"
#else
#include "NO_CE/SHA256/sha2.h"
#endif

void hash_f(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_PUBLICKEYBYTES] = {0x0};

	for (int i = 0; i < NTRUPLUS_PUBLICKEYBYTES; i++)
	{
		data[i+1] = msg[i];
	}
	
	sha256(buf, data, NTRUPLUS_PUBLICKEYBYTES + 1);
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

void hash_h_pke(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES] = {0x3};

	for (int i = 0; i < NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES; i++)
	{
		data[i+1] = msg[i];
	}

	shake256(buf,NTRUPLUS_N/4,data,NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES+1);
}
