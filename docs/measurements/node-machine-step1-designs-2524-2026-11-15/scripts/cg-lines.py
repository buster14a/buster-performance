#!/usr/bin/env python3
# cg-lines.py CALLGRIND.OUT REPO REV NODES RUNS_T RUNS_C RUNS_X: Ir by source function (by line ranges at REV) for the
# node machine's files, per taken node and run of the sweep.
import sys, re, subprocess, collections
out, repo, rev, nodes = sys.argv[1], sys.argv[2], sys.argv[3], float(sys.argv[4])
FILES = ('c_check_node_machine.c', 'c_check_node_machine_type.c', 'c_check_node_machine_contexts.c', 'c_check_node_machine_expand.c', 'c_check_node_machine_lower.c', 'c_check_node_machine_shape.c')
runs = {'type': float(sys.argv[5]), 'contexts': float(sys.argv[6]), 'expand': float(sys.argv[7]), 'machine': 1.0, 'lower': float(sys.argv[8]) if len(sys.argv) > 8 else 1.0, 'shape': 1.0}
files = {}
names = {'f': {}, 'n': {}, 'o': {}}
cost = collections.Counter()
cur = None
def name_of(tok, space='f'):
    m = re.match(r'\((\d+)\)(?: (.*))?$', tok.strip())
    if m:
        if m.group(2) is not None:
            names[space][m.group(1)] = m.group(2)
        return names[space].get(m.group(1), '?')
    return tok
lineno = 0
skipnext = False
has_instr = True
with open(out) as f:
    for line in f:
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
                if t == '*':
                    pass
                elif t[0] == '+':
                    lineno += int(t[1:])
                elif t[0] == '-':
                    lineno -= int(t[1:])
                else:
                    lineno = int(t)
                if not skipnext and cur and 'c_check_node_machine' in cur:
                    cost[(cur.split('/')[-1], lineno)] += int(parts[2])
            skipnext = False
res = collections.Counter()
for short in FILES:
    src = subprocess.run(['git', '-C', repo, 'show', f'{rev}:src/buster/compiler/{short}'], capture_output=True, text=True).stdout.split('\n')
    starts = []
    for i, l in enumerate(src, 1):
        m = re.match(r'static .*?\b(node_machine_\w+)\(', l)
        if m and not l.rstrip().endswith(';'):
            starts.append((i, m.group(1)))
    for (fname, ln), c in cost.items():
        if fname != short:
            continue
        fn = '?'
        for s, n in starts:
            if s <= ln:
                fn = n
            else:
                break
        res[(short, fn)] += c
key = lambda short: 'type' if 'type' in short else 'contexts' if 'contexts' in short else 'expand' if 'expand' in short else 'lower' if 'lower' in short else 'shape' if 'shape' in short else 'machine'
tot = collections.Counter()
for (short, fn), c in sorted(res.items(), key=lambda kv: -kv[1]):
    per = c / nodes / runs[key(short)]
    tot[short] += per
    if per >= 0.5:
        print(f'{short:36s} {fn:36s} {per:8.1f}')
for k, v in tot.items():
    print('TOTAL', k, f'{v:.1f}')
