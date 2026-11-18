# #2972: the stage marks' ticks a call (run2.sh), the median of three rounds, each path from its own run (the vector
# path's from `--only vector`, the twin's from `--only scalar`), for tiny.c's 1-entry and 6-entry functions, without the
# fixes (nofix) and with the first two (fix: one push for the bit columns, the values pass bounded by the count).
# Run in this directory.
import statistics
def blocks(path):
    out = {}; cur = None
    for line in open(path):
        if line[0] != ' ':
            w = line.split(); cur = (w[0], w[2].rstrip(':')); out[cur] = {}
        else:
            k, v = line.split(); out[cur][k] = float(v)
    return out
names = None
for t in ('nofix', 'fix'):
    for n in ('1', '6'):
        rows = {}
        for path in ('vector', 'scalar'):
            per = [blocks(f'logs2/stages-{t}-{path}-{r}.txt')[(path, n)] for r in (1, 2, 3)]
            names = list(per[0].keys())
            rows[path] = {k: statistics.median(p[k] for p in per) for k in names}
        print(f'{t}, {n}-entry functions: stage, vector, twin, difference')
        for k in names:
            print(f'  {k:15s} {rows["vector"][k]:7.1f} {rows["scalar"][k]:7.1f} {rows["vector"][k] - rows["scalar"][k]:+7.1f}')
