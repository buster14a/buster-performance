struct P { int a; long c; char *s; double d; float f; unsigned char b; short h; unsigned u; };
int g; long gl; static int sg; extern int ext; double gd; float gf; char gc; unsigned char guc; short gs;
int h(int); long h2(long, long); int (*fp)(int); void v(void); int var(const char *, ...); double dh(double); float fh(float);
static int twice(int x) { return x * 2 + sg; }
int post(struct P *p, int *q) { int a = (*q)++; p->a++; return a + p->a--; }
char *walk(char *s) { while (*s++) g++; return s; }
int logic(int a, int b, int c) { return (a && b) || (c ? a : b); }
int branches(int a, int b) { if (a && !b) return 1; else if (a || b) g = 2; while (a < b && g) a++; do { b--; } while (b > 0 && a); for (int i = 0; i < a; i++) { if (i == 3) continue; if (i == 5) break; g += i; } return g; }
int calls(int a) { v(); h(a); return h(h(a) + 1) + fp(a) + (int)h2(a, 2) + var("x%d", a) + twice(a); }
int globals(int a) { g = a; gl += g; sg = g + 1; ext++; int *p = &g; return *p + sg; }
const char *strings(int k) { const char *a = "one"; return k ? a : "two"; }
int locals(int a) { int x = a; int *p = &x; int arr[4]; arr[1] = a; *p += arr[1]; return x; }
unsigned char narrow(int a) { unsigned char c = (unsigned char)a; c += 2; return c; }
double floats(double d, float f, int i) { double r = d * f + i; return r / 2.0; }
double fsum(struct P *p) { return p->d + p->f; }
float fmul(float a, float b) { return a * b; }
double fneg(double a) { return -a; }
double fconv(int i, unsigned u, long l, float f) { return (double)i + u + l + f; }
int fcmp(double a, float b) { return a < b || a == 1.5 || b != 0; }
int fint(double a, float b) { return (int)a + (int)b + (unsigned char)a; }
long widen(int a, unsigned b) { long l = a; l += b; return l << 2; }
int divs(int a, int b, unsigned c) { return a / b + a % b + (int)(c / 3u) + (int)(c % 7u); }
int shifts(int a, unsigned b, long c) { return (a << 3) + (a >> 2) + (int)(b >> 5) + (int)(c >> 40); }
int chars(struct P *p) { gc = (char)p->a; guc = p->b; gs = p->h; return gc + guc + gs + p->b + p->h; }
int bits(unsigned a, unsigned b) { return (int)((a & b) | (a ^ ~b)); }
int incs(int *p, long *q, char *s, struct P *r) { ++*p; --*q; (*s)++; r->u--; r->h++; r->b--; return *p; }
int ptrs(int *p, int *q, struct P *a, struct P *b) { return (int)(p - q) + (int)(a - b) + (p < q) + (p == 0) + p[2] + *(q + 1); }
int cmps(int a, unsigned b, long c, char d) { return (a < 0) + (b > 3u) + (c <= 9) + (d >= 'a') + (a != 7) + !a; }
