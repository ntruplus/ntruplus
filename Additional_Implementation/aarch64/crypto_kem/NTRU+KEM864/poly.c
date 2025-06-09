#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "symmetric.h"

extern void poly_frombytes_asm(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES]);
extern void poly_tobytes_asm(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a);
extern void poly_shuffle_asm(poly* r, const poly* a);
extern void poly_shuffle2_asm(poly* r, const poly* a);

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

	poly_shuffle2_asm(&t,a);
	poly_tobytes_asm(r, &t);
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
	poly_frombytes_asm(r, a);
	poly_shuffle_asm(r, r); 
}
