#include <stdio.h>

#define Q 3457
#define QINV 12929


//basic
int exp_table[3456] = {0};

//tree
int tree[10][1152] = {0};
int table[3900] = {0};

//ntt
int ntt_tree[9][1152] = {0};
int zetas_exp[1152] = {0};

//mul
int zetas_mul_exp[3900] = {0};

//invntt
int invntt_tree[9][1152] = {0};
int zetas_inv_exp[1152] = {0};

void gen_exp()
{
    int a = 7;

    exp_table[0] = (1 << 16) % Q;
    //exp_table[0] = 1;
    for (int i = 1; i < 3456; i++)
    {
        exp_table[i] = (exp_table[i-1] * a) % Q;
    }
}
void gen_tree()
{
    int t = 2;

    tree[0][0] = 576;
    tree[0][1] = 2880;

    for (int j = 0; j < 2; j++)
    {
        for (int i = 0; i < t; i++)
        {
            tree[j+1][3*i+0] = tree[j][i]/3;
            tree[j+1][3*i+1] = tree[j+1][3*i+0] + 1152;
            tree[j+1][3*i+2] = tree[j+1][3*i+1] + 1152;
        }

        t = t*3;
    }

    for (int j = 2; j < 8; j++)
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
    int t;

    ntt_tree[0][0] = exp_table[tree[0][0]];
    ntt_tree[0][1] = exp_table[tree[0][1]];

    t = 6;

    for (int j = 1; j < 3; j++)
    {
        for (int i = 0; i < t; i++)
        {
            ntt_tree[j][2*i] = exp_table[tree[j][i]];
            ntt_tree[j][2*i+1] = exp_table[(tree[j][i] << 1) % 3456];
        }

        t = t*3;
    }

    for (int j = 3; j < 9; j++)
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

    invntt_tree[0][0] = exp_table[3456 - tree[0][0]];
    invntt_tree[0][1] = exp_table[3456 - tree[0][1]];

    t = 6;

    for (int j = 1; j < 3; j++)
    {
        for (int i = 0; i < t; i++)
        {
            invntt_tree[j][2*i] = exp_table[3456 - tree[j][i]];
            invntt_tree[j][2*i+1] = exp_table[((3456 - tree[j][i])*2) % 3456];
        }

        t = t*3;
    }

    for (int j = 3; j < 9; j++)
    {
        for (int i = 0; i < t; i++)
        {
            invntt_tree[j][i] = exp_table[3456 - tree[j][i]];
        }

        t = t*2;
    }
}

void ntt_encode()
{
    int k = 0;
    int t;
//level 0
    zetas_exp[k++] = ntt_tree[0][0];
    t = 2;
    printf("level 0 - k : %d\n", k);
    
//level 1 ~ 2
    for(int j = 1; j < 3; j++)
    {
        for (int i = 0; i < t; i++)
        {                
            zetas_exp[k++] = ntt_tree[j][6*i];
            zetas_exp[k++] = ntt_tree[j][6*i+1];
        }

        t = t*3;
        printf("level %d - k : %d\n", j, k);
    }
//level 3 ~ 9
    for(int j = 3; j < 9; j++)
    {
        for (int i = 0; i < t; i++)
        {                
            zetas_exp[k++] = ntt_tree[j][2*i];
        }

        t = t*2;
        printf("level %d - k : %d\n", j, k);
    }
}

void invntt_encode()
{
    int k = 0;
    int t;

//level6 ~ 1
    t = 1152;

    for(int j = 8; j >= 3; j--)
    {
        t = t/2;

        for (int i = 0; i < t; i++)
        {                
            zetas_inv_exp[k++] = invntt_tree[j][2*i];
        }

        printf("level %d - k : %d\n", j, k);
    }

    for(int j = 2; j >= 1; j--)
    {
        t = t/3;

        for (int i = 0; i < t; i++)
        {                
            zetas_inv_exp[k++] = invntt_tree[j][6*i];
            zetas_inv_exp[k++] = invntt_tree[j][6*i+1];            
        }

        printf("level %d - k : %d\n", j, k);
    }
    
//level0
    //(z-z^5)^-1
    zetas_inv_exp[k++] = 1665;
    
    printf("level %d - k : %d\n", 0, k);
}

void init()
{
    int t;
    gen_exp();

    gen_tree();

    printf("tree\n");
    t = 2;
    for (int j = 0; j < 2; j++)
    {
        printf("level %d\n", j);
        for (int i = 0; i < t; i++)
        {
            printf("%d ", tree[j][i]);
        }
        printf("\n\n");

        t = t*3;
    }

    for (int j = 2; j < 7; j++)
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

    printf("int16_t zetas[1151] = {");
    for (int i = 0; i < 1150; i++)
    {
        printf("%d, ", zetas_exp[i]);
    }
    printf("%d};", zetas_exp[1150]);
    printf("\n\n");
}

void invntt()
{
    trans_tree_inv();
 
    invntt_encode();

    printf("int16_t zetas_inv[1151] = {");
    for (int i = 0; i < 1150; i++)
    {
        printf("%d, ", zetas_inv_exp[i]);
    }
    printf("%d};", zetas_inv_exp[1150]);
    printf("\n\n");

}

int main(void)
{
    init();

    ntt();

    invntt();

    return 0;
}