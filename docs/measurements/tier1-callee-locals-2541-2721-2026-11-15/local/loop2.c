int printf(const char *, ...);
volatile int sink;
__attribute__((noinline)) void mark(int v)
{
    sink = v;
}
__attribute__((noinline)) static int sum_to(int n)
{
    int total = 0;
    for (int i = 0; i < n; i += 1)
    {
        total += i;
        mark(total);
    }
    return total;
}
int main(void)
{
    int all = sum_to(3) + sum_to(2);
    printf("L %d\n", all);
    return all != 4;
}
