int g(void);
int f(void) { return sizeof(int) > 8 ? g() : 1; }
