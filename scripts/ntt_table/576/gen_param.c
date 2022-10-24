#include <stdio.h>

#define Q 3457
#define QINV 12929

//basic
int exp_table[384] = {0};

//tree
int tree[7][1024] = {0};
int table[3900] = {0};

//ntt
int ntt_tree[8][768] = {0};
int zetas_exp[1852] = {0};

//mul
int zetas_mul_exp[3900] = {0};

//invntt
int invntt_tree[8][768] = {0};
int zetas_inv_exp[1856] = {0};

void gen_exp()
{
    int a = 10;

    exp_table[0] = (1 << 16) % Q;

    for (int i = 1; i < 384; i++)
    {
        exp_table[i] = (exp_table[i-1] * a) % Q;
    }
}
void gen_tree()
{
    tree[0][0] = 64;
    tree[0][1] = 320;

    for (int j = 0; j < 6; j++)
    {
        for (int i = 0; i < (2 << j); i++)
        {
            tree[j+1][2*i+0] = tree[j][i]/2;
            tree[j+1][2*i+1] = tree[j+1][2*i+0] + 192;
        }
    } 
}
void trans_tree()
{
    for (int j = 0; j < 7; j++)
    {
        for (int i = 0; i < (2 << j); i++)
        {
            ntt_tree[j][i] = exp_table[tree[j][i]];
        }
    }  
}
void trans_tree_inv()
{
    for (int j = 0; j < 7; j++)
    {
        for (int i = 0; i < (2 << j); i++)
        {
            invntt_tree[j][i] = exp_table[1152 - tree[j][i]];
        }
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
        zetas_exp[k++] = (ntt_tree[1][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[1][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = ntt_tree[1][i << 1];
        zetas_exp[k++] = ntt_tree[1][i << 1];
    }
    printf("k : %d\n", k);
//level2
    for (int i = 0; i < 4; i++)
    {
        zetas_exp[k++] = (ntt_tree[2][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[2][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = ntt_tree[2][i << 1];
        zetas_exp[k++] = ntt_tree[2][i << 1];
    }
    printf("k : %d\n", k);
//level3
    for (int i = 0; i < 8; i++)
    {
        zetas_exp[k++] = (ntt_tree[3][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[3][i << 1] * QINV) & 0xffff;
        zetas_exp[k++] = ntt_tree[3][i << 1];      
        zetas_exp[k++] = ntt_tree[3][i << 1];
    }
    printf("k : %d\n", k);
//level4
    for (int i = 0; i < 8; i++)
    {
        zetas_exp[k++] = (ntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[4][i << 2];
        zetas_exp[k++] = ntt_tree[4][i << 2];
        zetas_exp[k++] = ntt_tree[4][i << 2];
        zetas_exp[k++] = ntt_tree[4][i << 2];
        zetas_exp[k++] = ntt_tree[4][i << 2];
        zetas_exp[k++] = ntt_tree[4][i << 2];
        zetas_exp[k++] = ntt_tree[4][i << 2];
        zetas_exp[k++] = ntt_tree[4][i << 2];
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
    for (int i = 0; i < 8; i++)
    {
        zetas_exp[k++] = (ntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[5][(i << 3)+6] * QINV) & 0xffff;

        zetas_exp[k++] = ntt_tree[5][(i << 3)];
        zetas_exp[k++] = ntt_tree[5][(i << 3)];
        zetas_exp[k++] = ntt_tree[5][(i << 3)];
        zetas_exp[k++] = ntt_tree[5][(i << 3)];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+2];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+4];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+4];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+4];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+4];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+6];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+6];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+6];
        zetas_exp[k++] = ntt_tree[5][(i << 3)+6];
    }
        printf("k : %d\n", k);
//level6
    for (int i = 0; i < 8; i++)
    {
        zetas_exp[k++] = (ntt_tree[6][(i << 4)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+2] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+4] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+6] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+8] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+8] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+10] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+10] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+12] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+12] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+14] * QINV) & 0xffff;
        zetas_exp[k++] = (ntt_tree[6][(i << 4)+14] * QINV) & 0xffff;
                
        zetas_exp[k++] = ntt_tree[6][(i << 4)];
        zetas_exp[k++] = ntt_tree[6][(i << 4)];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+2];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+2];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+4];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+4];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+6];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+6];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+8];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+8];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+10];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+10];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+12];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+12];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+14];
        zetas_exp[k++] = ntt_tree[6][(i << 4)+14];
    }

    printf("k : %d\n", k);
}

