// #2922's kernels: selects of floating == and !=, each called from bench.c's loop in another object. The loops whose
// selects recur (best, equal) come first, so that their code and its placement are the same in every Tier 1 build whose
// rule for them is the same; sum, whose select doesn't recur, follows.
int k_null(double a, double b, int x, int y) { (void)a; (void)b; return x ^ y; }
int k_best(const double* p, int n, double t) { int b = -1; for (int i = 0; i < n; i++) { b = p[i] == t ? i : b; } return b; }
long k_equal(const double* p, int n, double t) { long c = 0; for (int i = 0; i < n; i++) { if (p[i] == t) c += 5; else c += 1; } return c; }
long k_sum(const double* p, int n, double t, long x, long y) { long s = 0; for (int i = 0; i < n; i++) { s += p[i] == t ? x : y; } return s; }
int k_lt(double a, double b, int x, int y) { return a < b ? x : y; }
int k_eq(double a, double b, int x, int y) { return a == b ? x : y; }
int k_ne(float a, float b, int x, int y) { return a != b ? x : y; }
