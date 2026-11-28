typedef int (*F)(int);
int d(F f, void *p) { return f >= p; }
