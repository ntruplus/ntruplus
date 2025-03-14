#include "params.h"
#include "ntt.h"

#define QINV 12929 // q^(-1) mod 2^16
#define QINV_PLANT 1951806081u // q^(-1) mod 2^32

const int16_t zetas[288] = {
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
	 -194,   928,  1229, -1032,  1608,  1111, -1669,   642,
	-1323,   163,   309,   981,  -557,  -258,   232, -1680,
	-1657, -1233,   144,  1699,   311, -1060,   578,  1298,
	 -403,  1607,  1074,  -148,   447, -1568,  1142,  -402,
	-1412,  -623,   855,   365,   -98,  -244,   407,  1225,
	  416,   683,  -105,  1714, -1019,  1061,  1163,   638,
	  798,  1493,  -351,   396,  -542,    -9,  1616,  -139,
	 -987,  -482,   889,   238, -1513,   466, -1089,  -101,
	  849,  -426,  1589,  1487,   671,  1459,  -776,   255,
	-1014,  1144,   472, -1153,  -325,  1519,   -26, -1123,
	  324,  1230,  1547,  -593,  -428,  1192,  1072, -1564,
	  688,  -333,  1023, -1686,   841,   824,   -71,  1587,
	  522,  -323,  1148,   389,  1231,   384,  1343,   169,
	  628, -1329, -1056,  -936,    24,  -293,  1523,  -300,
	-1654,   891,  -962,   -67,   179, -1177,   844,  -509,
	-1677, -1565,  -549, -1508,  1191,  -280,   -43,   669,
	 -746,   753,   770, -1046,  1711,  1438,   690,  1083,
	 1062,  1727,  -883,   553,  1670,    66,   825,  -133,
	-1586,   637,  -680,  -917,   644,  -372, -1193, -1136
};

const int32_t zetas_plant[288] = {
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
	 1170338210,  -329235271, -1967957245, -1744325740,  -977766636,  -769043898,  1124369512,  1484664715,
	   11181575,  -673379310,   172693218,  2007713957,  -491989311,  -436081435,   991433006,  1854899095,
	 -453474997,  1062249649, -1754264918,  -774013487, -1521936632,   505655681,  -121754931,  -303144929,
	-2129468888,  -130451711,   516837256,   848557322,  -792649446,  1444908003, -1266002799,  1318183483,
	-1887201424,  -403779107,  1395212113,   -32302329,  1432484030,   586411502, -1259790812,  1421302455,
	 -295690546,  1104491156, -1226246087,  -598835475,   125482122, -1352970606, -1879747040,   578957119,
	-1847444712,  1974169232,  1054795266,  -529261229,  -316811299,  -964100267,   833648555,  1812657589,
	-1218791703,   383900750, -1643691563,   202510752,  2087227381,   288236162,  -692015269,  -320538491,
	-2110832929,   178905204, -2058652245, -1531875810, -1612631632,   718105611,   386385545, -1316941086,
	  183874793,  1334334647,  -500686092,  1996532382,   499443695,  1418817660,   555351571, -1948078889,
	  347871230,  1479695126,  -831163761,   -53423082,  1873535054,  -682076091, -2083500190, -1944351697,
	 1162883827, -1311971497,   780225473, -1651145946,   372719175,  1892171013,    29817534,  -364022394,
	   83240616, -1195186155, -2054925053,  1106975950,   632380201,  1048583280,   222389108, -1462301564,
	  462171777,   800103830,  1411363277, -1482179920,  1139278279,  -844830131, -1970442040,   791407049,
	 1299547524,   956645883,  -926828349,   935525130, -1345516223,   857254103,  2125741696,  1786567247,
	 -687045680, -1097036772,  1319425880,  2145620052,   165238834,  1024977732,  2074803409,    81998219,
	  736741570,  1921988547,   402536709,  1528148618,  1943109300,  1331849853,  -531746023,  1480937523,
	 2094681765,  1270972388,   854769309,  -413718285, -1971684437,   -88210205,  1044856088,  1023735335,
	 -483292531,  1426272044,   648531365,  -401294312,  -209965135,  1668539508,  1529391016,   477080544
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
	int16_t t;
	
	t = (int16_t)a*QINV;
	t = (a - (int32_t)t*NTRUPLUS_Q) >> 16;
	
	return t;
}

