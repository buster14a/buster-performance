#include <stdio.h>
#include <stdlib.h>
long g_sum;
unsigned long g_hash;
__attribute__((noinline)) void f(const long *p, int n) { for (int i = 0; i < n; i++) { g_sum += p[i & 1023]; g_hash = g_hash * 31 + (unsigned long)p[i & 1023]; } }
int main(void) { long *p = malloc(1024 * sizeof(long)); for (int i = 0; i < 1024; i++) p[i] = i * 7 + 1; f(p, 200000000); printf("%ld %lu\n", g_sum, g_hash); return 0; }
