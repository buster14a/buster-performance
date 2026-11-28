typedef int (*F)(int);
int g(void *p, F f) { return p == f; }
