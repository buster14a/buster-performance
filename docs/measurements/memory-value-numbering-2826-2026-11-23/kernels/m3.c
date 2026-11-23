// The #3309 kernel: globals updated and reread in a loop.
#include <stdio.h>
#include <stdlib.h>
long g_a, g_b;
__attribute__((noinline)) void f(int n) { for (int i = 0; i < n; i++) { g_a += i; g_b ^= g_a; } }
int main(int argc, char** argv) { f(argc > 1 ? atoi(argv[1]) : 200000000); printf("%ld %ld\n", g_a, g_b); return 0; }
