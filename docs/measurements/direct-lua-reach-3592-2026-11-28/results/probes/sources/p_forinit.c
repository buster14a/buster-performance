void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void g(void); int f(int x) { if (x) return 1; for (g(); x; ) ; }
