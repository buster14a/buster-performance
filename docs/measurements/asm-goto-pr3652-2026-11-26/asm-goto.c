// asm goto kernel (#1839 item 2): a sign test branching to C labels, and a compare with an output reaching a label.
#include <stdio.h>
#include <stdlib.h>
static int sign(int x){asm goto("testl %0, %0\n\tjz %l1\n\tjs %l[neg]" :: "r"(x) :: zero, neg); return 1; zero: return 0; neg: return -1;}
static int hit(int x, int* o){int r=x*2; asm goto("cmpl $5, %1\n\tje %l[five]\n\tincl %0" : "+r"(r) : "r"(x) :: five); *o=r; return 0; five: *o=r; return 5;}
int main(int argc, char** argv){long n=argc>1?atol(argv[1]):200000000;long s=0;int o=0;
 for(long i=0;i<n;i++){s+=sign((int)(i%7)-3);s+=hit((int)(i&7),&o);s+=o;}
 printf("%ld\n",s);return 0;}
