#include <stdio.h>
long big[4];
__attribute__((noinline)) void f(int n) { for (int i = 0; i < n; i++) { big[1L << 36] += i; } }
int main(void) { f(0); printf("%ld\n", big[0]); return 0; }
