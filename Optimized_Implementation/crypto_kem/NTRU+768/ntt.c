#include "params.h"
#include "ntt.h"

#define QINV 1951806081u // q^(-1) mod 2^32

const uint32_t zetas[192] = {
    0x0012F51Du, 0xCA88B381u, 0x8BA9CD7Fu, 0xECF7EDA3u, 0xACC3CB92u, 0x74563281u, 0xCD7F0013u, 0x6FD1CA89u,
    0xA252CA76u, 0xB380ECF8u, 0xBE63ACC4u, 0x0AE2BFCCu, 0x80FFED0Bu, 0x3C346DE5u, 0x08125D74u, 0xAD358A42u,
    0x2E35774Cu, 0x34221071u, 0x5D745633u, 0x8A419C53u, 0x774C7F13u, 0x10708F5Eu, 0x6DE4E590u, 0x12F51D40u,
    0xC346DE4Eu, 0xF0012F52u, 0xF70A252Du, 0xC7F13081u, 0xE63ACC3Du, 0x45632810u, 0x42210709u, 0x1CA88B38u,
    0xD358A41Au, 0x7EDA28BBu, 0xAE2BFCBEu, 0x4E5902E3u, 0xC533C347u, 0x9CD7F001u, 0xDEF8F70Au, 0x5774C7F1u,
    0xA75BE63Bu, 0x25D74563u, 0xD4034221u, 0xA6FD1CA9u, 0xF5DAD359u, 0x0ECF7EDAu, 0xFED0AE2Cu, 0x46DE4E59u,
    0x23D76B4Du, 0xE03B3DFBu, 0x3FFB42B9u, 0x0D1B7939u, 0x40B8D5DDu, 0x00D08842u, 0xD6F98EB3u, 0x75D158CAu,
    0x22CE03B4u, 0xBE3DC289u, 0x4CF0D1B8u, 0x35FC004Cu, 0x47500D09u, 0xC69BF473u, 0x04975D16u, 0x4D629067u,
    0xF77BE3DCu, 0x8D5DD320u, 0xEA735FC0u, 0x98EB30F3u, 0x486C69BFu, 0xB42B8AFFu, 0x76B4D629u, 0xB3DFB68Au,
    0xE3DC2895u, 0xD31FC4C2u, 0x5FC004BDu, 0x30F2E487u, 0x69BF472Au, 0x8AFF2F78u, 0xD6290671u, 0xB68A2EA7u,
    0xD5DD31FCu, 0x8841C23Du, 0x8EB30F2Eu, 0x58CA0400u, 0x42B8AFF3u, 0x7939640Cu, 0x3DFB68A3u, 0x94B29D70u,
    0x0D08841Cu, 0xF472A22Du, 0x5D158CA0u, 0x906714CFu, 0xD1B79396u, 0x004BD475u, 0xC2894B2Au, 0xFC4C2049u,
    0x01A11084u, 0x7E8E5446u, 0xEBA2B194u, 0x520CE29Au, 0x1A36F273u, 0x80097A8Fu, 0xB8512965u, 0x3F898409u,
    0x5A6B1483u, 0xEFDB4517u, 0x15C57F98u, 0xC9CB205Cu, 0xAEE98FE2u, 0x420E11ECu, 0x75987972u, 0xC6501FFEu,
    0x4BAE8AC6u, 0xB148338Au, 0x4DFA3951u, 0x57F97BBEu, 0x1EE144A6u, 0x98FE2610u, 0xFE0025EAu, 0x87972436u,
    0x685715FEu, 0x6F272C81u, 0x67BF6D14u, 0x129653AEu, 0x31D661E6u, 0x2B194080u, 0x11083848u, 0xE54459C0u,
    0x8D37E8E5u, 0x715FE5EFu, 0x9AC520CEu, 0xF6D145D5u, 0x6BF80098u, 0x661E5C91u, 0xBA63F898u, 0x83847AEDu,
    0x1D9EFDB4u, 0x144A594Fu, 0x8DBC9CB2u, 0x025EA3A8u, 0x684420E1u, 0xA3951167u, 0xE8AC6502u, 0x8338A678u,
    0xC8171ABCu, 0xA01A1108u, 0x3ADF31D6u, 0x2EBA2B19u, 0x07FF6857u, 0xE1A36F27u, 0x9C0767BFu, 0x7B851296u,
    0x61024BAFu, 0xB5A6B148u, 0x43634DFAu, 0xA15C57F9u, 0xBBDF1EE1u, 0x6AEE98FEu, 0x539AFE00u, 0xC7598797u,
    0x94EB7CC7u, 0x24BAE8ACu, 0x3A806844u, 0x34DFA395u, 0x16701D9Fu, 0xF1EE144Au, 0x67868DBDu, 0xAFE0025Fu,
    0xC90D8D38u, 0xF6857160u, 0xAED69AC5u, 0x767BF6D1u, 0x5D4E6BF8u, 0xF31D661Eu, 0x71ABBA64u, 0xA1108384u,
    0xA8EA01A1u, 0xD8D37E8Eu, 0x4092EBA3u, 0x69AC520Du, 0x299E1A37u, 0xE6BF8009u, 0xF7C7B851u, 0xBBA63F8Au,
    0x1EBB5A6Bu, 0x01D9EFDBu, 0xFFDA15C5u, 0x68DBC9CBu, 0x05C6AEEAu, 0x0684420Eu, 0xB7CC7598u, 0xAE8AC650u
};

