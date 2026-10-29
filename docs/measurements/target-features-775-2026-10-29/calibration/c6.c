static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
int caller(int x) { return (*h)(x) + (&h)(x); }
