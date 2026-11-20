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
        T q=x[i];out[i]=q*q+bias[i];
#elif KIND == 1
        out[i]=x[i]*(T)1.25+bias[i];
#elif KIND == 2
        out[i]=(T)ints[i]*scale+bias[i];
#elif KIND == 3
        r=r*(T)0.875+bias[i];out[i]=r;
#else
        T q=x[i];out[2*i]=q*scale+bias[i];out[2*i+1]=q+scale;
#endif
    }
}
