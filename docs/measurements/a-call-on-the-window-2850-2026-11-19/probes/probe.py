#!/usr/bin/env python3
# probe.py COMPILER STATEMENTS [FILTER]: each statement alone in a function, through the shadow with C on the window:
# what the kernel in place and T make of it (records that differ), and what the window's C makes of it.
import subprocess, sys, re, os
compiler = sys.argv[1]
HEAD = '''struct pair { int first; long second; unsigned bits : 3; };
union both { int whole; float part; };
typedef union { int* ip; long* lp; } trans __attribute__((transparent_union));
enum color { RED, GREEN };
void fi(int);
void fu(unsigned);
void fc(char);
void fb(_Bool);
void fs(short);
void fl(long);
void ff(float);
void fd(double);
void fld(long double);
void fp(const char*);
void fcp(char*);
void fv(void*);
void fip(int*);
void flp(long*);
void fe(enum color);
void fst(struct pair);
void fsp(struct pair*);
void ft(trans);
void ffp(void (*)(int));
void f128(__int128);
void fh(_Float16);
void fz(_Complex double);
void fat(_Atomic int);
void fbi(_BitInt(24));
int two(int, long);
int printf(const char*, ...);
int kr();
extern void (*pf)(int);
extern int (*pv)(const char*, ...);
int g(int a, long b, char* s, float f, short h, double d, struct pair* o, struct pair v, _Bool t, enum color e, long double ld, __int128 w, int* ip, unsigned u, _Complex double z, _Float16 hf, const char* cs, void* vp, unsigned char uc)
{
    int arr[4];
    _Atomic int at = 0;
    volatile int vol = 0;
    register int reg = 0;
    typedef int v4 __attribute__((vector_size(16)));
    v4 vec = { 0 };
    %s
    return 0;
}
'''
lines = [l.rstrip('\n') for l in open(sys.argv[2]) if l.strip() and not l.startswith('#')]
os.makedirs('lines', exist_ok=True)
for line in lines:
    if len(sys.argv) > 3 and sys.argv[3] not in line:
        continue
    open('lines/one.c', 'w').write(HEAD % line)
    run = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--passes', '0', '--window-contexts', '--verify', '--list', '5', 'lines/one.c'], capture_output=True, text=True)
    out = run.stdout
    def get(pat, default='?'):
        m = re.search(pat, out)
        return m.group(1) if m else default
    base = get(r'the kernel in place: to-make=\d+ made=(\d+)') + '/' + get(r'the kernel in place: to-make=(\d+)')
    info = 'T=%s/%s kernel made=%s diff=%s | C: expr=%s decided=%s refused=%s diff=%s | calls-left-out=%s loud=%s | tests: %s' % (
        get(r'reader-time T expressions=\d+ records=\d+ typed=\d+ taken=(\d+)'), get(r'reader-time T expressions=(\d+)'), base,
        get(r'the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=(\d+)'),
        get(r'window contexts expressions=(\d+)'), get(r'window contexts expressions=\d+ records=\d+ decided=(\d+)'), get(r'of-them-refused=(\d+)'),
        get(r'window contexts expressions=.*? differences=(\d+)'),
        get(r'own tests calls-left-out=(\d+)'), get(r'of-them-with-a-loud-argument=(\d+)'),
        ' '.join(sorted(set(re.findall(r'list test=(\S+) file=lines/one.c line=4[6-9]', out)))))
    err = run.stderr.strip().replace('\n', ' / ')[:160]
    print('%-40s st %d %s%s' % (line[:40], run.returncode, info, (' ERR ' + err) if err else ''))
