#define _GNU_SOURCE
#include <fenv.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <unistd.h>
#include <xmmintrin.h>
typedef uint32_t Word;
struct __attribute__((packed)) PackedWord {unsigned char prefix;Word value;};
#define DECL(T,S) extern T indexed_##S(Word*,int,Word),alias_##S(Word*,int,Word),call_##S(Word*,int,Word),volatile_##S(Word*,int,Word),atomic_##S(Word*,int,Word),guarded_##S(Word*,int,Word),packed_##S(struct PackedWord*);
DECL(float,f)
DECL(double,d)
void write_word(Word *p, Word k) {*p=k;}
static uint64_t vec(unsigned k,int d,Word *p,int i,Word replacement) {
#define SAME(N) case N:if(d){double t=fn_d[N](p,i,replacement);uint64_t u;memcpy(&u,&t,8);return u;}else{float t=fn_f[N](p,i,replacement);Word u;memcpy(&u,&t,4);return u;}
    static float (*const fn_f[])(Word*,int,Word)={indexed_f,alias_f,call_f,volatile_f,atomic_f,guarded_f};
    static double (*const fn_d[])(Word*,int,Word)={indexed_d,alias_d,call_d,volatile_d,atomic_d,guarded_d};
    switch(k){SAME(0) SAME(1) SAME(2) SAME(3) SAME(4) SAME(5) default:abort();}
}
static uint64_t expected(Word x,int d,unsigned mode,int *ie) {
    if(x==0) return 0;
    unsigned log=31-(unsigned)__builtin_clz(x),mant=d?52:23,bias=d?1023:127;uint64_t val;
    if(log<=mant){val=(uint64_t)x<<(mant-log);}
    else{unsigned cut=log-mant;val=x>>cut;Word rem=x&((1u<<cut)-1),half=1u<<(cut-1);*ie=rem!=0;
        if(rem && (mode==2 || (mode==0 && (rem>half || (rem==half && (val&1)))))){val++;if(val==(2ull<<mant)){val>>=1;log++;}}}
    return ((uint64_t)(bias+log)<<mant)|(val&((1ull<<mant)-1));
}
static int traps(Word *p,int fault,int wide) {
    pid_t c=fork();if(c<0) return -1;
    if(c==0){_mm_setcsr(0x1f80u & ~(1u<<12));volatile Word one=1;
        if(wide){volatile double x=guarded_d(p,one,0);(void)x;}else{volatile float x=guarded_f(p,one,0);(void)x;}
        _exit(0);}
    int st;if(waitpid(c,&st,0)!=c)return -1;return fault? WIFSIGNALED(st) && WTERMSIG(st)==fault : WIFEXITED(st)&&WEXITSTATUS(st)==0;
}
int main(void) {
    struct rlimit no_core={0,0};setrlimit(RLIMIT_CORE,&no_core);long n=sysconf(_SC_PAGESIZE);unsigned char *mem=mmap(NULL,n*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(mem==MAP_FAILED||mprotect(mem+n,n,PROT_READ|PROT_WRITE))return 1;
    Word *first=(Word*)(mem+n),*last=(Word*)(mem+2*n)-1;Word seed=19;uint64_t checks=0;
    for(unsigned j=0;j<4096;j++){
        seed=seed*1664525u+1013904223u;Word x=j<64?(1u<<(j/2))+(j&1):seed,alt=~x;
        for(unsigned m=0;m<4;m++)for(int d=0;d!=2;d++){
            int ie=0;uint64_t answer=expected(x,d,m,&ie);unsigned initial=0x1f80+(m<<13)+(j&1?1:0);Word *at=(j&1)?first+3:last;
            for(unsigned k=0;k<7;k++){
                *at=x;_mm_setcsr(initial);uint64_t got=0;
                if(k==6){struct PackedWord *s=(void*)((unsigned char*)at-1);if(d){double t=packed_d(s);memcpy(&got,&t,8);}else{float t=packed_f(s);Word b;memcpy(&b,&t,4);got=b;}}
                else if(k==0)got=vec(k,d,at-3,6,alt);
                else if(k==5)got=vec(k,d,at,1,alt);
                else got=vec(k,d,at,0,alt);
                unsigned flags=_mm_getcsr()&63;if(got!=answer || flags!=((initial&63)|(ie?32:0))||*at!=(k>=1&&k<=4?alt:x)){fprintf(stderr,"case %u width %d mode %u x %x flags %u\n",k,d,m,x,flags);return 2;}checks++;
            }
            _mm_setcsr(initial);if(vec(5,d,(Word*)(mem+2*n),0,x)!=answer)return 3;checks++;
        }
    }
    _mm_setcsr(0x1f80);*last=0x01000001;
    if(traps(last,SIGFPE,0)!=1||traps(last,0,1)!=1||traps((Word*)(mem+2*n),SIGSEGV,0)!=1||traps((Word*)(mem+2*n),SIGSEGV,1)!=1)return 4;
    printf("%llu ordered memory, guarded branch, value and MXCSR checks; 4 real fault outcomes\n",(unsigned long long)checks);return 0;
}
