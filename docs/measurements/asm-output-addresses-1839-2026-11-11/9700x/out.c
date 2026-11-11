// #1839 item 7: asm bodies' register outputs, whose addresses go through the operand block.
#include <stdio.h>
#include <stdlib.h>
static int add(int a, int b){int r;__asm__("leal (%q1,%q2), %0":"=r"(r):"r"(a),"r"(b));return r;}
static void two(int a, int* lo, int* hi){__asm__("movl %2, %0\n\tnotl %0\n\tmovl %2, %1\n\tnegl %1":"=r"(*lo),"=r"(*hi):"r"(a));}
int main(int argc, char** argv){long n=argc>1?atol(argv[1]):200000000;long s=0;int lo,hi;
 for(long i=0;i<n;i++){s+=add((int)i,3);two((int)i,&lo,&hi);s+=lo^hi;}
 printf("%ld\n",s);return 0;}
