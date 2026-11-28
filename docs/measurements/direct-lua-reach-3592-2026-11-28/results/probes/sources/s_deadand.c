int g(void);
int f(int n) { return (sizeof(n) >= 8 && n + 1 > 5) ? g() : 1; }
