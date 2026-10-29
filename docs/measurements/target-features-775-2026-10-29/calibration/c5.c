__attribute__((target("avx2"))) int h(int x) { return x + 1; }
__attribute__((flatten)) int caller(int x) { return h(x); }
