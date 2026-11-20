#ifndef NAME
#define NAME kernel
#endif
void NAME(long double *out, const long double *in, unsigned n)
{
#if CASE == 2
    long double r=0.0L;
#endif
    for(unsigned i=0;i<n;i++) {
        long double x=in[i];
#if CASE == 0
        out[i]=x*0.5L+1.0L;
#elif CASE == 1
        out[i]=((x*1.125L-0.75L)*x+0.5L)*x+0.015625L;
#elif CASE == 2
        r=r*0.875L+x;out[i]=r;
#else
        out[i]=x*0x1.0000000000000002p0L+0x1.0000000000000006p-1L;
#endif
    }
}
