import argparse,csv,hashlib,json,os,platform,statistics,subprocess,sys,time
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('parent',type=Path);p.add_argument('candidate',type=Path);p.add_argument('work',type=Path);p.add_argument('--one',nargs=3);o=p.parse_args()
top=Path.home()/'buster-fast-bench/2850-codex-step2';out=o.work.resolve();out.mkdir(exist_ok=True,parents=True)
corpus=Path('/var/lib/buster-9700x/corpora/preprocessor-391e729af658');sqlite=corpus/'sqlite';main=top/'pooled-main-source';flags={'sqlite':['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(sqlite),sqlite/'sqlite3.c'],'main':['-march=native','-I'+str(main/'src'),'-fwrapv','-funsigned-char','--predefines',top/'proof-predefines.h',main/'src/buster/compiler/main.c']}
def digest(f):return hashlib.sha256(f.read_bytes()).hexdigest()
if o.one:
 name,arm,key=o.one;cc=o.parent if arm=='parent' else o.candidate
 obj=out/(key+'.o');obj.unlink(missing_ok=True);stem=out/key;stats=out/(key+'.perf');so=out/(key+'.stdout');se=out/(key+'.stderr');old=out/(key+'.json')
 cmd=['perf','stat','--no-big-num','-x',',','-e','instructions:u,cycles:u,context-switches,cpu-migrations,minor-faults,duration_time','-o',stats,'--',cc,'--lanes','1','-c',*flags[name],'-o',obj]
 with so.open('wb') as stdout,se.open('wb') as stderr:
  start=time.monotonic_ns();r=subprocess.run(cmd,cwd=top,stdout=stdout,stderr=stderr);end=time.monotonic_ns()
 assert r.returncode==0 and obj.exists(),(name,r.returncode,se.read_text()[-200:])
 counters={z[2]:int(z[0]) for z in csv.reader(stats.read_text().splitlines()) if len(z)>2 and z[0].strip().isdigit()}
 assert all(x in counters for x in ['cycles:u','instructions:u','duration_time']),counters
 record={'input':name,'arm':arm,'utc':time.strftime('%FT%TZ',time.gmtime()),'command':[str(v) for v in cmd],'ELF':digest(obj),'stdout':digest(so),'stderr':digest(se),'process-ns':end-start,'event':counters,'affinity':sorted(os.sched_getaffinity(0))};assert record['affinity']==[2],record
 if key.startswith('warm.'):
  (out/(key+'.sections')).write_bytes(subprocess.check_output(['readelf','-WhS',obj]));obj.rename(out/(key+'.elf'))
 else:obj.unlink()
 old.write_text(json.dumps(record,indent=2));sys.exit(0)
lock=Path.home()/'buster-fast-bench/exclusive.sh';env={k:v for k,v in os.environ.items() if not k.startswith('BUSTER_')};env|={'EXCLUSIVE_OWNER':'codex-2850-typed-reserve','EXCLUSIVE_TITLE':'#2850 ordinary typed reserve planner release','EXCLUSIVE_LINK':os.getenv('RESERVE_PR','https://github.com/buster14a/buster/issues/2850')}
def one(name,arm,key):
 f=out/(key+'.json')
 if not f.exists():
  with (out/'lock.log').open('a') as log:subprocess.run([lock,'taskset','-c','2',sys.executable,__file__,o.parent,o.candidate,out,'--one',name,arm,key],env=env,cwd=top,stdout=log,stderr=subprocess.STDOUT,check=True)
 return json.loads(f.read_text())
lscpu=subprocess.check_output(['lscpu'],text=True);assert '9700X' in lscpu,lscpu;(out/'lscpu.txt').write_text(lscpu);(out/'system.json').write_text(json.dumps({'platform':platform.platform(),'parent':str(o.parent),'candidate':str(o.candidate),'parent-sha256':digest(o.parent),'candidate-sha256':digest(o.candidate),'sqlite-source-sha256':digest(sqlite/'sqlite3.c'),'main-source-sha256':digest(main/'src/buster/compiler/main.c'),'predefines':digest(top/'proof-predefines.h'),'cpu2-siblings':Path('/sys/devices/system/cpu/cpu2/topology/thread_siblings_list').read_text().strip(),'governor':Path('/sys/devices/system/cpu/cpu2/cpufreq/scaling_governor').read_text().strip()},indent=2))
with (out/'samples.tsv').open('w',buffering=1) as s,(out/'summary.tsv').open('w',buffering=1) as u:
 t=csv.writer(s,delimiter='\t',lineterminator='\n');t.writerow(['input','round','position','arm','duration-ns','user-instructions','user-cycles','migrations','context-switches','faults','ELF','stdout','stderr'])
 q=csv.writer(u,delimiter='\t',lineterminator='\n');q.writerow(['input','metric','median-parent','median-candidate','median-paired-change','min-change','max-change','lower-rounds','rounds'])
 for n in ('sqlite','main'):
  expected=None;rr=[]
  for a in ['parent','candidate']:
   j=one(n,a,'warm.'+n+'.'+a);v=tuple(j[k] for k in ('ELF','stdout','stderr'))
   if expected is None:expected=v
   assert v==expected,(n,a,v,expected)
  for i in range(1,6):
   batch=[]
   for k,a in enumerate(['parent','candidate','candidate','parent'] if i%2 else ['candidate','parent','parent','candidate']):
    key=f'{n}.{i}.{k}.{a}';j=one(n,a,key);c=j['event'];v=tuple(j[k] for k in ('ELF','stdout','stderr'));assert v==expected,(key,v,expected);assert c['cpu-migrations']==0,(key,c)
    z=[n,i,k,a,c['duration_time'],c['instructions:u'],c['cycles:u'],c['cpu-migrations'],c['context-switches'],c['minor-faults'],*v];t.writerow(z);batch.append(z)
   rr.append(batch)
  for col,metric in [(4,'duration-ns'),(5,'user-instructions'),(6,'user-cycles')]:
   groups={a:[statistics.mean(r[col] for r in batch if r[3]==a) for batch in rr] for a in ('parent','candidate')};z=[b-a for a,b in zip(groups['parent'],groups['candidate'])];q.writerow([n,metric,statistics.median(groups['parent']),statistics.median(groups['candidate']),statistics.median(z),min(z),max(z),sum(x<0 for x in z),len(z)])
(out/'complete').write_text(time.strftime('%FT%TZ',time.gmtime())+'\n')
