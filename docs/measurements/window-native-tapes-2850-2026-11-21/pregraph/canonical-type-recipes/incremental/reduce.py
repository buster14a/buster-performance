"""Reduce the locked source producer comparisons; one row per issued full-corpus observation."""
from collections import Counter, defaultdict
from pathlib import Path
from statistics import mean, median
import csv,hashlib,re,sys,tarfile
raw=Path(sys.argv[1]);out=Path(sys.argv[2]);style=sys.argv[3]
out.mkdir(parents=True,exist_ok=True)
modes=['copy','links'] if style=='links' else ['links','epoch','both','private']
round_count=7 if style=='links' else 3
summary=defaultdict(dict);canonical={};all_rows=[];samples=[]
for f in sorted(raw.glob('*.timings')):
 group,r,i,mode=f.stem.split('-'); n=int(r); idx=int(i)
 if mode not in modes: raise ValueError(mode)
 receipt=f.with_suffix('.receipt').read_text().strip()
 stats=Counter();oracle=[];shape=Counter()
 assert 'differences=0' in receipt
 for l in f.read_text().splitlines():
  if l.startswith('cross-cost '):
   stat={k:int(v) for k,v in re.findall(r'([\w-]+)=(\d+)',l)}
   stats.update(stat);continue
  oracle.append(l)
  if l.startswith('source-rows'):
   shape.update({k:int(v) for k,v in re.findall(r'([\w-]+)=(\d+)',l)})
  assert not re.search(r'(?:different-values|different-roots|argument-differences|affected-roots|bad-roots|differences)=[1-9]',l)
 digest=hashlib.sha256(('\n'.join(oracle)+'\n').encode()).hexdigest()
 semantic=(stats['records'],receipt,digest)
 assert canonical.setdefault(group,semantic)==semantic,(group,f)
 assert stats['records']>0 and len(oracle)>0 and shape['written']>0
 ticks=[stats[s] for s in ('prepare','check','finish')]
 data=[v/stats['records'] for v in (*ticks,sum(ticks))]
 samples.append([group,n,idx,mode,stats['records'],*ticks,*data])
 summary[(group,n)].setdefault(mode,[]).append(data)
for g in ['sqlite','lua','musl']:
 for r in range(1,round_count+1):
  assert all(len(summary[g,r][m])==2 for m in modes), (g,r)
 for before,after in zip(modes,modes[1:]):
  for j,stage in enumerate(('preparation','checking_and_capture','finish','sum')):
   left=[];right=[]
   for r in range(1,round_count+1):
    left.append(mean(row[j] for row in summary[g,r][before]))
    right.append(mean(row[j] for row in summary[g,r][after]))
   deltas=[y-x for x,y in zip(left,right)]
   all_rows.append([g,before,after,stage,round_count,median(left),median(right),median(deltas),min(deltas),max(deltas),sum(v<0 for v in deltas)])
def write(name,header,rows):
 with (out/name).open('w') as fp:
  w=csv.writer(fp,delimiter='\t',lineterminator='\n');w.writerow(header.split());w.writerows(rows)
write('samples.tsv','corpus round position mode records prepare_TSC checking_TSC finish_TSC prepare_per_record checking_per_record finish_per_record sum_per_record',samples)
write('pairs.tsv','corpus baseline variant interval rounds baseline_median variant_median median_paired_delta paired_min paired_max rounds_lower',all_rows)
write('oracle.tsv','corpus swept_records sha256_non_timing_lines native_comparison',[[g,n,h,rec] for g,(n,rec,h) in sorted(canonical.items())])
assert len(samples)==round_count*3*len(modes)*2
with tarfile.open(out/'raw-counters.tar.xz','w:xz') as tar:
 for f in sorted(raw.iterdir()):
  if f.suffix in ('.receipt','.timings') or f.name=='all.done':tar.add(f,arcname=f.name)
