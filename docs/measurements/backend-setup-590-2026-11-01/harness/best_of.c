// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original harness for buster #590 / buster14a/buster#1027: each source on standard input compiled with -c by each
// compiler named, RUNS times in turn, and each compiler's per-file minimum wall time summed.
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>
// tm OUT RUNS -- COMPILER... ; reads source paths on stdin; prints per-compiler sum of per-file minimum wall ms.
static double now(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return t.tv_sec*1e3+t.tv_nsec/1e6;}
int main(int argc,char**argv)
{
    const char* out=argv[1]; int runs=atoi(argv[2]); int nc=argc-3;
    double sum[8]={0}; char path[4096]; int files=0;
    while (fgets(path,sizeof path,stdin)) {
        path[strcspn(path,"\n")]=0; files++;
        double best[8]; for(int c=0;c<nc;c++) best[c]=1e9;
        for (int r=0;r<runs;r++) for (int c=0;c<nc;c++) {
            double a=now(); pid_t p=fork();
            if(p==0){ int fd=open("/dev/null",1); dup2(fd,2); execl(argv[3+c],argv[3+c],"-c","-o",out,path,(char*)0); _exit(127); }
            int st; waitpid(p,&st,0); double b=now(); if(b-a<best[c]) best[c]=b-a;
        }
        for(int c=0;c<nc;c++) sum[c]+=best[c];
    }
    for(int c=0;c<nc;c++) printf("%s: %d files, sum of per-file minimum %.1f ms, %.3f ms per file\n", argv[3+c], files, sum[c], sum[c]/files);
    return 0;
}
