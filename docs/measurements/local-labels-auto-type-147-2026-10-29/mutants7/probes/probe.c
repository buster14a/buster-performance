#include <stdio.h>
typedef struct { int x; long y; } P;
typedef union { int i; float f; } U;
typedef int v4 __attribute__((vector_size(16)));
typedef float f8 __attribute__((ext_vector_type(8)));
static P mk(int n) { P p = { n, n * 2L }; return p; }
static U mku(int n) { U u; u.i = n; return u; }
__auto_type file_p = (P){ 5, 6L };
static __auto_type file_u = (U){ .i = 7 };
static v4 vin = { 1, 2, 3, 4 };
int tested(int n)
{
    __auto_type a = mk(n);
    __auto_type b = mku(n + 1);
    __auto_type c = vin + vin;
    v4 w = { n, n, n, n };
    __auto_type d = w * c;
    const __auto_type e = (P){ n, 9L };
    __auto_type f = n > 2 ? a : e;
    __auto_type g = ({ P t = { n + 3, 4L }; t; });
    static __auto_type h = (P){ 11, 12L };
    __auto_type k = (f8){ 1, 2, 3, 4, 5, 6, 7, 8 };
    volatile __auto_type m = (P){ n, 1L };
    h.x += n;
    return a.x + (int)a.y + b.i + c[1] + d[2] + e.x + (int)e.y + f.x + g.x + (int)g.y + h.x + (int)k[7] + m.x + file_p.x + file_u.i;
}
int main(void)
{
    int s = 0;
    for (int i = 0; i < 5; i += 1) s += tested(i);
    printf("%d\n", s);
    return 0;
}
