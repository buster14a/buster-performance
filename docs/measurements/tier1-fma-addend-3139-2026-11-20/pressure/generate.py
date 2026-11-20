from pathlib import Path
p=Path(__file__).resolve().parent
code=['extern void barrier(void); extern volatile int marker;']
driver=['''#define _GNU_SOURCE
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
''']
for width,t,suf,u in [(32,'float','ss','uint32_t'),(64,'double','sd','uint64_t')]:
 sufnum=str(width);globalv=f'bias_{width}';code.append(f'extern {t} {globalv}[32];')
 driver.append(f'{t} {globalv}[32];')
 proto=f'void spill{width}(const volatile {t} *a,const {t} *c,unsigned i,{t} *r)'
 fault=f'{t} ordered{width}({t} a,{t} b,const {t} *c)'
 barrier=f'{t} barrier{width}({t} a,{t} b,{t} *c)'
 code+=[proto+'{',*[f'{t} v{i}=a[{i}];' for i in range(24)],'barrier();']
 for j in range(24):
  x=f'v{j}';y=f'v{(j+7)%24}' if j%3 else '1.25';y=f'({t})'+y if j%3==0 else y
  z=f'c[(i+{j})&31]' if j%2 else f'{globalv}[(i+{j})&31]'
  code.append(f'r[{j}]={x}*{y}+{z};')
 code+=['}',fault+'{ marker=7; return a*b+*c; }',barrier+'{ '+t+' old=*c; *c=b; return a*b+old;}']
 driver += [proto+';',fault+';',barrier+';',f'static __attribute__((noinline)) {t} ref{width}({t} a,{t} b,{t} c) {{__asm__ volatile("vfmadd213{suf} %2,%1,%0" : "+x"(b) : "x"(a),"x"(c));return b;}}']
 bits=([0,0x80000000,1,0x80000001,0x3fc00000,0x7f7fffff,0x7f800000,0xff800000,0x7fc00111,0x7fc00222,0x7f800123,0xff800321] if width==32 else [0,0x8000000000000000,1,0x8000000000000001,0x3ff8000000000000,0x7fefffffffffffff,0x7ff0000000000000,0xfff0000000000000,0x7ff8000000000111,0x7ff8000000000222,0x7ff0000000000123,0xfff0000000000321])
 driver.append(f'static const {u} bits{width}[]={{'+','.join(hex(i)+'ull' for i in bits)+'};')
 driver.append('''static int runW(unsigned original) {
 T a[24],c[32],r[24],expect[24]; unsigned long length=sysconf(_SC_PAGESIZE);
 void *page=mmap(0,length,PROT_NONE,MAP_ANONYMOUS|MAP_PRIVATE,-1,0);
 if(page==MAP_FAILED)return 1;
 for(unsigned policy=0;policy<32;policy++) for(unsigned seed=0;seed<72;seed++) {
  unsigned ctl=(original|0x1f80)&~0xe07fU;ctl|=(policy&3)<<13 | ((policy>>2)&1)<<6 | ((policy>>3)&1)<<15 | ((policy>>4)&1);
  for(unsigned j=0;j<24;j++)memcpy(a+j,bitsW+(j*7+seed+(seed^j)/5)%12,sizeof(T));
  for(unsigned j=0;j<32;j++){memcpy(c+j,bitsW+(seed*5+j*3+j/3)%12,sizeof(T));memcpy(bias_W+j,bitsW+(seed*11+j*5+j/3)%12,sizeof(T));}
  set(ctl);spillW(a,c,seed,r);unsigned actual=mx();set(ctl);
  for(unsigned j=0;j<24;j++)expect[j]=refW(a[j],j%3?a[(j+7)%24]:(T)1.25,(j%2?c:bias_W)[(j+seed)&31]);
  if(actual!=mx()||memcmp(r,expect,sizeof r))return 2;
  for(unsigned j=0;j<sizeof(r);j++){hash^=((unsigned char*)r)[j];hash*=1099511628211ull;}
  T value=c[0],got;set(ctl);got=barrierW(a[0],a[1],&value);actual=mx();set(ctl);T expected=refW(a[0],a[1],c[0]);
  if(actual!=mx()||memcmp(&value,a+1,sizeof(T))||memcmp(&got,&expected,sizeof(T)))return 3;
  checks+=25;
 }
 set(original);
 pid_t pid=fork();if(!pid){alarm(3);signal(SIGSEGV,trap);marker=0;(void)orderedW(1,1,page);_exit(5);}int st=0;
 if(pid<0||waitpid(pid,&st,0)!=pid||!WIFEXITED(st)||WEXITSTATUS(st))return 4;
 faults++;munmap(page,length);return 0;
}'''.replace('W',str(width)).replace(';T ',';'+t+' ').replace(' T ',' '+t+' ').replace('(T)','('+t+')').replace('sizeof T','sizeof '+t).replace('64IFEXITED','WIFEXITED').replace('32IFEXITED','WIFEXITED').replace('64EXITSTATUS','WEXITSTATUS').replace('32EXITSTATUS','WEXITSTATUS'))
driver.append('int main(void){unsigned saved=mx();int rc=run32(saved);if(!rc)rc=run64(saved);if(rc)fprintf(stderr,"phase failed %d\\n",rc);else printf("%u result and MXCSR comparisons, %u ordered faults, %016llx\\n",checks,faults,hash);return rc;}')
(p/'pressure.c').write_text('\n'.join(code)+'\n');(p/'driver.c').write_text('\n'.join(driver)+'\n')
