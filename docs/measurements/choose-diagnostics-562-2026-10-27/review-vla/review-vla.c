typedef char V __attribute__((vector_size(16)));
#define BAD __builtin_ia32_cmpb128_mask(a,a,8,65535)
unsigned f(V a,int n){ (void)__builtin_choose_expr(1,0,0); return sizeof(int[n+BAD]); }
