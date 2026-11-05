#!/usr/bin/env python3
# #872: medians over a campaign's rounds, per unit and tree, and each merge's change against its parent.
#   m872sum.py LOG [PAIR...]   (PAIR is PARENT:CHILD, e.g. base:m754)
import collections, re, statistics, sys

log = sys.argv[1]
pairs = [p.split(':') for p in sys.argv[2:]]
runs = collections.defaultdict(list)   # (tree, unit) -> list of dicts
tokens = {}
cur = None
for line in open(log, errors='replace'):
    if line.startswith('== round '):
        p = line.split()
        cur = dict(name=p[3], unit=p[4], round=int(p[2]))
        runs[(p[3], p[4])].append(cur)
    elif cur is not None and line.startswith('checker-deferred: file='):
        tokens[cur['unit']] = int(re.search(r'tokens=(\d+)', line).group(1))
        cur['source'] = float(re.search(r'source_order=([\d.]+)', line).group(1))
    elif cur is not None and line.startswith('checker-deferred:   lanes='):
        m = re.match(r'checker-deferred:   lanes=(\d+) active=(\d+) .*whole=([\d.]+) top=([\d.]+) environment=([\d.]+) walks=([\d.]+) positions=([\d.]+) lanes_span=([\d.]+) merge=([\d.]+) rest=([\d.]+)', line)
        if m:
            cur[int(m.group(1))] = dict(active=int(m.group(2)), whole=float(m.group(3)), top=float(m.group(4)),
                                        environment=float(m.group(5)), walks=float(m.group(6)),
                                        positions=float(m.group(7)), lanes_span=float(m.group(8)),
                                        merge=float(m.group(9)), rest=float(m.group(10)))
    elif cur is not None and line.startswith('exit='):
        cur['exit'] = line.split()[0]

def med(tree, unit, key, field=None):
    vals = []
    for r in runs.get((tree, unit), []):
        if key not in r or 'exit' not in r or r['exit'] != 'exit=0':
            continue
        v = r[key]
        vals.append(v[field] if field else v)
    return statistics.median(vals) if vals else float('nan')

units = sorted(tokens, key=lambda u: tokens[u])
trees = sorted({t for (t, _) in runs})
bad = [(k, r.get('exit')) for k, rs in runs.items() for r in rs if r.get('exit') != 'exit=0']
print('units:', ' '.join(units))
print('trees:', ' '.join(trees))
print(f'runs: {sum(len(v) for v in runs.values())}, failed: {bad[:5]}')

for metric, key, field in [('source order', 'source', None), ('deferred, one lane', 1, 'whole'), ('deferred, by the rule', 8, 'whole')]:
    print(f'\n## {metric} (ns/token medians)')
    print('| Unit | Tokens | ' + ' | '.join(trees) + ' |')
    print('| --- | ---: | ' + ' | '.join('---:' for _ in trees) + ' |')
    for unit in units:
        print(f'| `{unit}.c` | {tokens[unit]} | ' + ' | '.join(f'{med(t, unit, key, field):.2f}' for t in trees) + ' |')

if pairs:
    for parent, child in pairs:
        print(f'\n## {parent} -> {child}: change of the medians')
        print('| Unit | Tokens | Source order | One lane | By the rule | One-lane walks | One-lane merge | One-lane rest |')
        print('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
        ssrc, sone, srule = [], [], []
        for unit in units:
            src = 100 * (med(child, unit, 'source') / med(parent, unit, 'source') - 1)
            one = 100 * (med(child, unit, 1, 'whole') / med(parent, unit, 1, 'whole') - 1)
            rule = 100 * (med(child, unit, 8, 'whole') / med(parent, unit, 8, 'whole') - 1)
            w = 100 * (med(child, unit, 1, 'walks') / med(parent, unit, 1, 'walks') - 1)
            mg = 100 * (med(child, unit, 1, 'merge') / med(parent, unit, 1, 'merge') - 1)
            rs = 100 * (med(child, unit, 1, 'rest') / med(parent, unit, 1, 'rest') - 1)
            print(f'| `{unit}.c` | {tokens[unit]} | {src:+.1f}% | {one:+.1f}% | {rule:+.1f}% | {w:+.1f}% | {mg:+.1f}% | {rs:+.1f}% |')
            ssrc.append(src); sone.append(one); srule.append(rule)
        print(f'| median | | {statistics.median(ssrc):+.1f}% | {statistics.median(sone):+.1f}% | {statistics.median(srule):+.1f}% | | | |')

# Weighted whole-unit totals, as one compile of all units would see them.
print('\n## Token-weighted totals (sum of tokens * median ns/token)')
print('| Tree | Source order | One lane | By the rule |')
print('| --- | ---: | ---: | ---: |')
for t in trees:
    def total(key, field):
        return sum(tokens[u] * med(t, u, key, field) for u in units)
    base_src = total('source', None)
    base_one = total(1, 'whole')
    base_rule = total(8, 'whole')
    print(f'| {t} | {base_src/1e6:.2f} ms | {base_one/1e6:.2f} ms | {base_rule/1e6:.2f} ms |')
