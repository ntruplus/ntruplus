#include "params.h"
#include "reduce.h"
#include "ntt.h"

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

const int32_t zetas_asm[144] = {
		3397956481, 2406523475, 1396454510, 1077158417, 1888443822,
		559078763, 2477340119, 195056369, 903222802, 708166433, 3856401067, 3027722101, 2904724773, 3550771343, 3112205114, 122997328,
		1339304237, 660955338, 4162030791, 1490876701, 1623813207, 3484924289, 2015168341, 972797048, 1545542180, 735499173, 1042371294,
		2139408066, 3273716756, 200025958, 1610146838, 1410120880, 900738007, 2067349026, 44726302, 1601450057, 2502188064, 2022622725,
		1129339101, 72059041, 2395341900, 1434968825, 3334594222, 213692328, 970312253, 1456089578, 119270137, 332962464, 3809189971,
		2361797174, 1535603002, 1212579717, 690772872, 3773160451, 552866777, 587653900, 3966974422, 4004246340, 262145820, 915646774,
		370234381, 2955663060, 3714767780, 2292222928, 2872422444, 1605177249, 2594125460, 2946966279, 3392986892, 703196844, 3942126477,
		100634178, 2529520803, 1554238961, 889556432, 2309616490, 3120901894, 356568011, 3342048605, 3482439494, 255933834, 3199172921, 1566662934, 1915776561, 3455106755, 2386645119, 1822596767, 1654873139, 3419077235, 4083759764, 788922255, 2666184501, 2167983203, 3477469905, 1032432116, 1633752385, 1350485812, 1848687110, 3200415319, 7454384, 982736226, 1546784578, 4201787503, 1443665606, 4207999489, 3207869702, 3429016413, 2914663951, 1997774780, 3497348261, 2221406285, 1832535945, 355325614, 146602876, 715620817, 1282153963, 1526906222, 4053942230, 1152944649, 129209315, 1285881155, 1041128897, 2679850870, 2117044916, 4219181064, 1200155745, 3601709631, 1979138821, 1070946431, 501928490, 3178052168, 3096053949, 1572874920, 2481067310, 4248998598, 1170338211, 3965732025, 2327010051, 2550641556, 3317200660, 3525923398, 1124369512, 1484664715, 0
};

