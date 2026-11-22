from pathlib import Path
import csv,fcntl,gzip,hashlib,itertools,json,os,statistics,subprocess,sys,tarfile,time
d=Path(__file__).resolve().parent;w=d.parent;prior=w/'perf/docs/measurements/window-compile-2850-2026-11-21/4bd73ecaf';sys.path.insert(0,str(prior));from reproduce import frozen_args
out=d/'long';out.mkdir(exist_ok=True);lock=(out/'run.lock').open('a')
try:fcntl.flock(lock.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
except BlockingIOError:raise SystemExit(0)
if (out/'raw.tar.gz').exists() and (out/'paired.tsv').exists():raise SystemExit(0)
core=min(os.sched_getaffinity(0));os.sched_setaffinity(0,{core});names=['default-integer-control','default-integer-transfers','default-ordered-integers'];exe={n:w/n/'build/compiler' for n in names};source=w/'switch-inputs/sqlite/sqlite3.c';flags=frozen_args(source,w/'pregraph-warning-study/compiler-source')['sqlite'];expected=None
def sha(raw):return hashlib.sha256(raw).hexdigest()
order=list(itertools.permutations(names))
with (out/'samples.tsv').open('w',buffering=1) as fp:
 wr=csv.writer(fp,delimiter='\t',lineterminator='\n');wr.writerow(('series','round','position','mode','wall-ns','user-ns','system-ns','minor','major','voluntary-switch','involuntary-switch','instructions-u','cycles-u','elf','stdout','stderr'))
 for ser,reps in [('warm',1),('wall',18),('pmu',6)]:
  for r in range(1,reps+1):
   seq=order[(r-1)%len(order)];seq=seq+tuple(reversed(seq))
   for i,n in enumerate(seq):
    stem=out/f'{ser}.{r}.{i}.{n}';obj=out/'unit.o';obj.unlink(missing_ok=True);cmd=[exe[n],'--lanes','1','-c',*flags,'-o',obj]
    if ser=='pmu':cmd=['perf','stat','-x,','--no-big-num','-e','instructions:u,cycles:u','-o',str(stem)+'.perf','--',*cmd]
    with open(str(stem)+'.out','wb') as o,open(str(stem)+'.err','wb') as e:
     start=time.monotonic_ns();p=subprocess.Popen(cmd,stdout=o,stderr=e);_,stat,u=os.wait4(p.pid,0);elapsed=time.monotonic_ns()-start;p.returncode=os.waitstatus_to_exitcode(stat);assert p.returncode==0
    code=sha(obj.read_bytes());expected=expected or code;assert expected==code
    vals={r[2]:r[0] for r in csv.reader(Path(str(stem)+'.perf').read_text().splitlines()) if len(r)>2} if ser=='pmu' else {}
    wr.writerow([ser,r,i,n,elapsed,round(u.ru_utime*1e9),round(u.ru_stime*1e9),u.ru_minflt,u.ru_majflt,u.ru_nvcsw,u.ru_nivcsw,vals.get('instructions:u',''),vals.get('cycles:u',''),code,sha(Path(str(stem)+'.out').read_bytes()),sha(Path(str(stem)+'.err').read_bytes())])
q=list(csv.DictReader((out/'samples.tsv').open(),delimiter='\t'));summary=[];base=names[0]
for n in names[1:]:
 for ser,keys in [('wall',('wall-ns','user-ns','system-ns','minor','involuntary-switch')),('pmu',('instructions-u','cycles-u'))]:
  v=[r for r in q if r['series']==ser];reps=18 if ser=='wall' else 6
  for k in keys:
   pairs=[[statistics.mean(float(r[k]) for r in v if r['mode']==m and r['round']==str(i)) for m in (base,n)] for i in range(1,reps+1)];delta=[b-a for a,b in pairs]
   summary.append([n,ser,k,statistics.median(a for a,b in pairs),statistics.median(b for a,b in pairs),statistics.median(delta),statistics.mean(delta),min(delta),max(delta),sum(x<0 for x in delta),reps])
with (out/'paired.tsv').open('w') as f:wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(('candidate','series','metric','baseline','candidate-median','paired-median','paired-mean','min','max','faster','rounds'));wr.writerows(summary)
with tarfile.open(out/'raw.tar.gz','w:gz') as a:
 for f in sorted(out.iterdir()):
  if f.suffix in ('.out','.err','.perf'):a.add(f,arcname=f.name)
print(core,expected);print('\n'.join(str(r) for r in summary if r[2] in ('wall-ns','cycles-u','instructions-u')))
