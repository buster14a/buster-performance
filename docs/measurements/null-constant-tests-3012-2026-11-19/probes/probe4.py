#!/usr/bin/env python3
# probe4.py COMPILER STATEMENTS: each line `CONTEXT @@ SOURCE` alone in a function, through the shadow with the window's
# tests and C on the window. CONTEXT is one of assign, init, argument, return, or a statement template with X in it.
# One line a statement: whether the compiler warns of it (the pipeline's event), what the reader-time tests and the
# window's own tests say, and the status.
import subprocess, sys, re, os
compiler = sys.argv[1]
head = '''enum color { RED, GREEN };
enum shade { DARK = 0, LIGHT = 1 };
struct pair { int* first; char* second; };
typedef int* intp;
void fp(const char*);
void fv(void*);
void f2(int, char*);
void fe(int, ...);
int* gp;
'''
templates = {
    'assign': ('int g(int* ip, int a)\n{\n    ip = X;\n    return a;\n}\n'),
    'init': ('int g(int* ip, int a)\n{\n    int* np = X;\n    return a;\n}\n'),
    'argument': ('int g(int* ip, int a)\n{\n    fp(X);\n    return a;\n}\n'),
    'second': ('int g(int* ip, int a)\n{\n    f2(a, X);\n    return a;\n}\n'),
    'return': ('char* g(int* ip, int a)\n{\n    return X;\n}\n'),
}
os.makedirs('lines4', exist_ok=True)
for line in open(sys.argv[2]):
    line = line.rstrip('\n')
    if not line.strip() or line.startswith('#'):
        continue
    context, source = [part.strip() for part in line.split(' @@ ', 1)]
    body = templates[context] if context in templates else 'int g(int* ip, int a)\n{\n    ' + context + '\n    return a;\n}\n'
    text = head + body.replace('X', source)
    open('lines4/one.c', 'w').write(text)
    run = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--passes', '0', '--window-contexts', '--verify', '--list', '5', 'lines4/one.c'], capture_output=True, text=True)
    out = run.stdout + run.stderr
    def get(pat, default='?'):
        m = re.search(pat, out)
        return m.group(1) if m else default
    warns = get(r'event id=25 option=-Wnon-literal-null-conversion expressions=(\d+)', '0')
    events = ','.join(sorted(set(re.findall(r'event id=\d+ option=(\S+)', out)) - {'-Wnon-literal-null-conversion'}))
    unsound = len(re.findall(r'UNSOUND', out))
    reader = get(r'reader-time tests expressions=\d+ refused=(\d+)')
    census = get(r'refused-by-the-census=(\d+)')
    rdiff = get(r'reader-time tests compared=.*? differences=(\d+)')
    taken = get(r'reader-time tests compared=\d+ never-lowered=\d+ taken-there=(\d+)')
    wdiff = get(r'window tests expressions=\d+ records=\d+ differences=(\d+)')
    cdiff = get(r'window contexts expressions=.*? differences=(\d+)')
    own = '%s/%s/%s/%s' % (get(r'operators-left-out-for-quiet-constants=\d+ checked=\d+ of-them-with-a-test=(\d+)'), get(r'calls-left-out=\d+ checked=\d+ of-them-with-a-test=(\d+)'),
                           get(r'casts-left-out=\d+ checked=\d+ of-them-with-a-test=(\d+)'), get(r'of-them-with-another-verdict=(\d+)'))
    payload = get(r"not-their-payloads'=(\d+)")
    kdiff = get(r'the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=(\d+)')
    loud = get(r'of-them-with-a-loud-argument=(\d+)')
    rejected = 'failures=0' not in out
    flag = '' if run.returncode == 0 else ' STATUS %d' % run.returncode
    shown = (context if context in templates else 'stmt') + ': ' + (source if context in templates else context.replace('X', source))
    print('%-44s warns=%s taken=%s reader-refuses=%s census-refuses=%s unsound=%d rdiff=%s window=%s own=%s payload=%s kernel=%s loud=%s C=%s%s%s%s' % (
        shown[:44], warns, taken, reader, census, unsound, rdiff, wdiff, own, payload, kdiff, loud, cdiff, (' other=' + events) if events else '', ' REJECTED' if rejected else '', flag))
