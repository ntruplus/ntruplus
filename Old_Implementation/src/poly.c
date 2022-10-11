#include <stdint.h>
#include "params.h"
#include "poly.h"

static int16_t crepmod3(int16_t a)
{
	a += (a >> 15) & Q;
	a -= (Q-1)/2;
	a += (a >> 15) & Q;
	a -= (Q+1)/2;

	a  = (a >> 8) + (a & 255);
	a  = (a >> 4) + (a & 15);
	a  = (a >> 2) + (a & 3);
	a  = (a >> 2) + (a & 3);
	a -= 3;
	a += ((a + 1) >> 15) & 3;
	return a;
}

void poly_crepmod3(poly *b, const poly *a)
{
	unsigned int i;

	for(i = 0; i < N; ++i)
	{
		b->coeffs[i] = crepmod3(a->coeffs[i]);
	}
}