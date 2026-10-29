void f(void)
{
    __auto_type x =
        sizeof(int (*)(int[sizeof(x)], ...));
}
