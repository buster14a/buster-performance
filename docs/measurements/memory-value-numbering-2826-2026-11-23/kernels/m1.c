// Repeated loads of a struct's fields through a pointer in a loop body (each read twice), no store between.
#include <stdio.h>
#include <stdlib.h>
typedef struct { long a, b, c, d; } Q;
__attribute__((noinline)) long f(const Q* q, const long* x, int n) { long s = 0; for (int i = 0; i < n; i++) { s += x[i & 1023] * q->a + q->b; s ^= q->a + q->c * q->b; s += q->d - q->c; } return s; }
int main(int argc, char** argv) { static long x[1024]; for (int i = 0; i < 1024; i++) x[i] = i * 7; Q q = { 3, 5, 7, 11 }; printf("%ld\n", f(&q, x, argc > 1 ? atoi(argv[1]) : 200000000)); return 0; }
