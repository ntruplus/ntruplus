#include <stdint.h>
#include "params.h"

const int16_t zetas[1220] __attribute__((aligned(32))) = {13688, 13688, 2424, 2424, 28816, 28816, 2192, 2192, 44228, 44228, 708, 708, 49100, 49100, 460, 460, 36721, 36721, 1265, 1265, 57006, 57006, 2990, 2990, 27735, 27735, 727, 727, 45100, 45100, 556, 556, 55451, 55451, 1307, 1307, 32892, 32892, 2684, 2684, 15584, 15584, 3296, 3296, 48304, 48304, 1200, 1200, 64437, 64437, 1845, 1845, 29498, 29498, 570, 570, 42105, 42105, 1529, 1529, 59887, 59887, 1135, 1135, 20437, 20437, 2901, 2901, 62560, 62560, 62560, 62560, 62560, 62560, 62560, 62560, 51754, 51754, 51754, 51754, 51754, 51754, 51754, 51754, 1120, 1120, 1120, 1120, 1120, 1120, 1120, 1120, 298, 298, 298, 298, 298, 298, 298, 298, 54731, 54731, 54731, 54731, 54731, 54731, 54731, 54731, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2029, 2635, 2635, 2635, 2635, 2635, 2635, 2635, 2635, 1901, 1901, 1901, 1901, 1901, 1901, 1901, 1901, 42788, 42788, 42788, 42788, 42788, 42788, 42788, 42788, 40759, 40759, 40759, 40759, 40759, 40759, 40759, 40759, 3364, 3364, 3364, 3364, 3364, 3364, 3364, 3364, 1463, 1463, 1463, 1463, 1463, 1463, 1463, 1463, 62484, 62484, 62484, 62484, 62484, 62484, 62484, 62484, 40968, 40968, 40968, 40968, 40968, 40968, 40968, 40968, 532, 532, 532, 532, 532, 532, 532, 532, 3080, 3080, 3080, 3080, 3080, 3080, 3080, 3080, 44020, 44020, 44020, 44020, 44020, 44020, 44020, 44020, 28986, 28986, 28986, 28986, 28986, 28986, 28986, 28986, 2548, 2548, 2548, 2548, 2548, 2548, 2548, 2548, 58, 58, 58, 58, 58, 58, 58, 58, 43641, 43641, 43641, 43641, 43641, 43641, 43641, 43641, 14655, 14655, 14655, 14655, 14655, 14655, 14655, 14655, 3065, 3065, 3065, 3065, 3065, 3065, 3065, 3065, 3007, 3007, 3007, 3007, 3007, 3007, 3007, 3007, 47034, 47034, 47034, 47034, 47034, 47034, 47034, 47034, 54996, 54996, 54996, 54996, 54996, 54996, 54996, 54996, 1722, 1722, 1722, 1722, 1722, 1722, 1722, 1722, 1236, 1236, 1236, 1236, 1236, 1236, 1236, 1236, 7963, 7963, 7963, 7963, 7963, 7963, 7963, 7963, 8854, 8854, 8854, 8854, 8854, 8854, 8854, 8854, 2971, 2971, 2971, 2971, 2971, 2971, 2971, 2971, 2966, 2966, 2966, 2966, 2966, 2966, 2966, 2966, 30560, 30560, 30560, 30560, 30560, 30560, 30560, 30560, 21707, 21707, 21707, 21707, 21707, 21707, 21707, 21707, 1888, 1888, 1888, 1888, 1888, 1888, 1888, 1888, 2379, 2379, 2379, 2379, 2379, 2379, 2379, 2379, 6692, 6692, 6692, 6692, 19337, 19337, 19337, 19337, 21214, 21214, 21214, 21214, 11356, 11356, 11356, 11356, 36, 36, 36, 36, 1289, 1289, 1289, 1289, 2014, 2014, 2014, 2014, 1628, 1628, 1628, 1628, 18048, 18048, 18048, 18048, 63660, 63660, 63660, 63660, 12361, 12361, 12361, 12361, 34787, 34787, 34787, 34787, 1664, 1664, 1664, 1664, 2732, 2732, 2732, 2732, 2505, 2505, 2505, 2505, 99, 99, 99, 99, 50693, 50693, 50693, 50693, 41953, 41953, 41953, 41953, 54314, 54314, 54314, 54314, 49631, 49631, 49631, 49631, 2437, 2437, 2437, 2437, 353, 353, 353, 353, 2858, 2858, 2858, 2858, 1119, 1119, 1119, 1119, 51792, 51792, 51792, 51792, 33991, 33991, 33991, 33991, 64854, 64854, 64854, 64854, 41100, 41100, 41100, 41100, 592, 592, 592, 592, 839, 839, 839, 839, 1622, 1622, 1622, 1622, 652, 652, 652, 652, 27356, 27356, 27356, 27356, 34674, 34674, 34674, 34674, 62276, 62276, 62276, 62276, 50731, 50731, 50731, 50731, 1244, 1244, 1244, 1244, 2674, 2674, 2674, 2674, 2372, 2372, 2372, 2372, 2731, 2731, 2731, 2731, 43318, 43318, 43318, 43318, 63717, 63717, 63717, 63717, 60456, 60456, 60456, 60456, 7413, 7413, 7413, 7413, 566, 566, 566, 566, 3173, 3173, 3173, 3173, 2088, 2088, 2088, 2088, 2165, 2165, 2165, 2165, 57100, 57100, 57100, 57100, 56570, 56570, 56570, 56570, 5005, 5005, 5005, 5005, 4437, 4437, 4437, 4437, 268, 268, 268, 268, 3066, 3066, 3066, 3066, 781, 781, 781, 781, 3285, 3285, 3285, 3285, 61536, 61536, 61536, 61536, 51565, 51565, 51565, 51565, 41043, 41043, 41043, 41043, 25953, 25953, 25953, 25953, 96, 96, 96, 96, 2285, 2285, 2285, 2285, 211, 211, 211, 211, 737, 737, 737, 737, 20569, 20569, 20569, 20569, 13764, 13764, 13764, 13764, 54807, 54807, 54807, 54807, 5384, 5384, 5384, 5384, 473, 473, 473, 473, 3012, 3012, 3012, 3012, 3223, 3223, 3223, 3223, 264, 264, 264, 264, 64001, 64001, 26939, 26939, 41821, 41821, 51963, 51963, 30295, 30295, 17915, 17915, 60096, 60096, 14541, 14541, 1921, 1921, 1467, 1467, 2781, 2781, 1915, 1915, 3287, 3287, 635, 635, 2752, 2752, 2125, 2125, 12399, 12399, 61631, 61631, 16721, 16721, 41631, 41631, 36304, 36304, 12816, 12816, 29119, 29119, 37726, 37726, 2799, 2799, 831, 831, 1745, 1745, 1311, 1311, 1488, 1488, 2576, 2576, 1087, 1087, 2142, 2142, 40285, 40285, 13366, 13366, 3223, 3223, 53499, 53499, 24854, 24854, 32456, 32456, 12475, 12475, 49783, 49783, 1245, 1245, 3382, 3382, 791, 791, 3451, 3451, 2582, 2582, 2760, 2760, 3387, 3387, 2295, 2295, 40607, 40607, 44930, 44930, 37328, 37328, 16702, 16702, 65423, 65423, 50541, 50541, 41934, 41934, 1422, 1422, 287, 287, 2690, 2690, 2512, 2512, 1598, 1598, 2575, 2575, 1261, 1261, 206, 206, 654, 654, 43508, 43508, 1328, 1328, 16588, 16588, 13214, 13214, 21062, 21062, 35053, 35053, 12171, 12171, 31641, 31641, 2036, 2036, 3376, 3376, 716, 716, 2206, 2206, 838, 838, 2157, 2157, 1035, 1035, 3353, 3353, 37574, 37574, 60115, 60115, 63300, 63300, 54617, 54617, 45972, 45972, 42238, 42238, 3678, 3678, 47944, 47944, 966, 966, 2899, 2899, 3396, 3396, 1753, 1753, 404, 404, 2558, 2558, 862, 862, 1864, 1864, 63565, 63565, 45916, 45916, 49650, 49650, 24645, 24645, 33233, 33233, 1157, 1157, 47224, 47224, 10579, 10579, 1997, 1997, 3420, 3420, 1266, 1266, 965, 965, 1873, 1873, 2053, 2053, 3192, 3192, 2515, 2515, 35337, 35337, 49195, 49195, 57878, 57878, 17043, 17043, 18294, 18294, 41536, 41536, 27678, 27678, 702, 702, 905, 905, 1195, 1195, 2838, 2838, 787, 787, 118, 118, 576, 576, 286, 286, 1982, 1982, 47679, 47679, 5024, 5024, 30029, 30029, 26617, 26617, 14920, 14920, 11735, 11735, 48380, 48380, 42882, 42882, 3263, 3263, 928, 928, 1229, 1229, 2425, 2425, 1608, 1608, 1111, 1111, 1788, 1788, 642, 642, 65366, 10275, 62901, 34901, 7508, 6655, 50408, 37233, 6920, 49328, 26768, 11811, 23223, 57821, 1858, 4626, 2134, 163, 309, 981, 2900, 3199, 232, 1777, 1800, 2224, 144, 1699, 311, 2397, 578, 1298, 32494, 1991, 57650, 52589, 12095, 43489, 19318, 45423, 28797, 6162, 44247, 493, 43679, 56589, 19223, 43849, 3054, 1607, 1074, 3309, 447, 1889, 1142, 3055, 2045, 2834, 855, 365, 3359, 3213, 407, 1225, 4512, 48683, 18712, 9138, 63622, 20645, 28683, 56702, 28190, 35413, 49442, 8076, 4835, 14712, 52816, 37878, 416, 683, 3352, 1714, 2438, 1061, 1163, 638, 798, 1493, 3106, 396, 2915, 3448, 1616, 3318, 18598, 59679, 25081, 62446, 33688, 61138, 10560, 4892, 32209, 62807, 31413, 23375, 24607, 54579, 59641, 20095, 2470, 2975, 889, 238, 1944, 466, 2368, 3356, 849, 3031, 1589, 1487, 671, 1459, 2681, 255, 62731, 45176, 7640, 35072, 57916, 43887, 57063, 29726, 60228, 42958, 12683, 816, 36949, 10408, 31792, 29669, 2443, 1144, 472, 2304, 3132, 1519, 3431, 2334, 324, 1230, 1547, 2864, 3029, 1192, 1072, 1893, 47792, 20020, 53631, 25195, 59849, 36664, 65082, 5555, 64266, 18238, 31356, 48645, 55887, 49536, 62143, 22313, 688, 3124, 1023, 1771, 841, 824, 3386, 1587, 522, 3134, 1148, 389, 1231, 384, 1343, 169, 58484, 53328, 44001, 22617, 48152, 12892, 30067, 53461, 45707, 50939, 14143, 51262, 20531, 52456, 33100, 38276, 628, 2128, 2401, 2521, 24, 3164, 1523, 3157, 1803, 891, 2495, 3390, 179, 2280, 844, 2948, 10484, 16740, 45404, 32797, 63015, 49897, 33878, 64285, 54295, 36209, 59394, 42219, 35887, 45214, 8114, 42939, 1780, 1892, 2908, 1949, 1191, 3177, 3414, 669, 2711, 753, 770, 2411, 1711, 1438, 690, 1083, 33574, 46143, 52494, 6313, 30086, 1346, 49593, 49916, 7375, 43773, 55641, 6124, 3204, 40077, 42200, 58257, 1062, 1727, 2574, 553, 1670, 66, 825, 3324, 1871, 637, 2777, 2540, 644, 3085, 2264, 2321};

