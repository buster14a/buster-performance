#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <xmmintrin.h>
#include <sys/mman.h>
#include <unistd.h>
typedef unsigned long long U;
extern float c_parameter_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern float c_load_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern float c_sum_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern float c_xor_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern float c_dirtycall_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern float c_volatileload_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern float c_aftercall_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern float c_mixed_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern float c_signedview_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern float c_rotate_f(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_parameter_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_load_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_sum_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_xor_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_dirtycall_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_volatileload_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_aftercall_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_mixed_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_signedview_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
extern double c_rotate_d(uint32_t x,const uint32_t *a,uint32_t key,uint64_t *side);
static float (*const calls_f[])(uint32_t,const uint32_t*,uint32_t,uint64_t*)={c_parameter_f,c_load_f,c_sum_f,c_xor_f,c_dirtycall_f,c_volatileload_f,c_aftercall_f,c_mixed_f,c_signedview_f,c_rotate_f};
static double (*const calls_d[])(uint32_t,const uint32_t*,uint32_t,uint64_t*)={c_parameter_d,c_load_d,c_sum_d,c_xor_d,c_dirtycall_d,c_volatileload_d,c_aftercall_d,c_mixed_d,c_signedview_d,c_rotate_d};
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

extern float callf_u32(uint64_t,const uint32_t*,uint32_t,uint64_t*,float (*)(uint32_t,const uint32_t*,uint32_t,uint64_t*));
extern double calld_u32(uint64_t,const uint32_t*,uint32_t,uint64_t*,double (*)(uint32_t,const uint32_t*,uint32_t,uint64_t*));
static uint32_t wanted(unsigned k,uint32_t x,uint32_t y,uint32_t key){switch(k){case 0:return x;case 1:return y;case 2:return x+key;case 3:return x^key;case 4:return x;case 5:return y;case 6:return y;case 7:return (key&1)?x:y;case 8:return y;case 9:return (x<<(key&31))|(x>>((0u-key)&31));}return 0;}
int main(void){
    uint32_t points[8000];unsigned n=0,initialcsr=_mm_getcsr();long pg=sysconf(_SC_PAGESIZE);
    char *memory=mmap(NULL,pg*2,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(memory==MAP_FAILED||mprotect(memory+pg,pg,PROT_NONE))return 2;
    uint32_t *ptr=(uint32_t*)(memory+pg)-1;
    for(unsigned e=0;e<32;e++)for(int adj=-5;adj<=5;adj++){points[n++]=(1u<<e)+adj;points[n++]=~((1u<<e)+adj);}
    for(unsigned e=24;e<32;e++){unsigned step=1u<<(e-23);for(unsigned j=0;j<8;j++)for(int d=-3;d<=3;d++)points[n++]=(1u<<e)+step*j+(step/2)+d;}
    for(unsigned i=0;i<2048;i++)points[n++]=(uint32_t)mix(i+9713);
    uint64_t cnt=0,hash=0;
    for(unsigned mode=0;mode<4;mode++)for(unsigned env=0;env<4;env++)for(unsigned i=0;i<n;i++){
        uint32_t x=points[i],y=points[(71*i+17)%n],key=(uint32_t)mix(i);*ptr=y;
        uint64_t raw=((mix(i+373)|0x8000000000000000ULL)&0xffffffff00000000ULL)|x;
        unsigned initial=0x1f80|(mode<<13)|(env&1?0x8040:0)|(env&2?0x15:0);
        for(unsigned k=0;k<10;k++)for(unsigned precision=0;precision<2;precision++){
            int inexact;uint32_t value=wanted(k,x,y,key);uint64_t expect=oracle(value,precision?53:24,mode,&inexact),side=0x1234f0f05a5a4321ULL;
            _mm_setcsr(initial);uint64_t got=precision?db(calld_u32(raw,ptr,key,&side,calls_d[k])):fb(callf_u32(raw,ptr,key,&side,calls_f[k]));
            unsigned flags=_mm_getcsr();uint64_t sideexpect=k==8?(uint64_t)(int64_t)(int32_t)y:0x1234f0f05a5a4321ULL;
            if(got!=expect||flags!=(initial|(inexact?32:0))||side!=sideexpect){fprintf(stderr,"case %u precision %u mode %u input %08x expected %llx got %llx flags %x/%x side %llx/%llx\n",k,precision,mode,x,(U)expect,(U)got,initial|(inexact?32:0),flags,(U)sideexpect,(U)side);return 1;}
            hash=(hash^got^side^flags)*1099511628211ULL;cnt++;
        }
    }
    _mm_setcsr(initialcsr);printf("%llu integer-oracle result, MXCSR and side-effect checks %016llx\n",(U)cnt,(U)hash);return 0;
}
