int k0(int, int);
int f(int a, int b)
{
    int x = 0;
    x = (*k0)(a, b);
    x = (**k0)(a, b);
    x = (&k0)(a, b);
    x = (*&k0)(a, b);
    return x;
}
