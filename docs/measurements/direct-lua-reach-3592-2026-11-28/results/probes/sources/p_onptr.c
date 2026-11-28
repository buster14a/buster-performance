void abort(void) __attribute__((__noreturn__));
void * __attribute__((noreturn)) g(void); int f(int x) { if (x) return 1; g(); }
