void abort(void) __attribute__((__noreturn__));
int z7(int x) { switch (x) { case 1: return 1; default: abort(); } }
