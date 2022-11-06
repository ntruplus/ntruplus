#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"
#include "rng.h"
#include "poly.h"
#define TEST_LOOP 1

int64_t cpucycles(void)
{
	unsigned int hi, lo;

    __asm__ __volatile__ ("rdtsc\n\t" : "=a" (lo), "=d"(hi));

    return ((int64_t)lo) | (((int64_t)hi) << 32);
}

void TEST_CCA_KEM()
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

void TEST_CCA_KEM_CLOCK()
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

void test_ntt()
{
	poly a,b,c,d,e,f;

	for(int i = 0; i < NTRUPLUS_N; i++)
	{
		a.coeffs[i] = 0;
		b.coeffs[i] = 0;
		c.coeffs[i] = 0;
		d.coeffs[i] = 0;
	}

	for(int i = 0; i < NTRUPLUS_N/3; i++)
	{
		a.coeffs[i] = 1;
		b.coeffs[i] = 1;
	}	

	poly_ntt(&c,&a);
	poly_freeze(&c);
	for(int i = 0; i < NTRUPLUS_N; i++)
	{
		if(i%16==0) printf("\n");
		printf("%d ", c.coeffs[i]);
	}
	printf("\n");

	poly_baseinv(&d,&c);
	poly_freeze(&d);

	//poly_ntt_pack(&d,&d);
/*
	poly_basemul(&e,&c,&d);

	poly_invntt(&f,&e);
*/
	for(int i = 0; i < NTRUPLUS_N; i++)
	{
		if(i%16==0) printf("\n");
		printf("%d ", d.coeffs[i]);
	}
	printf("\n");
}

int main(void)
{
	printf("PUBLICKEYBYTES : %d\n", CRYPTO_PUBLICKEYBYTES);
	printf("SECRETKEYBYTES : %d\n", CRYPTO_SECRETKEYBYTES);
	printf("CIPHERTEXTBYTES : %d\n", CRYPTO_CIPHERTEXTBYTES);

	test_ntt();
	//TEST_CCA_KEM();
	//TEST_CCA_KEM_CLOCK();
	
	return 0;	
}