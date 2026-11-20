#define _GNU_SOURCE
#include <immintrin.h>
#include <inttypes.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <unistd.h>

struct packed_f { char gap; float x; } __attribute__((packed));
struct packed_d { char gap; double x; } __attribute__((packed));
#define DECL(tag,T,R,P) R tag(const T*); R tag##_indexed(const T*,size_t); R tag##_packed(const struct P*); R tag##_volatile(const volatile T*); R tag##_shared(const T*,T*); R tag##_negative(const T*,size_t); R tag##_across_store(T*,T*,T);
DECL(f_i32,float,int32_t,packed_f)
DECL(d_i32,double,int32_t,packed_d)
DECL(f_i64,float,int64_t,packed_f)
DECL(d_i64,double,int64_t,packed_d)
DECL(f_u32,float,uint32_t,packed_f)
DECL(d_u32,double,uint32_t,packed_d)
static uint64_t steps=0,digest=UINT64_C(14695981039346656037);
static uint64_t step(uint64_t *s){*s^=*s<<13;*s^=*s>>7;*s^=*s<<17;return *s;}
static bool defined_input(uint64_t bits,unsigned source,unsigned target,bool unsign)
{
    unsigned part=source==32?23:52;
    unsigned bias=source==32?127:1023;
    uint64_t sign=UINT64_C(1)<<(source-1), abs=bits&(sign-1);
    if ((bits & sign) && unsign) return abs < ((uint64_t)bias<<part);
    uint64_t limit=(uint64_t)(bias+target-!unsign)<<part;
    return abs<limit || (!unsign && (bits&sign) && abs==limit);
}
static int match(uint64_t value,uint64_t expected,unsigned flags,unsigned expected_flags)
{
    if(value!=expected || flags!=expected_flags) {
        fprintf(stderr,"observation %" PRIu64 " result=%016" PRIx64 "/%016" PRIx64 " flags=%02x/%02x\n",steps,value,expected,flags,expected_flags);
        return 0;
    }
    digest=(digest^value)*UINT64_C(1099511628211);digest=(digest^flags)*UINT64_C(1099511628211);steps++;return 1;
}
#define RUN(tag,T,UT,R,UR,P,BITS,TARGET_BITS,UNSIGNED,DIRECTIVE,HW_OUT) do { \
  UT bits=(UT)(BITS); \
  if (!language || defined_input(bits,sizeof(T)*8,TARGET_BITS,UNSIGNED)) { \
    T input;memcpy(&input,&bits,sizeof(T));HW_OUT raw;_mm_setcsr(csr); \
    __asm__ volatile(DIRECTIVE " %1,%0":"=r"(raw):"x"(input):"memory"); \
    unsigned wantflags=_mm_getcsr()&63u;uint64_t want=(uint64_t)(UR)raw; \
    for(unsigned misalign=0;misalign<2;misalign++){ \
      unsigned char *addr=end-sizeof(T)-misalign;memcpy(addr,&input,sizeof(T)); \
      const T *ptr=(const T*)(const void*)addr; \
      for(unsigned mode=0;mode<7;mode++){ \
        if(language && misalign && mode!=2) continue; \
        T copied;memset(&copied,0,sizeof(copied));_mm_setcsr(csr);R got; \
        switch(mode) { case 0: got=tag(ptr);break; case 1:got=tag##_indexed(ptr-3,3);break; \
        case 2:got=tag##_packed((const struct P*)(const void*)(addr-1));break;case 3:got=tag##_volatile(ptr);break; \
        case 4:got=tag##_shared(ptr,&copied);break;case 5:got=tag##_negative(ptr-2,3);break;default:got=tag##_across_store((T*)(void*)addr,(T*)(void*)addr,(T)0);break;} \
        unsigned actual=_mm_getcsr()&63u; \
        if(!match((uint64_t)(UR)got,want,actual,wantflags) || (mode==4 && memcmp(&copied,&input,sizeof(T)))) return 3; \
        if(mode==6){UT stored;memcpy(&stored,addr,sizeof(stored));if(stored!=0)return 5;} \
      } \
    } \
  } \
}while(0)
static void caught(int signal,siginfo_t *info,void *context)
{
    (void)context;
    if(signal==SIGFPE && info->si_code==FPE_FLTINV)_exit(101);
    if(signal==SIGSEGV && info->si_code==SEGV_ACCERR)_exit(102);
    _exit(103);
}
static int trap_probe(unsigned fault,unsigned char *end,unsigned saved)
{
    pid_t p=fork();if(p<0)return 0;
    if(!p){struct sigaction action;memset(&action,0,sizeof(action));action.sa_sigaction=caught;action.sa_flags=SA_SIGINFO;sigemptyset(&action.sa_mask);
        if(sigaction(SIGFPE,&action,0)||sigaction(SIGSEGV,&action,0))_exit(104);
        unsigned csr=(saved&~63u)|0x1f80u;_mm_setcsr(fault?csr:(csr&~0x80u));volatile double invalid;uint64_t bits=UINT64_C(0x7ff0000000000001);memcpy((void*)&invalid,&bits,8);
        volatile int32_t out=d_i32(fault?(const double*)(const void*)end:(const double*)&invalid);(void)out;_exit(0);}
    int status=0;return waitpid(p,&status,0)==p && WIFEXITED(status) && WEXITSTATUS(status)==(fault?102:101);
}
int main(int argc,char **argv)
{
    if(argc!=2 || (strcmp(argv[1],"language")&&strcmp(argv[1],"machine")))return 2;
    bool language=!strcmp(argv[1],"language");unsigned saved=_mm_getcsr();
    long page=sysconf(_SC_PAGESIZE);unsigned char *map=mmap(NULL,2*(size_t)page,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(map==MAP_FAILED || mprotect(map+page,(size_t)page,PROT_NONE))return 2;
    unsigned char* end=map+page;
    static const uint32_t floats[]={0,0x80000000u,1,0x80000001u,0x007fffffu,0x00800000u,0x3f7fffffu,0xbf7fffffu,0x3fc00000u,0xbfc00000u,0x4effffffu,0x4f000000u,0xcf000000u,0x4f7fffffu,0x4f800000u,0x5effffffu,0x5f000000u,0xdf000000u,0x7f7fffffu,0x7f800000u,0xff800000u,0x7f800001u,0xffc02468u};
    static const uint64_t doubles[]={0,UINT64_C(0x8000000000000000),1,UINT64_C(0x8000000000000001),UINT64_C(0x000fffffffffffff),UINT64_C(0x0010000000000000),UINT64_C(0x3fefffffffffffff),UINT64_C(0xbfefffffffffffff),UINT64_C(0x3ff8000000000000),UINT64_C(0xbff8000000000000),UINT64_C(0x41dfffffffffffff),UINT64_C(0x41e0000000000000),UINT64_C(0xc1e0000000180000),UINT64_C(0xc1e0000000000000),UINT64_C(0x41efffffffffffff),UINT64_C(0x41f0000000000000),UINT64_C(0x43dfffffffffffff),UINT64_C(0x43e0000000000000),UINT64_C(0xc3e0000000000000),UINT64_C(0x7fefffffffffffff),UINT64_C(0x7ff0000000000000),UINT64_C(0xfff0000000000000),UINT64_C(0x7ff0000000000001),UINT64_C(0xfff8246800000001)};
    for(unsigned round=0;round<4;round++)for(unsigned flush=0;flush<4;flush++)for(unsigned sticky=0;sticky<2;sticky++){
      unsigned csr=(saved&~0xffffu)|0x1f80u|(round<<13)|((flush&1u)<<6)|((flush&2u)<<14)|(sticky?0x25u:0u);
      uint64_t state=UINT64_C(0xec70b42997d50d9f);
      for(unsigned i=0;i<1024;i++){uint32_t f=i<sizeof(floats)/sizeof(*floats)?floats[i]:(uint32_t)step(&state);uint64_t d=i<sizeof(doubles)/sizeof(*doubles)?doubles[i]:step(&state);
        RUN(f_i32,float,uint32_t,int32_t,uint32_t,packed_f,f,32,false,"cvttss2sil",int32_t);
        RUN(d_i32,double,uint64_t,int32_t,uint32_t,packed_d,d,32,false,"cvttsd2sil",int32_t);
        RUN(f_i64,float,uint32_t,int64_t,uint64_t,packed_f,f,64,false,"cvttss2siq",int64_t);
        RUN(d_i64,double,uint64_t,int64_t,uint64_t,packed_d,d,64,false,"cvttsd2siq",int64_t);
        RUN(f_u32,float,uint32_t,uint32_t,uint32_t,packed_f,f,32,true,"cvttss2siq",int64_t);
        RUN(d_u32,double,uint64_t,uint32_t,uint32_t,packed_d,d,32,true,"cvttsd2siq",int64_t);
      }
    }
    _mm_setcsr(saved);if(!trap_probe(0,end,saved)||!trap_probe(1,end,saved))return 4;
    printf("%s checks=%" PRIu64 " digest=%016" PRIx64 " invalid=SIGFPE guarded=SIGSEGV\n",argv[1],steps,digest);munmap(map,2*(size_t)page);return 0;
}
