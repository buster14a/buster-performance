void abort(void) __attribute__((__noreturn__));
int n(int x) { if (x) return 1; abort(); }
