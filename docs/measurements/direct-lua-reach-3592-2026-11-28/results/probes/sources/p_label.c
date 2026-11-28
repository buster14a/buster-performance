void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void g(void); int f(int x) { if (x) goto L; g(); L: ; }
