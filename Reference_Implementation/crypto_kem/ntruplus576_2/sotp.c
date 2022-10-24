#include "sotp.h"
#include "util.h"

void sotp_internal(poly *a, const unsigned char *msg, const unsigned char *buf)
{
    uint8_t tmp[32];
	uint32_t t1, t2;

    for(int i = 0; i < 32; i++)
    {
         tmp[i] = buf[i]^msg[i];
    }

    for(int i = 0; i < 8; i++)
    {
        t1 = load32_littleendian(tmp + 4*i);
        t2 = load32_littleendian(buf + 4*i + 32);

        for (int j = 0; j < 2; j++)
        {
            for(int k = 0; k < 16; k++)
            {
                a->coeffs[320 + 16*k + 2*i + j] = (t1 & 0x1) - (t2 & 0x1);

                t1 = t1 >> 1;
                t2 = t2 >> 1;
            }
        }
    }
}

void sotp_inv_internal(unsigned char *msg, const poly *a, const unsigned char *buf)
{
    uint8_t tmp[64];
	uint32_t t1, t2, t3;

    for(int i = 0; i < 8; i++)
    {
        t1 = load32_littleendian(buf + 4*i);
        t2 = load32_littleendian(buf + 4*i + 32);
        t3 = 0;
        for (int j = 0; j < 2; j++)
        {
            for(int k = 0; k < 16; k++)
            {
                t3 ^= (((a->coeffs[320 + 16*k + 2*i + j] + (t2 & 0x1)) & 0x1)^(t1 & 0x1)) << (k+16*j);

                t1 = t1 >> 1;
                t2 = t2 >> 1;
            }
        }
        
        msg[4*i] = t3;
        msg[4*i+1] = t3 >> 8;
        msg[4*i+2] = t3 >> 16;
        msg[4*i+3] = t3 >> 24;
    }
}