#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef WIDTH
#error WIDTH is required
#endif
#if WIDTH == 32
typedef float Scalar;
typedef uint32_t Bits;
#else
typedef double Scalar;
typedef uint64_t Bits;
#endif
enum { N=4096 };
extern void flip(Scalar*,Scalar*,const Scalar*,unsigned);
static Scalar input[N],negative[N],original[N];

int main(int argc,char **argv)
{
    const unsigned rounds=argc==3?(unsigned)strtoul(argv[1],0,10):0;
    const unsigned dirty=argc==3?(unsigned)strtoul(argv[2],0,10):2;
    if (!rounds||dirty>1) return 2;
    uint64_t state=UINT64_C(0xa9254b8cf0d76183);
    const Bits sign=(Bits)1<<(WIDTH-1);
    for(unsigned i=0;i<N;i++){
        state^=state<<13;state^=state>>7;state^=state<<17;
        Bits x=(Bits)state;
        memcpy(input+i,&x,sizeof(x));
    }
    for(unsigned r=0;r<rounds;r++){
        __asm__ volatile("vzeroupper" ::: "memory");
        if(dirty) __asm__ volatile("vpternlogd $255, %%zmm9, %%zmm9, %%zmm9" ::: "xmm9","memory");
        flip(negative,original,input,N);
    }
    __asm__ volatile("vzeroupper" ::: "memory");
    uint64_t hash=UINT64_C(14695981039346656037);
    for(unsigned i=0;i<N;i++){
        Bits x,y,z;memcpy(&x,input+i,sizeof(x));memcpy(&y,negative+i,sizeof(y));memcpy(&z,original+i,sizeof(z));
        if(x!=z || (x^sign)!=y) return 3;
        hash=(hash^(uint64_t)y)*UINT64_C(1099511628211);
    }
    printf("%u %u %016" PRIx64 "\n",N,rounds,hash);return 0;
}
