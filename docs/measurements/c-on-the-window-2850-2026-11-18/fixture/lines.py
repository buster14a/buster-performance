#!/usr/bin/env python3
# lines.py COMPILER [FILTER]: each statement of the fixture alone in the function, through the shadow with C on the
# window: whether T takes it, and what the window makes of it (decided, refused, listed and why, strides, far loads).
import subprocess, sys, re
compiler = sys.argv[1]
S10 = "a + a + a + a + a + a + a + a + a + a"
LONG = "(" + " + ".join([S10] * 7) + ")"
HEAD = '''struct pair { int first; long second; unsigned bits : 3; };
struct outer { struct pair inner; struct pair* link; int list[4]; };
union both { int whole; float part; };
enum Wide : unsigned __int128 { WIDE = (unsigned __int128)1 << 70, NARROW = 5 };
struct nothing { };
extern struct nothing* np;
extern double gd;
extern int global;
static long file_scope;
_Thread_local int thread_scope;
_Atomic int shared;
extern int table[4];
extern int open_list[];
int callee(int a, long b);
int over(int x) __attribute__((overloadable));
int over(long x) __attribute__((overloadable));
_Complex double zed;
int contexts(int a, long b, int* p, struct outer* o, struct outer v, int n, double d, char c, int (*q)[n], long double e, float f, char (*h)[4294967296],
             _BitInt(24) bi, __int128 w, __float128 q128, union both un)
{
    int local = a;
    long wide = a;
    static int still;
    int vla[n];
    typedef int v4 __attribute__((vector_size(16)));
    v4 vec = { 0 };
    typedef float f4 __attribute__((ext_vector_type(4)));
    f4 ev = { 0 };
    f4* evp = &ev;
    _Atomic struct pair ap;
    volatile int vol = 0;
    register int reg = 0;
    int arr[4];
    struct pair sp;
    long double lds[4];
    long double* pld = lds;
    struct wide { long double big; int small; };
    struct wide* wp = 0;
    _Complex double* zq = &zed;
    _Complex double* zp = &zed;
    _Float16 hf = 0;
    unsigned __int128 uw = 0;
    struct pair* _Atomic app;
    %s
    return 0;
}
'''
lines = [l.strip() for l in open(sys.argv[3] if len(sys.argv) > 3 else 'statements.txt') if l.strip() and not l.startswith('#')]
for line in lines:
    if len(sys.argv) > 2 and sys.argv[2] not in ('', '-') and sys.argv[2] not in line:
        continue
    text = HEAD % line.replace('LONG_SUM', LONG)
    open('lines/one.c', 'w').write(text)
    run = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--passes', '0', '--window-contexts', '--verify', '--list', '5', 'lines/one.c'], capture_output=True, text=True)
    out = run.stdout
    def get(pat, default='?'):
        m = re.search(pat, out)
        return m.group(1) if m else default
    base = dict(e=4, d=4, r=0)   # the function's own: two initializers, the return... measured below
    info = 'T-expressions=%s taken=%s | window: expressions=%s decided=%s refused=%s differences=%s strides=%s asked=%s far=%s | %s' % (
        get(r'reader-time T expressions=(\d+)'), get(r'reader-time T expressions=\d+ records=\d+ typed=\d+ taken=(\d+)'),
        get(r'window contexts expressions=(\d+)'), get(r'window contexts expressions=\d+ records=\d+ decided=(\d+)'), get(r'of-them-refused=(\d+)'),
        get(r'window contexts expressions=.*? differences=(\d+)'), get(r'strides-read=(\d+)'), get(r'of-them-asked-of-the-type-table=(\d+)') + '/' + get(r'rules-that-read-the-conversions=(\d+)'), get(r"out-of-a-block's-reach=(\d+)"),
        get(r"first record's reason: (.*)").replace('=0', '').replace('call ', '').replace('logical-or-conditional ', '').replace('update ', '').replace('comma-or-selection ', '').replace('division-by-a-constant ', '').replace('wide-value ', '').replace('leaf ', '').replace('operator', '').strip())
    print('%-34s status %d %s%s' % (line.replace('LONG_SUM', '<70 a>')[:34], run.returncode, info, (' ERR ' + run.stderr.strip()[:120]) if run.stderr.strip() else ''))
