static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
static inline __attribute__((always_inline, target("bmi2"))) int g(int x) { return x + 2; }
int e(int n) { int s = 0; do { s += g(n); } while (h(s) < n); return s; }
