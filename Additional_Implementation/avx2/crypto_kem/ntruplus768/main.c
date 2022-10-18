#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"

#include "rng.h"
#include "poly.h"
#include "sotp.h"

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

void poly_cbd2(poly *a, const unsigned char buf[192])
{
	uint32_t t1, t2;

	for(int i = 0; i < 3; i++)
	{
		for(int j = 0; j < 8; j++)
		{
			t1 = load32_littleendian(buf + 32*i + 4*j);
			t2 = load32_littleendian(buf + 32*i + 4*j + 96);

			for (int k = 0; k < 2; k++)
			{
				for(int l = 0; l < 16; l++)
				{
					a->coeffs[256*i + 16*l + 2*j + k] = (t1 & 0x1) - (t2 & 0x1);

					t1 = t1 >> 1;
					t2 = t2 >> 1;
				}
			}
		}
	}
}

void poly_cbd1_m12(poly *a, const unsigned char buf[192])
{
	uint32_t t1, t2;

	for(int i = 0; i < 3; i++)
	{
		for(int j = 0; j < 8; j++)
		{
			t1 = load32_littleendian(buf + 32*i + 4*j);
			t2 = load32_littleendian(buf + 32*i + 4*j + 96);

			for (int k = 0; k < 2; k++)
			{
				for(int l = 0; l < 16; l++)
				{
					a->coeffs[256*i + 16*l + 2*j + k] = (t1 & 0x1) - (t2 & 0x1);

					t1 = t1 >> 1;
					t2 = t2 >> 1;
				}
			}
		}
	}
}

void test_cbd()
{
	poly a,b,c,d;

	uint8_t buf[192] = {0};


	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		a.coeffs[i] = 0;
		b.coeffs[i] = 0;
	}
	
	for (int i = 0; i < 192; i++)
	{
		buf[i] = rand()%256;
	}

	for (int i = 0; i < 1; i++)
	{
		buf[i] = 0xff;
	}

	for (int i = 0; i < 192; i++)
	{
		if(i%16 == 0) printf("\n");
		printf("%d ", buf[i]);
	}
	printf("\n");

	poly_cbd1(&a,buf);

	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		if(i%16 == 0) printf("\n");
		printf("%d ", a.coeffs[i]);
	}
	printf("\n");

	poly_cbd2(&b,buf);

	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		if(i%16 == 0) printf("\n");
		printf("%d ", a.coeffs[i] - b.coeffs[i]);
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

	for (int i = 0; i < 768; i++)
	{
		if(i%16==0) printf("\n");
		printf("%4d ", a.coeffs[i]);
	}
	printf("\n");

	poly_ntt_pack(&b, &a);

	
	printf("after\n");
	for (int i = 0; i < 768; i++)
	{
		if(i%16==0) printf("\n");
		printf("%4d ", b.coeffs[i]);
	}
	printf("\n");

	poly_ntt_unpack(&a,&b);
	
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

void poly_tobytes2(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a)
{
	int16_t t[16];

	for (int i = 0; i < 3; i++)
	{
		for (int j = 0; j < 16; j++)
		{
			for (int k = 0; k < 16; k++)
			{
				t[k] = a->coeffs[256*i + 16*k + j];
			}

			r[384*i + 2*j + 0] = (t[0] >> 0);
			r[384*i + 2*j + 1] = (t[0] >> 8) + (t[1] << 4);			
			r[384*i + 2*j + 32] = (t[1] >> 4);
			r[384*i + 2*j + 33] = (t[2] >> 0);
			r[384*i + 2*j + 64] = (t[2] >> 8) + (t[3] << 4); 
			r[384*i + 2*j + 65] = (t[3] >> 4); 	
			r[384*i + 2*j + 96] = (t[4] >> 0);
			r[384*i + 2*j + 97] = (t[4] >> 8) + (t[5] << 4); 
			r[384*i + 2*j + 128] = (t[5] >> 4); 
			r[384*i + 2*j + 129] = (t[6] >> 0);
			r[384*i + 2*j + 160] = (t[6] >> 8) + (t[7] << 4); 
			r[384*i + 2*j + 161] = (t[7] >> 4); 
			r[384*i + 2*j + 192] = (t[8] >> 0);
			r[384*i + 2*j + 193] = (t[8] >> 8) + (t[9] << 4); 
			r[384*i + 2*j + 224] = (t[9] >> 4); 
			r[384*i + 2*j + 225] = (t[10] >> 0);
			r[384*i + 2*j + 256] = (t[10] >> 8) + (t[11] << 4); 
			r[384*i + 2*j + 257] = (t[11] >> 4); 
			r[384*i + 2*j + 288] = (t[12] >> 0);
			r[384*i + 2*j + 289] = (t[12] >> 8) + (t[13] << 4); 
			r[384*i + 2*j + 320] = (t[13] >> 4); 
			r[384*i + 2*j + 321] = (t[14] >> 0);
			r[384*i + 2*j + 352] = (t[14] >> 8) + (t[15] << 4); 
			r[384*i + 2*j + 353] = (t[15] >> 4); 
		}	
	}
}

