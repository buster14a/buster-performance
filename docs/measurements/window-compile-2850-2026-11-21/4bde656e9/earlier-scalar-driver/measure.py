from pathlib import Path
import sys,time,resource,csv,hashlib,subprocess,os,statistics
d=Path(sys.argv[1]).resolve();unit=sys.argv[2];args=sys.argv[3:]
old=(d/'../source-typed-study'/(unit+'.o')).read_bytes()
binary=(d/('..'+'/'+d.name.removesuffix('-study'))/'build/compiler').resolve(strict=True)
obj=d/(unit+'.timing.o'); metrics={}
with (d/(unit+'-observations.tsv')).open('w',buffering=1) as out:
 t=csv.writer(out,delimiter='\t',lineterminator='\n');t.writerow(['round','position','arm','ms','user_ms','system_ms','minor_faults','sha256','status'])
 for r in range(5):
  for i,arm in enumerate(('ordinary','live','live','ordinary') if r%2==0 else ('live','ordinary','ordinary','live')):
   before=resource.getrusage(resource.RUSAGE_CHILDREN);start=time.monotonic_ns()
   p=subprocess.run([binary,'--lanes','1','-c',*args,'-o',obj],env=os.environ|({'BUSTER_PARSE_LIVE_FOREST':'1'} if arm=='live' else {}),capture_output=True)
   wall=(time.monotonic_ns()-start)/1e6;after=resource.getrusage(resource.RUSAGE_CHILDREN)
   assert not p.returncode and not p.stdout and not p.stderr and obj.read_bytes()==old
   user=(after.ru_utime-before.ru_utime)*1e3;system=(after.ru_stime-before.ru_stime)*1e3
   t.writerow([r,i,arm,wall,user,system,after.ru_minflt-before.ru_minflt,hashlib.sha256(old).hexdigest(),p.returncode])
   metrics.setdefault(r,{}).setdefault(arm,[]).append(wall)
 for arm in ['ordinary','live']:
  stem=d/(unit+'.stages.'+arm+'.stderr')
  p=subprocess.run([binary,'--lanes','1','--time-stages','-c',*args,'-o',obj],env=os.environ|({'BUSTER_PARSE_LIVE_FOREST':'1'} if arm=='live' else {}),capture_output=True)
  stem.write_bytes(p.stderr);assert p.returncode==0 and not p.stdout and obj.read_bytes()==old
ds=[statistics.mean(row['live'])-statistics.mean(row['ordinary']) for row in metrics.values()]
with (d/(unit+'-paired.tsv')).open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['unit','rounds','ordinary_ms','live_ms','paired_ms','min','max','wins']);t.writerow([unit,5,*(statistics.median(statistics.mean(row[a]) for row in metrics.values()) for a in ['ordinary','live']),statistics.median(ds),min(ds),max(ds),sum(x<0 for x in ds)])
