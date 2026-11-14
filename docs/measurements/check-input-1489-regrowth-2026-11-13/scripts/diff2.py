import sys, re, collections
# diff2.py A.tsv RUNS_A B.tsv RUNS_B PATTERN N: per-run sample differences (A - B); one sample is 200003 cycles.
def load(f, runs):
    d = collections.Counter()
    for line in open(f):
        v, k = line.rstrip('\n').split('\t', 1)
        d[re.sub(r'\.buster_split', '', k)] += int(v) / runs
    return d
a = load(sys.argv[1], float(sys.argv[2])); b = load(sys.argv[3], float(sys.argv[4]))
pat = re.compile(sys.argv[5]); n = int(sys.argv[6])
keys = [k for k in set(a) | set(b) if pat.search(k)]
keys.sort(key=lambda k: -(a[k] - b[k]))
ms = 200003 / 5.2e6  # ms per sample at about 5.2 GHz
for k in keys[:n]: print('%+7.1f %7.1f %7.1f %+6.3fms %s' % (a[k] - b[k], a[k], b[k], (a[k] - b[k]) * ms, k))
print('...')
for k in keys[-12:]: print('%+7.1f %7.1f %7.1f %+6.3fms %s' % (a[k] - b[k], a[k], b[k], (a[k] - b[k]) * ms, k))
