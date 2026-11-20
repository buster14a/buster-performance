#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/sysinfo.h>
#include <xmmintrin.h>
extern int getloadavg(double*,int);
static unsigned long sample[3];static unsigned calls;
int __wrap_sysinfo(struct sysinfo *s){++calls;memset(s,0,sizeof(*s));memcpy(s->loads,sample,sizeof(sample));return 0;}
static uint64_t rnd(uint64_t x){x^=x>>30;x*=0xbf58476d1ce4e5b9ULL;x^=x>>27;x*=0x94d049bb133111ebULL;return x^(x>>31);}
int main(int argc,char**argv){
 unsigned initial=_mm_getcsr(),t=argc>1?(unsigned)strtoul(argv[1],0,10):0;uint64_t hash=0;unsigned checks=0;
 for(unsigned i=0;i<(t?200000u:4096u);i++){
  for(unsigned j=0;j<3;j++)sample[j]=rnd(i+3*j+3);
  int n=t?3:(int)(i%8)-2;
  unsigned mx=0x1f80|(t?0:(i%4)<<13);double a[4]={-1,-2,-3,-4},expected[4]={-1,-2,-3,-4};
  _mm_setcsr(mx);for(int j=0;j<n&&j<3;j++)expected[j]=(double)sample[j]/65536.;unsigned ef=_mm_getcsr();
  _mm_setcsr(mx);unsigned old=calls;int r=getloadavg(a,n);unsigned af=_mm_getcsr();
  if(r!=(n<0?-1:n>3?3:n)||calls-old!=(n>0)||ef!=af||memcmp(a,expected,sizeof(a))){fprintf(stderr,"i=%u n=%d ret=%d calls=%u/%u flags=%x/%x got=%a,%a,%a want=%a,%a,%a\n",i,n,r,calls,old,af,ef,a[0],a[1],a[2],expected[0],expected[1],expected[2]);return 2;}
  uint64_t b;memcpy(&b,a+i%3,8);hash=(hash^b)*1099511628211ULL;checks++;
 }
 _mm_setcsr(initial);printf("%u %016llx\n",checks,(unsigned long long)hash);return 0;
}
