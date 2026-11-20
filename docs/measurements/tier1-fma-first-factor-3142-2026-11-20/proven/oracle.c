#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#pragma STDC FENV_ACCESS ON
static uint64_t hash=UINT64_C(1469598103934665603),checks;
static const uint32_t words_f[]={0x0ULL,0x80000000ULL,0x1ULL,0x80000001ULL,0x3fa00000ULL,0xbfa00000ULL,0x7f800000ULL,0xff800000ULL,0x7fc00321ULL,0x7fc006caULL,0xffc00321ULL,0x7f800321ULL,0xff800321ULL,0x7f7fffffULL,0x800000ULL,0x3fa00001ULL};
extern float one_left_f(float,unsigned long long,const float*,unsigned long);
extern float one_right_f(float,unsigned long long,const float*,unsigned long);
extern float minuszero_left_f(float,unsigned long long,const float*,unsigned long);
extern float minuszero_right_f(float,unsigned long long,const float*,unsigned long);
extern float infinity_left_f(float,unsigned long long,const float*,unsigned long);
extern float infinity_right_f(float,unsigned long long,const float*,unsigned long);
extern float qnan_left_f(float,unsigned long long,const float*,unsigned long);
extern float qnan_right_f(float,unsigned long long,const float*,unsigned long);
extern float snan_left_f(float,unsigned long long,const float*,unsigned long);
extern float snan_right_f(float,unsigned long long,const float*,unsigned long);
extern float neginf_left_f(float,unsigned long long,const float*,unsigned long);
extern float neginf_right_f(float,unsigned long long,const float*,unsigned long);
extern float int32_left_f(float,unsigned long long,const float*,unsigned long);
extern float int32_right_f(float,unsigned long long,const float*,unsigned long);
extern float uint32_left_f(float,unsigned long long,const float*,unsigned long);
extern float uint32_right_f(float,unsigned long long,const float*,unsigned long);
extern float int64_left_f(float,unsigned long long,const float*,unsigned long);
extern float int64_right_f(float,unsigned long long,const float*,unsigned long);
extern float uint64_left_f(float,unsigned long long,const float*,unsigned long);
extern float uint64_right_f(float,unsigned long long,const float*,unsigned long);
extern float square_left_f(float,unsigned long long,const float*,unsigned long);
extern float square_right_f(float,unsigned long long,const float*,unsigned long);
static float (*const functions_f[])(float,unsigned long long,const float*,unsigned long)={one_left_f,one_right_f,minuszero_left_f,minuszero_right_f,infinity_left_f,infinity_right_f,qnan_left_f,qnan_right_f,snan_left_f,snan_right_f,neginf_left_f,neginf_right_f,int32_left_f,int32_right_f,uint32_left_f,uint32_right_f,int64_left_f,int64_right_f,uint64_left_f,uint64_right_f,square_left_f,square_right_f};

static const uint64_t words_d[]={0x0ULL,0x8000000000000000ULL,0x1ULL,0x8000000000000001ULL,0x3ff4000000000000ULL,0xbff4000000000000ULL,0x7ff0000000000000ULL,0xfff0000000000000ULL,0x7ff8000000000321ULL,0x7ff80000000006caULL,0xfff8000000000321ULL,0x7ff0000000000321ULL,0xfff0000000000321ULL,0x7fefffffffffffffULL,0x10000000000000ULL,0x3ff4000000000001ULL};
extern double one_left_d(double,unsigned long long,const double*,unsigned long);
extern double one_right_d(double,unsigned long long,const double*,unsigned long);
extern double minuszero_left_d(double,unsigned long long,const double*,unsigned long);
extern double minuszero_right_d(double,unsigned long long,const double*,unsigned long);
extern double infinity_left_d(double,unsigned long long,const double*,unsigned long);
extern double infinity_right_d(double,unsigned long long,const double*,unsigned long);
extern double qnan_left_d(double,unsigned long long,const double*,unsigned long);
extern double qnan_right_d(double,unsigned long long,const double*,unsigned long);
extern double snan_left_d(double,unsigned long long,const double*,unsigned long);
extern double snan_right_d(double,unsigned long long,const double*,unsigned long);
extern double neginf_left_d(double,unsigned long long,const double*,unsigned long);
extern double neginf_right_d(double,unsigned long long,const double*,unsigned long);
extern double int32_left_d(double,unsigned long long,const double*,unsigned long);
extern double int32_right_d(double,unsigned long long,const double*,unsigned long);
extern double uint32_left_d(double,unsigned long long,const double*,unsigned long);
extern double uint32_right_d(double,unsigned long long,const double*,unsigned long);
extern double int64_left_d(double,unsigned long long,const double*,unsigned long);
extern double int64_right_d(double,unsigned long long,const double*,unsigned long);
extern double uint64_left_d(double,unsigned long long,const double*,unsigned long);
extern double uint64_right_d(double,unsigned long long,const double*,unsigned long);
extern double square_left_d(double,unsigned long long,const double*,unsigned long);
extern double square_right_d(double,unsigned long long,const double*,unsigned long);
static double (*const functions_d[])(double,unsigned long long,const double*,unsigned long)={one_left_d,one_right_d,minuszero_left_d,minuszero_right_d,infinity_left_d,infinity_right_d,qnan_left_d,qnan_right_d,snan_left_d,snan_right_d,neginf_left_d,neginf_right_d,int32_left_d,int32_right_d,uint32_left_d,uint32_right_d,int64_left_d,int64_right_d,uint64_left_d,uint64_right_d,square_left_d,square_right_d};

