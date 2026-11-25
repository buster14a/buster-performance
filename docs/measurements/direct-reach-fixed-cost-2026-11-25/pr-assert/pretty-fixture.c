typedef struct Q Qrf;
typedef unsigned long long u64;
typedef int (*cb_t)(void*, int);
typedef int fn_t(int);
typedef __builtin_va_list va_list;
struct S { int a; };
union U { int a; };
enum E { E0 };
const char *names[32];
void p01(int a) { names[1] = __PRETTY_FUNCTION__; }
void p02(Qrf *p, const char *z, int a[10], unsigned long n) { names[2] = __PRETTY_FUNCTION__; }
int p03(void) { names[3] = __PRETTY_FUNCTION__; return 0; }
int p04() { names[4] = __PRETTY_FUNCTION__; return 0; }
void p05(int n, ...) { names[5] = __PRETTY_FUNCTION__; }
int (*p06(int x))(int) { names[6] = __PRETTY_FUNCTION__; return 0; }
void p07(const volatile int *p, int *restrict q, int *const r, char **argv, void *v, const void *cv) { names[7] = __PRETTY_FUNCTION__; }
const int p08(void) { names[8] = __PRETTY_FUNCTION__; return 0; }
const char *const p09(void) { names[9] = __PRETTY_FUNCTION__; return 0; }
void (*p10(int sig, void (*func)(int)))(int) { names[10] = __PRETTY_FUNCTION__; return 0; }
int (*p11(void))[3] { names[11] = __PRETTY_FUNCTION__; return 0; }
void p12(fn_t g, int x[const 3], int y[static restrict 2], char z[][2][3]) { names[12] = __PRETTY_FUNCTION__; }
static int p13(int x __attribute__((unused)), unsigned char c, long int l, int long m, unsigned u, signed s, short int si, long long int lli, unsigned long long ull) { names[13] = __PRETTY_FUNCTION__; return 0; }
void p14(void (*)(void), int (*)(), char (*)[]) { names[14] = __PRETTY_FUNCTION__; }
void p15(va_list ap) { names[15] = __PRETTY_FUNCTION__; }
void p16(__builtin_va_list ap) { names[16] = __PRETTY_FUNCTION__; }
void p17(va_list *ap) { names[17] = __PRETTY_FUNCTION__; }
_Bool p18(_Bool b) { names[18] = __PRETTY_FUNCTION__; return b; }
void p19(signed char a, char b, unsigned char c, short d, unsigned short e) { names[19] = __PRETTY_FUNCTION__; }
void p20(enum E e, union U *u, struct S s) { names[20] = __PRETTY_FUNCTION__; }
void p21(const Qrf *p, Qrf const *q, Qrf *const r) { names[21] = __PRETTY_FUNCTION__; }
char *(*p22(int a))[4] { names[22] = __PRETTY_FUNCTION__; return 0; }
void p23(int (*fp)(int (*)(int), char *)) { names[23] = __PRETTY_FUNCTION__; }
void p24(int *(*arr)[5]) { names[24] = __PRETTY_FUNCTION__; }
void p25(char x[], const char y[], char *z[]) { names[25] = __PRETTY_FUNCTION__; }
void p26(int a[0x10], int b[2u]) { names[26] = __PRETTY_FUNCTION__; }
u64 *p27(cb_t cb) { names[27] = __PRETTY_FUNCTION__; return 0; }
void p28(int (* const p)(void)) { names[28] = __PRETTY_FUNCTION__; }
void p29(__int128 a, unsigned __int128 b) { names[29] = __PRETTY_FUNCTION__; }
static __inline__ float p30(float a, double b) { names[30] = __PRETTY_FUNCTION__; return a; }
int use(void) { return p13(0, 0, 0, 0, 0, 0, 0, 0, 0) + (int)p30(0, 0); }
