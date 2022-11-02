#include <stdio.h>

#define Q 3457
#define QINV 12929

//basic
int exp_table[1152] = {0};

//tree
int tree[8][768] = {0};
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

    exp_table[0] = (1 << 16) % Q;

    for (int i = 1; i < 1152; i++)
    {
        exp_table[i] = (exp_table[i-1] * a) % Q;
    }
}
void gen_tree()
{
    tree[0][0] = 192;
    tree[0][1] = 960;

    for (int j = 0; j < 6; j++)
    {
        for (int i = 0; i < (2 << j); i++)
        {
            tree[j+1][2*i+0] = tree[j][i]/2;
            tree[j+1][2*i+1] = tree[j+1][2*i+0] + 576;
        }
    }

    for (int i = 0; i < 128; i++)
    {

        //alpha
        tree[7][6*i + 0] = tree[6][i] / 3;
        //alpha^2
        tree[7][6*i + 1] = tree[7][6*i + 0] << 1;
        //beta
        tree[7][6*i + 2] = (tree[7][6*i + 0] + 384) % 1152;
        //beta^2
        tree[7][6*i + 3] = (tree[7][6*i + 2] * 2) % 1152;
        //gamma               
        tree[7][6*i + 4] = (tree[7][6*i + 2] + 384) % 1152;
        //gamma^2        
        tree[7][6*i + 5] = (tree[7][6*i + 4] * 2) % 1152;
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

    for (int i = 0; i < 768; i++)
    {
        ntt_tree[7][i] = exp_table[tree[7][i]];
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

    for (int i = 0; i < 768; i++)
    {
        invntt_tree[7][i] = exp_table[1152 - tree[7][i]];
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
        //printf("k : %d\n", k);
    }

//level7
    for (int i = 0; i < 128; i++)
    {
        //alpha, alpha^2
        zetas_exp[k++] = ntt_tree[7][6*i + 0];
        zetas_exp[k++] = ntt_tree[7][6*i + 1];
        /*
        zetas_exp[k++] = ntt_tree[7][6*i + 2];
        zetas_exp[k++] = ntt_tree[7][6*i + 3];
        zetas_exp[k++] = ntt_tree[7][6*i + 4];
        zetas_exp[k++] = ntt_tree[7][6*i + 5];        
        */
    }        

    //printf("k : %d\n", k);
}

void mul_encode()
{
    int k = 0;

    for (int i = 0; i < 128; i++)
    {
        zetas_mul_exp[k++] = ntt_tree[7][6*i + 0];
        zetas_mul_exp[k++] = ntt_tree[7][6*i + 2];
        zetas_mul_exp[k++] = ntt_tree[7][6*i + 4];
    }

    //printf("k : %d\n", k);    
}
void invntt_encode()
{
    int k = 0;

//level7
    for(int i = 0; i < 128; i++)
    {
        //alpha^-1  alpha^-2 
        zetas_inv_exp[k++] = invntt_tree[7][6*i + 0];
        zetas_inv_exp[k++] = invntt_tree[7][6*i + 1];
/*
        zetas_inv_exp[k++] = invntt_tree[7][6*i + 2];
        zetas_inv_exp[k++] = invntt_tree[7][6*i + 3]; 
        zetas_inv_exp[k++] = invntt_tree[7][6*i + 4];
        zetas_inv_exp[k++] = invntt_tree[7][6*i + 5];
*/
    }
    //printf("k : %d\n", k); 

//level6 ~ 1
    for(int j = 6; j > 0; j--)
    {
        for (int i = 0; i < (1 << j); i++)
        {                
            zetas_inv_exp[k++] = invntt_tree[j][(i << 1)];
        }
        //printf("k : %d\n", k);
    }
      
//level0
    //(z-z^5)^-1
    zetas_inv_exp[k++] = 1665;

    //기억이 안남.... 전체적인 기법이랑, 3*2^x의 역수 포함
    zetas_inv_exp[k++] = 2568;
    
    //printf("k : %d\n", k);
}

void init()
{
    gen_exp();

    gen_tree();
/*
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
    */
}

void ntt()
{
    trans_tree();
    ntt_encode();

    printf("zetas_exp[383] = {");
    for (int i = 0; i < 382; i++)
    {
        printf("%d, ", zetas_exp[i]);
    }
    printf("%d};", zetas_exp[382]);
    printf("\n\n");
}

void mul()
{
    mul_encode();

    printf("zetas_mul_exp[384] = {");
    for (int i = 0; i < 383; i++)
    {
        printf("%d, ", zetas_mul_exp[i]);
    }
    printf("%d};", zetas_mul_exp[383]);
    printf("\n\n");    
}
void invntt()
{
    trans_tree_inv();
    invntt_encode();

    printf("zetas_inv[384] = {");
    for (int i = 0; i < 383; i++)
    {
        printf("%d, ", zetas_inv_exp[i]);
    }
    printf("%d};", zetas_inv_exp[383]);
    printf("\n\n");
}

int main(void)
{
    init();

    ntt();
    mul();
    invntt();

    return 0;
}