#include "params.h"
#include "reduce.h"
#include "ntt.h"

int16_t zetas[383] = {886, 460, 1265, 1947, 2997, 867, 1124, 257, 723, 722, 3456, 395, 3100, 1936, 1716, 2111, 1164, 222, 1611, 1867, 1262, 1484, 3201, 2352, 2399, 603, 1713, 2564, 387, 3109, 2520, 3336, 757, 820, 3241, 3413, 3418, 1241, 550, 3362, 1880, 2758, 2916, 502, 2802, 455, 639, 1464, 2869, 3021, 2442, 1267, 1673, 1899, 3176, 1351, 2376, 2044, 2126, 2782, 2623, 3403, 3252, 961, 2816, 630, 87, 2657, 548, 3393, 3086, 1428, 1580, 2465, 2892, 2851, 3077, 2164, 661, 156, 3281, 1257, 1507, 50, 830, 4, 2832, 569, 1840, 2258, 1530, 2620, 2008, 901, 1820, 3239, 1221, 3163, 2725, 2678, 1588, 2565, 1095, 2349, 275, 1709, 22, 354, 1728, 858, 2489, 2090, 124, 1550, 1531, 1379, 1458, 940, 1776, 315, 1772, 1408, 1248, 3425, 1543, 274, 400, 1022, 1063, 1188, 1053, 3430, 1626, 3040, 2066, 2784, 582, 361, 3227, 1956, 2048, 1401, 3206, 31, 1206, 1247, 1341, 2093, 2248, 444, 3222, 443, 2514, 312, 3105, 1250, 8, 100, 1660, 1130, 1473, 2856, 3160, 2135, 871, 2245, 2697, 1874, 2761, 1671, 774, 512, 2968, 2530, 514, 933, 277, 1734, 437, 432, 1640, 3215, 1514, 397, 1059, 1138, 223, 3274, 1802, 1783, 559, 2722, 1627, 1324, 545, 1227, 1009, 513, 219, 2544, 55, 2416, 2770, 2145, 1037, 863, 2572, 977, 316, 493, 3344, 1953, 3381, 2507, 1515, 2587, 2843, 2696, 504, 253, 2817, 2371, 2023, 3236, 2554, 812, 1034, 2810, 1705, 2299, 2902, 1414, 2039, 3017, 3067, 10, 166, 2075, 3332, 2970, 904, 929, 902, 686, 1708, 608, 1796, 2631, 2882, 1455, 3411, 1774, 1101, 1663, 2024, 418, 2099, 310, 1689, 2350, 983, 188, 1738, 63, 3120, 973, 941, 685, 1000, 2129, 80, 2939, 3155, 3139, 3018, 2050, 2917, 164, 2031, 2188, 368, 1143, 306, 524, 1093, 1563, 364, 406, 517, 1277, 1839, 2878, 1451, 2581, 2052, 3237, 3262, 2748, 2750, 2766, 1666, 83, 3452, 2193, 451, 452, 1972, 304, 898, 854, 3114, 2456, 3434, 1441, 413, 2560, 1012, 2279, 2570, 155, 2573, 2778, 3248, 94, 869, 2220, 2282, 2215, 2199, 1560, 1697, 2793, 40, 500, 1386, 3298, 1509, 3306, 259, 82, 2744, 3187, 2432, 2300, 153, 184, 2363, 2510, 182, 2275, 3195, 1975, 1672, 158, 1240, 2982, 2486, 3419, 752, 1348, 252, 3150, 435, 2914, 2740, 3137, 1602, 1208, 1385, 1756, 2185, 2160, 1286, 2247, 656, 1985, 1838, 2233, 1115, 2542, 2096, 2001, 2795};

