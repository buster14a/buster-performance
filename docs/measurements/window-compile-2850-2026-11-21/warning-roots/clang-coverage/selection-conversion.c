int choose(void) { int i = __builtin_choose_expr(1, 1 ? 4.25 : 7.5, 0); return i; }
int generic(int x) { int i = _Generic(x, int: 11.125, default: 0); return i; }
