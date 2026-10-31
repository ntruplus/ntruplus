/*
 * SHAKE256 specialized and amalgamated from XKCP (CC0-1.0).
 * https://creativecommons.org/publicdomain/zero/1.0/
 * https://github.com/XKCP/XKCP
 * Commit: 5585d0213203c0c5b2dfdf3b34f5da9275abc3e7.
 * Keccak designers: Guido Bertoni, Joan Daemen, Michaël Peeters,
 * and Gilles Van Assche. XKCP implementers: Gilles Van Assche,
 * Ronny Van Keer, and the XKCP contributors.
 * Modified for NTRU+: little-endian SHAKE256 only, non-complemented
 * lanes, six-round unrolling, and a fixed 17-lane absorb loop.
 */
#include "fips202.h"
#include <string.h>

#if defined(__BYTE_ORDER__) && __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
#error "This SHAKE256 implementation requires little-endian byte order"
#endif

#define ROL64(a, offset) ((((uint64_t)(a)) << (offset)) ^ (((uint64_t)(a)) >> (64 - (offset))))

static const uint64_t KeccakF1600RoundConstants[24] = {
    0x0000000000000001ULL,
    0x0000000000008082ULL,
    0x800000000000808aULL,
    0x8000000080008000ULL,
    0x000000000000808bULL,
    0x0000000080000001ULL,
    0x8000000080008081ULL,
    0x8000000000008009ULL,
    0x000000000000008aULL,
    0x0000000000000088ULL,
    0x0000000080008009ULL,
    0x000000008000000aULL,
    0x000000008000808bULL,
    0x800000000000008bULL,
    0x8000000000008089ULL,
    0x8000000000008003ULL,
    0x8000000000008002ULL,
    0x8000000000000080ULL,
    0x000000000000800aULL,
    0x800000008000000aULL,
    0x8000000080008081ULL,
    0x8000000000008080ULL,
    0x0000000080000001ULL,
    0x8000000080008008ULL };

#define declareABCDE \
    uint64_t Aba = 0, Abe = 0, Abi = 0, Abo = 0, Abu = 0; \
    uint64_t Aga = 0, Age = 0, Agi = 0, Ago = 0, Agu = 0; \
    uint64_t Aka = 0, Ake = 0, Aki = 0, Ako = 0, Aku = 0; \
    uint64_t Ama = 0, Ame = 0, Ami = 0, Amo = 0, Amu = 0; \
    uint64_t Asa = 0, Ase = 0, Asi = 0, Aso = 0, Asu = 0; \
    uint64_t Bba, Bbe, Bbi, Bbo, Bbu; \
    uint64_t Bga, Bge, Bgi, Bgo, Bgu; \
    uint64_t Bka, Bke, Bki, Bko, Bku; \
    uint64_t Bma, Bme, Bmi, Bmo, Bmu; \
    uint64_t Bsa, Bse, Bsi, Bso, Bsu; \
    uint64_t Ca, Ce, Ci, Co, Cu; \
    uint64_t Da, De, Di, Do, Du; \
    uint64_t Eba, Ebe, Ebi, Ebo, Ebu; \
    uint64_t Ega, Ege, Egi, Ego, Egu; \
    uint64_t Eka, Eke, Eki, Eko, Eku; \
    uint64_t Ema, Eme, Emi, Emo, Emu; \
    uint64_t Esa, Ese, Esi, Eso, Esu;

#define prepareTheta \
    Ca = Aba^Aga^Aka^Ama^Asa; \
    Ce = Abe^Age^Ake^Ame^Ase; \
    Ci = Abi^Agi^Aki^Ami^Asi; \
    Co = Abo^Ago^Ako^Amo^Aso; \
    Cu = Abu^Agu^Aku^Amu^Asu;

#define thetaRhoPiChiIotaPrepareTheta(i, A, E) \
    Da = Cu^ROL64(Ce, 1); \
    De = Ca^ROL64(Ci, 1); \
    Di = Ce^ROL64(Co, 1); \
    Do = Ci^ROL64(Cu, 1); \
    Du = Co^ROL64(Ca, 1); \