const int16_t zetas_inv[1224] __attribute__((aligned(32))) = {7280, 23337, 25460, 62333, 59413, 9896, 21764, 58162, 15621, 15944, 64191, 35451, 59224, 13043, 19394, 31963, 1136, 1193, 372, 2813, 917, 680, 2820, 1586, 133, 2632, 3391, 1787, 2904, 883, 1730, 2395, 22598, 57423, 20323, 29650, 23318, 6143, 29328, 11242, 1252, 31659, 15640, 2522, 32740, 20133, 48797, 55053, 2374, 2767, 2019, 1746, 1046, 2687, 2704, 746, 2788, 43, 280, 2266, 1508, 549, 1565, 1677, 27261, 32437, 13081, 45006, 14275, 51394, 14598, 19830, 12076, 35470, 52645, 17385, 42920, 21536, 12209, 7053, 509, 2613, 1177, 3278, 67, 962, 2566, 1654, 300, 1934, 293, 3433, 936, 1056, 1329, 2829, 43224, 3394, 16001, 9650, 16892, 34181, 47299, 1271, 59982, 455, 28873, 5688, 40342, 11906, 45517, 17745, 3288, 2114, 3073, 2226, 3068, 2309, 323, 2935, 1870, 71, 2633, 2616, 1686, 2434, 333, 2769, 35868, 33745, 55129, 28588, 64721, 52854, 22579, 5309, 35811, 8474, 21650, 7621, 30465, 57897, 20361, 2806, 1564, 2385, 2265, 428, 593, 1910, 2227, 3133, 1123, 26, 1938, 325, 1153, 2985, 2313, 1014, 45442, 5896, 10958, 40930, 42162, 34124, 2730, 33328, 60645, 54977, 4399, 31849, 3091, 40456, 5858, 46939, 3202, 776, 1998, 2786, 1970, 1868, 426, 2608, 101, 1089, 2991, 1513, 3219, 2568, 482, 987, 27659, 12721, 50825, 60702, 57461, 16095, 30124, 37347, 8835, 36854, 44892, 1915, 56399, 46825, 16854, 61025, 139, 1841, 9, 542, 3061, 351, 1964, 2659, 2819, 2294, 2396, 1019, 1743, 105, 2774, 3041, 21688, 46314, 8948, 21858, 65044, 21290, 59375, 36740, 20114, 46219, 22048, 53442, 12948, 7887, 63546, 33043, 2232, 3050, 244, 98, 3092, 2602, 623, 1412, 402, 2315, 1568, 3010, 148, 2383, 1850, 403, 60911, 63679, 7716, 42314, 53726, 38769, 16209, 58617, 28304, 15129, 58882, 58029, 30636, 2636, 55262, 171, 2159, 2879, 1060, 3146, 1758, 3313, 1233, 1657, 1680, 3225, 258, 557, 2476, 3148, 3294, 1323, 22655, 22655, 17157, 17157, 53802, 53802, 50617, 50617, 38920, 38920, 35508, 35508, 60513, 60513, 17858, 17858, 2815, 2815, 1669, 1669, 2346, 2346, 1849, 1849, 1032, 1032, 2228, 2228, 2529, 2529, 194, 194, 64835, 64835, 37859, 37859, 24001, 24001, 47243, 47243, 48494, 48494, 7659, 7659, 16342, 16342, 30200, 30200, 1475, 1475, 3171, 3171, 2881, 2881, 3339, 3339, 2670, 2670, 619, 619, 2262, 2262, 2552, 2552, 54958, 54958, 18313, 18313, 64380, 64380, 32304, 32304, 40892, 40892, 15887, 15887, 19621, 19621, 1972, 1972, 942, 942, 265, 265, 1404, 1404, 1584, 1584, 2492, 2492, 2191, 2191, 37, 37, 1460, 1460, 17593, 17593, 61859, 61859, 23299, 23299, 19565, 19565, 10920, 10920, 2237, 2237, 5422, 5422, 27963, 27963, 1593, 1593, 2595, 2595, 899, 899, 3053, 3053, 1704, 1704, 61, 61, 558, 558, 2491, 2491, 33896, 33896, 53366, 53366, 30484, 30484, 44475, 44475, 52323, 52323, 48949, 48949, 64209, 64209, 22029, 22029, 104, 104, 2422, 2422, 1300, 1300, 2619, 2619, 1251, 1251, 2741, 2741, 81, 81, 1421, 1421, 64115, 64115, 23603, 23603, 14996, 14996, 114, 114, 48835, 48835, 28209, 28209, 20607, 20607, 24930, 24930, 2803, 2803, 3251, 3251, 2196, 2196, 882, 882, 1859, 1859, 945, 945, 767, 767, 3170, 3170, 15754, 15754, 53062, 53062, 33081, 33081, 40683, 40683, 12038, 12038, 62314, 62314, 52171, 52171, 25252, 25252, 1162, 1162, 70, 70, 697, 697, 875, 875, 6, 6, 2666, 2666, 75, 75, 2212, 2212, 27811, 27811, 36418, 36418, 52721, 52721, 29233, 29233, 23906, 23906, 48816, 48816, 3906, 3906, 53138, 53138, 1315, 1315, 2370, 2370, 881, 881, 1969, 1969, 2146, 2146, 1712, 1712, 2626, 2626, 658, 658, 50996, 50996, 5441, 5441, 47622, 47622, 35242, 35242, 13574, 13574, 23716, 23716, 38598, 38598, 1536, 1536, 1332, 1332, 705, 705, 2822, 2822, 170, 170, 1542, 1542, 676, 676, 1990, 1990, 1536, 1536, 60153, 60153, 60153, 60153, 10730, 10730, 10730, 10730, 51773, 51773, 51773, 51773, 44968, 44968, 44968, 44968, 3193, 3193, 3193, 3193, 234, 234, 234, 234, 445, 445, 445, 445, 2984, 2984, 2984, 2984, 39584, 39584, 39584, 39584, 24494, 24494, 24494, 24494, 13972, 13972, 13972, 13972, 4001, 4001, 4001, 4001, 2720, 2720, 2720, 2720, 3246, 3246, 3246, 3246, 1172, 1172, 1172, 1172, 3361, 3361, 3361, 3361, 61100, 61100, 61100, 61100, 60532, 60532, 60532, 60532, 8967, 8967, 8967, 8967, 8437, 8437, 8437, 8437, 172, 172, 172, 172, 2676, 2676, 2676, 2676, 391, 391, 391, 391, 3189, 3189, 3189, 3189, 58124, 58124, 58124, 58124, 5081, 5081, 5081, 5081, 1820, 1820, 1820, 1820, 22219, 22219, 22219, 22219, 1292, 1292, 1292, 1292, 1369, 1369, 1369, 1369, 284, 284, 284, 284, 2891, 2891, 2891, 2891, 14806, 14806, 14806, 14806, 3261, 3261, 3261, 3261, 30863, 30863, 30863, 30863, 38181, 38181, 38181, 38181, 726, 726, 726, 726, 1085, 1085, 1085, 1085, 783, 783, 783, 783, 2213, 2213, 2213, 2213, 24437, 24437, 24437, 24437, 683, 683, 683, 683, 31546, 31546, 31546, 31546, 13745, 13745, 13745, 13745, 2805, 2805, 2805, 2805, 1835, 1835, 1835, 1835, 2618, 2618, 2618, 2618, 2865, 2865, 2865, 2865, 15906, 15906, 15906, 15906, 11223, 11223, 11223, 11223, 23584, 23584, 23584, 23584, 14844, 14844, 14844, 14844, 2338, 2338, 2338, 2338, 599, 599, 599, 599, 3104, 3104, 3104, 3104, 1020, 1020, 1020, 1020, 30750, 30750, 30750, 30750, 53176, 53176, 53176, 53176, 1877, 1877, 1877, 1877, 47489, 47489, 47489, 47489, 3358, 3358, 3358, 3358, 952, 952, 952, 952, 725, 725, 725, 725, 1793, 1793, 1793, 1793, 54181, 54181, 54181, 54181, 44323, 44323, 44323, 44323, 46200, 46200, 46200, 46200, 58845, 58845, 58845, 58845, 1829, 1829, 1829, 1829, 1443, 1443, 1443, 1443, 2168, 2168, 2168, 2168, 3421, 3421, 3421, 3421, 43830, 43830, 43830, 43830, 43830, 43830, 43830, 43830, 34977, 34977, 34977, 34977, 34977, 34977, 34977, 34977, 1078, 1078, 1078, 1078, 1078, 1078, 1078, 1078, 1569, 1569, 1569, 1569, 1569, 1569, 1569, 1569, 56683, 56683, 56683, 56683, 56683, 56683, 56683, 56683, 57574, 57574, 57574, 57574, 57574, 57574, 57574, 57574, 491, 491, 491, 491, 491, 491, 491, 491, 486, 486, 486, 486, 486, 486, 486, 486, 10541, 10541, 10541, 10541, 10541, 10541, 10541, 10541, 18503, 18503, 18503, 18503, 18503, 18503, 18503, 18503, 2221, 2221, 2221, 2221, 2221, 2221, 2221, 2221, 1735, 1735, 1735, 1735, 1735, 1735, 1735, 1735, 50882, 50882, 50882, 50882, 50882, 50882, 50882, 50882, 21896, 21896, 21896, 21896, 21896, 21896, 21896, 21896, 450, 450, 450, 450, 450, 450, 450, 450, 392, 392, 392, 392, 392, 392, 392, 392, 36551, 36551, 36551, 36551, 36551, 36551, 36551, 36551, 21517, 21517, 21517, 21517, 21517, 21517, 21517, 21517, 3399, 3399, 3399, 3399, 3399, 3399, 3399, 3399, 909, 909, 909, 909, 909, 909, 909, 909, 24569, 24569, 24569, 24569, 24569, 24569, 24569, 24569, 3053, 3053, 3053, 3053, 3053, 3053, 3053, 3053, 377, 377, 377, 377, 377, 377, 377, 377, 2925, 2925, 2925, 2925, 2925, 2925, 2925, 2925, 24778, 24778, 24778, 24778, 24778, 24778, 24778, 24778, 22749, 22749, 22749, 22749, 22749, 22749, 22749, 22749, 1994, 1994, 1994, 1994, 1994, 1994, 1994, 1994, 93, 93, 93, 93, 93, 93, 93, 93, 63508, 63508, 63508, 63508, 63508, 63508, 63508, 63508, 10806, 10806, 10806, 10806, 10806, 10806, 10806, 10806, 1556, 1556, 1556, 1556, 1556, 1556, 1556, 1556, 822, 822, 822, 822, 822, 822, 822, 822, 13783, 13783, 13783, 13783, 13783, 13783, 13783, 13783, 2977, 2977, 2977, 2977, 2977, 2977, 2977, 2977, 3159, 3159, 3159, 3159, 3159, 3159, 3159, 3159, 2337, 2337, 2337, 2337, 2337, 2337, 2337, 2337, 49953, 49953, 161, 161, 35792, 35792, 976, 976, 63773, 63773, 157, 157, 32645, 32645, 773, 773, 10086, 10086, 2150, 2150, 8531, 8531, 467, 467, 23432, 23432, 1928, 1928, 5650, 5650, 2322, 2322, 56228, 56228, 420, 420, 17233, 17233, 2257, 2257, 1100, 1100, 1612, 1612, 1764, 1764, 3300, 3300, 60664, 60664, 248, 248, 58598, 58598, 1510, 1510, 29783, 29783, 2775, 2775, 4873, 4873, 3209, 3209, 34560, 34560, 1792, 1792, 32096, 32096, 3424, 3424};

