#include <stdint.h>
#include "params.h"

const int16_t zetas[944] __attribute__((aligned(32))) = {
	13687,  13687,  -1033,  -1033,  28815,  28815,  -1265,  -1265,
   -21308, -21308,    708,    708, -16436, -16436,    460,    460,
   -28815, -28815,   1265,   1265,  -8531,  -8531,   -467,   -467,
	27735,  27735,    727,    727, -20436, -20436,    556,    556,
   -10085, -10085,   1307,   1307, -32645, -32645,   -773,   -773,
	15583,  15583,   -161,   -161, -17232, -17232,   1200,   1200,
	-1100,  -1100,  -1612,  -1612,  29498,  29498,    570,    570,
   -23431, -23431,   1529,   1529,  -5649,  -5649,   1135,   1135,
	20436,  20436,   -556,   -556,      0,      0,      0,      0,
		0,      0,      0,      0,      0,      0,      0,      0,
	-2976,  -2976,  -2976,  -2976,  -2976,  -2976,  -2976,  -2976,
   -13782, -13782, -13782, -13782, -13782, -13782, -13782, -13782,
	 1120,   1120,   1120,   1120,   1120,   1120,   1120,   1120,
	  298,    298,    298,    298,    298,    298,    298,    298,
   -10806, -10806, -10806, -10806, -10806, -10806, -10806, -10806,
	 2028,   2028,   2028,   2028,   2028,   2028,   2028,   2028,
	 -822,   -822,   -822,   -822,   -822,   -822,   -822,   -822,
	-1556,  -1556,  -1556,  -1556,  -1556,  -1556,  -1556,  -1556,
   -22749, -22749, -22749, -22749, -22749, -22749, -22749, -22749,
   -24777, -24777, -24777, -24777, -24777, -24777, -24777, -24777,
	  -93,    -93,    -93,    -93,    -93,    -93,    -93,    -93,
	 1463,   1463,   1463,   1463,   1463,   1463,   1463,   1463,
	-3052,  -3052,  -3052,  -3052,  -3052,  -3052,  -3052,  -3052,
   -24569, -24569, -24569, -24569, -24569, -24569, -24569, -24569,
	  532,    532,    532,    532,    532,    532,    532,    532,
	 -377,   -377,   -377,   -377,   -377,   -377,   -377,   -377,
   -21517, -21517, -21517, -21517, -21517, -21517, -21517, -21517,
	28986,  28986,  28986,  28986,  28986,  28986,  28986,  28986,
	 -909,   -909,   -909,   -909,   -909,   -909,   -909,   -909,
	   58,     58,     58,     58,     58,     58,     58,     58,
   -21896, -21896, -21896, -21896, -21896, -21896, -21896, -21896,
	14654,  14654,  14654,  14654,  14654,  14654,  14654,  14654,
	 -392,   -392,   -392,   -392,   -392,   -392,   -392,   -392,
	 -450,   -450,   -450,   -450,   -450,   -450,   -450,   -450,
   -18502, -18502, -18502, -18502, -18502, -18502, -18502, -18502,
   -10540, -10540, -10540, -10540, -10540, -10540, -10540, -10540,
	 1722,   1722,   1722,   1722,   1722,   1722,   1722,   1722,
	 1236,   1236,   1236,   1236,   1236,   1236,   1236,   1236,
	 7962,   7962,   7962,   7962,   7962,   7962,   7962,   7962,
	 8853,   8853,   8853,   8853,   8853,   8853,   8853,   8853,
	 -486,   -486,   -486,   -486,   -486,   -486,   -486,   -486,
	 -491,   -491,   -491,   -491,   -491,   -491,   -491,   -491,
	30559,  30559,  30559,  30559,  30559,  30559,  30559,  30559,
	21706,  21706,  21706,  21706,  21706,  21706,  21706,  21706,
	-1569,  -1569,  -1569,  -1569,  -1569,  -1569,  -1569,  -1569,
	-1078,  -1078,  -1078,  -1078,  -1078,  -1078,  -1078,  -1078,
	 6692,   6692,   6692,   6692,  19337,  19337,  19337,  19337,
	21213,  21213,  21213,  21213,  11356,  11356,  11356,  11356,
	   36,     36,     36,     36,   1289,   1289,   1289,   1289,
	-1443,  -1443,  -1443,  -1443,   1628,   1628,   1628,   1628,
	18048,  18048,  18048,  18048,  -1877,  -1877,  -1877,  -1877,
	12360,  12360,  12360,  12360, -30749, -30749, -30749, -30749,
	 1664,   1664,   1664,   1664,   -725,   -725,   -725,   -725,
	 -952,   -952,   -952,   -952,     99,     99,     99,     99,
   -14844, -14844, -14844, -14844, -23583, -23583, -23583, -23583,
   -11223, -11223, -11223, -11223, -15905, -15905, -15905, -15905,
	-1020,  -1020,  -1020,  -1020,    353,    353,    353,    353,
	 -599,   -599,   -599,   -599,   1119,   1119,   1119,   1119,
   -13744, -13744, -13744, -13744, -31545, -31545, -31545, -31545,
	 -682,   -682,   -682,   -682, -24436, -24436, -24436, -24436,
	  592,    592,    592,    592,    839,    839,    839,    839,
	 1622,   1622,   1622,   1622,    652,    652,    652,    652,
	27356,  27356,  27356,  27356, -30863, -30863, -30863, -30863,
	-3261,  -3261,  -3261,  -3261, -14806, -14806, -14806, -14806,
	 1244,   1244,   1244,   1244,   -783,   -783,   -783,   -783,
	-1085,  -1085,  -1085,  -1085,   -726,   -726,   -726,   -726,
   -22218, -22218, -22218, -22218,  -1820,  -1820,  -1820,  -1820,
	-5081,  -5081,  -5081,  -5081,   7412,   7412,   7412,   7412,
	  566,    566,    566,    566,   -284,   -284,   -284,   -284,
	-1369,  -1369,  -1369,  -1369,  -1292,  -1292,  -1292,  -1292,
	-8436,  -8436,  -8436,  -8436,  -8967,  -8967,  -8967,  -8967,
	 5005,   5005,   5005,   5005,   4436,   4436,   4436,   4436,
	  268,    268,    268,    268,   -391,   -391,   -391,   -391,
	  781,    781,    781,    781,   -172,   -172,   -172,   -172,
	-4000,  -4000,  -4000,  -4000, -13972, -13972, -13972, -13972,
   -24493, -24493, -24493, -24493,  25953,  25953,  25953,  25953,
	   96,     96,     96,     96,  -1172,  -1172,  -1172,  -1172,
	  211,    211,    211,    211,    737,    737,    737,    737,
	20569,  20569,  20569,  20569,  13763,  13763,  13763,  13763,
   -10730, -10730, -10730, -10730,   5384,   5384,   5384,   5384,
	  473,    473,    473,    473,   -445,   -445,   -445,   -445,
	 -234,   -234,   -234,   -234,    264,    264,    264,    264,
	-1536,  -1536,  26939,  26939, -23716, -23716, -13574, -13574,
	30294,  30294,  17915,  17915,  -5441,  -5441,  14540,  14540,
	-1536,  -1536,   1467,   1467,   -676,   -676,  -1542,  -1542,
	 -170,   -170,    635,    635,   -705,   -705,  -1332,  -1332,
	12398,  12398,  -3905,  -3905,  16720,  16720, -23905, -23905,
   -29232, -29232,  12815,  12815,  29119,  29119, -27811, -27811,
	 -658,   -658,    831,    831,  -1712,  -1712,   1311,   1311,
	 1488,   1488,   -881,   -881,   1087,   1087,  -1315,  -1315,
   -25251, -25251,  13365,  13365,   3223,   3223, -12038, -12038,
	24853,  24853,  32455,  32455,  12474,  12474, -15754, -15754,
	 1245,   1245,    -75,    -75,    791,    791,     -6,     -6,
	 -875,   -875,   -697,   -697,    -70,    -70,  -1162,  -1162,
   -24929, -24929, -20607, -20607, -28209, -28209,  16702,  16702,
	 -114,   -114, -14995, -14995, -23602, -23602,   1422,   1422,
	  287,    287,   -767,   -767,   -945,   -945,   1598,   1598,
	 -882,   -882,   1261,   1261,    206,    206,    654,    654,
   -22029, -22029,   1327,   1327,  16588,  16588,  13213,  13213,
	21062,  21062, -30484, -30484,  12171,  12171,  31640,  31640,
	-1421,  -1421,    -81,    -81,    716,    716,  -1251,  -1251,
	  838,    838,  -1300,  -1300,   1035,   1035,   -104,   -104,
   -27962, -27962,  -5422,  -5422,  -2237,  -2237, -10920, -10920,
   -19564, -19564, -23299, -23299,   3678,   3678, -17593, -17593,
	  966,    966,   -558,   -558,    -61,    -61,  -1704,  -1704,
	  404,    404,   -899,   -899,    862,    862,  -1593,  -1593,
	-1972,  -1972, -19621, -19621, -15886, -15886,  24645,  24645,
   -32304, -32304,   1156,   1156, -18313, -18313,  10578,  10578,
	-1460,  -1460,    -37,    -37,   1266,   1266,    965,    965,
	-1584,  -1584,  -1404,  -1404,   -265,   -265,   -942,   -942,
   -30199, -30199, -16341, -16341,  -7659,  -7659,  17043,  17043,
	18294,  18294, -24000, -24000,  27678,  27678,    701,    701,
	  905,    905,   1195,   1195,   -619,   -619,    787,    787,
	  118,    118,    576,    576,    286,    286,  -1475,  -1475,
   -17858, -17858,   5024,   5024,  30029,  30029,  26616,  26616,
	14920,  14920,  11735,  11735, -17157, -17157, -22654, -22654,
	 -194,   -194,    928,    928,   1229,   1229,  -1032,  -1032,
	 1608,   1608,   1111,   1111,  -1669,  -1669,    642,    642
};

