int f1(int a) { return _Generic(a, int: a + 1, default: 2); }
