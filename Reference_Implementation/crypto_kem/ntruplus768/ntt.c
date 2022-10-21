#include "params.h"
#include "reduce.h"
#include "ntt.h"

int16_t zetas[383] = {
	886, 1520, 1571, 704, 624, 813, 1742, 594, 2255, 2260, 2946, 137, 200, 2500, 16, 775, 2494, 62, 2412, 470, 888, 729, 1039, 1909, 3342, 291, 2065, 2429, 1603, 1024, 2479, 2030, 2585, 2928, 2281, 562, 341, 2534, 3346, 2357, 2482, 3369, 3379, 2, 1416, 415, 3432, 2662, 631, 2702, 1295, 410, 3349, 2107, 1789, 1129, 765, 920, 1444, 2179, 910, 1004, 2147, 2367, 2648, 1987, 3254, 3019, 1026, 2454, 2018, 1374, 1375, 1631, 110, 1770, 1726, 833, 2074, 226, 986, 1954, 632, 427, 1557, 449, 3305, 2449, 1935, 1717, 2229, 2868, 1285, 506, 2177, 79, 620, 836, 741, 3438, 376, 1243, 1966, 1575, 1946, 126, 2783, 3297, 801, 1370, 2000, 878, 2821, 2421, 2853, 2852, 328, 643, 2377, 2845, 2286, 919, 736, 2729, 3126, 1048, 2186, 2722, 3239, 973, 1626, 686, 1408, 1627, 218, 63, 3430, 608, 1248, 1324, 1221, 3120, 27, 2970, 315, 513, 2725, 685, 3040, 904, 3142, 1227, 3163, 2129, 2066, 929, 1772, 1009, 294, 418, 1022, 1455, 1543, 2145, 2565, 2099, 2435, 2631, 3425, 863, 1095, 310, 1063, 2882, 32, 2544, 2678, 188, 1053, 1774, 274, 55, 779, 2350, 1188, 1663, 400, 2416, 1588, 983, 2269, 3236, 2090, 2696, 1728, 2050, 361, 2554, 1367, 2587, 354, 164, 3227, 812, 124, 2843, 3103, 2939, 2784, 2299, 1531, 253, 858, 3155, 673, 2810, 1550, 2371, 2489, 3139, 582, 1705, 1907, 977, 2349, 1143, 2048, 10, 940, 316, 1108, 2188, 1956, 2075, 1776, 493, 275, 368, 1501, 1414, 1379, 2507, 22, 524, 1401, 2039, 2078, 1953, 1709, 1563, 3206, 3017, 1458, 3381, 1748, 406, 31, 3150, 1640, 82, 1671, 517, 3426, 1348, 432, 3187, 774, 1277, 1206, 252, 3025, 3298, 1874, 2581, 1341, 2914, 3215, 1509, 1583, 2878, 1247, 3137, 1514, 3306, 2761, 1451, 2210, 1975, 933, 184, 2968, 2766, 444, 1672, 2524, 2300, 512, 83, 3222, 158, 277, 153, 2945, 3237, 2093, 3419, 437, 2510, 2530, 3262, 1364, 2982, 1734, 2275, 514, 2748, 2248, 2486, 1723, 155, 1130, 1441, 8, 2160, 1138, 2573, 2327, 2456, 1250, 2247, 223, 2778, 1473, 3434, 2207, 1208, 397, 2220, 3160, 2560, 100, 1385, 3060, 94, 2856, 2279, 1660, 1756, 1059, 869, 601, 2193, 443, 2233, 1802, 2793, 2245, 451, 3014, 1985, 3274, 500, 2697, 452, 2514, 1838, 183, 2215, 2135, 854, 3105, 2542, 1783, 2199, 1322, 304, 312, 2001, 559, 1560, 871, 898, 3145
};

