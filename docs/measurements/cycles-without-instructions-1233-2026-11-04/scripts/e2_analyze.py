#!/usr/bin/env python3
"""#1233 E2: from e2_reduce.py's CSV (gzip), each event's samples per process by function, M, H and A (warm-ups left
out): the functions whose merge-minus-main difference is largest, A's beside it for the floor, and where the function
sits in each build (its address modulo 64). Usage: e2_analyze.py functions.csv.gz [ROWS]."""
import sys, csv, gzip, collections, statistics as st
procs = collections.defaultdict(set); counts = collections.defaultdict(lambda: collections.defaultdict(float))
addr = {}; totals = collections.defaultdict(lambda: collections.defaultdict(list)); pertotal = collections.defaultdict(float)
for row in csv.DictReader(gzip.open(sys.argv[1], 'rt')):
    if row['run'] == '0':
        continue
    b, key, ev, n = row['build'], (row['function'], int(row['occurrence'])), row['event'], int(row['count'])
    procs[b].add(row['run']); counts[ev][(b, key)] += n; pertotal[(ev, b, row['run'])] += n
    addr[(b, key)] = int(row['address'], 16)
for (ev, b, r), n in pertotal.items():
    totals[ev][b].append(n)
print('processes', {b: len(r) for b, r in procs.items()})
for ev in counts:
    print(f'== {ev}: samples per process, M {st.mean(totals[ev]["M"]):.1f}, H {st.mean(totals[ev]["H"]):.1f}, A {st.mean(totals[ev]["A"]):.1f}')
    keys = {k for (b, k) in counts[ev]}
    rows = []
    for k in keys:
        s = {b: counts[ev].get((b, k), 0) / len(procs[b]) for b in 'MHA'}
        rows.append((s['H'] - s['M'], s['A'] - s['M'], s['M'], k))
    for dh, da, m, k in sorted(rows, key=lambda x: -abs(x[0]))[:int(sys.argv[2]) if len(sys.argv) > 2 else 25]:
        am, ah = addr.get(('M', k), 0), addr.get(('H', k), 0)
        where = f'{am % 64:2d}->{ah % 64:2d} mod 64' if am and ah else ''
        print(f'  {k[0][:44]:44s}#{k[1]} M {m:9.1f} H {dh:+8.1f} ({100 * dh / m if m else 0:+6.1f}%) A {da:+8.1f} ({100 * da / m if m else 0:+6.1f}%)  {where}')
