#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"
#include "randombytes.h"
#include "cpucycles.h"


#define TEST_LOOP1 10000
#define TEST_LOOP2 100000

static void TEST_PKE()
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES];
	unsigned char sk[CRYPTO_SECRETKEYBYTES];
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
	unsigned char m[144];
	unsigned char dm[144];
	unsigned long long mlen = 0;
	unsigned long long dmlen = 0;
	unsigned long long clen = 0;
	int cnt = 0;

	printf("================ CORRECTNESS TEST ================\n");

	//Generate public and secret key
	crypto_encrypt_keypair(pk, sk);

	//Encrypt and Decrypt message
	for (int i = 0; i < 68; i++)
	{
		for(int j = 0; j < TEST_LOOP1; j++)
		{
			randombytes(m, i);
			mlen = i;
			dmlen = 0;

			crypto_encrypt(ct, &clen, m, mlen, pk);
			crypto_encrypt_open(dm, &dmlen, ct, clen, sk);

			if(mlen != dmlen || memcmp(m, dm, dmlen) != 0)
			{
				cnt++;
				continue;
			}
		}
	}
	printf("count: %d\n\n", cnt);
}

static void TEST_PKE_CLOCK()
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES];
	unsigned char sk[CRYPTO_SECRETKEYBYTES];
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
	unsigned char m[144] = {0};
	unsigned char dm[144];
	unsigned long long mlen = 0;
	unsigned long long dmlen = 0;
	unsigned long long clen = 0;

    unsigned long long kcycles, ecycles, dcycles;
    unsigned long long cycles1, cycles2;

	printf("=================== SPEED TEST ===================\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP2; i++)
	{
		cycles1 = cpucycles();
		crypto_encrypt_keypair(pk, sk);
        cycles2 = cpucycles();
        kcycles += cycles2-cycles1;
	}
    printf("  KEYGEN runs in ................. %8lld cycles", kcycles/TEST_LOOP2);
    printf("\n"); 

	ecycles=0;
	dcycles=0;

	mlen = 32;

	for (int i = 0; i < TEST_LOOP2; i++)
	{
		cycles1 = cpucycles();
		crypto_encrypt(ct, &clen, m, mlen, pk);
        cycles2 = cpucycles();
        ecycles += cycles2-cycles1;

		cycles1 = cpucycles(); 
		crypto_encrypt_open(dm, &dmlen, ct, clen, sk);
		cycles2 = cpucycles();
        dcycles += cycles2-cycles1;
	}

    printf("  ENC    runs in ................. %8lld cycles", ecycles/TEST_LOOP2);
    printf("\n"); 

    printf("  DEC    runs in ................. %8lld cycles", dcycles/TEST_LOOP2);
    printf("\n\n"); 
}

int main(void)
{
	printf("=================== PARAMETERS ===================\n");
	printf("ALGORITHM_NAME  : %s\n", CRYPTO_ALGNAME);
	printf("PUBLICKEYBYTES  : %d\n", CRYPTO_PUBLICKEYBYTES);
	printf("SECRETKEYBYTES  : %d\n", CRYPTO_SECRETKEYBYTES);
	printf("CIPHERTEXTBYTES : %d\n", CRYPTO_CIPHERTEXTBYTES);
	printf("\n");

	TEST_PKE();
	TEST_PKE_CLOCK();

	return 0;	
}