static inline int16_t plantard_reduce(int32_t a)
{
	a = ((int32_t)(a * QINV)) >> 16;
	a=((a+8) * NTRUPLUS_Q) >> 16;
	return a;
}

static inline int16_t plantard_reduce_acc(int32_t a)
{
	a = a >> 16;
	a = ((a+8)*NTRUPLUS_Q) >> 16;
	return a;
}

static inline int16_t plantard_mul(uint32_t a, uint32_t b)
{
	int32_t t = (int32_t)((uint32_t)a*b) >> 16;
	t = ((t+8)*NTRUPLUS_Q) >> 16;
	return t;
}

/*************************************************
* Name:        fqinv
*
* Description: Inversion
*
* Arguments:   - int16_t a: first factor a = x mod q
*
* Returns 16-bit integer congruent to x^{-1} * R^2 mod q
**************************************************/
static inline int16_t fqinv(int16_t a) //-3 => 5
{
	int16_t t1,t2,t3;
	uint32_t A,T1;

	A = a*QINV;
	t1 = plantard_reduce_acc(a*A);    //10

	T1 = t1*QINV;
	t2 = plantard_reduce_acc(t1*T1);  //100
	t2 = plantard_reduce(t2*t2);      //1000
	t3 = plantard_reduce(t2*t2);      //10000
	t1 = plantard_reduce_acc(t2*T1);  //1010

	T1 = t1*QINV;
	t2 = plantard_reduce_acc(t3*T1);  //11010
	t2 = plantard_reduce(t2*t2);      //110100
	t2 = plantard_reduce_acc(t2*A);   //110101

	t1 = plantard_reduce_acc(t2*T1);  //111111

	t2 = plantard_reduce(t2*t2);      //1101010
	t2 = plantard_reduce(t2*t2);      //11010100
	t2 = plantard_reduce(t2*t2);      //110101000
	t2 = plantard_reduce(t2*t2);      //1101010000
	t2 = plantard_reduce(t2*t2);      //11010100000
	t2 = plantard_reduce(t2*t2);      //110101000000
	t2 = plantard_reduce(t2*t1);      //110101111111

	return t2;
}

