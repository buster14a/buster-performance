#include <stdio.h>
double g_x = 1.0, g_y;
static long s_n;
__attribute__((noinline)) void f(int n) { for (int i = 0; i < n; i++) { g_x = g_x * 1.0000001 + 0.5; g_y += g_x; s_n += i & 3; } }
int main(void) { f(200000000); printf("%.6f %.6f %ld\n", g_x, g_y, s_n); return 0; }
