int gi;
int *gp;
extern int f(int);
int plain(void) { return 42; }
int id(int n) { return n; }
int plus(int n) { return n + 1; }
int cast(int n) { return (int)n; }
int *ptr(int *p) { return p; }
int *gptr(void) { return &gi; }
int discarded(int n) { n; (void)n; n = 3; n++; f(n); n + 2; return n; }
int narrow(void) { return (char)1024; }
int divbad(int n) { return n / 0; }
int shbad(int n) { return n << -1; }
extern int unused(int) __attribute__((warn_unused_result));
int call(int n) { unused(n); f(n); return n; }
int packed(int n) { return ({ int x = n; x; }); }
int signedness(unsigned n) { return n < -1; }
