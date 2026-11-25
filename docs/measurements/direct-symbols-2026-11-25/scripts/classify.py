#!/usr/bin/env python3
# classify.py diffs/*.txt: each unit's symbol differences by kind.
import sys, collections
kinds = collections.Counter(); units = collections.defaultdict(set); examples = collections.defaultdict(list)
for path in sys.argv[1:]:
    lines = open(path).read().splitlines()
    unit = lines[0][2:]
    tag = unit.split()[0].split('[')[0]
    d = {}; f = {}
    for l in [x for x in lines[1:] if len(x.split()) >= 6]:
        side, rest = l[0], l[2:].split()
        (d if side == '<' else f)[rest[0]] = rest[1:]
    for name in sorted(set(d) | set(f)):
        a = d.get(name); b = f.get(name)
        if a and b:
            diffs = [k for k, x, y in zip(('bind', 'type', 'vis', 'sec'), a, b) if x != y]
            k = 'changed ' + '+'.join(diffs) + (f' {a[2]}->{b[2]}' if 'vis' in diffs else '') + (f' {a[3]}->{b[3]}' if 'sec' in diffs else '') + (f' {a[0]}->{b[0]}' if 'bind' in diffs else '')
        elif a:
            k = f'only direct ({a[0]} {a[1]} {a[3] if a[3] in ("UND",) else "defined"})'
        else:
            k = f'only full ({b[0]} {b[1]} {b[3] if b[3] in ("UND",) else "defined"})'
        kinds[(tag, k)] += 1; units[(tag, k)].add(unit)
        if len(examples[(tag, k)]) < 4: examples[(tag, k)].append(name)
for (tag, k), n in sorted(kinds.items()):
    print(f'{tag:12} {k:55} symbols {n:5}  units {len(units[(tag, k)]):4}  e.g. {" ".join(examples[(tag, k)])}')
