typedef int (*F)(int);
int a(F f, void *p) { return f == p; }
