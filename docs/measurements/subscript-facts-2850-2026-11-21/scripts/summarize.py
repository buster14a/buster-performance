"""Summarize shared-producer pairs by process; every present process must have exactly nine full sweeps per label."""
from statistics import median
from pathlib import Path
import re,sys
d=Path(sys.argv[1]); patt=re.compile(r'subscript-pair: pair=(\d+) records=(\d+) common-producer=(\d+) first-label=(\d+) second-label=(\d+)')
for corpus in ('sqlite','lua','musl'):
 for code in ('AA','AB'):
    groups=[]
    for p in sorted(d.glob(f'{corpus}-*-{code}.txt')):
        rows=[list(map(int,r)) for r in patt.findall(p.read_text())]
        if not rows: continue
        assert len(rows)==9 and [r[0] for r in rows]==list(range(9)) and len({(r[1],r[2]) for r in rows})==1
        delta=[(b-a)/n for _,n,p0,a,b in rows]
        incA=[(p0+a)/n for _,n,p0,a,b in rows];incB=[(p0+b)/n for _,n,p0,a,b in rows]
        per_proc=median(delta)
        groups.append((per_proc,median(incA),median(incB),sum(x<0 for x in delta)))
    if not groups: continue
    g=[p[0] for p in groups]
    print(corpus,code,'processes',len(g),'inclusive medians %.4f %.4f'%(median(p[1] for p in groups),median(p[2] for p in groups)),'paired delta %+.4f [%+.4f,%+.4f]'%(median(g),min(g),max(g)),'second faster',sum(p[3] for p in groups),'/',9*len(groups),'process medians',','.join('%+.4f'%v for v in g))
