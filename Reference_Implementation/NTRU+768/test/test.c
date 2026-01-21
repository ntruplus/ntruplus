#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"
#include "randombytes.h"
#include "poly.h"
#include "symmetric.h"
#include "cpucycles.h"

#define TEST_LOOP 100000

static void TEST_CCA_KEM(void)
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES] = {0};
	unsigned char sk[CRYPTO_SECRETKEYBYTES] = {0};
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES] = {0};
	unsigned char ss[CRYPTO_BYTES] = {0};
	unsigned char dss[CRYPTO_BYTES] = {0};

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

static void TEST_CCA_KEM_CLOCK(void)
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES] = {0};
	unsigned char sk[CRYPTO_SECRETKEYBYTES] = {0};
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES] = {0};
	unsigned char ss[CRYPTO_BYTES] = {0};
	unsigned char dss[CRYPTO_BYTES] = {0};

	unsigned long long kcycles, ecycles, dcycles;
	unsigned long long cycles1, cycles2;
	
	printf("========= CCA KEM ENCAP DECAP SPEED TEST =========\n");
	
	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		crypto_kem_keypair(pk, sk);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1-cyclegap;
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
		ecycles += cycles2-cycles1-cyclegap;
		
		cycles1 = cpucycles(); 
		crypto_kem_dec(dss, ct, sk);
		cycles2 = cpucycles();
		dcycles += cycles2-cycles1-cyclegap;
	}
	
	printf("  ENCAP  runs in ................. %8lld cycles", ecycles/TEST_LOOP);
	printf("\n"); 
	
	printf("  DECAP  runs in ................. %8lld cycles", dcycles/TEST_LOOP);
	printf("\n"); 
	
	printf("==================================================\n\n");
}

int main(void)
{
	printf("================= BENCHMARK INFO =================\n");
	setup_rdtsc();
	printf("cyclegap: %lld\n",cyclegap);
	printf("==================================================\n\n");

	printf("=================== PARAMETERS ===================\n");
	printf("ALGORITHM_NAME  : %s\n", CRYPTO_ALGNAME);
	printf("PUBLICKEYBYTES  : %d\n", CRYPTO_PUBLICKEYBYTES);
	printf("SECRETKEYBYTES  : %d\n", CRYPTO_SECRETKEYBYTES);
	printf("CIPHERTEXTBYTES : %d\n", CRYPTO_CIPHERTEXTBYTES);
	printf("==================================================\n\n");

	TEST_CCA_KEM();
	TEST_CCA_KEM_CLOCK();

	return 0;
}
