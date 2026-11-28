#include <stdio.h>
extern int count;
int t_call(void); int t_char(const unsigned char *s); int t_const(void); int t_const_out(void); int t_int(int c); long t_long(long c); int t_neg(signed char c); int t_hcall(void);
int main(void) {
  const unsigned char us[] = "x";
  int r1 = t_call(); int c1 = count; int r2 = t_hcall(); int c2 = count;
  printf("%d count=%d %d count=%d %d %d %d %d %ld %d %d\n", r1, c1, r2, c2, t_char(us), t_const(), t_const_out(), t_int(-1), t_long(97), t_neg((signed char)-5), t_neg('m'));
  return 0; }
