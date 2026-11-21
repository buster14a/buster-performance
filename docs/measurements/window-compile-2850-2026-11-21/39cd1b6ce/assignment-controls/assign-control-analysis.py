import collections,csv,io,sys,tarfile
from pathlib import Path
from statistics import mean,median
root,dest=map(Path,sys.argv[1:3]);dest.mkdir(parents=True,exist_ok=True)
order=list(csv.DictReader((root/'order.tsv').open(),delimiter='\t')); modes=('parent-reads','parent-stores','retained','legacy-scan','legacy-stores','narrow-scan','narrow-stores')
assert len(order)==98, len(order)
for n in range(1,8):
    group=[r['mode'] for r in order if int(r['round'])==n]
    assert group==group[::-1] and sorted(group[:7])==sorted(modes)
vals=collections.defaultdict(list);faults=collections.defaultdict(list)
with (dest/'pmu.tsv').open('w') as out,tarfile.open(dest/'process-counters.tar.xz','w:xz') as arc:
 wr=csv.writer(out,delimiter='\t',lineterminator='\n')
 events=('cycles:u','cycles:k','instructions:u','instructions:k','task-clock','page-faults','context-switches','cpu-migrations')
 wr.writerow(('round','position','mode',*events))
 for r in order:
    n=int(r['round']);pos=int(r['position']);m=r['mode'];stem=root/f'pmu-{n}-{pos}'
    assert not stem.with_suffix('.stdout').read_bytes() and not stem.with_suffix('.stderr').read_bytes()
    f=stem.with_suffix('.perf');rows=[s.split(',') for s in f.read_text().splitlines() if ',' in s]
    e={s[2]:float(s[0]) for s in rows};assert set(e)==set(events) and all(float(s[4])==100 for s in rows)
    wr.writerow([n,pos,m,*[e[k] if k=='task-clock' else int(e[k]) for k in events]])
    vals['cycles/token',m,n].append((e['cycles:u']+e['cycles:k'])/716136)
    vals['user instructions',m,n].append(e['instructions:u'])
    vals['kernel instructions',m,n].append(e['instructions:k'])
    faults[m].append(int(e['page-faults']))
    arc.add(f,arcname=f.name,recursive=False)
 for m in modes:
    for ext in ('sha256','stderr','stdout'):
        f=root/f'stage-{m}.{ext}';arc.add(f,arcname=f.name,recursive=False)
for m in modes:
    print(m,*[round(median(mean(vals[k,m,n]) for n in range(1,8)),4) for k in ('cycles/token','user instructions','kernel instructions')], 'PMU faults',min(faults[m]),max(faults[m]))
for m,c in [('parent-stores','parent-reads'),('retained','parent-reads'),('legacy-scan','retained'),('legacy-stores','legacy-scan'),('narrow-scan','retained'),('narrow-stores','narrow-scan'),('narrow-stores','legacy-stores'),('legacy-stores','parent-stores'),('narrow-stores','parent-stores')]:
 print(m,'minus',c)
 for k in ('cycles/token','user instructions'):
    v=[mean(vals[k,m,n])-mean(vals[k,c,n]) for n in range(1,8)]
    print('  ',k,*(round(f(v),5) for f in (median,min,max)))
