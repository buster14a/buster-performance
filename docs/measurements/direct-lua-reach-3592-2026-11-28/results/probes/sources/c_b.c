typedef int (*F)(int);
F b(int c, F f) { return c ? f : ((void*)0); }
