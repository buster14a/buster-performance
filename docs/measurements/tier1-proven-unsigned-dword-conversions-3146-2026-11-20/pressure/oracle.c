#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <xmmintrin.h>
#include <sys/mman.h>
#include <unistd.h>
typedef unsigned long long U;
static U mix(U x) { x ^= x >> 30; x *= 0xbf58476d1ce4e5b9ULL; x ^= x >> 27; x *= 0x94d049bb133111ebULL; return x ^ (x >> 31); }
static U oracle(U x, unsigned p, unsigned mode, int *inexact) {
    if (!x) { *inexact = 0; return 0; }
    unsigned e = 63u - (unsigned)__builtin_clzll(x);
    unsigned s = e >= p ? e + 1 - p : 0;
    U bits = s ? x >> s : x << (p - 1 - e);
    U rem = x & ((1ULL << s) - 1);
    *inexact = rem != 0;
    if (rem && (mode == 2 || (mode == 0 && (rem > (1ULL << (s - 1)) || (rem == (1ULL << (s - 1)) && (bits & 1)))))) {
        if (++bits == (1ULL << p)) { bits >>= 1; ++e; }
    }
    return ((U)(e + (p == 24 ? 127u : 1023u)) << (p - 1)) | (bits & ((1ULL << (p - 1)) - 1));
}
static U fb(float x) { uint32_t z; memcpy(&z,&x,4);return z; }
static U db(double x) { U z;memcpy(&z,&x,8);return z; }


extern void pressure(const volatile uint32_t*,float*,double*);
int main(void){
    long pg=sysconf(_SC_PAGESIZE);char*b=mmap(0,pg*2,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(b==MAP_FAILED||mprotect(b+pg,pg,PROT_NONE))return 2;
    uint32_t*input=(uint32_t*)(b+pg)-24;float f[24];double d[24];U count=0,hash=0;unsigned original=_mm_getcsr();
    for(unsigned r=0;r<1024;r++)for(unsigned mode=0;mode<4;mode++)for(unsigned env=0;env<4;env++){
        unsigned initial=0x1f80|(mode<<13)|(env&1?0x8040:0)|(env&2?0x15:0),status=initial;
        for(unsigned i=0;i<24;i++)input[i]=(r&1)?(uint32_t)mix(24*r+i):((1u<<((r+i)%32))+(i%7)-3);
        _mm_setcsr(initial);pressure(input,f,d);unsigned actual=_mm_getcsr();
        for(unsigned i=0;i<24;i++){
            int inexact;U yf=oracle(input[i],24,mode,&inexact);status|=inexact?32:0;U yd=oracle(input[i],53,mode,&inexact);
            if(fb(f[i])!=yf||db(d[i])!=yd)return 1;
            hash=(hash^yf^yd)*1099511628211ULL;count+=2;
        }
        if(actual!=status)return 1;
    }
    _mm_setcsr(original);printf("%llu guarded spill conversion results and 16384 raw MXCSR checks %016llx\n",count,hash);return 0;
}
