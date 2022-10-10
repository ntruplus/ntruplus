#ifndef INDCPA_H
#define INDCPA_H

#include <stdint.h>
#include "params.h"

void indcpa_keypair(uint8_t pk[NTRUPLUS_INDCPA_PUBLICKEYBYTES],
                    uint8_t sk[NTRUPLUS_INDCPA_SECRETKEYBYTES]);

void indcpa_enc(uint8_t c[NTRUPLUS_INDCPA_BYTES],
                const uint8_t m[NTRUPLUS_INDCPA_MSGBYTES],
                const uint8_t pk[NTRUPLUS_INDCPA_PUBLICKEYBYTES],
                const uint8_t coins[NTRUPLUS_SYMBYTES]);

void indcpa_dec(uint8_t m[NTRUPLUS_INDCPA_MSGBYTES],
                const uint8_t c[NTRUPLUS_INDCPA_BYTES],
                const uint8_t sk[NTRUPLUS_INDCPA_SECRETKEYBYTES]);

#endif
