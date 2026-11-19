struct pair { int first; long second; unsigned bits : 3; };
typedef int v4 __attribute__((vector_size(16)));
typedef float f4 __attribute__((ext_vector_type(4)));
struct sa { _Atomic int m; int n; };
void fi(int); void fl(long); void ff(float); void fd(double); void fld(long double); void fp(const char*); void fv(void*);
void fat(_Atomic int); void fev(f4); void fvec(v4); void fb(_Bool);
int vf(int, ...);
_Atomic int geta(void); struct sa getsa(void); const double getcd(void); const int getci(void);
#pragma STDC FENV_ACCESS ON
int g(int a, long b, double d, f4 ev, v4 vec, int* ip, float f)
{
    fev(ev + ev);
    return 0;
}
