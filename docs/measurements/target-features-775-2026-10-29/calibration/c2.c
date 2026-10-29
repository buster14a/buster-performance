static inline __attribute__((always_inline)) int h(int x) { return x + 1; }
__attribute__((target("avx2"))) int caller(int x) { return h(x); }
