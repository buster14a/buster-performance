enum { EK = 1000 };
int k0(int, int);
int f(int a)
{
    int x = 0;
    x = k0(a, 1000.0 > 1 ? 1000 : 1);
    return x;
}
