void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void z(void) { int a = (abort(), 1); }
