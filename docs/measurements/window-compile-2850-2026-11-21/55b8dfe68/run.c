#include <stdio.h>
int ind(int);static unsigned calls;
int ext(int n) { calls = calls*101u+(unsigned)n; return n*3-17; }
int main(void) { unsigned h=141;for(int i=-31;i<35;++i) h=57*h+(unsigned)ind(i);printf("%u %u\n",h,calls);}
