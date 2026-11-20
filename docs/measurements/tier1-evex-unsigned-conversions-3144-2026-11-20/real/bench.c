#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <xmmintrin.h>
#include "benchfn.h"
#include "timefn.h"
static PTime span;static unsigned elapsed;
UTIL_time_t __wrap_UTIL_getTime(void){return (UTIL_time_t){17};}
PTime __wrap_UTIL_clockSpanNano(UTIL_time_t start){if(start.t!=17)abort();elapsed++;return span;}
static size_t inner(const void*s,size_t x,void*d,size_t n,void*p){(void)s;(void)d;(void)n;(void)p;return x;}
static uint64_t rnd(uint64_t x){x^=x>>30;x*=0xbf58476d1ce4e5b9ULL;x^=x>>27;x*=0x94d049bb133111ebULL;return x^(x>>31);}
int main(int argc,char**argv){
 unsigned init=_mm_getcsr(),t=argc>1?(unsigned)strtoul(argv[1],0,10):0;uint64_t h=0;unsigned checks=0;
 char src=1,dst=0;const void* sources[]={&src};void* outputs[]={&dst};size_t sizes[]={7},cap[]={1};size_t results[]={0};
 for(unsigned i=0;i<(t?200000u:8192u);i++){
  unsigned l=t?1:(i%12);span=(i&1)?rnd(i+72):((1ULL<<(i%64))+(i%7)-3);
  BMK_benchParams_t p={0};p.benchFn=inner;p.blockCount=t?0:(i>>2)&1u;p.srcBuffers=sources;p.srcSizes=sizes;p.dstBuffers=outputs;p.dstCapacities=cap;p.blockResults=results;
  unsigned mx=0x1f80|(t?0:(i%4)<<13);_mm_setcsr(mx);volatile PTime x=span;volatile unsigned loops=l?l:1;double expected=(double)x/loops;unsigned ef=_mm_getcsr();
  _mm_setcsr(mx);unsigned before=elapsed;BMK_runOutcome_t o=BMK_benchFunction(p,l);if(!BMK_isSuccessful_runOutcome(o))return 2;BMK_runTime_t rt=BMK_extract_runTime(o);unsigned af=_mm_getcsr();
  if(elapsed!=before+1||memcmp(&rt.nanoSecPerRun,&expected,8)||ef!=af||rt.sumOfReturn!=(p.blockCount?7:0))return 3;
  uint64_t b;memcpy(&b,&rt.nanoSecPerRun,8);h=(h^b)*1099511628211ULL;checks++;
 }
 _mm_setcsr(init);printf("%u %016llx\n",checks,(unsigned long long)h);return 0;
}
