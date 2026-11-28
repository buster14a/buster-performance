void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void f(void) { if (0) return; abort(); }
