# summarize.py DIR A B: median of each perf stat event over DIR/stat-X-*.csv, the difference, and how many rounds
# B was lower than A in, with the median of the per-round differences.
import glob, statistics, sys
d, a, b = sys.argv[1:4]
med, per = {}, {}
for x in (a, b):
    vals = {}
    for f in sorted(glob.glob(f"{d}/stat-{x}-*.csv")):
        r = int(f.rsplit("-", 1)[1].split(".")[0])
        for line in open(f):
            p = line.strip().split(",")
            if len(p) > 3 and p[0] and p[0][0].isdigit():
                vals.setdefault(p[2], []).append(float(p[0]))
                per.setdefault((x, p[2]), {})[r] = float(p[0])
    med[x] = {k: statistics.median(v) for k, v in vals.items()}
for k in med[a]:
    ra = [per[(b, k)][r] / per[(a, k)][r] - 1 for r in per[(a, k)]]
    print(f"{k:18} {med[a][k]:16,.3f} {med[b][k]:16,.3f} {100 * (med[b][k] / med[a][k] - 1):+.2f}%  rounds lower {sum(1 for x in ra if x < 0)}/{len(ra)} median {100 * statistics.median(ra):+.2f}%")
