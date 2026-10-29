typedef struct { int x; long y; } P;
void f(int n)
{
    static __auto_type s =
        (P){ n, 1L };
}
