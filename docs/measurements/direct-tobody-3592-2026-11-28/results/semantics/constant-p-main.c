#include <stdio.h>
extern int count; int t_bcp(void); int t_inc(int *p);
int main(void) { int r = t_bcp(); int a[2] = {1, 2}; int s = t_inc(a); printf("%d count=%d %d\n", r, count, s); return 0; }
