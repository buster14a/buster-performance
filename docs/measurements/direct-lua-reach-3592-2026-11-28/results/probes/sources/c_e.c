typedef int (*F)(int);
int e(F f, const volatile void *p) { return f != p; }
