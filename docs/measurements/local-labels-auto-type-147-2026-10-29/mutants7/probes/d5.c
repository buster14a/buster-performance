typedef int v4 __attribute__((vector_size(16)));
v4 gv;
void f(void)
{
    static __auto_type s =
        gv;
}