/*************************************************
* Name:        ntt
*
* Description: number-theoretic transform (NTT) in Rq.
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to output vector of elements of Zq
*              - int16_t a[NTRUPLUS_N]: pointer to input vector of elements of Zq
**************************************************/
void ntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3;
	uint32_t T1,T2;
	uint32_t zeta[5];
	int16_t v[8];

	int index = 1;

	zeta[0] = zetas[index++];

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = plantard_mul(zeta[0], a[i + NTRUPLUS_N/2]);

		r[i + NTRUPLUS_N/2] = a[i] + a[i + NTRUPLUS_N/2] - t1;
		r[i               ] = a[i]                       + t1;
	}

	for(int i = 0; i < 2; i++)
	{
		zeta[0] = zetas[2+2*i];
		zeta[1] = zetas[3+2*i];
		zeta[2] = zetas[6+3*i];
		zeta[3] = zetas[7+3*i];
		zeta[4] = zetas[8+3*i];

		for(int j = 0; j < 64; j++)
		{
			for(int k = 0; k < 6; k++)
			{
				v[k] = r[64*k+j+384*i];
			}

			t1 = plantard_mul(zeta[0], v[2]);
			t2 = plantard_mul(zeta[1], v[4]);
			t3 = plantard_mul(-898253212, t1 - t2);

			v[4] = v[0] - t1 - t3;
			v[2] = v[0] - t2 + t3;
			v[0] = v[0] + t1 + t2;

			t1 = plantard_mul(zeta[0], v[3]);
			t2 = plantard_mul(zeta[1], v[5]);
			t3 = plantard_mul(-898253212, t1 - t2);

			v[5] = v[1] - t1 - t3;
			v[3] = v[1] - t2 + t3;
			v[1] = v[1] + t1 + t2;

			t1 = plantard_mul(zeta[2], v[1]);
			v[1] = v[0] - t1;
			v[0] = v[0] + t1;

			t1 = plantard_mul(zeta[3], v[3]);
			v[3] = v[2] - t1;
			v[2] = v[2] + t1;

			t1 = plantard_mul(zeta[4], v[5]);
			v[5] = v[4] - t1;
			v[4] = v[4] + t1;

			for (int k = 0; k < 6; k++)
			{
				r[64*k+j+384*i] = v[k];
			}
		}
	}

	for (int i = 0; i < 12; i++)
	{
		zeta[0] = zetas[12+i];
		zeta[1] = zetas[24+2*i];
		zeta[2] = zetas[25+2*i];

		for (int j = 0; j < 8; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = r[8*k+j+64*i];
			}

			t1 = plantard_mul(zeta[0], v[4]);
			v[4] = v[0] - t1;
			v[0] = v[0] + t1;

			t1 = plantard_mul(zeta[0], v[5]);
			v[5] = v[1] - t1;
			v[1] = v[1] + t1;

			t1 = plantard_mul(zeta[0], v[6]);
			v[6] = v[2] - t1;
			v[2] = v[2] + t1;

			t1 = plantard_mul(zeta[0], v[7]);
			v[7] = v[3] - t1;
			v[3] = v[3] + t1;

			t1 = plantard_mul(zeta[1], v[2]);
			v[2] = v[0] - t1;
			v[0] = v[0] + t1;

			t1 = plantard_mul(zeta[1], v[3]);
			v[3] = v[1] - t1;
			v[1] = v[1] + t1;

			t1 = plantard_mul(zeta[2], v[6]);
			v[6] = v[4] - t1;
			v[4] = v[4] + t1;

			t1 = plantard_mul(zeta[2], v[7]);
			v[7] = v[5] - t1;
			v[5] = v[5] + t1;

			for (int k = 0; k < 8; k++)
			{
				r[8*k+j+64*i] = v[k];
			}
		}
	}

	for (int i = 0; i < 48; i++)
	{
		zeta[0] = zetas[48+i];
		zeta[1] = zetas[96+2*i];
		zeta[2] = zetas[97+2*i];

		for (int j = 0; j < 2; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = r[2*k+j+16*i];
			}

			t1 = plantard_mul(zeta[0], v[4]);
			v[4] = v[0] - t1;
			v[0] = v[0] + t1;

			t1 = plantard_mul(zeta[0], v[5]);
			v[5] = v[1] - t1;
			v[1] = v[1] + t1;

			t1 = plantard_mul(zeta[0], v[6]);
			v[6] = v[2] - t1;
			v[2] = v[2] + t1;

			t1 = plantard_mul(zeta[0], v[7]);
			v[7] = v[3] - t1;
			v[3] = v[3] + t1;

			T1 = v[0] * zetas[0];
			T2 = v[2] * zeta[1];
			v[2] = plantard_reduce_acc(T1 - T2);
			v[0] = plantard_reduce_acc(T1 + T2);

			T1 = v[1] * zetas[0];
			T2 = v[3] * zeta[1];
			v[3] = plantard_reduce_acc(T1 - T2);
			v[1] = plantard_reduce_acc(T1 + T2);

			T1 = v[4] * zetas[0];
			T2 = v[6] * zeta[2];
			v[6] = plantard_reduce_acc(T1 - T2);
			v[4] = plantard_reduce_acc(T1 + T2);

			T1 = v[5] * zetas[0];
			T2 = v[7] * zeta[2];
			v[7] = plantard_reduce_acc(T1 - T2);
			v[5] = plantard_reduce_acc(T1 + T2);

			for (int k = 0; k < 8; k++)
			{
				r[2*k+j+16*i] = v[k];
			}
		}
	}
}

