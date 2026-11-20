#define _GNU_SOURCE
#include <immintrin.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
struct wide_packed {char pad;double value;} __attribute__((packed));
struct narrow_packed {char pad;float value;} __attribute__((packed));
extern double to_double(const float*),to_double_index(const float*,size_t),to_double_packed(const struct narrow_packed*);
extern float to_float(const double*),to_float_index(const double*,size_t),to_float_packed(const struct wide_packed*);
extern void to_double_stream(double*,const float*,unsigned),to_float_stream(float*,const double*,unsigned);
static uint32_t flags(void) {return _mm_getcsr()&0x3f;}
static uint64_t next(uint64_t *s) {*s^=*s<<13;*s^=*s>>7;*s^=*s<<17;return *s;}
static uint64_t checked,digest=UINT64_C(1469598103934665603);
static int compare(uint64_t a,uint64_t b,uint32_t fs,uint32_t expected)
{
    if(a!=b || fs!=expected){if(checked<UINT64_MAX)fprintf(stderr,"observation %" PRIu64 ": %" PRIx64 " vs %" PRIx64 ", flags %x vs %x\n",checked,a,b,fs,expected);return 0;}
    digest=(digest^a)*UINT64_C(1099511628211);digest=(digest^fs)*UINT64_C(1099511628211);checked++;return 1;
}
int main(void)
{
    static const uint64_t w[]={0,UINT64_C(0x8000000000000000),1,UINT64_C(0x8000000000000001),UINT64_C(0x0010000000000000),UINT64_C(0x380fffffe0000000),UINT64_C(0x3ff0000010000000),UINT64_C(0x47efffffe0000000),UINT64_C(0x7fefffffffffffff),UINT64_C(0x7ff0000000000000),UINT64_C(0xfff0000000000000),UINT64_C(0x7ff0000000001111),UINT64_C(0xfff8abcde1234567)};
    static const uint32_t f[]={0,0x80000000u,1,0x80000001u,0x00800000,0x007fffff,0x3f800001,0x7f7fffff,0x7f800000,0xff800000,0x7f800011,0xffc01234};
    long page=sysconf(_SC_PAGESIZE);char *map=mmap(NULL,(size_t)(2*page),PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(map==MAP_FAILED || mprotect(map+page,(size_t)page,PROT_NONE))return 2;
    char *last=map+page;unsigned saved=_mm_getcsr();
    for(unsigned rounding=0;rounding<4;rounding++)for(unsigned flush=0;flush<4;flush++)for(unsigned sticky=0;sticky<2;sticky++) {
        unsigned csr=(saved&~0xffbfu)|0x1f80u|(rounding<<13)|((flush&1u)<<6)|((flush&2u)<<14)|(sticky?0x25u:0u);
        uint64_t r=UINT64_C(0xcff537a1b54a32d1);
        for(unsigned i=0;i<2056;i++){
            uint64_t x=i<sizeof(w)/8?w[i]:next(&r);uint32_t y=i<sizeof(f)/4?f[i]:(uint32_t)next(&r);
            double wide;float small;memcpy(&wide,&x,8);memcpy(&small,&y,4);
            uint64_t er64,got64;uint32_t er32,got32;double out64;float out32;
            _mm_setcsr(csr);
            __asm__ volatile("cvtss2sd %1,%0":"=x"(out64):"m"(small):"memory");unsigned fe=flags();memcpy(&er64,&out64,8);
            memcpy(last-4,&y,4);
            for(unsigned mode=0;mode<4;mode++){
                _mm_setcsr(csr);
                if(mode==0)out64=to_double((float*)(last-4));
                else if(mode==1)out64=to_double_index((float*)(last-32),5);
                else if(mode==2)out64=to_double_packed((const struct narrow_packed*)(last-5));
                else to_double_stream(&out64,(float*)(last-4),1);
                unsigned actual=flags();memcpy(&got64,&out64,8);
                if(!compare(got64,er64,actual,fe))return 3;
            }
            _mm_setcsr(csr);
            __asm__ volatile("cvtsd2ss %1,%0":"=x"(out32):"m"(wide):"memory");fe=flags();memcpy(&er32,&out32,4);
            memcpy(last-8,&x,8);
            for(unsigned mode=0;mode<4;mode++){
                _mm_setcsr(csr);
                if(mode==0)out32=to_float((double*)(last-8));
                else if(mode==1)out32=to_float_index((double*)(last-64),5);
                else if(mode==2)out32=to_float_packed((const struct wide_packed*)(last-9));
                else to_float_stream(&out32,(double*)(last-8),1);
                unsigned actual=flags();memcpy(&got32,&out32,4);
                if(!compare(got32,er32,actual,fe))return 4;
            }
        }
    }
    _mm_setcsr(saved);munmap(map,(size_t)(2*page));
    printf("checks=%" PRIu64 " digest=%016" PRIx64 "\n",checked,digest);return 0;
}