static inline int16_t plantard_reduce(int32_t a)
{
	a=a*QINV_PLANT;
	a>>=16;
	a=((a+8)*NTRUPLUS_Q)>>16;

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
	int32_t t;

	t=((int32_t)a*b) >> 16;
	t=((t+8)*NTRUPLUS_Q) >> 16;

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

	for(int start = 0; start < NTRUPLUS_N; start += 432)
	{
		zeta[0] = zetas_plant[index++];
		zeta[1] = zetas_plant[index++];

		for(int i = start; i < start + 144; i++)
		{
			t1 = plantard_mul(zeta[0], r[i + 144]);
			t2 = plantard_mul(zeta[1], r[i + 288]);
			t3 = plantard_mul(-898253212, t1 - t2);

			r[i + 288] = r[i] - t1 - t3;
			r[i + 144] = r[i] - t2 + t3;
			r[i      ] = r[i] + t1 + t2;
		}		
	}

	for (int i = 0; i < 6; i++)
	{
		zeta[0] = zetas_plant[6+2*i];
		zeta[1] = zetas_plant[7+2*i];
		zeta[2] = zetas_plant[18+3*i];
		zeta[3] = zetas_plant[19+3*i];
		zeta[4] = zetas_plant[20+3*i];

		for (int j = 0; j < 24; j++)
		{
			for (int k = 0; k < 6; k++)
			{
				v[k] = r[24*k+j+144*i];
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
				r[24*k+j+144*i] = v[k];
			}
		}
	}

	for (int i = 0; i < 36; i++)
	{
		zeta[0] = zetas_plant[36+i];
		zeta[1] = zetas_plant[72+2*i];
		zeta[2] = zetas_plant[73+2*i];

		for (int j = 0; j < 3; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = r[3*k+j+24*i];
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
				r[3*k+j+24*i] = v[k];
			}
		}
	}

	index = 144;

	for(int start = 0; start < NTRUPLUS_N; start += 6)
	{
		zeta[0] = zetas_plant[index++];

		for(int i = start; i < start + 3; i++)
		{
			T1 = r[i]*zetas_plant[0];
			T2 = zeta[0]*r[i + 3];

			r[i + 3] = plantard_reduce_acc(T1 - T2);
			r[i    ] = plantard_reduce_acc(T1 + T2);
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
	int32_t zeta[7];
	int16_t v[8];

	for (int i = 0; i < 36; i++)
	{
		zeta[0] = zetas_plant[287-4*i];
		zeta[1] = zetas_plant[286-4*i];
		zeta[2] = zetas_plant[285-4*i];
		zeta[3] = zetas_plant[284-4*i];
		zeta[4] = zetas_plant[143-2*i];
		zeta[5] = zetas_plant[142-2*i];
		zeta[6] = zetas_plant[71-i];

		for (int j = 0; j < 3; j++)
		{
			for (int k = 0; k < 8; k++)
			{
				v[k] = a[3*k+j+24*i];
			}

			t1 = v[1];

			v[1] = plantard_mul(zeta[0],  t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];

			v[3] = plantard_mul(zeta[1],  t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[5];

			v[5] = plantard_mul(zeta[2],  t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = v[7];

			v[7] = plantard_mul(zeta[3],  t1 - v[6]);
			v[6] = v[6] + t1;


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
			v[0] = v[0] + t1;

			t1 = v[5];

			v[5] = plantard_mul(zeta[6],  t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];

			v[6] = plantard_mul(zeta[6],  t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[7];

			v[7] = plantard_mul(zeta[6],  t1 - v[3]);
			v[3] = v[3] + t1;			
				
			for (int k = 0; k < 8; k++)
			{
				r[3*k+j+24*i] = v[k];
			}
		}
	}

	for (int i = 0; i < 6; i++)
	{
		zeta[0] = zetas_plant[35-3*i];
		zeta[1] = zetas_plant[34-3*i];
		zeta[2] = zetas_plant[33-3*i];
		zeta[3] = zetas_plant[16-2*i];
		zeta[4] = zetas_plant[17-2*i];

		for (int j = 0; j < 24; j++)
		{
			for (int k = 0; k < 6; k++)
			{
				v[k] = r[24*k+j+144*i];
			}

			t1 = v[1];

			v[1] = plantard_mul(zeta[0],  t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];

			v[3] = plantard_mul(zeta[1],  t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[5];

			v[5] = plantard_mul(zeta[2],  t1 - v[4]);
			v[4] = v[4] + t1;			

			t1 = plantard_mul(-898253212,    v[2] - v[0]);
			t2 = plantard_mul(zeta[3], v[4] - v[0] + t1);
			t3 = plantard_mul(zeta[4], v[4] - v[2] - t1);

			v[0] = plantard_mul(v[0] + v[2] + v[4], zetas_plant[0]);
			v[2] = t2;
			v[4] = t3;

			t1 = plantard_mul(-898253212,    v[3] - v[1]);
			t2 = plantard_mul(zeta[3], v[5] - v[1] + t1);
			t3 = plantard_mul(zeta[4], v[5] - v[3] - t1);

			v[1] = plantard_mul(v[1] + v[3] + v[5], zetas_plant[0]);
			v[3] = t2;
			v[5] = t3;

			for (int k = 0; k < 6; k++)
			{
				r[24*k+j+144*i] = v[k];
			}
		}
	}

	zeta[0] = zetas_plant[4];
	zeta[1] = zetas_plant[5];
	zeta[2] = zetas_plant[2];
	zeta[3] = zetas_plant[3];

	for (int i = 0; i < 144; i++)
	{
		for (int j = 0; j < 6; j++)
		{
			v[j] = a[144*j+i];
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

		v[0] = plantard_mul(-2103378546, t1 - t2);
		v[3] = plantard_mul(88210205, t2);

		t1 = v[1] + v[4];
		t2 = plantard_mul(2030077108, v[1] - v[4]);

		v[1] = plantard_mul(-2103378546, t1 - t2);
		v[4] = plantard_mul(88210205, t2);

		t1 = v[2] + v[5];
		t2 = plantard_mul(2030077108, v[2] - v[5]);

		v[2] = plantard_mul(-2103378546, t1 - t2);
		v[5] = plantard_mul(88210205, t2);				

		for (int j = 0; j < 6; j++)
		{
			r[144*j+i] = v[j];
		}
	}
}

/*************************************************
* Name:        baseinv
*
* Description: Inversion of polynomial in Zq[X]/(X^3-zeta)
*              used for inversion of element in Rq in NTT domain
*
* Arguments:   - int16_t r[3]: pointer to the output polynomial
*              - const int16_t a[3]: pointer to the input polynomial
*              - int32_t zeta: integer defining the reduction polynomial
**************************************************/
int baseinv(int16_t r[6], const int16_t a[6], int32_t zeta)
{
	int16_t t, s;
	int32_t A0, A1, A2, T;
	int32_t B0, B1, B2, S;

	A0 = a[0]*QINV_PLANT;
	A1 = a[1]*QINV_PLANT;
	A2 = a[2]*QINV_PLANT;

	r[0] = plantard_reduce_acc(a[1]*A2);
	r[1] = plantard_reduce_acc(a[2]*A2);
	r[2] = plantard_reduce_acc(a[1]*A1-a[0]*A2);

	r[0] = plantard_reduce_acc(a[0]*A0-r[0]*zeta);
	r[1] = plantard_reduce_acc(r[1]*zeta-a[0]*A1);

	t  = plantard_reduce_acc(r[2]*A1+r[1]*A2);
	t  = plantard_reduce_acc(t*zeta+r[0]*A0);

	if(t == 0) return 1;

	B0 = a[3]*QINV_PLANT;
	B1 = a[4]*QINV_PLANT;
	B2 = a[5]*QINV_PLANT;

	r[3] = plantard_reduce_acc(a[4]*B2);
	r[4] = plantard_reduce_acc(a[5]*B2);
	r[5] = plantard_reduce_acc(a[4]*B1-a[3]*B2);

	r[3] = plantard_reduce_acc(a[3]*B0+r[3]*zeta);
	r[4] = -plantard_reduce_acc(r[4]*zeta+a[3]*B1);

	s  = plantard_reduce_acc(r[5]*B1+r[4]*B2);
	s  = plantard_reduce_acc(-s*zeta+r[3]*B0);

	if(s == 0) return 1;	

	t = fqinv(t);
	s = fqinv(s);
	t = plantard_reduce(t);
	s = plantard_reduce(s);
	
	T = -t*QINV_PLANT;
	S = -s*QINV_PLANT;

	r[0] = plantard_reduce_acc(r[0]*T);
	r[1] = plantard_reduce_acc(r[1]*T);
	r[2] = plantard_reduce_acc(r[2]*T);
	r[3] = plantard_reduce_acc(r[3]*S);
	r[4] = plantard_reduce_acc(r[4]*S);
	r[5] = plantard_reduce_acc(r[5]*S);

	return 0;
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^3-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t c[3]: pointer to the output polynomial
*              - const int16_t a[3]: pointer to the first factor
*              - const int16_t b[3]: pointer to the second factor
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
void basemul(int16_t r[3], const int16_t a[3], const int16_t b[3], int16_t zeta)
{
	r[0] = montgomery_reduce(a[2]*b[1]+a[1]*b[2]);
	r[1] = montgomery_reduce(a[2]*b[2]);

	r[0] = montgomery_reduce(r[0]*zeta+a[0]*b[0]);
	r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
	r[2] = montgomery_reduce(a[2]*b[0]+a[1]*b[1]+a[0]*b[2]);
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^3-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t c[3]: pointer to the output polynomial
*              - const int16_t a[3]: pointer to the first factor
*              - const int16_t b[3]: pointer to the second factor
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
void basemul_add(int16_t r[3], const int16_t a[3], const int16_t b[3], const int16_t c[3], int16_t zeta)
{
	r[0] = montgomery_reduce(a[2]*b[1]+a[1]*b[2]);
	r[1] = montgomery_reduce(a[2]*b[2]);

	r[0] = montgomery_reduce(c[0]*(-147)+r[0]*zeta+a[0]*b[0]);
	r[1] = montgomery_reduce(c[1]*(-147)+r[1]*zeta+a[0]*b[1]+a[1]*b[0]);
	r[2] = montgomery_reduce(c[2]*(-147)+a[2]*b[0]+a[1]*b[1]+a[0]*b[2]);
}
