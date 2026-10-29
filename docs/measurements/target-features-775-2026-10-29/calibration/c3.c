static inline __attribute__((always_inline)) int h(int x) { return x + 1; }
__attribute__((target("no-sse4.2"))) int caller(int x) { return h(x); }
