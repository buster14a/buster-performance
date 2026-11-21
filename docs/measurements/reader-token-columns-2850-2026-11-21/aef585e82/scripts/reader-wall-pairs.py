"""Summarize independent wall-clock observations by round from the locked host."""
import csv,re,statistics,sys
from pathlib import Path
p=Path(sys.argv[1])
writer=csv.writer(sys.stdout,delimiter='\t',lineterminator='\n')
writer.writerow(['policy','unit','before median','after median','paired median','paired min','paired max','rounds improved'])
for policy in ('auto','huge','base'):
    bins={x:[] for x in ('before','after')}
    for r in range(1,8):
        for tag in bins:
            obs=[]
            for f in sorted(p.glob(f'{r}-{policy}-*-{tag}.wall')):
                line=next(l for l in f.read_text().splitlines() if l.startswith('run 1 list 1:'))
                assert line.endswith('status 0'),line
                obs.append([float(re.search(r'([.\d]+) ms wall',line)[1]),int(re.search(r'(\d+) KiB',line)[1]),int(re.search(r'(\d+) minor faults',line)[1])])
            assert len(obs)==2
            bins[tag].append(list(map(statistics.mean,zip(*obs))))
    for col,unit in enumerate(['ms','peak KiB','minor faults']):
        x=[s[col] for s in bins['before']];y=[s[col] for s in bins['after']]
        d=[b-a for a,b in zip(x,y)];writer.writerow([policy,unit,*(f'{n:.4f}' for n in [statistics.median(x),statistics.median(y),statistics.median(d),min(d),max(d)]),sum(i<0 for i in d)])
