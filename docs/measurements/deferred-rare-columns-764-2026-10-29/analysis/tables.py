#!/usr/bin/env python3
# The record's tables (#764), as Markdown, from the campaigns' logs: tables.py KIND LOG... (KIND: d1, a5, w5, so5, b5, s5).
import re, sys, statistics, collections
fieldre = re.compile(r'(\w+)=([-\w./]+)')
def read(paths):
    runs = collections.defaultdict(list)
    for path in paths:
        cur = None
        for line in open(path, errors='replace'):
            if line.startswith('== round '):
                p = line.split()
                cur = dict(round=int(p[2]), run=p[3], unit=p[4], lanes=int(p[6]), readings=[])
                runs[(p[3], p[4], int(p[6]))].append(cur)
            elif cur is not None and line.startswith('checker-deferred: file='):
                f = dict(fieldre.findall(line))
                cur['so'] = float(f['source_order']); cur['tokens'] = int(f['tokens'])
            elif cur is not None and line.startswith('checker-deferred:   lanes=') and ' active=' in line:
                # The first `positions` is in ns/token, the second (after `ns/token,`) in ns/body.
                fields = dict(fieldre.findall(line.split(' ns/token,')[0]))
                fields.update({k: v for k, v in fieldre.findall(line.split(' ns/token,')[1]) if k != 'positions'})
                cur['readings'].append(fields)
            elif cur is not None and line.startswith('exit='):
                cur['exit'] = int(line.split()[0][5:])
    return runs
med = statistics.median
def ok(rs): return [r for r in rs if r.get('exit') == 0 and len(r['readings']) == 2]
def name(u): return '`sqlite3.c`' if u == 'sqlite' else '`%s.c`' % u
def pct(a, b): return (a / b - 1) * 100
kind = sys.argv[1]
runs = read(sys.argv[2:])
units = []
for (r, u, l) in runs:
    if u not in units: units.append(u)
if kind == 'a5':
    H, C, M = 'head-3b87d0c9-every', 'pr791-561e5f1c-every', 'main-bc11fddb-every'
    print('| Unit | Tokens | Walks on 8, head | Control | Main | Head on 8 | Control | Main | Head on 1 | Control | Main | Source order: head | Control | Main |')
    print('| --- | ---: | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |')
    for u in units:
        h, c, m = (sorted(ok(runs[(t, u, 8)]), key=lambda r: r['round']) for t in (H, C, M))
        wk = lambda rs: '%.1f (%.1f)' % (med([float(r['readings'][1]['walks']) for r in rs]), max(float(r['readings'][1]['walks']) for r in rs) - min(float(r['readings'][1]['walks']) for r in rs))
        g = lambda rs, i: med([float(r['readings'][i]['whole']) for r in rs])
        so = lambda rs: med([r['so'] for r in rs])
        print('| %s | %d | %s | %s | %s | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f |' % (name(u), h[0]['tokens'], wk(h), wk(c), wk(m), g(h, 1), g(c, 1), g(m, 1), g(h, 0), g(c, 0), g(m, 0), so(h), so(c), so(m)))
elif kind in ('w5', 'd1'):
    trees = sorted({r for (r, u, l) in runs}, key=lambda t: ['main', 'pr791', 'cols', 'multicols', 'pop', 'head'].index(t.split('-')[0]))
    print('| Unit | Tree | Walks on 8 by round (spread) | On 8 | On 1 | Source order |')
    print('| --- | --- | --- | ---: | ---: | ---: |')
    for u in units:
        for t in trees:
            rs = sorted(ok(runs[(t, u, 8)]), key=lambda r: r['round'])
            w = [float(r['readings'][1]['walks']) for r in rs]
            print('| %s | %s | %s (%.1f) | %.2f | %.2f | %.2f |' % (name(u), t.replace('-every', '').replace('-warm', ''), ' '.join('%.1f' % x for x in w), max(w) - min(w),
                  med([float(r['readings'][1]['whole']) for r in rs]), med([float(r['readings'][0]['whole']) for r in rs]), med([r['so'] for r in rs])))
