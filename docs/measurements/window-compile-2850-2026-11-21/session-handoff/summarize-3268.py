from pathlib import Path
import csv,statistics as st,re,sys,hashlib
d=Path(sys.argv[1]);out=Path(sys.argv[2]);metrics=['wall_ms','cycles:u','instructions:u','cycles:k','page-faults']
with out.open('w') as f:
 c=csv.writer(f,delimiter='\t',lineterminator='\n');c.writerow(['unit','metric','groups','base_median','head_median','paired_median','head_lower','objects_per_process'])
 for u in ['sqlite','main','lua','musl']:
  p=d/'results'/('ordinary-pair-declreadyb76-'+u);order=list(csv.DictReader((p/'order.tsv').open(),delimiter='\t'))
  ref=(p/'preflight-baseline.objects').read_bytes()
  assert ref and (p/'preflight-candidate.objects').read_bytes()==ref
  data={}
  for z in order:
   mode=z['mode'];series=z['series'];r=int(z['round']);s=p/(series+'-'+z['round']+'-'+z['position'])
   assert s.with_suffix('.objects').read_bytes()==ref
   if series=='wall':
    text=s.with_suffix('.wall').read_text();v={'wall_ms':float(re.search(r'run 1 list 1: ([0-9.]+) ms wall',text)[1])}
    assert '0 failed processes' in text
   else:v={row[2]:float(row[0]) for row in csv.reader(s.with_suffix('.perf').open()) if len(row)>3 and row[2] in metrics}
   for k,val in v.items():data.setdefault((k,r,mode),[]).append(val)
  for k in metrics:
   pairs=[(st.mean(data[k,r,'baseline']),st.mean(data[k,r,'candidate'])) for r in range(1,8)]
   assert all(len(data[k,r,m])==2 for r in range(1,8) for m in ['baseline','candidate'])
   b,h=zip(*pairs);diff=[y-x for x,y in pairs]
   c.writerow([u,k,len(pairs),round(st.median(b),5),round(st.median(h),5),round(st.median(diff),5),sum(x<0 for x in diff),len(ref.splitlines())])
