enum A17 { a17 }; enum B17 { b17 };
int f17(enum A17 x, enum B17 y) { return x == y; }
int f17b(enum A17 x, enum B17 y) { return x | y; }
int f17c(enum A17 x) { return x == b17; }
