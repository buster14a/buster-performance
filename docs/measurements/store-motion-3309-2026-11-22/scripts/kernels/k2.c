#include <stdio.h>
long g_a, g_b;
long g_arr[16];
__attribute__((noinline)) void f(int n) { for (int i = 0; i < n; i++) { g_a += i; g_b ^= g_a; g_arr[i & 15] += 1; } }
int main(void) { f(200000000); printf("%ld %ld %ld\n", g_a, g_b, g_arr[5]); return 0; }
