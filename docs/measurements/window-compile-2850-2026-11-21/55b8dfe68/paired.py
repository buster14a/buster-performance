from pathlib import Path
import argparse,csv,hashlib,os,subprocess,time
p=Path(__file__).resolve().parent; work=p.parent
x=argparse.ArgumentParser();x.add_argument('table');x.add_argument('arms',nargs='+');x.add_argument('--rounds',type=int,default=3);a=x.parse_args();arms={}
for arm in a.arms:
 name,path=arm.split('=',1);arms[name]=(Path(path).resolve(),name.endswith('ordinary'),name.startswith('profile'))
args=subprocess.check_output(['bash','-c','source ../switch-local-args.sh; eval "args=($sqlite_arguments)"; printf "%s\\0" "${args[@]}"'],cwd=work/'switch-inputs').split(b'\0')[:-1];args=[os.fsdecode(v) for v in args];oracle=hashlib.sha256((work/'source-typed-study/sqlite.o').read_bytes()).hexdigest();dest=p/(a.table+'.o'); env={k:v for k,v in os.environ.items() if not k.startswith('BUSTER_CONTROL_')}
with (p/(a.table+'.tsv')).open('w',buffering=1) as log:
 w=csv.writer(log,delimiter='\t',lineterminator='\n');w.writerow('round position arm wall-ms user-ms sys-ms max-rss-kib minor-faults major-faults sha256'.split());keys=list(arms)
 for r in range(a.rounds):
  order=keys[:] if r%2==0 else keys[::-1]
  if r>=2:
   cut=(r//2)%len(keys);order=order[cut:]+order[:cut]
  for i,key in enumerate(order):
   binary,ordinary,profile=arms[key];runenv=dict(env);
   if not ordinary:runenv['BUSTER_CONTROL_SOURCE_NATIVE']='1'
   if key[-1:].isdigit():runenv['BUSTER_CONTROL_SOURCE_VARIANT']=key[-1]
   if key in ('early','release'):runenv['BUSTER_CONTROL_EARLY_NATIVE']='1'
   if key=='release':runenv['BUSTER_CONTROL_EARLY_RELEASE']='1'
   if profile:runenv['BUSTER_CONTROL_SOURCE_COSTS']='1'
   with (p/f'{a.table}-{r+1}-{key}.stderr').open('wb') as err:
    tic=time.perf_counter_ns();proc=subprocess.Popen([binary,'--lanes','1','-c',*args,'-o',dest],env=runenv,stdout=subprocess.DEVNULL,stderr=err,cwd=work/'switch-inputs');pid,status,usage=os.wait4(proc.pid,0);proc.returncode=os.waitstatus_to_exitcode(status);ms=(time.perf_counter_ns()-tic)/1e6;assert proc.returncode==0,(key,proc.returncode)
   sha=hashlib.sha256(dest.read_bytes()).hexdigest();assert sha==oracle,(key,sha)
   w.writerow([r+1,i+1,key,round(ms,3),round(usage.ru_utime*1e3,3),round(usage.ru_stime*1e3,3),usage.ru_maxrss,usage.ru_minflt,usage.ru_majflt,sha])
