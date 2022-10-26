#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"
#include "rng.h"

#include "poly.h"
#include "ntt.h"

#define TEST_LOOP 100000
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

void test_ntt_clock()
{
    int16_t a[NTRUPLUS_N] = {0};
    int16_t b[NTRUPLUS_N] = {0};
    int16_t c[NTRUPLUS_N] = {0};

    unsigned long long kcycles, ecycles, dcycles;
    unsigned long long cycles1, cycles2;

	printf("========= CCA KEM ENCAP DECAP SPEED TEST =========\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
   		ntt(a);
        cycles2 = cpucycles();
        kcycles += cycles2-cycles1;
	}
    printf("  KEYGEN runs in ................. %8lld cycles", kcycles/TEST_LOOP);
    printf("\n"); 

	printf("==================================================\n");
}

int test_ntt()
{
	poly a,b,c,d;
	uint8_t buf[1000] = {0};

	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		//buf[i] = i;
		a.coeffs[i] = 1;
	}


	poly_ntt(&a); 
	poly_freeze(&a); 
	poly_invntt(&a);
	poly_freeze(&a);
	
    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        if(i%16==0) printf("\n");
        printf("%d " , a.coeffs[i]);
    }
    printf("\n");
}

int test_ntt2()
{
	poly a,b,c;

    for (int i = 0; i < NTRUPLUS_N; i++)
    {
		a.coeffs[i] = 0;
		b.coeffs[i] = 0;
    }


    for (int i = 0; i < 200; i++)
    {
		a.coeffs[i] = 1;
		b.coeffs[i] = 1;	
    }

	poly_ntt(&a);
	poly_ntt(&b);


	poly_basemul(&c, &a, &a);
	poly_freeze(&c);
	poly_invntt(&c);

    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        if(i%32==0) printf("\n");
        printf("%d " , c.coeffs[i]);
    }
    printf("\n");

}

int test_ntt3()
{
	poly a,b,c,d;
	uint8_t buf[1000] = {0};

	for (int i = 0; i < 1000; i++)
	{
		buf[i] = i;
	}
	
    poly_cbd1(&a, buf);  
	poly_ntt(&a);

    poly_baseinv(&c, &a);
	poly_basemul(&d, &c, &a);
	poly_freeze(&d);
	poly_invntt(&d);
}

void test_tofrom()
{
	poly a,b,c;

	uint8_t buf[2000];
    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        a.coeffs[i] = i;
    }

	poly_tobytes(buf, &a);
	poly_frombytes(&b, buf);

    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        if(i%16==0) printf("\n");
        printf("%d " , b.coeffs[i]);
    }
    printf("\n");

}

void test_sotp()
{
	poly a;
	uint8_t buf[144];
	uint8_t msg[32];

	randombytes(msg,32);
	randombytes(buf,144);

	for (int i = 0; i < 32; i++)
	{
		if(i%16==0)	printf("\n");
		printf("%d ", msg[i]);
	}
	printf("\n");

	poly_sotp(&a,msg,buf);

	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		if(i%16==0)	printf("\n");
		printf("%d ", a.coeffs[i]);
	}
	printf("\n");

	poly_sotp_inv(msg,&a,buf);
	
	for (int i = 0; i < 32; i++)
	{
		if(i%16==0)	printf("\n");
		printf("%d ", msg[i]);
	}
	printf("\n");
}
int main(void)
{

	unsigned char entropy_input[48] = {0};
	unsigned char personalization_string[48] = {0};

	printf("PUBLICKEYBYTES : %d\n", CRYPTO_PUBLICKEYBYTES);
	printf("SECRETKEYBYTES : %d\n", CRYPTO_SECRETKEYBYTES);
	printf("CIPHERTEXTBYTES : %d\n", CRYPTO_CIPHERTEXTBYTES);

	randombytes_init(entropy_input, personalization_string, 128);

	//test_tofrom();
	//test_ntt();
	//test_ntt2();
	//test_ntt3();
	//test_ntt_clock();
	//test_sotp();
	TEST_CCA_KEM();
	TEST_CCA_KEM_CLOCK();
	
	return 0;	
}