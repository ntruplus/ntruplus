#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "ntt.h"
#include "reduce.h"
#include "symmetric.h"

extern void poly_ntt_asm(poly *r, const poly *a, const int16_t* zetas);
extern void poly_invntt_asm(poly *r, const poly *a, const int16_t* zetas);
extern void poly_frombytes_asm(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES], const int16_t *zetas);
extern void poly_tobytes_asm(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a, const int16_t* zetas);
extern void poly_cbd1_asm(poly *r, const uint8_t buf[NTRUPLUS_N/4], const int16_t* zeta);
extern void poly_sotp_asm(poly *r, const unsigned char *msg, const unsigned char *buf, const int16_t* zetas);
extern int  poly_sotp_inv_asm(unsigned char *msg, const poly *e, const unsigned char *buf, const int16_t* zetas);	
extern void poly_basemul_asm(poly *r, const poly *a, const poly *b, const int16_t* zetas);
extern int  poly_baseinv_asm(poly *r, const poly *a, const int16_t* zetas);
extern void poly_basemul_add_asm(poly *r, const poly *a, const poly *b, const poly *c, const int16_t* zetas);
extern void poly_crepmod3_asm(poly *r, const poly *a, const int16_t* zetas);



const int16_t zetas2[1048] __attribute__((aligned(16))) = {
  3457,  19412,   -723,  -6853,   -722,  -6844,  -1520, -14408,
  1124,  10654,    867,   8218,   1520,  14408,    450,   4265,
 -1463, -13867,   1078,  10218,    532,   5043,   1722,  16322,
  -822,  -7792,    909,   8616,     58,    550,  -1556, -14749,
  1236,  11716,    298,   2825,  -1078, -10218,      0,      0,
  3457,  19412,    157,   1488,      0,      0,      0,      0, 
  -353,   -353,   -353,   -353,  -1020,  -1020,  -1020,  -1020, 
 -3346,  -3346,  -3346,  -3346,  -9668,  -9668,  -9668,  -9668, 
    81,     81,  -1421,  -1421,   1251,   1251,    716,    716, 
   768,    768, -13469, -13469,  11858,  11858,   6787,   6787, 
     9,   -542,    139,   1616,   -396,   -351,    798,   1493, 
    85,  -5137,   1318,  15318,  -3754,  -3327,   7564,  14152, 
  3457,  19412,    727,   6891,      0,      0,      0,      0, 
 -1119,  -1119,  -1119,  -1119,   -599,   -599,   -599,   -599, 
-10607, -10607, -10607, -10607,  -5678,  -5678,  -5678,  -5678, 
 -1598,  -1598,   -945,   -945,    287,    287,   -767,   -767, 
-15147, -15147,  -8957,  -8957,   2720,   2720,  -7270,  -7270, 
  -365,    855,  -1412,   -623,  -1225,    407,    -98,   -244, 
 -3460,   8104, -13384,  -5905, -11611,   3858,   -929,  -2313, 
  3457,  19412,    570,   5403,      0,      0,      0,      0, 
  -952,   -952,   -952,   -952,     99,     99,     99,     99, 
 -9024,  -9024,  -9024,  -9024,    938,    938,    938,    938, 
  -654,   -654,    206,    206,   -882,   -882,   1261,   1261, 
 -6199,  -6199,   1953,   1953,  -8360,  -8360,  11953,  11953, 
 -1714,   -105,    416,    683,   -638,   1163,  -1019,   1061, 
-16247,   -995,   3943,   6474,  -6047,  11024,  -9659,  10057, 
  3457,  19412,   -107,  -1014,      0,      0,      0,      0, 
  -652,   -652,   -652,   -652,   1622,   1622,   1622,   1622, 
 -6180,  -6180,  -6180,  -6180,  15375,  15375,  15375,  15375, 
  1542,   1542,   -676,   -676,  -1536,  -1536,   1467,   1467, 
 14616,  14616,  -6408,  -6408, -14559, -14559,  13905,  13905, 
 -1519,   -325,   1123,    -26,   1153,    472,  -1014,   1144, 
-14398,  -3081,  10645,   -246,  10929,   4474,  -9611,  10844, 
  3457,  19412,   1200,  11374,      0,      0,      0,      0, 
   783,    783,    783,    783,   1244,   1244,   1244,   1244, 
  7422,   7422,   7422,   7422,  11792,  11792,  11792,  11792, 
  1332,   1332,   -705,   -705,   -170,   -170,    635,    635, 
 12626,  12626,  -6683,  -6683,  -1611,  -1611,   6019,   6019, 
  -238,    889,   -987,   -482,    101,  -1089,  -1513,    466, 
 -2256,   8427,  -9356,  -4569,    957, -10322, -14341,   4417, 
  3457,  19412,   1307,  12389,      0,      0,      0,      0, 
   592,    592,    592,    592,    839,    839,    839,    839, 
  5611,   5611,   5611,   5611,   7953,   7953,   7953,   7953, 
 -1311,  -1311,  -1712,  -1712,   -658,   -658,    831,    831, 
-12427, -12427, -16228, -16228,  -6237,  -6237,   7877,   7877, 
 -1487,   1589,    849,   -426,   -255,   -776,    671,   1459, 
-14095,  15062,   8047,  -4038,  -2417,  -7356,   6360,  13829, 
  3457,  19412,    161,   1526,      0,      0,      0,      0, 
   725,    725,    725,    725,   1664,   1664,   1664,   1664, 
  6872,   6872,   6872,   6872,  15773,  15773,  15773,  15773, 
  1315,   1315,   1087,   1087,   1488,   1488,   -881,   -881, 
 12465,  12465,  10303,  10303,  14104,  14104,  -8351,  -8351, 
  -981,    309,  -1323,    163,   1680,    232,   -557,   -258, 
 -9299,   2929, -12540,   1545,  15924,   2199,  -5280,  -2446, 
  3457,  19412,   1296,  12284,      0,      0,      0,      0, 
    36,     36,     36,     36,   1289,   1289,   1289,   1289, 
   341,    341,    341,    341,  12218,  12218,  12218,  12218, 
     6,      6,    791,    791,   1245,   1245,    -75,    -75, 
    57,     57,   7498,   7498,  11801,  11801,   -711,   -711, 
 -1699,    144,  -1657,  -1233,  -1298,    578,    311,  -1060, 
-16104,   1365, -15706, -11687, -12303,   5479,   2948, -10047, 
  3457,  19412,   1135,  10758,      0,      0,      0,      0, 
 -1443,  -1443,  -1443,  -1443,   1628,   1628,   1628,   1628, 
-13678, -13678, -13678, -13678,  15431,  15431,  15431,  15431, 
  1162,   1162,    -70,    -70,   -875,   -875,   -697,   -697, 
 11014,  11014,   -664,   -664,  -8294,  -8294,  -6607,  -6607, 
   148,   1074,   -403,   1607,    402,   1142,    447,  -1568, 
  1403,  10180,  -3820,  15232,   3810,  10825,   4237, -14863, 
  3457,  19412,  -1529, -14493,      0,      0,      0,      0, 
   172,    172,    172,    172,    781,    781,    781,    781, 
  1630,   1630,   1630,   1630,   7403,   7403,   7403,   7403, 
 -1111,  -1111,   1608,   1608,   -642,   -642,  -1669,  -1669, 
-10531, -10531,  15242,  15242,  -6085,  -6085, -15820, -15820, 
   280,   1191,   -669,    -43,   1508,   -549,  -1677,  -1565, 
  2654,  11289,  -6341,   -408,  14294,  -5204, -15896, -14834, 
  3457,  19412,   1155,  10948,      0,      0,      0,      0, 
  1172,   1172,   1172,   1172,     96,     96,     96,     96, 
 11109,  11109,  11109,  11109,    910,    910,    910,    910, 
  1475,   1475,    286,    286,    118,    118,    576,    576, 
 13981,  13981,   2711,   2711,   1118,   1118,   5460,   5460, 
   936,  -1056,    628,  -1329,    300,   1523,     24,   -293, 
  8872, -10010,   5953, -12597,   2844,  14436,    227,  -2777, 
  3457,  19412,   -773,  -7327,      0,      0,      0,      0, 
   268,    268,    268,    268,   -391,   -391,   -391,   -391, 
  2540,   2540,   2540,   2540,  -3706,  -3706,  -3706,  -3706, 
  1032,   1032,   1229,   1229,   -194,   -194,    928,    928, 
  9782,   9782,  11649,  11649,  -1839,  -1839,   8796,   8796, 
    67,   -962,  -1654,    891,    509,    844,    179,  -1177, 
   635,  -9119, -15678,   8446,   4825,   8000,   1697, -11156, 
  3457,  19412,    976,   9251,      0,      0,      0,      0, 
   445,    445,    445,    445,    473,    473,    473,    473, 
  4218,   4218,   4218,   4218,   4483,   4483,   4483,   4483, 
   104,    104,   1035,   1035,    838,    838,  -1300,  -1300, 
   986,    986,   9810,   9810,   7943,   7943, -12322, -12322, 
   372,    644,   1136,  -1193,    917,   -680,  -1586,    637, 
  3526,   6104,  10768, -11308,   8692,  -6446, -15033,   6038, 
  3457,  19412,    556,   5270,      0,      0,      0,      0, 
  -264,   -264,   -264,   -264,   -234,   -234,   -234,   -234, 
 -2502,  -2502,  -2502,  -2502,  -2218,  -2218,  -2218,  -2218, 
  1704,   1704,    -61,    -61,    966,    966,   -558,   -558, 
 16152,  16152,   -578,   -578,   9156,   9156,  -5289,  -5289, 
  1046,    770,   -746,    753,  -1083,    690,   1711,   1438, 
  9915,   7299,  -7071,   7137, -10265,   6540,  16218,  13630, 
  3457,  19412,   -420,  -3981,      0,      0,      0,      0, 
   211,    211,    211,    211,    737,    737,    737,    737, 
  2000,   2000,   2000,   2000,   6986,   6986,   6986,   6986, 
  1593,   1593,    862,    862,    404,    404,   -899,   -899, 
 15100,  15100,   8171,   8171,   3829,   3829,  -8521,  -8521, 
  -553,   -883,   1062,   1727,    133,    825,   1670,     66, 
 -5242,  -8370,  10066,  16370,   1261,   7820,  15829,    626, 
  3457,  19412,   -467,  -4427,      0,      0,      0,      0, 
  1292,   1292,   1292,   1292,  -1369,  -1369,  -1369,  -1369, 
 12247,  12247,  12247,  12247, -12976, -12976, -12976, -12976, 
  -965,   -965,   1266,   1266,  -1460,  -1460,    -37,    -37, 
 -9147,  -9147,  12000,  12000, -13839, -13839,   -351,   -351, 
   593,   1547,    324,   1230,   1564,   1072,   -428,   1192, 
  5621,  14664,   3071,  11659,  14825,  10161,  -4057,  11299, 
  3457,  19412,  -1612, -15280,      0,      0,      0,      0, 
 -1085,  -1085,  -1085,  -1085,   -726,   -726,   -726,   -726, 
-10284, -10284, -10284, -10284,  -6882,  -6882,  -6882,  -6882, 
   942,    942,   -265,   -265,  -1584,  -1584,  -1404,  -1404, 
  8929,   8929,  -2512,  -2512, -15014, -15014, -13308, -13308, 
  1686,   1023,    688,   -333,  -1587,    -71,    841,    824, 
 15981,   9697,   6521,  -3156, -15043,   -673,   7972,   7810, 
  3457,  19412,  -1145, -10853,      0,      0,      0,      0, 
   566,    566,    566,    566,   -284,   -284,   -284,   -284, 
  5365,   5365,   5365,   5365,  -2692,  -2692,  -2692,  -2692, 
  -787,   -787,   -619,   -619,    905,    905,   1195,   1195, 
 -7460,  -7460,  -5867,  -5867,   8578,   8578,  11327,  11327, 
  -389,   1148,    522,   -323,   -169,   1343,   1231,    384, 
 -3687,  10882,   4948,  -3062,  -1602,  12730,  11668,   3640
};

