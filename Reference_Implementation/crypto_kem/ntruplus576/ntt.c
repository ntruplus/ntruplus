#include "params.h"
#include "reduce.h"
#include "ntt.h"


int16_t zetas[287] = {2424, 2192, 708, 460, 1265, 2990, 727, 556, 1307, 2684, 3296, 1200, 1845, 570, 1529, 1135, 2901, 1120, 298, 2635, 1901, 3364, 1463, 532, 3080, 2548, 58, 3065, 3007, 1722, 1236, 2971, 2966, 1888, 2379, 36, 1289, 2014, 1628, 1664, 2732, 2505, 99, 2437, 353, 2858, 1119, 592, 839, 1622, 652, 1244, 2674, 2372, 2731, 566, 3173, 2088, 2165, 268, 3066, 781, 3285, 96, 2285, 211, 737, 473, 3012, 3223, 264, 1921, 1467, 2781, 1915, 3287, 635, 2752, 2125, 2799, 831, 1745, 1311, 1488, 2576, 1087, 2142, 1245, 3382, 791, 3451, 2582, 2760, 3387, 2295, 287, 2690, 2512, 1598, 2575, 1261, 206, 654, 2036, 3376, 716, 2206, 838, 2157, 1035, 3353, 966, 2899, 3396, 1753, 404, 2558, 862, 1864, 1997, 3420, 1266, 965, 1873, 2053, 3192, 2515, 905, 1195, 2838, 787, 118, 576, 286, 1982, 3263, 928, 1229, 2425, 1608, 1111, 1788, 642, 2134, 163, 309, 981, 2900, 3199, 232, 1777, 1800, 2224, 144, 1699, 311, 2397, 578, 1298, 3054, 1607, 1074, 3309, 447, 1889, 1142, 3055, 2045, 2834, 855, 365, 3359, 3213, 407, 1225, 416, 683, 3352, 1714, 2438, 1061, 1163, 638, 798, 1493, 3106, 396, 2915, 3448, 1616, 3318, 2470, 2975, 889, 238, 1944, 466, 2368, 3356, 849, 3031, 1589, 1487, 671, 1459, 2681, 255, 2443, 1144, 472, 2304, 3132, 1519, 3431, 2334, 324, 1230, 1547, 2864, 3029, 1192, 1072, 1893, 688, 3124, 1023, 1771, 841, 824, 3386, 1587, 522, 3134, 1148, 389, 1231, 384, 1343, 169, 628, 2128, 2401, 2521, 24, 3164, 1523, 3157, 1803, 891, 2495, 3390, 179, 2280, 844, 2948, 1780, 1892, 2908, 1949, 1191, 3177, 3414, 669, 2711, 753, 770, 2411, 1711, 1438, 690, 1083, 1062, 1727, 2574, 553, 1670, 66, 825, 3324, 1871, 637, 2777, 2540, 644, 3085, 2264, 2321};
int16_t zetas_inv[287] = {1136, 1193, 372, 2813, 917, 680, 2820, 1586, 133, 2632, 3391, 1787, 2904, 883, 1730, 2395, 2374, 2767, 2019, 1746, 1046, 2687, 2704, 746, 2788, 43, 280, 2266, 1508, 549, 1565, 1677, 509, 2613, 1177, 3278, 67, 962, 2566, 1654, 300, 1934, 293, 3433, 936, 1056, 1329, 2829, 3288, 2114, 3073, 2226, 3068, 2309, 323, 2935, 1870, 71, 2633, 2616, 1686, 2434, 333, 2769, 1564, 2385, 2265, 428, 593, 1910, 2227, 3133, 1123, 26, 1938, 325, 1153, 2985, 2313, 1014, 3202, 776, 1998, 2786, 1970, 1868, 426, 2608, 101, 1089, 2991, 1513, 3219, 2568, 482, 987, 139, 1841, 9, 542, 3061, 351, 1964, 2659, 2819, 2294, 2396, 1019, 1743, 105, 2774, 3041, 2232, 3050, 244, 98, 3092, 2602, 623, 1412, 402, 2315, 1568, 3010, 148, 2383, 1850, 403, 2159, 2879, 1060, 3146, 1758, 3313, 1233, 1657, 1680, 3225, 258, 557, 2476, 3148, 3294, 1323, 2815, 1669, 2346, 1849, 1032, 2228, 2529, 194, 1475, 3171, 2881, 3339, 2670, 619, 2262, 2552, 942, 265, 1404, 1584, 2492, 2191, 37, 1460, 1593, 2595, 899, 3053, 1704, 61, 558, 2491, 104, 2422, 1300, 2619, 1251, 2741, 81, 1421, 2803, 3251, 2196, 882, 1859, 945, 767, 3170, 1162, 70, 697, 875, 6, 2666, 75, 2212, 1315, 2370, 881, 1969, 2146, 1712, 2626, 658, 1332, 705, 2822, 170, 1542, 676, 1990, 1536, 3193, 234, 445, 2984, 2720, 3246, 1172, 3361, 172, 2676, 391, 3189, 1292, 1369, 284, 2891, 726, 1085, 783, 2213, 2805, 1835, 2618, 2865, 2338, 599, 3104, 1020, 3358, 952, 725, 1793, 1829, 1443, 2168, 3421, 1078, 1569, 491, 486, 2221, 1735, 450, 392, 3399, 909, 377, 2925, 1994, 93, 1556, 822, 3159, 2337, 161, 976, 157, 773, 2150, 467, 1928, 2322, 420, 2257, 1612, 3300, 248, 1510, 2775, 3209, 1792};


