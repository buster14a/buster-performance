#!/usr/bin/env python3
# Campaign A5's comparisons, from its log (runs.sh's headings and benchmark-checker-deferred's lines): for each unit, the
# eight-lane walks of the head, the base-page control and main in each round, their lowest, highest and spread; the
# eight-lane and one-lane readings of each tree (the medians of the rounds); and source order's reading in the processes
# of each tree. Then the medians over the units of the trees' changes against main.
#   a5sum.py HEAD CONTROL MAIN LOG...
import re, sys, statistics, collections
head, control, main = sys.argv[1:4]
fieldre = re.compile(r'(\w+)=([-\w./]+)')
runs = collections.defaultdict(list)
for path in sys.argv[4:]:
    cur = None
    for line in open(path, errors='replace'):
        if line.startswith('== round '):
            p = line.split()
            cur = dict(round=int(p[2]), run=p[3], unit=p[4], lanes=int(p[6]), readings=[])
            runs[(p[3], p[4], int(p[6]))].append(cur)
        elif cur is not None and line.startswith('checker-deferred: file='):
            f = dict(fieldre.findall(line))
            cur['so'] = float(f['source_order'])
        elif cur is not None and line.startswith('checker-deferred:   lanes=') and ' active=' in line:
            cur['readings'].append({k: v for k, v in fieldre.findall(line)})
        elif cur is not None and line.startswith('exit='):
            cur['exit'] = int(line.split()[0][5:])
def ok(rs):
    return [r for r in rs if r.get('exit') == 0 and len(r['readings']) == 2]
def num(r, i, k):
    return float(r['readings'][i][k].split('/')[0])
units = []
for (run, unit, lanes) in runs:
    if unit not in units:
        units.append(unit)
med = statistics.median
changes = collections.defaultdict(list)
print('%-16s | %-38s | %-38s | %-38s | %7s %7s %7s | %7s %7s %7s | %6s %6s %6s' % ('unit', 'head walks on 8 (spread)', 'control walks on 8 (spread)', 'main walks on 8 (spread)',
      'head8', 'ctl8', 'main8', 'head1', 'ctl1', 'main1', 'soH', 'soC', 'soM'))
for unit in units:
    row = {}
    for name, tree in (('h', head), ('c', control), ('m', main)):
        rs = sorted(ok(runs.get(('%s-every' % tree, unit, 8), [])), key=lambda r: r['round'])
        walks = [num(r, 1, 'walks') for r in rs]
        row[name] = dict(walks=walks, many=med([num(r, 1, 'whole') for r in rs]) if rs else float('nan'),
                         one=med([num(r, 0, 'whole') for r in rs]) if rs else float('nan'), so=med([r['so'] for r in rs]) if rs else float('nan'))
    w = lambda d: ('%s (%.1f)' % (' '.join('%.1f' % x for x in d['walks']), max(d['walks']) - min(d['walks']))) if d['walks'] else '-'
    print('%-16s | %-38s | %-38s | %-38s | %7.2f %7.2f %7.2f | %7.2f %7.2f %7.2f | %6.2f %6.2f %6.2f' % (unit, w(row['h']), w(row['c']), w(row['m']),
          row['h']['many'], row['c']['many'], row['m']['many'], row['h']['one'], row['c']['one'], row['m']['one'], row['h']['so'], row['c']['so'], row['m']['so']))
    for k in ('many', 'one', 'so'):
        for name in ('h', 'c'):
            if row[name][k] == row[name][k] and row['m'][k] == row['m'][k]:
                changes[(name, k)].append(row[name][k] / row['m'][k] - 1)
    if row['h']['walks'] and row['c']['walks']:
        changes[('spread', 'h')].append(max(row['h']['walks']) - min(row['h']['walks']))
        changes[('spread', 'c')].append(max(row['c']['walks']) - min(row['c']['walks']))
        changes[('spread', 'm')].append(max(row['m']['walks']) - min(row['m']['walks'])) if row['m']['walks'] else None
q = lambda v: '%+.1f%% (%+.1f to %+.1f, %d units)' % (med(v) * 100, min(v) * 100, max(v) * 100, len(v)) if v else '-'
print()
for k, label in (('many', 'eight lanes'), ('one', 'one lane'), ('so', 'source order')):
    print('against main, %-13s: head %s; control %s' % (label, q(changes[('h', k)]), q(changes[('c', k)])))
for name in ('h', 'c', 'm'):
    v = changes[('spread', name)]
    if v:
        print('walks spread on 8 lanes, %s: median %.2f, highest %.2f ns/token' % ({'h': 'head', 'c': 'control', 'm': 'main'}[name], med(v), max(v)))
