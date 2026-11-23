// An element read twice in one expression and an array element stored then read (#2743-style indexed loop).
#include <stdio.h>
#include <stdlib.h>
__attribute__((noinline)) long f(long* a, int n) { long s = 0; for (int i = 1; i < n; i++) { a[i & 4095] = a[(i - 1) & 4095] + i; s += a[i & 4095] * a[i & 4095]; } return s; }
int main(int argc, char** argv) { static long a[4096]; printf("%ld\n", f(a, argc > 1 ? atoi(argv[1]) : 100000000)); return 0; }
