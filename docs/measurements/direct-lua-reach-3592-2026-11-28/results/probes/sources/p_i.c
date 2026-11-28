typedef int (*F)(int);
int i(F f, void *p) { return p ? f == p : 0; }
