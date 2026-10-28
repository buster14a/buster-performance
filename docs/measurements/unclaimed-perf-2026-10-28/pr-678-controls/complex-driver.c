#include <stdio.h>
#include <fenv.h>
#include <errno.h>
#include <xmmintrin.h>
#include <signal.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdarg.h>
int tested(int); int oracle_tested(int);
void terminal_probe(void) __attribute__((weak));
int external_data=17; int external_helper(int n){return n*3;}
int external_apply(int(*function)(int),int n){return function(n);}
int change_rounding(int n){const int modes[]={FE_TONEAREST,FE_TOWARDZERO,FE_UPWARD,FE_DOWNWARD};return fesetround(modes[(unsigned)n&3]);}
int clear_fp(void){return feclearexcept(FE_ALL_EXCEPT);}
int fp_state(void){int f=fetestexcept(FE_ALL_EXCEPT);return !!(f&FE_INVALID)+2*!!(f&FE_DIVBYZERO)+4*!!(f&FE_OVERFLOW)+8*!!(f&FE_UNDERFLOW)+16*!!(f&FE_INEXACT);}
int change_daz(int n){struct {unsigned char b[512];} __attribute__((aligned(16))) s;__asm__ volatile("fxsave %0":"=m"(s));unsigned mask;__builtin_memcpy(&mask,s.b+28,4);unsigned old=_mm_getcsr();if(mask&64u)_mm_setcsr((old&~64u)|((unsigned)n&1u)*64u);return (old>>6)&1;}
double fp_special(int n){const unsigned long b[]={0,0x8000000000000000UL,0x7ff0000000000000UL,0xfff0000000000000UL,0x7ff8000000000001UL,0x7ff0000000000001UL,1,0x8000000000000001UL,0x3ff8000000000000UL};union{unsigned long bits;double value;}x={b[(unsigned)n%9]};return x.value;}
float fp_specialf(int n){const unsigned b[]={0,0x80000000u,0x7f800000u,0xff800000u,0x7fc00001u,0x7f800001u,1,0x80000001u,0x3fc00000u};union{unsigned bits;float value;}x={b[(unsigned)n%9]};return x.value;}
unsigned long fp_bits(double d){union{double d;unsigned long u;}x={d};return x.u;}
unsigned fp_bitsf(float f){union{float f;unsigned u;}x={f};return x.u;}
int set_math_errno(int n){errno=n;return 0;}int get_math_errno(void){return errno;}
union external_wide{long double x;char c[40];};union external_wide external_wide(int n){union external_wide w;for(int i=0;i<40;i++)w.c[i]=(char)(n+i);if((unsigned long)&w%16)w.c[0]=99;return w;}
struct external_aligned{_Alignas(32) long a;int b;};int external_aligned_by_value(int k,struct external_aligned x,struct external_aligned y){return (int)(x.a+x.b+y.a*3+y.b)+k+(int)((((unsigned long)&x)|((unsigned long)&y))&31)*1000;}
struct external_cx{_Complex long double z;};struct external_cx external_complex(long double a,long double b){struct external_cx c;__real__ c.z=a;__imag__ c.z=b;return c;}long double external_complex_apply(struct external_cx(*f)(long double,long double),long double a){struct external_cx c=f(a,-a);return __real__ c.z*4+__imag__ c.z;}
static unsigned long external_fold(unsigned long h,unsigned long v){return (h^v)*1099511628211UL;}
unsigned long external_variadic(int n,...){va_list a;va_start(a,n);unsigned long h=(unsigned long)n;for(int i=0;i<20;i++){long l=va_arg(a,long);double d=va_arg(a,double);unsigned long b;__builtin_memcpy(&b,&d,8);h=external_fold(external_fold(h,(unsigned long)l),b);}va_end(a);return h;}
unsigned long external_floats(int n,float f0,float f1,float f2,float f3,float f4,float f5,float f6,float f7,float f8,float f9,int m,...){const float f[10]={f0,f1,f2,f3,f4,f5,f6,f7,f8,f9};va_list a;va_start(a,m);unsigned long h=(unsigned long)n*31+(unsigned long)m;for(int i=0;i<10;i++){unsigned b;__builtin_memcpy(&b,&f[i],4);h=external_fold(h,b);}for(int i=0;i<10;i++){long l=va_arg(a,long);double d=va_arg(a,double);unsigned long b;__builtin_memcpy(&b,&d,8);h=external_fold(external_fold(h,(unsigned long)l),b);}va_end(a);return h;}
int main(void) { for (int repeat=0;repeat<3;repeat++) for (int n=-3;n<=19;n++) {
int a=tested(n), b=oracle_tested(n); if(a!=b) { fprintf(stderr,"n=%d repeat=%d ours=%d oracle=%d\n",n,repeat,a,b); return 1; } }
if(terminal_probe){int p=fork();if(p<0)return 2;if(!p){struct rlimit r={0,0};setrlimit(RLIMIT_CORE,&r);terminal_probe();_exit(91);}
int s=0;if(waitpid(p,&s,0)!=p||!WIFSIGNALED(s)||WTERMSIG(s)!=SIGILL)return 3;}return 0;}
