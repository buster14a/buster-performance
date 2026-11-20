#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>
void x87_add(long double*, const long double*); void x87_chain(long double*, const long double*);
void x87_order(long double*, const long double*); void x87_affine(long double*, const long double*);
void x87_literals(long double*); void x87_alias(long double*);
void x87_trap(volatile int*, long double*, const long double*);
long double x87_join(int); long double x87_call(long double);
long double x87_positive_zero(void),x87_positive_one(void),x87_negative_one(void);
long double x87_single_min(void),x87_single_max(void),x87_negative_zero(void);
long double x87_below_single_normal(void),x87_above_single_max(void),x87_extra_fraction(void);
long double x87_double_min(void),x87_double_max(void),x87_below_double_normal(void),x87_above_double_max(void),x87_beyond_double_precision(void);
volatile int marker; long double x87_pending(void);
static void pending_trapped(int s) { _exit(s==SIGFPE && marker==1 ? 0 : 92); }
static volatile sig_atomic_t trap_marker;
static long double trap_result=1.0L;
static void trapped(int number) { static const unsigned char one[10]={0,0,0,0,0,0,0,128,255,63};
const volatile unsigned char *bytes=(const volatile unsigned char*)&trap_result; unsigned changed=trap_marker!=0;
for(unsigned i=0;i<10;++i) changed|=bytes[i]!=one[i]; _exit(number==SIGFPE && !changed ? 0 : 90); }
long double x87_external(long double value) { return value * 2.0L; }
static void reference(unsigned kind, long double *out, const long double *p) {
if(kind==0) *out=p[0]+p[1]; else if(kind==1) *out=p[0]*p[1]+p[2];
else if(kind==2) *out=(p[0]-p[1])/(p[2]-p[3]); else *out=p[0]*0.5L+p[1]; }
int main(void) { alarm(10); unsigned errors=0; unsigned short saved,after;
__asm__ volatile("fnstcw %0":"=m"(saved));
static const unsigned short precision[]={0,0x200,0x300};
static const long double inputs[][4]={ {7.25L,-3.5L,0.125L,1.5L}, {0.0L,-0.0L,1.0L,2.0L},
{0x1p-16382L,0x1p-16445L,0.5L,2.0L}, {0x1.fffffffffffffffep+16383L,2.0L,1.0L,0.5L} };
void (*functions[])(long double*,const long double*)={x87_add,x87_chain,x87_order,x87_affine};
for(unsigned p=0;p<3;++p) for(unsigned r=0;r<4;++r) {
unsigned short control=(saved&~0xf00u)|0x3fu|precision[p]|(r<<10);
__asm__ volatile("fnclex; fldcw %0"::"m"(control));
for(unsigned i=0;i<4;++i) for(unsigned k=0;k<4;++k) {
long double actual,expected; unsigned short actual_flags,expected_flags;
__asm__ volatile("fnclex"); functions[k](&actual,inputs[i]);
__asm__ volatile("fnstsw %0":"=a"(actual_flags));
__asm__ volatile("fnclex"); reference(k,&expected,inputs[i]);
__asm__ volatile("fnstsw %0":"=a"(expected_flags));
errors+=memcmp(&actual,&expected,10)!=0; errors+=(actual_flags&0x3f)!=(expected_flags&0x3f);
__asm__ volatile("fnstcw %0":"=m"(after)); errors+=after!=control; }
long double (*leaves[])(void)={x87_positive_zero,x87_positive_one,x87_negative_one,x87_single_min,x87_single_max,x87_negative_zero,x87_below_single_normal,x87_above_single_max,x87_extra_fraction,
x87_double_min,x87_double_max,x87_below_double_normal,x87_above_double_max,x87_beyond_double_precision};
static const long double boundary[]={0.0L,1.0L,-1.0L,0x1p-126L,-0x1.fffffep127L,-0.0L,0x1p-127L,0x1p128L,0x1.000001p0L,
-0x1p-1022L,0x1.fffffffffffffp1023L,-0x1p-1023L,0x1p1024L,0x1.00000000000008p0L};
for(unsigned i=0;i<sizeof(leaves)/sizeof(*leaves);++i){long double got=leaves[i]();errors+=memcmp(&got,boundary+i,10)!=0;}
long double values[7]; static const long double constants[]={0.0L,-0.0L,0.5L,-1.5L,0x1.0000000000000002p+0L,0x1p-16382L,0x1p-16445L};
x87_literals(values); for(unsigned i=0;i<7;++i) errors+=memcmp(values+i,constants+i,10)!=0; }
__asm__ volatile("fnclex; fldcw %0"::"m"(saved));
errors+=x87_join(0)!=-0.5L; errors+=x87_join(1)!=0x1.0000000000000002p+0L;
errors+=x87_call(3.25L)!=7.0L; long double alias=3.25L; x87_alias(&alias); errors+=alias!=5.25L;
pid_t child=fork(); if(child==0) { alarm(5); signal(SIGFPE,trapped);
unsigned short unmasked=(saved|0x3fu)&~8u;
__asm__ volatile("fnclex; fldcw %0"::"m"(unmasked));
x87_trap(&trap_marker,&trap_result,inputs[3]); _exit(91); }
int child_status=0; if(child<0) ++errors; else {
errors+=waitpid(child,&child_status,0)!=child; errors+=!WIFEXITED(child_status)||WEXITSTATUS(child_status)!=0; }
child=fork(); if(child==0) { alarm(5); signal(SIGFPE,pending_trapped); const unsigned short cw=0x037e;
__asm__ volatile("fninit; fldz; fldz; fdivp; fldcw %0"::"m"(cw):"memory"); (void)x87_pending(); _exit(93); }
if(child<0) ++errors; else { errors+=waitpid(child,&child_status,0)!=child; errors+=!WIFEXITED(child_status)||WEXITSTATUS(child_status)!=0; }
printf("%u\n",errors); return errors!=0; }