/*************************************************
* Name:        invntt
*
* Description: inverse number-theoretic transform in Rq and
*              multiplication by Montgomery factor R = 2^16.
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to output vector of elements of Zq
*              - int16_t a[NTRUPLUS_N]: pointer to input vector of elements of Zq
**************************************************/
void invntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3;
	uint32_t zeta[7];
	int16_t v[8];

	for (int i = 0; i < 48; i++)
	{
		zeta[0] = zetas[191-2*i];
		zeta[1] = zetas[190-2*i];
		zeta[2] = zetas[95-i];

		for (int j = 0; j < 2; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = a[2*k+j+16*i];
			}

			t1 = v[2];

			v[2] = plantard_mul(zeta[0],  t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];

			v[3] = plantard_mul(zeta[0],  t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];

			v[6] = plantard_mul(zeta[1],  t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = v[7];

			v[7] = plantard_mul(zeta[1],  t1 - v[5]);
			v[5] = v[5] + t1;


			t1 = v[4];

			v[4] = plantard_mul(zeta[2],  t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[5];

			v[5] = plantard_mul(zeta[2],  t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];

			v[6] = plantard_mul(zeta[2],  t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[7];

			v[7] = plantard_mul(zeta[2],  t1 - v[3]);
			v[3] = v[3] + t1;			
								

			for (int k = 0; k < 8; k++)
			{
				r[2*k+j+16*i] = v[k];
			}
		}
	}
	
	for (int i = 0; i < 6; i++)
	{
		zeta[0] = zetas[47-4*i];
		zeta[1] = zetas[46-4*i];
		zeta[2] = zetas[45-4*i];
		zeta[3] = zetas[44-4*i];
		zeta[4] = zetas[23-2*i];
		zeta[5] = zetas[22-2*i];
		zeta[6] = zetas[11-i];

		for (int j = 0; j < 16; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = a[16*k+j+128*i];
			}

			t1 = v[1];

			v[1] = plantard_mul(zeta[0],  t1 - v[0]);
			v[0] = (v[0] + t1);

			t1 = v[3];

			v[3] = plantard_mul(zeta[1],  t1 - v[2]);
			v[2] = (v[2] + t1);

			t1 = v[5];

			v[5] = plantard_mul(zeta[2],  t1 - v[4]);
			v[4] = (v[4] + t1);

			t1 = v[7];

			v[7] = plantard_mul(zeta[3],  t1 - v[6]);
			v[6] = (v[6] + t1);


			t1 = v[2];

			v[2] = plantard_mul(zeta[4],  t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];

			v[3] = plantard_mul(zeta[4],  t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];

			v[6] = plantard_mul(zeta[5],  t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = v[7];

			v[7] = plantard_mul(zeta[5],  t1 - v[5]);
			v[5] = v[5] + t1;


			t1 = v[4];

			v[4] = plantard_mul(zeta[6],  t1 - v[0]);
			v[0] = plantard_mul(v[0] + t1, zetas[0]);

			t1 = v[5];

			v[5] = plantard_mul(zeta[6],  t1 - v[1]);
			v[1] = plantard_mul(v[1] + t1, zetas[0]);

			t1 = v[6];

			v[6] = plantard_mul(zeta[6],  t1 - v[2]);
			v[2] = plantard_mul(v[2] + t1, zetas[0]);

			t1 = v[7];

			v[7] = plantard_mul(zeta[6],  t1 - v[3]);
			v[3] = plantard_mul(v[3] + t1, zetas[0]);		
				
			for (int k = 0; k < 8; k++)
			{
				r[16*k+j+128*i] = v[k];
			}
		}
	}

	zeta[0] = zetas[4];
	zeta[1] = zetas[5];
	zeta[2] = zetas[2];
	zeta[3] = zetas[3];

	for (int i = 0; i < 128; i++)
	{
		for (int j = 0; j < 6; j++)
		{
			v[j] = a[128*j+i];
		}

		t1 = plantard_mul(-898253212,    v[1] - v[0]);
		t2 = plantard_mul(zeta[0], v[2] - v[0] + t1);
		t3 = plantard_mul(zeta[1], v[2] - v[1] - t1);

		v[0] = v[0] + v[1] + v[2];
		v[1] = t2;
		v[2] = t3;

		t1 = plantard_mul(-898253212,    v[4] - v[3]);
		t2 = plantard_mul(zeta[2], v[5] - v[3] + t1);
		t3 = plantard_mul(zeta[3], v[5] - v[4] - t1);

		v[3] = v[3] + v[4] + v[5];
		v[4] = t2;
		v[5] = t3;

		t1 = v[0] + v[3];
		t2 = plantard_mul(2030077108, v[0] - v[3]);

		v[0] = plantard_mul(4272604146, t1 - t2);
		v[3] = plantard_mul(4250240995, t2);

		t1 = v[1] + v[4];
		t2 = plantard_mul(2030077108, v[1] - v[4]);

		v[1] = plantard_mul(4272604146, t1 - t2);
		v[4] = plantard_mul(4250240995, t2);

		t1 = v[2] + v[5];
		t2 = plantard_mul(2030077108, v[2] - v[5]);

		v[2] = plantard_mul(4272604146, t1 - t2);
		v[5] = plantard_mul(4250240995, t2);				

		for (int j = 0; j < 6; j++)
		{
			r[128*j+i] = v[j];
		}
	}
}

/*************************************************
* Name:        baseinv
*
* Description: Inversion of polynomial in Zq[X]/(X^4-zeta)
*              used for inversion of element in Rq in NTT domain
*
* Arguments:   - int16_t r[4]: pointer to the output polynomial
*              - const int16_t a[4]: pointer to the input polynomial
*              - int32_t zeta: integer defining the reduction polynomial
**************************************************/
int baseinv(int16_t r[8], const int16_t a[8], uint32_t zeta)
{
	int16_t t0, t1, t2;
	int16_t s0, s1, s2;
	uint32_t A0, A1, A2, A3;
	uint32_t B0, B1, B2, B3;
	int32_t det0, det1;
	uint32_t zeta1, zeta2;
	uint32_t T, S;

	zeta1 = zeta;
	zeta2 = -zeta;

	A0 = a[0]*QINV;
	A1 = a[1]*QINV;
	A2 = a[2]*QINV;
	A3 = a[3]*QINV;
	B0 = a[4]*QINV;
	B1 = a[5]*QINV;
	B2 = a[6]*QINV;
	B3 = a[7]*QINV;

	t0 = plantard_reduce_acc(a[2]*A2 - 2*a[1]*A3);
	s0 = plantard_reduce_acc(a[6]*B2 - 2*a[5]*B3);
	t1 = plantard_reduce_acc(a[3]*A3);
	s1 = plantard_reduce_acc(a[7]*B3);
	t0 = plantard_reduce_acc(a[0]*A0 + t0*zeta1);
	s0 = plantard_reduce_acc(a[4]*B0 + s0*zeta2);
	t1 = plantard_reduce_acc(a[1]*A1 + t1*zeta1 - 2*a[0]*A2);
	s1 = plantard_reduce_acc(a[5]*B1 + s1*zeta2 - 2*a[4]*B2);
	t2 = plantard_reduce_acc(t1*zeta1);
	s2 = plantard_reduce_acc(s1*zeta2);
	
	det0 = plantard_reduce(t0*t0 - t1*t2);
	det1 = plantard_reduce(s0*s0 - s1*s2);
	
	if(!(det0 && det1)) return 1;

	r[0] = plantard_reduce_acc(A0*t0 + A2*t2);
	r[1] = plantard_reduce_acc(A3*t2 + A1*t0);
	r[2] = plantard_reduce_acc(A2*t0 + A0*t1);
	r[3] = plantard_reduce_acc(A1*t1 + A3*t0);
	r[4] = plantard_reduce_acc(B0*s0 + B2*s2);
	r[5] = plantard_reduce_acc(B3*s2 + B1*s0);
	r[6] = plantard_reduce_acc(B2*s0 + B0*s1);
	r[7] = plantard_reduce_acc(B1*s1 + B3*s0);

	det0 = fqinv(det0);
	det1 = fqinv(det1);
	det0 = plantard_mul(det0, 3975671203);
	det1 = plantard_mul(det1, 3975671203);

	T = det0 * QINV;
	S = det1 * QINV;

	r[0] =  plantard_reduce_acc(r[0]*T);
	r[1] = -plantard_reduce_acc(r[1]*T);
	r[2] =  plantard_reduce_acc(r[2]*T);
	r[3] = -plantard_reduce_acc(r[3]*T);
	r[4] =  plantard_reduce_acc(r[4]*S);
	r[5] = -plantard_reduce_acc(r[5]*S);
	r[6] =  plantard_reduce_acc(r[6]*S);
	r[7] = -plantard_reduce_acc(r[7]*S);

	return 0;
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^4-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t r[4]: pointer to the output polynomial
*              - const int16_t a[4]: pointer to the first factor
*              - const int16_t b[4]: pointer to the second factor
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
void basemul(int16_t r[4], const int16_t a[4], const int16_t b[4], uint32_t zeta)
{
	uint32_t A0, A1, A2, A3;

	A0 = a[0] * QINV;
	A1 = a[1] * QINV;
	A2 = a[2] * QINV;
	A3 = a[3] * QINV;

	r[0] = plantard_reduce_acc(A1*b[3]+A2*b[2]+A3*b[1]);
	r[1] = plantard_reduce_acc(A2*b[3]+A3*b[2]);
	r[2] = plantard_reduce_acc(A3*b[3]);

	r[0] = plantard_reduce_acc(r[0]*zeta+A0*b[0]);
	r[1] = plantard_reduce_acc(r[1]*zeta+A0*b[1]+A1*b[0]);
	r[2] = plantard_reduce_acc(r[2]*zeta+A0*b[2]+A1*b[1]+A2*b[0]);
	r[3] = plantard_reduce_acc(A0*b[3]+A1*b[2]+A2*b[1]+A3*b[0]);

	r[0] = plantard_mul(r[0], 3217808880);
	r[1] = plantard_mul(r[1], 3217808880);
	r[2] = plantard_mul(r[2], 3217808880);
	r[3] = plantard_mul(r[3], 3217808880);
}

/*************************************************
* Name:        basemul_add
*
* Description: Multiplication then addition of polynomials in Zq[X]/(X^4-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t c[4]: pointer to the output polynomial
*              - const int16_t a[4]: pointer to the first factor
*              - const int16_t b[4]: pointer to the second factor
*              - const int16_t c[4]: pointer to the third factor
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
void basemul_add(int16_t r[4], const int16_t a[4], const int16_t b[4], const int16_t c[4], uint32_t zeta)
{
	uint32_t A0, A1, A2, A3;

	A0 = a[0] * QINV;
	A1 = a[1] * QINV;
	A2 = a[2] * QINV;
	A3 = a[3] * QINV;

	r[0] = plantard_reduce_acc(A1*b[3]+A2*b[2]+A3*b[1]);
	r[1] = plantard_reduce_acc(A2*b[3]+A3*b[2]);
	r[2] = plantard_reduce_acc(A3*b[3]);

	r[0] = plantard_reduce_acc(r[0]*zeta+A0*b[0]);
	r[1] = plantard_reduce_acc(r[1]*zeta+A0*b[1]+A1*b[0]);
	r[2] = plantard_reduce_acc(r[2]*zeta+A0*b[2]+A1*b[1]+A2*b[0]);
	r[3] = plantard_reduce_acc(A0*b[3]+A1*b[2]+A2*b[1]+A3*b[0]);

	r[0] = plantard_reduce_acc(c[0]*1242398 + r[0]*3217808880);
	r[1] = plantard_reduce_acc(c[1]*1242398 + r[1]*3217808880);
	r[2] = plantard_reduce_acc(c[2]*1242398 + r[2]*3217808880);
	r[3] = plantard_reduce_acc(c[3]*1242398 + r[3]*3217808880);
}
