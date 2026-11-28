enum E {A = -1, B}; void g(enum E); void t(int c) { g(c ? A : B); }
