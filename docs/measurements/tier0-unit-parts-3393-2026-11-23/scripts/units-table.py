# units-table.py DIR: per corpus (lua, musl), the sum over files of each file's median (over rounds) of the four stages.
import collections, glob, os, re, statistics, sys
stages = ['emit-setup', 'code-atoms', 'publish-data', 'object-build']
runs = collections.defaultdict(list)
for path in glob.glob(os.path.join(sys.argv[1], '*-[0-9]*.txt')):
    name = os.path.basename(path)
    if name.startswith('objects'):
        continue
    unit = name.rsplit('-', 1)[0]
    total = 0.0
    for line in open(path):
        p = line.split('\t')
        if len(p) > 2 and p[0] == 'time-stage' and p[1] in stages:
            total += float(p[2])
    runs[unit].append(total)
sums = collections.defaultdict(float)
counts = collections.Counter()
for unit, values in runs.items():
    sums[unit.split('-')[0]] += statistics.median(values)
    counts[unit.split('-')[0]] += 1
for corpus in sorted(sums):
    print('%s\t%d units\t%.3f ms' % (corpus, counts[corpus], sums[corpus]))
