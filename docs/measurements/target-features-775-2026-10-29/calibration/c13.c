__attribute__((target("avx2"))) static inline __attribute__((always_inline)) int h(int x);
int caller(int x) { return h(x); }
static inline int h(int x) { return x + 1; }
