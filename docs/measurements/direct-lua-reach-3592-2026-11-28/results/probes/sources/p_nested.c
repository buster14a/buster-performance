void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void g(int); int k(int); int f(int x) { if (x) return 1; g(k(x)); }
