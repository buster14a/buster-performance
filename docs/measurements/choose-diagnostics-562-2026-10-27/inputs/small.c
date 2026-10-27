typedef char V __attribute__((vector_size(16)));
#pragma clang diagnostic ignored "-Wargument-outside-range"
unsigned f0(V a){return __builtin_choose_expr(0,__builtin_ia32_cmpb128_mask(a,a,8,65535),0);}