elif kind == 'so5':
    H, M = 'head-3b87d0c9', 'main-bc11fddb'
    ch_so = []; ch_one = []
    print('| Unit | Source order, head | Main | Change | One lane, head | Main | Change |')
    print('| --- | ---: | ---: | ---: | ---: | ---: | ---: |')
    for u in units:
        h = ok(runs[(H, u, 1)]); m = ok(runs[(M, u, 1)])
        sh, sm = med([r['so'] for r in h]), med([r['so'] for r in m])
        oh, om = med([float(r['readings'][0]['whole']) for r in h]), med([float(r['readings'][0]['whole']) for r in m])
        ch_so.append(pct(sh, sm)); ch_one.append(pct(oh, om))
        print('| %s | %.2f | %.2f | %+.1f%% | %.2f | %.2f | %+.1f%% |' % (name(u), sh, sm, pct(sh, sm), oh, om, pct(oh, om)))
    print('\nmedian change: source order %+.2f%% (%+.1f to %+.1f), one lane %+.2f%% (%+.1f to %+.1f)' % (med(ch_so), min(ch_so), max(ch_so), med(ch_one), min(ch_one), max(ch_one)))
elif kind == 'b5':
    trees = sorted({r for (r, u, l) in runs})
    H = [t for t in trees if t.startswith('head')][0]; M = 'main-bc11fddb'
    print('| Unit | Head\'s lanes | Main\'s lanes | Head, rule against 1 | Main, the same | Head on its lanes | Main on its | Head against main |')
    print('| --- | ---: | ---: | --- | --- | ---: | ---: | ---: |')
    chs = []
    for u in units:
        h = ok(runs[(H, u, 8)]); m = ok(runs[(M, u, 8)])
        hc = [pct(float(r['readings'][1]['whole']), float(r['readings'][0]['whole'])) for r in h]
        mc = [pct(float(r['readings'][1]['whole']), float(r['readings'][0]['whole'])) for r in m]
        hm, mm = med([float(r['readings'][1]['whole']) for r in h]), med([float(r['readings'][1]['whole']) for r in m])
        chs.append(pct(hm, mm))
        print('| %s | %d | %d | %+.1f%% (%+.1f to %+.1f) | %+.1f%% (%+.1f to %+.1f) | %.2f | %.2f | %+.1f%% |' % (name(u), int(float(h[0]['readings'][1]['active'])), int(float(m[0]['readings'][1]['active'])),
              med(hc), min(hc), max(hc), med(mc), min(mc), max(mc), hm, mm, pct(hm, mm)))
    print('\nhead against main on their rules\' lanes: median %+.2f%% (%+.1f to %+.1f)' % (med(chs), min(chs), max(chs)))
elif kind == 's5':
    rows = collections.defaultdict(list)
    for (t, u, l), rs in runs.items():
        for r in ok(rs): rows[t].append(r)
    keys = ['whole', 'top', 'environment', 'lanes_span', 'walks', 'positions', 'merge', 'rest']
    print('| | ' + ' | '.join(sorted(rows)) + ' |')
    print('| --- |' + ' ---: |' * len(rows))
    print('| source order | ' + ' | '.join('%.2f (%.2f to %.2f)' % (med([r['so'] for r in rows[t]]), min(r['so'] for r in rows[t]), max(r['so'] for r in rows[t])) for t in sorted(rows)) + ' |')
    for i, lab in ((0, 'one lane'), (1, 'the rule\'s lanes')):
        for k in keys:
            print('| %s: %s | ' % (lab, k) + ' | '.join('%.2f' % med([float(r['readings'][i][k]) for r in rows[t]]) for t in sorted(rows)) + ' |')
    print('| the rule\'s lanes against source order | ' + ' | '.join('%+.1f%%' % med([pct(float(r['readings'][1]['whole']), r['so']) for r in rows[t]]) for t in sorted(rows)) + ' |')
