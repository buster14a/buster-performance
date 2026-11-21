void f(int *p);
int g(void)
{
    {
        int x __attribute__((cleanup(f))) = 7;
        return x;
    }
}
