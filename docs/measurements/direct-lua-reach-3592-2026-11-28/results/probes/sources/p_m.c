typedef int (*F)(int);
int m(F f) { return f == (void*)0L; }
