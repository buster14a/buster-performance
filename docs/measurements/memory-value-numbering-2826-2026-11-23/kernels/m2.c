// A store then a reload of the same field in one iteration (store-to-load forwarding in the IR).
#include <stdio.h>
#include <stdlib.h>
typedef struct { long sum; long count; long last; } Acc;
__attribute__((noinline)) void f(Acc* acc, const long* x, int n) { for (int i = 0; i < n; i++) { acc->sum += x[i & 1023]; acc->count = acc->count + 1; acc->last = acc->sum ^ acc->count; } }
int main(int argc, char** argv) { static long x[1024]; for (int i = 0; i < 1024; i++) x[i] = i * 3 + 1; Acc a = { 0, 0, 0 }; f(&a, x, argc > 1 ? atoi(argv[1]) : 200000000); printf("%ld %ld %ld\n", a.sum, a.count, a.last); return 0; }
