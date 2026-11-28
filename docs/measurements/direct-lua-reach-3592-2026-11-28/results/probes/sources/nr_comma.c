void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void w(int x) { x++, abort(); }
