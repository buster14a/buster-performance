// #2684: a named result's call initializer (#1375 builds `b` where the hidden pointer points), N longs: main's call
// returned into an object of its own, copied into `b`; head's passes the pointer on.
struct Big { long a[N]; };
__attribute__((noinline)) static struct Big mk(long x) { struct Big b; for (int i = 0; i < N; i++) b.a[i] = x + i; return b; }
__attribute__((noinline)) static struct Big named(long x) { struct Big b = mk(x); b.a[0] += 1; return b; }
long kernel(int m) { long s = 0; for (int r = 0; r < m; r++) { struct Big b = named(r); s += b.a[0] + b.a[N - 1]; } return s; }
