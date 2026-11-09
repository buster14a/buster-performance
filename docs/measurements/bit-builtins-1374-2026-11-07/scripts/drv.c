#include <stdio.h>
#include <stdlib.h>
#include <time.h>
unsigned long kernel(unsigned long x); unsigned long swaps(unsigned x);
static double now(void){ struct timespec t; clock_gettime(CLOCK_MONOTONIC,&t); return t.tv_sec*1e3+t.tv_nsec/1e6; }
int main(int argc, char** argv) {
  unsigned long x = 88172645463325252ul, s = 0; double best = 1e9, bestb = 1e9;
  for (int r = 0; r < 5; r++) {
    double t0 = now();
    for (int i = 0; i < 20000000; i++) { x ^= x << 13; x ^= x >> 7; x ^= x << 17; s += kernel(x); }
    double t1 = now();
    for (int i = 0; i < 20000000; i++) { x ^= x << 13; x ^= x >> 7; x ^= x << 17; s += swaps((unsigned)x); }
    double t2 = now();
    if (t1 - t0 < best) best = t1 - t0; if (t2 - t1 < bestb) bestb = t2 - t1;
  }
  printf("counts %.1f ms  swaps %.1f ms  (%lu)\n", best, bestb, s);
  return 0;
}
