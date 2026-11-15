#line 1 "dbg_tier1_inline.c"
int printf(const char *, ...);
volatile int t1i_sink;
__attribute__((noinline)) void t1i_mark(int y)
{
    t1i_sink = y;
}
static int t1i_square(int x)
{
    int y = x * x;
    t1i_mark(y);
    return y + 1;
}
static int t1i_twice(int x)
{
    return t1i_square(x) + t1i_square(x + 1);
}
int main(void)
{
    int total = 0;
    for (int i = 0; i < 3; i += 1)
    {
        total += t1i_twice(i);
    }
    printf("T1I %d\n", total);
    return total != 25;
}
