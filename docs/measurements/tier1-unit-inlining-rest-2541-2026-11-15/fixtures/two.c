int printf(const char *, ...);
volatile int sink;
__attribute__((noinline)) void mark(int y)
{
    sink = y;
}
static int pair(int a, long b, int c)
{
    int s = a * 100 + (int)b * 10 + c;
    mark(s);
    return s + a + c;
}
int main(void)
{
    int total = 0;
    for (int i = 0; i < 3; i += 1)
    {
        total += pair(i, (long)i + 5, i * 2);
    }
    printf("TWO %d\n", total);
    return 0;
}
