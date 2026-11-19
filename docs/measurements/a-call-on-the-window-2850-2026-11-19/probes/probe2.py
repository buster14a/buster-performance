#!/usr/bin/env python3
# probe2.py COMPILER STATEMENTS [FILTER]: each statement alone in a function, through the shadow with C on the window:
# what the kernel in place makes of its calls (made, with every conversion, plain, left for an argument), whether any
# record or argument's conversion differs from T's, and what C on the window makes of it (decided, refused, differences).
import subprocess, sys, re, os
compiler = sys.argv[1]
HEAD = '''struct pair { int first; long second; unsigned bits : 3; };
union both { int whole; float part; };
typedef union { int* ip; long* lp; } trans __attribute__((transparent_union));
enum color { RED, GREEN };
typedef int v4 __attribute__((vector_size(16)));
typedef float f4 __attribute__((ext_vector_type(4)));
void fi(int); void fu(unsigned); void fc(char); void fb(_Bool); void fs(short); void fl(long); void ful(unsigned long);
void ff(float); void fd(double); void fld(long double); void fq(__float128); void fh(_Float16);
void fp(const char*); void fcp(char*); void fv(void*); void fcv(const void*); void fip(int*); void fcip(const int*); void flp(long*);
void fe(enum color); void fst(struct pair); void fun(union both); void fsp(struct pair*); void ft(trans); void ffp(void (*)(int));
void f128(__int128); void fz(_Complex double); void fat(_Atomic int); void fbi(_BitInt(24)); void fvec(v4); void fev(f4);
void fpp(int**); void frp(int* restrict);
int two(int, long); int six(int, long, char*, double, void*, unsigned); int nine(int, int, int, int, int, int, int, int, int);
int printf(const char*, ...); int vf(int, ...); int none(void);
enum color getc(void); struct pair getp(void); void (*getf(void))(int); double getd(void); long double getld(void); v4 getv(void);
extern void (*pf)(int); extern int (*pv)(const char*, ...); extern void (*table[4])(int);
struct ops { void (*run)(int); int (*sum)(int, long); };
int g(int a, long b, char* s, float f, short h, double d, struct pair* o, struct pair v, _Bool t, enum color e, long double ld, __int128 w, int* ip, unsigned u,
      _Complex double z, _Float16 hf, const char* cs, void* vp, unsigned char uc, struct ops* op, __float128 q, _BitInt(24) bi, const int ci, union both un,
      v4 vec, v4 other, f4 ev, int* restrict rp, volatile int* volp, const int* cip, long* lp)
{
    int arr[4];
    char buf[8];
    const char cbuf[4] = "abc";
    _Atomic int at = 0;
    volatile int vol = 0;
    static int still;
    %s
    return 0;
}
'''
lines = [l.rstrip('\n') for l in open(sys.argv[2]) if l.strip() and not l.startswith('#')]
os.makedirs('lines', exist_ok=True)
bad = 0
for line in lines:
    if len(sys.argv) > 3 and sys.argv[3] not in line:
        continue
    open('lines/two.c', 'w').write(HEAD % line)
    run = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--passes', '0', '--window-contexts', '--verify', '--list', '5', 'lines/two.c'], capture_output=True, text=True)
    out = run.stdout
    def get(pat, default='?'):
        m = re.search(pat, out)
        return m.group(1) if m else default
    kernel = 'made=%s/%s diff=%s' % (get(r'the kernel in place: to-make=\d+ made=(\d+)'), get(r'the kernel in place: to-make=(\d+)'),
                                      get(r'the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=(\d+)'))
    calls = 'calls=%s made=%s whole=%s plain=%s left-arg=%s' % (get(r"in place's calls: to-make=(\d+)"), get(r"in place's calls: to-make=\d+ made=(\d+)"),
                                                                get(r"with-every-argument's-conversion=(\d+)"), get(r'of-them-plain=(\d+)'), get(r'left-for-an-argument=(\d+)'))
    c = 'expr=%s decided=%s refused=%s diff=%s' % (get(r'window contexts expressions=(\d+)'), get(r'window contexts expressions=\d+ records=\d+ decided=(\d+)'),
                                                   get(r'of-them-refused=(\d+)'), get(r'window contexts expressions=.*? differences=(\d+)'))
    listed = get(r"first record's reason: (.*)").replace('=0', '')
    listed = ' '.join(w for w in listed.split() if '=' in w)
    err = run.stderr.strip().replace('\n', ' / ')[:140]
    failed = get(r'failed="([^"]*)"', '')
    flag = '' if run.returncode == 0 else ' STATUS %d' % run.returncode
    bad += run.returncode != 0 and not failed
    print('%-44s %s | %s | C: %s | listed: %s%s%s%s' % (line[:44], kernel, calls, c, listed, flag, (' FAILED ' + failed) if failed else '', (' ERR ' + err) if err else ''))
print('statements with a status that is no rejection: %d' % bad)
