#include <stdio.h>
long x;
extern long y __asm__("x");
__attribute__((noinline)) void f(int n) { for (int i = 0; i < n; i++) { x += i; y += 1; } }
int main(void) { f(10); printf("%ld\n", x); return 0; }
