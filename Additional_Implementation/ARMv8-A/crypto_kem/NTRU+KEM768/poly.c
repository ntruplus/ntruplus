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

const int16_t zetas2[416] __attribute__((aligned(16))) = {
    3457,  19412,   -723,  -6853,   -722,  -6844, -1571, -14891,
    -257,  -2436,  -1124, -10654,   1571,  14891,  -682,  -6464,
    1510,  14313,  -1265, -11991,  -1033,  -9792,  -886,  -8398,
	 147,   1393,      0 ,     0,      0,     0 ,     0,      0,

    3457,  19412, 	-1715, -16256, 	-820, -7773, -216, -2047, 
	484, 4588, -429, -4066, 864, 8190, 177, 1678, 
	22, 1709,  -275,  1108, 354,  -1728, -968,  858,
	209,  16199, -2607, 10502, 3355, -16379, -9175, 8133,

	3457,  19412, 	 813, 7706, -121, -1147, -757, -7175,
	 874, 8284, 11, 104, -554, -5251, 1591, 15081, 
	 1221, -218,  294, -732,   -1095, 892,  1588,  -779,  
	 11574,-2066, 2787,-6938,  -10379,8455,15052,-7384,

	 3457,  19412, 	 109, 1033,  -348, -3299, 937, 8882,
	 470, 4455, -888, -8417, 1039, 9848, 729, 6910,
	 1022,  -1063, 1053, 1188, 417, -1391,  -27, -1626,  
	 9687, -10076, 9981, 11261,3953, -13185, -256,-15412,

	 3457,  19412, 	 -1118, -10597,  	 893, 8465, 387, 3668, 
	 963, 9128, -775, -7346, 62, 588, 1045, 9905,
	 1409,1501,  1401,  251,  673, 582,  230, -361,  
	 13356, 14228,13280, 2379, 6379,5517, 2180,-3422,
	
	 3457,  19412, 624, 5915, -603, -5716, 1713, 16237,
	 -115, -1090, -1548, -14673, -291, -2758, -1392, -13194,	  
	 -1550,  1531, -1367,  -124,   1458,  1379, -940,  -1681, 
	 -14692,14512, -12957,-1175,13820, 13071,-8910,-15934,

	 3457,  19412, 704, 6673, -1105, -10474, 1058, 10029, 
	  978, 9270, -1024, -9706, 1603, 15194, -1028, -9744,
	   400, 274,  -1543,  32,   1408, -1248,-315, -1685, 
	   3791, 2597,-14626,303,13346,  -11829, -2986, -15972,

    3457,  19412, 1262, 11962,  -794, -7526, -1339, -12692,
	-380, -3602, -606, -5744, 1293, 12256, 661, 6265, 
	-755,-1295,  795, 631, 108, -410, -1350, 1668,
	-7156, -12275,7536,  5981, 1024, -3886, -12796, 15811,

    3457,  19412, -1590, -15071, -446, -4228, 1181, 11194, 
	1428, 13536, -1580, -14976, -565, -5355, -992, -9403,
	1310, -1004, 910, -1278, -920,  1444,  1129, -765,
	12417,  -9517,8626, -12114, -8720,13687, 10701, -7251,

	3457,  19412, 1611, 15270, 	-1197, -11346, 511, 4844,
	-569, -5393, -1617, -15327, -1530, -14502, 1199, 11365, 
	-1446,  496,  790,  714,  303,  -190,  1398, -1082, 
	-13706,4701,7488,6768,2872,-1801,13251, -10256,

	3457,  19412, 222, 2104, -594, -5630, -1202, -11393, 
	901, 8540, 1637, 15517, 837, 7934, -1449, -13735,
	-742,-128,  -1096,  1600,  1260,  -174,  1535,  -1282, 
	-7033, -1213,-10389,15166,11943,-1649,14550,-12152,

	3457,  19412, 1484, 14066, -137, -1299, 200, 1896,
	176, 1668, -156, -1479, 1257, 11915, -1507, -14284,
	-1176, -529,  872,  1427,  562,  -341,  -111,  -923, 
	-11147,-5014,8265, 13526,5327,-3232,-1052,-8749,
	
	3457,  19412, 256, 2427, -16, -152, 957, 9071, 
		-625, -5924, 4, 38, -830, -7867, -50, -474, 
	415, 25,  -2,  1416,    78,  88, -975,  -1100,
	3934, 237,-19,13422,739, 834,-9242, -10427
};




