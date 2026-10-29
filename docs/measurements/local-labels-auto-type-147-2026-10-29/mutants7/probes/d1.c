typedef struct { int x; long y; } P;
P g;
void f(void)
{
    static __auto_type s =
        g;
}
