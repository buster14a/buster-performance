// A struct of N longs built by 8-byte stores, then assigned through a pointer: the copy reads the stores just made.
struct Big { long a[N]; };
void k_assign(struct Big *out, long x) { struct Big b; for (int i = 0; i < N; i++) b.a[i] = x + i; *out = b; }
