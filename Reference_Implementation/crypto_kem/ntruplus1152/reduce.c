#include <stdint.h>
#include "params.h"
#include "reduce.h"

//-q ~ q로 추정
int16_t fqmontred(int32_t a)
{
	int32_t t;
	int16_t u;

	u = a * QINV;
	t = (int32_t)u * NTRUPLUS_Q;
	t = a - t;
	t >>= 16;
	return t;
}

/*fqred16
// -2Q = -6914 <= <= -4097      |    0 <= <= 2817
//       -4096 <= <=    -1      | -639 <= <= 3456
//           0 <= <=  4095      |    0 <= <= 4095
//        4096 <= <=  6914 = 2Q |  639 <= <= 3457
*/
int16_t fqred16(int16_t a)
{
	int16_t t;

	t = a & 0xFFF;
	a >>= 12;
	t +=  (a << 10) - (a << 8)  - (a << 7) - a;
	return t;
}

int16_t fqcsubq(int16_t a)
{
	a += (a >> 15) & NTRUPLUS_Q;
	a -= NTRUPLUS_Q;
	a += (a >> 15) & NTRUPLUS_Q;
	return a;
}


int16_t fqmul(int16_t a, int16_t b)
{
  return fqmontred((int32_t)a*b);
}
/*
Q = 3457
Q - 2 = 3455 = 1101 0111 1111
a^(Q-2) * a = a^(Q-2) = 1 mod Q 

1	t = fqmul(t, t); //10 				M^-3
	t = fqmul(t, a); //11 				M^-5
2	t = fqmul(t, t); //110 				M^-11
3	t = fqmul(t, t); //1100 				M^-23
	t = fqmul(t, a); //1101 				M^-25
4	t = fqmul(t, t); //1101 0				M^-51
5	t = fqmul(t, t); //1101 00			M^-103
	t = fqmul(t, a); //1101 01			M^-105
6	t = fqmul(t, t); //1101 010			M^-211
	t = fqmul(t, a); //1101 011			M^-213
7	t = fqmul(t, t); //1101 0110			M^-427
	t = fqmul(t, a); //1101 0111			M^-429
8	t = fqmul(t, t); //1101 0111 0		M^-859
	t = fqmul(t, a); //1101 0111 1		M^-861
9	t = fqmul(t, t); //1101 0111 10		M^-1723
	t = fqmul(t, a); //1101 0111 11		M^-1725
10	t = fqmul(t, t); //1101 0111 110		M^-3451
	t = fqmul(t, a); //1101 0111 111		M^-3453
11	t = fqmul(t, t); //1101 0111 1110		M^-6907
	t = fqmul(t, a); //1101 0111 1111		M^-6909 = M^3
*/

/*
1	t = fqmul(t, t); //10 				M^-1
	t = fqmul(t, a); //11 				M^-2
2	t = fqmul(t, t); //110 				M^-5
3	t = fqmul(t, t); //1100 			M^-11
	t = fqmul(t, a); //1101 			M^-12
4	t = fqmul(t, t); //1101 0			M^-25
5	t = fqmul(t, t); //1101 00			M^-51
	t = fqmul(t, a); //1101 01			M^-52
6	t = fqmul(t, t); //1101 010			M^-105
	t = fqmul(t, a); //1101 011			M^-106
7	t = fqmul(t, t); //1101 0110		M^-213
	t = fqmul(t, a); //1101 0111		M^-214
8	t = fqmul(t, t); //1101 0111 0		M^-429
	t = fqmul(t, a); //1101 0111 1		M^-430
9	t = fqmul(t, t); //1101 0111 10		M^-861
	t = fqmul(t, a); //1101 0111 11		M^-862
10	t = fqmul(t, t); //1101 0111 110	M^-1725
	t = fqmul(t, a); //1101 0111 111	M^-1726
11	t = fqmul(t, t); //1101 0111 1110	M^-3453
	t = fqmul(t, a); //1101 0111 1111	M^-3454 => M^2
*/

//new to check
int16_t fqinv(int16_t a)
{
	int16_t t = a;

	for(int i = 1; i <= 11; i++)
	{
		t = fqmul(t, t);
		if(i != 2 && i != 4) t = fqmul(t, a);
	}

	return t;
}