\
    A##ba ^= Da; \
    Bba = A##ba; \
    A##ge ^= De; \
    Bbe = ROL64(A##ge, 44); \
    A##ki ^= Di; \
    Bbi = ROL64(A##ki, 43); \
    A##mo ^= Do; \
    Bbo = ROL64(A##mo, 21); \
    A##su ^= Du; \
    Bbu = ROL64(A##su, 14); \
    E##ba =   Bba ^((~Bbe)&  Bbi ); \
    E##ba ^= KeccakF1600RoundConstants[i]; \
    Ca = E##ba; \
    E##be =   Bbe ^((~Bbi)&  Bbo ); \
    Ce = E##be; \
    E##bi =   Bbi ^((~Bbo)&  Bbu ); \
    Ci = E##bi; \
    E##bo =   Bbo ^((~Bbu)&  Bba ); \
    Co = E##bo; \
    E##bu =   Bbu ^((~Bba)&  Bbe ); \
    Cu = E##bu; \
\
    A##bo ^= Do; \
    Bga = ROL64(A##bo, 28); \
    A##gu ^= Du; \
    Bge = ROL64(A##gu, 20); \
    A##ka ^= Da; \
    Bgi = ROL64(A##ka, 3); \
    A##me ^= De; \
    Bgo = ROL64(A##me, 45); \
    A##si ^= Di; \
    Bgu = ROL64(A##si, 61); \
    E##ga =   Bga ^((~Bge)&  Bgi ); \
    Ca ^= E##ga; \
    E##ge =   Bge ^((~Bgi)&  Bgo ); \
    Ce ^= E##ge; \
    E##gi =   Bgi ^((~Bgo)&  Bgu ); \
    Ci ^= E##gi; \
    E##go =   Bgo ^((~Bgu)&  Bga ); \
    Co ^= E##go; \
    E##gu =   Bgu ^((~Bga)&  Bge ); \
    Cu ^= E##gu; \
\
    A##be ^= De; \
    Bka = ROL64(A##be, 1); \
    A##gi ^= Di; \
    Bke = ROL64(A##gi, 6); \
    A##ko ^= Do; \
    Bki = ROL64(A##ko, 25); \
    A##mu ^= Du; \
    Bko = ROL64(A##mu, 8); \
    A##sa ^= Da; \
    Bku = ROL64(A##sa, 18); \
    E##ka =   Bka ^((~Bke)&  Bki ); \
    Ca ^= E##ka; \
    E##ke =   Bke ^((~Bki)&  Bko ); \
    Ce ^= E##ke; \
    E##ki =   Bki ^((~Bko)&  Bku ); \
    Ci ^= E##ki; \
    E##ko =   Bko ^((~Bku)&  Bka ); \
    Co ^= E##ko; \
    E##ku =   Bku ^((~Bka)&  Bke ); \
    Cu ^= E##ku; \
\
    A##bu ^= Du; \
    Bma = ROL64(A##bu, 27); \
    A##ga ^= Da; \
    Bme = ROL64(A##ga, 36); \
    A##ke ^= De; \
    Bmi = ROL64(A##ke, 10); \
    A##mi ^= Di; \
    Bmo = ROL64(A##mi, 15); \
    A##so ^= Do; \
    Bmu = ROL64(A##so, 56); \
    E##ma =   Bma ^((~Bme)&  Bmi ); \
    Ca ^= E##ma; \
    E##me =   Bme ^((~Bmi)&  Bmo ); \
    Ce ^= E##me; \
    E##mi =   Bmi ^((~Bmo)&  Bmu ); \
    Ci ^= E##mi; \
    E##mo =   Bmo ^((~Bmu)&  Bma ); \
    Co ^= E##mo; \
    E##mu =   Bmu ^((~Bma)&  Bme ); \
    Cu ^= E##mu; \
\
    A##bi ^= Di; \
    Bsa = ROL64(A##bi, 62); \
    A##go ^= Do; \
    Bse = ROL64(A##go, 55); \
    A##ku ^= Du; \
    Bsi = ROL64(A##ku, 39); \
    A##ma ^= Da; \
    Bso = ROL64(A##ma, 41); \
    A##se ^= De; \
    Bsu = ROL64(A##se, 2); \
    E##sa =   Bsa ^((~Bse)&  Bsi ); \
    Ca ^= E##sa; \
    E##se =   Bse ^((~Bsi)&  Bso ); \
    Ce ^= E##se; \
    E##si =   Bsi ^((~Bso)&  Bsu ); \
    Ci ^= E##si; \
    E##so =   Bso ^((~Bsu)&  Bsa ); \
    Co ^= E##so; \
    E##su =   Bsu ^((~Bsa)&  Bse ); \
    Cu ^= E##su; \


#define copyFromState(X, state) \
    X##ba = state[ 0]; \
    X##be = state[ 1]; \
    X##bi = state[ 2]; \
    X##bo = state[ 3]; \
    X##bu = state[ 4]; \
    X##ga = state[ 5]; \
    X##ge = state[ 6]; \
    X##gi = state[ 7]; \
    X##go = state[ 8]; \
    X##gu = state[ 9]; \
    X##ka = state[10]; \
    X##ke = state[11]; \
    X##ki = state[12]; \
    X##ko = state[13]; \
    X##ku = state[14]; \
    X##ma = state[15]; \
    X##me = state[16]; \
    X##mi = state[17]; \
    X##mo = state[18]; \
    X##mu = state[19]; \
    X##sa = state[20]; \
    X##se = state[21]; \
    X##si = state[22]; \
    X##so = state[23]; \
    X##su = state[24];

#define copyToState(state, X) \
    state[ 0] = X##ba; \
    state[ 1] = X##be; \
    state[ 2] = X##bi; \
    state[ 3] = X##bo; \
    state[ 4] = X##bu; \
    state[ 5] = X##ga; \
    state[ 6] = X##ge; \
    state[ 7] = X##gi; \
    state[ 8] = X##go; \
    state[ 9] = X##gu; \
    state[10] = X##ka; \
    state[11] = X##ke; \
    state[12] = X##ki; \
    state[13] = X##ko; \
    state[14] = X##ku; \
    state[15] = X##ma; \
    state[16] = X##me; \
    state[17] = X##mi; \
    state[18] = X##mo; \
    state[19] = X##mu; \
    state[20] = X##sa; \
    state[21] = X##se; \
    state[22] = X##si; \
    state[23] = X##so; \
    state[24] = X##su;

#define rounds24 \
    prepareTheta \
    for(i=0; i<24; i+=6) { \
        thetaRhoPiChiIotaPrepareTheta(i  , A, E) \
        thetaRhoPiChiIotaPrepareTheta(i+1, E, A) \
        thetaRhoPiChiIotaPrepareTheta(i+2, A, E) \
        thetaRhoPiChiIotaPrepareTheta(i+3, E, A) \
        thetaRhoPiChiIotaPrepareTheta(i+4, A, E) \
        thetaRhoPiChiIotaPrepareTheta(i+5, E, A) \
    }

/*************************************************
* Name:        load64
* Description: Loads an unaligned little-endian lane.
* Arguments:   - const uint8_t *input: eight input bytes
**************************************************/
static inline uint64_t load64(const uint8_t *input)
{
    uint64_t lane;
    memcpy(&lane, input, sizeof lane);
    return lane;
}

#define addInput17(X, input) \
    X##ba ^= load64((input) + 8 * 0); \
    X##be ^= load64((input) + 8 * 1); \
    X##bi ^= load64((input) + 8 * 2); \
    X##bo ^= load64((input) + 8 * 3); \
    X##bu ^= load64((input) + 8 * 4); \
    X##ga ^= load64((input) + 8 * 5); \
    X##ge ^= load64((input) + 8 * 6); \
    X##gi ^= load64((input) + 8 * 7); \
    X##go ^= load64((input) + 8 * 8); \
    X##gu ^= load64((input) + 8 * 9); \
    X##ka ^= load64((input) + 8 * 10); \
    X##ke ^= load64((input) + 8 * 11); \
    X##ki ^= load64((input) + 8 * 12); \
    X##ko ^= load64((input) + 8 * 13); \
    X##ku ^= load64((input) + 8 * 14); \
    X##ma ^= load64((input) + 8 * 15); \
    X##me ^= load64((input) + 8 * 16);

/*************************************************
* Name:        keccak_permute
* Description: Applies 24 rounds, six rounds per iteration.
* Arguments:   - uint64_t state[25]: Keccak state
**************************************************/
static void keccak_permute(uint64_t state[25])
{
    declareABCDE
    unsigned int i;

    copyFromState(A, state)
    rounds24
    copyToState(state, A)
}

/*************************************************
* Name:        absorb_full_blocks
* Description: Absorbs full 136-byte blocks with the XKCP fast loop.
* Arguments:   - uint64_t state[25]: Keccak state
*              - const uint8_t *input: input bytes
*              - size_t inlen: available input length
**************************************************/
static size_t absorb_full_blocks(uint64_t state[25], const uint8_t *input, size_t inlen)
{
    const size_t original = inlen;
    declareABCDE
    unsigned int i;

    copyFromState(A, state)
    while (inlen >= 136) {
        addInput17(A, input)
        rounds24
        input += 136;
        inlen -= 136;
    }
    copyToState(state, A)
    return original - inlen;
}

/*************************************************
* Name:        clear_state
* Description: Clears the 25 named state words.
* Arguments:   - uint64_t state[25]: Keccak state
**************************************************/
static void clear_state(uint64_t state[25])
{
    volatile uint64_t *words = state;

    for (unsigned int i = 0; i < 25; ++i)
        words[i] = 0;
}

/*************************************************
* Name:        shake256
* Description: SHAKE256; input/output may overlap and be unaligned.
* Arguments:   - uint8_t *out: output bytes
*              - size_t outlen: requested output length
*              - const uint8_t *in: input bytes
*              - size_t inlen: input length
**************************************************/
void shake256(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen)
{
    uint64_t state[25] = {0};

    if (inlen >= 136) {
        const size_t consumed = absorb_full_blocks(state, in, inlen);
        in += consumed;
        inlen -= consumed;
    }

    size_t offset = 0;
    for (; offset + 8 <= inlen; offset += 8)
        state[offset / 8] ^= load64(in + offset);
    if (offset < inlen) {
        uint64_t tail = 0;
        memcpy(&tail, in + offset, inlen - offset);
        state[offset / 8] ^= tail;
    }
    ((uint8_t *)state)[inlen] ^= 0x1f;
    ((uint8_t *)state)[135] ^= 0x80;
    keccak_permute(state);

    while (outlen > 136) {
        memcpy(out, state, 136);
        keccak_permute(state);
        out += 136;
        outlen -= 136;
    }
    if (outlen != 0)
        memcpy(out, state, outlen);

    clear_state(state);
}
