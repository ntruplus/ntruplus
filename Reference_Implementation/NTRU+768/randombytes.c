#if defined(__linux__) && !defined(_GNU_SOURCE)
#define _GNU_SOURCE
#endif

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include "randombytes.h"

#ifdef _WIN32
#include <windows.h>
#include <wincrypt.h>
#else
#include <fcntl.h>
#include <errno.h>
#ifdef __linux__
#include <unistd.h>
#include <sys/syscall.h>
#else
#include <unistd.h>
#endif
#endif

#ifdef _WIN32
void randombytes(uint8_t *out, size_t outlen) {
  HCRYPTPROV ctx;
  size_t len;

  if(!CryptAcquireContext(&ctx, NULL, NULL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT))
    abort();

  while(outlen > 0) {
    len = (outlen > 1048576) ? 1048576 : outlen;
    if(!CryptGenRandom(ctx, len, (BYTE *)out))
      abort();

    out += len;
    outlen -= len;
  }

  if(!CryptReleaseContext(ctx, 0))
    abort();
}
#elif defined(__APPLE__)
void randombytes(uint8_t *out, size_t outlen) {
  arc4random_buf(out, outlen);
}
#elif defined(__linux__) && defined(SYS_getrandom)
void randombytes(uint8_t *out, size_t outlen) {
  ssize_t ret;

  while(outlen > 0) {
    ret = syscall(SYS_getrandom, out, outlen, 0);
    if(ret == -1 && errno == EINTR)
      continue;
    else if(ret == -1)
      abort();

    out += ret;
    outlen -= ret;
  }
}
#else
void randombytes(uint8_t *out, size_t outlen) {
  int fd;
  ssize_t ret;

  do {
#ifdef O_CLOEXEC
    fd = open("/dev/urandom", O_RDONLY | O_CLOEXEC);
#else
    fd = open("/dev/urandom", O_RDONLY);
#endif
    if(fd == -1 && errno == EINTR)
      continue;
    else if(fd == -1)
      abort();
  } while(fd == -1);

  while(outlen > 0) {
    ret = read(fd, out, outlen);
    if(ret == -1 && errno == EINTR)
      continue;
    else if(ret == -1)
      abort();

    out += ret;
    outlen -= ret;
  }

  if(close(fd) == -1)
    abort();
}
#endif
