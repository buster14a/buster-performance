#!/usr/bin/env python3
"""#874 E2 summary: per unit, the merge pass's store faults and the 2 MB regions two threads met at.

e2summary.py OPS DIR UNIT...
A fault is a store when its instruction writes memory (the last operand is memory, and it isn't
a compare or test). Only faults whose instruction's symbol is check_deferred_pass* count; regions
where more than one thread took such a store fault at one 4 KB page each within 100 us are the
huge page's first write, which no thread repeats once the region is mapped.
"""
import collections
import gzip
import os
import re
import sys

WINDOW = 100e-6
ops_path, directory, units = sys.argv[1], sys.argv[2], sys.argv[3:]


def operands(text):
    out, depth, cur = [], 0, ''
    for ch in text:
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        if ch == ',' and depth == 0:
            out.append(cur)
            cur = ''
        else:
            cur += ch
    if cur.strip():
        out.append(cur)
    return [o.strip() for o in out]


kind = {}
for line in open(ops_path):
    parts = line.split(None, 3)
    if len(parts) < 3:
        continue
    tree, ip = parts[0], int(parts[1], 16)
    mnemonic = parts[2]
    args = operands(parts[3].strip()) if len(parts) > 3 else []
    memory = [i for i, o in enumerate(args) if '(' in o]
    if not memory:
        k = 'other'
    elif memory[-1] == len(args) - 1 and not re.match(r'(cmp|test|vptest|kortest|ucomis|comis|bt\b)', mnemonic):
        k = 'store'
    else:
        k = 'load'
    kind[(tree, ip)] = k


def summary(path, tree):
    stores = collections.defaultdict(list)
    total = 0
    for line in gzip.open(path, 'rt', errors='replace'):
        p = line.split()
        if len(p) < 6 or '/' not in p[0] or not p[1].endswith(':'):
            continue
        sym = p[-1]
        if 'check_deferred_pass' not in sym:
            continue
        address, ip = int(p[2], 16), int(p[-2], 16)
        if not (0 < address < 0x800000000000):
            continue
        if kind.get((tree, ip)) != 'store':
            continue
        stores[address >> 21].append((float(p[1][:-1]), int(p[0].split('/')[1]), address >> 12))
        total += 1
    met = 0
    for events in stores.values():
        events.sort()
        i = 0
        while i < len(events):
            j = i
            while j < len(events) and events[j][0] - events[i][0] <= WINDOW:
                j += 1
            burst = events[i:j]
            per = collections.Counter(e[1] for e in burst)
            pages = collections.defaultdict(set)
            for _, tid, page in burst:
                pages[tid].add(page)
            if len(per) > 1 and max(len(v) for v in pages.values()) == 1:
                met += 1
            i = j
    return total, met


print('| Unit | Fix pass stores | Fix regions | Control pass stores | Control regions |')
print('| --- | ---: | ---: | ---: | ---: |')
for unit in units:
    fix = summary(os.path.join(directory, f'faults-fix-{unit}.txt.gz'), 'fix')
    control = summary(os.path.join(directory, f'faults-control-{unit}.txt.gz'), 'control')
    print(f'| `{unit}.c` | {fix[0]} | {fix[1]} | {control[0]} | {control[1]} |')
