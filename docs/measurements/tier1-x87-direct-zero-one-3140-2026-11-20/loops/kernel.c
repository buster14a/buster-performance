#ifndef NAME
#define NAME kernel
#endif
void NAME(long double *out,const long double *in,unsigned n)
{
    for(unsigned i=0;i<n;i++){
        long double x=in[i];
#if CASE == 0
        out[i]=x<0.0L?0.0L:x;
#elif CASE == 1
        out[i]=1.0L/(1.0L+x*x);
#elif CASE == 2
        out[i]=x<0.0L?0.0L:1.0L;
#else
        out[i]=x*0x1.0000000000000002p0L+0x1.0000000000000006p-1L;
#endif
    }
}
