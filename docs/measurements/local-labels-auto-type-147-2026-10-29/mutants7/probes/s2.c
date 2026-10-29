void f(void)
{
    __auto_type x =
        sizeof(int[nullptr == nullptr ? sizeof(__typeof__(x)) : 1]);
}
