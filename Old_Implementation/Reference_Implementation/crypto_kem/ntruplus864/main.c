#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "api.h"
#include "rng.h"

#include "poly.h"
#include "ntt.h"

#define TEST_LOOP 10000
int64_t cpucycles(void)
{
	unsigned int hi, lo;

    __asm__ __volatile__ ("rdtsc\n\t" : "=a" (lo), "=d"(hi));

    return ((int64_t)lo) | (((int64_t)hi) << 32);
}

void TEST_CCA_KEM()
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES];
	unsigned char sk[CRYPTO_SECRETKEYBYTES];
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
	unsigned char ss[CRYPTO_BYTES];
	unsigned char dss[CRYPTO_BYTES];

	int cnt = 0;

	printf("============ CCA_KEM ENCAP DECAP TEST ============\n");

	//Generate public and secret key
	crypto_kem_keypair(pk, sk);

	//Encrypt and Decrypt message
	for(int j = 0; j < TEST_LOOP; j++)
	{
		crypto_kem_enc(ct, ss, pk);
		crypto_kem_dec(dss, ct, sk);

		if(memcmp(ss, dss, 32) != 0)
		{
			printf("ss[%d]  : ", j);
			for(int i=0; i<32; i++) printf("%02X", ss[i]);
			printf("\n");
		
			printf("dss[%d] : ", j);
			for(int i=0; i<32; i++) printf("%02X", dss[i]);
			printf("\n");
		
			cnt++;
		}
	}
	printf("count: %d\n", cnt);
	printf("==================================================\n\n");

}

void TEST_CCA_KEM_CLOCK()
{
	unsigned char pk[CRYPTO_PUBLICKEYBYTES];
	unsigned char sk[CRYPTO_SECRETKEYBYTES];
	unsigned char ct[CRYPTO_CIPHERTEXTBYTES];
	unsigned char ss[CRYPTO_BYTES];
	unsigned char dss[CRYPTO_BYTES];

    unsigned long long kcycles, ecycles, dcycles;
    unsigned long long cycles1, cycles2;

	printf("========= CCA KEM ENCAP DECAP SPEED TEST =========\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		crypto_kem_keypair(pk, sk);
        cycles2 = cpucycles();
        kcycles += cycles2-cycles1;
	}
    printf("  KEYGEN runs in ................. %8lld cycles", kcycles/TEST_LOOP);
    printf("\n"); 

	ecycles=0;
	dcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
		crypto_kem_enc(ct, ss, pk);
        cycles2 = cpucycles();
        ecycles += cycles2-cycles1;

		cycles1 = cpucycles(); 
		crypto_kem_dec(dss, ct, sk);
		cycles2 = cpucycles();
        dcycles += cycles2-cycles1;
	}

    printf("  ENCAP  runs in ................. %8lld cycles", ecycles/TEST_LOOP);
    printf("\n"); 

    printf("  DECAP  runs in ................. %8lld cycles", dcycles/TEST_LOOP);
    printf("\n"); 

	printf("==================================================\n");
}

void test_ntt_clock()
{
    int16_t a[NTRUPLUS_N] = {0};
    int16_t b[NTRUPLUS_N] = {0};
    int16_t c[NTRUPLUS_N] = {0};

    unsigned long long kcycles, ecycles, dcycles;
    unsigned long long cycles1, cycles2;

	printf("========= CCA KEM ENCAP DECAP SPEED TEST =========\n");

	kcycles=0;
	for (int i = 0; i < TEST_LOOP; i++)
	{
		cycles1 = cpucycles();
   		ntt(a);
        cycles2 = cpucycles();
        kcycles += cycles2-cycles1;
	}
    printf("  KEYGEN runs in ................. %8lld cycles", kcycles/TEST_LOOP);
    printf("\n"); 

	printf("==================================================\n");
}


int test_ntt()
{
	poly a,b,c,d;
	uint8_t buf[1000] = {0};

	for (int i = 0; i < NTRUPLUS_N; i++)
	{
		//buf[i] = i;
		a.coeffs[i] = 1;
	}


	poly_ntt(&a);  
	poly_invntt(&a);
	
    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        if(i%16==0) printf("\n");
        printf("%d " , a.coeffs[i]);
    }
    printf("\n");
}

int test_ntt2()
{
	poly a,b,c;

    for (int i = 0; i < NTRUPLUS_N; i++)
    {
		a.coeffs[i] = 0;
		b.coeffs[i] = 0;
    }


    for (int i = 0; i < 499; i++)
    {
		a.coeffs[i] = 1;
		b.coeffs[i] = 1;	
    }

	poly_ntt(&a);
	poly_ntt(&b);


	poly_basemul(&c, &a, &a);
	poly_freeze(&c);
	poly_invntt(&c);

    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        if(i%32==0) printf("\n");
        printf("%d " , c.coeffs[i]);
    }
    printf("\n");

}

