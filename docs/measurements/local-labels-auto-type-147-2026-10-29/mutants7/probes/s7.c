void f(void)
{
    __auto_type x = 1;
    __auto_type y =
        sizeof(int (*)(int[sizeof(x) + sizeof(y)], ...));
}
