#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
enum { N = 2048 };
static long double left[N], right[N], result[N];
static int exponents[N];
static void fill(void) {
    uint64_t s=UINT64_C(0xc4c6e17bd009d48d);
    for (unsigned i=0;i<N;i++) {
        s ^= s<<13; s ^= s>>7; s ^= s<<17;
        long double x=(long double)((int)(s%131071)-65535)*0x1p-13L;
        long double y=(long double)((int)((s>>20)%4095)-2047)*0x1p-8L;
#if CASE == 2 || CASE == 5
        x=fabsl(x)+0x1p-12L;
#elif CASE == 3
        x *= 0x1p-3L;
#elif CASE == 9
        x=fabsl(x)+0.75L;
#endif
        left[i]=x;right[i]=y;
    }
}
int main(int argc,char** argv) {
    if (argc!=2) return 2;
    unsigned n=(unsigned)strtoul(argv[1],NULL,10);
    if(n<1 || n>4096) return 2;
    fill();
    for(unsigned r=0;r<n;r++) {
        for(unsigned j=0;j<N;j++) {
            unsigned i=(j+r)&(N-1);
            long double x=left[i];
#if CASE == 0
            result[i]=exp2l(x);
#elif CASE == 1
            result[i]=expm1l(x);
#elif CASE == 2
            result[i]=log10l(x);
#elif CASE == 3
            result[i]=acosl(x);
#elif CASE == 4
            result[i]=atan2l(x,right[i]);
#elif CASE == 5
            result[i]=powl(x,right[i]);
#elif CASE == 6
            result[i]=coshl(x);
#elif CASE == 7
            result[i]=frexpl(x,&exponents[i]);
#elif CASE == 8
            result[i]=exp10l(x);
#elif CASE == 9
            result[i]=tgammal(x);
#elif CASE == 10
            result[i]=erfl(x);
#elif CASE == 11
            result[i]=sinl(x);
#endif
        }
    }
    uint64_t hash=UINT64_C(1469598103934665603);
    for(unsigned i=0;i<N;i++){
        const unsigned char *b=(unsigned char*)&result[i];
        for(unsigned j=0;j<10;j++) hash=(hash^b[j])*UINT64_C(1099511628211);
        hash=(hash^(unsigned)exponents[i])*UINT64_C(1099511628211);
    }
    unsigned short sw,cw;
    __asm__ volatile("fnstsw %0;fnstcw %1":"=m"(sw),"=m"(cw));
    printf("%016llx %04x %04x\n",(unsigned long long)hash,sw&0x383f,cw);
    return 0;
}
