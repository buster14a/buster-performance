typedef union { int i; float f; } U;
U u;
void f(void)
{
    static __auto_type s =
        u;
}
