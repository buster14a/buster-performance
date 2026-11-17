// #2791's kernels: selects of floating comparisons, each called from bench.c's loop in another object.
int k_null(double a, double b, int x, int y) { (void)a; (void)b; return x ^ y; }
int k_lt(double a, double b, int x, int y) { return a < b ? x : y; }
int k_ge(float a, float b, int x, int y) { return a >= b ? x : y; }
long k_nle(double a, double b, long x, long y) { return !(a <= b) ? x : y; }
int k_eq(double a, double b, int x, int y) { return a == b ? x : y; }
int k_ne(float a, float b, int x, int y) { return a != b ? x : y; }
long k_count(const double* p, int n, double t) { long c = 0; for (int i = 0; i < n; i++) { if (p[i] > t) c += 3; else c -= 1; } return c; }
long k_equal(const double* p, int n, double t) { long c = 0; for (int i = 0; i < n; i++) { if (p[i] == t) c += 5; else c += 1; } return c; }
