enum E {A,B}; enum F {X,Y}; void g(enum E); void t(int c) { g(c ? X : Y); }
