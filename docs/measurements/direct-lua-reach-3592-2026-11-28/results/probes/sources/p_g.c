typedef int (*F)(int);
int g(F f, int *x) { return f == x; }
