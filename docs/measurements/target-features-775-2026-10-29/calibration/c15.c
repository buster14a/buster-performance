static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
static int s(int x) { return h(x) + h(x + 1); }
static int t(int x) { return h(x + 2); }
int e(int x) { return s(x) + t(x); }
