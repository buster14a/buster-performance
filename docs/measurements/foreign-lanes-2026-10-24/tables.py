# The design's tables from the sweep's logs: each phase's medians by lane count, and its limit.
import re, statistics, sys
data = {}
for path in sys.argv[1:]:
    cur = None; lanes = None
    for line in open(path):
        m = re.match(r'== lanes (\d+) run (\d+)', line)
        if m:
            lanes = int(m.group(1)); continue
        m = re.match(r'link-foreign: ([\d.]+) ms', line)
        if m:
            cur = {'total': float(m.group(1))}; data.setdefault(lanes, []).append(cur); continue
        if cur is None:
            continue
        m = re.match(r'  (\S+)\s+([\d.]+) ms(.*)', line)
        if m:
            cur[m.group(1)] = float(m.group(2))
            for k, v in re.findall(r'(\S+) ([\d.]+)', m.group(3)):
                cur[m.group(1) + '.' + k] = float(v)
order = sorted(data)
rows = [
    ('The whole link', 'total'), ('Resolution', 'resolve'), ('resolution: open', 'resolve.open'), ('resolution: indices', 'resolve.indices'),
    ('resolution: headers', 'resolve.headers'), ('resolution: symbols', 'resolve.symbols'), ('resolution: exchange', 'resolve.exchange'),
    ('resolution: resolve', 'resolve.resolve'), ('resolution: groups', 'resolve.groups'), ('resolution: winners', 'resolve.winners'),
    ('Conversion', 'convert'), ('conversion: sections', 'convert.sections'), ('conversion: names', 'convert.names'), ('conversion: maps', 'convert.maps'),
    ('conversion: relocations', 'convert.relocations'), ('conversion: copies', 'convert.copies'), ('conversion: check', 'convert.check'),
    ('conversion: exports', 'convert.exports'), ('Write', 'write'), ('write: lanes and symbols', 'write.lanes+symbols'), ('write: count', 'write.count'),
    ('write: dynamic', 'write.dynamic'), ('write: chunks', 'write.chunks'), ('Release', 'release'),
]
med = {k: [statistics.median(r.get(k, 0) for r in data[l]) for l in order] for _, k in rows}
def cell(v):
    return ('%.2f' % v) if v >= 1 else ('%.3f' % v)
print('| Phase | ' + ' | '.join(str(l) for l in order) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in order) + ' |')
for name, k in rows:
    row = med[k]
    best = min(range(len(row)), key=lambda i: row[i])
    print('| ' + name + ' | ' + ' | '.join(('**' + cell(v) + '**') if i == best else cell(v) for i, v in enumerate(row)) + ' |')
print()
print('| Phase | 1 lane | Fastest | Within 3% from |')
print('| --- | ---: | ---: | ---: |')
sequential = {'convert.sections', 'convert.copies', 'convert.exports', 'release'}
for name, k in rows:
    row = med[k]
    best = min(range(len(row)), key=lambda i: row[i])
    knee = next(i for i in range(len(row)) if row[i] <= 1.03 * row[best])
    if k in sequential:
        print('| %s | %s ms | not on lanes | 1 |' % (name, cell(row[0])))
    else:
        print('| %s | %s ms | %s ms on %d | %d |' % (name, cell(row[0]), cell(row[best]), order[best], order[knee]))
