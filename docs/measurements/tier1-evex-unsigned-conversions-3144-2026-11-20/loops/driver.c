#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef unsigned long long Input;
#if OUT_WIDTH == 64
typedef double Output;
#else
typedef float Output;
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
        input[i]=(i&7)?state:((1ULL<<(i%64))-1);expected[i]=(Output)input[i];
    }
    for(unsigned r=0;r<reps;r++){
        __asm__ volatile("vzeroupper":::"memory");
        if(dirty)__asm__ volatile("vpternlogd $255,%%zmm9,%%zmm9,%%zmm9":::"xmm9","memory");
        stream(actual,input,N);
    }
    __asm__ volatile("vzeroupper":::"memory");
    uint64_t h=UINT64_C(14695981039346656037);
    for(unsigned i=0;i<N;i++){if(memcmp(&actual[i],&expected[i],sizeof(Output)))return 3;uint64_t bits=0;memcpy(&bits,&actual[i],sizeof(Output));h=(h^bits)*UINT64_C(1099511628211);}
    printf("%u %u %016" PRIx64 "\n",N,reps,h);return 0;
}