void mul_encode()
{
    int k = 0;

    for (int i = 0; i < 8; i++)
    {
        //alpha, beta
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 0] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 2] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 12] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 14] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 24] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 26] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 36] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 38] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 48] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 50] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 60] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 62] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 72] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 74] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 84] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 86] * QINV) & 0xffff;

        zetas_mul_exp[k++] = ntt_tree[7][96*i + 0];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 2];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 12];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 14];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 24];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 26];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 36];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 38];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 48];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 50];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 60];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 62];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 72];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 74];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 84];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 86];

        //gamma, alpha
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 4] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 6] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 16] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 18] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 28] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 30] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 40] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 42] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 52] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 54] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 64] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 66] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 76] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 78] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 88] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 90] * QINV) & 0xffff;

        zetas_mul_exp[k++] = ntt_tree[7][96*i + 4];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 6];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 16];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 18];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 28];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 30];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 40];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 42];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 52];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 54];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 64];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 66];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 76];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 78];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 88];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 90];

        //beta, gamma
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 8] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 10] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 20] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 22] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 32] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 34] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 44] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 46] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 56] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 58] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 68] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 70] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 80] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 82] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 92] * QINV) & 0xffff;
        zetas_mul_exp[k++] = (ntt_tree[7][96*i + 94] * QINV) & 0xffff;

        zetas_mul_exp[k++] = ntt_tree[7][96*i + 8];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 10];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 20];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 22];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 32];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 34];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 44];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 46];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 56];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 58];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 68];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 70];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 80];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 82];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 92];
        zetas_mul_exp[k++] = ntt_tree[7][96*i + 94];
    }

    printf("k : %d\n", k);    
}
void invntt_encode()
{
    int k = 0;

//level7
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            //alpha^-1  alpha^-2 
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 0] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 0] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 12] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 12] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 24] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 24] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 36] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 36] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 48] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 48] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 60] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 60] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 72] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 72] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 84] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 84] * QINV) & 0xffff;

            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 0];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 0];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 12];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 12];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 24];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 24];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 36];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 36];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 48];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 48];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 60];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 60];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 72];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 72];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 84];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 84];
        }
        for (int j = 0; j < 2; j++)
        {
            //alpha^-1  alpha^-2 
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 6] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 6] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 18] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 18] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 30] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 30] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 42] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 42] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 54] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 54] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 66] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 66] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 78] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 78] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 90] * QINV) & 0xffff;
            zetas_inv_exp[k++] = (invntt_tree[7][96*i + j + 90] * QINV) & 0xffff;

            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 6];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 6];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 18];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 18];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 30];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 30];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 42];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 42];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 54];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 54];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 66];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 66];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 78];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 78];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 90];
            zetas_inv_exp[k++] = invntt_tree[7][96*i + j + 90];
        }
    }  
    printf("k : %d\n", k); 

//level6
    for (int i = 0; i < 8; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+8] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+8] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+10] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+10] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+12] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+12] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+14] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[6][(i << 4)+14] * QINV) & 0xffff;
                
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+2];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+2];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+4];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+4];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+6];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+6];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+8];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+8];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+10];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+10];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+12];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+12];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+14];
        zetas_inv_exp[k++] = invntt_tree[6][(i << 4)+14];
    }

    printf("k : %d\n", k);

//level5
    for (int i = 0; i < 8; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+4] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+6] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[5][(i << 3)+6] * QINV) & 0xffff;

        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+2];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+4];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+4];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+4];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+4];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+6];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+6];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+6];
        zetas_inv_exp[k++] = invntt_tree[5][(i << 3)+6];
    }
        printf("k : %d\n", k);

//level4
    for (int i = 0; i < 8; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][i << 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[4][(i << 2) + 2] * QINV) & 0xffff;

        zetas_inv_exp[k++] = invntt_tree[4][i << 2];
        zetas_inv_exp[k++] = invntt_tree[4][i << 2];
        zetas_inv_exp[k++] = invntt_tree[4][i << 2];
        zetas_inv_exp[k++] = invntt_tree[4][i << 2];
        zetas_inv_exp[k++] = invntt_tree[4][i << 2];
        zetas_inv_exp[k++] = invntt_tree[4][i << 2];
        zetas_inv_exp[k++] = invntt_tree[4][i << 2];
        zetas_inv_exp[k++] = invntt_tree[4][i << 2];
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
    for (int i = 0; i < 8; i++)
    {
        zetas_inv_exp[k++] = (invntt_tree[3][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[3][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = invntt_tree[3][i << 1];      
        zetas_inv_exp[k++] = invntt_tree[3][i << 1];
    }
    printf("k : %d\n", k);

//level2
    for (int i = 0; i < 4; i++)
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
        zetas_inv_exp[k++] = (invntt_tree[1][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = (invntt_tree[1][i << 1] * QINV) & 0xffff;
        zetas_inv_exp[k++] = invntt_tree[1][i << 1];
        zetas_inv_exp[k++] = invntt_tree[1][i << 1];
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
    gen_exp();

    gen_tree();

    printf("tree\n");
    for (int j = 0; j < 7; j++)
    {
        printf("level %d\n", j);
        for (int i = 0; i < (2 << j); i++)
        {
            printf("%d ", tree[j][i]);
        }
        printf("\n");
    }

    printf("level %d\n", 6);
    for (int i = 0; i < 128; i++)
    {
        printf("%d ", tree[6][i]);
    }
    printf("\n");

    printf("level %d\n", 7);
    for (int i = 0; i < 768; i++)
    {
        printf("%d ", tree[7][i]);
    }
    printf("\n");
}

void ntt()
{
    trans_tree();
    ntt_encode();

    printf("zetas_exp\n");
    for (int i = 0; i < 1852; i++)
    {
        printf("%d, ", zetas_exp[i]);
    }
    printf("\n");
}

void mul()
{
    mul_encode();

    printf("zetas_mul_exp\n");
    for (int i = 0; i < 768; i++)
    {
        printf("%d, ", zetas_mul_exp[i]);
    }
    printf("\n");    
}
void invntt()
{
    trans_tree_inv();
    invntt_encode();

    printf("table\n");
    for (int i = 0; i < 1856; i++)
    {
        printf("%d, ", zetas_inv_exp[i]);
    }
    printf("\n");
}

int main(void)
{
    //init();

    //ntt();
    //mul();
    //invntt();

    return 0;
}