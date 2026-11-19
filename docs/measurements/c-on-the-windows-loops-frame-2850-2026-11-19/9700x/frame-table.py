#!/usr/bin/env python3
# frame-table.py RESULTS LABEL...: job-frame.sh's readings: C's loop's user instructions, cycles, loads and stores a block of
# 64 records, in its first and its second run of a chunk, medians of the runs less the reads' own share; and whether each
# run's shadow counts are the piece's (its decided expressions and its differences).
import re, statistics, sys, glob
results = sys.argv[1]
P = r'node-loop-x: (\S+) chunks=(\d+) blocks=(\d+) records=(\d+) instructions=(\d+) cycles=(\d+) loads=(\d+) stores=(\d+)'
for corpus in ('sqlite3', 'lua'):
    for run in ('first-run', 'second-run'):
        for label in sys.argv[2:]:
            values = []; counts = set()
            for path in sorted(glob.glob('%s/%s/counters-piece-%s-*.txt' % (results, label, corpus))):
                t = open(path, errors='replace').read()
                found = {m.group(1): [int(x) for x in m.groups()[1:]] for m in re.finditer(P, t)}
                if run in found and 'no-run' in found:
                    blocks = found[run][1]
                    values.append([(found[run][3 + i] - found['no-run'][3 + i]) / blocks for i in range(4)])
                m = re.search(r'window contexts expressions=\d+ records=\d+ decided=(\d+) .*? differences=(\d+)', t)
                s = re.findall(r'^status (\d+)', t, re.M)
                counts.add((m.group(1) if m else '?', m.group(2) if m else '?', s[-1] if s else '?'))
            if values:
                r = [statistics.median(v[i] for v in values) for i in range(4)]
                print('%-8s %-10s %-6s (n=%d) instr %7.1f cycles %6.1f loads %6.1f stores %6.1f   decided/differences/status %s' % (corpus, run, label, len(values), *r, sorted(counts)))
