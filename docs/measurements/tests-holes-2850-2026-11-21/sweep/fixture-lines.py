#!/usr/bin/env python3
# fixture-lines.py COMPILER TEST_FILE NAME [OPTION...]: a fixture's text (a `static const char NAME[] = "..."` of the
# test file) written out and run through the census (measure-node-machine --shadow --window-rows --list 400): each
# annotated line with what the census did there (its expressions, those refused, the tests that refuse), and whether
# its `// refuse: TEST` or `// take` holds; then the compiler's own warnings and the shadow's status.
import re, subprocess, sys, os, collections
compiler, test_file, name = sys.argv[1], sys.argv[2], sys.argv[3]
options = sys.argv[4:]
src = open(test_file).read()
m = re.search(r'static const char ' + name + r'\[\] =(.*?);\n\n', src, re.S)
body = re.sub(r'"(?:[^"\\\n]|\\.)*"|//[^\n]*', lambda x: x.group(0) if x.group(0).startswith('"') else '', m.group(1))
text = ''.join(re.findall(r'"((?:[^"\\\n]|\\.)*)"', body))
simple = {'n': '\n', 't': '\t', '\\': '\\', '"': '"', "'": "'"}
out = []
i = 0
while i < len(text):
    if text[i] == '\\':
        out.append(simple.get(text[i + 1], '\\' + text[i + 1])); i += 2
    else:
        out.append(text[i]); i += 1
text = ''.join(out)
path = '/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad/holes/fixtures/%s.c' % name
open(path, 'w').write(text)
r = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--window-rows', '--passes', '0', '--list', '400'] + options + [path], capture_output=True, text=True)
report = r.stdout + r.stderr
refused = collections.defaultdict(set)
for mm in re.finditer(r'node-census: list test=(\S+) (?:file=\S+ )?line=(\d+)', report):
    refused[int(mm.group(2))].add(mm.group(1))
bad = 0
for n, line in enumerate(text.split('\n'), 1):
    mm = re.search(r'// (refuse: (\S+)|take)', line)
    if not mm:
        continue
    if mm.group(2):
        ok = mm.group(2) in refused[n]
    else:
        ok = not refused[n]
    bad += not ok
    print('%s %3d %-60s | %s' % ('ok ' if ok else 'BAD', n, line.strip()[:60], ','.join(sorted(refused[n])) or '-'))
w = subprocess.run([compiler, '-fsyntax-only'] + options + [path], capture_output=True, text=True)
print('compiler: status %d, %d warnings, %d errors' % (w.returncode, w.stderr.count('warning:'), w.stderr.count('error:')))
for l in w.stderr.split('\n'):
    if 'error:' in l:
        print('  ' + l[:200])
print('shadow: status %d, annotations that do not hold: %d' % (r.returncode, bad))
for l in report.split('\n'):
    if re.search(r'UNSOUND|difference file=|DIFFERENT|differences=[1-9]', l):
        print('  ' + re.sub(r'file=\S+ ', '', l)[:260])
