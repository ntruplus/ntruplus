#include "cpa_pke.h"
#include "aux_func.h"

int cpa_pke_keygen(poly *hhat, poly *fhat, const unsigned char coins[N/2])
{
    int r;
    poly f, g;

    psi_1_n(&f, coins);
    psi_1_n(&g, coins + N/4);

    poly_triple(&g, &g);
    poly_triple(&f, &f);
    f.coeffs[0] += 1;

    poly_ntt(fhat, &f);
    poly_ntt(&g, &g);
    poly_freeze(fhat);
      
    r = poly_baseinv(&f, fhat);
    poly_basemul(hhat, &f, &g);
    poly_freeze(hhat);

    return r;
}

void cpa_pke_encrypt(poly *chat, const poly *hhat, const unsigned char *msg, const unsigned char coins[320])
{
    poly e, r;

    psi_1_n(&r, coins);
    psi_1_n_lambda(&e, coins + N/4);
    G(&e, msg);

    poly_ntt(&r, &r);
    poly_ntt(&e, &e);
    poly_basemul(chat, &r, hhat);
    poly_reduce(chat);
    poly_add(chat, chat, &e);
    poly_freeze(chat);
}

void cpa_pke_decrypt(unsigned char *msg, const poly *chat, const poly *fhat)
{
    poly e;

    poly_basemul(&e, chat, fhat);
    poly_reduce(&e);
    poly_invntt(&e, &e);
    poly_crepmod3(&e, &e);

    G_inv(msg, &e);
}