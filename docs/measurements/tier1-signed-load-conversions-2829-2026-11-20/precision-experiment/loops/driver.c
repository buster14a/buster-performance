#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#if WIDTH == 32
typedef float Input;
typedef double Output;
typedef uint32_t InBits;
typedef uint64_t OutBits;
#else
typedef double Input;
typedef float Output;
typedef uint64_t InBits;
typedef uint32_t OutBits;
#endif
extern void stream(Output *,const Input *,unsigned);
enum { N=2048 };
static Input input[N];
static Output expected[N],actual[N];
int main(int argc,char **argv)
{
    unsigned rounds=argc==3?(unsigned)strtoul(argv[1],0,10):0;
    unsigned dirty=argc==3?(unsigned)strtoul(argv[2],0,10):2;
    if (!rounds || dirty>1) return 2;
    uint64_t s=UINT64_C(0x95fa866618e391dd);
    for (unsigned i=0;i<N;i++) {
        s^=s<<13; s^=s>>7; s^=s<<17;
#if WIDTH == 32
        InBits bits=((uint32_t)s&UINT32_C(0x807fffff)) | (uint32_t)(95+(s>>58))*UINT32_C(0x800000);
#else
        InBits bits=(s&UINT64_C(0x800fffffffffffff)) | (uint64_t)(991+(s>>58))*UINT64_C(0x10000000000000);
#endif
        memcpy(&input[i],&bits,sizeof(bits)); expected[i]=(Output)input[i];
    }
    for (unsigned r=0;r<rounds;r++) {
        __asm__ volatile("vzeroupper" ::: "memory");
        if (dirty) __asm__ volatile("vpternlogd $255, %%zmm9, %%zmm9, %%zmm9" ::: "xmm9","memory");
        stream(actual,input,N);
    }
    __asm__ volatile("vzeroupper" ::: "memory");
    uint64_t digest=UINT64_C(14695981039346656037);
    for (unsigned i=0;i<N;i++) {
        OutBits bits; memcpy(&bits,&actual[i],sizeof(bits));
        if(memcmp(&actual[i],&expected[i],sizeof(bits))) return 3;
        digest=(digest^(uint64_t)bits)*UINT64_C(1099511628211);
    }
    printf("%u %u %016" PRIx64 "\n",N,rounds,digest);return 0;
}
