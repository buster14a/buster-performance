struct pair { int first; long second; unsigned bits : 3; };
struct outer { struct pair inner; struct pair* link; int list[4]; };
union both { int whole; float part; };
struct wide { long double big; int small; };
extern int global;
static long file_scope;
_Thread_local int thread_scope;
_Atomic int shared;
extern int table[4];
extern int open_list[];
_Complex double zed;
typedef int four __attribute__((vector_size(16)));
typedef int spaced __attribute__((aligned(16)));
typedef float fourf __attribute__((ext_vector_type(4)));
typedef union { int* ip; long* lp; long whole; } either __attribute__((transparent_union));
enum shade { RED, GREEN };
int callee(int a, long b);
void fi(int);
void fl(long);
void fd(double);
void fp(const char*);
void fv(void*);
void fst(struct pair);
void fld(long double);
void ffour(four);
void fe(enum shade);
void fb(_Bool);
void ff(float);
void fip(int*);
void fcp(const int*);
void ffn(void (*)(int));
void fat(_Atomic int);
void fvol(volatile int*);
void fev(fourf);
void fbit(_BitInt(24));
void fz(_Complex double);
void fcvv(const volatile void*);
int* hop(int);
void ft(either);
four make_four(void);
const int cfi(void);
int vf(int, ...);
int more(int, int, int, int, int, int);
int printf(const char*, ...);
extern void (*fptr)(int);
__int128 big(int);
void none(void);
struct outer whole(struct outer* o)
{
    return *o;
}
int contexts(int a, long b, int* p, struct outer* o, struct outer v, int n, double d, char c, int (*q)[n], long double e, float f, char (*h)[4294967296],
             _BitInt(24) bi, __int128 w, __float128 q128, union both un, long double* lds, _Complex double* zp, four vec,
             struct wide* wp, four other, enum shade sh, fourf ev)
{
    int local = a;
    long wide = a;
    static int still;
    volatile int vol = a;
    register int reg = a;
    const int fixed = 3;
    int arr[4];
    spaced apart = a;
    volatile struct pair vsp;
    volatile int va[4];
    int* const kept = p;
    short shorts[2];
