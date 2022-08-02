#include <stdio.h>
#include "cca_kem.h"
#include "poly.h"
#include "randombytes.h"
#include <string.h>

#define TEST_LOOP 1000000
int64_t cpucycles(void)
{
	unsigned int hi, lo;

    __asm__ __volatile__ ("rdtsc\n\t" : "=a" (lo), "=d"(hi));

    return ((int64_t)lo) | (((int64_t)hi) << 32);
}

void TEST_CCA_KEM()
{
	unsigned char pk[PUBLICKEYBYTES];
	unsigned char sk[SECRETKEYBYTES];
	unsigned char ct[CIPHERTEXTBYTES];
	unsigned char ss[SHAREDKEYBYTES];
	unsigned char dss[SHAREDKEYBYTES];

	int cnt = 0;

	printf("============ CCA_KEM ENCAP DECAP TEST ============\n");

	//Generate public and secret key
	cca_kem_keygen(pk, sk);

	//Encrypt and Decrypt message
	for(int j = 0; j < TEST_LOOP; j++)
	{
		cca_kem_encap(ct, ss, pk);
		cca_kem_decap(dss, ct, sk);

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
	unsigned char pk[PUBLICKEYBYTES];
	unsigned char sk[SECRETKEYBYTES];
	unsigned char ct[CIPHERTEXTBYTES];
	unsigned char ss[SHAREDKEYBYTES];
	unsigned char dss[SHAREDKEYBYTES];

    unsigned long long kcycles, ecycles, dcycles;
    unsigned long long cycles1, cycles2;

	printf("========= CCA KEM ENCAP DECAP SPEED TEST =========\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		cca_kem_keygen(pk, sk);
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
		cca_kem_encap(ct, ss, pk);
        cycles2 = cpucycles();
        ecycles += cycles2-cycles1;

		cycles1 = cpucycles(); 
		cca_kem_decap(dss, ct, sk);
		cycles2 = cpucycles();
        dcycles += cycles2-cycles1;
	}

    printf("  ENCAP  runs in ................. %8lld cycles", ecycles/TEST_LOOP);
    printf("\n"); 

    printf("  DECAP  runs in ................. %8lld cycles", dcycles/TEST_LOOP);
    printf("\n"); 

	printf("==================================================\n");
}

void test_poly()
{
	poly a;
	poly b;

	poly c;
	poly d;

	poly e;
	poly f;

	for (int i = 0; i < 384; i++)
	{
		a.coeffs[i] = 1;
		b.coeffs[i] = 1;		
	}
/*
	for (int i = 0; i < 384; i++)
	{
		a.coeffs[384 + i] = 1;
		b.coeffs[384 + i] = 1;		
	}
*/
	poly_ntt(&c, &a);
	poly_ntt(&d, &b);

	poly_basemul(&e, &c, &d);
	
	poly_invntt(&f, &e);

	for (int i = 0; i < 768; i++)
	{
		printf(" %d", f.coeffs[i]);
	}
	printf("\n");
}

int main(void)
{
	
	printf("PUBLICKEYBYTES : %d\n", PUBLICKEYBYTES);
	printf("SECRETKEYBYTES : %d\n", SECRETKEYBYTES);
	printf("CIPHERTEXTBYTES : %d\n", CIPHERTEXTBYTES);

	TEST_CCA_KEM();
	TEST_CCA_KEM_CLOCK();

	//test_poly();

	return 0;	
}