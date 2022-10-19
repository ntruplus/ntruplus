#include <stdio.h>
#include "ntt.h"


int main(void)
{
    int16_t a[1024] = {0};
    int16_t b[1024] = {0};
    int16_t c[1024] = {0};

    for (int i = 0; i < 1024; i++)
    {
        a[i] = 1;
    }
        
    ntt(a);

    for (int i = 0; i < 1024; i++)
    {
        if(i%16==0) printf("\n");
        printf("%d " , a[i]);
    }
    printf("\n");
    
    invntt(a);

    for (int i = 0; i < 1024; i++)
    {
        if(i%16==0) printf("\n");
        printf("%d " , a[i]);
    }
    printf("\n");


    return 0;
}