int test_ntt3()
{
	poly a,b,c,d;
	uint8_t buf[1000] = {0};

	for (int i = 0; i < 1000; i++)
	{
		buf[i] = i;
	}
	
    poly_cbd1(&a, buf);  
	poly_ntt(&a);

    poly_baseinv(&c, &a);
	poly_basemul(&d, &c, &a);
	poly_freeze(&d);
	poly_invntt(&d);

    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        if(i%32==0) printf("\n");
        printf("%d " , d.coeffs[i]);
    }
    printf("\n");

}

void test_tofrom()
{
	poly a,b,c;

	uint8_t buf[2000];
    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        a.coeffs[i] = i;
    }

	poly_tobytes(buf, &a);
	poly_frombytes(&b, buf);

    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        if(i%16==0) printf("\n");
        printf("%d " , b.coeffs[i]);
    }
    printf("\n");

}

void test_ntt4()
{
	poly c,d,e;

	uint16_t a[864] = {1716, 199, 492, 1470, 3040, 1874, 2149, 90, 2587, 2636, 1767, 1841, 2445, 1265, 3384, 2706, 2755, 1818, 39, 1591, 209, 951, 1450, 1811, 2214, 1856, 181, 5, 283, 946, 2572, 492, 1060, 235, 3286, 3388, 1139, 878, 400, 2665, 1057, 61, 652, 3110, 1691, 2199, 3182, 658, 765, 1250, 940, 1001, 3100, 3024, 329, 3150, 2240, 792, 674, 1798, 508, 176, 914, 2073, 3268, 1672, 3262, 945, 1087, 3077, 1651, 78, 3041, 1240, 2842, 205, 2682, 2714, 1200, 1647, 2651, 3408, 2684, 726, 1824, 1974, 2521, 473, 1372, 1922, 3361, 825, 1366, 785, 3177, 1758, 3294, 2735, 75, 2749, 589, 2328, 739, 1276, 2097, 1836, 421, 178, 557, 1079, 176, 1950, 1084, 2183, 2945, 2335, 1981, 2055, 274, 162, 2649, 1555, 2006, 1911, 924, 1439, 482, 2556, 1153, 1296, 651, 449, 316, 2104, 2114, 1891, 3199, 1832, 2205, 2570, 2908, 2316, 2922, 1633, 1802, 46, 2443, 3145, 3034, 2470, 2978, 569, 1429, 158, 1829, 597, 840, 1046, 144, 1406, 64, 1303, 3298, 552, 982, 2128, 2084, 2315, 2498, 749, 235, 1825, 3397, 2708, 3158, 2742, 1130, 978, 51, 2481, 1472, 1005, 262, 2911, 2976, 2742, 1762, 1186, 1065, 3042, 1942, 2852, 522, 161, 2066, 562, 129, 1226, 9, 2492, 395, 2729, 2231, 3320, 2351, 3110, 575, 3095, 693, 150, 786, 2729, 579, 3426, 689, 1868, 2602, 1968, 3090, 438, 1916, 3373, 2410, 1038, 1662, 2581, 2019, 2488, 2335, 3148, 876, 1981, 1054, 2331, 1589, 2492, 1734, 2368, 2904, 84, 2226, 828, 17, 1718, 350, 273, 3343, 1475, 238, 857, 3411, 1707, 2378, 2457, 1466, 1746, 2765, 831, 2487, 922, 266, 2454, 523, 906, 1940, 2182, 519, 2040, 2035, 1142, 1362, 2608, 914, 524, 1732, 1006, 822, 1758, 2002, 885, 394, 518, 3380, 99, 1301, 883, 2936, 837, 2870, 944, 2399, 1198, 3165, 352, 2158, 1446, 1094, 1304, 1287, 413, 3168, 2147, 2934, 801, 133, 2932, 135, 1645, 752, 884, 1901, 248, 2749, 539, 898, 999, 3005, 491, 2109, 3453, 2610, 573, 1009, 2008, 2809, 3198, 2024, 1711, 102, 2869, 1632, 2248, 972, 17, 127, 2612, 2537, 2607, 793, 1181, 1587, 1010, 2492, 2654, 325, 449, 1130, 3236, 760, 1151, 2002, 2530, 1207, 1028, 3334, 439, 1031, 2885, 3046, 253, 2610, 1189, 1510, 13, 3094, 2195, 2793, 3279, 584, 291, 2083, 1770, 3079, 1059, 3291, 1666, 207, 533, 546, 1320, 2085, 2760, 1550, 996, 1717, 3231, 2203, 187, 2049, 852, 3444, 2352, 2614, 193, 3144, 210, 977, 58, 1314, 1173, 284, 797, 1266, 807, 1153, 3142, 1127, 2135, 2457, 3111, 1950, 2424, 2068, 692, 645, 2615, 2999, 2222, 1547, 166, 1114, 2502, 1663, 3228, 747, 1878, 1610, 1082, 301, 1338, 288, 1224, 1614, 2676, 1232, 922, 825, 1110, 403, 3298, 1153, 2981, 3133, 3179, 2330, 2797, 2435, 3024, 2374, 2132, 724, 888, 2513, 714, 335, 1185, 1434, 1242, 57, 1797, 2684, 494, 963, 2134, 1223, 895, 163, 1626, 2262, 2347, 479, 3003, 3233, 170, 455, 1494, 575, 2870, 2232, 2181, 1494, 1877, 1295, 1198, 1012, 839, 183, 386, 1152, 1068, 925, 3398, 3005, 2181, 1149, 662, 1615, 2487, 475, 1844, 2086, 1629, 49, 897, 491, 2156, 980, 2957, 3360, 345, 1580, 914, 3335, 398, 2231, 1695, 304, 814, 712, 408, 1536, 957, 900, 1501, 903, 370, 2629, 47, 785, 2495, 1032, 1648, 2793, 1572, 49, 2965, 3331, 3024, 1561, 1611, 2596, 1436, 1078, 271, 2479, 943, 3402, 1024, 1511, 1767, 2433, 754, 2254, 3108, 1407, 350, 198, 758, 1496, 1348, 1361, 484, 2920, 2249, 1482, 1074, 1837, 1176, 2758, 1582, 448, 1575, 213, 747, 3450, 698, 3451, 1556, 2187, 545, 297, 1234, 2791, 1485, 2913, 1898, 3092, 345, 1927, 3215, 21, 1721, 1956, 2082, 294, 844, 1811, 2236, 492, 3069, 2331, 1669, 3076, 1400, 1517, 456, 1483, 879, 1248, 621, 180, 946, 293, 1172, 2292, 1303, 716, 440, 2038, 3303, 1588, 1056, 581, 4, 3133, 686, 2293, 1669, 2690, 2861, 62, 1496, 1013, 631, 1953, 1940, 1251, 2184, 2630, 2347, 2691, 621, 2807, 1794, 2934, 2247, 1880, 433, 971, 3041, 1438, 1865, 1469, 1472, 2670, 2739, 2973, 975, 1052, 2931, 2528, 330, 3309, 1844, 347, 2773, 232, 2687, 3308, 812, 139, 2521, 3155, 2639, 3281, 1749, 2513, 631, 3436, 78, 1914, 608, 1593, 359, 8, 2308, 1592, 154, 724, 1499, 3213, 3142, 363, 3410, 1713, 2023, 1160, 1833, 99, 323, 1567, 43, 2748, 1207, 2217, 188, 1908, 769, 657, 2090, 1501, 665, 2332, 2709, 1111, 698, 1285, 384, 2758, 3069, 2319, 697, 1198, 1208, 1570, 2486, 2230, 3031, 472, 328, 800, 455, 2992, 271, 2128, 2901, 1564, 2692, 1609, 2522, 2243, 1877, 2625, 3428, 996, 2829, 13, 973, 814, 1886, 1746, 255, 1903, 66, 2294, 2336, 1225, 1943, 911, 3359, 178, 2122, 1457, 2977, 1626, 1017, 2380, 823, 860, 2645, 729, 1159, 3013, 1532, 767, 551, 2431, 1702, 1757, 2453, 1241, 839, 2937, 257, 351, 2931, 2917, 1546, 860, 1223, 342, 1186, 3086, 3400, 1431, 1169, 2593, 3354, 286, 897, 750, 45, 2650, 438, 1305, 1843, 2162, 685, 1356, 1671, 3018, 3348, 3088, 2540, 2009, 223, 1421, 246, 1360, 1603, 1017, 3055, 367, 3435, 2249, 1111, 3298, 60, 1598, 3420, 1253, 3096, 2317, 2458, 518, 1158, 3287, 402, 2725, 366, 415, 1732, 1947, 762, 2810, 2925, 2870, 686, 3277, 1276, 162, 926, 3120, 2189, 2251, 2278, 1256, 797, 1721, 3247, 599, 1084, 2183, 1005};

	int16_t b[864] = {0, 3, 0, 0, 3, 0, -3, 0, -3, 0, -3, 0, 0, 3, 0, 0, 3, 3, 3, 3, 0, 3, 0, 3, 0, 3, 0, 0, 0, 3, -3, -3, 0, 3, 0, 3, 0, 0, 3, 0, 0, 0, -3, 0, 3, 3, -3, -3, 3, -3, 3, 0, -3, 0, -3, -3, 0, 3, 0, 3, -3, -3, 3, 0, 0, -3, -3, 0, -3, -3, 3, 0, 3, 3, -3, -3, 0, -3, -3, 3, 3, 3, 0, -3, 0, 3, 0, 0, 0, 0, 3, 0, 0, 0, 0, -3, 3, 3, -3, 0, 0, 3, 3, 0, 0, 0, 0, 0, -3, 0, -3, -3, 0, 3, -3, 3, 3, -3, 3, 3, 0, 0, -3, 3, -3, 3, 0, 0, 0, -3, 3, 0, -3, -3, -3, -3, -3, -3, 3, 0, 0, 3, 0, 0, 0, -3, -3, 3, 0, 0, 0, 0, 0, 0, 0, -3, 0, -3, -3, 3, 0, 3, -3, 3, -3, -3, 0, 0, 0, 0, 3, 3, 3, 0, 3, -3, 0, 0, 3, 0, 0, -3, 3, -3, 0, 0, 0, 0, -3, -3, 0, -3, 3, 0, 0, -3, 0, 3, 0, -3, 3, 0, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 0, 0, 3, -3, 0, -3, -3, 3, -3, 0, 0, 3, 0, -3, 0, 0, 3, -3, 0, 0, 3, 0, 0, 3, 0, 3, 0, 3, 3, 3, 0, -3, 3, 0, 0, 0, -3, 3, 0, -3, 0, 0, 0, 3, 0, -3, 0, 0, 0, 3, 0, 0, 3, -3, -3, -3, -3, 0, 0, 0, -3, -3, 0, 0, -3, -3, 3, 0, 0, -3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -3, -3, 0, -3, 3, 3, 0, -3, -3, 0, 0, 0, -3, 3, 3, 0, 0, -3, -3, 0, 0, -3, 3, 0, 0, -3, 0, 3, 3, 3, -3, -3, 3, 0, 0, 0, 0, 0, -3, -3, 3, 0, -3, 0, 3, 0, -3, 0, 3, -3, 3, 3, 0, -3, 0, 3, 3, -3, 3, 3, 0, 0, 3, 0, 0, 0, 0, 3, 0, 3, -3, 3, 3, 3, -3, 3, 3, 0, 3, -3, 3, 0, 0, -3, -3, 3, 0, -3, 0, 3, 0, 0, 3, 0, 0, 3, 3, 3, 0, 0, 0, -3, 0, 0, -3, -3, 0, 0, -3, 0, 3, 0, -3, -3, -3, 3, 0, 3, -3, 0, 3, 3, 3, -3, 0, 0, 0, 3, 0, -3, 3, 0, -3, -3, -3, -3, -3, 3, 0, 0, 0, -3, 0, 3, -3, 0, 0, 0, 0, -3, -3, 3, 0, -3, 0, -3, 0, 3, 0, 0, -3, 3, 3, 0, -3, 3, -3, 3, 0, 0, -3, 0, 0, 3, 0, -3, 0, 0, 0, 3, 0, 0, 3, 0, 0, -3, 3, 0, -3, 0, 0, -3, 0, 0, 0, -3, 3, 3, 0, 0, 0, 0, -3, 0, 0, 3, 0, 3, 0, 0, 3, 0, 3, 0, 0, 3, 3, 0, 3, 0, 0, 0, 3, 3, 3, 0, 3, 0, 0, 0, 0, 0, 0, -3, -3, 0, -3, -3, -3, 0, 0, 3, -3, 0, -3, 0, 0, 0, -3, 0, -3, -3, 3, -3, 0, 3, 0, 3, 0, 3, 3, -3, 3, 0, -3, 0, 0, -3, 0, 0, 3, 0, 0, 0, -3, 0, 0, 0, 0, 3, 0, 0, 3, -3, 3, 0, 3, 0, 3, 3, 0, -3, 0, 3, 0, 0, 0, 0, 0, 0, 3, -3, 3, 0, -3, 0, 0, 3, 0, 3, 0, 0, 3, -3, 3, 0, 3, 0, 3, -3, 0, 0, -3, -3, 0, 0, 3, -3, 0, 3, 0, 0, -3, -3, 3, 3, 0, 0, -3, 3, 0, 0, 0, 0, 3, 3, 0, -3, 3, -3, 0, 0, 0, -3, 0, 0, 0, 0, 0, 3, -3, 0, 0, 0, -3, 0, -3, -3, 0, -3, 0, -3, 0, 3, 0, 0, 3, 0, 3, 3, 3, -3, 0, -3, 3, 0, 0, 0, 0, -3, -3, -3, 3, -3, 3, 0, 0, 3, 0, 3, 3, 0, 0, 3, 3, 0, 0, 0, 0, -3, 0, -3, -3, 0, -3, 0, -3, 3, 0, -3, 0, 3, 0, 3, 0, 0, 3, 0, -3, 0, 0, 3, 0, 0, 3, 0, 0, 0, -3, 0, 3, 0, 3, 0, 0, 0, 0, 0, 3, 0, -3, 0, 0, 3, 0, -3, 0, -3, -3, -3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 3, 0, -3, 0, 3, 0, 0, 0, -3, 3, -3, 0, 3, 0, -3, 3, 3, 0, 0, -3, -3, -3, 0, -3, -3, 0, 3, 0, -3, 0, 0, 0, 0, -3, 3, 0, 0, -3, 0, 3, 0, 0, -3, -3, -3, 0, -3, -3, 0, 0, 3, 3, 3, 3, 0, 0, 0, 3, 0, 3, 3, 0, 3, 0, 0, -3, 3, 0, 0, 0, 3, 0, 0, 0, 0, 3, 3, -3, 0, 3, 3, 0, -3, 3, 0, 0, 0, 0, 0, 0, -3, 3, 3, 0, -3, 0, -3, -3, 3, 0};


	for(int i=0; i<NTRUPLUS_N;i++)
	{
		c.coeffs[i] = a[i];
		d.coeffs[i] = b[i];
	}

	poly_ntt(&c);
	poly_ntt(&d);

	poly_basemul(&c, &c, &d);

	poly_invntt(&c);

	for (int i = 0; i < NTRUPLUS_N; i++)
    {
        if(i%64==0) printf("\n");
        printf("%d " , c.coeffs[i]);
    }
    printf("\n");

}

