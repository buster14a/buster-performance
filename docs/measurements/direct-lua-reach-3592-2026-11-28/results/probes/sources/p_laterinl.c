void abort(void) __attribute__((__noreturn__));
void g(void); static inline int f(int x) { if (x) return 1; g(); } __attribute__((noreturn)) void g(void); int use(int x) { return f(x); }
