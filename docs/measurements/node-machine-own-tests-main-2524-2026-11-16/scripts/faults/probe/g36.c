struct S { int a; int b; };
int f36(void) { int x; x = ((struct S){ 1, 2 }).a; return x; }
int f36b(void) { int *p; p = (int[]){ 1, 2 }; return p[0]; }
int f36c(void) { struct S s; s = (struct S){ 1, 2 }; return s.a; }
int f36d(int i) { return ((int[]){ 1, 2 })[i]; }
