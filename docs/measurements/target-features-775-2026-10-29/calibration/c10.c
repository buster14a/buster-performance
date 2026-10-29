static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
static int s(int x) { return h(x); }
int e1(int x) { return s(x) + h(x + 1); }
int e2(int x) { return h(x + 2); }
