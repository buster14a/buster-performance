int h(int x);
int caller(int x) { return h(x); }
__attribute__((always_inline, target("avx2"))) inline int h(int x) { return x + 1; }
