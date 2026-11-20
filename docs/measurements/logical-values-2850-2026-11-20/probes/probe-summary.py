#!/usr/bin/env python3
# probe-summary.py BASELINE CASES: the logical piece's probes by what the window makes of each one's statement, beside
# the baseline's (the same function with an empty statement): taken whole, listed for C, listed for X, or refused.
import re, sys, collections
def parse(line):
    m = re.match(r'(\S+)\s+status (\d+)  C: expr (\d+) decided (\d+) refused (\d+) diff (\d+) \| rows: expr (\d+) taken (\d+) entries (\d+) diff (\d+) \| listed upd (\d+) br (\d+) conv (\d+) float (\d+) .* numbered (\d+)', line)
    return (m.group(1),) + tuple(int(m.group(i)) for i in range(2, 16)) if m else None
base = parse(open(sys.argv[1]).readline())
b_listed_c, b_refused, b_listed_x = base[2] - base[3], base[4], base[6] - base[7]
c = collections.Counter(); notes = collections.defaultdict(list); numbered = collections.Counter()
for line in open(sys.argv[2]):
    r = parse(line)
    if not r or r[0] == 'baseline': continue
    name = r[0]; g = re.sub(r'_(at_)?\d+$', '', name)
    listed_c, refused, listed_x = r[2] - r[3] - b_listed_c, r[4] - b_refused, r[6] - r[7] - b_listed_x
    kind = 'refused' if refused > 0 else 'listed for C' if listed_c > 0 else 'listed for X' if listed_x > 0 else 'whole'
    c[(g, kind)] += 1
    numbered[g] += r[14] > 0
    if kind != 'whole': notes[g].append('%s:%s' % (name.split('_')[-1], {'refused': 'R', 'listed for C': 'C', 'listed for X': 'X'}[kind]))
for k, v in sorted(c.items()): print('%-12s %-13s %d' % (k[0], k[1], v))
print('numbered:', dict(numbered))
for g in ('comma', 'conditional', 'logical'): print(g, 'not whole:', ' '.join(notes[g]))
for g in notes:
    if g not in ('comma', 'conditional', 'logical'): print(g, 'not whole at:', ' '.join(n.split(':')[0] for n in notes[g]))
