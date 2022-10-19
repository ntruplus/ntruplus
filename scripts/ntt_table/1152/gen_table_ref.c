#include <stdio.h>

#define Q 3457
#define QINV 12929


//basic
int exp_table[3456] = {0};

//tree
int tree[10][1152] = {0};
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
    int a = 5;

    //exp_table[0] = (1 << 16) % Q;
    exp_table[0] = 1;
    for (int i = 1; i < 3456; i++)
    {
        exp_table[i] = (exp_table[i-1] * a) % Q;
    }
}
void gen_tree()
{
    int t;

    tree[0][0] = 576;
    tree[0][1] = 2880;

    for (int j = 0; j < 2; j++)
    {
        for (int i = 0; i < (2 << j); i++)
        {
            tree[j+1][2*i+0] = tree[j][i]/2;
            tree[j+1][2*i+1] = tree[j+1][2*i+0] + 1728;
        }
    } 

    t = 16;
    for (int j = 2; j < 4; j++)
    {
        for (int i = 0; i < t; i++)
        {
            tree[j+1][3*i+0] = tree[j][i]/3;
            tree[j+1][3*i+1] = tree[j+1][3*i+0] + 1728;
            tree[j+1][3*i+2] = tree[j+1][3*i+1] + 1728;
        }

        t = t*3;
    }

    for (int j = 4; j < 8; j++)
    {
        for (int i = 0; i < t; i++)
        {
            tree[j+1][2*i+0] = tree[j][i]/2;
            tree[j+1][2*i+1] = tree[j+1][2*i+0] + 1728;
        }

        t = t*2;
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
            invntt_tree[j][i] = exp_table[384 - tree[j][i]];
        }
    }  
}
void ntt_encode()
{
    int k = 0;

//level0 ~ 6
    for(int j = 0; j < 7; j++)
    {
        for (int i = 0; i < (1 << j); i++)
        {                
            zetas_exp[k++] = ntt_tree[j][i << 1];
        }
        printf("k : %d\n", k);
    }
}

void invntt_encode()
{
    int k = 0;

//level6 ~ 1
    for(int j = 6; j > 0; j--)
    {
        for (int i = 0; i < (1 << j); i++)
        {                
            zetas_inv_exp[k++] = invntt_tree[j][(i << 1)];
        }
        printf("k : %d\n", k);
    }
      
//level0
    //(z-z^5)^-1
    zetas_inv_exp[k++] = 1665;

    //기억이 안남.... 전체적인 기법이랑, 3*2^x의 역수 포함
    zetas_inv_exp[k++] = 2568;
    
    printf("k : %d\n", k);
}

void init()
{
    int t;
    gen_exp();

    gen_tree();

    printf("tree\n");
    for (int j = 0; j < 4; j++)
    {
        printf("level %d\n", j);
        for (int i = 0; i < (2 << j); i++)
        {
            printf("%d ", tree[j][i]);
        }
        printf("\n\n");
    }

    t = 32;
    for (int j = 4; j < 6; j++)
    {
        printf("level %d\n", j);
        for (int i = 0; i < t; i++)
        {
            printf("%d ", tree[j][i]);
        }
        printf("\n\n");

        t = t*3;
    }

    t = 288;
    for (int j = 6; j < 9; j++)
    {
        printf("level %d\n", j);
        for (int i = 0; i < t; i++)
        {
            printf("%d ", tree[j][i]);
        }
        printf("\n\n");

        t = t*2;
    }
/*
    for (int j = 0; j < 2; j++)
    {
        for (int i = 0; i < (2 << j); i++)
        {
            tree[j+1][2*i+0] = tree[j][i]/2;
            tree[j+1][2*i+1] = tree[j+1][2*i+0] + 1728;
        }
    } 

    t = 16;
    for (int j = 2; j < 4; j++)
    {
        for (int i = 0; i < t; i++)
        {
            tree[j+1][3*i+0] = tree[j][i]/3;
            tree[j+1][3*i+1] = tree[j+1][3*i+0] + 1728;
            tree[j+1][3*i+2] = tree[j+1][3*i+1] + 1728;
        }

        t = t*3;
    }

    for (int j = 4; j < 8; j++)
    {
        for (int i = 0; i < t; i++)
        {
            tree[j+1][2*i+0] = tree[j][i]/2;
            tree[j+1][2*i+1] = tree[j+1][2*i+0] + 1728;
        }

        t = t*2;
    }
*/

}

void ntt()
{
    trans_tree();
    ntt_encode();

    printf("int16_t zetas[127] = {");
    for (int i = 0; i < 126; i++)
    {
        printf("%d, ", zetas_exp[i]);
    }
    printf("%d};", zetas_exp[126]);
    printf("\n\n");
}

void invntt()
{
    trans_tree_inv();
    invntt_encode();

    printf("int16_t zetas_inv[127] = {");
    for (int i = 0; i < 126; i++)
    {
        printf("%d, ", zetas_inv_exp[i]);
    }
    printf("%d};", zetas_inv_exp[126]);
    printf("\n\n");
}

int main(void)
{
    init();
/*
    ntt();
    invntt();
*/
    return 0;
}