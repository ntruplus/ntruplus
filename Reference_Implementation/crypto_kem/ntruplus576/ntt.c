#include "params.h"
#include "reduce.h"
#include "ntt.h"

int16_t zetas[575] = {886, 460, 1265, 1947, 2997, 107, 1145, 161, 976, 2730, 1155, 556, 1307, 1612, 3300, 2684, 3296, 3065, 58, 450, 2379, 1888, 2966, 2221, 1735, 2971, 1901, 1994, 93, 2635, 298, 1120, 2925, 2548, 3080, 566, 284, 2372, 726, 1292, 1369, 234, 264, 2984, 3012, 3246, 737, 3285, 781, 3066, 268, 96, 1172, 952, 99, 1119, 2858, 353, 2437, 1664, 725, 2014, 1829, 36, 2168, 2618, 2865, 2213, 2674, 1835, 652, 2491, 2899, 1753, 3396, 2619, 2157, 3353, 1035, 1864, 862, 2558, 404, 2346, 1849, 1669, 642, 2529, 194, 2228, 2425, 2881, 3339, 3171, 1982, 3192, 942, 1873, 1404, 1266, 2492, 1997, 37, 905, 2262, 2670, 619, 881, 1969, 2370, 2142, 70, 2295, 875, 2760, 2666, 3451, 2212, 3382, 2799, 2626, 2146, 1712, 3287, 2822, 1332, 705, 1921, 1990, 1542, 676, 1598, 2512, 2690, 287, 3376, 2036, 716, 1251, 1261, 2575, 206, 2803, 3124, 688, 1023, 1686, 3386, 1870, 841, 2633, 1230, 324, 1547, 593, 1072, 1564, 3029, 2265, 1343, 3288, 1231, 3073, 1148, 3068, 522, 323, 917, 680, 2820, 1586, 372, 2813, 1193, 2321, 2904, 883, 1730, 2395, 3391, 1787, 2632, 3324, 1046, 2687, 2704, 746, 2019, 1746, 2767, 1083, 3278, 2280, 2948, 844, 1654, 891, 3390, 2495, 3433, 3164, 3157, 1523, 2829, 2128, 2521, 2401, 1677, 1892, 1949, 2908, 669, 3414, 3177, 1191, 365, 855, 2834, 2045, 3213, 3359, 407, 2232, 3448, 2915, 1616, 139, 1493, 798, 3106, 3061, 1061, 2438, 1163, 2819, 683, 416, 3352, 1743, 3054, 1850, 148, 2383, 402, 2315, 1568, 3010, 1800, 1233, 1758, 3313, 2159, 2879, 1060, 3146, 2134, 3294, 2476, 3148, 1680, 3225, 258, 557, 1089, 3356, 1513, 466, 2568, 238, 987, 2975, 2985, 2304, 1014, 1144, 325, 1519, 2334, 3431, 1868, 1487, 2608, 3031, 2786, 1459, 255, 2681, 3168, 649, 1573, 2927, 3385, 2578, 2557, 1112, 1698, 852, 483, 279, 2947, 1552, 539, 2115, 1429, 1169, 2306, 2513, 2246, 52, 419, 650, 2920, 3383, 1930, 2532, 1505, 2673, 3256, 571, 3341, 2617, 2007, 3328, 1574, 2219, 2390, 1810, 1483, 964, 2981, 1679, 202, 2178, 2525, 3026, 3398, 288, 991, 143, 1337, 622, 1156, 861, 2751, 2040, 1546, 1301, 1116, 1525, 122, 49, 208, 1387, 2600, 1781, 3138, 1147, 1198, 2238, 321, 894, 2284, 804, 3214, 2651, 2148, 296, 1962, 618, 326, 811, 2941, 2343, 464, 3360, 1798, 2649, 1733, 271, 3259, 1904, 982, 3058, 2488, 1566, 3444, 2290, 572, 2950, 236, 2305, 2643, 2450, 196, 2969, 1747, 730, 2824, 2211, 1131, 1276, 2038, 2122, 210, 3428, 2625, 1366, 233, 972, 1184, 1779, 3216, 1235, 2173, 3338, 2458, 2064, 3069, 1601, 3244, 2153, 2523, 985, 702, 792, 1861, 2986, 1084, 3439, 3179, 3232, 1064, 314, 2929, 468, 2490, 150, 12, 1875, 1775, 1648, 3174, 3315, 2081, 2791, 85, 2046, 995, 768, 338, 2686, 2413, 2811, 778, 2296, 422, 1983, 1818, 2317, 2976, 1762, 2630, 1283, 1707, 1394, 2324, 140, 1454, 754, 890, 2511, 856, 2384, 329, 2144, 2809, 2460, 2271, 3094, 600, 411, 586, 3409, 1872, 2112, 2658, 2201, 793, 2047, 1270, 3117, 2889, 1132, 3271, 322, 873, 719, 2270, 345, 373, 2105, 2934, 385, 134, 1924, 1675, 3308, 2354, 3099, 1769, 2439, 3016, 1098, 3130, 3354, 560, 1075, 86, 1338, 2926, 2592, 2005, 1287, 1662, 2141, 33, 835, 1534, 2883, 1890, 3196, 3265, 1113, 1057, 1813, 1071, 2272, 1288, 744, 2097, 1834, 285, 2183, 1506, 1965, 1540, 2092, 1380, 1291, 3422, 581, 2025, 955, 2842, 3295, 2861, 214, 2921, 2675, 843, 1217, 1895, 3113, 3045, 1308, 1764, 2522, 1650, 266, 3340, 3325, 1691, 2351, 2124, 3};

