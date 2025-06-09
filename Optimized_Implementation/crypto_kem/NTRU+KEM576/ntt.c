#include "params.h"
#include "ntt.h"

#define QINV 12929 // q^(-1) mod 2^16
#define QINV_PLANT ((int32_t)1951806081LL) // q^(-1) mod 2^32

const int16_t zetas[144] = {
	 -147, -1033, -1265,   708,   460,  1265,  -467,   727,
	  556,  1307,  -773,  -161,  1200, -1612,   570,  1529,
	 1135,  -556,  1120,   298,  -822, -1556,   -93,  1463,
	  532,  -377,  -909,    58,  -392,  -450,  1722,  1236,
	 -486,  -491, -1569, -1078,    36,  1289, -1443,  1628,
	 1664,  -725,  -952,    99, -1020,   353,  -599,  1119,
	  592,   839,  1622,   652,  1244,  -783, -1085,  -726,
	  566,  -284, -1369, -1292,   268,  -391,   781,  -172,
	   96, -1172,   211,   737,   473,  -445,  -234,   264,
	-1536,  1467,  -676, -1542,  -170,   635,  -705, -1332,
	 -658,   831, -1712,  1311,  1488,  -881,  1087, -1315,
	 1245,   -75,   791,    -6,  -875,  -697,   -70, -1162,
	  287,  -767,  -945,  1598,  -882,  1261,   206,   654,
	-1421,   -81,   716, -1251,   838, -1300,  1035,  -104,
	  966,  -558,   -61, -1704,   404,  -899,   862, -1593,
	-1460,   -37,  1266,   965, -1584, -1404,  -265,  -942,
	  905,  1195,  -619,   787,   118,   576,   286, -1475,
	 -194,   928,  1229, -1032,  1608,  1111, -1669,   642
};

const int32_t zetas_plant[144] = {
    1242397,  -897010815, -1888443821,  1396454510,  1077158416,  1888443822,   559078763, -1817627177,
 1339304236,   660955338,  2139408066, -1021250540,  1129339101,    72059041, -1933170122,  1535603002,
  370234381, -1339304236,   195056368,   903222801,   708166433,  -132936506,  1490876701,  1623813207,
  200025957,  1610146837,  1410120880, -1899625396,  1434968825,  -960373075,  1212579717,   690772871,
 -521806845,  -580199516, -2002744368, -1422544852,  -438566230, -1267245196, -1390242524,  -744195953,
-1182762183,   122997328,  -810043008,  2015168341,   972797047,  1545542180,   735499172,  1042371293,
  900738007,  2067349025,    44726301,  1601450056, -1792779233,  2022622724,   213692327,   970312253,
 1456089578,   119270136,   332962463,  -485777325,   552866777,   587653900,  -327992874,  -290720957,
  262145820,   915646774,  1605177248, -1700841836, -1348001017,  -901980404,   703196844,  -352840819,
  100634177, -1765446493,  1554238961,   889556432, -1985350807, -1174065402,   356568011,  -952918691,
 -812527802,   255933834, -1095794375,  1566662933,  1915776561,  -839860542, -1908322177,  1822596767,
 1654873138,  -875890062,  -211207533,   788922254, -1628782796, -2126984093,  -817497391,  1032432115,
 1633752385,  1350485812,  1848687109, -1094551978,     7454384,   982736225,  1546784577,   -93179794,
 1443665605,   -86967808, -1087097594,  -865950884, -1380303346,  1997774779,  -797619035, -2073561012,
 1832535945,   355325614,   146602876,   715620816,  1282153963,  1526906221,  -241025067,  1152944649,
  129209314,  1285881155,  1041128896, -1615116426,  2117044915,   -75786232,  1200155744,  -693257666,
 1979138821,  1070946430,   501928489, -1116915128, -1198913347,  1572874920, -1813899986,   -45968698,
 1170338210,  -329235271, -1967957245, -1744325740,  -977766636,  -769043898,  1124369512,  1484664715
};

/*************************************************
* Name:        montgomery_reduce
*
* Description: Montgomery reduction; given a 32-bit integer a, computes
*              16-bit integer congruent to a * R^-1 mod q, where R=2^16
*
* Arguments:   - int32_t a: input integer to be reduced;
*                           has to be in {-q2^15,...,q2^15-1}
*
* Returns:     integer in {-q+1,...,q-1} congruent to a * R^-1 modulo q.
**************************************************/
static inline int16_t montgomery_reduce(int32_t a)
{
	int16_t t = (int16_t)a*QINV;
	t = (a - (int32_t)t*NTRUPLUS_Q) >> 16;
	return t;
}

static inline int16_t plantard_reduce(int32_t a)
{
  a = ((int32_t)(a * QINV_PLANT)) >> 16;
  a=((a+8) * NTRUPLUS_Q) >> 16;
  return a;
}

static inline int16_t plantard_reduce_acc(int32_t a)
{
	a = a >> 16;
	a = ((a+8)*NTRUPLUS_Q) >> 16;
	return a;
}

