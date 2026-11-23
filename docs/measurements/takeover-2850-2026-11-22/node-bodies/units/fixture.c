struct P { int a; long c; char *s; };
int g; long gl; static int sg; extern int ext;
int h(int); long h2(long, long); int (*fp)(int); void v(void); int var(const char *, ...);
static int twice(int x) { return x * 2 + sg; }
int post(struct P *p, int *q) { int a = (*q)++; p->a++; return a + p->a--; }
char *walk(char *s) { while (*s++) g++; return s; }
int logic(int a, int b, int c) { return (a && b) || (c ? a : b); }
int cond(int a, int b) { int x = a > b ? a : b; return x; }
int branches(int a, int b) { if (a && !b) return 1; else if (a || b) g = 2; while (a < b && g) a++; do { b--; } while (b > 0 && a);
  for (int i = 0; i < a; i++) { if (i == 3) continue; if (i == 5) break; g += i; } return g; }
int jumps(int n) { again: if (n > 10) goto done; n += 3; goto again; done: return n; }
int calls(int a) { v(); h(a); return h(h(a) + 1) + fp(a) + (int)h2(a, 2) + var("x%d", a) + twice(a); }
int globals(int a) { g = a; gl += g; sg = g + 1; ext++; int *p = &g; return *p + sg; }
const char *strings(int k) { const char *a = "one"; return k ? a : "two"; }
int locals(int a) { int x = a; int *p = &x; int arr[4]; arr[1] = a; *p += arr[1]; return x; }
void nothing(int a) { if (a) return; g = 1; }
unsigned char narrow(int a) { unsigned char c = (unsigned char)a; c += 2; return c; }
double floats(double d, float f, int i) { double r = d * f + i; return r / 2.0; }
long widen(int a, unsigned b) { long l = a; l += b; return l << 2; }
int chosen(int k) { switch (k) { case 1: return 2; default: return 3; } }
int aligned(int c) { int x __attribute__((aligned(16))) = c; return x; }
