typedef int (*F)(void); int g(void); F t(void *p) { F f = (__extension__ (F)(p)); return f ? f : g; }