const int16_t zetas_inv[936] __attribute__((aligned(32))) = {
	  22654,  22654,  17157,  17157, -11735, -11735, -14920, -14920,
	 -26616, -26616, -30029, -30029,  -5024,  -5024,  17858,  17858,
	   -642,   -642,   1669,   1669,  -1111,  -1111,  -1608,  -1608,
	   1032,   1032,  -1229,  -1229,   -928,   -928,    194,    194,
	   -701,   -701, -27678, -27678,  24000,  24000, -18294, -18294,
	 -17043, -17043,   7659,   7659,  16341,  16341,  30199,  30199,
	   1475,   1475,   -286,   -286,   -576,   -576,   -118,   -118,
	   -787,   -787,    619,    619,  -1195,  -1195,   -905,   -905,
	 -10578, -10578,  18313,  18313,  -1156,  -1156,  32304,  32304,
	 -24645, -24645,  15886,  15886,  19621,  19621,   1972,   1972,
	    942,    942,    265,    265,   1404,   1404,   1584,   1584,
	   -965,   -965,  -1266,  -1266,     37,     37,   1460,   1460,
	  17593,  17593,  -3678,  -3678,  23299,  23299,  19564,  19564,
	  10920,  10920,   2237,   2237,   5422,   5422,  27962,  27962,
	   1593,   1593,   -862,   -862,    899,    899,   -404,   -404,
	   1704,   1704,     61,     61,    558,    558,   -966,   -966,
	 -31640, -31640, -12171, -12171,  30484,  30484, -21062, -21062,
	 -13213, -13213, -16588, -16588,  -1327,  -1327,  22029,  22029,
	    104,    104,  -1035,  -1035,   1300,   1300,   -838,   -838,
	   1251,   1251,   -716,   -716,     81,     81,   1421,   1421,
	  -1422,  -1422,  23602,  23602,  14995,  14995,    114,    114,
	 -16702, -16702,  28209,  28209,  20607,  20607,  24929,  24929,
	   -654,   -654,   -206,   -206,  -1261,  -1261,    882,    882,
	  -1598,  -1598,    945,    945,    767,    767,   -287,   -287,
	  15754,  15754, -12474, -12474, -32455, -32455, -24853, -24853,
	  12038,  12038,  -3223,  -3223, -13365, -13365,  25251,  25251,
	   1162,   1162,     70,     70,    697,    697,    875,    875,
	      6,      6,   -791,   -791,     75,     75,  -1245,  -1245,
	  27811,  27811, -29119, -29119, -12815, -12815,  29232,  29232,
	  23905,  23905, -16720, -16720,   3905,   3905, -12398, -12398,
	   1315,   1315,  -1087,  -1087,    881,    881,  -1488,  -1488,
	  -1311,  -1311,   1712,   1712,   -831,   -831,    658,    658,
	 -14540, -14540,   5441,   5441, -17915, -17915, -30294, -30294,
	  13574,  13574,  23716,  23716, -26939, -26939,   1536,   1536,
	   1332,   1332,    705,    705,   -635,   -635,    170,    170,
	   1542,   1542,    676,    676,  -1467,  -1467,   1536,   1536,
	  -5384,  -5384,  -5384,  -5384,  10730,  10730,  10730,  10730,
	 -13763, -13763, -13763, -13763, -20569, -20569, -20569, -20569,
	   -264,   -264,   -264,   -264,    234,    234,    234,    234,
	    445,    445,    445,    445,   -473,   -473,   -473,   -473,
	 -25953, -25953, -25953, -25953,  24493,  24493,  24493,  24493,
	  13972,  13972,  13972,  13972,   4000,   4000,   4000,   4000,
	   -737,   -737,   -737,   -737,   -211,   -211,   -211,   -211,
	   1172,   1172,   1172,   1172,    -96,    -96,    -96,    -96,
	  -4436,  -4436,  -4436,  -4436,  -5005,  -5005,  -5005,  -5005,
	   8967,   8967,   8967,   8967,   8436,   8436,   8436,   8436,
	    172,    172,    172,    172,   -781,   -781,   -781,   -781,
	    391,    391,    391,    391,   -268,   -268,   -268,   -268,
	  -7412,  -7412,  -7412,  -7412,   5081,   5081,   5081,   5081,
	   1820,   1820,   1820,   1820,  22218,  22218,  22218,  22218,
	   1292,   1292,   1292,   1292,   1369,   1369,   1369,   1369,
	    284,    284,    284,    284,   -566,   -566,   -566,   -566,
	  14806,  14806,  14806,  14806,   3261,   3261,   3261,   3261,
	  30863,  30863,  30863,  30863, -27356, -27356, -27356, -27356,
	    726,    726,    726,    726,   1085,   1085,   1085,   1085,
	    783,    783,    783,    783,  -1244,  -1244,  -1244,  -1244,
	  24436,  24436,  24436,  24436,    682,    682,    682,    682,
	  31545,  31545,  31545,  31545,  13744,  13744,  13744,  13744,
	   -652,   -652,   -652,   -652,  -1622,  -1622,  -1622,  -1622,
	   -839,   -839,   -839,   -839,   -592,   -592,   -592,   -592,
	  15905,  15905,  15905,  15905,  11223,  11223,  11223,  11223,
	  23583,  23583,  23583,  23583,  14844,  14844,  14844,  14844,
	  -1119,  -1119,  -1119,  -1119,    599,    599,    599,    599,
	   -353,   -353,   -353,   -353,   1020,   1020,   1020,   1020,
	  30749,  30749,  30749,  30749, -12360, -12360, -12360, -12360,
	   1877,   1877,   1877,   1877, -18048, -18048, -18048, -18048,
	    -99,    -99,    -99,    -99,    952,    952,    952,    952,
	    725,    725,    725,    725,  -1664,  -1664,  -1664,  -1664,
	 -11356, -11356, -11356, -11356, -21213, -21213, -21213, -21213,
	 -19337, -19337, -19337, -19337,  -6692,  -6692,  -6692,  -6692,
	  -1628,  -1628,  -1628,  -1628,   1443,   1443,   1443,   1443,
	  -1289,  -1289,  -1289,  -1289,    -36,    -36,    -36,    -36,
	 -21706, -21706, -21706, -21706, -21706, -21706, -21706, -21706,
	 -30559, -30559, -30559, -30559, -30559, -30559, -30559, -30559,
	   1078,   1078,   1078,   1078,   1078,   1078,   1078,   1078,
	   1569,   1569,   1569,   1569,   1569,   1569,   1569,   1569,
	  -8853,  -8853,  -8853,  -8853,  -8853,  -8853,  -8853,  -8853,
	  -7962,  -7962,  -7962,  -7962,  -7962,  -7962,  -7962,  -7962,
	    491,    491,    491,    491,    491,    491,    491,    491,
	    486,    486,    486,    486,    486,    486,    486,    486,
	  10540,  10540,  10540,  10540,  10540,  10540,  10540,  10540,
	  18502,  18502,  18502,  18502,  18502,  18502,  18502,  18502,
	  -1236,  -1236,  -1236,  -1236,  -1236,  -1236,  -1236,  -1236,
	  -1722,  -1722,  -1722,  -1722,  -1722,  -1722,  -1722,  -1722,
	 -14654, -14654, -14654, -14654, -14654, -14654, -14654, -14654,
	  21896,  21896,  21896,  21896,  21896,  21896,  21896,  21896,
	    450,    450,    450,    450,    450,    450,    450,    450,
	    392,    392,    392,    392,    392,    392,    392,    392,
	 -28986, -28986, -28986, -28986, -28986, -28986, -28986, -28986,
	  21517,  21517,  21517,  21517,  21517,  21517,  21517,  21517,
	    -58,    -58,    -58,    -58,    -58,    -58,    -58,    -58,
	    909,    909,    909,    909,    909,    909,    909,    909,
	  24569,  24569,  24569,  24569,  24569,  24569,  24569,  24569,
	   3052,   3052,   3052,   3052,   3052,   3052,   3052,   3052,
	    377,    377,    377,    377,    377,    377,    377,    377,
	   -532,   -532,   -532,   -532,   -532,   -532,   -532,   -532,
	  24777,  24777,  24777,  24777,  24777,  24777,  24777,  24777,
	  22749,  22749,  22749,  22749,  22749,  22749,  22749,  22749,
	  -1463,  -1463,  -1463,  -1463,  -1463,  -1463,  -1463,  -1463,
	     93,     93,     93,     93,     93,     93,     93,     93,
	  -2028,  -2028,  -2028,  -2028,  -2028,  -2028,  -2028,  -2028,
	  10806,  10806,  10806,  10806,  10806,  10806,  10806,  10806,
	   1556,   1556,   1556,   1556,   1556,   1556,   1556,   1556,
	    822,    822,    822,    822,    822,    822,    822,    822,
	  13782,  13782,  13782,  13782,  13782,  13782,  13782,  13782,
	   2976,   2976,   2976,   2976,   2976,   2976,   2976,   2976,
	   -298,   -298,   -298,   -298,   -298,   -298,   -298,   -298,
	  -1120,  -1120,  -1120,  -1120,  -1120,  -1120,  -1120,  -1120,
	 -15583, -15583,    161,    161, -29744, -29744,    976,    976,
	  -1763,  -1763,    157,    157,  32645,  32645,    773,    773,
	  10085,  10085,  -1307,  -1307,   8531,   8531,    467,    467,
	  23431,  23431,  -1529,  -1529,   5649,   5649,  -1135,  -1135,
	  -9308,  -9308,    420,    420,  17232,  17232,  -1200,  -1200,
	   1100,   1100,   1612,   1612,   1763,   1763,   -157,   -157,
	  -4872,  -4872,    248,    248,  -6938,  -6938,   1510,   1510,
	  29782,  29782,   -682,   -682,   4872,   4872,   -248,   -248,
	 -30977, -30977,  -1665,  -1665,  -1346,  -1346,    -66,    -66
};

