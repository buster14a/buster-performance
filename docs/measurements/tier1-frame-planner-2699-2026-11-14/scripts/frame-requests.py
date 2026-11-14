# Summarizes container/frame-requests-sqlite3.txt: one line per tier1_frame_plan call of `--tier1 -c sqlite3.c --lanes 1`,
# "objects classes columns slots minimum_position maximum_position", printed by a temporary fprintf in tier1_frame_plan_path
# (scripts/frame-requests.patch.txt).
import collections, sys
rows = [tuple(map(int, line.split())) for line in open(sys.argv[1])]
n = len(rows)
counts = sorted(r[0] for r in rows)
total = sum(counts)
def pct(a, p): return a[min(len(a) - 1, int(len(a) * p))]
print('plans', n, 'objects', total)
print('objects per plan: p10 %d p25 %d p50 %d p75 %d p90 %d p95 %d p99 %d max %d' % tuple(pct(counts, p) for p in (.1, .25, .5, .75, .9, .95, .99, 1)))
for lo, hi in ((0, 0), (1, 4), (5, 8), (9, 16), (17, 32), (33, 64), (65, 128), (129, 256), (257, 1024)):
    sel = [r for r in rows if lo <= r[0] <= hi]
    print('objects %d..%d: plans %d (%.1f%%), objects %d (%.1f%%)' % (lo, hi, len(sel), 100 * len(sel) / n, sum(r[0] for r in sel), 100 * sum(r[0] for r in sel) / total))
print('classes per plan:', sorted(collections.Counter(r[1] for r in rows).items()))
with_objects = [r for r in rows if r[0]]
print('largest position: p50 %d p90 %d p99 %d max %d' % tuple(pct(sorted(r[5] for r in with_objects), p) for p in (.5, .9, .99, 1)))
print('columns: p50 %d p90 %d p99 %d max %d' % tuple(pct(sorted(r[2] for r in with_objects), p) for p in (.5, .9, .99, 1)))
print('slots: p50 %d p90 %d p99 %d max %d' % tuple(pct(sorted(r[3] for r in rows), p) for p in (.5, .9, .99, 1)))