void test_ntt5()
{
	int16_t f[864] = {4, 0, 0, 0, 0, 0, 0, 0, -3, 3, 0, 0, -3, 3, -3, 0, 0, -3, 3, 0, 0, -3, 0, -3, 3, 0, 3, -3, 0, 3, 3, 0, 0, -3, 3, -3, 3, 0, -3, -3, -3, -3, 3, 0, 3, 0, 3, 0, -3, 0, 0, -3, 0, 0, 0, 3, 3, 0, 0, 3, 0, 0, -3, 3, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, -3, -3, 0, -3, 3, 0, -3, 0, 3, 0, 0, 3, 0, 0, -3, -3, 3, 0, 0, 0, 0, 0, 0, 3, 0, -3, 3, 0, 0, -3, 0, 0, 0, -3, -3, 0, -3, 0, 0, -3, 0, 0, -3, 0, 0, 3, 3, 0, 0, 3, -3, 3, 3, 3, 0, 3, 0, 0, 0, -3, 0, 0, -3, -3, 0, 0, 0, -3, 0, 3, 3, 0, 0, 0, 0, 3, -3, 0, 3, 0, 0, 3, 0, -3, 3, 0, 0, 0, -3, 0, 3, 0, 3, 0, -3, -3, 3, 3, 0, -3, 0, 0, -3, 3, 0, 3, 0, 3, 0, 3, 0, -3, 0, -3, 3, 3, 3, 0, 0, 0, -3, 0, 0, 0, 3, -3, 0, 3, -3, -3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 3, 3, 0, -3, 3, 0, 3, 0, 0, -3, 0, 0, 0, -3, 3, 0, 0, 0, 0, 3, -3, 0, 0, 0, 3, -3, -3, -3, 3, 0, 3, 0, -3, 0, 0, 0, 3, -3, 0, 0, 0, 0, 0, 0, 3, 3, -3, 3, 3, 0, 3, 0, 0, -3, 0, 3, 0, 3, 3, 0, 3, 0, 0, 0, -3, 0, 0, -3, 3, 3, 0, 0, 0, 3, 3, 0, 3, 0, 3, -3, 0, 3, 3, 0, -3, 0, 0, 0, 3, 0, 3, 3, -3, 3, 0, 0, 0, 0, 3, 0, 3, -3, 0, 0, -3, 0, 3, 0, 3, -3, 3, 3, 3, 3, 0, 0, 0, 3, 3, 0, -3, -3, 3, 0, 0, -3, 3, 0, 3, 0, 0, -3, 3, 0, 0, -3, -3, 0, 3, 0, -3, 0, 0, -3, 0, 0, 0, 0, -3, -3, 0, -3, 3, 0, -3, 0, 3, 0, -3, 0, 0, -3, 0, 0, 0, 0, 0, 3, -3, 0, -3, -3, 0, 0, 0, -3, 0, -3, 3, 3, -3, 3, 3, 3, 0, -3, 0, 3, 0, -3, -3, 0, -3, 0, 0, 0, -3, -3, 3, 0, 3, 0, -3, 0, 0, 0, 0, 3, 0, -3, 3, 3, 0, 0, -3, 0, 3, 0, 0, 0, 0, 0, 0, 3, -3, 0, 0, 0, 0, -3, 0, -3, 3, -3, 0, 0, -3, 3, -3, -3, 3, 3, -3, 3, -3, 3, 0, -3, -3, -3, 0, -3, 0, 0, 0, 3, 3, 0, -3, -3, 0, 0, 0, 0, -3, -3, 0, 0, 0, 0, 0, 0, -3, 0, -3, -3, 0, 0, 3, -3, 3, 3, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, -3, 3, 0, 0, 3, 3, 0, -3, -3, -3, 3, 0, 0, -3, 0, 0, 0, -3, 0, 3, -3, -3, -3, -3, 0, 0, 3, 0, 3, 0, -3, -3, 0, -3, 0, 0, 0, 0, 3, 0, 0, 0, -3, 3, 3, 0, 3, 0, 0, 0, 3, 0, -3, 3, 0, 3, 3, 0, -3, 0, 3, 3, 0, -3, -3, 0, -3, 0, 3, 0, 0, 3, -3, 0, 3, 0, 3, 0, 3, 0, 3, -3, -3, -3, 0, -3, -3, 3, -3, 0, 0, 0, 0, 0, -3, 0, -3, 0, 3, 0, 0, 0, 0, 0, -3, 0, -3, 0, 0, 0, 0, 0, -3, 0, 0, -3, 0, -3, 0, 3, 0, -3, 3, 3, 0, 3, -3, 0, 0, 3, 3, -3, -3, 0, 0, 0, 0, -3, 0, -3, -3, 0, 3, 0, -3, 3, 3, 0, 0, 0, 0, 0, -3, -3, 0, 0, -3, 0, 0, 0, -3, 0, 3, -3, -3, 3, -3, 0, 0, -3, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, -3, 3, -3, 0, -3, 3, -3, 0, 0, -3, -3, -3, 3, -3, 0, 3, 0, 0, 0, 0, 3, 0, -3, -3, -3, 0, -3, 0, 0, 0, 3, 0, 3, 0, 0, 3, 0, 3, 0, 3, 0, 0, -3, 3, 0, 0, 3, 3, 0, -3, -3, 3, 3, 0, 0, 0, 0, 0, -3, 0, 0, 3, 0, 0, -3, 0, 3, 3, 0, 3, 3, -3, 3, 0, -3, 3, 3, 3, 0, 0, -3, 3, 0, 3, 3, -3, -3, 3, 3, 0, -3, 0, 3, 0, 3, 3, 3, 0, 0, 0, -3, 0, -3, -3, 0, 0, 0, -3, -3, -3, 0, 0, 3, 0, -3, 0, -3, 3, -3, 0, 3, 3, 0, -3, 0, 0, -3, 3, 0, 0, 0, 0, 0, 3, 3, -3, 3, 0, 0, -3, 3, 3, -3, 0, 0, 3, 0, 0, 0, 0, -3, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0};

	int16_t g[864] = {0, 3, 0, 0, 3, 0, -3, 0, -3, 0, -3, 0, 0, 3, 0, 0, 3, 3, 3, 3, 0, 3, 0, 3, 0, 3, 0, 0, 0, 3, -3, -3, 0, 3, 0, 3, 0, 0, 3, 0, 0, 0, -3, 0, 3, 3, -3, -3, 3, -3, 3, 0, -3, 0, -3, -3, 0, 3, 0, 3, -3, -3, 3, 0, 0, -3, -3, 0, -3, -3, 3, 0, 3, 3, -3, -3, 0, -3, -3, 3, 3, 3, 0, -3, 0, 3, 0, 0, 0, 0, 3, 0, 0, 0, 0, -3, 3, 3, -3, 0, 0, 3, 3, 0, 0, 0, 0, 0, -3, 0, -3, -3, 0, 3, -3, 3, 3, -3, 3, 3, 0, 0, -3, 3, -3, 3, 0, 0, 0, -3, 3, 0, -3, -3, -3, -3, -3, -3, 3, 0, 0, 3, 0, 0, 0, -3, -3, 3, 0, 0, 0, 0, 0, 0, 0, -3, 0, -3, -3, 3, 0, 3, -3, 3, -3, -3, 0, 0, 0, 0, 3, 3, 3, 0, 3, -3, 0, 0, 3, 0, 0, -3, 3, -3, 0, 0, 0, 0, -3, -3, 0, -3, 3, 0, 0, -3, 0, 3, 0, -3, 3, 0, 0, 0, 0, 0, 3, 0, 0, 3, 0, 0, 0, 0, 3, -3, 0, -3, -3, 3, -3, 0, 0, 3, 0, -3, 0, 0, 3, -3, 0, 0, 3, 0, 0, 3, 0, 3, 0, 3, 3, 3, 0, -3, 3, 0, 0, 0, -3, 3, 0, -3, 0, 0, 0, 3, 0, -3, 0, 0, 0, 3, 0, 0, 3, -3, -3, -3, -3, 0, 0, 0, -3, -3, 0, 0, -3, -3, 3, 0, 0, -3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -3, -3, 0, -3, 3, 3, 0, -3, -3, 0, 0, 0, -3, 3, 3, 0, 0, -3, -3, 0, 0, -3, 3, 0, 0, -3, 0, 3, 3, 3, -3, -3, 3, 0, 0, 0, 0, 0, -3, -3, 3, 0, -3, 0, 3, 0, -3, 0, 3, -3, 3, 3, 0, -3, 0, 3, 3, -3, 3, 3, 0, 0, 3, 0, 0, 0, 0, 3, 0, 3, -3, 3, 3, 3, -3, 3, 3, 0, 3, -3, 3, 0, 0, -3, -3, 3, 0, -3, 0, 3, 0, 0, 3, 0, 0, 3, 3, 3, 0, 0, 0, -3, 0, 0, -3, -3, 0, 0, -3, 0, 3, 0, -3, -3, -3, 3, 0, 3, -3, 0, 3, 3, 3, -3, 0, 0, 0, 3, 0, -3, 3, 0, -3, -3, -3, -3, -3, 3, 0, 0, 0, -3, 0, 3, -3, 0, 0, 0, 0, -3, -3, 3, 0, -3, 0, -3, 0, 3, 0, 0, -3, 3, 3, 0, -3, 3, -3, 3, 0, 0, -3, 0, 0, 3, 0, -3, 0, 0, 0, 3, 0, 0, 3, 0, 0, -3, 3, 0, -3, 0, 0, -3, 0, 0, 0, -3, 3, 3, 0, 0, 0, 0, -3, 0, 0, 3, 0, 3, 0, 0, 3, 0, 3, 0, 0, 3, 3, 0, 3, 0, 0, 0, 3, 3, 3, 0, 3, 0, 0, 0, 0, 0, 0, -3, -3, 0, -3, -3, -3, 0, 0, 3, -3, 0, -3, 0, 0, 0, -3, 0, -3, -3, 3, -3, 0, 3, 0, 3, 0, 3, 3, -3, 3, 0, -3, 0, 0, -3, 0, 0, 3, 0, 0, 0, -3, 0, 0, 0, 0, 3, 0, 0, 3, -3, 3, 0, 3, 0, 3, 3, 0, -3, 0, 3, 0, 0, 0, 0, 0, 0, 3, -3, 3, 0, -3, 0, 0, 3, 0, 3, 0, 0, 3, -3, 3, 0, 3, 0, 3, -3, 0, 0, -3, -3, 0, 0, 3, -3, 0, 3, 0, 0, -3, -3, 3, 3, 0, 0, -3, 3, 0, 0, 0, 0, 3, 3, 0, -3, 3, -3, 0, 0, 0, -3, 0, 0, 0, 0, 0, 3, -3, 0, 0, 0, -3, 0, -3, -3, 0, -3, 0, -3, 0, 3, 0, 0, 3, 0, 3, 3, 3, -3, 0, -3, 3, 0, 0, 0, 0, -3, -3, -3, 3, -3, 3, 0, 0, 3, 0, 3, 3, 0, 0, 3, 3, 0, 0, 0, 0, -3, 0, -3, -3, 0, -3, 0, -3, 3, 0, -3, 0, 3, 0, 3, 0, 0, 3, 0, -3, 0, 0, 3, 0, 0, 3, 0, 0, 0, -3, 0, 3, 0, 3, 0, 0, 0, 0, 0, 3, 0, -3, 0, 0, 3, 0, -3, 0, -3, -3, -3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 3, 0, -3, 0, 3, 0, 0, 0, -3, 3, -3, 0, 3, 0, -3, 3, 3, 0, 0, -3, -3, -3, 0, -3, -3, 0, 3, 0, -3, 0, 0, 0, 0, -3, 3, 0, 0, -3, 0, 3, 0, 0, -3, -3, -3, 0, -3, -3, 0, 0, 3, 3, 3, 3, 0, 0, 0, 3, 0, 3, 3, 0, 3, 0, 0, -3, 3, 0, 0, 0, 3, 0, 0, 0, 0, 3, 3, -3, 0, 3, 3, 0, -3, 3, 0, 0, 0, 0, 0, 0, -3, 3, 3, 0, -3, 0, -3, -3, 3, 0};

	int16_t r[864] = {1, 0, 0, 1, 1, -1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, -1, 1, 0, 0, 0, 0, 0, -1, 1, -1, -1, -1, -1, -1, -1, 1, 0, 0, -1, 0, -1, 0, -1, 0, 0, 0, -1, -1, 0, 1, 0, 0, 1, 0, 0, 1, -1, -1, 0, 0, 1, 0, 1, -1, 1, 0, 0, 0, 0, 0, 1, -1, 1, 0, -1, -1, -1, -1, 0, 1, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, -1, -1, 0, -1, 0, -1, 0, 0, 0, 1, 0, -1, 1, 0, 1, -1, 0, -1, -1, -1, 0, 0, 0, 0, 1, -1, 1, 0, 0, -1, 0, 0, 0, -1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, -1, 0, 0, 0, 0, -1, 0, 1, 0, 0, -1, -1, 0, 1, 0, 1, 0, 0, 0, -1, 0, 0, -1, -1, 0, 1, 0, 1, 1, 0, 0, -1, 0, 0, -1, 0, -1, 1, 0, 1, -1, 1, 0, -1, 0, 0, 1, -1, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 1, 0, 0, 1, 1, 1, -1, 0, 1, 1, 1, 1, 1, -1, 0, 0, 0, -1, 1, -1, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 1, 0, -1, 0, -1, 1, 0, 0, 1, 1, -1, 0, 0, 1, -1, 1, 0, 1, 0, 0, -1, -1, -1, -1, 0, 1, 1, 0, 1, 0, 0, 0, 0, -1, 1, 0, 0, -1, 0, 0, -1, 1, 0, -1, -1, 1, 0, 1, -1, 0, 0, 0, 1, -1, 0, -1, 1, -1, 1, 0, 0, 1, 0, 1, 0, -1, -1, 0, 0, 1, 0, -1, 0, 1, 0, -1, 1, 0, 0, 0, 0, 1, -1, -1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, -1, 0, 0, 0, 0, 0, 0, 0, -1, -1, -1, 0, 1, -1, 0, 1, 1, 0, -1, -1, 0, 0, -1, -1, -1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, -1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, -1, 1, -1, 0, -1, 0, 0, 0, 1, 1, 1, 0, -1, -1, 1, 0, -1, 0, 1, 0, 0, 1, -1, 1, -1, 1, 0, 0, -1, 1, 0, -1, 1, 0, -1, 1, 1, -1, 0, 1, 0, 1, 1, 0, 1, 0, -1, -1, -1, -1, 0, -1, 0, 0, 0, 0, 1, -1, 1, 1, 0, 0, -1, 1, 0, 0, -1, -1, 0, 0, -1, 0, 0, -1, 1, 0, 1, 0, -1, -1, 1, -1, 1, 1, 0, 0, -1, 0, 0, -1, 0, 1, 1, 1, 1, 0, 0, 0, -1, 0, 0, 0, -1, -1, 0, 0, 0, 1, 1, 1, -1, 1, -1, -1, 0, 0, 0, 0, -1, 0, -1, 0, -1, -1, -1, -1, 0, -1, 0, 0, -1, 1, -1, -1, 0, -1, -1, 0, 0, 0, 0, 0, -1, 0, 1, 1, 0, 0, -1, 0, 0, 1, 0, 1, -1, -1, 0, 0, -1, 1, 1, 1, 0, -1, 0, 1, -1, 1, 1, -1, -1, 1, -1, 1, 0, 1, -1, 1, -1, 1, 1, 0, 1, 0, -1, 0, 0, -1, 1, -1, 0, -1, -1, 0, 0, -1, 1, 0, 0, -1, 0, 1, -1, -1, 1, -1, 0, 0, 1, -1, 0, 0, 1, -1, 1, -1, 0, 0, -1, -1, 1, 0, 0, 1, -1, 1, 0, 0, 0, 1, 0, -1, 0, 0, 0, -1, 0, 1, 0, 0, 1, -1, -1, 0, 1, 0, 1, 0, -1, 1, 0, 1, 1, -1, -1, -1, 1, 0, -1, -1, 0, 1, 1, 0, 0, -1, 0, 0, -1, -1, 0, -1, 0, 0, 0, -1, -1, 0, -1, 0, 0, 1, -1, 1, -1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, -1, 1, -1, 0, 0, 1, 0, 0, 0, 1, -1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, -1, 1, 1, 0, -1, 0, 1, 0, 0, 0, 1, 1, -1, 1, 0, 0, 1, 0, 0, 0, -1, -1, 0, 0, -1, 0, 0, -1, -1, 0, -1, -1, 1, 0, 0, 0, 1, 1, 0, -1, 1, 0, -1, 1, 0, -1, 1, 0, -1, 0, 0, 0, 1, 0, 0, 1, -1, 0, 0, -1, 1, -1, 0, -1, -1, -1, 0, 1, -1, -1, 0, 0, 0, 0, -1, 0, 0, -1, -1, 0, 0, 0, 1, -1, 1, 0, 1, -1, 1, 1, 1, 1, 1, 0, 1, 0, 0, -1, 0, 1, 0, -1, 1, 1, -1, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 1, -1, 0, 0, 0, 0, 0, 0, -1, -1, 0, 1, 1, 1, 0, -1, 1, 0, -1, 0, -1, 0, -1, 1, -1, 0};

	poly a,b,c,d,e,h,j,k;

	for(int i=0; i<NTRUPLUS_N;i++)
	{
		a.coeffs[i] = f[i];
		b.coeffs[i] = g[i];
		c.coeffs[i] = r[i];
	}

	poly_ntt(&a);
	poly_ntt(&b);
	poly_ntt(&c);

	poly_baseinv(&d, &a); //M^2
	poly_freeze(&d);
	poly_basemul(&e, &d, &b); //M^1
	poly_freeze(&e);
	poly_basemul(&h, &e, &c); //M^0
	poly_freeze(&h);
	poly_invntt(&h);    //M^1
	poly_freeze(&h);
    printf("h\n");
    for (int i = 0; i < NTRUPLUS_N; i++)
    {
        printf("%d ", h.coeffs[i]);
    }
    printf("\n");
}
int main(void)
{
	unsigned char entropy_input[48] = {0};
	unsigned char personalization_string[48] = {0};

	printf("PUBLICKEYBYTES : %d\n", CRYPTO_PUBLICKEYBYTES);
	printf("SECRETKEYBYTES : %d\n", CRYPTO_SECRETKEYBYTES);
	printf("CIPHERTEXTBYTES : %d\n", CRYPTO_CIPHERTEXTBYTES);

	randombytes_init(entropy_input, personalization_string, 128);

	//test_tofrom();
	//test_ntt();
	//test_ntt2();
	//test_ntt3();
	//test_ntt4();
//test_ntt5();
	//test_ntt_clock();
	TEST_CCA_KEM();
	TEST_CCA_KEM_CLOCK();
	
	return 0;	
}