#include <stdio.h>
__attribute__((noinline)) static unsigned __int128 f(unsigned __int128 a, unsigned long b) { return a * b + (a >> 3); }
int main(void) { unsigned __int128 t = 1; for (int i = 0; i < 40000000; i++) t = f(t, (unsigned long)i | 1); printf("%llu\n", (unsigned long long)t); return 0; }