int16_t zetas_inv[383] = {
	662, 2898, 2559, 3145, 1760, 2586, 1456, 559, 343, 352, 1258, 1322, 1361, 1674, 2603, 3105, 2071, 760, 1619, 183, 1485, 943, 2957, 2697, 2342, 1655, 3006, 3014, 3417, 1212, 1224, 1802, 887, 1797, 2588, 601, 1272, 2398, 1178, 1660, 1175, 297, 2072, 3060, 2445, 3357, 1237, 3160, 2801, 3234, 23, 2207, 209, 1984, 1210, 223, 3044, 3449, 884, 2327, 2171, 2319, 2016, 8, 262, 2943, 971, 1723, 707, 1209, 1182, 514, 2705, 3020, 195, 1364, 3275, 927, 38, 437, 5, 235, 3304, 2945, 2217, 3180, 3374, 3222, 1094, 489, 1785, 2524, 1791, 3013, 3273, 2968, 1855, 1943, 2006, 2210, 3198, 696, 320, 1514, 1405, 2116, 1948, 1583, 717, 242, 876, 1341, 1025, 2683, 3205, 3025, 1618, 2251, 270, 774, 3022, 1817, 2940, 3426, 713, 1786, 307, 1640, 3093, 251, 76, 1748, 390, 1999, 1894, 3206, 1942, 3435, 1418, 2078, 2364, 2056, 950, 22, 125, 1681, 3089, 1501, 113, 3182, 1382, 1776, 3151, 1409, 3141, 1108, 3291, 2517, 2314, 2048, 1434, 968, 1752, 1907, 439, 2875, 1086, 2489, 555, 1926, 302, 673, 640, 2599, 1158, 1531, 1426, 230, 614, 3103, 2423, 3333, 3293, 3227, 2953, 1729, 903, 1367, 540, 3096, 761, 1728, 1433, 3057, 2474, 2269, 687, 1869, 1794, 400, 1719, 2404, 3402, 779, 2356, 3183, 3269, 1053, 885, 2362, 575, 32, 1768, 2394, 2594, 1095, 46, 1914, 1358, 2435, 2420, 892, 2002, 1543, 3377, 1391, 2448, 294, 2555, 1685, 1328, 2066, 3238, 732, 2553, 3142, 2457, 417, 2944, 2725, 1661, 2209, 337, 27, 2912, 2236, 2849, 1248, 2516, 1831, 1830, 218, 1749, 2049, 2484, 1626, 1271, 2409, 331, 728, 2721, 2538, 1171, 612, 1080, 2814, 3129, 605, 604, 1036, 636, 2579, 1457, 2087, 2656, 160, 674, 3331, 1511, 1882, 1491, 2214, 3081, 19, 2716, 2621, 2837, 3378, 1280, 2951, 2172, 589, 1228, 1740, 1522, 1008, 152, 3008, 1900, 3030, 2825, 1503, 2471, 3231, 1383, 2624, 1731, 1687, 3347, 1826, 2082, 2083, 1439, 1003, 2431, 438, 203, 1470, 809, 1090, 1310, 2453, 2547, 1278, 2013, 2537, 2692, 2328, 1668, 1350, 108, 3047, 2162, 755, 2826, 795, 25, 3042, 2041, 3455, 78, 88, 975, 1100, 111, 923, 3116, 2895, 1176, 529, 872, 1427, 978, 2433, 1854, 1028, 1392, 3166, 115, 1548, 2418, 2728, 2569, 2987, 1045, 3395, 963, 2682, 3441, 957, 3257, 3320, 511, 1197, 1202, 2863, 1715, 2644, 2833, 2753, 1886, 1937, 1665
};

int16_t zetas_mul[384] = {2722, 1708, 2484, 973, 735, 1749, 686, 941, 1830, 1627, 2771, 2516, 63, 545, 2849, 608, 3394, 2912, 1324, 1796, 337, 3120, 2133, 1661, 2970, 1000, 2944, 513, 487, 2457, 685, 219, 2553, 904, 2772, 3238, 1227, 902, 1328, 2129, 2230, 2555, 929, 80, 2448, 1009, 2528, 3377, 418, 1037, 2002, 1455, 3039, 2420, 2145, 3411, 1358, 2099, 1312, 46, 2631, 1689, 2594, 863, 826, 1768, 310, 2572, 575, 2882, 3147, 885, 2544, 1101, 3269, 188, 913, 2356, 1774, 1738, 3402, 55, 1683, 1719, 2350, 2770, 1794, 1663, 1107, 687, 2416, 2024, 2474, 983, 1041, 1433, 3236, 2917, 761, 2696, 221, 540, 2050, 504, 903, 2554, 1407, 2953, 2587, 1034, 3293, 164, 870, 2423, 812, 2031, 614, 2843, 2645, 1426, 2939, 2817, 1158, 2299, 518, 640, 253, 2902, 302, 3155, 3204, 555, 2810, 3018, 1086, 2371, 647, 439, 3139, 2023, 1752, 1705, 318, 1434, 977, 166, 2314, 1143, 2480, 3291, 10, 306, 3141, 316, 3447, 3151, 2188, 3344, 1382, 2075, 1269, 113, 493, 3332, 3089, 368, 2964, 125, 1414, 1093, 950, 2507, 2043, 2364, 524, 1515, 1418, 2039, 2933, 1942, 1953, 3067, 1894, 1563, 1504, 390, 3017, 364, 76, 3381, 440, 3093, 406, 2744, 307, 3150, 3051, 713, 82, 435, 2940, 517, 3375, 3022, 1348, 1839, 270, 3187, 2109, 1618, 1277, 2432, 3205, 252, 2180, 1025, 3298, 2740, 876, 2581, 159, 717, 2914, 2052, 1948, 1509, 543, 1405, 2878, 259, 320, 3137, 579, 3198, 3306, 1602, 2006, 1451, 151, 1855, 1975, 1666, 3273, 184, 1482, 1791, 2766, 2363, 1785, 1672, 691, 1094, 2300, 1240, 3374, 83, 1157, 2217, 158, 3452, 3304, 153, 3299, 5, 3237, 182, 38, 3419, 220, 3275, 2510, 752, 195, 3262, 947, 2705, 2982, 2750, 1182, 2275, 475, 707, 2748, 3195, 971, 2486, 709, 262, 155, 1286, 2016, 1441, 3302, 2171, 2160, 413, 884, 2573, 1297, 3044, 2456, 3248, 1210, 2247, 1001, 209, 2778, 656, 23, 3434, 679, 2801, 1208, 1012, 1237, 2220, 2249, 2445, 2560, 2282, 2072, 1385, 897, 1175, 94, 2185, 1178, 2279, 3363, 1272, 1756, 2570, 2588, 869, 1701, 887, 2193, 40, 1224, 2233, 1264, 3417, 2793, 1115, 3006, 451, 664, 2342, 1985, 1972, 2957, 500, 1472, 1485, 452, 1386, 1619, 1838, 3005, 2071, 2215, 2096, 2603, 854, 1242, 1361, 2542, 3114, 1258, 2199, 915, 343, 304, 1697, 1456, 2001, 3153, 1760, 1560, 2795, 2559, 898, 1897, 662};

