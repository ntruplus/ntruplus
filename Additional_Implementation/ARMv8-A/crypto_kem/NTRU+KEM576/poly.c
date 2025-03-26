#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "ntt.h"
#include "symmetric.h"

extern void poly_frombytes_asm(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES], const int16_t *zetas);
extern void poly_tobytes_asm(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a, const int16_t* zetas);
extern void poly_cbd1_asm(poly *r, const uint8_t buf[NTRUPLUS_N/4], const int16_t* zeta);
extern void poly_sotp_asm(poly *r, const unsigned char *msg, const unsigned char *buf, const int16_t* zetas);
extern int  poly_sotp_inv_asm(unsigned char *msg, const poly *e, const unsigned char *buf, const int16_t* zetas);	
extern void poly_basemul_asm(poly *r, const poly *a, const poly *b, const int16_t* zetas);
extern int  poly_baseinv_asm(poly *r, const poly *a, const int16_t* zetas);
extern void poly_basemul_add_asm(poly *r, const poly *a, const poly *b, const poly *c, const int16_t* zetas);
extern void poly_crepmod3_asm(poly *r, const poly *a, const int16_t* zetas);

const int16_t zetas2[360] __attribute__((aligned(16))) = {
    3457,  19412,   -723,  -6853,   -722,  -6844,  -1520, -14408,
    1124,  10654,    867,   8218,   1520,  14408,    450,   4265,
   -1463, -13867,   1078,  10218,    532,   5043,   1722,  16322,
    -822,  -7792,    909,   8616,     58,    550,  -1556, -14749,
    1236,  11716,    298,   2825,  -1078, -10218,      0,      0,
  
    3457,  19412,    157,   1488,    727,   6891,   -353,  -3346, 
   -1020,  -9668,  -1119, -10607,   -599,  -5678,      0,      0,
      81,  -1421,   1251,    716,  -1598,   -945,    287,   -767,
     768, -13469,  11858,   6787, -15147,  -8957,   2720,  -7270, 

    3457,  19412,    570,   5403,   -107,  -1014,   -952,  -9024,
      99,    938,   -652,  -6180,   1622,  15375,      0,      0,
    -654,    206,   -882,   1261,   1542,   -676,  -1536,   1467,
   -6199,   1953,  -8360,  11953,  14616,  -6408, -14559,  13905, 

    3457,  19412,   1200,  11374,   1307,  12389,    783,   7422,
    1244,  11792,    592,   5611,    839,   7953,      0,      0, 
    1332,   -705,   -170,    635,  -1311,  -1712,   -658,    831,
    12626, -6683,  -1611,   6019, -12427, -16228,  -6237,   7877, 

    3457,  19412,    161,   1526,   1296,  12284,    725,   6872,
    1664,  15773,     36,    341,   1289,  12218,      0,      0, 
    1315,   1087,   1488,   -881,      6,    791,   1245,    -75,
   12465,  10303,  14104,  -8351,     57,   7498,  11801,   -711, 

    3457,  19412,   1135,  10758,  -1529, -14493,  -1443, -13678,
    1628,  15431,    172,   1630,    781,   7403,      0,      0,
    1162,    -70,   -875,   -697,  -1111,   1608,   -642,  -1669,
   11014,   -664,  -8294,  -6607, -10531,  15242,  -6085, -15820, 

    3457,  19412,   1155,  10948,   -773,  -7327,   1172,  11109,
      96,    910,    268,   2540,   -391,  -3706,      0,      0,
    1475,    286,    118,    576,   1032,   1229,   -194,    928,
   13981,   2711,   1118,   5460,   9782,  11649,  -1839,   8796, 

    3457,  19412,    976,   9251,    556,   5270,    445,   4218,
     473,   4483,   -264,  -2502,   -234,  -2218,      0,      0,
     104,   1035,    838,  -1300,   1704,    -61,    966,   -558,
     986,   9810,   7943, -12322,  16152,   -578,   9156,  -5289, 

    3457,  19412,   -420,  -3981,   -467,  -4427,    211,   2000,
     737,   6986,   1292,  12247,  -1369, -12976,      0,      0,
    1593,    862,    404,   -899,   -965,   1266,  -1460,    -37,
   15100,   8171,   3829,  -8521,  -9147,  12000, -13839,   -351, 

    3457,  19412,  -1612, -15280,  -1145, -10853,  -1085, -10284,
    -726,  -6882,    566,   5365,   -284,  -2692,      0,      0,
     942,   -265,  -1584,  -1404,   -787,   -619,    905,   1195,
    8929,  -2512, -15014, -13308,  -7460,  -5867,   8578,  11327
};

