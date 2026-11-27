"""Pair dynamic pass calls by translation-unit group, configuration and ordinal."""
from pathlib import Path
from statistics import median
import argparse
import collections

def samples(root, name, mode, group):
    build, path=name.split(':')
    rounds=[]
    for log in sorted(root.glob(f'{build}-{mode}-{group}-{path}-*.log')):
        rows=[tuple(map(int,line.split()[1:])) for line in log.read_text().splitlines() if line.startswith('gvn-ticks ')]
        if rows: rounds.append(rows)
    if not rounds: return []
    full=max(map(len,rounds))
    rounds=[r for r in rounds if len(r)==full]
    for r in rounds[1:]:
        assert all(a[:6]==b[:6] for a,b in zip(r,rounds[0]))
    return [(*r[0][:6], median(list(x[6] for x in r))) for r in zip(*rounds)]

if __name__=='__main__':
    p=argparse.ArgumentParser()
    for a in ['root','mode','baseline','candidate']: p.add_argument(a)
    args=p.parse_args()
    tables=collections.defaultdict(lambda:[[] for _ in range(5)])
    for g in ('sqlite','lua','musl'):
        a,b=(samples(Path(args.root),spec,args.mode,g) for spec in (args.baseline,args.candidate))
        if not a or not b:continue
        if len(a)!=len(b) or any(x[2:4]!=y[2:4] for x,y in zip(a,b)):
            print(g, 'differing call sequences; use independent size totals', len(a),len(b))
            continue
        for x,y in zip(a,b):
            assert x[4]==y[4]==0
            k=sum(x[0]>=t for t in (16,64,256,1024))
            for key in (g,'total',f'policy={x[2:4]}'):
                tables[key][k].append((x[6],y[6],x[:2]!=y[:2]))
    for key,bins in tables.items():
        def summary(x): return (len(x),round(sum(v[1] for v in x)/sum(v[0] for v in x),3),sum(v[2] for v in x)) if x else None
        print(key,summary(sum(bins,[])),*[summary(x) for x in bins])
