#include <stdio.h>
int seen;int mark(int n){seen=seen*10+n;return n;}
int tested(int n){seen=0;double x=n<0?__builtin_nan(""):n==0?0.0:n==1?__builtin_inf():n==2?0x1p-1074:(double)n;
int r=__builtin_fpclassify(mark(1),mark(2),mark(3),mark(4),mark(5),x);return seen*10+r;}
int main(void){for(int n=-1;n<=3;n++)printf("n=%d %d\n",n,tested(n));return 0;}
