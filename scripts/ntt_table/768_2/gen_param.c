#include <stdio.h>

#define Q 3457
#define QINV 12929

//basic
int exp_table[3456] = {0};

//tree
int tree[8][1024] = {0};

//ntt
int ntt_tree[8][768] = {0};
int zetas_exp[1852] = {0};

//invntt
int invntt_tree[8][768] = {0};
int zetas_inv_exp[1856] = {0};

void gen_exp()
{
    int a = 5;

    exp_table[0] = (1 << 16) % Q;

    for (int i = 1; i < 1152; i++)
    {
        exp_table[i] = (exp_table[i-1] * a) % Q;
    }
}
void gen_tree()
{
    int t = 2;

    tree[0][0] = 192;
    tree[0][1] = 960;

    for (int j = 0; j < 1; j++)
    {
        for (int i = 0; i < t; i++)
        {
            tree[j+1][3*i+0] = tree[j][i]/3;
            tree[j+1][3*i+1] = tree[j+1][3*i+0] + 384;
            tree[j+1][3*i+2] = tree[j+1][3*i+1] + 384;
        }

        t = t*3;
    }

    for (int j = 1; j < 7; j++)
    {
        for (int i = 0; i < t; i++)
        {
            tree[j+1][2*i+0] = tree[j][i]/2;
            tree[j+1][2*i+1] = tree[j+1][2*i+0] + 576;
        }

        t = t*2;
    }
}

void trans_tree()
{
    int t;

    ntt_tree[0][0] = exp_table[tree[0][0]];
    ntt_tree[0][1] = exp_table[tree[0][1]];

    t = 6;

    for (int j = 1; j < 2; j++)
    {
        for (int i = 0; i < t; i++)
        {
            ntt_tree[j][2*i] = exp_table[tree[j][i]];
            ntt_tree[j][2*i+1] = exp_table[(tree[j][i] << 1) % 1152];
        }

        t = t*3;
    }

    for (int j = 2; j < 8; j++)
    {
        for (int i = 0; i < t; i++)
        {
            ntt_tree[j][i] = exp_table[tree[j][i]];
        }

        t = t*2;
    }

}

void trans_tree_inv()
{
    int t;

    invntt_tree[0][0] = exp_table[1152 - tree[0][0]];
    invntt_tree[0][1] = exp_table[1152 - tree[0][1]];

    t = 6;

    for (int j = 1; j < 2; j++)
    {
        for (int i = 0; i < t; i++)
        {
            invntt_tree[j][2*i] = exp_table[1152 - tree[j][i]];
            invntt_tree[j][2*i+1] = exp_table[((1152 - tree[j][i])*2) % 1152];
        }

        t = t*3;
    }

    for (int j = 2; j < 8; j++)
    {
        for (int i = 0; i < t; i++)
        {
            invntt_tree[j][i] = exp_table[1152 - tree[j][i]];
        }

        t = t*2;
    }
}


