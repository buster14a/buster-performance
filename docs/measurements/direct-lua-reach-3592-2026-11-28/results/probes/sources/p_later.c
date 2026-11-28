void abort(void) __attribute__((__noreturn__));
void g(void); int f(int x) { if (x) return 1; g(); } __attribute__((noreturn)) void g(void);
