void abort(void) __attribute__((__noreturn__));
_Noreturn void g(void); int f(int x) { if (x) return 1; g(); }