void ntt_encode()
{
    int k = 0;

//level0
    for (int i = 0; i < 1; i++)
    {
        zetas_exp[k++] = (ntt_tree[0][0] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[0][0] * QINV) & 0xffff;
        zetas_exp[k++] = ntt_tree[0][0];
        zetas_exp[k++] = ntt_tree[0][0];
    }
    printf("k : %d\n", k);    
//level1
    for (int i = 0; i < 2; i++)
    {
        zetas_exp[k++] = (ntt_tree[1][6*i] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[1][6*i] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[1][6*i];
        zetas_exp[k++] = ntt_tree[1][6*i];

        zetas_exp[k++] = (ntt_tree[1][6*i+1] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[1][6*i+1] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[1][6*i+1];
        zetas_exp[k++] = ntt_tree[1][6*i+1];        
    }
    printf("k : %d\n", k);
//level2
    for (int i = 0; i < 6; i++)
    {
        zetas_exp[k++] = (ntt_tree[2][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[2][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = ntt_tree[2][i << 1];
        zetas_exp[k++] = ntt_tree[2][i << 1];
    }
    printf("k : %d\n", k);
//level3
    for (int i = 0; i < 12; i++)
    {
        zetas_exp[k++] = (ntt_tree[3][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[3][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = ntt_tree[3][i << 1];      
        zetas_exp[k++] = ntt_tree[3][i << 1];
    }
    printf("k : %d\n", k);
//level4
    for (int i = 0; i < 24; i++)
    {
        zetas_exp[k++] = (ntt_tree[4][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = ntt_tree[4][i << 1];      
        zetas_exp[k++] = ntt_tree[4][i << 1];
    }
    printf("k : %d\n", k);
//level5
    for (int i = 0; i < 24; i++)
    {
        zetas_exp[k++] = (ntt_tree[5][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)] * QINV) & 0xffff;

        zetas_exp[k++] = (ntt_tree[5][(i << 2)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 2)+2] * QINV) & 0xffff;


        zetas_exp[k++] = ntt_tree[5][(i << 2)];
        zetas_exp[k++] = ntt_tree[5][(i << 2)];
        zetas_exp[k++] = ntt_tree[5][(i << 2)];
        zetas_exp[k++] = ntt_tree[5][(i << 2)];
        zetas_exp[k++] = ntt_tree[5][(i << 2)];
        zetas_exp[k++] = ntt_tree[5][(i << 2)];
        zetas_exp[k++] = ntt_tree[5][(i << 2)];
        zetas_exp[k++] = ntt_tree[5][(i << 2)];
        zetas_exp[k++] = ntt_tree[5][(i << 2)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 2)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 2)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 2)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 2)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 2)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 2)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 2)+2];

    }
        printf("k : %d\n", k);

//level6
    for (int i = 0; i < 24; i++)
    {
        zetas_exp[k++] = (ntt_tree[6][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 3)+6] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[6][(i << 3)];
        zetas_exp[k++] = ntt_tree[6][(i << 3)];
        zetas_exp[k++] = ntt_tree[6][(i << 3)];
        zetas_exp[k++] = ntt_tree[6][(i << 3)];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+2];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+2];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+2];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+2];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+4];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+4];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+4];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+4];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+6];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+6];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+6];
        zetas_exp[k++] = ntt_tree[6][(i << 3)+6];        
    }

    printf("k : %d\n", k);

//level7
    for (int i = 0; i < 24; i++)
    {
        zetas_exp[k++] = (ntt_tree[7][(i << 4)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+8] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+8] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+10] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+10] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+12] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+12] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+14] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 4)+14] * QINV) & 0xffff;
                
        zetas_exp[k++] = ntt_tree[7][(i << 4)];
        zetas_exp[k++] = ntt_tree[7][(i << 4)];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+2];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+2];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+4];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+4];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+6];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+6];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+8];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+8];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+10];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+10];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+12];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+12];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+14];
        zetas_exp[k++] = ntt_tree[7][(i << 4)+14];
    }

    printf("k : %d\n", k);
}

void invntt_encode()
{
    int k = 0;

//level7
    for (int i = 0; i < 24; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+8] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+8] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+10] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+10] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+12] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+12] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+14] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 4)+14] * QINV) & 0xffff;
                
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+2];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+2];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+4];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+4];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+6];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+6];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+8];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+8];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+10];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+10];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+12];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+12];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+14];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 4)+14];
    }

    printf("k : %d\n", k);

//level6
    for (int i = 0; i < 24; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 3)+6] * QINV) & 0xffff;

        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+2];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+2];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+2];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+2];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+4];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+4];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+4];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+4];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+6];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+6];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+6];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 3)+6];
    }

    printf("k : %d\n", k);

