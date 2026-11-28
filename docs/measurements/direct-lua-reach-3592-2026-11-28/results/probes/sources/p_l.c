typedef int (*F)(int);
int l(F f) { return f == (const void*)0; }
