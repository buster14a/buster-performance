__attribute__((noreturn)) int g(void);
int f(int x) { if (x) return 1; (void)(x > 1 && g()); }
