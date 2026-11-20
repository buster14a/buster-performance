#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#if IN_WIDTH==32
typedef float Input;
#else
typedef double Input;
#endif
#if OUT_WIDTH==64
typedef int64_t Output;
#elif UNSIGNED_OUTPUT
typedef uint32_t Output;
#else
typedef int32_t Output;
#endif
enum {N=2048};
extern void stream(Output*,const Input*,unsigned);
static Input input[N];static Output expected[N],actual[N];
int main(int argc,char **argv)
{
    unsigned reps=argc==3?(unsigned)strtoul(argv[1],0,10):0;
    unsigned dirty=argc==3?(unsigned)strtoul(argv[2],0,10):2;
    if(!reps || dirty>1)return 2;
    uint64_t state=UINT64_C(0x948e475355acb1e7);
    for(unsigned i=0;i<N;i++) {
        state^=state<<13;state^=state>>7;state^=state<<17;
        double scaled=(double)((state>>12)&0xffffffu)*0.132;
#if UNSIGNED_OUTPUT
        if(i&1u)scaled+=2147483648.;
#else
        if(i&1u)scaled=-scaled;
#if OUT_WIDTH==64
        if(i&2u)scaled*=65536.;
#endif
#endif
        input[i]=(Input)scaled;expected[i]=(Output)input[i];
    }
    for(unsigned r=0;r<reps;r++){
        __asm__ volatile("vzeroupper":::"memory");
        if(dirty)__asm__ volatile("vpternlogd $255,%%zmm9,%%zmm9,%%zmm9":::"xmm9","memory");
        stream(actual,input,N);
    }
    __asm__ volatile("vzeroupper":::"memory");
    uint64_t h=UINT64_C(14695981039346656037);
    for(unsigned i=0;i<N;i++){if(actual[i]!=expected[i])return 3;h=(h^(uint64_t)actual[i])*UINT64_C(1099511628211);}
    printf("%u %u %016" PRIx64 "\n",N,reps,h);return 0;
}
