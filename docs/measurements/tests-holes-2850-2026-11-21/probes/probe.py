#!/usr/bin/env python3
# probe.py COMPILER CASES: each case a file of its own (with the cases' file's OPTIONS, where it sets them) through measure-node-machine --shadow --window-rows --passes 0; a line
# a case: C's expressions, decided and refused on the window; the rows' expressions, taken, differences and listed.
import subprocess, sys, re, os, tempfile
compiler = sys.argv[1]
cases = []
def C(name, text): cases.append((name, text))
OPTIONS = []
exec(open(sys.argv[2]).read())
only = sys.argv[3:] 
d = tempfile.mkdtemp(prefix='probe-')
for name, text in cases:
    if only and name not in only: continue
    path = os.path.join(d, name + '.c')
    open(path, 'w').write(text)
    r = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--window-rows', '--passes', '0', '--list', '5'] + OPTIONS + [path], capture_output=True, text=True)
    out = r.stdout + r.stderr
    def grab(pattern):
        m = re.search(pattern, out)
        return m.groups() if m else None
    c = grab(r'window contexts expressions=(\d+) records=\d+ decided=(\d+) \([^)]*\) their-records=\d+ \([^)]*\) of-them-refused=(\d+) differences=(\d+)')
    x = grab(r'window rows expressions=(\d+) records=\d+ taken=(\d+) \([^)]*\) their-records=\d+ \([^)]*\) their-entries=(\d+) differences=(\d+) not-kept-by-the-reference=\d+ second-runs-that-differ=0')
    l = grab(r'window rows listed, by an expression.s first record.s reason: update=(\d+) branches=(\d+) refused-conversion=(\d+) constant-to-a-floating-class=(\d+)')
    w = grab(r"a target's word=(\d+) \([^)]*\) a line or a table=(\d+)")
    v = grab(r"window rows values: tapes that differ in a value alone=(\d+); records on a list=(\d+) .*expressions numbered=(\d+)")
    m = grab(r"window summaries expressions=(\d+) their-references=(\d+) \([^)]*\) with-an-unknown=(\d+) with-a-stop=(\d+); records listed for a reference=\d+ calls asked a record at a time=(\d+) \([^)]*\) expressions reduced=(\d+) second-runs-that-differ=0; operators whose turn lists for a second operand whose truth is known=(\d+)")
    n = grab(r"window summaries compared=(\d+) \(not kept: 0\) the program's references=(\d+) reference-differences=(\d+) fact-differences=(\d+) .*fold-differences=(\d+) .*truth-differences=(\d+) ")
    print('%-28s status %d  C: expr %s decided %s refused %s diff %s | rows: expr %s taken %s entries %s diff %s | listed upd %s br %s conv %s float %s | words %s lines %s | values alone %s listed %s numbered %s | facts kept %s refs %s unknown %s stop %s asked %s reduced %s decided %s | compared %s program-refs %s diff refs %s facts %s folds %s truths %s' % (
        (name, r.returncode) + (c or ('?',) * 4) + (x or ('?',) * 4) + (l or ('?',) * 4) + (w or ('?',) * 2) + (v or ('?',) * 3) + (m or ('?',) * 7) + (n or ('?',) * 6)))
    sys.stdout.flush()
