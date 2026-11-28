void abort(void) __attribute__((__noreturn__));
typedef void T(void) __attribute__((noreturn)); T g; int f(int x) { if (x) return 1; g(); }