static int check_f(void *last) {
 volatile unsigned long long integers[]={0,1,0x7fffffff,0x80000001,0x1000001,0x1fffffffffffffULL,0x8000000000000001ULL,~0ULL};
 for(unsigned mode=0;mode<4;mode++)for(unsigned flush=0;flush<4;flush++)for(unsigned sticky=0;sticky<2;sticky++)for(unsigned i=0;i<16;i++)for(unsigned j=0;j<16;j++)for(unsigned n=0;n<22;n++) {
  float x,c,k=0,reference,got;uint32_t xb=words_f[i],cb=words_f[j];memcpy(&x,&xb,sizeof(x));memcpy(&c,&cb,sizeof(c));memcpy(last,&c,sizeof(c));
  unsigned long long u=integers[(i+3*j)%8];unsigned init=0x1f80|(mode<<13)|((flush&1)?0x40:0)|((flush&2)?0x8000:0)|(sticky?5:0);
  unsigned status,expected;__asm__ volatile("ldmxcsr %0"::"m"(init):"memory");
  switch(n){case 0:{uint32_t bits=0x3fa00000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 1:{uint32_t bits=0x3fa00000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 2:{uint32_t bits=0x80000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 3:{uint32_t bits=0x80000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 4:{uint32_t bits=0x7f800000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 5:{uint32_t bits=0x7f800000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 6:{uint32_t bits=0x7fc00321ULL;memcpy(&k,&bits,sizeof(k)); break;}case 7:{uint32_t bits=0x7fc00321ULL;memcpy(&k,&bits,sizeof(k)); break;}case 8:{uint32_t bits=0x7f800321ULL;memcpy(&k,&bits,sizeof(k)); break;}case 9:{uint32_t bits=0x7f800321ULL;memcpy(&k,&bits,sizeof(k)); break;}case 10:{uint32_t bits=0xff800000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 11:{uint32_t bits=0xff800000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 12:{k=(float)(int)u; break;}case 13:{k=(float)(int)u; break;}case 14:{k=(float)(unsigned int)u; break;}case 15:{k=(float)(unsigned int)u; break;}case 16:{k=(float)(long long)u; break;}case 17:{k=(float)(long long)u; break;}case 18:{k=(float)(unsigned long long)u; break;}case 19:{k=(float)(unsigned long long)u; break;}case 20:{k=x; break;}case 21:{k=x; break;}}
  float a=n%2?k:c,b=n%2?c:k;__asm__ volatile("vfmadd213ss %2,%1,%0" : "+x"(b) : "x"(a),"x"(x) : "memory");reference=b;
  __asm__ volatile("stmxcsr %0":"=m"(expected)::"memory");__asm__ volatile("ldmxcsr %0"::"m"(init):"memory");
  got=functions_f[n](x,u,((float*)last)-3,2);__asm__ volatile("stmxcsr %0":"=m"(status)::"memory");
  if(memcmp(&reference,&got,sizeof(got))||status!=expected){fprintf(stderr,"f n=%u i=%u j=%u mode=%u flush=%u sticky=%u flags=%x/%x\n",n,i,j,mode,flush,sticky,status,expected);return 1;}
  unsigned long long raw=0;memcpy(&raw,&got,sizeof(got));hash=(hash^raw^status)*UINT64_C(1099511628211);checks++;
 }return 0;
}
static int check_d(void *last) {
 volatile unsigned long long integers[]={0,1,0x7fffffff,0x80000001,0x1000001,0x1fffffffffffffULL,0x8000000000000001ULL,~0ULL};
 for(unsigned mode=0;mode<4;mode++)for(unsigned flush=0;flush<4;flush++)for(unsigned sticky=0;sticky<2;sticky++)for(unsigned i=0;i<16;i++)for(unsigned j=0;j<16;j++)for(unsigned n=0;n<22;n++) {
  double x,c,k=0,reference,got;uint64_t xb=words_d[i],cb=words_d[j];memcpy(&x,&xb,sizeof(x));memcpy(&c,&cb,sizeof(c));memcpy(last,&c,sizeof(c));
  unsigned long long u=integers[(i+3*j)%8];unsigned init=0x1f80|(mode<<13)|((flush&1)?0x40:0)|((flush&2)?0x8000:0)|(sticky?5:0);
  unsigned status,expected;__asm__ volatile("ldmxcsr %0"::"m"(init):"memory");
  switch(n){case 0:{uint64_t bits=0x3ff4000000000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 1:{uint64_t bits=0x3ff4000000000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 2:{uint64_t bits=0x8000000000000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 3:{uint64_t bits=0x8000000000000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 4:{uint64_t bits=0x7ff0000000000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 5:{uint64_t bits=0x7ff0000000000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 6:{uint64_t bits=0x7ff8000000000321ULL;memcpy(&k,&bits,sizeof(k)); break;}case 7:{uint64_t bits=0x7ff8000000000321ULL;memcpy(&k,&bits,sizeof(k)); break;}case 8:{uint64_t bits=0x7ff0000000000321ULL;memcpy(&k,&bits,sizeof(k)); break;}case 9:{uint64_t bits=0x7ff0000000000321ULL;memcpy(&k,&bits,sizeof(k)); break;}case 10:{uint64_t bits=0xfff0000000000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 11:{uint64_t bits=0xfff0000000000000ULL;memcpy(&k,&bits,sizeof(k)); break;}case 12:{k=(double)(int)u; break;}case 13:{k=(double)(int)u; break;}case 14:{k=(double)(unsigned int)u; break;}case 15:{k=(double)(unsigned int)u; break;}case 16:{k=(double)(long long)u; break;}case 17:{k=(double)(long long)u; break;}case 18:{k=(double)(unsigned long long)u; break;}case 19:{k=(double)(unsigned long long)u; break;}case 20:{k=x; break;}case 21:{k=x; break;}}
  double a=n%2?k:c,b=n%2?c:k;__asm__ volatile("vfmadd213sd %2,%1,%0" : "+x"(b) : "x"(a),"x"(x) : "memory");reference=b;
  __asm__ volatile("stmxcsr %0":"=m"(expected)::"memory");__asm__ volatile("ldmxcsr %0"::"m"(init):"memory");
  got=functions_d[n](x,u,((double*)last)-3,2);__asm__ volatile("stmxcsr %0":"=m"(status)::"memory");
  if(memcmp(&reference,&got,sizeof(got))||status!=expected){fprintf(stderr,"d n=%u i=%u j=%u mode=%u flush=%u sticky=%u flags=%x/%x\n",n,i,j,mode,flush,sticky,status,expected);return 1;}
  unsigned long long raw=0;memcpy(&raw,&got,sizeof(got));hash=(hash^raw^status)*UINT64_C(1099511628211);checks++;
 }return 0;
}
int main(void){
 size_t pg=(size_t)sysconf(_SC_PAGESIZE);char*b=mmap(NULL,2*pg,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
 if(b==MAP_FAILED||mprotect(b+pg,pg,PROT_NONE))return 2;
 if(check_f(b+pg-4)||check_d(b+pg-8))return 1;
 printf("%llu hardware value and raw MXCSR checks %016llx\n",(unsigned long long)checks,(unsigned long long)hash);return 0;
}
