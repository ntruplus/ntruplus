#include "params.h"
#include "reduce.h"
#include "ntt.h"

const int16_t zetas[192] = {
	 -147, -1033,  -682,  -248,  -708,   682,     1,  -722,
	 -723,  -257, -1124,  -867,  -256,  1484,  1262, -1590,
	 1611,   222,  1164, -1346,  1716, -1521,  -357,   395,
	 -455,   639,   502,   655,  -699,   541,    95, -1577,
	-1241,   550,   -44,    39,  -820,  -216,  -121,  -757,
	 -348,   937,   893,   387,  -603,  1713, -1105,  1058,
	 1449,   837,   901,  1637,  -569, -1617, -1530,  1199,
	   50,  -830,  -625,     4,   176,  -156,  1257, -1507,
	 -380,  -606,  1293,   661,  1428, -1580,  -565,  -992,
	  548,  -800,    64,  -371,   961,   641,    87,   630,
	  675,  -834,   205,    54, -1081,  1351,  1413, -1331,
	-1673, -1267, -1558,   281, -1464,  -588,  1015,   436,
	  223,  1138, -1059,  -397,  -183,  1655,   559, -1674,
	  277,   933,  1723,   437, -1514,   242,  1640,   432,
	-1583,   696,   774,  1671,   927,   514,   512,   489,
	  297,   601,  1473,  1130,  1322,   871,   760,  1212,
	 -312,  -352,   443,   943,     8,  1250,  -100,  1660,
	  -31,  1206, -1341, -1247,   444,   235,  1364, -1209,
	  361,   230,   673,   582,  1409,  1501,  1401,   251,
	 1022, -1063,  1053,  1188,   417, -1391,   -27, -1626,
	 1685,  -315,  1408, -1248,   400,   274, -1543,    32,
	-1550,  1531, -1367,  -124,  1458,  1379,  -940, -1681,
	   22,  1709,  -275,  1108,   354, -1728,  -968,   858,
	 1221,  -218,   294,  -732, -1095,   892,  1588,  -779
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
	int16_t zeta[7];
	int16_t v[8];
	
	zeta[0] = zetas[1];
	zeta[1] = zetas[2];
	zeta[2] = zetas[3];
	zeta[3] = zetas[4];
	zeta[4] = zetas[5];

	for (int i = 0; i < 128; i++)
	{
		for (int j = 0; j < 6; j++)
		{
			v[j] = a[128*j+i];
		}

		t1 = fqmul(zeta[0], v[3]);
		v[3] = (v[0] + v[3] - t1);
		v[0] = (v[0] + t1);

		t1 = fqmul(zeta[0], v[4]);
		v[4] = (v[1] + v[4] - t1);
		v[1] = (v[1] + t1);

		t1 = fqmul(zeta[0], v[5]);
		v[5] = (v[2] + v[5] - t1);
		v[2] = (v[2] + t1);

		t1 = fqmul(zeta[1], v[1]);
		t2 = fqmul(zeta[2], v[2]);
		t3 = fqmul(-886, t1 - t2);

		v[2] = v[0] - t1 - t3;
		v[1] = v[0] - t2 + t3;
		v[0] = v[0] + t1 + t2;

		t1 = fqmul(zeta[3], v[4]);
		t2 = fqmul(zeta[4], v[5]);
		t3 = fqmul(-886, t1 - t2);

		v[5] = v[3] - t1 - t3;
		v[4] = v[3] - t2 + t3;
		v[3] = v[3] + t1 + t2;

		for (int j = 0; j < 6; j++)
		{
			r[128*j+i] = v[j];
		}
	}

	for (int i = 0; i < 6; i++)
	{
		zeta[0] = zetas[6+i];
		zeta[1] = zetas[12+2*i];
		zeta[2] = zetas[13+2*i];
		zeta[3] = zetas[24+4*i];
		zeta[4] = zetas[25+4*i];
		zeta[5] = zetas[26+4*i];
		zeta[6] = zetas[27+4*i];

		for (int j = 0; j < 16; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = r[16*k+j+128*i];
			}

			t1 = fqmul(zeta[0], v[4]);
			v[4] = (v[0] - t1);
			v[0] = (v[0] + t1);

			t1 = fqmul(zeta[0], v[5]);
			v[5] = (v[1] - t1);
			v[1] = (v[1] + t1);

			t1 = fqmul(zeta[0], v[6]);
			v[6] = (v[2] - t1);
			v[2] = (v[2] + t1);

			t1 = fqmul(zeta[0], v[7]);
			v[7] = (v[3] - t1);
			v[3] = (v[3] + t1);

			t1 = fqmul(zeta[1], v[2]);
			v[2] = (v[0] - t1);
			v[0] = (v[0] + t1);

			t1 = fqmul(zeta[1], v[3]);
			v[3] = (v[1] - t1);
			v[1] = (v[1] + t1);

			t1 = fqmul(zeta[2], v[6]);
			v[6] = (v[4] - t1);
			v[4] = (v[4] + t1);

			t1 = fqmul(zeta[2], v[7]);
			v[7] = (v[5] - t1);
			v[5] = (v[5] + t1);

			t1 = fqmul(zeta[3], v[1]);
			v[1] = (v[0] - t1);
			v[0] = (v[0] + t1);

			t1 = fqmul(zeta[4], v[3]);
			v[3] = (v[2] - t1);
			v[2] = (v[2] + t1);

			t1 = fqmul(zeta[5], v[5]);
			v[5] = (v[4] - t1);
			v[4] = (v[4] + t1);

			t1 = fqmul(zeta[6], v[7]);
			v[7] = (v[6] - t1);
			v[6] = (v[6] + t1);

			for (int k = 0; k < 8; k++)
			{
				r[16*k+j+128*i] = v[k];
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

			t1 = fqmul(zeta[0], v[4]);
			v[4] = (v[0] - t1);
			v[0] = (v[0] + t1);

			t1 = fqmul(zeta[0], v[5]);
			v[5] = (v[1] - t1);
			v[1] = (v[1] + t1);

			t1 = fqmul(zeta[0], v[6]);
			v[6] = (v[2] - t1);
			v[2] = (v[2] + t1);

			t1 = fqmul(zeta[0], v[7]);
			v[7] = (v[3] - t1);
			v[3] = (v[3] + t1);

			T1 = v[0] * (-147);
			T2 = v[2] * zeta[1];
			v[2] = montgomery_reduce(T1 - T2);
			v[0] = montgomery_reduce(T1 + T2);

			T1 = v[1] * (-147);
			T2 = v[3] * zeta[1];
			v[3] = montgomery_reduce(T1 - T2);
			v[1] = montgomery_reduce(T1 + T2);

			T1 = v[4] * (-147);
			T2 = v[6] * zeta[2];
			v[6] = montgomery_reduce(T1 - T2);
			v[4] = montgomery_reduce(T1 + T2);

			T1 = v[5] * (-147);
			T2 = v[7] * zeta[2];
			v[7] = montgomery_reduce(T1 - T2);
			v[5] = montgomery_reduce(T1 + T2);

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
	int16_t zeta[7];
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

			v[1] = fqmul(zeta[0],  t1 - v[0]);
			v[0] = barrett_reduce(v[0] + t1);

			t1 = v[3];

			v[3] = fqmul(zeta[1],  t1 - v[2]);
			v[2] = barrett_reduce(v[2] + t1);

			t1 = v[5];

			v[5] = fqmul(zeta[2],  t1 - v[4]);
			v[4] = barrett_reduce(v[4] + t1);

			t1 = v[7];

			v[7] = fqmul(zeta[3],  t1 - v[6]);
			v[6] = barrett_reduce(v[6] + t1);


			t1 = v[2];

			v[2] = fqmul(zeta[4],  t1 - v[0]);
			v[0] = (v[0] + t1);

			t1 = v[3];

			v[3] = fqmul(zeta[4],  t1 - v[1]);
			v[1] = (v[1] + t1);

			t1 = v[6];

			v[6] = fqmul(zeta[5],  t1 - v[4]);
			v[4] = (v[4] + t1);

			t1 = v[7];

			v[7] = fqmul(zeta[5],  t1 - v[5]);
			v[5] = (v[5] + t1);


			t1 = v[4];

			v[4] = fqmul(zeta[6],  t1 - v[0]);
			v[0] = barrett_reduce(v[0] + t1);

			t1 = v[5];

			v[5] = fqmul(zeta[6],  t1 - v[1]);
			v[1] = barrett_reduce(v[1] + t1);

			t1 = v[6];

			v[6] = fqmul(zeta[6],  t1 - v[2]);
			v[2] = barrett_reduce(v[2] + t1);

			t1 = v[7];

			v[7] = fqmul(zeta[6],  t1 - v[3]);
			v[3] = barrett_reduce(v[3] + t1);			
				
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

		v[0] = fqmul(1679, t1 - t2);
		v[3] = fqmul(-99, t2);

		t1 = v[1] + v[4];
		t2 = fqmul(-1665, v[1] - v[4]);

		v[1] = fqmul(1679, t1 - t2);
		v[4] = fqmul(-99, t2);

		t1 = v[2] + v[5];
		t2 = fqmul(-1665, v[2] - v[5]);

		v[2] = fqmul(1679, t1 - t2);
		v[5] = fqmul(-99, t2);				

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
