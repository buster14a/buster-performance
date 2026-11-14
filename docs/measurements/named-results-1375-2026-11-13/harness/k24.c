struct R { long a, b, c; };
struct R k_sret(long x) { struct R r = { x, x + 1, x * 2 }; return r; }
