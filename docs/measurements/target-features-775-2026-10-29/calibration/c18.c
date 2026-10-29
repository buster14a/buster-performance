static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
static inline __attribute__((always_inline, target("bmi2"))) int g(int x) { return x + 2; }
int e(int n) { return n ? g(n) : h(n); }
int f(int n) { int a[2]; a[h(n)] = g(n); return a[0]; }
