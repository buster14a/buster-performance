int k0(int, int);
static int s0(int a, int b) { return a + b; }
static inline __attribute__((always_inline)) int s1(int a) { return a + 1; }
int f(int a, int b)
{
    int x = 0;
    k0(a, b);
    x = k0(a, 1);
    x += s0(a, b);
    x += s1(a);
    (void)k0(a, b);
    return x;
}
static __attribute__((noinline, no_builtin("memset"))) int nb(int a) { return a; }
