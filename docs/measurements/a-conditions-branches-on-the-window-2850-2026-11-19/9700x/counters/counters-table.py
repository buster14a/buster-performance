#!/usr/bin/env python3
# counters-table.py RESULTS: job-loop-counters.sh's readings: the loop's user instructions, cycles, loads and stores
# dispatched a block of 64 records, in its first and its second run of a chunk, for the build before, the piece's, and
# the switch's executable off and on; medians of the runs, less the reads' own share (the run around nothing).
import re, statistics, sys, glob
results = sys.argv[1]
specs = (('before', 'upd4c'), ('piece', 'br2c'), ('off', 'br2xc'), ('on', 'br2xc'))
P = r'node-loop-x: (\S+) chunks=(\d+) blocks=(\d+) records=(\d+) instructions=(\d+) cycles=(\d+) loads=(\d+) stores=(\d+)'
for corpus in ('sqlite3', 'lua', 'musl'):
    print(corpus)
    for run in ('first-run', 'second-run'):
        rows = {}
        for tag, label in specs:
            values = []
            for path in sorted(glob.glob('%s/%s/counters-%s-%s-*.txt' % (results, label, tag, corpus))):
                t = open(path, errors='replace').read()
                found = {m.group(1): [int(x) for x in m.groups()[1:]] for m in re.finditer(P, t)}
                if run in found and 'no-run' in found:
                    chunks, blocks, records = found[run][:3]
                    values.append([(found[run][3 + i] - found['no-run'][3 + i]) / blocks for i in range(4)] + [blocks, records])
            rows[tag] = [statistics.median(v[i] for v in values) for i in range(6)] if values else None
        for tag, _ in specs:
            r = rows[tag]
            if r:
                print('   %-10s %-6s a block: instructions %7.1f  cycles %6.1f  loads %6.1f  stores %6.1f   (blocks %d, records %d)' % (run, tag, r[0], r[1], r[2], r[3], r[4], r[5]))
        if rows['before'] and rows['piece'] and rows['off'] and rows['on']:
            d = lambda a, b: '  '.join('%+.1f' % (rows[a][i] - rows[b][i]) for i in range(4))
            print('   %-10s piece less before: %s;  off less before: %s;  on less off: %s' % (run, d('piece', 'before'), d('off', 'before'), d('on', 'off')))
