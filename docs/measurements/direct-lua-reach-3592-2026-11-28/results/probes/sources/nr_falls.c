void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void p(int x) { if (x) abort(); }
