#!/usr/bin/env python3
# knob-table.py RESULTS LABEL: ONE executable with the update's block on and off (job-upd-knob.sh's readings, on, off,
# off, on inside each): the loop's ticks a record swept in its first run and in a second run over the same chunk, C's
# three sweeps a record swept and a record of the decided, the kernel in place; medians, and each reading's own
# difference (the two on's mean less the two off's).
import re, glob, statistics, sys
results, label = sys.argv[1], sys.argv[2]
P = {
    'the loop, a record swept, first run': r"window contexts ticks=\d+ \([\d.]+ a record swept, [\d.]+ a record of the decided\): the loop=\d+ \(([\d.]+)\)",
    'the loop, a second run over the same chunk': r"window contexts a second run over the same chunk, not counted: ticks=\d+ \([\d.]+ a record swept, [\d.]+ a record of the decided\): the loop=\d+ \(([\d.]+)\)",
    "C's three sweeps, a record swept": r"window contexts ticks=\d+ \(([\d.]+) a record swept",
    "C's three sweeps, a record of the decided": r"window contexts ticks=\d+ \([\d.]+ a record swept, ([\d.]+) a record of the decided\)",
    'the kernel in place, a record': r"the kernel in place: .* ticks=\d+ \(([\d.]+) a record\)",
}
for corpus in ('sqlite3', 'lua', 'musl'):
    n = len(glob.glob('%s/%s/contexts-on1-%s-*.txt' % (results, label, corpus)))
    print('%s: %d readings' % (corpus, n))
    for name, pat in P.items():
        on = []; off = []; diff = []
        for i in range(1, n + 1):
            v = {}
            for tag in ('on1', 'off1', 'off2', 'on2'):
                t = open('%s/%s/contexts-%s-%s-%d.txt' % (results, label, tag, corpus, i), errors='replace').read()
                v[tag] = float(re.search(pat, t).group(1))
            a = (v['on1'] + v['on2']) / 2; b = (v['off1'] + v['off2']) / 2
            on.append(a); off.append(b); diff.append(a - b)
        print('  %-44s off %6.2f  on %6.2f  each reading\'s own difference %+.2f (%+.2f to %+.2f)' % (name, statistics.median(off), statistics.median(on), statistics.median(diff), min(diff), max(diff)))
