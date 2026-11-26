int f(void) { static int n = 5; return n++; }
int fm __asm__("f.m") = 9;
