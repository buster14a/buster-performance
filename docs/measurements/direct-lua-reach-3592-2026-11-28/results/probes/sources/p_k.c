typedef int (*F)(int);
int k(F f) { return f == (void*)(1-1); }
