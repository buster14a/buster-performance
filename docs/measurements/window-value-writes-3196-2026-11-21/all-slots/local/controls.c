struct Object { int x; double y; char z; };
extern long get(long);
static unsigned *const *root;

long examples(int n, float f, double d, int *p, struct Object *q, unsigned k)
{
    int a=+3, b=-7;
    float volatile f1=1.25f;
    double volatile d1=-8.5;
    unsigned long s=(unsigned long)(signed char)0xef;
    long u=p[4]++ + p[1]++ + (int)(f1++ + d1--);
    int *addr=&q->x;
    unsigned *other=*root;
    p+=3;
    *addr=(short)0xa0e3;
    b += 4;
    f-=d;
    u+=(n && p && *p && q->x ? get(get(n)+get(b)) : get(a)) + (s && (p || get(f > 1)));
    return ((k && f && !d) || (p && n)) ? u+(p[-1]++ + (*other)++ + q->x--) : q->x+q->z;
}
