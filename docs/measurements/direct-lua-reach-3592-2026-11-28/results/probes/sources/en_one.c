enum E {A,B}; void g(enum E); void t(int c) { g(c ? A : 1); }
