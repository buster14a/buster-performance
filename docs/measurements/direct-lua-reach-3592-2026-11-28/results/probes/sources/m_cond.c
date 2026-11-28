__attribute__((noreturn)) void g(void);
int f(int x) { if (x) return 1; x > 1 ? g() : (void)0; }