const int16_t zetas2_mul[296] __attribute__((aligned(16))) = {
   3457, -12929,   -147,      0,      0,      0,      0,      0,
  -1323,    163,    309,    981,   -557,   -258,    232,  -1680, 
   1323,   -163,   -309,   -981,    557,    258,   -232,   1680, 
  -1657,  -1233,    144,   1699,    311,  -1060,    578,   1298, 
   1657,   1233,   -144,  -1699,   -311,   1060,   -578,  -1298, 
   -403,   1607,   1074,   -148,    447,  -1568,   1142,   -402, 
	403,  -1607,  -1074,    148,   -447,   1568,  -1142,    402, 
  -1412,   -623,    855,    365,    -98,   -244,    407,   1225, 
   1412,    623,   -855,   -365,     98,    244,   -407,  -1225, 
	416,    683,   -105,   1714,  -1019,   1061,   1163,    638, 
   -416,   -683,    105,  -1714,   1019,  -1061,  -1163,   -638, 
	798,   1493,   -351,    396,   -542,     -9,   1616,   -139, 
   -798,  -1493,    351,   -396,    542,      9,  -1616,    139, 
   -987,   -482,    889,    238,  -1513,    466,  -1089,   -101, 
	987,    482,   -889,   -238,   1513,   -466,   1089,    101, 
	849,   -426,   1589,   1487,    671,   1459,   -776,    255, 
   -849,    426,  -1589,  -1487,   -671,  -1459,    776,   -255, 
  -1014,   1144,    472,  -1153,   -325,   1519,    -26,  -1123, 
   1014,  -1144,   -472,   1153,    325,  -1519,     26,   1123, 
	324,   1230,   1547,   -593,   -428,   1192,   1072,  -1564, 
   -324,  -1230,  -1547,    593,    428,  -1192,  -1072,   1564, 
	688,   -333,   1023,  -1686,    841,    824,    -71,   1587, 
   -688,    333,  -1023,   1686,   -841,   -824,     71,  -1587, 
	522,   -323,   1148,    389,   1231,    384,   1343,    169, 
   -522,    323,  -1148,   -389,  -1231,   -384,  -1343,   -169, 
	628,  -1329,  -1056,   -936,     24,   -293,   1523,   -300, 
   -628,   1329,   1056,    936,    -24,    293,  -1523,    300, 
  -1654,    891,   -962,    -67,    179,  -1177,    844,   -509, 
   1654,   -891,    962,     67,   -179,   1177,   -844,    509, 
  -1677,  -1565,   -549,  -1508,   1191,   -280,    -43,    669, 
   1677,   1565,    549,   1508,  -1191,    280,     43,   -669, 
   -746,    753,    770,  -1046,   1711,   1438,    690,   1083, 
	746,   -753,   -770,   1046,  -1711,  -1438,   -690,  -1083, 
   1062,   1727,   -883,    553,   1670,     66,    825,   -133, 
  -1062,  -1727,    883,   -553,  -1670,    -66,   -825,    133, 
  -1586,    637,   -680,   -917,    644,   -372,  -1193,  -1136, 
   1586,   -637,    680,    917,   -644,    372,   1193,   1136 
};

