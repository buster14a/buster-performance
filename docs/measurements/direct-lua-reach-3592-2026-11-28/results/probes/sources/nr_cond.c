void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void q(int x) { x ? abort() : abort(); }
