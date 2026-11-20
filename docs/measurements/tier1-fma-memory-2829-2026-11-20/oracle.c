// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#include <fenv.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#pragma STDC FENV_ACCESS ON

#define DECLARE(s,t) \
 extern t fma_a_##s(t,t,const t*), fma_c_##s(t,t,const t*), fma_scaled_##s(t,t,const t*,unsigned long); \
 extern t fma_first_##s(t,t,const t*), fma_addend_##s(t,t,const t*), fma_store_##s(t,t,t*); \
 extern void fma_fresh_##s(t,t,const t*,t*);
DECLARE(f32,float)
DECLARE(f64,double)

static uint64_t digest = UINT64_C(14695981039346656037);
static uint64_t checks;
static const uint64_t words[2][16] = {
 {0,0x80000000,0x3f800000,0xbf800000,1,0x80000001,0x00800000,0x7f7fffff,0x3f800001,0xc0000001,
  0x7f800000,0xff800000,0x7fc12345,0xffc10001,0x7f800017,0xff8000f1},
 {0,UINT64_C(0x8000000000000000),UINT64_C(0x3ff0000000000000),UINT64_C(0xbff0000000000000),1,UINT64_C(0x8000000000000001),
  UINT64_C(0x0010000000000000),UINT64_C(0x7fefffffffffffff),UINT64_C(0x3ff0000000000001),UINT64_C(0xc000000000000001),
  UINT64_C(0x7ff0000000000000),UINT64_C(0xfff0000000000000),UINT64_C(0x7ff8123456789abc),UINT64_C(0xfff8000000000101),
  UINT64_C(0x7ff0000000000017),UINT64_C(0xfff00000000000f1)}
};

__attribute__((noinline)) static float ref_f32(float a, float b, float c)
{
    __asm__ volatile("vfmadd213ss %2, %1, %0" : "+x"(b) : "x"(a), "x"(c));
    return b;
}

__attribute__((noinline)) static double ref_f64(double a, double b, double c)
{
    __asm__ volatile("vfmadd213sd %2, %1, %0" : "+x"(b) : "x"(a), "x"(c));
    return b;
}

#define TEST(s,t,which) \
static int check_##s(uint64_t xa,uint64_t xb,uint64_t xc,void *last) \
{ \
  t a,b,c,reference; memcpy(&a,&xa,sizeof(t)); memcpy(&b,&xb,sizeof(t)); memcpy(&c,&xc,sizeof(t)); \
  feclearexcept(FE_ALL_EXCEPT); reference=ref_##s(a,b,c); const int expected=fetestexcept(FE_ALL_EXCEPT); \
  for(unsigned k=0;k<7;k++) { \
    uint64_t input=k==4?xa:k==5?xc:xb; memcpy(last,&input,sizeof(t)); t got; t out[3]; \
    feclearexcept(FE_ALL_EXCEPT); \
    if(k==0) got=fma_a_##s(a,c,last); else if(k==1) got=fma_c_##s(c,a,last); \
    else if(k==2) { fma_fresh_##s(a,c,last,out); got=out[0]; if(memcmp(out+1,&a,sizeof(t)) || memcmp(out+2,&c,sizeof(t))) return 1; } \
    else if(k==3) got=fma_scaled_##s(a,c,((const t*)last)-3,2); \
    else if(k==4) got=fma_first_##s(b,c,last); else if(k==5) got=fma_addend_##s(a,b,last); \
    else {got=fma_store_##s(a,c,last); if(memcmp(last,&c,sizeof(t))) return 1;} \
    int actual=fetestexcept(FE_ALL_EXCEPT); uint64_t raw=0; memcpy(&raw,&got,sizeof(t)); \
    if(memcmp(&got,&reference,sizeof(t))||actual!=expected) { \
      fprintf(stderr,"width=%u form=%u A=%016" PRIx64 " B=%016" PRIx64 " C=%016" PRIx64 " result=%016" PRIx64 " flags=%d expected=%d\n",which,k,xa,xb,xc,raw,actual,expected); return 1; }\
    checks++; digest=(digest^raw^(unsigned)actual)*UINT64_C(1099511628211); \
  } return 0; \
}
TEST(f32,float,32)
TEST(f64,double,64)

int main(void)
{
    const int modes[4]={FE_TONEAREST,FE_DOWNWARD,FE_UPWARD,FE_TOWARDZERO};
    const size_t page=(size_t)sysconf(_SC_PAGESIZE);
    unsigned char *region=mmap(NULL,2*page,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(region==MAP_FAILED || mprotect(region+page,page,PROT_NONE)) return 2;
    for(unsigned mode=0;mode<4;mode++) {
        if(fesetround(modes[mode])) return 2;
        for(unsigned a=0;a<16;a++) for(unsigned b=0;b<16;b++) for(unsigned c=0;c<16;c++) {
            if(check_f32(words[0][a],words[0][b],words[0][c],region+page-4)) return 1;
            if(check_f64(words[1][a],words[1][b],words[1][c],region+page-8)) return 1;
        }
    }
    printf("%" PRIu64 " bit patterns and exception sets %016" PRIx64 "\n",checks,digest);
    return munmap(region,2*page)!=0;
}
