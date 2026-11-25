enum { Bias = 17, Big = 0x100000005L };
static inline long leaf(int x) { int local = x + Bias; return local + Big; }
static inline long next(int x) { return leaf(x) + 3; }
long (*fp)(int) = next;
int main(void) { int n = 9; return !(fp(n) == 4294967330L && next(n + 1) == 4294967331L); }