int16_t zetas_inv[575] = {3454, 1333, 1106, 1766, 132, 117, 3191, 1807, 935, 1693, 2149, 412, 344, 1562, 2240, 2614, 782, 536, 3243, 596, 162, 615, 2502, 1432, 2876, 35, 2166, 2077, 1365, 1917, 1492, 1951, 1274, 3172, 1623, 1360, 2713, 2169, 1185, 2386, 1644, 2400, 2344, 192, 261, 1567, 574, 1923, 2622, 3424, 1316, 1795, 2170, 1452, 865, 531, 2119, 3371, 2382, 2897, 103, 327, 2359, 441, 1018, 1688, 358, 1103, 149, 1782, 1533, 3323, 3072, 523, 1352, 3084, 3112, 1187, 2738, 2584, 3135, 186, 2325, 568, 340, 2187, 1410, 2664, 1256, 799, 1345, 1585, 48, 2871, 3046, 2857, 363, 1186, 997, 648, 1313, 3128, 1073, 2601, 946, 2567, 2703, 2003, 3317, 1133, 2063, 1750, 2174, 827, 1695, 481, 1140, 1639, 1474, 3035, 1161, 2679, 646, 1044, 771, 3119, 2689, 2462, 1411, 3372, 666, 1376, 142, 283, 1809, 1682, 1582, 3445, 3307, 967, 2989, 528, 3143, 2393, 225, 278, 18, 2373, 471, 1596, 2665, 2755, 2472, 934, 1304, 213, 1856, 388, 1393, 999, 119, 1284, 2222, 241, 1678, 2273, 2485, 3224, 2091, 832, 29, 3247, 1335, 1419, 2181, 2326, 1246, 633, 2727, 1710, 488, 3261, 1007, 814, 1152, 3221, 507, 2885, 1167, 13, 1891, 969, 399, 2475, 1553, 198, 3186, 1724, 808, 1659, 97, 2993, 1114, 516, 2646, 3131, 2839, 1495, 3161, 1309, 806, 243, 2653, 1173, 2563, 3136, 1219, 2259, 2310, 319, 1676, 857, 2070, 3249, 3408, 3335, 1932, 2341, 2156, 1911, 1417, 706, 2596, 2301, 2835, 2120, 3314, 2466, 3169, 59, 431, 932, 1279, 3255, 1778, 476, 2493, 1974, 1647, 1067, 1238, 1883, 129, 1450, 840, 116, 2886, 201, 784, 1952, 925, 1527, 74, 537, 2807, 3038, 3405, 1211, 944, 1151, 2288, 2028, 1342, 2918, 1905, 510, 3178, 2974, 2605, 1759, 2345, 900, 879, 72, 530, 1884, 2808, 289, 776, 3202, 1998, 671, 426, 849, 1970, 1589, 26, 1123, 1938, 3132, 2313, 2443, 1153, 472, 482, 2470, 3219, 889, 2991, 1944, 101, 2368, 2900, 3199, 232, 1777, 309, 981, 163, 1323, 311, 2397, 578, 1298, 144, 1699, 2224, 1657, 447, 1889, 1142, 3055, 1074, 3309, 1607, 403, 1714, 105, 3041, 2774, 638, 2294, 1019, 2396, 396, 351, 2659, 1964, 3318, 1841, 542, 9, 1225, 3050, 98, 244, 1412, 623, 2602, 3092, 2266, 280, 43, 2788, 549, 1508, 1565, 1780, 1056, 936, 1329, 628, 1934, 300, 293, 24, 962, 67, 2566, 1803, 2613, 509, 1177, 179, 2374, 690, 1711, 1438, 2711, 753, 770, 2411, 133, 825, 1670, 66, 1062, 1727, 2574, 553, 1136, 2264, 644, 3085, 1871, 637, 2777, 2540, 3134, 2935, 389, 2309, 384, 2226, 169, 2114, 1192, 428, 1893, 2385, 2864, 1910, 3133, 2227, 824, 2616, 1587, 71, 1771, 2434, 2769, 333, 654, 3251, 882, 2196, 2206, 2741, 1421, 81, 3170, 767, 945, 1859, 2781, 1915, 1467, 1536, 2752, 2125, 635, 170, 1745, 1311, 831, 658, 75, 1245, 6, 791, 697, 2582, 1162, 3387, 1315, 1087, 1488, 2576, 2838, 787, 1195, 2552, 3420, 1460, 965, 2191, 2053, 1584, 2515, 265, 1475, 286, 118, 576, 1032, 1229, 3263, 928, 2815, 1788, 1608, 1111, 3053, 899, 2595, 1593, 2422, 104, 1300, 838, 61, 1704, 558, 966, 2805, 1622, 783, 1244, 592, 839, 1289, 3421, 1628, 1443, 2732, 1793, 1020, 3104, 599, 2338, 3358, 2505, 2285, 3361, 3189, 391, 2676, 172, 2720, 211, 445, 473, 3193, 3223, 2088, 2165, 2731, 1085, 3173, 2891, 377, 909, 532, 2337, 3159, 822, 3364, 1463, 1556, 486, 1722, 1236, 491, 1569, 1078, 3007, 3399, 392, 2302, 1296, 2990, 727, 2481, 3350, 157, 773, 1135, 2901, 2150, 467, 2775, 3209, 2749, 682, 1665};

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
				t3 = fqmul(1033, t1); //expon[384] = 722; //w
				t4 = fqmul(2571, t2); //expon[768] = 2734; //w^2

				t1 = t1 + t2;
				t3 = t3 + t4;

				a[i + 2*step] = fqred16(a[i] - (t1 + t3));
				a[i + step] = fqred16(a[i] + t3);
				a[i    ] = fqred16(a[i] + t1);
			}
		}
	}

	for(int step = 16; step >= 1; step >>= 1)
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

	for(int step = 1; step <= 16; step <<= 1)
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
	
	for(int step = 32; step <= NTRUPLUS_N/6; step = 3*step)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta1 = zetas_inv[k++]; //alpha^-1
			zeta2 = zetas_inv[k++]; //alpha^-2

			for(int i = start; i < start + step; i++)
			{
				t1 = fqred16(fqmul(2571, a[i + step]) + fqmul(1033, a[i + 2*step]));
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

//		a[i      ] = fqred16(fqmul((1 << 9)*3073  % 3457, t1 - t2));
//		a[i + 576] = fqred16(fqmul((1 << 10)*3073 % 3457, t2));

		a[i      ] = fqred16(fqmul(1712, t1 - t2));
		a[i + NTRUPLUS_N/2] = fqred16(fqmul(3424, t2));	
	}
}
