static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
static inline __attribute__((always_inline, target("bmi2"))) int g(int x) { return x + 2; }
int e(int n)
{
    int s = 0;
    for (int i = h(n); i < g(n); i = h(i)) { s += g(i); }
    while (h(s) < n) { s += g(s); }
    do { s += g(s); } while (h(s) < n);
    return ({ int t = g(s); t; }) + h(s);
}
