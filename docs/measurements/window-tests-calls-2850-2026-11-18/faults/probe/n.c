void kn(int, int) __attribute__((noreturn));
int f(int a, int b)
{
    if (a) kn(a, b);
    if (b) kn(a, 1000);
    return a;
}
