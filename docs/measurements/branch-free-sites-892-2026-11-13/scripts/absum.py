# absum.py DIR A B: medians of ab.sh's rounds (perf stat -r 3 each) and --time-stages runs, A against B.
import sys, glob, statistics, re, collections
d, a, b = sys.argv[1:4]
def stat(t):
    rows = collections.defaultdict(list)
    for f in sorted(glob.glob(f'{d}/stat.r*.{t}.csv')):
        for line in open(f):
            if line.startswith('#') or not line.strip():
                continue
            p = line.split(',')
            try:
                rows[p[2]].append(float(p[0]))
            except ValueError:
                pass
    return rows
def stages(t):
    rows = collections.defaultdict(list)
    for f in sorted(glob.glob(f'{d}/stages.r*.{t}.txt')):
        for line in open(f):
            p = line.rstrip('\n').split('\t')
            if len(p) >= 3 and p[0] == 'time-stage' and p[1] != 'stage':
                try:
                    rows[p[1]].append(float(p[2]))
                except ValueError:
                    pass
            elif len(p) >= 3 and p[0] == 'time-process':
                try:
                    rows['process.' + p[1]].append(float(p[2]))
                except ValueError:
                    pass
    return rows
sa, sb = stat(a), stat(b)
print(f'perf stat rounds: {a} {len(sa.get("cycles:u", []))}, {b} {len(sb.get("cycles:u", []))}')
for k in sa:
    if k in sb and sa[k] and sb[k]:
        ma, mb = statistics.median(sa[k]), statistics.median(sb[k])
        # paired by round
        pairs = [y / x - 1 for x, y in zip(sa[k], sb[k])]
        print(f'  {k:28s} {ma:16.0f} {mb:16.0f} {(mb/ma-1)*100:+7.2f}%  paired median {statistics.median(pairs)*100:+6.2f}% range [{min(pairs)*100:+.2f}, {max(pairs)*100:+.2f}]')
ta, tb = stages(a), stages(b)
print(f'time-stages runs: {a} {len(ta.get("check-input", []))}, {b} {len(tb.get("check-input", []))}')
for k in ta:
    if k in tb and ta[k] and tb[k]:
        ma, mb = statistics.median(ta[k]), statistics.median(tb[k])
        if ma >= 0.5 or mb >= 0.5:
            print(f'  {k:28s} {ma:9.3f} {mb:9.3f} {mb-ma:+8.3f} ms {(mb/ma-1)*100 if ma else 0:+7.2f}%')
