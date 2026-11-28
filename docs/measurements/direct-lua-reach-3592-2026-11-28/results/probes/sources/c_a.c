typedef int (*F)(int);
void *a(int c, F f, void *p) { return c ? f : p; }
