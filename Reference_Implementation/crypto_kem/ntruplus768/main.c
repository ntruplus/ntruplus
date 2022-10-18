#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"
#include "ntt.h"
#include "poly.h"
#include "reduce.h"
#include "sotp.h"
#include "rng.h"

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
void test_ntt_pack()
{
	uint16_t a[768] = {0};
	uint16_t b[768] = {0};
	uint16_t c[768] = {0};	

	for (int i = 0; i < 768; i++)
	{
		a[i] = i+1;
	}

	for (int i = 0; i < 768; i++)
	{
		if(i%16 == 0) 	printf("\n");
		printf("%d ", a[i]);
	}
	printf("\n");

	ntt_pack(b,a);
	
	for (int i = 0; i < 768; i++)
	{
		if(i%16 == 0) 	printf("\n");		
		printf("%d ", b[i]);
	}
	printf("\n");

	ntt_unpack(c,b);
	
	for (int i = 0; i < 768; i++)
	{
		if(i%16 == 0) 	printf("\n");		
		printf("%d ", c[i]);
	}
	printf("\n");

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
void test_ntt()
{
	poly a,b,c;


	for (int i = 0; i < 768; i++)
	{
		a.coeffs[i] = i;
	}

	printf("before\n");
	for (int i = 0; i < 768; i++)
	{
		printf("%d ", a.coeffs[i]);
	}
	printf("\n");


	poly_ntt(&a);
	poly_freeze(&a);	

	
	printf("after\n");
	for (int i = 0; i < 768; i++)
	{
		
		if(i%16==0) printf("\n");
		printf("%4d ", a.coeffs[i]);
	}
	printf("\n");

	poly_invntt(&a);
	poly_freeze(&a);
	printf("return\n");	
	for (int i = 0; i < 768; i++)
	{
		if(i%16==0) printf("\n");
		printf("%4d ", a.coeffs[i]);
	}
	printf("\n");

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


	sotp_inv_internal(msg, &a, buf);

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


void test_poly_tobytes()
{
	uint8_t buf[NTRUPLUS_POLYBYTES] = {0};
	poly a,b;

	for (int i = 0; i < 768; i++)
	{
		a.coeffs[i] = i;
		b.coeffs[i] = 0;
	}

	for (int i = 0; i < 768; i++)
	{
		if(i%16==0) printf("\n");
		printf("%4d ", a.coeffs[i]);
	}
	printf("\n");

	poly_tobytes(buf, &a);
	poly_frombytes(&b, buf);

	for (int i = 0; i < NTRUPLUS_POLYBYTES; i++)
	{
		if(i%32 == 0) printf("\n");
		printf("%02X", buf[i]);
	}
	printf("\n");
	for (int i = 0; i < 768; i++)
	{
		if(i%16==0) printf("\n");
		printf("%4d ", b.coeffs[i]);
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

	TEST_CCA_KEM();
	//TEST_CCA_KEM_CLOCK();




//	test_ntt_pack();
	//test_poly_pack();
	//test_ntt();
	//test_poly_short();
	//test_poly_tobytes();
	
	return 0;	
}