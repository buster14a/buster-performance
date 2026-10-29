static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
int caller(int x) { if (0) return h(x); return (0 && h(x)) + (1 ? x : h(x)); }
int after(int x) { return x; return h(x); }