void poly_frombytes2(poly *a, const unsigned char *buf)
{
	unsigned char t[24];

	for(int i = 0; i < 3; ++i)
	{
		for(int j = 0; j < 16; ++j)
		{
			for(int k = 0; k < 12; ++k)
			{
				t[2*k] = buf[384*i + 2*j + 32*k];
				t[2*k+1] = buf[384*i + 2*j + 32*k + 1];
			}

			a->coeffs[256*i + j +   0]  = t[0];
			a->coeffs[256*i + j +   0] += ((int16_t)t[1] & 0xf) << 8;

			a->coeffs[256*i + j +  16]  = t[1] >> 4;
			a->coeffs[256*i + j +  16] += (int16_t)t[2] << 4;

			a->coeffs[256*i + j +  32]  = t[3];
			a->coeffs[256*i + j +  32] += ((int16_t)t[4] & 0xf) << 8;

			a->coeffs[256*i + j +  48]  = t[4] >> 4;
			a->coeffs[256*i + j +  48] += (int16_t)t[5] << 4;

			a->coeffs[256*i + j +  64]  = t[6];
			a->coeffs[256*i + j +  64] += ((int16_t)t[7] & 0xf) << 8;

			a->coeffs[256*i + j +  80]  = t[7] >> 4;
			a->coeffs[256*i + j +  80] += (int16_t)t[8] << 4;

			a->coeffs[256*i + j +  96]  = t[9];
			a->coeffs[256*i + j +  96] += ((int16_t)t[10] & 0xf) << 8;

			a->coeffs[256*i + j +  112]  = t[10] >> 4;
			a->coeffs[256*i + j +  112] += (int16_t)t[11] << 4;

			a->coeffs[256*i + j + 128]  = t[12];
			a->coeffs[256*i + j + 128] += ((int16_t)t[13] & 0xf) << 8;

			a->coeffs[256*i + j +  144]  = t[13] >> 4;
			a->coeffs[256*i + j +  144] += (int16_t)t[14] << 4;

			a->coeffs[256*i + j + 160]  = t[15];
			a->coeffs[256*i + j + 160] += ((int16_t)t[16] & 0xf) << 8;

			a->coeffs[256*i + j + 176]  = t[16] >> 4;
			a->coeffs[256*i + j + 176] += (int16_t)t[17] << 4;

			a->coeffs[256*i + j + 192]  = t[18];
			a->coeffs[256*i + j + 192] += ((int16_t)t[19] & 0xf) << 8;

			a->coeffs[256*i + j + 208]  = t[19] >> 4;
			a->coeffs[256*i + j + 208] += (int16_t)t[20] << 4;

			a->coeffs[256*i + j + 224]  = t[21];
			a->coeffs[256*i + j + 224] += ((int16_t)t[22] & 0xf) << 8;

			a->coeffs[256*i + j + 240]  = t[22] >> 4;
			a->coeffs[256*i + j + 240] += (int16_t)t[23] << 4;
		}
	}
}

void test_poly_tobytes()
{
	uint8_t buf[NTRUPLUS_POLYBYTES] = {0};
	uint8_t buf2[NTRUPLUS_POLYBYTES] = {0};
	poly a,b;
	poly c,d;
	for (int i = 0; i < 768; i++)
	{
		a.coeffs[i] = i;
	}


	

	printf("bytes\n");
	for (int i = 0; i < 32; i++)
	{
		printf("%d : %02X\n", i, ((uint8_t*)a.coeffs)[i]);
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

	poly_tobytes2(buf2, &a);
	for (int i = 0; i < NTRUPLUS_POLYBYTES; i++)
	{
		if(i%32 == 0) printf("\n");
		printf("%02X", buf2[i]);
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

	//test_poly_short();
	//test_ntt();
	//test_cbd();
	//test();
	//test_poly_tobytes();

	return 0;	
}