/*************************************************
* Name:        fqmul
*
* Description: Multiplication followed by Montgomery reduction
*
* Arguments:   - int16_t a: first factor
*              - int16_t b: second factor
*
* Returns 16-bit integer congruent to a*b*R^{-1} mod q
**************************************************/
static int16_t fqmul(int16_t a, int16_t b)
{
	return montgomery_reduce((int32_t)a*b);
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
static int16_t fqinv(int16_t a)
{
	int16_t t1,t2,t3;

	t1 = fqmul(a, a);    //10
	t2 = fqmul(t1, t1);  //100
	t2 = fqmul(t2, t2);  //1000
	t3 = fqmul(t2, t2);  //10000

	t1 = fqmul(t1, t2);  //1010

	t2 = fqmul(t1, t3);  //11010
	t2 = fqmul(t2, t2);  //110100
	t2 = fqmul(t2, a);   //110101

	t1 = fqmul(t1, t2);  //111111

	t2 = fqmul(t2, t2);  //1101010
	t2 = fqmul(t2, t2);  //11010100
	t2 = fqmul(t2, t2);  //110101000
	t2 = fqmul(t2, t2);  //1101010000
	t2 = fqmul(t2, t2);  //11010100000
	t2 = fqmul(t2, t2);  //110101000000
	t2 = fqmul(t2, t1);  //110101111111

	return t2;
}

extern void ntt_fast(int16_t *, const int32_t *);
/*************************************************
* Name:        ntt
*
* Description: number-theoretic transform (NTT) in Rq.
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to input/output vector of elements of Zq
**************************************************/
void ntt(int16_t r[NTRUPLUS_N])
{
	ntt_fast(r, zetas_asm);

	for(int i = 0; i < NTRUPLUS_N; i++)
	{
		r[i] = barrett_reduce(r[i]);
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
	int16_t zeta[5];
	int16_t v[8];

	for (int i = 0; i < 36; i++)
	{
		zeta[0] = zetas[143-2*i];
		zeta[1] = zetas[142-2*i];
		zeta[2] = zetas[71-i];

		for (int j = 0; j < 2; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = a[2*k+j+16*i];
			}

			t1 = v[2];

			v[2] = fqmul(zeta[0],  t1 - v[0]);
			v[0] = (v[0] + t1);

			t1 = v[3];

			v[3] = fqmul(zeta[0],  t1 - v[1]);
			v[1] = (v[1] + t1);

			t1 = v[6];

			v[6] = fqmul(zeta[1],  t1 - v[4]);
			v[4] = (v[4] + t1);

			t1 = v[7];

			v[7] = fqmul(zeta[1],  t1 - v[5]);
			v[5] = (v[5] + t1);


			t1 = v[4];

			v[4] = fqmul(zeta[2],  t1 - v[0]);
			v[0] = (v[0] + t1);

			t1 = v[5];

			v[5] = fqmul(zeta[2],  t1 - v[1]);
			v[1] = (v[1] + t1);

			t1 = v[6];

			v[6] = fqmul(zeta[2],  t1 - v[2]);
			v[2] = (v[2] + t1);

			t1 = v[7];

			v[7] = fqmul(zeta[2],  t1 - v[3]);
			v[3] = (v[3] + t1);			
								

			for (int k = 0; k < 8; k++)
			{
				r[2*k+j+16*i] = v[k];
			}
		}
	}

	for (int i = 0; i < 6; i++)
	{
		zeta[0] = zetas[35-3*i];
		zeta[1] = zetas[34-3*i];
		zeta[2] = zetas[33-3*i];
		zeta[3] = zetas[16-2*i];
		zeta[4] = zetas[17-2*i];

		for (int j = 0; j < 16; j++)
		{
			for (int k = 0; k < 6; k++)
			{
				v[k] = r[16*k+j+96*i];
			}

			t1 = v[1];

			v[1] = fqmul(zeta[0],  t1 - v[0]);
			v[0] = barrett_reduce(v[0] + t1);

			t1 = v[3];

			v[3] = fqmul(zeta[1],  t1 - v[2]);
			v[2] = barrett_reduce(v[2] + t1);

			t1 = v[5];

			v[5] = fqmul(zeta[2],  t1 - v[4]);
			v[4] = barrett_reduce(v[4] + t1);			

			t1 = fqmul(-886,    v[2] - v[0]);
			t2 = fqmul(zeta[3], v[4] - v[0] + t1);
			t3 = fqmul(zeta[4], v[4] - v[2] - t1);

			v[0] = (v[0] + v[2] + v[4]);
			v[2] = t2;
			v[4] = t3;

			t1 = fqmul(-886,    v[3] - v[1]);
			t2 = fqmul(zeta[3], v[5] - v[1] + t1);
			t3 = fqmul(zeta[4], v[5] - v[3] - t1);

			v[1] = (v[1] + v[3] + v[5]);
			v[3] = t2;
			v[5] = t3;

			for (int k = 0; k < 6; k++)
			{
				r[16*k+j+96*i] = v[k];
			}
		}
	}

	zeta[0] = zetas[4];
	zeta[1] = zetas[5];
	zeta[2] = zetas[2];
	zeta[3] = zetas[3];

	for (int i = 0; i < 96; i++)
	{
		for (int j = 0; j < 6; j++)
		{
			v[j] = a[96*j+i];
		}

		t1 = fqmul(-886,    v[1] - v[0]);
		t2 = fqmul(zeta[0], v[2] - v[0] + t1);
		t3 = fqmul(zeta[1], v[2] - v[1] - t1);

		v[0] = barrett_reduce(v[0] + v[1] + v[2]);
		v[1] = t2;
		v[2] = t3;

		t1 = fqmul(-886,    v[4] - v[3]);
		t2 = fqmul(zeta[2], v[5] - v[3] + t1);
		t3 = fqmul(zeta[3], v[5] - v[4] - t1);

		v[3] = barrett_reduce(v[3] + v[4] + v[5]);
		v[4] = t2;
		v[5] = t3;

		t1 = v[0] + v[3];
		t2 = fqmul(-1665, v[0] - v[3]);

		v[0] = fqmul(-66, t1 - t2);
		v[3] = fqmul(-132, t2);

		t1 = v[1] + v[4];
		t2 = fqmul(-1665, v[1] - v[4]);

		v[1] = fqmul(-66, t1 - t2);
		v[4] = fqmul(-132, t2);

		t1 = v[2] + v[5];
		t2 = fqmul(-1665, v[2] - v[5]);

		v[2] = fqmul(-66, t1 - t2);
		v[5] = fqmul(-132, t2);				

		for (int j = 0; j < 6; j++)
		{
			r[96*j+i] = v[j];
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
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
int baseinv(int16_t r[4], const int16_t a[4], int16_t zeta)
{
	int16_t t0, t1, t2;
	
	t0 = montgomery_reduce(a[2]*a[2] - (a[1]*a[3] << 1));
	t1 = montgomery_reduce(a[3]*a[3]);
	t0 = montgomery_reduce(a[0]*a[0] + t0*zeta);
	t1 = montgomery_reduce(((a[0]*a[2]) << 1) - a[1]*a[1] - t1*zeta);

	t2 = montgomery_reduce(t1*t1);
	t2 = montgomery_reduce(t0*t0 - t2*zeta);

	if(t2 == 0) return 1;

	t2 = fqinv(t2);
	t0 = fqmul(t0,t2);
	t1 = fqmul(t1,t2);
	t2 = fqmul(t1,zeta);
	
	r[0] = montgomery_reduce(a[0]*t0 - a[2]*t2);
	r[1] = montgomery_reduce(a[3]*t2 - a[1]*t0);
	r[2] = montgomery_reduce(a[2]*t0 - a[0]*t1);
	r[3] = montgomery_reduce(a[1]*t1 - a[3]*t0);

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
