#!/usr/bin/env python3
# Walk the skip loop's common path: from the first "Loop Header: Depth=1" label, follow fall-through at conditional
# branches (unless the target is the header, or the branch's ordinal is in TAKE), follow jmp; count instructions.
import sys, re
path = sys.argv[1]
take = set(int(x) for x in sys.argv[2].split(',')) if len(sys.argv) > 2 and sys.argv[2] else set()
which = int(sys.argv[3]) if len(sys.argv) > 3 else 0
lines = open(path).read().split('\n')
insns = []  # (label or None, text)
labels = {}
headers = []
for l in lines:
    m = re.match(r'^(\.LBB\w+):(.*)$', l)
    if m:
        labels[m.group(1)] = len(insns)
        if 'Loop Header: Depth=1' in m.group(2):
            headers.append(m.group(1))
        continue
    s = l.strip()
    if not s or s.startswith('.') or s.startswith('#'):
        continue
    s = re.sub(r'\s*#.*$', '', s)
    insns.append(s)
hdr = headers[which]
import os
if os.environ.get('HDR'): hdr = os.environ['HDR']
i = labels[hdr]
count = 0
branch = 0
trace = []
steps = 0
while True:
    s = insns[i]
    count += 1
    trace.append(s)
    op = s.split()[0]
    if op == 'jmp':
        i = labels[s.split()[1]]
    elif op.startswith('j'):
        tgt = s.split()[1]
        branch += 1
        if tgt == hdr or branch in take:
            i = labels[tgt]
        else:
            i += 1
    elif op in ('retq', 'ret'):
        break
    else:
        i += 1
    if i == labels[hdr]:
        break
    steps += 1
    if steps > 2000:
        print("runaway"); break
print(hdr, count, "instructions,", branch, "branches")
if '-v' in sys.argv:
    print('\n'.join(trace))
