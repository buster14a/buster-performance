enum { EK = 1000 };
int k0(int, int);
int f(int a)
{
    int x = 0;
    x = k0(a, (unsigned char)1000 + 1000);
    return x;
}
