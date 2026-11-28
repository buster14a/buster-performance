void abort(void) __attribute__((__noreturn__));
int t_sel(int x) { if (x) return x + 1; abort(); }
int t_cmp(int (*f)(int)) { return f != ((void*)0); }
int t_eq(void *p, int (*f)(int)) { return p == f; }
long t_ext(int x) { return (__extension__ (long)(x)) + 1; }
