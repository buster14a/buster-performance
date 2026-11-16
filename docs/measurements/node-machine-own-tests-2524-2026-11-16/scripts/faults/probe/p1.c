int f1(int a) { return __builtin_popcount(a) + _Generic(a, int: 1, default: 2); }
int f1b(int a) { int b = ({ a + 1; }); return b; }