void ntt(int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3,t4,t;
	int16_t zeta, zeta1,zeta2;
	int k = 0;

	zeta = zetas[k++];

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t = fqmul(zeta, a[i + NTRUPLUS_N/2]);

		a[i + NTRUPLUS_N/2] = (a[i] + a[i + NTRUPLUS_N/2] - t);
		a[i      ] = (a[i] + t);
	}

	for(int step = NTRUPLUS_N/6; step >= 32; step = step/3)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta1 = zetas[k++]; //alpha
			zeta2 = zetas[k++]; //alpha^2

			for(int i = start; i < start + step; i++)
			{
				t1 = fqmul(zeta1, a[i + step]);
				t2 = fqmul(zeta2, a[i + 2*step]);
				t3 = fqmul(2571, t1); //expon[384] = 722; //w
				t4 = fqmul(1033, t2); //expon[768] = 2734; //w^2

				t1 = t1 + t2;
				t3 = t3 + t4;

				a[i + 2*step] = fqred16(a[i] - (t1 + t3));
				a[i + step] = fqred16(a[i] + t3);
				a[i    ] = fqred16(a[i] + t1);
			}
		}
	}

	for(int step = 16; step >= 2; step >>= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta = zetas[k++];

			for(int i = start; i < start + step; i++)
			{
				t = fqmul(zeta, a[i + step]);
				
				a[i + step] = fqred16(a[i] - t);
				a[i       ] = fqred16(a[i] + t);
			}
		}
	}
}

void invntt(int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3,t4,t;
	int16_t zeta, zeta1,zeta2;
	int k = 0;

	for(int step = 2; step <= 4; step <<= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta = zetas_inv[k++];

			for(int i = start; i < start + step; i++)
			{
				t1 = a[i + step];

				a[i + step] = fqred16(fqmul(zeta, a[i] - t1));
				a[i       ] = fqred16(a[i] + t1);
			}
		}
	}
/*	
	for(int step = 32; step <= NTRUPLUS_N/6; step = 3*step)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta1 = zetas_inv[k++]; //alpha^-1
			zeta2 = zetas_inv[k++]; //alpha^-2

			for(int i = start; i < start + step; i++)
			{
				t1 = fqred16(fqmul(1033, a[i + step]) + fqmul(2571, a[i + 2*step]));
				t2 = fqred16(a[i + step] + a[i + 2*step]);

				a[i + 2*step] = fqred16(fqmul(zeta2, a[i] - (t1 + t2)));
				a[i + step] = fqred16(fqmul(zeta1, a[i] + t1));
				a[i    ] = fqred16(a[i] + t2);
			}
		}
	}

	zeta = zetas_inv[k];//(\psi-\psi^5)^-1

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = fqred16(a[i] + a[i + NTRUPLUS_N/2]);
		t2 = fqmul(zeta, a[i] - a[i + NTRUPLUS_N/2]);

		a[i      ] = fqred16(fqmul((1 << 9)*3073  % 3457, t1 - t2));
		a[i + NTRUPLUS_N/2] = fqred16(fqmul((1 << 10)*3073 % 3457, t2));

		a[i      ] = fqred16(fqmul(3424, t1 - t2));
		a[i + NTRUPLUS_N/2] = fqred16(fqmul(3391, t2));	
	}
	*/
}

/*
(a[0] + a[1]x)(b[0] + b[1]x)

(a[0] + a[1])(b[0] + b[1]) - a[0]b[0] - a[1]b[1]

(a[0]b[0] + a[1]b[1]*zeta) + (a[1]b[0] + a[0]b[1])x
(a[0]b[0] + a[1]b[1]*zeta) + ((a[0] + a[1])(b[0] + b[1]) - a[0]b[0] - a[1]b[1])x

*/
//M^-1
void basemul(int16_t c[2], const int16_t a[2], const int16_t b[2], int16_t zeta)
{
/*
	//School Book
	c[0]  = fqmul(a[1], b[1]);
	c[0]  = fqmul(c[0], zeta);
	c[0] += fqmul(a[0], b[0]);
	//c[0]  = fqred16(c[0]);

	c[1]  = fqmul(a[1], b[0]);
	c[1] += fqmul(a[0], b[1]);
	//c[1]  = fqred16(c[1]);
*/

	//Karatsuba
	int16_t t1 = fqmul(a[0], b[0]);
	int16_t t2 = fqmul(a[1], b[1]);
	int16_t t3 = fqmul((a[0] + a[1]),(b[0] + b[1]));

	c[1] = t3 - t1 - t2;
	c[0] = fqmul(t2, zeta);
	c[0] += t1;
}

int baseinv(int16_t b[2], const int16_t a[2], int16_t zeta)
{
	int16_t det, t;
	int r;

	det = fqmul(a[0], a[0]); //M^-1
	t = fqmul(a[1], a[1]); //M^-1
	t = fqmul(t, zeta); //M^-1
	det = det - t; //M^-1

	det   = fqinv(det); //M^3
	b[0] = fqmul(a[0], det); //M^2
	b[1] = fqmul(NTRUPLUS_Q - a[1], det); //M^2

	r = (uint16_t)det;
	r = (uint32_t)(-r) >> 31;
	return r - 1;
}