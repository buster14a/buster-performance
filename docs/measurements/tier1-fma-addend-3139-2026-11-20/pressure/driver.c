#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <unistd.h>
volatile int marker;
__attribute__((noinline)) void barrier(void) { __asm__ volatile("" ::: "memory"); }
static void trap(int sig) { _exit(sig==SIGSEGV && marker==7 ? 0:4); }
static unsigned checks, faults;
static unsigned long long hash=1469598103934665603ull;
static inline unsigned mx(void) { unsigned v; __asm__ volatile("stmxcsr %0":"=m"(v)); return v; }
static inline void set(unsigned x) {__asm__ volatile("ldmxcsr %0"::"m"(x));}

float bias_32[32];
void spill32(const volatile float *a,const float *c,unsigned i,float *r);
float ordered32(float a,float b,const float *c);
float barrier32(float a,float b,float *c);
static __attribute__((noinline)) float ref32(float a,float b,float c) {__asm__ volatile("vfmadd213ss %2,%1,%0" : "+x"(b) : "x"(a),"x"(c));return b;}
static const uint32_t bits32[]={0x0ull,0x80000000ull,0x1ull,0x80000001ull,0x3fc00000ull,0x7f7fffffull,0x7f800000ull,0xff800000ull,0x7fc00111ull,0x7fc00222ull,0x7f800123ull,0xff800321ull};
static int run32(unsigned original) {
 float a[24],c[32],r[24],expect[24]; unsigned long length=sysconf(_SC_PAGESIZE);
 void *page=mmap(0,length,PROT_NONE,MAP_ANONYMOUS|MAP_PRIVATE,-1,0);
 if(page==MAP_FAILED)return 1;
 for(unsigned policy=0;policy<32;policy++) for(unsigned seed=0;seed<72;seed++) {
  unsigned ctl=(original|0x1f80)&~0xe07fU;ctl|=(policy&3)<<13 | ((policy>>2)&1)<<6 | ((policy>>3)&1)<<15 | ((policy>>4)&1);
  for(unsigned j=0;j<24;j++)memcpy(a+j,bits32+(j*7+seed+(seed^j)/5)%12,sizeof(float));
  for(unsigned j=0;j<32;j++){memcpy(c+j,bits32+(seed*5+j*3+j/3)%12,sizeof(float));memcpy(bias_32+j,bits32+(seed*11+j*5+j/3)%12,sizeof(float));}
  set(ctl);spill32(a,c,seed,r);unsigned actual=mx();set(ctl);
  for(unsigned j=0;j<24;j++)expect[j]=ref32(a[j],j%3?a[(j+7)%24]:(float)1.25,(j%2?c:bias_32)[(j+seed)&31]);
  if(actual!=mx()||memcmp(r,expect,sizeof r))return 2;
  for(unsigned j=0;j<sizeof(r);j++){hash^=((unsigned char*)r)[j];hash*=1099511628211ull;}
  float value=c[0],got;set(ctl);got=barrier32(a[0],a[1],&value);actual=mx();set(ctl);float expected=ref32(a[0],a[1],c[0]);
  if(actual!=mx()||memcmp(&value,a+1,sizeof(float))||memcmp(&got,&expected,sizeof(float)))return 3;
  checks+=25;
 }
 set(original);
 pid_t pid=fork();if(!pid){alarm(3);signal(SIGSEGV,trap);marker=0;(void)ordered32(1,1,page);_exit(5);}int st=0;
 if(pid<0||waitpid(pid,&st,0)!=pid||!WIFEXITED(st)||WEXITSTATUS(st))return 4;
 faults++;munmap(page,length);return 0;
}
double bias_64[32];
void spill64(const volatile double *a,const double *c,unsigned i,double *r);
double ordered64(double a,double b,const double *c);
double barrier64(double a,double b,double *c);
static __attribute__((noinline)) double ref64(double a,double b,double c) {__asm__ volatile("vfmadd213sd %2,%1,%0" : "+x"(b) : "x"(a),"x"(c));return b;}
static const uint64_t bits64[]={0x0ull,0x8000000000000000ull,0x1ull,0x8000000000000001ull,0x3ff8000000000000ull,0x7fefffffffffffffull,0x7ff0000000000000ull,0xfff0000000000000ull,0x7ff8000000000111ull,0x7ff8000000000222ull,0x7ff0000000000123ull,0xfff0000000000321ull};
static int run64(unsigned original) {
 double a[24],c[32],r[24],expect[24]; unsigned long length=sysconf(_SC_PAGESIZE);
 void *page=mmap(0,length,PROT_NONE,MAP_ANONYMOUS|MAP_PRIVATE,-1,0);
 if(page==MAP_FAILED)return 1;
 for(unsigned policy=0;policy<32;policy++) for(unsigned seed=0;seed<72;seed++) {
  unsigned ctl=(original|0x1f80)&~0xe07fU;ctl|=(policy&3)<<13 | ((policy>>2)&1)<<6 | ((policy>>3)&1)<<15 | ((policy>>4)&1);
  for(unsigned j=0;j<24;j++)memcpy(a+j,bits64+(j*7+seed+(seed^j)/5)%12,sizeof(double));
  for(unsigned j=0;j<32;j++){memcpy(c+j,bits64+(seed*5+j*3+j/3)%12,sizeof(double));memcpy(bias_64+j,bits64+(seed*11+j*5+j/3)%12,sizeof(double));}
  set(ctl);spill64(a,c,seed,r);unsigned actual=mx();set(ctl);
  for(unsigned j=0;j<24;j++)expect[j]=ref64(a[j],j%3?a[(j+7)%24]:(double)1.25,(j%2?c:bias_64)[(j+seed)&31]);
  if(actual!=mx()||memcmp(r,expect,sizeof r))return 2;
  for(unsigned j=0;j<sizeof(r);j++){hash^=((unsigned char*)r)[j];hash*=1099511628211ull;}
  double value=c[0],got;set(ctl);got=barrier64(a[0],a[1],&value);actual=mx();set(ctl);double expected=ref64(a[0],a[1],c[0]);
  if(actual!=mx()||memcmp(&value,a+1,sizeof(double))||memcmp(&got,&expected,sizeof(double)))return 3;
  checks+=25;
 }
 set(original);
 pid_t pid=fork();if(!pid){alarm(3);signal(SIGSEGV,trap);marker=0;(void)ordered64(1,1,page);_exit(5);}int st=0;
 if(pid<0||waitpid(pid,&st,0)!=pid||!WIFEXITED(st)||WEXITSTATUS(st))return 4;
 faults++;munmap(page,length);return 0;
}
int main(void){unsigned saved=mx();int rc=run32(saved);if(!rc)rc=run64(saved);if(rc)fprintf(stderr,"phase failed %d\n",rc);else printf("%u result and MXCSR comparisons, %u ordered faults, %016llx\n",checks,faults,hash);return rc;}
