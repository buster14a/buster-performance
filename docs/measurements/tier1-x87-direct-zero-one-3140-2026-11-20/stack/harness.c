#define _GNU_SOURCE
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
typedef long double (*leaf)(void);
#define DECL(name) extern long double x87_##name(void), ref_##name(void)
DECL(positive_zero); DECL(positive_one); DECL(negative_zero); DECL(negative_one);
extern void snapshot(leaf f, int depth, unsigned cw, unsigned char *fx, unsigned sticky);
volatile int marker;
static void trapped(int sig, siginfo_t *info, void *uc) {
    (void)uc; _exit(sig == SIGFPE && info->si_code == FPE_FLTINV && marker == 9 ? 0 : 31);
}
static int trap_case(leaf f, int pending) {
    pid_t child=fork();
    if (child<0) return 0;
    if (!child) {
        struct sigaction action={.sa_sigaction=trapped,.sa_flags=SA_SIGINFO};
        sigemptyset(&action.sa_mask); sigaction(SIGFPE,&action,0); alarm(3); marker=0;
        unsigned short cw=0x037e;
        if(pending) {
            __asm__ volatile("fninit; fldz; fldz; fdivp; fldcw %0"::"m"(cw):"memory");
            (void)f(); __asm__ volatile("fwait");
        } else {
            _Alignas(16) unsigned char a[512]; snapshot(f,8,cw,a,0);
        }
        _exit(32);
    }
    int st=0;return waitpid(child,&st,0)==child && WIFEXITED(st) && WEXITSTATUS(st)==0;
}
int main(void) {
    leaf target[]={x87_positive_zero,x87_positive_one,x87_negative_zero,x87_negative_one};
    leaf reference[]={ref_positive_zero,ref_positive_one,ref_negative_zero,ref_negative_one};
    unsigned precision[]={0,2,3}, cases=0, traps=0;
    for(unsigned l=0;l<4;l++) {
        for(unsigned pc=0;pc<3;pc++) for(unsigned rc=0;rc<4;rc++) for(unsigned depth=0;depth<=8;depth++) for(unsigned sticky=0;sticky<2;sticky++) {
            _Alignas(16) unsigned char a[512]={0}, b[512]={0};
            unsigned cw=0x7f | precision[pc]<<8 | rc<<10;
            marker=0; snapshot(target[l],depth,cw,a,sticky); if(marker!=9) return 2;
            marker=0; snapshot(reference[l],depth,cw,b,sticky); if(marker!=9||memcmp(a,b,5)!=0) return 3;
            unsigned top=(a[3]>>3)&7, slots=depth==8?8:depth+1;
            if(__builtin_popcount((unsigned)a[4])!=slots || (a[0]|a[1]<<8)!=cw) return 4;
            if(depth==8 && ((a[2]&0x41)!=0x41 || (a[3]&2)==0)) return 5;
            for(unsigned i=0;i<8;i++) if((a[4]>>((top+i)&7))&1)
                if(memcmp(a+32+16*i,b+32+16*i,10)) return 6;
            cases++;
        }
        for(int pending=0;pending<2;pending++) {
            if(!trap_case(target[l],pending)||!trap_case(reference[l],pending)) return 7;
            traps+=2;
        }
    }
    printf("%u stack observations, %u observed signal deliveries\n",cases,traps);return 0;
}
