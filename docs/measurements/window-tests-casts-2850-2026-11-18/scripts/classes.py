#!/usr/bin/env python3
# classes.py FILE...: the census-expr lines' listed operators by class, and the listed expressions by why.
import sys, collections
KIND = ['none', 'pointer', 'signed', 'unsigned', 'zero', 'tiny', 'small', 'constant']
def kind(b):
    return KIND[(b >> 3) & 7] + ('+c' if b & 1 else '') + ('+bf' if b & 2 else '') + ('+decl' if b & 4 else '') + ('+loud' if b & 0x40 else '')
def own_class(own, width):
    if own & 0x20: return 'pointer'
    if own & 0x01: return 'void'
    if own & 0x08: return 'enum'
    if own & 0x02: return 'special'
    if own & 0x04: return 'aggregate'
    if own & 0x80: return 'array'
    if width == 64: return 'int64'
    if width: return 'int<64'
    return 'other'
SENT = [(1, 'C'), (2, 'E'), (4, 'P'), (8, 'V'), (0x10, 'A'), (0x20, 'S'), (0x40, 'Q'), (0x80, 'T')]
def sent(b):
    return ''.join(n for m, n in SENT if b & m) or '-'
for path in sys.argv[1:]:
    names = {}
    ops = collections.Counter()
    fired = collections.Counter()
    whys = collections.Counter()
    total = 0
    for line in open(path, errors='replace'):
        if line.startswith('census-op:'):
            f = dict(x.split('=', 1) for x in line.split()[1:])
            names[int(f['code'])] = f['name']
        if not line.startswith('census-expr:'):
            continue
        parts = line.split()
        f = dict(x.split('=', 1) for x in parts[1:11])
        whys[int(f['why'])] += 1
        for o in parts[11:]:
            v = o.split('.')
            op, snt, al, own, width = int(v[0]), int(v[1], 16), int(v[2], 16), int(v[3], 16), int(v[4])
            left, right = int(v[5], 16), int(v[6], 16)
            trigger, always, tests = int(v[9]), int(v[10]), int(v[13], 16)
            key = (op, sent(snt), kind(left), kind(right), own_class(own, width) if op == 24 else '')
            ops[key] += 1
            total += 1
            if tests != 0 or trigger != 16 and False:
                fired[key] += 1
            fired[(key, 'trigger')] += trigger
    print('==', path.split('/')[-1], 'listed operators', total)
    for key, n in ops.most_common(int(__import__("os").environ.get("TOP", "30"))):
        print('%6d %5.1f%% fired=%d  %s sent=%s left=%s right=%s %s' % (n, 100.0 * n / total, fired[key], names.get(key[0], key[0]), key[1], key[2], key[3], key[4]))
    print('whys', sorted(whys.items()))
