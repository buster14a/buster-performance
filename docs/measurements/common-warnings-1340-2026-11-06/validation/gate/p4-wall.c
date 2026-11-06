#pragma clang diagnostic warning "-Wall"
int printf(const char *, ...);
int f(int p, unsigned u)
{
    int x;
    int y = 2;
    y = y;
    if (p < u)
        return x;
    return y;
}
void g(int q)
{
    q = 1;
}
int h(int a, unsigned b) { return a == b; }
