#!/usr/bin/env python3
# Summarizes a campaign's log (runs.sh's headings "== round R RUN UNIT lanes L" and benchmark-checker-deferred's lines)
# by unit and run: for source order and the one-lane and many-lane readings, the median of the rounds' figures (each
# round's a process's median of its passes), and for the many-lane walks every round's figure, their lowest, highest
# and spread (highest less lowest), in nanoseconds per token.
#   dsum.py LOG... [--runs RUN,...] [--units UNIT,...]
import re, sys, statistics, collections
args = [a for a in sys.argv[1:] if not a.startswith('--')]
opts = dict(a[2:].split('=', 1) for a in sys.argv[1:] if a.startswith('--') and '=' in a)
runs_order = opts.get('runs', '').split(',') if 'runs' in opts else None
units_order = opts.get('units', '').split(',') if 'units' in opts else None
fieldre = re.compile(r'(\w+)=([-\w./]+)')
def fields(line):
    return {m.group(1): m.group(2) for m in fieldre.finditer(line)}
def num(v):
    try:
        return float(v.split('/')[0])
    except (ValueError, AttributeError):
        return None
data = collections.OrderedDict()
for path in args:
    head = None
    for line in open(path, errors='replace'):
        line = line.rstrip('\n')
        if line.startswith('== round '):
            p = line.split()
            head = dict(round=int(p[2]), run=p[3], unit=p[4], lanes=int(p[6]))
            cur = dict(head)
            cur['readings'] = []
            data.setdefault((p[3], p[4]), []).append(cur)
        elif head is not None and line.startswith('checker-deferred: file='):
            f = fields(line)
            cur['so'] = num(f.get('source_order'))
            cur['tokens'] = int(f.get('tokens', '0'))
        elif head is not None and line.startswith('checker-deferred:   lanes=') and ' active=' in line:
            cur['readings'].append(fields(line))
        elif head is not None and line.startswith('exit='):
            cur['exit'] = int(line.split()[0][5:])
def med(xs):
    xs = [x for x in xs if x is not None]
    return statistics.median(xs) if xs else float('nan')
units = collections.OrderedDict()
for (run, unit), rs in data.items():
    units.setdefault(unit, collections.OrderedDict())[run] = rs
order_units = units_order or list(units)
for unit in order_units:
    if unit not in units:
        continue
    runs = units[unit]
    print('%s (%d tokens)' % (unit, next(iter(runs.values()))[0].get('tokens', 0)))
    print('  %-26s %3s %7s | %7s %7s %6s %6s %6s | %7s %7s %7s %6s %6s %6s | %s' % ('run', 'n', 'so', '1:whole', 'top', 'walks', 'merge', 'rest', 'L:whole', 'top', 'walks', 'span', 'merge', 'rest', 'L walks by round (low..high, spread)'))
    for run in (runs_order or list(runs)):
        rs = runs.get(run)
        if not rs:
            continue
        ok = [r for r in rs if r.get('exit') == 0 and len(r['readings']) == 2]
        g = lambda i, k: med([num(r['readings'][i].get(k)) for r in ok])
        walks = [num(r['readings'][1].get('walks')) for r in sorted(ok, key=lambda r: r['round'])]
        spread = (max(walks) - min(walks)) if walks else float('nan')
        print('  %-26s %3d %7.2f | %7.2f %7.2f %6.2f %6.2f %6.2f | %7.2f %7.2f %7.2f %6.2f %6.2f %6.2f | %s (%.2f..%.2f, %.2f)' % (
            run, len(ok), med([r.get('so') for r in ok]), g(0, 'whole'), g(0, 'top'), g(0, 'walks'), g(0, 'merge'), g(0, 'rest'),
            g(1, 'whole'), g(1, 'top'), g(1, 'walks'), g(1, 'lanes_span'), g(1, 'merge'), g(1, 'rest'),
            ' '.join('%.1f' % w for w in walks), min(walks) if walks else float('nan'), max(walks) if walks else float('nan'), spread))
        bad = [r for r in rs if r.get('exit') != 0 or len(r['readings']) != 2]
        if bad:
            print('    %d failed or incomplete: %s' % (len(bad), ', '.join('round %d exit %s' % (r['round'], r.get('exit')) for r in bad)))
