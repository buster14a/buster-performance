from collections import defaultdict
import csv,io,re,sys,tarfile
from pathlib import Path
from statistics import mean,median
root=Path(sys.argv[1]);dest=Path(sys.argv[2]);dest.mkdir(exist_ok=True,parents=True)
rows=list(csv.DictReader((root/'order.tsv').open(),delimiter='\t'))
modes=('reads','ordinary','returns','stores')
assert len(rows)==112
samples=defaultdict(list); high=defaultdict(set); bands=defaultdict(list); costs=defaultdict(list)
with (dest/'samples.tsv').open('w') as out,tarfile.open(dest/'measurements.tar.xz','w:xz') as arc:
 wr=csv.writer(out,delimiter='\t',lineterminator='\n');wr.writerow(('series','round','position','mode','cycles/token','user-instructions','kernel-instructions','wall-ms','system-ms','faults','major-faults'))
 for row in rows:
    series=row['series'];n=int(row['round']);pos=int(row['position']);m=row['mode']; stem=root/f'{series}-{n}-{pos}'
    assert not stem.with_suffix('.stderr').read_bytes(),stem
    if series=='pmu':
      assert not stem.with_suffix('.stdout').read_bytes(),stem
      raw=stem.with_suffix('.perf').read_text()
      pts=[line.split(',') for line in raw.splitlines() if ',' in line];assert all(float(p[4])==100 for p in pts),stem
      e={p[2]:float(p[0]) for p in pts}
      cyc=(e['cycles:u']+e['cycles:k'])/716136; ins=int(e['instructions:u']); ker=int(e['instructions:k']); faults=int(e['page-faults'])
      wr.writerow((series,n,pos,m,round(cyc,8),ins,ker,'','',faults,'n/a'))
      for metric,value in [('cycles/token',cyc),('user-instructions',ins),('kernel-instructions',ker)]:samples[m,metric,n].append(value)
      costs[series,m].append((cyc,n,pos,faults)); path=stem.with_suffix('.perf');data=raw.encode()
    else:
      raw=stem.with_suffix('.wall').read_text()
      a=re.search(r'^run 1 list 1.*?: ([\d.]+) ms wall, [\d.]+ ms user, ([\d.]+) ms system, \d+ KiB wait4 peak, (\d+) minor faults, (\d+) major,.*status 0$',raw,re.M)
      assert a and 'time-runs: done, 0 failed processes' in raw,stem
      elapsed=float(a[1]);system=float(a[2]);faults=int(a[3]);major=int(a[4])
      wr.writerow((series,n,pos,m,'','','',elapsed,system,faults,major));samples[m,'wall-ms',n].append(elapsed)
      costs[series,m].append((elapsed,n,pos,faults));path=stem.with_suffix('.wall');data=('\n'.join(v for v in raw.splitlines() if v.startswith(('run 1 list','time-runs:')))+'\n').encode()
    if faults>20000:high[series].add(n)
    bands[series,m].append(faults)
    item=tarfile.TarInfo(path.name);item.size=len(data);arc.addfile(item,io.BytesIO(data))
for series in ('pmu','wall'):
    for n in range(1,8):
        order=[r['mode'] for r in rows if r['series']==series and int(r['round'])==n]
        assert order==order[::-1] and sorted(order[:4])==sorted(modes)
for mode in modes:
 print('absolute',mode,*(round(median(mean(samples[mode,k,n]) for n in range(1,8)),5) for k in ('cycles/token','wall-ms','user-instructions')))
 for series in ('pmu','wall'):
    print('faults and slowest',series,mode,(min(bands[series,mode]),max(bands[series,mode])),max(costs[series,mode]))
for m,c in [('returns','reads'),('returns','ordinary'),('stores','returns'),('stores','reads'),('stores','ordinary'),('ordinary','reads')]:
 for k in ('cycles/token','wall-ms','user-instructions'):
    series='wall' if k=='wall-ms' else 'pmu'
    ds=[mean(samples[m,k,n])-mean(samples[c,k,n]) for n in range(1,8)]
    clean=[v for n,v in enumerate(ds,1) if n not in high[series]]
    print(m,'minus',c,k,*[round(f(ds),5) for f in (median,min,max)],'clean',*[round(f(clean),5) for f in (median,min,max)] if clean else ['none'])
print('high fault (>20,000) rounds',dict(high))
