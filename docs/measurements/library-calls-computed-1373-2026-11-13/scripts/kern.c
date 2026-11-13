// #1373's kernels: the library spellings, which real code writes, of small fixed-size copies, absolute values and signs.
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
// The issue's kernel: a 24- and a 7-byte copy.
void copies(char *d, const char *s) { memcpy(d, s, 24); memcpy(d + 32, s + 8, 7); }
// An unaligned load written as memcpy into an integer, the type-punning idiom.
uint32_t load32(const void *p) { uint32_t v; memcpy(&v, p, 4); return v; }
// A 12-byte move within one buffer and a 16-byte clear.
void moves(char *d) { memmove(d, d + 16, 12); memset(d + 32, 0, 16); }
// The first comment's kernels.
long absolutes(int x, long y) { return abs(x) + labs(y); }
double signs(double x) { return fabs(x) + copysign(1.0, x); }
// The second comment's loops over 4,096 elements.
long sum_abs(const int *p, int n) { long s = 0; for (int i = 0; i < n; i++) s += abs(p[i]); return s; }
long sum_labs(const long *p, int n) { long s = 0; for (int i = 0; i < n; i++) s += labs(p[i]); return s; }
double sum_fabs(const double *p, int n) { double s = 0; for (int i = 0; i < n; i++) s += fabs(p[i]); return s; }