#define QINV 12929
#define LOW ((1U << 12) - 1)
#define V ((1U << 26)/NTRUPLUS_Q)

#define WQINV 13707
#define W 2571

#define WINVQINV 51849
#define WINV 1033

const uint64_t _4x9[4] __attribute__((aligned(32))) = {9, 9, 9, 9};
const uint64_t _4x3[8] __attribute__((aligned(32))) = {15, 15, 15, 15};

const uint16_t _low_mask[16] __attribute__((aligned(32))) = {LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW};
const uint16_t _4x1[8] __attribute__((aligned(32))) = {1, 1, 1, 1};
const uint32_t _8x1[8] __attribute__((aligned(32))) = {1, 1, 1, 1, 1, 1, 1, 1};

const uint16_t _16xv[16] __attribute__((aligned(32))) = {V, V, V, V, V, V, V, V, V, V, V, V, V, V, V, V};
const uint16_t _16x1[16] __attribute__((aligned(32))) = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
const uint16_t _16x3[16] __attribute__((aligned(32))) = {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3};
const uint16_t _16x33[16] __attribute__((aligned(32))) = {0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333, 0x3333};
const uint16_t _16x5[16] __attribute__((aligned(32))) = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5};
const uint16_t _16x55[16] __attribute__((aligned(32))) = {0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555};
const uint16_t _16xq[16]  __attribute__((aligned(32))) = {NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q};
const uint16_t _16xqinv[16] __attribute__((aligned(32))) = {QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV};

const uint16_t _16xw[16] __attribute__((aligned(32))) = {W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W};
const uint16_t _16xwqinv[16] __attribute__((aligned(32))) = {WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV};
const uint16_t _16xwinvqinv[16] __attribute__((aligned(32))) = {WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV, WINVQINV};
const uint16_t _16xwinv[16] __attribute__((aligned(32))) = {WINV, WINV, WINV, WINV, WINV, WINV, WINV, WINV, WINV, WINV, WINV, WINV, WINV, WINV, WINV, WINV};

#undef QINV
#undef LOW
#undef V
#undef WQINV
#undef W
#undef WINVQINV
#undef WINV