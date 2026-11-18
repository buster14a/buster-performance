#include <setjmp.h>
#include <stdio.h>
int scale(int x) { return x * 3 + 1; }
__attribute__((weak)) int hook(int x) { return x + 11; }
static long crunch(const int* p, int n)
{
    long s = 0;
    for (int i = 0; i < n; i += 1)
    {
        int v = p[i];
        if (v & 1) s += v * 3; else s -= v / 2;
        switch (v & 3) { case 0: s ^= 5; break; case 1: s += 7; break; case 2: s *= 3; break; default: s -= 1; }
        s += scale(v) + (v << 2) - (v >> 1) + (s >> 3) * (v | 1) - (s % 7) + ((v & 8) != 0 ? s / 3 : s * 2);
        s ^= (s << 7) + (long)(v * 1103515245u) + (s >> 11) - (long)(i * 12345);
    }
    return s;
}
static long quotient(__int128 a, long b) { return (long)(a / b); }
static int lead(int x) { return x ^ 0x55; }
static int hop(int x) { return lead(x) + lead(x + 1); }
static int add1(int x) { return x + 1; }
static int sub1(int x) { return x - 1; }
static int (*const table[])(int) = { sub1 };
static __attribute__((used)) int pinned(int x) { return x * 5; }
static int saved(int x) { return x * 9 - 4; }
static jmp_buf place;
__attribute__((noinline)) int jumpy(int x) { if (setjmp(place) != 0) return -1; return saved(x); }
__attribute__((noinline)) long run(int n, int (*f)(int))
{
    int d[7] = { 3, 8, 1, 6, 4, 11, 2 };
    long r = crunch(d, 7);
    for (int i = 0; i < n; i += 1) r += scale(i) + hook(i) + hop(i) + add1(i) + sub1(i) + pinned(i) + f(i) + table[0](i);
    return r + jumpy(n);
}
__attribute__((noinline)) long wide(int n) { return quotient((__int128)n << 70, 12345) + quotient(-(__int128)n << 66, 777); }
int main(void) { printf("%ld %d\n", run(9, add1) + wide(5), scale(4)); return 0; }
