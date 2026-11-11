#!/usr/bin/env python3
# #1444 item 5: per-caller calls of the string functions in a callgrind profile, through their IFUNC stubs.
#   strcalls.py PROFILE
import re, subprocess, sys, collections
text = subprocess.run(['callgrind_annotate', '--threshold=100', '--tree=caller', sys.argv[1]], capture_output=True, text=True).stdout
callers = collections.defaultdict(list)
block = []
for line in text.split('\n') + ['']:
    if line.strip() == '':
        star = [l for l in block if '*  ' in l]
        if star:
            callee = re.search(r'\*  \?\?\?:(\S+)', star[0]).group(1)
            for l in block:
                m = re.search(r'< +\?\?\?:(\S+) \(([\d,]+)x\)', l)
                if m:
                    callers[callee].append((m.group(1), int(m.group(2).replace(',', ''))))
        block = []
    else:
        block.append(line)
names = ('strcmp', 'strncmp', 'memcmp', 'strlen', 'bcmp')
totals = collections.Counter()
for callee, lst in callers.items():
    base = re.sub(r'^__', '', callee).split('_')[0]
    if base not in names:
        continue
    for caller, count in lst:
        if caller.startswith('0x'):
            for c2, n2 in callers.get(caller, []):
                totals[(base, c2)] += n2
        else:
            totals[(base, caller)] += count
for (f, c), n in sorted(totals.items(), key=lambda x: (x[0][0], -x[1])):
    print('%-8s %-40s %6d' % (f, c, n))
