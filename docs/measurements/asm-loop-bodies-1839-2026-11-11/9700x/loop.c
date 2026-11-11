// #1839 item 4: a loop template (loop to its own label) and a jrcxz template, 50 million statements each.
#include <stdio.h>
#include <stdlib.h>
static long sum(long n){long s=0;__asm__("1:\n\taddq %%rcx, %0\n\tloop 1b":"+r"(s),"+c"(n));return s;}
static int zero(long n){int r=1;__asm__("jrcxz 1f\n\tmovl $0, %0\n1:":"+r"(r):"c"(n));return r;}
int main(int argc, char** argv){long n=argc>1?atol(argv[1]):50000000;long s=0;
 for(long i=0;i<n;i++){s+=sum((i&3)+1);s+=zero(i&1);}
 printf("%ld\n",s);return 0;}