const int16_t zetas2_inv[1048] __attribute__((aligned(16))) = {
   3457,  19412,  -1145, -10853,      0,      0,      0,      0,
	384,   1231,   1343,   -169,   -323,    522,   1148,   -389,
   3640,  11668,  12730,  -1602,  -3062,   4948,  10882,  -3687,
   1195,   1195,    905,    905,   -619,   -619,   -787,   -787,
  11327,  11327,   8578,   8578,  -5867,  -5867,  -7460,  -7460,
   -284,   -284,   -284,   -284,    566,    566,    566,    566,
  -2692,  -2692,  -2692,  -2692,   5365,   5365,   5365,   5365,
   3457,  19412,  -1612, -15280,      0,      0,      0,      0,
	824,    841,    -71,  -1587,   -333,    688,   1023,   1686,
   7810,   7972,   -673, -15043,  -3156,   6521,   9697,  15981,
  -1404,  -1404,  -1584,  -1584,   -265,   -265,    942,    942,
 -13308,- 13308, -15014, -15014,  -2512,  -2512,   8929,   8929,
   -726,   -726,   -726,   -726,  -1085,  -1085,  -1085,  -1085,
  -6882,  -6882,  -6882,  -6882, -10284, -10284, -10284, -10284,
   3457,  19412,   -467,  -4427,      0,      0,      0,      0,
   1192,   -428,   1072,   1564,   1230,    324,   1547,    593,
  11299,  -4057,  10161,  14825,  11659,   3071,  14664,   5621,
	-37,    -37,  -1460,  -1460,   1266,   1266,   -965,   -965,
   -351,   -351, -13839, -13839,  12000,  12000,  -9147,  -9147,
  -1369,  -1369,  -1369,  -1369,   1292,   1292,   1292,   1292,
 -12976, -12976, -12976, -12976,  12247,  12247,  12247,  12247,
   3457,  19412,   -420,  -3981,      0,      0,      0,      0,
	 66,   1670,    825,    133,   1727,   1062,   -883,   -553,
	626,  15829,   7820,   1261,  16370,  10066,  -8370,  -5242,
   -899,   -899,    404,    404,    862,    862,   1593,   1593,
  -8521,  -8521,   3829,   3829,   8171,   8171,  15100,  15100,
	737,    737,    737,    737,    211,    211,    211,    211,
   6986,   6986,   6986,   6986,   2000,   2000,   2000,   2000,
   3457,  19412,    556,   5270,      0,      0,      0,      0,
   1438,   1711,    690,  -1083,    753,   -746,    770,   1046,
  13630,  16218,   6540, -10265,   7137,  -7071,   7299,   9915,
   -558,   -558,    966,    966,    -61,    -61,   1704,   1704,
  -5289,  -5289,   9156,   9156,   -578,   -578,  16152,  16152,
   -234,   -234,   -234,   -234,   -264,   -264,   -264,   -264,
  -2218,  -2218,  -2218,  -2218,  -2502,  -2502,  -2502,  -2502,
   3457,  19412,    976,   9251,      0,      0,      0,      0,
	637,  -1586,   -680,    917,  -1193,   1136,    644,    372,
   6038, -15033,  -6446,   8692, -11308,  10768,   6104,   3526,
  -1300,  -1300,    838,    838,   1035,   1035,    104,    104,
 -12322,- 12322,   7943,   7943,   9810,   9810,    986,    986,
	473,    473,    473,    473,    445,    445,    445,    445,
   4483,   4483,   4483,   4483,   4218,   4218,   4218,   4218,
   3457,  19412,   -773,  -7327,      0,      0,      0,      0,
  -1177,    179,    844,    509,    891,  -1654,   -962,     67,
 -11156,   1697,   8000,   4825,   8446, -15678,  -9119,    635,
	928,    928,   -194,   -194,   1229,   1229,   1032,   1032,
   8796,   8796,  -1839,  -1839,  11649,  11649,   9782,   9782,
   -391,   -391,   -391,   -391,    268,    268,    268,    268,
  -3706,  -3706,  -3706,  -3706,   2540,   2540,   2540,   2540,
   3457,  19412,   1155,  10948,      0,      0,      0,      0,
   -293,     24,   1523,    300,  -1329,    628,  -1056,    936,
  -2777,    227,  14436,   2844, -12597,   5953, -10010,   8872,
	576,    576,    118,    118,    286,    286,   1475,   1475,
   5460,   5460,   1118,   1118,   2711,   2711,  13981,  13981,
	 96,     96,     96,     96,   1172,   1172,   1172,   1172,
	910,    910,    910,    910,  11109,  11109,  11109,  11109,
   3457,  19412,  -1529, -14493,      0,      0,      0,      0,
  -1565,  -1677,   -549,   1508,    -43,   -669,   1191,    280,
 -14834, -15896,  -5204,  14294,   -408,  -6341,  11289,   2654,
  -1669,  -1669,   -642,   -642,   1608,   1608,  -1111,  -1111,
 -15820,- 15820,  -6085,  -6085,  15242,  15242, -10531, -10531,
	781,    781,    781,    781,    172,    172,    172,    172,
   7403,   7403,   7403,   7403,   1630,   1630,   1630,   1630,
   3457,  19412,   1135,  10758,      0,      0,      0,      0,
  -1568,    447,   1142,    402,   1607,   -403,   1074,    148,
 -14863,   4237,  10825,   3810,  15232,  -3820,  10180,   1403,
   -697,   -697,   -875,   -875,    -70,    -70,   1162,   1162,
  -6607,  -6607,  -8294,  -8294,   -664,   -664,  11014,  11014,
   1628,   1628,   1628,   1628,  -1443,  -1443,  -1443,  -1443,
  15431,  15431,  15431,  15431, -13678, -13678, -13678, -13678,
   3457,  19412,   1296,  12284,      0,      0,      0,      0,
  -1060,    311,    578,  -1298,  -1233,  -1657,    144,  -1699,
 -10047,   2948,   5479, -12303, -11687, -15706,   1365, -16104,
	-75,    -75,   1245,   1245,    791,    791,      6,      6,
   -711,   -711,  11801,  11801,   7498,   7498,     57,     57,
   1289,   1289,   1289,   1289,     36,     36,     36,     36,
  12218,  12218,  12218,  12218,    341,    341,    341,    341,
   3457,  19412,    161,   1526,      0,      0,      0,      0,
   -258,   -557,    232,   1680,    163,  -1323,    309,   -981,
  -2446,  -5280,   2199,  15924,   1545, -12540,   2929,  -9299,
   -881,   -881,   1488,   1488,   1087,   1087,   1315,   1315,
  -8351,  -8351,  14104,  14104,  10303,  10303,  12465,  12465,
   1664,   1664,   1664,   1664,    725,    725,    725,    725,
  15773,  15773,  15773,  15773,   6872,   6872,   6872,   6872,
   3457,  19412,   1307,  12389,      0,      0,      0,      0,
   1459,    671,   -776,   -255,   -426,    849,   1589,  -1487,
  13829,   6360,  -7356,  -2417,  -4038,   8047,  15062, -14095,
	831,    831,   -658,   -658,  -1712,  -1712,  -1311,  -1311,
   7877,   7877,  -6237,  -6237, -16228, -16228, -12427, -12427,
	839,    839,    839,    839,    592,    592,    592,    592,
   7953,   7953,   7953,   7953,   5611,   5611,   5611,   5611,
   3457,  19412,   1200,  11374,      0,      0,      0,      0,
	466,  -1513,  -1089,    101,   -482,   -987,    889,   -238,
   4417, -14341, -10322,    957,  -4569,  -9356,   8427,  -2256,
	635,    635,   -170,   -170,   -705,   -705,   1332,   1332,
   6019,   6019,  -1611,  -1611,  -6683,  -6683,  12626,  12626,
   1244,   1244,   1244,   1244,    783,    783,    783,    783,
  11792,  11792,  11792,  11792,   7422,   7422,   7422,   7422,
   3457,  19412,   -107,  -1014,      0,      0,      0,      0,
   1144,  -1014,    472,   1153,    -26,   1123,   -325,  -1519,
  10844,  -9611,   4474,  10929,   -246,  10645,  -3081, -14398,
   1467,   1467,  -1536,  -1536,   -676,   -676,   1542,   1542,
  13905,  13905, -14559, -14559,  -6408,  -6408,  14616,  14616,
   1622,   1622,   1622,   1622,   -652,   -652,   -652,   -652,
  15375,  15375,  15375,  15375,  -6180,  -6180,  -6180,  -6180,
   3457,  19412,    570,   5403,      0,      0,      0,      0,
   1061,  -1019,   1163,   -638,    683,    416,   -105,  -1714,
  10057,  -9659,  11024,  -6047,   6474,   3943,   -995, -16247,
   1261,   1261,   -882,   -882,    206,    206,   -654,   -654,
  11953,  11953,  -8360,  -8360,   1953,   1953,  -6199,  -6199,
	 99,     99,     99,     99,   -952,   -952,   -952,   -952,
	938,    938,    938,    938,  -9024,  -9024,  -9024,  -9024,
   3457,  19412,    727,   6891,      0,      0,      0,      0,
   -244,    -98,    407,  -1225,   -623,  -1412,    855,   -365,
  -2313,   -929,   3858, -11611,  -5905, -13384,   8104,  -3460,
   -767,   -767,    287,    287,   -945,   -945,  -1598,  -1598,
  -7270,  -7270,   2720,   2720,  -8957,  -8957, -15147, -15147,
   -599,   -599,   -599,   -599,  -1119,  -1119,  -1119,  -1119,
  -5678,  -5678,  -5678,  -5678, -10607, -10607, -10607, -10607,
   3457,  19412,    157,   1488,      0,      0,      0,      0,
   1493,    798,   -351,   -396,   1616,    139,   -542,      9,
  14152,   7564,  -3327,  -3754,  15318,   1318,  -5137,     85,
	716,    716,   1251,   1251,  -1421,  -1421,     81,     81,
   6787,   6787,  11858,  11858, -13469, -13469,    768,    768,
  -1020,  -1020,  -1020,  -1020,   -353,   -353,   -353,   -353,
  -9668,  -9668,  -9668,  -9668,  -3346,  -3346,  -3346,  -3346,
   3457,  19412,   -723,  -6853,    298,   2825,  -1078, -10218,
  -1556, -14749,   1236,  11716,    909,   8616,     58,    550,
   1722,  16322,   -822,  -7792,   1078,  10218,    532,   5043,
	450,   4265,  -1463, -13867,    867,   8218,   1520,  14408,
  -1520, -14408,   1124,  10654,   1634,  15488,  -1693, -16048, 
};


