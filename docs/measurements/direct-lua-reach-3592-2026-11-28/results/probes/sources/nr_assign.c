void abort(void) __attribute__((__noreturn__));
int y(void) { int a = 0; a = (abort(), 1); }
