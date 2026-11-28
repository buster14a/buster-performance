struct S { int a; }; int t(void) { return (__extension__ (struct S){ 1 }).a; }
