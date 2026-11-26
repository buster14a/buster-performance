int g(void) __asm__("h.x");
int g(void) { static int x; return x; }
