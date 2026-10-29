static inline __attribute__((always_inline, target("arch=haswell"))) int h(int x) { return x + 1; }
int caller(int x) { return h(x); }
