void f(void)
{
    __auto_type x =
        (int (*)(char[sizeof(__typeof__(x))], ...))0;
}
