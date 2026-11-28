void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) int g(void); int f(int x) { if (x) return 1; (void)sizeof(g()); }
