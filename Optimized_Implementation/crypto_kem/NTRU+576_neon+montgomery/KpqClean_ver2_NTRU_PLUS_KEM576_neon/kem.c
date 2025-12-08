#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#include "api.h"
#include "params.h"
#include "symmetric.h"
#include "poly.h"
#include "verify.h"
#include "fips202.h"
#include "randombytes.h"

/*************************************************
* Name:        crypto_kem_keypair
*
* Description: Generates public and private key
*              for CCA-secure NTRU+ key encapsulation mechanism
*
* Arguments:   - unsigned char *pk: pointer to output public key
*                (an already allocated array of CRYPTO_PUBLICKEYBYTES bytes)
*              - unsigned char *sk: pointer to output private key
*                (an already allocated array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/
int crypto_kem_keypair(unsigned char *pk, unsigned char *sk)
{
	uint8_t buf[NTRUPLUS_N / 4];
	poly f, finv;
	poly g;
	poly h, hinv;

	// 첫 do … while 블록은 NTRU+에서 요구하는 “짧고 invertible”한 비밀 다항식 f를 생성합니
	do {
		// randombytes로 32바이트 시드를 뽑고 shake256으로 NTRUPLUS_N/4바이트까지 확장합니다. (난수 길이 조정)
		randombytes(buf, 32);
		shake256(buf, NTRUPLUS_N / 4, buf, 32);

		//  poly_cbd1가 그 바이트열을 중심 이항 분포(−1,0,1) 계수 다항식으로 변환.
		// poly_cbd1을 거치고나면 f.coeffs[i]들이 -1,0,1 값으로 채워짐
		poly_cbd1(&f, buf);
		// 1. poly_triple로 계수를 3배 해 NTRU 구조가 요구하는 형태(계수 ≈ 3⋅{−1,0,1})로 맞춥니다.
		// 2. f.coeffs[0]+=1을 통해 f = 1 + 3f'을 만드는데, 이렇게 만드는 이유는 f mod3이 1이 나오도록
		// 왜냐면 다른 계수들은 전부 3배를 해서 3으로 나누어떨어지게하고 상수항에 1을 더해서 mod3이 1이 나오게
		// (이걸만족해야 복호화 과정이 가능하다고함)
		poly_triple(&f, &f);
		f.coeffs[0] += 1; // f.coeffs[0] += 1로 상수항에 ‘1’을 더해 전통적인 f = 1 + 3F 형태를 만족시킵니다.
		poly_ntt(&f, &f); // poly_ntt로 f를 NTT 영역으로 옮겨 곱셈/역연산을 빠르게 수행하도록 준비합니다.
	} while(poly_baseinv(&finv, &f)); // 마지막으로 poly_baseinv가 각 4차 블록에서의 역원을 계산해 finv에 저장합니다. 역이 존재하지 않으면(0을 만나면) 루프를 다시 돌며 새로운 f를 뽑습니다.

	// 두 번째 do … while은 공개키 다항식 h = g * f^{-1}과 그 역을 마련합니다.
	do {
		randombytes(buf, 32);
		shake256(buf, NTRUPLUS_N / 4, buf, 32);

		poly_cbd1(&g, buf); 
		poly_triple(&g, &g);
		// poly_ntt로 g를 NTT 영역으로 옮기고, poly_basemul로 h = g ⋅ finv를 계산해 점별 곱으로 빠르게 얻습니다.
		poly_ntt(&g, &g);
		poly_basemul(&h, &g, &finv);
	} while(poly_baseinv(&hinv, &h)); // poly_baseinv(&hinv, &h)가 h의 역을 확인합니다. h가 invertible하지 않으면(희박하지만 가능) 새 g를 뽑아 반복합니다.
	
	//pk
	poly_tobytes(pk, &h);
	
	//sk
	poly_tobytes(sk, &f);
	poly_tobytes(sk + NTRUPLUS_POLYBYTES, &hinv);	
	hash_f(sk + 2 * NTRUPLUS_POLYBYTES, pk); 
	
	return 0;
}


/*************************************************
* Name:        crypto_kem_enc
*
* Description: Generates cipher text and shared
*              secret for given public key
*
* Arguments:   - unsigned char *ct: pointer to output cipher text
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - unsigned char *ss: pointer to output shared secret
*                (an already allocated array of CRYPTO_BYTES bytes)
*              - const unsigned char *pk: pointer to input public key
*                (an already allocated array of CRYPTO_PUBLICKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/
int crypto_kem_enc(unsigned char *ct,
                   unsigned char *ss,
                   const unsigned char *pk)
{
	uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES];
	uint8_t buf1[NTRUPLUS_SYMBYTES + NTRUPLUS_N / 4];
	uint8_t buf2[NTRUPLUS_POLYBYTES];
	
	poly c, h, r, m;
	
	randombytes(msg, NTRUPLUS_N / 8); //
	hash_f(msg + NTRUPLUS_N / 8, pk); // pk를 해시해서 msg뒤에 붙임
	hash_h_kem(buf1, msg);
	// -> buf1 앞 SYMBYTES는 최종 공유키, 뒤 N/4는 랜덤 다항식 시드입니다.
	
	poly_cbd1(&r, buf1 + NTRUPLUS_SYMBYTES); // buf1의 NTRUPLUS_SYMBYTES만큼 건너뛴 뒷부분부터 중심 이항 분포 다항식 r을 만듭니다.
	poly_ntt(&r, &r); // r을 NTT 도메인으로 변환해 곱셈을 빠르게 합니다. (추후 c = h*r + m을 할 때, h는 이미 NTT 도메인에 있으므로 r도 NTT 도메인으로 맞춰줘야함)
	
	poly_tobytes(buf2, &r);
	hash_g(buf2, buf2);
	poly_sotp(&m, msg, buf2); //
	poly_ntt(&m, &m);
	
	poly_frombytes(&h, pk); // 공개키 바이트열을 다항식 h로 역직렬화합니다. (h가 공개키)
	poly_basemul_add(&c, &h, &r, &m); // NTT 영역에서 c = h⋅r + m을 계산해 암호문 다항식 c를 얻습니다
	poly_tobytes(ct, &c);
	
	for (int i = 0; i < NTRUPLUS_SSBYTES; i++)
	{
		ss[i] = buf1[i];
	}
	
	return 0;
}

/*************************************************
* Name:        crypto_kem_dec
*
* Description: Generates shared secret for given
*              cipher text and private key
*
* Arguments:   - unsigned char *ss: pointer to output shared secret
*                (an already allocated array of CRYPTO_BYTES bytes)
*              - const unsigned char *ct: pointer to input cipher text
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - const unsigned char *sk: pointer to input private key
*                (an already allocated array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success) or 1 (failure)
*
* On failure, ss will contain zero values.
**************************************************/
int crypto_kem_dec(unsigned char *ss,
                   const unsigned char *ct,
                   const unsigned char *sk)
{
	uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES];
	uint8_t buf1[NTRUPLUS_POLYBYTES];
	uint8_t buf2[NTRUPLUS_POLYBYTES];
	uint8_t buf3[NTRUPLUS_POLYBYTES+NTRUPLUS_SYMBYTES] = {0};
	
	int8_t fail;
	
	poly c, f, hinv;
	poly r1, r2;
	poly m1, m2;
	
	poly_frombytes(&c, ct); // 암호문 바이트열(ct - cypher text)을 다항식 c로 역직렬화합니다.
	poly_frombytes(&f, sk); // 비밀키 바이트열(sk - secret key)에서 비밀 다항식 f를 역직렬화합니다.
	poly_frombytes(&hinv, sk + NTRUPLUS_POLYBYTES); // 비밀키에서 hinv도 역직렬화합니다.
	
	poly_basemul(&m1, &c, &f); // c * f를 NTT 도메인에서 계산해 m1에 저장합니다. (cf = h*r*f + m*f = r + m*f)
	poly_invntt(&m1, &m1); // m1을 역NTT로 변환해 표준 도메인 다항식으로 만듭니다.
	poly_crepmod3(&m1, &m1); // m mod 3 -> 이제 m을 얻음

	// 위 과정에서 m을 얻었으나, m만으로는 원래 메시지를 복원할 수 없음
	poly_ntt(&m2, &m1);
	poly_sub(&c, &c, &m2); // 암호화 완성식이 원래 c = h*r + m이므로, m2 = NTT(m)이므로 c - m2 = h*r
	// 여기까지 얻어진 식 : c - NTT(m) = h*r
	// 양변에 hinv를 곱하면 -> r = (c - NTT(m)) * hinv
	poly_basemul(&r2, &c, &hinv);
	// 즉, r2 = (c - NTT(m)) * hinv

	poly_tobytes(buf1, &r2);
	hash_g(buf2, buf1);
	fail = poly_sotp_inv(msg, &m1, buf2);
	
	for (int i = 0; i < NTRUPLUS_SYMBYTES; i++)
	{
		msg[i + NTRUPLUS_N / 8] = sk[i + 2 * NTRUPLUS_POLYBYTES]; 
	}
	
	hash_h_kem(buf3, msg); // buf3가 암호화 때의 buf1과 동일한 값이 되어야 함
	
	poly_cbd1(&r1, buf3 + NTRUPLUS_SSBYTES);
	poly_ntt(&r1, &r1);
	poly_tobytes(buf2, &r1);
	
	fail |= verify(buf1, buf2, NTRUPLUS_POLYBYTES);

	// 참고로 ss는 공유키(shared secret) (비밀키 f,g랑 다른거임!!)
	for(int i = 0; i < NTRUPLUS_SSBYTES; i++)
	{
		ss[i] = buf3[i] & ~(-fail);
	}
	
	return fail;
}
