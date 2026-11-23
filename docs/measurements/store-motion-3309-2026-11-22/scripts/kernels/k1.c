#include <stdio.h>
long g_a, g_b;
__attribute__((noinline)) void f(int n) { for (int i = 0; i < n; i++) { g_a += i; g_b ^= g_a; } }
int main(void) { f(200000000); printf("%ld %ld\n", g_a, g_b); return 0; }
