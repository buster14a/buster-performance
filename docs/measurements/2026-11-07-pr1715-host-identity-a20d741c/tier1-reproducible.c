#include <stdio.h>
__attribute__((noinline)) unsigned long m3(unsigned long x) { return x * 3; }
__attribute__((noinline)) unsigned long m5(unsigned long x) { return x * 5; }
__attribute__((noinline)) unsigned long m9(unsigned long x) { return x * 9; }
__attribute__((noinline)) unsigned long m4(unsigned long x) { return x * 4; }
__attribute__((noinline)) unsigned m3i(unsigned x) { return x * 3; }
__attribute__((noinline)) unsigned long address_sum(unsigned long x, unsigned long y) { return x + y * 4 + 8; }
__attribute__((noinline)) unsigned long chain(unsigned long x) { return (x * 3) * 3; }
__attribute__((noinline)) unsigned long load_add(unsigned long x, const unsigned long* p) { return x + *p; }
__attribute__((noinline)) unsigned long two_loads(const unsigned long* p) { return p[0] + p[1]; }
volatile unsigned long allocation_inputs[] = {0x123456789abcdeful, ~0ul, 0x8000000000000000ul, 5};
__attribute__((noinline)) unsigned long unrestricted(void)
{ unsigned long a = allocation_inputs[0], b = allocation_inputs[1], c = allocation_inputs[2], d = allocation_inputs[3]; return (a + b) + (c + d); }
__attribute__((noinline)) unsigned long loop(const unsigned long* p, unsigned n)
{ unsigned long s = 1; for (unsigned i = 0; i < n; i += 1) s = (s * 3) * 3 + p[i]; return s; }
int main(void)
{
    unsigned long p[] = {0, 1, ~0ul, 0x8000000000000000ul, 0x123456789abcdeful};
    unsigned long s = loop(p, 0) ^ loop(p, 5) ^ two_loads(p + 2) ^ unrestricted();
    for (unsigned i = 0; i < 5; i += 1)
    {
        unsigned long x = p[i];
        s += m3(x) ^ m5(x) ^ m9(x) ^ m4(x) ^ m3i((unsigned)x);
        s ^= address_sum(x, p[4 - i]) + chain(x) + load_add(x, p + i);
    }
    printf("%lx\n", s);
    return 0;
}
