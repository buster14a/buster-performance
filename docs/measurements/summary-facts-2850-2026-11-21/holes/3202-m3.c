void f(int *p);
int g(int n)
{
    int x __attribute__((cleanup(f))) = 7;
    {
        int a[n];
        a[0] = x;
    }
    return x;
}
