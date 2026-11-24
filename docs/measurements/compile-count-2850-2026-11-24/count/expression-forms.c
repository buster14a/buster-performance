#define SAME(x) ((x) == (x))
#define ID(x) (x)
#define NULLP ((void *)0)
#define TRUTH(x) ((x) ? 1 : 0)
struct S { int a; int arr[4]; int *p; void (*fn)(void); struct S *next; char name[8]; };
int garr[4];
int garr2[4];
void gfn(void);
int *ret(void) __attribute__((returns_nonnull));
int *plain(void);
void take_bool(_Bool);
void nn(int *p, int *q) __attribute__((nonnull(1)));
int self(int x, int y, struct S s, struct S *p, int *q)
{
    int r = 0;
    r += x == x;
    r += x != x;
    r += x <= x;
    r += s.a == s.a;
    r += p->a == p->a;
    r += p->next->a == p->next->a;
    r += p->arr[1] == p->arr[1];
    r += p->arr[1] == p->arr[2];
    r += s.a == p->a;
    r += SAME(x);
    r += ID(x) == x;
    r += x == ID(x);
    r += (x) == x;
    r += garr == garr;
    r += garr == garr2;
    r += garr != garr2;
    r += garr < garr2;
    r += s.arr == s.arr;
    r += s.arr == p->arr;
    r += q + 1u >= q;
    r += q + 1u < q;
    r += q > q + 1u;
    r += q + 1 >= q;
    r += (q + 1u) >= q;
    r += "a" == "b";
    r += q == (int *)"a";
    r += s.name == "x";
    r += "x" == 0;
    return r + y;
}
int pointer(int x, struct S s, struct S *p, int *q, int *nonnull_parameter) __attribute__((nonnull(5)));
int pointer(int x, struct S s, struct S *p, int *q, int *nonnull_parameter)
{
    int r = 0;
    if (garr) r++;
    if (!garr) r++;
    if (gfn) r++;
    if (&gfn) r++;
    if (&x) r++;
    if (&s) r++;
    if (&s.a) r++;
    if (&p->a) r++;
    if (s.arr) r++;
    if (p->arr) r++;
    if (s.name) r++;
    if (p->fn) r++;
    if (s.fn) r++;
    if (p->p) r++;
    if (p->next) r++;
    if (p->next->next) r++;
    if (q) r++;
    if (ret()) r++;
    if ((ret())) r++;
    if (plain()) r++;
    if (nonnull_parameter) r++;
    if (!nonnull_parameter) r++;
    if (garr == 0) r++;
    if (0 == garr) r++;
    if (garr != NULLP) r++;
    if (gfn == 0) r++;
    if (&x == 0) r++;
    if (&p->a != 0) r++;
    if (p->arr == 0) r++;
    if (s.arr != 0) r++;
    if ((garr) == 0) r++;
    if (ret() == 0) r++;
    if ((ret()) == 0) r++;
    if (((ret())) != NULLP) r++;
    if (plain() == 0) r++;
    if (nonnull_parameter == 0) r++;
    if (p->fn == 0) r++;
    if (p->p == 0) r++;
    if (TRUTH(garr)) r++;
    if (ID(garr)) r++;
    if (ID(garr) == 0) r++;
    r += garr && x;
    r += x || gfn;
    r += garr ? 1 : 2;
    r += p->arr ? 1 : 2;
    _Bool b = garr;
    _Bool c = gfn;
    _Bool d = &x;
    _Bool e = p->arr;
    _Bool f = p->p;
    b = s.arr;
    c = p->fn;
    take_bool(garr);
    take_bool(p->arr);
    take_bool(gfn);
    take_bool(q);
    take_bool(ret());
    return r + b + c + d + e + f;
}
int modified(int *np) __attribute__((nonnull));
int modified(int *np)
{
    int r = 0;
    if (np) r++;
    np = 0;
    if (np) r++;
    return r;
}
_Bool returns_bool(struct S *p) { return p->arr; }
_Bool returns_bool2(void) { return garr; }
