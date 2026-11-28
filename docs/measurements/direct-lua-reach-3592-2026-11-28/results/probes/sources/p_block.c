void abort(void) __attribute__((__noreturn__));
int f(int x) { void g(void) __attribute__((noreturn)); if (x) return 1; g(); }
