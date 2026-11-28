typedef int (*F)(int);
int c(F f, void *p) { return f < p; }
