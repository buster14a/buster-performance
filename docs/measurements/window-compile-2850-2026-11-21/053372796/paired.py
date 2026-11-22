from pathlib import Path
import csv,hashlib,itertools,os,statistics,subprocess,time
d=Path(__file__).resolve().parent;w=d.parent
s=(w/'sizeof-expression-study/source-regions.py').read_text();srcargs=s.split("srcargs='''")[1].split("'''")[0].replace('\\\\0','\\0').replace('$1/pregraph-warning-study','$1/switch-inputs/../pregraph-warning-study').replace('$1/proof-predefines.h','$1/switch-inputs/../proof-predefines.h')
comp={'ordinary':'default-integer-control','selected':'selected-reader-storage','tagged':'tagged-expression-lists'}
orders=list(itertools.permutations(comp))
with (d/'paired-wall.tsv').open('w',buffering=1) as f,(d/'paired-result.tsv').open('w',buffering=1) as summary:
 t=csv.writer(f,delimiter='\t');t.writerow(['unit','round','position','arm','wall_ms','rss_kib','minflt','sha256']);o=csv.writer(summary,delimiter='\t');o.writerow(['unit','arm','ordinary_ms','new_ms','paired_ms','new_lower','rss_change','page_fault_change'])
 for u in ['sqlite','main']:
  args=subprocess.check_output(['bash','-c',srcargs,'_',str(w),u]).decode().strip('\0').split('\0')
  expected=hashlib.sha256((w/'source-typed-study'/(u+'.o')).read_bytes()).hexdigest()
  history={arm:[] for arm in comp}
  for rnd,order in enumerate(orders):
   v={a:[] for a in comp}
   for pos,arm in enumerate(order+order[::-1]):
    obj=d/'paired.o';obj.unlink(missing_ok=True);cmd=[w/comp[arm]/'build/compiler','--lanes','1','-c',*args,'-o',obj];env=os.environ|({'BUSTER_TAGGED_VALUES':'1'} if arm=='tagged' else {})
    with (d/'paired.out').open('wb') as so,(d/'paired.err').open('wb') as se:
     start=time.monotonic_ns();proc=subprocess.Popen(cmd,env=env,stdout=so,stderr=se);pid,st,r=os.wait4(proc.pid,0);elapsed=(time.monotonic_ns()-start)/1e6;proc.returncode=os.waitstatus_to_exitcode(st)
    assert proc.returncode==0 and (d/'paired.out').stat().st_size==(d/'paired.err').stat().st_size==0
    sha=hashlib.sha256(obj.read_bytes()).hexdigest();assert sha==expected
    cells=(elapsed,r.ru_maxrss,r.ru_minflt);v[arm].append(cells);t.writerow([u,rnd,pos,arm,*cells,sha])
   for a in comp:history[a].append(tuple(statistics.mean(z) for z in zip(*v[a])))
  for a in ['selected','tagged']:
   b=history['ordinary'];n=history[a];diff=list(zip(*[[y-x for x,y in zip(r,s)] for r,s in zip(b,n)]))
   o.writerow([u,a,statistics.median(x[0] for x in b),statistics.median(x[0] for x in n),statistics.median(diff[0]),sum(x<0 for x in diff[0]),statistics.median(diff[1]),statistics.median(diff[2])])
  for rnd,order in enumerate(orders[:3]):
   for arm in order:
    dest=d/f'{u}-{rnd}-{arm}.perf';obj=d/'paired.o'
    r=subprocess.run(['perf','stat','--no-big-num','-x',';','-e','instructions:u,cycles:u,branches:u,minor-faults','-o',dest,'--',w/comp[arm]/'build/compiler','--lanes','1','-c',*args,'-o',obj],capture_output=True,env=os.environ|({'BUSTER_TAGGED_VALUES':'1'} if arm=='tagged' else {}))
    assert r.returncode==0 and not r.stdout and not r.stderr and hashlib.sha256(obj.read_bytes()).hexdigest()==expected
