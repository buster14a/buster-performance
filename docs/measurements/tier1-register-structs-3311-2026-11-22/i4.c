#include <stdio.h>
typedef struct { int x, y, z, w; } V4;
volatile int vz;
__attribute__((noinline)) static V4 addv(V4 a, V4 b) { return (V4){ a.x + b.x, a.y + b.y, a.z ^ b.z, a.w - b.w }; }
int main(void) { V4 acc = { 0 }, d = { 1, 2, 3, 4 + vz }; for (int i = 0; i < 100000000; i++) acc = addv(acc, d); printf("%ld\n", (long)(acc.x + acc.y + acc.z + acc.w)); return 0; }
