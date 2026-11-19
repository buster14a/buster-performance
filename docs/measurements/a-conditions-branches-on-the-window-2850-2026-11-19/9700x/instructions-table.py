#!/usr/bin/env python3
# instructions-table.py RESULTS: job-br-instructions.sh's readings: whole runs' user instructions, cycles and branch
# misses for the build before, the piece's build and the switch's executable off and on; medians of five, and the
# differences a record swept.
import re, statistics, sys
results = sys.argv[1]
def read(tag, corpus, n):
    perf = open('%s/br1x/instructions-%s-%s-%d.txt.perf' % (results, tag, corpus, n)).read()
    out = open('%s/br1x/instructions-%s-%s-%d.txt' % (results, tag, corpus, n), errors='replace').read()
    v = {}
    for line in perf.split('\n'):
        f = line.split(',')
        if len(f) > 2 and f[0].isdigit():
            v[f[2]] = int(f[0])
    v['swept'] = int(re.search(r'records-swept=(\d+)', out).group(1))
    return v
for corpus in ('sqlite3', 'lua'):
    rows = {tag: [read(tag, corpus, n) for n in range(1, 6)] for tag in ('before', 'piece', 'off', 'on')}
    swept = rows['before'][0]['swept']
    print('%s: records swept %d' % (corpus, swept))
    for tag in ('before', 'piece', 'off', 'on'):
        ins = [r['instructions:u'] for r in rows[tag]]; cyc = [r['cycles:u'] for r in rows[tag]]; mis = [r['branch-misses:u'] for r in rows[tag]]
        print('   %-6s instructions %d (%d to %d)  cycles %d (%d to %d)  branch misses %d' % (tag, statistics.median(ins), min(ins), max(ins), statistics.median(cyc), min(cyc), max(cyc), statistics.median(mis)))
    med = lambda tag, key: statistics.median(r[key] for r in rows[tag])
    for a, b in (('off', 'before'), ('on', 'off'), ('piece', 'before'), ('on', 'piece')):
        print('   %s less %s: instructions %+d (%+.2f a record swept); cycles %+d (%+.2f a record swept)' % (a, b, med(a, 'instructions:u') - med(b, 'instructions:u'), (med(a, 'instructions:u') - med(b, 'instructions:u')) / swept, med(a, 'cycles:u') - med(b, 'cycles:u'), (med(a, 'cycles:u') - med(b, 'cycles:u')) / swept))
