int f38(void) { register int r = 1; int x; x = r + 1; return x; }
int f38b(register int p) { return p + 1; }
struct R { int m; };
int f38d(void) { register struct R s; s.m = 1; return s.m; }
int f38e(void) { register int r = 2; return (r) + 1; }
