#include "params.h"
#include "reduce.h"
#include "ntt.h"

int16_t zetas[191] = {2424, 2192, 708, 460, 1265, 722, 723, 1, 2590, 257, 1124, 1590, 1262, 3235, 1611, 3201, 1484, 3100, 395, 2111, 2293, 1936, 1741, 1577, 95, 699, 2916, 39, 44, 2216, 550, 3002, 639, 2955, 2802, 603, 1744, 2352, 1058, 3336, 2700, 216, 2637, 2564, 3070, 937, 348, 1507, 1257, 3281, 156, 2627, 3407, 3453, 2832, 565, 992, 1877, 2029, 3077, 2851, 2164, 2796, 2008, 2620, 901, 1637, 1617, 2888, 1199, 1530, 1267, 1784, 281, 1558, 1993, 2869, 2442, 3021, 2496, 2816, 87, 630, 371, 64, 2909, 800, 1351, 1081, 1331, 1413, 3252, 3403, 2623, 2782, 2245, 760, 2135, 2586, 601, 3160, 2327, 1473, 2683, 1786, 696, 1583, 2968, 512, 2530, 2943, 3222, 444, 2248, 2093, 2116, 2210, 2251, 3426, 312, 352, 443, 943, 2207, 8, 1660, 100, 2319, 223, 3060, 1059, 3274, 1655, 2898, 1674, 437, 1734, 277, 933, 1817, 3025, 242, 1514, 2349, 3182, 3435, 1748, 2489, 858, 1728, 354, 2236, 218, 294, 2725, 2565, 2362, 2678, 1869, 1063, 1022, 1188, 2404, 417, 2066, 27, 1626, 251, 2056, 1409, 1501, 3227, 361, 582, 2784, 1367, 124, 1531, 1550, 1681, 2517, 1999, 2078, 274, 3057, 3425, 1914, 2049, 1248, 3142, 1772};

void ntt(int16_t b[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3;
	int16_t zeta1, zeta2;
	int k = 0;

	zeta1 = zetas[k++];

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = fqmul(zeta1, a[i + NTRUPLUS_N/2]);

		b[i + NTRUPLUS_N/2] = (a[i] + a[i + NTRUPLUS_N/2] - t1);
		b[i      ] = (a[i] + t1);
	}

	for(int start = 0; start < NTRUPLUS_N; start += 288)
	{
		zeta1 = zetas[k++];
		zeta2 = zetas[k++];

		for(int i = start; i < start + 96; i++)
		{
			t1 = fqmul(zeta1, b[i + 96]);
			t2 = fqmul(zeta2, b[i + 192]);
			t3 = fqmul(2571, t1 - t2);

			b[i + 192] = fqred16(b[i] - t1 - t3);
			b[i +  96] = fqred16(b[i] - t2 + t3);
			b[i      ] = fqred16(b[i] + t1 + t2);
		}		
	}

	for(int step = 48; step >= 3; step >>= 1)
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
	int16_t t1,t2,t3;
	int16_t zeta1,zeta2;
	int k = 190;

	for(int i = 0; i < NTRUPLUS_N; i++)
	{
		r[i] = a[i];
	}

	for(int step = 3; step <= 48; step <<= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k--];

			for(int i = start; i < start + step; i++)
			{
				t1 = r[i + step];

				r[i + step] = fqred16(fqmul(zeta1,  t1 - r[i]));
				r[i       ] = fqred16(r[i] + t1);
			}
		}
	}

	for(int start = 0; start < NTRUPLUS_N; start += 288)
	{
		zeta2 = zetas[k--];
		zeta1 = zetas[k--];

		for(int i = start; i < start + 96; i++)
		{
			t1 = fqmul(2571,  r[i +  96] - r[i]);
			t2 = fqmul(zeta1, r[i + 192] - r[i]      + t1);
			t3 = fqmul(zeta2, r[i + 192] - r[i + 96] - t1);
			r[i      ] = fqred16(r[i] + r[i + 96] + r[i + 192]);
			r[i + 96] = t2;			
			r[i + 192] = t3;
		}
	}

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = fqred16(r[i] + r[i + NTRUPLUS_N/2]);
		t2 = fqmul(1792, r[i] - r[i + NTRUPLUS_N/2]);

		r[i               ] = fqred16(fqmul(1679, t1 - t2));
		r[i + NTRUPLUS_N/2] = fqred16(fqmul(3358, t2));			
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