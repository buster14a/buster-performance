#!/usr/bin/env python3
# probe3.py COMPILER STATEMENTS [OUT]: each statement alone after the fixture's own declarations and locals
# (fixture-head.c), through the shadow with C on the window. A line `@decl TEXT` adds a declaration before the
# function and `@local TEXT` a local, for the statements after it. One line a statement: what the kernel in place
# makes of its calls, whether a record or a conversion differs from T's, and what C on the window makes of it.
import subprocess, sys, re, os
compiler = sys.argv[1]
head = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'fixture-head.c')).read()
cut = head.index('struct outer whole(')
decls, locals_ = [], []
os.makedirs('lines3', exist_ok=True)
for line in open(sys.argv[2]):
    line = line.rstrip('\n')
    if not line.strip() or line.startswith('#'):
        continue
    if line.startswith('@decl '):
        decls.append(line[6:]); continue
    if line.startswith('@local '):
        locals_.append(line[7:]); continue
    text = head[:cut] + ''.join(d + '\n' for d in decls) + head[cut:] + ''.join('    ' + l + '\n' for l in locals_) + '    ' + line + '\n    return a;\n}\n'
    open('lines3/one.c', 'w').write(text)
    run = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--passes', '0', '--window-contexts', '--verify', '--list', '5', 'lines3/one.c'], capture_output=True, text=True)
    out = run.stdout
    def get(pat, default='?'):
        m = re.search(pat, out)
        return m.group(1) if m else default
    kernel = 'diff=%s' % get(r'the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=(\d+)')
    calls = 'calls=%s made=%s whole=%s plain=%s left=%s' % (get(r"in place's calls: to-make=(\d+)"), get(r"in place's calls: to-make=\d+ made=(\d+)"),
                                                           get(r"with-every-argument's-conversion=(\d+)"), get(r'of-them-plain=(\d+)'), get(r'left-for-an-argument=(\d+)'))
    c = 'expr=%s decided=%s refused=%s diff=%s' % (get(r'window contexts expressions=(\d+)'), get(r'window contexts expressions=\d+ records=\d+ decided=(\d+)'),
                                                   get(r'of-them-refused=(\d+)'), get(r'window contexts expressions=.*? differences=(\d+)'))
    failed = get(r'failed="([^"]*)"', '')
    flag = '' if run.returncode == 0 else ' STATUS %d' % run.returncode
    print('%-52s %s | %s | C: %s%s%s' % (line[:52], kernel, calls, c, flag, (' FAILED ' + failed) if failed else ''))
