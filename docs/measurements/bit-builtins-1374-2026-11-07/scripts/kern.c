unsigned long kernel(unsigned long x) { return __builtin_popcountl(x) + __builtin_ctzl(x | 1) + __builtin_clzl(x | 1); }
unsigned long swaps(unsigned x) { return __builtin_bswap32(x) ^ (unsigned)__builtin_bswap64((unsigned long)x << 7); }