const int16_t zetas2_mul[400] __attribute__((aligned(16))) = {
	
	3457,  -12929,    -147,      0,      0,      0,      0,      0,
	223, 1138, -1059, -397, -183, 1655, 559, -1674, 
	-223, -1138, 1059, 397, 183, -1655, -559, 1674, 
	277, 933, 1723, 437, -1514, 242, 1640, 432, 
	-277, -933, -1723, -437, 1514, -242, -1640, -432, 
	-1583, 696, 774, 1671, 927, 514, 512, 489, 
	1583, -696, -774, -1671, -927, -514, -512, -489, 
	297, 601, 1473, 1130, 1322, 871, 760, 1212, 
	-297, -601, -1473, -1130, -1322, -871, -760, -1212, 
	-312, -352, 443, 943, 8, 1250, -100, 1660, 
	312, 352, -443, -943, -8, -1250, 100, -1660, 
	-31, 1206, -1341, -1247, 444, 235, 1364, -1209, 
	31, -1206, 1341, 1247, -444, -235, -1364, 1209, 
	361, 230, 673, 582, 1409, 1501, 1401, 251, 
	-361, -230, -673, -582, -1409, -1501, -1401, -251, 
	1022, -1063, 1053, 1188, 417, -1391, -27, -1626, 
	-1022, 1063, -1053, -1188, -417, 1391, 27, 1626, 
	1685, -315, 1408, -1248, 400, 274, -1543, 32, 
	-1685, 315, -1408, 1248, -400, -274, 1543, -32, 
	-1550, 1531, -1367, -124, 1458, 1379, -940, -1681, 
	1550, -1531, 1367, 124, -1458, -1379, 940, 1681, 
	22, 1709, -275, 1108, 354, -1728, -968, 858, 
	-22, -1709, 275, -1108, -354, 1728, 968, -858, 
	1221, -218, 294, -732, -1095, 892, 1588, -779, 
	-1221, 218, -294, 732, 1095, -892, -1588, 779, 
};

const int16_t zetas2_inv[416] __attribute__((aligned(16))) = {
	3457,  19412, -50, -474, -830, -7867, 4, 38, 
	-625, -5924, 957, 9071, -16, -152, 256, 2427, 
	-1100, -975, 88, 78, 1416, -2, 25, 415, 
	-10427, -9242, 834, 739, 13422, -19, 237, 3934, 

	3457,  19412, -1507, -14284, 1257, 11915, -156, -1479, 
176, 1668, 200, 1896, -137, -1299, 1484, 14066, 
-923, -111, -341, 562, 1427, 872, -529, -1176, 
-8749, -1052, -3232, 5327, 13526, 8265, -5014, -11147, 

3457,  19412, -1449, -13735, 837, 7934, 1637, 15517, 
901, 8540, -1202, -11393, -594, -5630, 222, 2104, 
-1282, 1535, -174, 1260, 1600, -1096, -128, -742, 
-12152, 14550, -1649, 11943, 15166, -10389, -1213, -7033, 

3457,  19412, 1199, 11365, -1530, -14502, -1617, -15327, 
-569, -5393, 511, 4844, -1197, -11346, 1611, 15270, 
-1082, 1398, -190, 303, 714, 790, 496, -1446, 
-10256, 13251, -1801, 2872, 6768, 7488, 4701, -13706, 

3457,  19412, -992, -9403, -565, -5355, -1580, -14976, 
1428, 13536, 1181, 11194, -446, -4228, -1590, -15071, 
-765, 1129, 1444, -920, -1278, 910, -1004, 1310, 
-7251, 10701, 13687, -8720, -12114, 8626, -9517, 12417, 

3457,  19412, 661, 6265, 1293, 12256, -606, -5744, 
-380, -3602, -1339, -12692, -794, -7526, 1262, 11962, 
1668, -1350, -410, 108, 631, 795, -1295, -755, 
15811, -12796, -3886, 1024, 5981, 7536, -12275, -7156, 

3457,  19412, -1028, -9744, 1603, 15194, -1024, -9706, 
978, 9270, 1058, 10029, -1105, -10474, 704, 6673, 
-1685, -315, -1248, 1408, 32, -1543, 274, 400, 
-15972, -2986, -11829, 13346, 303, -14626, 2597, 3791, 

3457,  19412, -1392, -13194, -291, -2758, -1548, -14673, 
-115, -1090, 1713, 16237, -603, -5716, 624, 5915, 
-1681, -940, 1379, 1458, -124, -1367, 1531, -1550, 
-15934, -8910, 13071, 13820, -1175, -12957, 14512, -14692, 

3457,  19412, 1045, 9905, 62, 588, -775, -7346, 
963, 9128, 387, 3668, 893, 8465, -1118, -10597, 
-361, 230, 582, 673, 251, 1401, 1501, 1409, 
-3422, 2180, 5517, 6379, 2379, 13280, 14228, 13356, 

3457,  19412, 729, 6910, 1039, 9848, -888, -8417, 
470, 4455, 937, 8882, -348, -3299, 109, 1033, 
-1626, -27, -1391, 417, 1188, 1053, -1063, 1022, 
-15412, -256, -13185, 3953, 11261, 9981, -10076, 9687, 

3457,  19412, 1591, 15081, -554, -5251, 11, 104, 
874, 8284, -757, -7175, -121, -1147, 813, 7706, 
-779, 1588, 892, -1095, -732, 294, -218, 1221, 
-7384, 15052, 8455, -10379, -6938, 2787, -2066, 11574, 

3457,  19412, 177, 1678, 864, 8190, -429, -4066, 
484, 4588, -216, -2047, -820, -7773, -1715, -16256, 
858, -968, -1728, 354, 1108, -275, 1709, 22, 
8133, -9175, -16379, 3355, 10502, -2607, 16199, 209, 

3457,  19412,   -723,  -6853,  147,   1393,  -886,  -8398,
-1033,  -9792,  -1265, -11991, 1510,  14313,   -682,  -6464,
-1124, -10654,   1571,  14891, -1571, -14891,  -257,  -2436,
1634,  15488,   -811,  -7687, -1622 ,  -15375,    0 ,     0
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
	poly_tobytes_asm(r, a, qs);
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
