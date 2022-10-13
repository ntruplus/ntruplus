#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"

#include "rng.h"
#include "poly.h"
#include "sotp.h"

#define TEST_LOOP 1000000
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

void test_poly_short()
{
	uint8_t msg[32] = {0};
	uint8_t buf[64] = {0};

	poly a,b;


	for (int i = 0; i < 32; i++)
	{
		msg[i] = 0x5;
	}

	for (int i = 0; i < 64; i++)
	{
		buf[i] = 0xaa;
	}

	sotp_internal(&a, msg, buf);

	for (int i = 512; i < 768; i++)
	{
		printf("%d ", a.coeffs[i]);
	}
	printf("\n\n");


	sotp_internal2(&b, msg, buf);

	for (int i = 512; i < 768; i++)
	{
		printf("%d ", b.coeffs[i]);
	}
	printf("\n\n");


	sotp_inv_internal2(msg, &a, buf);

	for (int i = 0; i < 32; i++)
	{
		printf("%d ", msg[i]);
	}
	printf("\n\n");

/*
	for(int i=0;i<768;i++)
	{
		b.coeffs[i] = 0;
	}

	poly_short5(&b, buf);

	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		//if(i%16 == 0) printf("\n");
		printf("%d ", b.coeffs[i]);
	}
	printf("\n");
*/
}

void test_poly_pack()
{
	poly a,b;

	uint8_t buf[1152] = {0};

	for (int i = 0; i < 768; i++)
	{
		a.coeffs[i] = i;
	}
	
	poly_tobytes(buf, &a);

	for (int i = 0; i < 1152; i++)
	{
		printf("%d ", buf[i]);
	}
	printf("\n\n");

	poly_frombytes(&b, buf);

	for (int i = 0; i < 768; i++)
	{
		printf("%d ", b.coeffs[i]);
	}
	printf("\n");
}

void ntt_pack(int16_t b[768], const int16_t a[768])
{
	int16_t buf[12];

	for(int i = 0; i < 4; ++i)
	{
		for(int j = 0; j < 16; ++j) 
		{
			for(int k = 0; k < 12; k++)
			{
				buf[k] = a[192*i + 12*j + k];
			}

			for(int k = 0; k < 6; k++)
			{
				for(int l = 0; l < 2; l++)
				{
					b[192*i + 12*k + l] = buf[2*k];
					b[192*i + 12*k + 2*j+1] = buf[2*k + 1];
				}
			}
		}	
	}
}

void ntt_unpack(int16_t b[768], const int16_t a[768])
{
	unsigned j, k, l;
	int16_t buf[96];

	for(j = 0; j < 768/96; ++j)
	{
		for(k = 0; k < 6; ++k)
		{
			for(l = 0; l < 16; ++l)
			{
				buf[6*l + k] = a[96*j + 16*k + l];
			} 
		}
			
		for(k = 0; k < 96; ++k)
		{
			b[96*j + k] = buf[k];
		}
	}
}


void test_nttpack()
{
	poly a,b;

	for(int i=0; i<768;i++)
	{
		a.coeffs[i] = i+1;
	}

	for(int i = 0; i < 768; i++)
	{
		printf("%d ", a.coeffs[i]);
	}
	printf("\n");

	ntt_pack(b.coeffs,a.coeffs);

	for(int i = 0; i < 768; i++)
	{
		printf("%d ", b.coeffs[i]);
	}
	printf("\n");



}
int main(void)
{
	
	printf("PUBLICKEYBYTES : %d\n", CRYPTO_PUBLICKEYBYTES);
	printf("SECRETKEYBYTES : %d\n", CRYPTO_SECRETKEYBYTES);
	printf("CIPHERTEXTBYTES : %d\n", CRYPTO_CIPHERTEXTBYTES);

	//TEST_CCA_KEM();
	//TEST_CCA_KEM_CLOCK();

	//test_poly_short();
	//test_poly_pack();
	test_nttpack();
	return 0;	
}