void ntt(int16_t a[NTRUPLUS_N])
{
	int16_t t1, t2, t3, t4;
	int16_t zeta1, zeta2;
	int k = 0;

	zeta1 = zetas[k++];

	for(int i = 0; i < 384; i++)
	{
		t1 = fqmul(zeta1, a[i + 384]);

		a[i + 384] = (a[i] + a[i + 384] - t1);
		a[i      ] = (a[i] + t1);
	}

	for(int step = 192; step > 3; step >>= 1)
	{
		for(int start = 0; start < 768; start += (step << 1))
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

	for(int start = 0; start < NTRUPLUS_N; start += 6)
	{
		zeta1 = zetas[k++]; //alpha
		zeta2 = zetas[k++]; //alpha^2

		for(int i = start; i < start + 2; i++)
		{
			t1 = fqmul(zeta1, a[i + 2]);
			t2 = fqmul(zeta2, a[i + 4]);
			t3 = fqmul(1033, t1); //expon[384] = 722; //w
			t4 = fqmul(2571, t2); //expon[768] = 2734; //w^2

			t1 = t1 + t2;
			t3 = t3 + t4;

			a[i + 4] = fqred16(a[i] - (t1 + t3));
			a[i + 2] = fqred16(a[i] + t3);
			a[i    ] = fqred16(a[i] + t1);
		}
	}
}

void invntt(int16_t a[768])
{
	int16_t t1, t2;
	int16_t zeta1;
	int16_t zeta2;

	int k = 0;

	for(int start = 0; start < 768; start += 6)
	{
		zeta1 = zetas_inv[k++]; //alpha^-1
		zeta2 = zetas_inv[k++]; //alpha^-2
	
		for(int i = start; i < start + 2; i++)
		{
			t1 = fqred16(fqmul(2571, a[i + 2]) + fqmul(1033, a[i + 4]));
			t2 = fqred16(a[i + 2] + a[i + 4]);

			a[i + 4] = fqred16(fqmul(zeta2, a[i] - (t1 + t2)));
			a[i + 2] = fqred16(fqmul(zeta1, a[i] + t1));
			a[i    ] = fqred16(a[i] + t2);
		}
	}

	for(int step = 6; step < 384; step <<= 1)
	{
		for(int start = 0; start <768; start += (step << 1))
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

	zeta1 = zetas_inv[k];

	for(int i = 0; i < 384; i++)
	{
		t1 = fqred16(a[i] + a[i + 384]);
		t2 = fqmul(zeta1, a[i] - a[i + 384]);

		a[i      ] = fqred16(fqmul(2568, t1 - t2));
		a[i + 384] = fqred16(fqmul(1679, t2));	
	}
}

void ntt_pack(int16_t b[768], const int16_t a[768])
{
	int16_t buf[96];

	for(int i = 0; i < 768/96; ++i)
	{
		for(int j = 0; j < 96; ++j) 
		{
			buf[j] = a[96*i + j];
		}

		for(int j = 0; j < 6; ++j)
		{
			for(int k = 0; k < 16; ++k)
			{
				b[96*i + 16*j + k] = buf[6*k + j];
			} 
		}	
	}
}

void ntt_unpack(int16_t b[768], const int16_t a[768])
{
	unsigned j, k, l;
	int16_t buf[96];

	for(j = 0; j < 768/96; ++j)
	{
		for(k = 0; k < 6; ++k)
		{
			for(l = 0; l < 16; ++l)
			{
				buf[6*l + k] = a[96*j + 16*k + l];
			} 
		}
			
		for(k = 0; k < 96; ++k)
		{
			b[96*j + k] = buf[k];
		}
	}
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