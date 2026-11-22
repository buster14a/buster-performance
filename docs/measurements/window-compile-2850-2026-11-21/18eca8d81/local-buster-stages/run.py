from pathlib import Path
import csv,hashlib,json,os,statistics,subprocess
s=Path(__file__).resolve().parent;w=s.parent;cpus=os.sched_getaffinity(0);cpu=min(cpus);os.sched_setaffinity(0,{cpu})
source=w/'pregraph-warning-study/compiler-source';flags=['--lanes','1','--time-stages','-c','-march=native','-I'+str(source/'src'),'-fwrapv','-funsigned-char','--predefines',str(w/'proof-predefines.h'),source/'src/buster/compiler/main.c']
pairs=[('seeded','tile-parser-precedence','seed-parser-windows'),('final-roles','seed-parser-windows','reader-final-role-blocks')]
metrics=('parse','check-input','total');rows=[];ref=None
with (s/'samples.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['comparison','round','position','compiler','cpu',*metrics,'elf-bytes','elf-sha256'])
 for n in range(1,4):
  for label,b,c in pairs[::1 if n%2 else -1]:
   for i,v in enumerate((b,c,c,b) if n%2 else (c,b,b,c)):
    out=s/'unit.o';out.unlink(missing_ok=True);res=subprocess.run([w/v/'build/compiler',*flags,'-o',out],capture_output=True,timeout=90);stem=f'{label}-{n}-{i}'
    (s/(stem+'.stderr')).write_bytes(res.stderr);assert not res.returncode and not res.stdout,(label,n,i,res.stderr[-1000:])
    blob=out.read_bytes();h=hashlib.sha256(blob).hexdigest();assert ref is None or ref==h;ref=h
    values={line.split('\t')[1]:float(line.split('\t')[2]) for line in res.stderr.decode().splitlines() if line.startswith('time-stage\t') and line.split('\t')[1] in metrics}
    t.writerow([label,n,i,v,cpu,*[values[k] for k in metrics],len(blob),h]);rows.append((label,n,v,values))
with (s/'summary.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['comparison','metric','baseline-median-ms','candidate-median-ms','median-paired-change-ms','minimum-ms','maximum-ms','wins'])
 for label,b,c in pairs:
  for metric in metrics:
   series=[[statistics.mean(vals[metric] for ll,rr,vv,vals in rows if ll==label and rr==n and vv==v) for n in range(1,4)] for v in (b,c)]
   dif=[y-x for x,y in zip(*series)];t.writerow([label,metric,*map(statistics.median,series),statistics.median(dif),min(dif),max(dif),sum(n<0 for n in dif)])
