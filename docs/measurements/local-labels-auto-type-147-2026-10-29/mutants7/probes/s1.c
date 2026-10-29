void f(void)
{
    __auto_type x =
        sizeof(int[true + sizeof(x)]);
}
