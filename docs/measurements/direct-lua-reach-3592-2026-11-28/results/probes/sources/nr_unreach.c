void abort(void) __attribute__((__noreturn__));
int h(int x) { if (x) return 1; __builtin_unreachable(); }
