void abort(void) __attribute__((__noreturn__));
static void g(void) __attribute__((noreturn)); static void g(void) { abort(); } int f(int x) { if (x) return 1; g(); }
