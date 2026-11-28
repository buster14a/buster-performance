int count;
int h(void) { count++; return 3; }
int t_bcp(void) { return __builtin_constant_p(h()) + __builtin_constant_p(5) * 100; }
int t_inc(int *p) { int r = __builtin_constant_p(*p++); return r + (p == 0 ? 1000 : 0); }
