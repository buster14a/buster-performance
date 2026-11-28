typedef int (*F)(int);
int b(F f) { return f != ((void*)0); }
