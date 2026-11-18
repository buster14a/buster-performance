struct S;
struct S* ks(int, int);
typedef int F(int, int);
int k0(int, int);
F* getfn(void);
_Atomic(F*) kat;
struct P { char c; F* fn; } __attribute__((packed));
struct B { F* fn; int bits : 3; };
extern F* const kext;
static F* kst;
_Thread_local F* ktl;
void kvoid(int, int);
long long kll(int, int);
double kd(int, int);
int f(int a, struct P* pp, struct B* pb)
{
    register F* rp = k0;
    F* local = k0;
    F* arr[2] = { k0, k0 };
    int x = 0;
    x = pp->fn(a, 1000);
    return x;
}
