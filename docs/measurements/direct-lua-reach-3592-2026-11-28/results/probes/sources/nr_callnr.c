void abort(void) __attribute__((__noreturn__));
__attribute__((noreturn)) void z4(void); int z5(int x) { if (x) return 2; z4(); }
