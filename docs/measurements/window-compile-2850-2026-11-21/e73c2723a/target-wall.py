import argparse,csv,hashlib,json,os,statistics,subprocess,sys,time
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--one',nargs=3);args=p.parse_args();root=Path(__file__).resolve().parent;d=root/'target-wall';d.mkdir(exist_ok=True);top=Path.home()/'buster-fast-bench/2850-codex-step2';sqlite=Path('/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite');main=top/'pooled-main-source';flags={'sqlite':['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(sqlite),sqlite/'sqlite3.c'],'main':['-march=native','-I'+str(main/'src'),'-fwrapv','-funsigned-char','--predefines',top/'proof-predefines.h',main/'src/buster/compiler/main.c']}
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
if args.one:
 n,arm,key=args.one;obj=d/(key+'.o');obj.unlink(missing_ok=True);so=d/(key+'.stdout');se=d/(key+'.stderr');cc=root/arm/'build/compiler';cmd=[cc,'--lanes','1','-c',*flags[n],'-o',obj]
 with so.open('wb') as stdout,se.open('wb') as stderr:
  start=time.monotonic_ns();x=subprocess.run(cmd,cwd=top,stdout=stdout,stderr=stderr);end=time.monotonic_ns()
 assert x.returncode==0 and obj.exists(),(n,x.returncode,se.read_text()[-300:]);frame={'input':n,'arm':arm,'command':[str(z) for z in cmd],'UTC':time.strftime('%FT%TZ',time.gmtime()),'affinity':sorted(os.sched_getaffinity(0)),'elapsed-ns':end-start,'ELF':sha(obj),'stdout':sha(so),'stderr':sha(se)};assert frame['affinity']==[2] and frame['elapsed-ns']>1000000,frame
 obj.unlink();(d/(key+'.json')).write_text(json.dumps(frame,indent=2));sys.exit(0)
env={k:v for k,v in os.environ.items() if not k.startswith('BUSTER_')};env.update({'EXCLUSIVE_OWNER':'codex-2850-typed-reserve','EXCLUSIVE_TITLE':'#2850 direct process wall for ordinary typed reserve','EXCLUSIVE_LINK':'https://github.com/buster14a/buster/pull/3269'})
def one(n,arm,key):
 p=d/(key+'.json')
 if not p.exists():
  with (d/'lock.log').open('a') as l:subprocess.run([Path.home()/'buster-fast-bench/exclusive.sh','taskset','-c','2',sys.executable,__file__,'--one',n,arm,key],stdout=l,stderr=subprocess.STDOUT,cwd=top,env=env,check=True)
 j=json.loads(p.read_text());assert j['affinity']==[2];return j
with (d/'samples.tsv').open('w',buffering=1) as f,(d/'summary.tsv').open('w',buffering=1) as s:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['input','round','position','arm','wall-ns','ELF','stdout','stderr']);q=csv.writer(s,delimiter='\t',lineterminator='\n');q.writerow(['input','metric','median-parent','median-candidate','median-paired-change','min-change','max-change','lower-rounds','rounds'])
 for n in flags:
  expected=None
  for a in ('parent','candidate'):
   j=one(n,a,'warm.'+n+'.'+a);v=tuple(j[k] for k in ('ELF','stdout','stderr'));expected=v if expected is None else expected;assert v==expected
   pmu=root/'target'/('warm.'+n+'.'+a+'.json')
   if pmu.exists():assert tuple(json.loads(pmu.read_text())[k] for k in ('ELF','stdout','stderr'))==v
  rounds=[]
  for i in range(1,6):
   rr=[]
   for pos,arm in enumerate(('parent','candidate','candidate','parent') if i%2 else ('candidate','parent','parent','candidate')):
    j=one(n,arm,f'{n}.{i}.{pos}.{arm}');v=tuple(j[k] for k in ('ELF','stdout','stderr'));assert v==expected
    w=j['elapsed-ns'];t.writerow([n,i,pos,arm,w,*v]);rr.append((arm,w))
   rounds.append({a:statistics.mean(w for arm,w in rr if arm==a) for a in ('parent','candidate')})
  changes=[r['candidate']-r['parent'] for r in rounds];q.writerow([n,'wall-ns',*(statistics.median(r[a] for r in rounds) for a in ('parent','candidate')),statistics.median(changes),min(changes),max(changes),sum(y<0 for y in changes),len(changes)])
(d/'complete').write_text(time.strftime('%FT%TZ',time.gmtime())+'\n')
