#!/usr/bin/env python3
# probe-u2.py COMPILER STATEMENTS [--flat]: each line's statement alone in a function (the head below), through the shadow with C
# on the window (--window-contexts --verify): a line a statement with what C on the window made of its expressions
# (decided, refused, listed by reason, differences from C on T's columns), the updates C asks its plan of and those the
# loop's masks took, the kernel in place's differences, and the status. The head's `seg` points to an int in the gs
# space, which gives the unit's type table extended qualifiers (the loop then asks each masked update's destination's
# space); with --flat it is a plain pointer, and the table has none.
import subprocess, sys, re, os
compiler = sys.argv[1]
flat = '--flat' in sys.argv[3:]
work = 'lines-u-flat' if flat else 'lines-u'
head = '''typedef int v4 __attribute__((vector_size(16)));
struct s { int a; long b; char c; unsigned f : 3; int arr[4]; float x; double d; struct s* next; _Atomic int at; };
enum e { E0, E1 };
int gi; long gl; char gc; unsigned char guc; short gs; float gf; double gd; long double gld; __int128 g128; _Bool gb; enum e ge;
int* gp; char* gcp; void* gvp; void (*gfp)(void); struct s gst; struct s* gsp; _Atomic int gat; volatile int gvol; _Complex double gcd; v4 gv;
int garr[8]; static int sgi; int __seg_gs* seg;
void use(int); int get(void);
int g(int a, long l, char c, float x, double d, int* p, struct s* sp, unsigned u, short sh, _Bool b, enum e e, long double ld, void* vp, char* cp)
{
    register int ri = a; static int si; int arr[4]; struct s st; int i = a; v4 vl; __int128 w = a; _Atomic int at; volatile int vol; unsigned long ul = u;
    X
    return i;
}
'''
if flat:
    head = head.replace('int __seg_gs* seg;', 'int* seg;')
os.makedirs(work, exist_ok=True)
for line in open(sys.argv[2]):
    line = line.rstrip('\n')
    if not line.strip() or line.startswith('#'):
        continue
    open(work + '/one.c', 'w').write(head.replace('X', line))
    run = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--passes', '0', '--window-contexts', '--verify', '--list', '5', work + '/one.c'], capture_output=True, text=True)
    out = run.stdout + run.stderr
    def get(pat, default='?'):
        m = re.search(pat, out)
        return m.group(1) if m else default
    rejected = 'failures=0' not in out
    listed = get(r"listed, by an expression's first record's reason:(.*)", '')
    listed = ' '.join(x for x in listed.split() if not x.endswith('=0'))
    print('%-34s decided=%s/%s refused=%s diff=%s/%s listed[%s] updates=%s/%s kernel=%s unsound=%d%s%s' % (
        line[:34], get(r'window contexts expressions=\d+ records=\d+ decided=(\d+)'), get(r'window contexts expressions=(\d+)'), get(r'of-them-refused=(\d+)'),
        get(r'of-them-refused=\d+ differences=(\d+)'), get(r'records-that-differ=(\d+)'), listed, get(r'window contexts updates=(\d+)'), get(r'window contexts updates=\d+ \([^)]*\) taken=(\d+)'),
        get(r'the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=(\d+)'), len(re.findall(r'UNSOUND', out)), ' REJECTED' if rejected else '', '' if run.returncode == 0 else ' STATUS %d' % run.returncode))
