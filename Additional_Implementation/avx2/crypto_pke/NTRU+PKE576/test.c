#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"
#include "randombytes.h"
#include "poly.h"
#include "symmetric.h"

#define TEST_LOOP 100000
#define TEST_LOOP1 10000
#define TEST_LOOP2 100000

static inline uint64_t cpucycles(void) 
{
	uint64_t result;
	
	__asm__ volatile ("rdtsc; shlq $32,%%rdx; orq %%rdx,%%rax"
	: "=a" (result) : : "%rdx");
	
	return result;
}

static void TEST_PKE()
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES];
	unsigned char sk[CRYPTO_SECRETKEYBYTES];
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
	unsigned char m[CRYPTO_MAXPLAINTEXT];
	unsigned char dm[CRYPTO_MAXPLAINTEXT];
	unsigned long long mlen = 0;
	unsigned long long dmlen = 0;
	unsigned long long clen = 0;
	int cnt = 0;

	printf("================ CORRECTNESS TEST ================\n");

	//Generate public and secret key
	crypto_encrypt_keypair(pk, sk);

	//Encrypt and Decrypt message
	for (int i = 0; i < 32; i++)
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
	unsigned char m[CRYPTO_MAXPLAINTEXT] = {0};
	unsigned char dm[CRYPTO_MAXPLAINTEXT];
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

static void TEST_MODULE_CLOCK()
{
	unsigned char buf[10000] = {0};

	poly a,b,c;
	unsigned long long kcycles;
	unsigned long long cycles1, cycles2;
	
	printf("========= CCA KEM ENCAP DECAP SPEED TEST =========\n");
	
	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		a.coeffs[i] = b.coeffs[i] = c.coeffs[i] = 0;
	}
	a.coeffs[0] = 1;
	poly_ntt(&b,&a);
	
	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_baseinv(&a, &b);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_baseinv runs in ........... %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_invntt(&a, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_invntt runs in ............ %8lld cycles", kcycles/TEST_LOOP);
	printf("\n"); 

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_basemul(&a, &a, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_basemul runs in ........... %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_ntt(&a, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_ntt runs in ............... %8lld cycles", kcycles/TEST_LOOP);
	printf("\n"); 

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_sotp_inv(buf, &a, buf);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_sotp_inv runs in .......... %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_tobytes(buf, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_tobytes runs in ........... %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");
	
	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_sotp(&a, buf, buf);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_sotp runs in .............. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_cbd1(&a, buf);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_cbd1 runs in .............. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");	

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_frombytes(&a, buf);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_frombytes runs in ......... %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_crepmod3(&a, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_crepmod3 runs in .......... %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_triple(&a, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_triple runs in ............ %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		poly_sub(&a, &a, &a);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  poly_sub runs in ............... %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		hash_f(buf, buf);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  hash_f runs in ................. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		hash_g(buf, buf);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  hash_g runs in ................. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		hash_h_pke(buf, buf);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  hash_h_pke runs in ............. %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");
		
	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		randombytes(buf, NTRUPLUS_N / 8);
		cycles2 = cpucycles();
		kcycles += cycles2-cycles1;
	}
	printf("  randombytes runs in ............ %8lld cycles", kcycles/TEST_LOOP);
	printf("\n");
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
	TEST_MODULE_CLOCK();

	return 0;	
}
