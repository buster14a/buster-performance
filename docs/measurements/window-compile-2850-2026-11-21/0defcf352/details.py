from pathlib import Path
import sys,csv
base=Path(__file__).resolve().parent/'complete'
for name in sys.argv[1:] or ('fixture','sqlite','main'):
 with (base/(name+'.control-comparison.tsv')).open() as f:
  admitted={r['close'] for r in csv.DictReader(f,delimiter='\t')}
 assert admitted
 for kind in ('plan','case'):
  def get(mode,tag):
   records={}
   for line in (base/(name+'.'+mode+'.log')).read_text().splitlines():
    if line.startswith('source-'+kind+'-'+tag+'\t'):
     _,body,token,*record=line.split('\t')
     if body in admitted:
      assert (body,token) not in records
      records[body,token]=record
   return records
  a=get('source','local');b=get('whole','whole')
  keys=set(a)|set(b); mismatches=[k for k in sorted(keys) if a.get(k)!=b.get(k)]
  with (base/(name+'.'+kind+'.tsv')).open('w') as f:
   w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['close','token','source','ordinary','exact'])
   for k in sorted(keys,key=lambda t:tuple(map(int,t))): w.writerow([*k,','.join(a.get(k,[])),','.join(b.get(k,[])),int(a.get(k)==b.get(k))])
  print(name,kind,len(a),len(b),'parts',sum(int(v[0]) for v in a.values()) if kind=='plan' else '-', 'differences',len(mismatches),mismatches[:5],flush=True)
