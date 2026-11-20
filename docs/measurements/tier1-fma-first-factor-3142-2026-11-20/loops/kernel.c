#if WIDTH == 32
typedef float T;
#else
typedef double T;
#endif
#ifndef NAME
#define NAME kernel
#endif
void NAME(T *out,const T *x,const T *bias,const int *ints,unsigned length,T scale)
{
#if KIND == 3
    T r=(T)0.0625;
#endif
    for(unsigned i=0;i<length;i++) {
#if KIND == 0
        out[i]=x[i]*(T)0.875+scale;
#elif KIND == 1
        out[i]=x[i]*(T)1.25+scale;
#elif KIND == 2
        out[i]=x[i]*(T)ints[i]+scale;
#elif KIND == 3
        r=x[i]*(T)0.875+r;out[i]=r;
#else
        T q=bias[i];out[2*i]=x[i]*(T)1.25+q;out[2*i+1]=q+scale;
#endif
    }
}
