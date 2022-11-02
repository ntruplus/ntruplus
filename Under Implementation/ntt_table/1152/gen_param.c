#include <stdio.h>

#define Q 3457
#define QINV 12929

//basic
int exp_table[3456] = {0};

//tree
int tree[10][4000] = {0};
int table[3900] = {0};

//ntt
int ntt_tree[9][4000] = {0};
int zetas_exp[4000] = {0};

//mul
int zetas_mul_exp[3900] = {0};

//invntt
int invntt_tree[9][4000] = {0};
int zetas_inv_exp[4000] = {0};

void gen_exp()
{
    int a = 3;

    exp_table[0] = (1 << 16) % Q;
    //exp_table[0] = 1;
    for (int i = 1; i < 1728; i++)
    {
        exp_table[i] = (exp_table[i-1] * a) % Q;
    }
}
void gen_tree()
{
    int t = 2;

    tree[0][0] = 288;
    tree[0][1] = 1440;

    for (int j = 0; j < 2; j++)
    {
        for (int i = 0; i < t; i++)
        {
            tree[j+1][3*i+0] = tree[j][i]/3;
            tree[j+1][3*i+1] = tree[j+1][3*i+0] + 576;
            tree[j+1][3*i+2] = tree[j+1][3*i+1] + 576;
        }

        t = t*3;
    }

    for (int j = 2; j < 7; j++)
    {
        for (int i = 0; i < t; i++)
        {
            tree[j+1][2*i+0] = tree[j][i]/2;
            tree[j+1][2*i+1] = tree[j+1][2*i+0] + 864;
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

    for (int j = 1; j < 3; j++)
    {
        for (int i = 0; i < t; i++)
        {
            ntt_tree[j][2*i] = exp_table[tree[j][i]];
            ntt_tree[j][2*i+1] = exp_table[(tree[j][i] << 1) % 1728];
        }

        t = t*3;
    }

    for (int j = 3; j < 8; j++)
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

    invntt_tree[0][0] = exp_table[1728 - tree[0][0]];
    invntt_tree[0][1] = exp_table[1728 - tree[0][1]];

    t = 6;

    for (int j = 1; j < 3; j++)
    {
        for (int i = 0; i < t; i++)
        {
            invntt_tree[j][2*i] = exp_table[1728 - tree[j][i]];
            invntt_tree[j][2*i+1] = exp_table[((3456 - tree[j][i])*2) % 1728];
        }

        t = t*3;
    }

    for (int j = 3; j < 8; j++)
    {
        for (int i = 0; i < t; i++)
        {
            invntt_tree[j][i] = exp_table[1728 - tree[j][i]];
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
        zetas_exp[k++] = (ntt_tree[2][6*i] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[2][6*i] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[2][6*i];
        zetas_exp[k++] = ntt_tree[2][6*i];

        zetas_exp[k++] = (ntt_tree[2][6*i+1] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[2][6*i+1] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[2][6*i+1];
        zetas_exp[k++] = ntt_tree[2][6*i+1];        
    }
    printf("k : %d\n", k);

//level3
    for (int i = 0; i < 18; i++)
    {
        zetas_exp[k++] = (ntt_tree[3][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[3][i << 1] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[3][i << 1];
        zetas_exp[k++] = ntt_tree[3][i << 1];
    }
    printf("k : %d\n", k);

//level4
    for (int i = 0; i < 18; i++)
    {
        zetas_exp[k++] = (ntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[4][(i << 2)];
        zetas_exp[k++] = ntt_tree[4][(i << 2)];
        zetas_exp[k++] = ntt_tree[4][(i << 2)];
        zetas_exp[k++] = ntt_tree[4][(i << 2)];
        zetas_exp[k++] = ntt_tree[4][(i << 2)];
        zetas_exp[k++] = ntt_tree[4][(i << 2)];
        zetas_exp[k++] = ntt_tree[4][(i << 2)];
        zetas_exp[k++] = ntt_tree[4][(i << 2)];

        zetas_exp[k++] = ntt_tree[4][(i << 2) + 2];
        zetas_exp[k++] = ntt_tree[4][(i << 2) + 2];
        zetas_exp[k++] = ntt_tree[4][(i << 2) + 2];
        zetas_exp[k++] = ntt_tree[4][(i << 2) + 2];
        zetas_exp[k++] = ntt_tree[4][(i << 2) + 2];
        zetas_exp[k++] = ntt_tree[4][(i << 2) + 2];
        zetas_exp[k++] = ntt_tree[4][(i << 2) + 2];
        zetas_exp[k++] = ntt_tree[4][(i << 2) + 2];
    }
    printf("k : %d\n", k);

//level5
    for (int i = 0; i < 18; i++)
    {
        zetas_exp[k++] = (ntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3) + 6] * QINV) & 0xffff;


        zetas_exp[k++] = ntt_tree[5][(i << 3)];
        zetas_exp[k++] = ntt_tree[5][(i << 3)];
        zetas_exp[k++] = ntt_tree[5][(i << 3)];
        zetas_exp[k++] = ntt_tree[5][(i << 3)];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 2];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 2];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 2];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 2];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 4];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 4];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 4];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 4];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 6];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 6];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 6];
        zetas_exp[k++] = ntt_tree[5][(i << 3) + 6];
    }
    
    printf("k : %d\n", k);

