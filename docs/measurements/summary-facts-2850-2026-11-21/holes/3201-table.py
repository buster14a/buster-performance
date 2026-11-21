import subprocess, sys, re
PRE = '''enum color { RED, GREEN };
int ga[8];
int one(int a);
struct pair { int first; int list[4]; };
int f(long a, int* p, struct pair* q, int (*fp)(int))
{
    int local = 0;
    enum color hue = RED;
'''
POST = '''
    return local + (int)hue;
}
'''
cases = ['local = (a < p);', 'local = (p >= a);', 'local = (p <= 1);', 'local = (ga > a);', 'if (a < p) local = 1;', 'local = (p == a);', 'local = (p != 1);', 'local = (p < 0);', 'local = (p == 0);',
         'local = (int)ga;', 'local = (short)one;', 'local = (short)"x";', 'local = (char)q->list;', 'local = (unsigned char)*fp;', 'hue = (enum color)ga;', 'local = (int)p;', 'hue = (enum color)p;',
         'local = (int)fp;', 'local = (long)ga != 0;', 'a = (long)ga;']
for i, c in enumerate(cases):
    open('c%d.c' % i, 'w').write(PRE + '    ' + c + POST)
    r = subprocess.run([sys.argv[1], 'measure-node-machine', '--shadow', '--window-rows', '--passes', '0', '--list', '3', 'c%d.c' % i], capture_output=True, text=True)
    out = r.stdout + r.stderr
    line = [l for l in out.split('\n') if 'reader-time tests difference' in l and 'line=9' in l]
    m = re.search(r'reader-time tests compared=(\d+) never-lowered=\d+ taken-there=(\d+)', out)
    k = subprocess.run([sys.argv[1], '-fsyntax-only', 'c%d.c' % i], capture_output=True, text=True)
    w = re.findall(r':9:\d+: warning: (.*)', k.stderr)
    print('%2d status %d %-8s compared %s taken %s | %-28s | %s' % (i, r.returncode, 'UNSOUND' if any('UNSOUND' in l for l in line) else '', m.group(1) if m else '?', m.group(2) if m else '?', c, '; '.join(w) or 'no warning'))