const int16_t crep[56] __attribute__((aligned(16))) = {
    3457, 3457, 3457, 3457, 3457, 3457, 3457, 3457, 
	1728, 1728, 1728, 1728, 1728, 1728, 1728, 1728, 
	1729, 1729, 1729, 1729, 1729, 1729, 1729, 1729, 
	 255,  255,  255,  255,  255,  255,  255,  255,
	  15,   15,   15,   15,   15,   15,   15,   15,
	   3,    3,    3,    3,    3,    3,    3,    3,
	   1,    1,    1,    1,    1,    1,    1,    1	   
};

const int16_t mask[8] __attribute__((aligned(16))) = {
    0xfff, 0xfff, 0xfff, 0xfff, 0xfff, 0xfff, 0xfff, 0xfff   
};

const int16_t qs[8] __attribute__((aligned(16))) = {
    3457, 3457, 3457, 3457, 3457, 3457, 3457, 3457   
};

const int16_t ones[8] __attribute__((aligned(16))) = {
    1, 1, 1, 1, 1, 1, 1, 1   
};

/*************************************************
* Name:        poly_tobytes
*
* Description: Serialization of a polynomial
*
* Arguments:   - uint8_t *r: pointer to output byte array
*                            (needs space for NTRUPLUS_POLYBYTES bytes)
*              - poly *a:    pointer to input polynomial
**************************************************/
void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a)
{
	poly t;

	poly_shuffle2(&t,a);
	poly_tobytes_asm(r, &t, qs);
}

