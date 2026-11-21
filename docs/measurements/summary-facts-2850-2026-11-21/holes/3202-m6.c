void f(int *p);
int g(int n)
{
    int x __attribute__((cleanup(f))) = 7;
    if (n)
    {
        return 1;
    }
    return x;
}
