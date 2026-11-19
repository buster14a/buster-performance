# Medians of perf stat -x, CSVs by label: user and kernel cycles, user instructions, faults, task-clock.
import sys, glob, os, statistics, collections, re
d = sys.argv[1]
rows = collections.defaultdict(lambda: collections.defaultdict(list))
for path in glob.glob(os.path.join(d, 'perf-*.csv')):
    label = re.sub(r'\.\d+\.csv$', '', os.path.basename(path))[5:].replace('.csv', '')
    for line in open(path):
        f = line.strip().split(',')
        if len(f) < 3 or f[0].startswith('#') or not f[0]:
            continue
        try:
            v = float(f[0])
        except ValueError:
            continue
        rows[label][f[2]].append(v)
def med(label, ev):
    v = rows[label].get(ev, [])
    return statistics.median(v) if v else float('nan')
print(f"{'label':22} {'n':>2} {'wall-ms(task)':>13} {'Mcyc user':>10} {'Mcyc kern':>10} {'Minstr user':>11} {'faults':>8}")
for label in sorted(rows):
    n = len(rows[label].get('cycles:u', []))
    print(f"{label:22} {n:2d} {med(label,'task-clock'):13.1f} {med(label,'cycles:u')/1e6:10.1f} {med(label,'cycles:k')/1e6:10.1f} {med(label,'instructions:u')/1e6:11.1f} {med(label,'page-faults'):8.0f}")
