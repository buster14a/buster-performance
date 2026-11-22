from pathlib import Path
import csv,hashlib,os,subprocess,sys,time,statistics
d=Path(__file__).resolve().parent;w=d.parent
g=sys.argv[1]; options=[a for a in sys.argv[2:] if not a.endswith('.c')];files=[a for a in sys.argv[2:] if a.endswith('.c')]
bins=[('ordinary',w/'main-fbef-clean/build/compiler',{}),('selected',w/'selected-reader-storage/build/compiler',{}),('tagged',w/'tagged-expression-lists/build/compiler',{'BUSTER_TAGGED_VALUES':'1'})]
def invoke(name,exe,env,src,flags,out):
 out.unlink(missing_ok=True)
 t=time.perf_counter_ns()
 p=subprocess.run([exe,'--lanes','1','-c',*options,*flags,src,'-o',out],env=os.environ|env,capture_output=True)
 elapsed=(time.perf_counter_ns()-t)/1e6
 return (p.returncode,hashlib.sha256(out.read_bytes()).hexdigest() if out.exists() else '',p.stdout,p.stderr),elapsed
with (d/(g+'.tsv')).open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t');t.writerow(['source','policy','exit','object_sha256','selected_equal','tagged_equal','ordinary_ms','selected_ms','tagged_ms'])
 for i,src in enumerate(files):
  for policy,flags in [('default',[]),('wall',['-Wall','-Wextra']),('strict',['-Wall','-Wextra','-Werror']),('quiet',['-w']),('everything',['-Weverything'])]:
   outs=[];times=[]
   for name,exe,env in bins:
    obs,elapsed=invoke(name,exe,env,src,flags,d/(g+'.o'));outs.append(obs);times.append(elapsed)
    if g in ('main','sqlite') or obs!=outs[0]:
     (d/(g+'-'+str(i)+'-'+policy+'-'+name+'.stderr')).write_bytes(obs[3])
   t.writerow([src,policy,*outs[0][:2],*(int(b==outs[0]) for b in outs[1:]),*times])
