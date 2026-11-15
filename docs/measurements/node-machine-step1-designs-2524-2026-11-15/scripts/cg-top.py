#!/usr/bin/env python3
# cg-top.py CALLGRIND.OUT REPO REV FILE NODES RUNS FIRST LAST: Ir per taken node and run by source line of FILE in [FIRST, LAST].
import sys, re, subprocess, collections
out, repo, rev, short, nodes, runs, first, last = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], float(sys.argv[5]), float(sys.argv[6]), int(sys.argv[7]), int(sys.argv[8])
names = {'f': {}, 'n': {}, 'o': {}}
def name_of(tok, space='f'):
    m = re.match(r'\((\d+)\)(?: (.*))?$', tok.strip())
    if m:
        if m.group(2) is not None:
            names[space][m.group(1)] = m.group(2)
        return names[space].get(m.group(1), '?')
    return tok
cost = collections.Counter(); cur = None; lineno = 0; skipnext = False; has_instr = True
for line in open(out):
    line = line.rstrip('\n')
    if line.startswith('positions:'):
        has_instr = 'instr' in line
    if line.startswith(('fl=', 'fi=', 'fe=')):
        cur = name_of(line[3:])
    elif line.startswith(('cfi=', 'cfl=')):
        name_of(line.split('=', 1)[1], 'f')
    elif line.startswith(('fn=', 'cfn=')):
        name_of(line.split('=', 1)[1], 'n')
    elif line.startswith(('ob=', 'cob=')):
        name_of(line.split('=', 1)[1], 'o')
    elif line.startswith('calls='):
        skipnext = True
    elif line and (line[0].isdigit() or line[0] in '+-*'):
        parts = line.split()
        if not has_instr:
            parts = ['0'] + parts
        if len(parts) >= 3:
            t = parts[1]
            if t == '*': pass
            elif t[0] == '+': lineno += int(t[1:])
            elif t[0] == '-': lineno -= int(t[1:])
            else: lineno = int(t)
            if not skipnext and cur and cur.endswith('/' + short):
                cost[lineno] += int(parts[2])
        skipnext = False
src = subprocess.run(['git', '-C', repo, 'show', f'{rev}:src/buster/compiler/{short}'], capture_output=True, text=True).stdout.split('\n')
total = 0
for ln in sorted(cost):
    if first <= ln <= last:
        per = cost[ln] / nodes / runs
        total += per
        if per >= 0.3:
            print(f'{ln:5d} {per:7.1f}  {src[ln-1].strip()[:150] if 0 < ln <= len(src) else ""}')
print('total', f'{total:.1f}')
