"""Measure both integration snapshots as individually paired whole-translation-unit compilations."""
from pathlib import Path
import csv,hashlib,itertools,json,os,statistics,subprocess,sys,time
p=Path(__file__).resolve().parent;w=p.parent;d=p/'build-counters';raw=d/'raw';raw.mkdir(parents=True,exist_ok=True)
metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];snaps=['fifteen','eighteen'];vs=['control','candidate'];rounds=7
def nul(n):return [a.decode() for a in (w/'integration-evidence'/n).read_bytes().split(b'\0') if a]
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def save(name,head,rows):
 with (d/name).open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(rows)
sources=nul('sources.argv');flags=nul('tier1-flags.argv');os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400',BUSTER_TEST_HOST_BUSY='0')
if len(sys.argv)==1:
 for r in range(rounds):
  for j in range(6):
   batch=[(i+5*r)%43 for i in range(j*8,min(43,(j+1)*8))]
   for s in (snaps if (r+j)%2 else snaps[::-1]):
    if all((raw/f'{s}-{r}-{i}-{v}.json').is_file() for i,v in itertools.product(batch,vs)):continue
    run('cores','-n',1,'--',sys.executable,__file__,'batch',s,r,*batch,env=dict(os.environ,CORES_TITLE=f'Pair compiler counters for {s}-PR self-host sources, round {r+1}',CORES_LINK='https://github.com/buster14a/buster/pull/3133'))
  print('round',r,flush=True)
 run(sys.executable,__file__,'sum')
elif sys.argv[1]=='batch':
 s=sys.argv[2];r=int(sys.argv[3]);cpus=os.sched_getaffinity(0);cpu=min(cpus);os.sched_setaffinity(0,{cpu})
 for i in map(int,sys.argv[4:]):
  for v in (vs if (r+i)%2 else vs[::-1]):
   f=raw/f'{s}-{r}-{i}-{v}.json'
   if f.is_file():continue
   stamp=d/'last.stat';out=d/'last.o';cc=w/(s+'-'+v)/'build/compiler';a=time.monotonic_ns()
   z=run('perf','stat','-e',','.join(metrics),'-x',';','--no-big-num','-o',stamp,'--',cc,'--lanes','1',*flags,'-c',sources[i],'-o',out,cwd=w/(s+'-control'),capture_output=True)
   dt=(time.monotonic_ns()-a)/1e6;c={t[2]:float(t[0]) for ln in stamp.read_text().splitlines() if len(t:=ln.split(';'))>2 and t[2] in metrics};assert len(c)==len(metrics)
   f.write_text(json.dumps(dict(snapshot=s,round=r,unit=i,source=sources[i],variant=v,cpu=cpu,wall_ms=dt,sha256=sha(out),object_bytes=out.stat().st_size,**c))+'\n')
else:
 rows=[json.loads(f.read_text()) for f in sorted(raw.glob('*.json'))];assert len(rows)==rounds*len(snaps)*43*2;idx={(x['snapshot'],x['round'],x['unit'],x['variant']):x for x in rows};header=list(rows[0]);save('observations.tsv',header,[[x[h] for h in header] for x in rows]);out=[];refs=[]
 for s in snaps:
  for scope in [*range(43),-1]:
   units=[scope] if scope>=0 else list(range(43))
   if scope>=0:
    for v in vs:
     gold=w/(s+'-evidence')/(s+'-control-own-stage2' if v=='control' else s+'-candidate-common')/f'unit-{scope:04}.o';hx=sha(gold) if gold.is_file() else '-'
     digests={idx[s,r,scope,v]['sha256'] for r in range(rounds)};assert len(digests)==1
     refs.append([s,scope,sources[scope],v,next(iter(digests)),hx,next(iter(digests))==hx])
   for m in metrics+['wall_ms']:
    get=lambda v:[sum(idx[s,r,i,v][m] for i in units) for r in range(1,rounds)]
    a=get('control');b=get('candidate');z=[100*(v/u-1) for u,v in zip(a,b) if u];delta=[v-u for u,v in zip(a,b)]
    if z:out.append([s,scope,sources[scope] if scope>=0 else 'ALL',m,len(z),statistics.median(a),statistics.median(b),statistics.median(delta),statistics.median(z),min(z),max(z)])
 save('paired.tsv',['snapshot','unit','source','metric','pairs','control','candidate','paired_delta','paired_percent','minimum_percent','maximum_percent'],out);save('hashes.tsv',['snapshot','unit','source','variant','observed_sha256','previous_fixed_or_common_build_sha256','identical'],refs)