/*************************************************
* Name:        poly_frombytes
*
* Description: De-serialization of a polynomial;
*              inverse of poly_tobytes
*
* Arguments:   - poly *r:          pointer to output polynomial
*              - const uint8_t *a: pointer to input byte array
*                                  (of NTRUPLUS_POLYBYTES bytes)
**************************************************/
void poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES])
{
	poly_frombytes_asm(r, a, mask);
	poly_shuffle(r, r); 
}

/*************************************************
* Name:        poly_cbd1
*
* Description: Sample a polynomial deterministically from a random,
*              with output polynomial close to centered binomial distribution
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *buf: pointer to input random
*                                     (of length NTRUPLUS_N/4 bytes)
**************************************************/
void poly_cbd1(poly *r, const uint8_t buf[NTRUPLUS_N/4])
{
	poly_cbd1_asm(r,buf, ones);
}

/*************************************************
* Name:        poly_sotp
*
* Description: Encode a message deterministically using SOTP and a random,
			   with output polynomial close to centered binomial distribution
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *msg: pointer to input message
*              - const uint8_t *buf: pointer to input random
**************************************************/
void poly_sotp(poly *r, const uint8_t *msg, const uint8_t *buf)
{
	poly_sotp_asm(r, msg, buf, ones);
}

/*************************************************
* Name:        poly_sotp_inv
*
* Description: Decode a message deterministically using SOTP_INV and a random
*
* Arguments:   - uint8_t *msg: pointer to output message
*              - const poly *a: pointer to iput polynomial
*              - const uint8_t *buf: pointer to input random
*
* Returns 0 (success) or 1 (failure)
**************************************************/
int poly_sotp_inv(uint8_t *msg, const poly *a, const uint8_t *buf)
{
	return poly_sotp_inv_asm(msg, a, buf, ones);
}
/*************************************************
* Name:        poly_ntt
*
* Description: Computes number-theoretic transform (NTT)
*
* Arguments:   - poly *r: pointer to output polynomial
*              - poly *a: pointer to input polynomial
**************************************************/
void poly_ntt(poly *r, const poly *a)
{
	poly_ntt_asm(r, a, zetas2);
}
/*************************************************
* Name:        poly_invntt
*
* Description: Computes inverse of number-theoretic transform (NTT)
*
* Arguments:   - poly *r: pointer to output polynomial
*              - poly *a: pointer to input polynomial
**************************************************/
void poly_invntt(poly *r, const poly *a)
{
	poly_invntt_asm(r, a, zetas2_inv);
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inversion of polynomial in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to input polynomial
* 
* Returns:     integer
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
	return poly_baseinv_asm(r, a, zetas2_mul);
}

/*************************************************
* Name:        poly_basemul
*
* Description: Multiplication of two polynomials in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to first input polynomial
*              - const poly *b: pointer to second input polynomial
**************************************************/
void poly_basemul(poly *r, const poly *a, const poly *b)
{
	poly_basemul_asm(r, a, b, zetas2_mul);
}
/*************************************************
* Name:        poly_basemul_add
*
* Description: Multiplication then addition of three polynomials in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to first input polynomial
*              - const poly *b: pointer to second input polynomial
*              - const poly *c: pointer to third input polynomial
**************************************************/
void poly_basemul_add(poly *r, const poly *a, const poly *b, const poly *c)
{
	poly_basemul_add_asm(r, a, b, c, zetas2_mul);
}

/*************************************************
* Name:        poly_crepmod3
*
* Description: Compute modulus 3 operation to polynomial
*
* Arguments: - poly *r: pointer to output polynomial
*            - const poly *a: pointer to input polynomial
**************************************************/
void poly_crepmod3(poly *r, const poly* a)
{
	poly_crepmod3_asm(r, a, crep);
}