const int16_t zetas2_mul[400] __attribute__((aligned(16))) = {
	
	  3457,  -12929,    -147,      0,      0,      0,      0,      0,
	 -1536,    1467,    -676,  -1542,   -170,    635,   -705,  -1332,
	  1536,   -1467,     676,   1542,    170,   -635,    705,   1332,
 	  -658,     831,   -1712,   1311,   1488,   -881,   1087,  -1315,
	   658,    -831,    1712,  -1311,  -1488,    881,  -1087,   1315,
	  1245,     -75,     791,     -6,   -875,   -697,    -70,  -1162,
	 -1245,      75,    -791,      6,    875,    697,     70,   1162,
	   287,    -767,    -945,   1598,   -882,   1261,    206,    654,
	  -287,     767,     945,  -1598,    882,  -1261,   -206,   -654,
	 -1421,     -81,     716,  -1251,    838,  -1300,   1035,   -104,
	  1421,      81,    -716,   1251,   -838,   1300,  -1035,    104,
	   966,    -558,     -61,  -1704,    404,   -899,    862,  -1593,
	  -966,     558,      61,   1704,   -404,    899,   -862,   1593,
	 -1460,     -37,    1266,    965,  -1584,  -1404,   -265,   -942,
	  1460,      37,   -1266,   -965,   1584,   1404,    265,    942,
	   905,    1195,    -619,    787,    118,    576,    286,  -1475,
	  -905,   -1195,     619,   -787,   -118,   -576,   -286,   1475,
	  -194,     928,    1229,  -1032,   1608,   1111,  -1669,    642, 
	   194,    -928,   -1229,   1032,  -1608,  -1111,   1669,   -642
};

const int16_t zetas2_inv[360] __attribute__((aligned(16))) = {
    3457,  19412,  -284,  -2692,566,   5365, -726,  -6882,
   -1085,   -10284,-1145, -10853,      -1612, -15280,   0,      0,
    1195,    905,   -619,   -787,  -1404,  -1584,   -265,    942,
   11327,   8578,  -5867,  -7460, -13308, -15014,  -2512,   8929,

    3457,  19412,    -1369, -12976,  1292,  12247,  737,   6986,  
     211,   2000,   -467,  -4427,   -420,  -3981,      0,      0,
     -37,  -1460,   1266,   -965,   -899,    404,    862,   1593,
    -351, -13839,  12000,  -9147,  -8521,   3829,   8171,  15100,

    3457,  19412,  -234,  -2218,   -264,  -2502, 473,   4483, 
     445,   4218,    556,   5270,    976,   9251,      0,      0,
    -558,    966,    -61,   1704,  -1300,    838,   1035,    104,  
   -5289,   9156,   -578,  16152, -12322,   7943,   9810,    986,  
    
    3457,  19412,  -391,  -3706, 268,   2540,    96,    910,    
    1172,  11109,-773,  -7327,       1155,  10948,     0,      0,
     928,   -194,   1229,   1032,    576,    118,    286,   1475,        
    8796,  -1839,  11649,   9782,   5460,   1118,   2711,  13981, 
 
    3457,  19412,  781,   7403,  172,   1630,  1628,  15431, 
   -1443, -13678, -1529, -14493, 1135,  10758,  0,      0,
   -1669,   -642, 1608,-1111,   -697,   -875,   -70,   1162,   
  -15820, -6085, 15242, -10531,    -6607, -8294, -664, 11014, 
            
    3457,  19412,  1289,  12218,    36,    341,1664,  15773, 
     725,   6872, 1296,  12284,  161,   1526,        0,      0, 
     -75, 1245, 791,    6,    -881,     1488,    1087,       1315,  
    -711, 11801, 7498,  57, -8351,   14104, 10303, 12465,       
     
    3457,  19412,    839,   7953,   592,   5611,   1244,  11792,   
     783,   7422,   1307,  12389,  1200,  11374,      0,      0, 
     831,   -658,  -1712,  -1311,   635,   -170,   -705,   1332,      
    7877,  -6237, -16228, -12427,  6019,  -1611,  -6683,  12626, 
        
     3457,  19412,  1622,  15375,    -652,  -6180,  99,    938, 
     -952,  -9024, -107,  -1014,     570,   5403,       0,      0,
     1467, -1536,   -676,   1542,    1261,  -882,  206,     -654,   
     13905, -14559,-6408,   14616,  11953,  -8360,  1953,    -6199,  
 
      3457,  19412,   -599,  -5678, -1119, -10607,  -1020,  -9668, 
      -353,  -3346,  727,   6891,   157,   1488,    0,      0,
      -767,287,    -945,   -1598,    716,  1251,  -1421,    81,  
      -7270,  2720,-8957,  -15147,   6787,  11858,  -13469,     768, 

      3457,  19412,   -723,  -6853,   298,   2825,  -1078, -10218, 
      -1556, -14749, 1236,  11716,       909,   8616,     58,    550, 
      1722,  16322,      -822,  -7792,         1078,  10218,    532,   5043, 
      450,   4265, -1463, -13867,         867,   8218,   1520,  14408,   
      -1520, -14408,    1124,  10654,    1634,  15488,  71,     673

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
	ntt(r->coeffs, a->coeffs, zetas2);
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
	invntt(r->coeffs, a->coeffs, zetas2_inv);
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