int16_t zetas_inv[383] = {662, 1456, 1361, 915, 2342, 1224, 1619, 1472, 2801, 1210, 2171, 1297, 1272, 1701, 2072, 2249, 1855, 320, 717, 543, 3022, 307, 3205, 2109, 2705, 38, 971, 475, 2217, 3299, 1785, 1482, 262, 1182, 3275, 947, 1094, 3273, 3304, 1157, 1025, 270, 713, 3375, 3198, 151, 1948, 159, 2071, 2957, 3417, 664, 1760, 1897, 1258, 1242, 1175, 1237, 2588, 3363, 209, 679, 884, 3302, 887, 1178, 2445, 897, 3044, 2016, 23, 1001, 343, 2603, 2559, 3153, 1485, 3005, 3006, 1264, 5, 3374, 1791, 691, 707, 709, 195, 220, 1405, 876, 2006, 579, 1618, 2180, 2940, 3051, 3093, 1894, 2364, 2933, 3151, 2314, 3089, 1269, 1426, 3293, 540, 1407, 439, 318, 302, 518, 3377, 1328, 2457, 2772, 2516, 2484, 337, 3394, 1719, 3269, 2474, 1107, 1768, 3147, 1358, 3039, 1433, 1794, 2356, 1683, 46, 2002, 575, 826, 1661, 2849, 1749, 2771, 2555, 2528, 2553, 487, 125, 1382, 3291, 3447, 390, 440, 1418, 2043, 555, 1158, 1752, 647, 2423, 2645, 903, 221, 1434, 1086, 640, 3204, 2953, 761, 614, 870, 1942, 950, 76, 1504, 113, 2964, 3141, 2480, 885, 2594, 2420, 1312, 687, 1041, 3402, 913, 3238, 2944, 2448, 2230, 2912, 2133, 1830, 735, 2898, 1674, 1655, 183, 3234, 2319, 2398, 3060, 1943, 242, 1817, 3025, 3020, 1723, 3180, 2524, 2943, 927, 489, 2945, 2683, 1786, 696, 1583, 760, 1212, 2586, 1322, 297, 601, 1984, 2327, 1797, 3357, 3449, 2207, 352, 3145, 943, 3014, 235, 3013, 1209, 1364, 2116, 2210, 2251, 3426, 251, 2056, 1409, 1501, 230, 3096, 2875, 673, 1391, 417, 1831, 27, 2404, 2269, 2394, 2435, 3057, 3183, 1914, 32, 2209, 2049, 1685, 3142, 1681, 2517, 1999, 2078, 1926, 1907, 3333, 1367, 968, 2599, 1729, 3103, 3435, 1748, 3182, 1108, 2362, 892, 1869, 779, 732, 294, 2236, 218, 1637, 2556, 1449, 837, 1927, 1199, 1617, 2888, 625, 3453, 2627, 3407, 1950, 2200, 176, 3301, 2796, 1293, 380, 606, 565, 992, 1877, 2029, 371, 64, 2909, 800, 3370, 2827, 641, 2496, 205, 54, 834, 675, 1331, 1413, 1081, 2106, 281, 1558, 1784, 2190, 1015, 436, 588, 1993, 2818, 3002, 655, 2955, 541, 699, 1577, 95, 2907, 2216, 39, 44, 216, 2637, 2700, 121, 937, 348, 3070, 893, 1744, 2854, 1058, 1105, 256, 1973, 2195, 1590, 1846, 3235, 2293, 1346, 1741, 1521, 357, 3062, 1, 2735, 2734, 3200, 2333, 2590, 2775, 3209, 2749, 682, 1665};

void ntt(int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3,t4;
	int16_t zeta1,zeta2;
	int k = 0;

	zeta1 = zetas[k++];

	for(int i = 0; i < 384; i++)
	{
		t1 = fqmul(zeta1, a[i + 384]);

		a[i + 384] = (a[i] + a[i + 384] - t1);
		a[i      ] = (a[i] + t1);
	}

	for(int start = 0; start < NTRUPLUS_N; start += 384)
	{
		zeta1 = zetas[k++];
		zeta2 = zetas[k++];

		for(int i = start; i < start + 128; i++)
		{
			t1 = fqmul(zeta1, a[i + 128]);
			t2 = fqmul(zeta2, a[i + 256]);
			t3 = fqmul(1033, t1);
			t4 = fqmul(2571, t2);

			t1 = t1 + t2;
			t3 = t3 + t4;

			a[i + 256] = fqred16(a[i] - (t1 + t3));
			a[i + 128] = fqred16(a[i] + t3);
			a[i    ] = fqred16(a[i] + t1);
		}
	}

	for(int step = 64; step >= 2; step >>= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k++];

			for(int i = start; i < start + step; i++)
			{
				t1 = fqmul(zeta1, a[i + step]);
				
				a[i + step] = fqred16(a[i] - t1);
				a[i       ] = fqred16(a[i] + t1);
			}
		}
	}
}


void invntt(int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3,t4,t;
	int16_t zeta1,zeta2;
	int k = 0;

//	for(int step = 2; step <= 64; step <<= 1)
	for(int step = 2; step <= 2; step <<= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas_inv[k++];

			for(int i = start; i < start + step; i++)
			{
				t1 = a[i + step];

				a[i + step] = fqred16(fqmul(zeta1, a[i] - t1));
				a[i       ] = fqred16(a[i] + t1);
			}
		}
	}
/*
	for(int start = 0; start < NTRUPLUS_N; start += 384)
	{
		zeta1 = zetas_inv[k++];
		zeta2 = zetas_inv[k++];

		for(int i = start; i < start + 128; i++)
		{
			t1 = fqred16(fqmul(2571, a[i + 128]) + fqmul(1033, a[i + 256]));
			t2 = fqred16(a[i + 128] + a[i + 256]);

			a[i + 256] = fqred16(fqmul(zeta2, a[i] - (t1 + t2)));
			a[i + 128] = fqred16(fqmul(zeta1, a[i] + t1));
			a[i    ] = fqred16(a[i] + t2);
		}
	}

	zeta1 = zetas_inv[k];

	for(int i = 0; i < 384; i++)
	{
		t1 = fqred16(a[i] + a[i + 384]);
		t2 = fqmul(zeta1, a[i] - a[i + 384]);

		//(1 << 9) * 2305  

		a[i      ] = fqred16(fqmul(2568, t1 - t2));
		a[i + 384] = fqred16(fqmul(1679, t2));	
	}
	*/
}

void basemul(int16_t c[2], const int16_t a[2], const int16_t b[2], int16_t zeta)
{
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

	det = fqmul(a[0], a[0]);
	t = fqmul(a[1], a[1]);
	t = fqmul(t, zeta);
	det = det - t;

	det   = fqinv(det);
	b[0] = fqmul(a[0], det);
	b[1] = fqmul(NTRUPLUS_Q - a[1], det);

	r = (uint16_t)det;
	r = (uint32_t)(-r) >> 31;
	return r - 1;
}