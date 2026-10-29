static inline __attribute__((always_inline, target("avx2"))) int h(int x) { return x + 1; }
int caller(int x) { return h(x); }
__attribute__((target("avx2"))) int ok(int x) { return h(x); }
static __attribute__((target("avx2"))) int plain(int x) { return x + 2; }
int caller2(int x) { return plain(x); }
