#include <ctype.h>
int count;
int h(void) { count++; return 'A'; }
int t_call(void) { return tolower(h()); }
int t_char(const unsigned char *s) { return toupper(*s); }
int t_const(void) { return toupper('q') + tolower('Z') * 1000; }
int t_const_out(void) { return tolower(300) + toupper(-200); }
int t_int(int c) { return tolower(c); }
long t_long(long c) { return toupper(c); }
int t_neg(signed char c) { return toupper(c) + 1000 * tolower((char)-3); }
int t_hcall(void) { return toupper((unsigned char)h()); }
