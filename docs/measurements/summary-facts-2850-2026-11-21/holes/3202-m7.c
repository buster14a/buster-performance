void f(int *p);
int g(int n)
{
    int x __attribute__((cleanup(f))) = 7;
    goto out;
out:
    return x;
}
