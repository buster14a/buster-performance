struct S { int f; }; extern int g(int); int trouble(void) { struct S *p; return g(p->f); }
