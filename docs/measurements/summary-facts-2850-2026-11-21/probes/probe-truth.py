#!/usr/bin/env python3
# probe-truth.py COMPILER CASES: as probe.py, a line a case with the truths' counts: the roots kept, the branches'
# conditions asked their truth, the differences, the truths known; and the compiler's own warnings' count.
import subprocess, sys, re, os, tempfile
compiler = sys.argv[1]
cases = []
def C(name, text): cases.append((name, text))
exec(open(sys.argv[2]).read())
only = sys.argv[3:]
d = tempfile.mkdtemp(prefix='probe-')
for name, text in cases:
    if only and name not in only: continue
    path = os.path.join(d, name + '.c')
    open(path, 'w').write(text)
    r = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--window-rows', '--passes', '0', '--list', '5', path], capture_output=True, text=True)
    out = r.stdout + r.stderr
    def grab(pattern):
        m = re.search(pattern, out)
        return m.groups() if m else None
    x = grab(r'window rows expressions=(\d+) records=\d+ taken=(\d+)')
    n = grab(r"window summaries compared=(\d+) \(not kept: (\d+)\) the program's references=\d+ reference-differences=(\d+) fact-differences=(\d+) .*folds asked=(\d+) fold-differences=(\d+) \(of the compared: a constant folded=(\d+)\); branches' conditions' truths asked=(\d+) truth-differences=(\d+) \(of the compared: a truth known=(\d+)\)")
    statement = [l for l in text.split('\n') if l.startswith('    ') and not l.startswith('    int local') and not l.startswith('    long wide') and not l.startswith('    return local')]
    print('%-12s status %d  expr %s taken %s | compared %s unkept %s diff refs %s facts %s | folds asked %s diff %s folded %s | truths asked %s diff %s known %s | %s' % (
        (name, r.returncode) + (x or ('?',) * 2) + (n or ('?',) * 10) + (statement[0].strip() if statement else '',)))
    sys.stdout.flush()
