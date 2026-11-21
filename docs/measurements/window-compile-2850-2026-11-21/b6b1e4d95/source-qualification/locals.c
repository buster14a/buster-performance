static int omitted_before(int x) { int pad[3] = {x, x + 1, x + 2}; return pad[1]; }
int empty_between(void) { return 3; }
static __attribute__((target_clones("default","sse4.2"))) int copies(int n)
{
    int left = n + 5;
    int local[3] = {left, n * 3, n / 3};
    return local[(unsigned)n % 3] + left;
}
static int omitted_after(int x) { int lhs = x * 7, rhs = x / 5; return lhs + rhs; }
int run_locals(int x)
{
    int lead = x - 3;
    int result = copies(x);
    for (int i = 0; i < 2; ++i) { int extra = lead + i; result += extra; }
    return result;
}