//level6
    for (int i = 0; i < 18; i++)
    {
        zetas_exp[k++] = (ntt_tree[6][(i << 4)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 8] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 8] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 10] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 10] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 12] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 12] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 14] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4) + 14] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[6][(i << 4)];
        zetas_exp[k++] = ntt_tree[6][(i << 4)];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 2];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 2];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 4];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 4];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 6];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 6];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 8];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 8];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 10];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 10];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 12];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 12];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 14];
        zetas_exp[k++] = ntt_tree[6][(i << 4) + 14];        
    }

    printf("k : %d\n", k);

//level7
    for (int i = 0; i < 18; i++)
    {
        zetas_exp[k++] = (ntt_tree[7][(i << 5)     ] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) +  2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) +  4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) +  6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) +  8] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 10] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 12] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 14] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 16] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 18] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 20] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 22] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 24] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 26] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 28] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[7][(i << 5) + 30] * QINV) & 0xffff;
                
        zetas_exp[k++] = ntt_tree[7][(i << 5)];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 2];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 4];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 6];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 8];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 10];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 12];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 14];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 16];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 18];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 20];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 22];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 24];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 26];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 28];
        zetas_exp[k++] = ntt_tree[7][(i << 5) + 30];
    }

    printf("k : %d\n", k);
}

void invntt_encode()
{
    int k = 0;

//level7
    for (int i = 0; i < 18; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 8] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 10] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 12] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 14] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 16] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 18] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 20] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 22] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 24] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 26] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 28] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[7][(i << 5) + 30] * QINV) & 0xffff;
                
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5)];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 2];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 4];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 6];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 8];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 10];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 12];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 14];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 16];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 18];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 20];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 22];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 24];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 26];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 28];
        zetas_inv_exp[k++] = invntt_tree[7][(i << 5) + 30];
    }

    printf("k : %d\n", k);

//level6
    for (int i = 0; i < 18; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 8] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 8] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 10] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 10] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 12] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 12] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 14] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4) + 14] * QINV) & 0xffff;

        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 2];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 2];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 4];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 4];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 6];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 6];
        
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 8];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 8];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 10];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 10];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 12];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 12];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 14];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4) + 14];        
    }

    printf("k : %d\n", k);

//level5
    for (int i = 0; i < 18; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3) + 6] * QINV) & 0xffff;


        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 4];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 4];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 4];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 4];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 6];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 6];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 6];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3) + 6];
    }
    
        printf("k : %d\n", k);

//level4
    for (int i = 0; i < 18; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;

        zetas_inv_exp[k++] = invntt_tree[4][(i << 2)];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2)];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2)];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2)];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2)];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2)];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2)];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2)];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2) + 2];
        zetas_inv_exp[k++] = invntt_tree[4][(i << 2) + 2];   
    }
    printf("k : %d\n", k);

//level3
    for (int i = 0; i < 18; i++)
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
        zetas_inv_exp[k++] = (invntt_tree[2][6*i] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[2][6*i] * QINV) & 0xffff;

        zetas_inv_exp[k++] = invntt_tree[2][6*i];
        zetas_inv_exp[k++] = invntt_tree[2][6*i];

        zetas_inv_exp[k++] = (invntt_tree[2][6*i+1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[2][6*i+1] * QINV) & 0xffff;

        zetas_inv_exp[k++] = invntt_tree[2][6*i+1];
        zetas_inv_exp[k++] = invntt_tree[2][6*i+1];

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
        zetas_inv_exp[k++] = (1792 * QINV) & 0xffff;
        zetas_inv_exp[k++] = (1792 * QINV) & 0xffff;
        zetas_inv_exp[k++] = 1792;
        zetas_inv_exp[k++] = 1792;

        //기억이 안남.... 전체적인 기법이랑, 3*2^x의 역수 포함
        zetas_inv_exp[k++] = (1712 * QINV) & 0xffff;
        zetas_inv_exp[k++] = (1712 * QINV) & 0xffff;
        zetas_inv_exp[k++] = 1712;
        zetas_inv_exp[k++] = 1712; //&3391
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

    for (int j = 1; j < 7; j++)
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

    printf("int16_t zetas[2444] = {");
    for (int i = 0; i < 2443; i++)
    {
        printf("%d, ", zetas_exp[i]);
    }
    printf("%d};", zetas_exp[2443]);
    printf("\n\n");
}

void invntt()
{
    trans_tree_inv();
    invntt_encode();

    printf("int16_t zetas_inv[2448] = {");
    for (int i = 0; i < 2447; i++)
    {
        printf("%d, ", zetas_inv_exp[i]);
    }
    printf("%d};", zetas_inv_exp[2447]);
    printf("\n\n");

}



int main(void)
{
    init();

    ntt();
    invntt();

    return 0;
}