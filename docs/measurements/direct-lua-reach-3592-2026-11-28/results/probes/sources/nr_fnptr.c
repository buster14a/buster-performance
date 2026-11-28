void abort(void) __attribute__((__noreturn__));
void (*fp)(void) __attribute__((noreturn)); int z6(int x) { if (x) return 2; fp(); }
