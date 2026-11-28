typedef int (*F)(int);
int n(F f) { return f == (void*)1; }
