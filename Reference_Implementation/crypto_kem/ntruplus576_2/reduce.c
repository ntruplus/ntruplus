#include <stdint.h>
#include "params.h"
#include "reduce.h"

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