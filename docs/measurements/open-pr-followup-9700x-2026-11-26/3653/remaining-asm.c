// Hot inline-asm kernels for #1839: each loop's asm statement is one the helper design called and an asm body places
// in its caller. The result is printed so that every build's output can be compared.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static unsigned long stamp(void){unsigned lo,hi;__asm__ volatile("rdtsc":"=a"(lo),"=d"(hi));return ((unsigned long)hi<<32)|lo;}
static unsigned long k_rdtsc(long n){unsigned long s=0,p=stamp();for(long i=0;i<n;i++){unsigned long t=stamp();s+=(t>=p);p=t;}return s;}
static unsigned long k_cpuid(long n){unsigned long s=0;for(long i=0;i<n;i++){unsigned a,b,c,d;__asm__ volatile("cpuid":"=a"(a),"=b"(b),"=c"(c),"=d"(d):"0"(0u),"2"(0u));s+=b^c^d;}return s;}
static unsigned long k_flags(long n){unsigned long s=0;for(long i=0;i<n;i++){int z;__asm__("testl %1,%1":"=@ccz"(z):"r"((int)(i&255)));s+=z;}return s;}
static unsigned long k_shift(long n){unsigned long s=0;for(long i=0;i<n;i++){unsigned x=(unsigned)i;__asm__("roll %%cl,%0":"+r"(x):"c"((int)(i&31)));s+=x;}return s;}
static unsigned long k_x87(long n){long double s=0;for(long i=0;i<n;i++){long double x=(long double)(i&1023);__asm__("fsqrt":"+t"(x));s+=x;}return (unsigned long)s;}
static unsigned long k_mul(long n){unsigned long s=0;for(long i=0;i<n;i++){unsigned long lo,hi;__asm__("mulq %3":"=a"(lo),"=d"(hi):"0"((unsigned long)i),"r"(0x9e3779b97f4a7c15ul));s+=lo^hi;}return s;}
int main(int argc,char**argv){
  const char* k=argc>1?argv[1]:"flags"; long n=argc>2?atol(argv[2]):100000000;
  unsigned long r=!strcmp(k,"rdtsc")?k_rdtsc(n):!strcmp(k,"cpuid")?k_cpuid(n):!strcmp(k,"flags")?k_flags(n):!strcmp(k,"shift")?k_shift(n):!strcmp(k,"x87")?k_x87(n):k_mul(n);
  printf("%s %lu\n",k,strcmp(k,"rdtsc")&&strcmp(k,"cpuid")?r:1ul);return 0;}
