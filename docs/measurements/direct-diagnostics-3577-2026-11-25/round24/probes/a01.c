extern int fn __asm__("f.n");
int f(void) { static int n = 5; return n++ + fn; }