const int16_t zetas_mul[288] __attribute__((aligned(32))) = {
	  -1536,   1536,  26939, -26939, -23716,  23716, -13574,  13574,
	  30294, -30294,  17915, -17915,  -5441,   5441,  14540, -14540,
	  -1536,   1536,   1467,  -1467,   -676,    676,  -1542,   1542,
	   -170,    170,    635,   -635,   -705,    705,  -1332,   1332,
	  12398, -12398,  -3905,   3905,  16720, -16720, -23905,  23905,
	 -29232,  29232,  12815, -12815,  29119, -29119, -27811,  27811,
	   -658,    658,    831,   -831,  -1712,   1712,   1311,  -1311,
	   1488,  -1488,   -881,    881,   1087,  -1087,  -1315,   1315,
	 -25251,  25251,  13365, -13365,   3223,  -3223, -12038,  12038,
	  24853, -24853,  32455, -32455,  12474, -12474, -15754,  15754,
	   1245,  -1245,    -75,     75,    791,   -791,     -6,      6,
	   -875,    875,   -697,    697,    -70,     70,  -1162,   1162,
	 -24929,  24929, -20607,  20607, -28209,  28209,  16702, -16702,
	   -114,    114, -14995,  14995, -23602,  23602,   1422,  -1422,
	    287,   -287,   -767,    767,   -945,    945,   1598,  -1598,
	   -882,    882,   1261,  -1261,    206,   -206,    654,   -654,
	 -22029,  22029,   1327,  -1327,  16588, -16588,  13213, -13213,
	  21062, -21062, -30484,  30484,  12171, -12171,  31640, -31640,
	  -1421,   1421,    -81,     81,    716,   -716,  -1251,   1251,
	    838,   -838,  -1300,   1300,   1035,  -1035,   -104,    104,
	 -27962,  27962,  -5422,   5422,  -2237,   2237, -10920,  10920,
	 -19564,  19564, -23299,  23299,   3678,  -3678, -17593,  17593,
	    966,   -966,   -558,    558,    -61,     61,  -1704,   1704,
	    404,   -404,   -899,    899,    862,   -862,  -1593,   1593,
	  -1972,   1972, -19621,  19621, -15886,  15886,  24645, -24645,
	 -32304,  32304,   1156,  -1156, -18313,  18313,  10578, -10578,
	  -1460,   1460,    -37,     37,   1266,  -1266,    965,   -965,
	  -1584,   1584,  -1404,   1404,   -265,    265,   -942,    942,
	 -30199,  30199, -16341,  16341,  -7659,   7659,  17043, -17043,
	  18294, -18294, -24000,  24000,  27678, -27678,    701,   -701,
	    905,   -905,   1195,  -1195,   -619,    619,    787,   -787,
	    118,   -118,    576,   -576,    286,   -286,  -1475,   1475,
	 -17858,  17858,   5024,  -5024,  30029, -30029,  26616, -26616,
	  14920, -14920,  11735, -11735, -17157,  17157, -22654,  22654,
	   -194,    194,    928,   -928,   1229,  -1229,  -1032,   1032,
	   1608,  -1608,   1111,  -1111,  -1669,   1669,    642,   -642
};

