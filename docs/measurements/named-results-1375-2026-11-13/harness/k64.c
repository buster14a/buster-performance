struct Big { long a[8]; };
__attribute__((noinline)) static struct Big mk(long x) { struct Big b; for (int i = 0; i < 8; i++) b.a[i] = x + i; return b; }
long k_sret(int m) { long s = 0; for (int r = 0; r < m; r++) { struct Big b = mk(r); s += b.a[7]; } return s; }
