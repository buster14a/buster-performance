# stages.py DIR: the stage marks' ticks a call, median of rounds, vector vs scalar, for tiny1 (1 entry) and tiny6 (6 entries).
import statistics, sys, glob
D = sys.argv[1]
def blocks(path):
    out = {}; cur = None
    for line in open(path):
        if line[0] != ' ':
            w = line.split(); cur = (w[0], w[2].rstrip(':')); out[cur] = {}
        else:
            k, v = line.split(); out[cur][k] = float(v)
    return out
for f, n in (('tiny1', '1'), ('tiny6', '6')):
    rows = {}
    names = None
    for path in ('vector', 'scalar'):
        files = sorted(glob.glob(f'{D}/stages-{f}-{path}-*.txt'))
        per = [blocks(p)[(path, n)] for p in files]
        names = list(per[0].keys())
        rows[path] = {k: statistics.median(p[k] for p in per) for k in names}
    print(f'{f}: {n}-entry functions ({len(files)} rounds): stage, vector, twin, difference')
    for k in names:
        print(f'  {k:15s} {rows["vector"][k]:7.1f} {rows["scalar"][k]:7.1f} {rows["vector"][k] - rows["scalar"][k]:+7.1f}')
