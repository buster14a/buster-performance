typedef int (*F)(int);
int h(F f) { return f == (char*)0; }
