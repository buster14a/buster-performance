#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
enum { N=256 };
void kernel(long double*,const long double*,unsigned);
void reference(long double*,const long double*,unsigned);
static long double in[N],out[N],expected[N];
int main(int argc,char **argv) {
    unsigned m=argc==2?(unsigned)strtoul(argv[1],0,10):0;
    if(!m||m>1000000)return 2;
    uint64_t v=UINT64_C(0xde9d2b112bc97ccd);
    for(unsigned i=0;i<N;i++){v^=v<<7;v^=v>>9;in[i]=(long double)((int)(v%300003)-150001)*0x1p-17L;}
    __asm__ volatile("fninit");reference(expected,in,N);
    unsigned short ref;__asm__ volatile("fnstsw %0":"=m"(ref)::"memory");
    __asm__ volatile("fninit");
    for(unsigned j=0;j<m;j++) kernel(out,in,N);
    unsigned short flags;__asm__ volatile("fnstsw %0":"=m"(flags)::"memory");
    if((flags&0x383f)!=(ref&0x383f))return 3;
    uint64_t h=UINT64_C(14695981039346656037);
    for(unsigned i=0;i<N;i++){
        if(memcmp(out+i,expected+i,10))return 4;
        const unsigned char *p=(const unsigned char *)(out+i);
        for(unsigned k=0;k<10;k++)h=(h^p[k])*UINT64_C(1099511628211);
    }
    printf("%d %u %04x %016" PRIx64 "\n",N,m,flags&0x383f,h);return 0;
}
