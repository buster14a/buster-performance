int f(x) _Atomic(int) x; { return x + 1; }
int tested(int x) { return f(x); }
