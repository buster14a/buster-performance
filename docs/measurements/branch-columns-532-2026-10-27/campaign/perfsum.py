# Summarizes perf stat -r 3 files named PREFIX-ROUND-VARIANT.txt: per variant the median over rounds of each counter,
# and per pair the median of the per-round differences (paired, as the rounds interleave them).
import re, sys, glob, statistics, os
prefix = sys.argv[1]
variants = sys.argv[2].split(',')
base = variants[0]
fields = ['task-clock', 'cycles:u', 'instructions:u', 'cycles:k', 'instructions:k', 'elapsed']
def parse(path):
    text = open(path).read()
    out = {}
    m = re.search(r'([\d.]+) msec task-clock', text); out['task-clock'] = float(m.group(1))
    for f in ['cycles:u', 'instructions:u', 'cycles:k', 'instructions:k']:
        m = re.search(r'(\d+)\s+' + re.escape(f) + r'\s', text); out[f] = int(m.group(1))
    m = re.search(r'([\d.]+) \+- ([\d.]+) seconds time elapsed', text); out['elapsed'] = float(m.group(1)) * 1000
    return out
rounds = sorted({int(re.match(r'.*-(\d+)-[^-]+\.txt$', p).group(1)) for p in glob.glob(prefix + '-*-*.txt')})
data = {v: {r: parse('%s-%d-%s.txt' % (prefix, r, v)) for r in rounds} for v in variants}
print('rounds:', len(rounds))
print('%-16s' % 'counter' + ''.join('%18s' % v for v in variants) + ''.join('%26s' % (v + ' - ' + base) for v in variants[1:]))
for f in fields:
    row = '%-16s' % f
    for v in variants:
        med = statistics.median(data[v][r][f] for r in rounds)
        row += '%18s' % ('%.3f' % med if f in ('task-clock', 'elapsed') else '{:,}'.format(int(med)))
    for v in variants[1:]:
        diffs = [data[v][r][f] - data[base][r][f] for r in rounds]
        rel = [100.0 * (data[v][r][f] - data[base][r][f]) / data[base][r][f] for r in rounds]
        med = statistics.median(diffs)
        txt = ('%+.3f' % med if f in ('task-clock', 'elapsed') else '{:+,}'.format(int(med))) + ' (%+.2f%% [%+.2f, %+.2f])' % (statistics.median(rel), min(rel), max(rel))
        row += '%40s' % txt
    print(row)