//level5
    for (int i = 0; i < 24; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[5][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 2) + 2] * QINV) & 0xffff;

        zetas_inv_exp[k++] = invntt_tree[5][i << 2];
        zetas_inv_exp[k++] = invntt_tree[5][i << 2];
        zetas_inv_exp[k++] = invntt_tree[5][i << 2];
        zetas_inv_exp[k++] = invntt_tree[5][i << 2];
        zetas_inv_exp[k++] = invntt_tree[5][i << 2];
        zetas_inv_exp[k++] = invntt_tree[5][i << 2];
        zetas_inv_exp[k++] = invntt_tree[5][i << 2];
        zetas_inv_exp[k++] = invntt_tree[5][i << 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 2) + 2];
    }
        printf("k : %d\n", k);

//level4
    for (int i = 0; i < 24; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[4][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = invntt_tree[4][i << 1];      
        zetas_inv_exp[k++] = invntt_tree[4][i << 1];
    }
    printf("k : %d\n", k);

//level3
    for (int i = 0; i < 12; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[3][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[3][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = invntt_tree[3][i << 1];      
        zetas_inv_exp[k++] = invntt_tree[3][i << 1];
    }
    printf("k : %d\n", k);

//level2
    for (int i = 0; i < 6; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[2][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[2][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = invntt_tree[2][i << 1];
        zetas_inv_exp[k++] = invntt_tree[2][i << 1];
    }
    printf("k : %d\n", k);

//level1
    for (int i = 0; i < 2; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[1][6*i] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[1][6*i] * QINV) & 0xffff;
        zetas_inv_exp[k++] = invntt_tree[1][6*i];
        zetas_inv_exp[k++] = invntt_tree[1][6*i];

        zetas_inv_exp[k++] = (invntt_tree[1][6*i+1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[1][6*i+1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = invntt_tree[1][6*i+1];
        zetas_inv_exp[k++] = invntt_tree[1][6*i+1];

    }
    printf("k : %d\n", k);

      
//level0
    for (int i = 0; i < 1; i++)
    {
        //(z-z^5)^-1
        zetas_inv_exp[k++] = (1665 * QINV) & 0xffff;
        zetas_inv_exp[k++] = (1665 * QINV) & 0xffff;
        zetas_inv_exp[k++] = 1665;
        zetas_inv_exp[k++] = 1665;

        //기억이 안남.... 전체적인 기법이랑, 3*2^x의 역수 포함
        zetas_inv_exp[k++] = (2568 * QINV) & 0xffff;
        zetas_inv_exp[k++] = (2568 * QINV) & 0xffff;
        zetas_inv_exp[k++] = 2568;
        zetas_inv_exp[k++] = 2568;
    }
    printf("k : %d\n", k);
}

void init()
{
    int t;

    gen_exp();

    gen_tree();

    printf("tree\n");
    t = 2;
    for (int j = 0; j < 1; j++)
    {
        printf("level %d\n", j);
        for (int i = 0; i < t; i++)
        {
            printf("%d ", tree[j][i]);
        }
        printf("\n\n");

        t = t*3;
    }

    for (int j = 1; j < 8; j++)
    {
        printf("level %d\n", j);
        for (int i = 0; i < t; i++)
        {
            printf("%d ", tree[j][i]);
        }
        printf("\n\n");

        t = t*2;
    }
}

void ntt()
{
    trans_tree();
    ntt_encode();

    printf("int16_t zetas[2492] = {");
    for (int i = 0; i < 2491; i++)
    {
        printf("%d, ", zetas_exp[i]);
    }
    printf("%d};", zetas_exp[2491]);
    printf("\n\n");
}

void invntt()
{
    trans_tree_inv();
    invntt_encode();

    printf("int16_t zetas_inv[2496] = {");
    for (int i = 0; i < 2495; i++)
    {
        printf("%d, ", zetas_inv_exp[i]);
    }
    printf("%d};", zetas_inv_exp[2495]);
    printf("\n\n");

}

int main(void)
{
    init();

    ntt();
    //mul();
    invntt();

    return 0;
}