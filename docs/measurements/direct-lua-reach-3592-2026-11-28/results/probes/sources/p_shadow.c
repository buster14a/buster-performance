void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void g(void); int f(int x, void (*g)(void)) { if (x) return 1; g(); }
