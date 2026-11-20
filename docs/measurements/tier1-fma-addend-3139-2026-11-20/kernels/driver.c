#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#if WIDTH == 32
typedef float T;
#else
typedef double T;
#endif
enum { N=1024 };
extern void kernel(T*,const T*,const T*,const int*,unsigned,T);
extern void reference(T*,const T*,const T*,const int*,unsigned,T);
static T out[2*N],ref[2*N],x[N],bias[N];static int ints[N];
static unsigned mx(void){unsigned st;__asm__ volatile("stmxcsr %0":"=m"(st)::"memory");return st;}
int main(int ac,char**av){if(ac!=2)return 2;unsigned repeat=(unsigned)strtoul(av[1],0,10);if(!repeat)return 2;
 uint64_t r=UINT64_C(0xe946814fc224fa01);
 for(unsigned i=0;i<N;i++){r^=r<<13;r^=r>>7;r^=r<<17;ints[i]=(int)(r>>8);x[i]=(T)((int)(r%180001)-90000)*(T)0x1.00002p-15;bias[i]=(T)((int)((r>>19)%55001)-27500)*(T)0x1.020002p-11;}
 unsigned st=0x1f80;__asm__ volatile("ldmxcsr %0"::"m"(st):"memory");reference(ref,x,bias,ints,N,(T)0x1.a1112p-2);unsigned expected=mx();
 __asm__ volatile("ldmxcsr %0"::"m"(st):"memory");for(unsigned i=0;i<repeat;i++)kernel(out,x,bias,ints,N,(T)0x1.a1112p-2);
 unsigned got=mx();if(memcmp(out,ref,sizeof(out))||got!=expected){fprintf(stderr,"MXCSR %x vs %x\n",got,expected);for(unsigned j=0;j<2*N;j++)if(memcmp(out+j,ref+j,sizeof(T))){fprintf(stderr,"first mismatch %u got %a expected %a inputs %a %a\n",j,(double)out[j],(double)ref[j],(double)x[j%N],(double)bias[j%N]);break;}return 3;}
 uint64_t hash=UINT64_C(1469598103934665603);for(unsigned i=0;i<sizeof(out);i++)hash=(hash^((unsigned char*)out)[i])*UINT64_C(1099511628211);
 printf("%016" PRIx64 " %04x\n",hash,got);return 0;}
