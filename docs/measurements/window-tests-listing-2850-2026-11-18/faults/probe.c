int f1(int a, int b)
{
    (void)(a = b);
    return a;
}
int f2(int a, int b)
{
    (int)(a = b);
    return a;
}
int f3(int a, int b)
{
    for (a = 0; a < b; (void)(a = b))
    {
    }
    return a;
}
int f4(int a, int b)
{
    int v[(int)(a = b)];
    v[0] = 0;
    return v[0] + a;
}
int f5(int a, int b, void* p)
{
    void* q = &&l;
    goto *(void*)(p = q);
l:
    return a + b;
}
int f7(int a, int b)
{
    int x = ({ (int)(a = b); });
    return a + x;
}
int f8(int a, int b)
{
    ({ (void)(a = b); });
    return a;
}
int f9(int a, int b)
{
    switch (a)
    {
        case (int)1: (void)(b = a);
    }
    return b;
}
int f10(int a, int b)
{
    __typeof__((int)(a = b)) x = 0;
    return x + (int)sizeof((int)(a = b));
}
