#ifndef SYMMETRIC_H
#define SYMMETRIC_H

#include "params.h"

void hash_h(unsigned char *buf, const unsigned char *msg);
void hash_g(unsigned char *buf, const unsigned char *msg);

#endif /* SYMMETRIC_H */
