typedef char C64 __attribute__((vector_size(64)));
unsigned long long f(C64 a) { return __builtin_ia32_ucmpb512_mask(a,a,8,~0ull); }
