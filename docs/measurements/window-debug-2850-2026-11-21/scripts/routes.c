#define POS 18 + 24
#define NEG(x) -x
extern void end(void) __attribute__((noreturn));
int kept(void) { return POS; }
int neg(void) { return NEG(42); }
int min(void) { return 2147483647 - 2147483647; }
static int unused(void) { return 11; }
__attribute__((target("sse4.2"))) int feature(void) { return 8 * 5; }
int stop(void) { end(); return 1; }
int stmt(int x) { if (x) goto done; return 3 - 5; done: return 6; }
int addr(int x) { static const int n=1; return x+n; }
__attribute__((noreturn)) int bad(void) { return 4; }
int chk(int *x) { if(x != 0) return 9; if(!x) return x[0]; return 7; }
enum E { A, B }; int sel(enum E e) {switch(e) { case A: return 1; } return 2; }
int oflow(void) { return 2147483647 + 1; }
