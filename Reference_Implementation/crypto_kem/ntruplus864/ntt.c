#include "params.h"
#include "reduce.h"
#include "ntt.h"

int16_t zetas[287] = {2424, 2192, 708, 460, 1265, 2990, 727, 556, 1307, 2684, 3296, 1200, 1845, 570, 1529, 1135, 2901, 1120, 298, 2635, 1901, 3364, 1463, 532, 3080, 2548, 58, 3065, 3007, 1722, 1236, 2971, 2966, 1888, 2379, 36, 1289, 2014, 1628, 1664, 2732, 2505, 99, 2437, 353, 2858, 1119, 592, 839, 1622, 652, 1244, 2674, 2372, 2731, 566, 3173, 2088, 2165, 268, 3066, 781, 3285, 96, 2285, 211, 737, 473, 3012, 3223, 264, 1921, 1467, 2781, 1915, 3287, 635, 2752, 2125, 2799, 831, 1745, 1311, 1488, 2576, 1087, 2142, 1245, 3382, 791, 3451, 2582, 2760, 3387, 2295, 287, 2690, 2512, 1598, 2575, 1261, 206, 654, 2036, 3376, 716, 2206, 838, 2157, 1035, 3353, 966, 2899, 3396, 1753, 404, 2558, 862, 1864, 1997, 3420, 1266, 965, 1873, 2053, 3192, 2515, 905, 1195, 2838, 787, 118, 576, 286, 1982, 3263, 928, 1229, 2425, 1608, 1111, 1788, 642, 2134, 163, 309, 981, 2900, 3199, 232, 1777, 1800, 2224, 144, 1699, 311, 2397, 578, 1298, 3054, 1607, 1074, 3309, 447, 1889, 1142, 3055, 2045, 2834, 855, 365, 3359, 3213, 407, 1225, 416, 683, 3352, 1714, 2438, 1061, 1163, 638, 798, 1493, 3106, 396, 2915, 3448, 1616, 3318, 2470, 2975, 889, 238, 1944, 466, 2368, 3356, 849, 3031, 1589, 1487, 671, 1459, 2681, 255, 2443, 1144, 472, 2304, 3132, 1519, 3431, 2334, 324, 1230, 1547, 2864, 3029, 1192, 1072, 1893, 688, 3124, 1023, 1771, 841, 824, 3386, 1587, 522, 3134, 1148, 389, 1231, 384, 1343, 169, 628, 2128, 2401, 2521, 24, 3164, 1523, 3157, 1803, 891, 2495, 3390, 179, 2280, 844, 2948, 1780, 1892, 2908, 1949, 1191, 3177, 3414, 669, 2711, 753, 770, 2411, 1711, 1438, 690, 1083, 1062, 1727, 2574, 553, 1670, 66, 825, 3324, 1871, 637, 2777, 2540, 644, 3085, 2264, 2321};

void ntt(int16_t b[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3,t4;
	int16_t zeta1,zeta2;
	int k = 0;

	zeta1 = zetas[k++];

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = fqmul(zeta1, a[i + NTRUPLUS_N/2]);

		b[i + NTRUPLUS_N/2] = (a[i] + a[i + NTRUPLUS_N/2] - t1);
		b[i      ] = (a[i] + t1);
	}

	for(int step = NTRUPLUS_N/6; step >= 48; step = step/3)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta1 = zetas[k++];
			zeta2 = zetas[k++];

			for(int i = start; i < start + step; i++)
			{
				t1 = fqmul(zeta1, b[i +   step]);
				t2 = fqmul(zeta2, b[i + 2*step]);
				t3 = fqmul(2571, t1 - t2);
	
				b[i + 2*step] = fqred16(b[i] - t1 - t3);
				b[i +   step] = fqred16(b[i] - t2 + t3);
				b[i         ] = fqred16(b[i] + t1 + t2);
			}
		}
	}

	for(int step = 24; step >= 3; step >>= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k++];

			for(int i = start; i < start + step; i++)
			{
				t1 = fqmul(zeta1, b[i + step]);
				
				b[i + step] = fqred16(b[i] - t1);
				b[i       ] = fqred16(b[i] + t1);
			}
		}
	}
}

void invntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3,t4;
	int16_t zeta1,zeta2;
	int k = 286;

	for(int i = 0; i < NTRUPLUS_N; i++)
	{
		r[i] = a[i];
	}

	for(int step = 3; step <= 24; step <<= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k--];

			for(int i = start; i < start + step; i++)
			{
				t1 = r[i + step];

				r[i + step] = fqred16(fqmul(zeta1, t1 - r[i]));
				r[i       ] = fqred16(r[i] + t1);
			}
		}
	}

	for(int step = 48; step <= NTRUPLUS_N/6; step = 3*step)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta2 = zetas[k--];
			zeta1 = zetas[k--];

			for(int i = start; i < start + step; i++)
			{
				t1 = fqmul(2571, r[i + step] - r[i]);
				t2 = fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
				t3 = fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
				r[i         ] = fqred16(r[i] + r[i + step] + r[i + 2*step]);
				r[i +   step] = t2;			
				r[i + 2*step] = t3;
			}			
		}
	}
	
	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = fqred16(r[i] + r[i + NTRUPLUS_N/2]);
		t2 = fqmul(1792, r[i] - r[i + NTRUPLUS_N/2]);

		r[i               ] = fqred16(fqmul(3424, t1 - t2));
		r[i + NTRUPLUS_N/2] = fqred16(fqmul(3391, t2));	
	}
}

void basemul(int16_t c[3], const int16_t a[3], const int16_t b[3], int16_t zeta)
{
	c[0]  = fqmul(a[2], b[1]);
	c[0] += fqmul(a[1], b[2]);
	c[0]  = fqmul(c[0], zeta);
	c[0] += fqmul(a[0], b[0]);

	c[1]  = fqmul(a[2], b[2]);
	c[1]  = fqmul(c[1], zeta);
	c[1] += fqmul(a[0], b[1]);
	c[1] += fqmul(a[1], b[0]);
	c[1]  = fqred16(c[1]);

	c[2]  = fqmul(a[2], b[0]);
	c[2] += fqmul(a[1], b[1]);
	c[2] += fqmul(a[0], b[2]);
	c[2]  = fqred16(c[2]);
}

int baseinv(int16_t b[3], const int16_t a[3], int16_t zeta)
{
	int16_t det, t;
	int r;

	b[0]  = fqmul(a[0], a[0]);
	t     = fqmul(a[1], a[2]);
	t     = fqmul(t, zeta);
	b[0] -= t;

	b[1]  = fqmul(a[2], a[2]);
	b[1]  = fqmul(b[1], zeta);
	t     = fqmul(a[0], a[1]);
	b[1] -= t;

	b[2]  = fqmul(a[1], a[1]);
	t     = fqmul(a[0], a[2]);
	b[2] -= t;

	det   = fqmul(b[2], a[1]);
	t     = fqmul(b[1], a[2]);
	det  += t;
	det   = fqmul(det, zeta); 
	t     = fqmul(b[0], a[0]);
	det  += t;

	det   = fqinv(det);
	b[0]  = fqmul(b[0], det);
	b[1]  = fqmul(b[1], det);
	b[2]  = fqmul(b[2], det);

	r = (uint16_t)det;
	r = (uint32_t)(-r) >> 31;

	return r - 1;
}