static inline int16_t plantard_mul(int32_t a, int32_t b)
{
	int32_t t = ((int32_t)(a*b)) >> 16;
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
	int32_t A,T1;

	A = a*QINV_PLANT;
	t1 = plantard_reduce_acc(a*A);    //10

	T1 = t1*QINV_PLANT;
	t2 = plantard_reduce_acc(t1*T1);  //100
	t2 = plantard_reduce(t2*t2);      //1000
	t3 = plantard_reduce(t2*t2);      //10000
	t1 = plantard_reduce_acc(t2*T1);  //1010

	T1 = t1*QINV_PLANT;
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
	int32_t T1,T2;
	int32_t zeta[5];
	int16_t v[8];

	int index = 1;

	zeta[0] = zetas_plant[index++];

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = plantard_mul(zeta[0], a[i + NTRUPLUS_N/2]);

		r[i + NTRUPLUS_N/2] = a[i] + a[i + NTRUPLUS_N/2] - t1;
		r[i               ] = a[i]                       + t1;
	}

	for(int start = 0; start < NTRUPLUS_N; start += 288)
	{
		zeta[0] = zetas_plant[index++];
		zeta[1] = zetas_plant[index++];

		for(int i = start; i < start + 96; i++)
		{
			t1 = plantard_mul(zeta[0], r[i +  96]);
			t2 = plantard_mul(zeta[1], r[i + 192]);
			t3 = plantard_mul(-898253212, t1 - t2);

			r[i + 192] = r[i] - t1 - t3;
			r[i +  96] = r[i] - t2 + t3;
			r[i      ] = r[i] + t1 + t2;
		}		
	}

	for(int i = 0; i < 6; i++)
	{
		zeta[0] = zetas_plant[6+2*i];
		zeta[1] = zetas_plant[7+2*i];
		zeta[2] = zetas_plant[18+3*i];
		zeta[3] = zetas_plant[19+3*i];
		zeta[4] = zetas_plant[20+3*i];

		for(int j = 0; j < 16; j++)
		{
			for(int k = 0; k < 6; k++)
			{
				v[k] = r[16*k+j+96*i];
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
				r[16*k+j+96*i] = v[k];
			}
		}
	}

	for (int i = 0; i < 36; i++)
	{
		zeta[0] = zetas_plant[36+i];
		zeta[1] = zetas_plant[72+2*i];
		zeta[2] = zetas_plant[73+2*i];

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

			T1 = v[0] * zetas_plant[0];
			T2 = v[2] * zeta[1];
			v[2] = plantard_reduce_acc(T1 - T2);
			v[0] = plantard_reduce_acc(T1 + T2);

			T1 = v[1] * zetas_plant[0];
			T2 = v[3] * zeta[1];
			v[3] = plantard_reduce_acc(T1 - T2);
			v[1] = plantard_reduce_acc(T1 + T2);

			T1 = v[4] * zetas_plant[0];
			T2 = v[6] * zeta[2];
			v[6] = plantard_reduce_acc(T1 - T2);
			v[4] = plantard_reduce_acc(T1 + T2);

			T1 = v[5] * zetas_plant[0];
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
	int16_t t1, t2, t3;
	int32_t zeta[5];
	int16_t v[4];

	int index;

	for (int i = 0; i < 36; i++)
	{
		zeta[0] = zetas_plant[143-2*i];
		zeta[1] = zetas_plant[142-2*i];
		zeta[2] = zetas_plant[71-i];

		for (int j = 0; j < 4; j++)
		{
			for (int k = 0; k < 4; k++)
			{
				v[k] = a[4*k+j+16*i];
			}

			t1 = v[1];
			t2 = v[3];

			v[1] = plantard_mul(zeta[0],  t1 - v[0]);
			v[3] = plantard_mul(zeta[1],  t2 - v[2]);
			v[0] = v[0] + t1;
			v[2] = v[2] + t2;

			t1 = v[2];
			t2 = v[3];

			v[2] = plantard_mul(zeta[2],  t1 - v[0]);
			v[3] = plantard_mul(zeta[2],  t2 - v[1]);
			v[0] = v[0] + t1;
			v[1] = v[1] + t2;								

			for (int k = 0; k < 4; k++)
			{
				r[4*k+j+16*i] = v[k];
			}
		}
	}

	index = 35;

	for(int step = 16; step <= 16; step <<= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta[0] = zetas_plant[index--];

			for(int i = start; i < start + step; i++)
			{
				t1 = r[i + step];

				r[i + step] = plantard_mul(zeta[0],  t1 - r[i]);
				r[i       ] = r[i] + t1;
			}
		}
	}

	for(int step = 32; step <= 32; step = 3*step)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta[1] = zetas_plant[index--];
			zeta[0] = zetas_plant[index--];

			for(int i = start; i < start + step; i++)
			{
				t1 = plantard_mul(-898253212,  r[i +   step] - r[i]);
				t2 = plantard_mul(zeta[0], r[i + 2*step] - r[i]        + t1);
				t3 = plantard_mul(zeta[1], r[i + 2*step] - r[i + step] - t1);

				r[i         ] = plantard_mul(r[i] + r[i + step] + r[i + 2*step], zetas_plant[0]);
				r[i +   step] = t2;			
				r[i + 2*step] = t3;
			}
		}
	}

	for(int step = 96; step <= NTRUPLUS_N/6; step = 3*step)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta[1] = zetas_plant[index--];
			zeta[0] = zetas_plant[index--];

			for(int i = start; i < start + step; i++)
			{
				t1 = plantard_mul(-898253212,  r[i +   step] - r[i]);
				t2 = plantard_mul(zeta[0], r[i + 2*step] - r[i]        + t1);
				t3 = plantard_mul(zeta[1], r[i + 2*step] - r[i + step] - t1);

				r[i         ] = r[i] + r[i + step] + r[i + 2*step];
				r[i +   step] = t2;			
				r[i + 2*step] = t3;
			}
		}
	}

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = r[i] + r[i + NTRUPLUS_N/2];
		t2 = plantard_mul(2030077108, r[i] - r[i + NTRUPLUS_N/2]);

		r[i               ] = plantard_mul(88210205, t1 - t2);
		r[i + NTRUPLUS_N/2] = plantard_mul(176420410, t2);
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
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
int baseinv(int16_t r[8], const int16_t a[8], int32_t zeta)
{
	int16_t t0, t1, t2;
	int16_t s0, s1, s2;
	int32_t A0, A1, A2, A3;
	int32_t B0, B1, B2, B3;
	int32_t det0, det1;
	int32_t zeta1, zeta2;
	int32_t T, S;

	zeta1 = zeta;
	zeta2 = -zeta;

	A0 = a[0]*QINV_PLANT;
	A1 = a[1]*QINV_PLANT;
	A2 = a[2]*QINV_PLANT;
	A3 = a[3]*QINV_PLANT;
	B0 = a[4]*QINV_PLANT;
	B1 = a[5]*QINV_PLANT;
	B2 = a[6]*QINV_PLANT;
	B3 = a[7]*QINV_PLANT;

	t0 = plantard_reduce_acc(a[2]*A2 - (a[1]*A3 << 1));
	s0 = plantard_reduce_acc(a[6]*B2 - (a[5]*B3 << 1));
	t1 = plantard_reduce_acc(a[3]*A3);
	s1 = plantard_reduce_acc(a[7]*B3);
	t0 = plantard_reduce_acc(a[0]*A0 + t0*zeta1);
	s0 = plantard_reduce_acc(a[4]*B0 + s0*zeta2);
	t1 = plantard_reduce_acc(a[1]*A1 + t1*zeta1 - ((a[0]*A2) << 1));
	s1 = plantard_reduce_acc(a[5]*B1 + s1*zeta2 - ((a[4]*B2) << 1));
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
	det0 = plantard_reduce(det0);
	det1 = plantard_reduce(det1);

	T = det0 * QINV_PLANT;
	S = det1 * QINV_PLANT;

	r[0] = -plantard_reduce_acc(r[0]*T);
	r[1] =  plantard_reduce_acc(r[1]*T);
	r[2] = -plantard_reduce_acc(r[2]*T);
	r[3] =  plantard_reduce_acc(r[3]*T);
	r[4] = -plantard_reduce_acc(r[4]*S);
	r[5] =  plantard_reduce_acc(r[5]*S);
	r[6] = -plantard_reduce_acc(r[6]*S);
	r[7] =  plantard_reduce_acc(r[7]*S);

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
void basemul(int16_t r[4], const int16_t a[4], const int16_t b[4], int16_t zeta)
{
	r[0] = montgomery_reduce(a[1]*b[3]+a[2]*b[2]+a[3]*b[1]);
	r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
	r[2] = montgomery_reduce(a[3]*b[3]);

	r[0] = montgomery_reduce(r[0]*zeta+a[0]*b[0]);
	r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
	r[2] = montgomery_reduce(r[2]*zeta+a[0]*b[2]+a[1]*b[1]+a[2]*b[0]);
	r[3] = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
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
void basemul_add(int16_t r[4], const int16_t a[4], const int16_t b[4], const int16_t c[4], int16_t zeta)
{
	r[0] = montgomery_reduce(a[1]*b[3]+a[2]*b[2]+a[3]*b[1]);
	r[1] = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);
	r[2] = montgomery_reduce(a[3]*b[3]);

	r[0] = montgomery_reduce(c[0]*(-147)+r[0]*zeta+a[0]*b[0]);
	r[1] = montgomery_reduce(c[1]*(-147)+r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
	r[2] = montgomery_reduce(c[2]*(-147)+r[2]*zeta+a[0]*b[2]+a[1]*b[1]+a[2]*b[0]);
	r[3] = montgomery_reduce(c[3]*(-147)+a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]);
}