#define QINV 12929
#define LOW ((1U << 12) - 1)
#define V ((1U << 26)/NTRUPLUS_Q)

#define WQINV 13706
#define W -886

#define Qm1div2 1728
#define Qp1div2 1729

const uint16_t _low_mask[16] __attribute__((aligned(32))) = {LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW, LOW};
const uint16_t _4x1[4] __attribute__((aligned(32))) = {1, 1, 1, 1};
const uint16_t _4x01[4] __attribute__((aligned(32))) = {1, 0, 0, 0};
const uint32_t _8x1[8] __attribute__((aligned(32))) = {1, 1, 1, 1, 1, 1, 1, 1};

const uint16_t _16xv[16] __attribute__((aligned(32))) = {V, V, V, V, V, V, V, V, V, V, V, V, V, V, V, V};
const uint16_t _16x1[16] __attribute__((aligned(32))) = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
const uint16_t _16x3[36] __attribute__((aligned(32))) = {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3};
const uint16_t _16x15[36] __attribute__((aligned(32))) = {15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15};
const uint16_t _16x255[36] __attribute__((aligned(32))) = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255};
const uint16_t _16xq[16]  __attribute__((aligned(32))) = {NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q, NTRUPLUS_Q};
const uint16_t _16xqm1div2[16]  __attribute__((aligned(32))) = {Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2, Qm1div2};
const uint16_t _16xqp1div2[16]  __attribute__((aligned(32))) = {Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2, Qp1div2};
const uint16_t _16xqinv[16] __attribute__((aligned(32))) = {QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV, QINV};

const uint16_t _16xw[16] __attribute__((aligned(32))) = {W, W, W, W, W, W, W, W, W, W, W, W, W, W, W, W};
const uint16_t _16xwqinv[16] __attribute__((aligned(32))) = {WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV, WQINV};

#undef QINV
#undef LOW
#undef V
#undef WQINV
#undef W
#undef Qm1div2
#undef Qp1div2
