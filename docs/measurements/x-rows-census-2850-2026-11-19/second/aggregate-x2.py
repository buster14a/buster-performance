#!/usr/bin/env python3
# aggregate-x.py OUT: the X census's lines (xx:, from stdin) as unique rows with their counts: each record's features and
# its row's three parts (own, conversion, after). A tab-separated file, one row a unique combination.
import sys, re, collections
out = sys.argv[1]
rows = collections.Counter()
records = 0; expressions = set()
P = re.compile(r'xx: e=(\d+) r=(\d+) n=(\d+) op=(\d+) tpl=(\d+) w=([0-9a-f]+) st=([0-9a-f]+) fl=([0-9a-f]+) ctx=([0-9a-f]+) state=([0-9a-f]+) tw=([0-9a-f]+) same=(\d+) c0=([0-9a-f]+) c1=([0-9a-f]+) ob=([0-9a-f]+) off=(\d+) mo=(\d+) fold=(\d+) up=([0-9a-f]+) uk=([0-9a-f]+) hop=(\d+) hw=([0-9a-f]+) hc0=([0-9a-f]+) last=(\d+) \| own=(\S+) conv=(\S+) after=(\S+)')
for line in sys.stdin:
    if not line.startswith('xx: '):
        continue
    m = P.match(line)
    if not m:
        sys.stderr.write('unparsed: ' + line[:200] + '\n')
        continue
    g = m.groups()
    records += 1
    w = int(g[5], 16); st = int(g[6], 16); fl = int(g[7], 16); tw = int(g[10], 16); c0 = int(g[12], 16); c1 = int(g[13], 16); hw = int(g[21], 16); hc0 = int(g[22], 16)
    key = (int(g[3]), int(g[4]), w & 0xff, (w >> 8) & 0xff, (w >> 16) & 0xff, st & 3, (st >> 2) & 7, (st >> 5) & 7, fl & 0xffff, int(g[8], 16), int(g[9], 16), tw & 0xff, (tw >> 8) & 0xff,
           int(g[11]), c0 & 0xff, (c0 >> 8) & 0xff, c1 & 0xff, (c1 >> 8) & 0xff, int(g[14], 16), int(g[15]), int(g[16]), int(g[17]), int(g[18], 16), int(g[19], 16), int(g[20]), hw & 0xff, hc0 & 0xff,
           int(g[23]), g[24], g[25], g[26])
    rows[key] += 1
names = ['op', 'tpl', 'class', 'facts', 'kind', 'category', 'constant', 'standing_high', 'flags', 'ctx', 'state', 'tclass', 'tfacts', 'same', 'c0class', 'c0facts', 'c1class', 'c1facts', 'ob', 'off', 'mo',
         'fold', 'up', 'uk', 'hop', 'hclass', 'hc0class', 'last', 'own', 'conv', 'after']
with open(out, 'w') as f:
    f.write('count\t' + '\t'.join(names) + '\n')
    for key, n in sorted(rows.items(), key=lambda kv: -kv[1]):
        f.write('%d\t%s\n' % (n, '\t'.join(str(x) for x in key)))
sys.stderr.write('records %d, unique rows %d\n' % (records, len(rows)))
