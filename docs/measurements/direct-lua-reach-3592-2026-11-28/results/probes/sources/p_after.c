void abort(void) __attribute__((__noreturn__));
void g(void) __attribute__((noreturn)); int f(int x) { if (x) return 1; g(); }
