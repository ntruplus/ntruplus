#include "sotp.h"
#include "poly.h"
void sotp_internal2(poly *a, const unsigned char *msg, const unsigned char *buf)
{
    unsigned int i,j,k;
    uint32_t t1, t2;

    uint8_t tmp[64];

    for (int i = 0; i < 32; i++)
    {
        tmp[i] = buf[i] ^ msg[i];
        tmp[32+i] = buf[i];
    }
        
    for(j = 0; j < 8; j++)
    {
        t1 = load32_littleendian(tmp + 4*j);
        t2 = load32_littleendian(tmp + 4*j + 32);

        for(k = 0; k < 16; k++)
        {
            a->coeffs[512+16*k + 2*j] = ((t1 >> k) & 0x1) - ((t2 >> k) & 0x1);
        }

        t1 = t1 >> 16;
        t2 = t2 >> 16;

        for(k = 0; k < 16; k++)
        {
            a->coeffs[512+16*k + 2*j + 1] = ((t1 >> k) & 0x1) - ((t2 >> k) & 0x1);
        }
    }
}

void sotp_inv_internal2(unsigned char *msg, const poly *a, const unsigned char *buf)
{
    unsigned int i,j,k;
    uint32_t t1, t2;

    uint8_t tmp[64];

    for (int i = 0; i < 32; i++)
    {
        tmp[i] = buf[i] ^ msg[i];
        tmp[32+i] = buf[i];
    }

        
    for(j = 0; j < 8; j++)
    {
        t1 = load32_littleendian(tmp + 4*j);
        t2 = load32_littleendian(tmp + 4*j + 32);

        for(k = 0; k < 16; k++)
        {
            msg[4*j] ^= (((a->coeffs[512 + 16*k + 2*j] + ((t2 >> k) & 0x1)) & 0x1) ^ ((t1 >> k) & 0x1)) << k;
        }

        t1 = t1 >> 16;
        t2 = t2 >> 16;

        for(k = 0; k < 16; k++)
        {
            msg[4*j] ^= (((a->coeffs[512 + 16*k + 2*j + 1] + ((t2 >> k) & 0x1)) & 0x1) ^ ((t1 >> k) & 0x1)) << (k + 16);
        }

        load32_littleendian(msg + 4*j);
    }
}