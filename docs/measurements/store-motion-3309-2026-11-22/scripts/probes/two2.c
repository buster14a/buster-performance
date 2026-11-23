#include <stdio.h>
extern long real_object, other_name;
__attribute__((noinline)) void f(int n) { for (int i = 0; i < n; i++) { real_object += i; other_name += 1; } }
int main(void) { f(10); printf("%ld\n", real_object); return 0; }
