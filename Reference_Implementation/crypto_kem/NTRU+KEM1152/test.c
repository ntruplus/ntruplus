#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"
#include "randombytes.h"
#include "cpucycles.h"

#define TEST_LOOP 100000

static void TEST_CCA_KEM()
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES];
	unsigned char sk[CRYPTO_SECRETKEYBYTES];
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
	unsigned char ss[CRYPTO_BYTES];
	unsigned char dss[CRYPTO_BYTES];

	int cnt = 0;

	printf("============ CCA_KEM ENCAP DECAP TEST ============\n");

	//Generate public and secret key
	crypto_kem_keypair(pk, sk);

	//Encrypt and Decrypt message
	for(int j = 0; j < TEST_LOOP; j++)
	{
		crypto_kem_enc(ct, ss, pk);
		crypto_kem_dec(dss, ct, sk);

		if(memcmp(ss, dss, 32) != 0)
		{
			printf("ss[%d]  : ", j);
			for(int i=0; i<32; i++) printf("%02X", ss[i]);
			printf("\n");
		
			printf("dss[%d] : ", j);
			for(int i=0; i<32; i++) printf("%02X", dss[i]);
			printf("\n");
		
			cnt++;
		}
	}
	printf("count: %d\n", cnt);
	printf("==================================================\n\n");

}

static void TEST_CCA_KEM_CLOCK()
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES];
	unsigned char sk[CRYPTO_SECRETKEYBYTES];
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
	unsigned char ss[CRYPTO_BYTES];
	unsigned char dss[CRYPTO_BYTES];

	unsigned long long kcycles, ecycles, dcycles;
	unsigned long long cycles1, cycles2;
	
	printf("========= CCA KEM ENCAP DECAP SPEED TEST =========\n");
	
	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		crypto_kem_keypair(pk, sk);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  KEYGEN runs in ................. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n"); 
	
	ecycles=0;
	dcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		crypto_kem_enc(ct, ss, pk);
		cycles2 = cpucycles();
		ecycles += cycles2-cycles1;
		
		cycles1 = cpucycles(); 
		crypto_kem_dec(dss, ct, sk);
		cycles2 = cpucycles();
		dcycles += cycles2-cycles1;
	}
	
	printf("  ENCAP  runs in ................. %8lld cycles", ecycles/TEST_LOOP);
	printf("\n"); 
	
	printf("  DECAP  runs in ................. %8lld cycles", dcycles/TEST_LOOP);
	printf("\n"); 
	
	printf("==================================================\n");
}

#include "poly.h"
#include "ntt.h"

void TEST_UNIT()
{
	unsigned long long kcycles, ecycles, dcycles;
	unsigned long long cycles1, cycles2;
	uint8_t buf[NTRUPLUS_N / 2] = {0};
	poly a,b,c,d,e,f;

	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		a.coeffs[i] = i;
	}

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_ntt(&b, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_ntt runs in ................. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_invntt(&b, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_invntt runs in ................. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n"); 	

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_basemul(&c, &b, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_basemul runs in ................. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_baseinv(&b, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_baseinv runs in ................. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n"); 	 		

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_cbd1(&b, buf);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_cbd1 runs in ................. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n"); 	 
}

int main(void)
{
	printf("PUBLICKEYBYTES : %d\n", CRYPTO_PUBLICKEYBYTES);
	printf("SECRETKEYBYTES : %d\n", CRYPTO_SECRETKEYBYTES);
	printf("CIPHERTEXTBYTES : %d\n", CRYPTO_CIPHERTEXTBYTES);

	//TEST_CCA_KEM();
	TEST_CCA_KEM_CLOCK();
	TEST_UNIT();

	return 0;	
}
