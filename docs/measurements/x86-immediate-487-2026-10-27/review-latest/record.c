typedef char V __attribute__((vector_size(16)));
struct S { unsigned x; };
unsigned f(V a) { return ((struct S){ .x = __builtin_ia32_cmpb128_mask(a,a,8,65535) }).x; }
