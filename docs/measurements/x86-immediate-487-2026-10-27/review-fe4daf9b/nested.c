typedef char V __attribute__((vector_size(16)));
unsigned f(V a) { return (unsigned){ (unsigned){ __builtin_ia32_cmpb128_mask(a,a,8,65535) } }; }
