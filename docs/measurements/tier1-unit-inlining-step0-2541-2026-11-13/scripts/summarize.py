#!/usr/bin/env python3
# summarize.py RESULTS: medians of the self-built compilers' runs (results/selfhost/runs.tsv) by workload and build, and
# speedtest1's placements (results/place/runs.tsv): per placement the median of head's and main's measured rounds, and
# 100 ln(head / main) of user cycles with a 95% t interval over the placements. Prints Markdown tables.
import sys, math, statistics, collections
root = sys.argv[1]
rows = [l.rstrip('\n').split('\t') for l in open(root + '/selfhost/runs.tsv') if l.strip()]
by = collections.defaultdict(list)
for p, r, w, b, clock, cycles, ins, br, miss, code in rows:
    if p == 'measured' and code == '0':
        by[(w, b)].append((float(clock), int(cycles), int(ins)))
print('| workload | build | runs | task-clock ms | user cycles, M | instructions, M |')
print('| --- | --- | ---: | ---: | ---: | ---: |')
for (w, b), v in sorted(by.items()):
    print('| %s | %s | %d | %.1f | %.1f | %.1f |' % (w, b, len(v), statistics.median(x[0] for x in v), statistics.median(x[1] for x in v) / 1e6, statistics.median(x[2] for x in v) / 1e6))
try:
    rows = [l.rstrip('\n').split('\t') for l in open(root + '/place/runs.tsv') if l.strip()]
except FileNotFoundError:
    rows = []
if rows:
    by = collections.defaultdict(list)
    for p, r, s, t, clock, cycles, ins, br, miss, code in rows:
        if p == 'measured' and code == '0':
            by[(int(s), t)].append((int(cycles), int(ins)))
    shifts = sorted({s for s, t in by})
    d = []
    print('\n| placement | main cycles, M | head cycles, M | 100 ln(head/main) | main instr, M | head instr, M |')
    print('| ---: | ---: | ---: | ---: | ---: | ---: |')
    for s in shifts:
        m = statistics.median(x[0] for x in by[(s, 'main')]); h = statistics.median(x[0] for x in by[(s, 'head')])
        mi = statistics.median(x[1] for x in by[(s, 'main')]); hi = statistics.median(x[1] for x in by[(s, 'head')])
        d.append(100 * math.log(h / m))
        print('| %d | %.1f | %.1f | %+.2f | %.1f | %.1f |' % (s, m / 1e6, h / 1e6, d[-1], mi / 1e6, hi / 1e6))
    n = len(d); mean = statistics.mean(d); sd = statistics.stdev(d) if n > 1 else 0
    t = {8: 2.365, 7: 2.447, 6: 2.571, 5: 2.776, 4: 3.182}.get(n, 2.0)
    print('\nmean 100 ln(head/main) %+.2f, 95%% interval %+.2f to %+.2f over %d placements; head faster at %d of %d' % (mean, mean - t * sd / math.sqrt(n), mean + t * sd / math.sqrt(n), n, sum(1 for x in d if x < 0), n))
