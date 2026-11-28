typedef int (*F)(int);
int o(F f) { return f ? 1 : 0; }
