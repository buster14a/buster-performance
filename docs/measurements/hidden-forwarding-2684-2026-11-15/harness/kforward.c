// #2684: `return mk(x);` through the hidden pointer, N longs, which main's lowering returned into an object of the
// wrapper's own and copied (memmove past 256 bytes), and head's passes the pointer on.
struct Big { long a[N]; };
__attribute__((noinline)) static struct Big mk(long x) { struct Big b; for (int i = 0; i < N; i++) b.a[i] = x + i; return b; }
__attribute__((noinline)) static struct Big fwd(long x) { return mk(x); }
long kernel(int m) { long s = 0; for (int r = 0; r < m; r++) { struct Big b = fwd(r); s += b.a[N - 1]; } return s; }
