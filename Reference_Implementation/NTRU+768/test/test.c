#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"
#include "randombytes.h"
#include "poly.h"
#include "symmetric.h"
#include "counter.h"

#if defined(__aarch64__)
#define COUNTER_UNIT_STR "ticks"
#elif defined(__x86_64__) || defined(__i386__)
#define COUNTER_UNIT_STR "cycles"
#else
#error "counter unsupported on this architecture"
#endif

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
	for(int j = 0; j < TEST_LOOP_COUNT; j++)
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
}

static void TEST_CCA_KEM_CLOCK(void)
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES] = {0};
	unsigned char sk[CRYPTO_SECRETKEYBYTES] = {0};
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES] = {0};
	unsigned char ss[CRYPTO_BYTES] = {0};
	unsigned char dss[CRYPTO_BYTES] = {0};

	unsigned long long kcycles, ecycles, dcycles;
	unsigned long long count1, count2;
	
	printf("========= CCA KEM ENCAP DECAP SPEED TEST =========\n");
	
	kcycles=0;
	for (int i = 0; i < TEST_LOOP_COUNT; i++)
	{
		count1 = counter();
		crypto_kem_keypair(pk, sk);
		count2 = counter();
		kcycles += count2 - count1 - countergap;
	}
	printf("  KEYGEN runs in ................. %8lld %s", kcycles/TEST_LOOP_COUNT, COUNTER_UNIT_STR);
	printf("\n"); 
	
	ecycles=0;
	dcycles=0;
	for (int i = 0; i < TEST_LOOP_COUNT; i++)
	{
		count1 = counter();
		crypto_kem_enc(ct, ss, pk);
		count2 = counter();
		ecycles += count2 - count1 - countergap;
		
		count1 = counter(); 
		crypto_kem_dec(dss, ct, sk);
		count2 = counter();
		dcycles += count2 - count1 - countergap;
	}
	
	printf("  ENCAP  runs in ................. %8lld %s\n", ecycles/TEST_LOOP_COUNT, COUNTER_UNIT_STR);
	printf("  DECAP  runs in ................. %8lld %s\n", dcycles/TEST_LOOP_COUNT, COUNTER_UNIT_STR);
}

int main(void)
{
	printf("================= BENCHMARK INFO =================\n");
	setup_counter();
	printf("ITERATIONS: %d\n", TEST_LOOP_COUNT);
	printf("COUNTERGAP: %lld %s\n", countergap, COUNTER_UNIT_STR);
	printf("=================== PARAMETERS ===================\n");
	printf("ALGORITHM_NAME  : %s\n", CRYPTO_ALGNAME);
	printf("PUBLICKEYBYTES  : %d\n", CRYPTO_PUBLICKEYBYTES);
	printf("SECRETKEYBYTES  : %d\n", CRYPTO_SECRETKEYBYTES);
	printf("CIPHERTEXTBYTES : %d\n", CRYPTO_CIPHERTEXTBYTES);

	TEST_CCA_KEM();
	TEST_CCA_KEM_CLOCK();

	return 0;
}
