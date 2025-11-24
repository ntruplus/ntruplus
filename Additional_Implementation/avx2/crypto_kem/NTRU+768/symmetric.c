#include "symmetric.h"
#include "Keccak_avx2/fips202.h"

void hash_f(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_POLYBYTES];
	
	data[0] = 'F';

	for (int i = 0; i < NTRUPLUS_POLYBYTES; i++)
	{
		data[i+1] = msg[i];
	}
	
	shake256(buf,32,data,NTRUPLUS_POLYBYTES+1);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_POLYBYTES];

	data[0] = 'G';

	for (int i = 0; i < NTRUPLUS_POLYBYTES; i++)
	{
		data[i+1] = msg[i];
	}
	
	shake256(buf,NTRUPLUS_N/4,data,NTRUPLUS_POLYBYTES+1);
}

void hash_h(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES];
	
	data[0] = 'H';

	for (int i = 0; i < NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES; i++)
	{
		data[i+1] = msg[i];
	}

	shake256(buf,NTRUPLUS_SSBYTES + NTRUPLUS_N/4,data,NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES+1);
}
