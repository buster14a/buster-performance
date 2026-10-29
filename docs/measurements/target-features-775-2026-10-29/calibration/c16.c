static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
static inline __attribute__((always_inline, target("bmi2"))) int g(int x) { return x + 2; }
int e(int n) { int s = 0; for (int i = 0; i < n; i = h(i)) { s += g(i); } return s; }
