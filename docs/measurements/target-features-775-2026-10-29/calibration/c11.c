static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
static inline __attribute__((always_inline, target("bmi2,avx2"))) int g(int x) { return x + 2; }
int e1(int x) { return h(g(x)) + h(x); }
