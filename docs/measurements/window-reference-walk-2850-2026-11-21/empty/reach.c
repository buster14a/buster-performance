static volatile int table[] = {2, -4, 7, 12};
static int factor = 7;
static int spare(void) { return 17; }
extern int extra(int);
int via_table(int x)
{
    int a = x < 4 ? x : x - 2;
    return table[(unsigned)(a + factor) % 4] + extra(x);
}
int with_region(int x)
{
    return x && ({ int k = table[((unsigned)x - 1) % 4]; k > 0; });
}
int as_size(int x)
{
    return (int)sizeof(spare()) + (x == 13 ? table[0] : 0);
}
