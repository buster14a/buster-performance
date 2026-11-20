from pathlib import Path
import csv,hashlib,json,os,resource,statistics,subprocess,sys,tempfile,time
p=Path(__file__).resolve().parent;w=p.parents[1];src=w/'compile-evidence';raw=p/'observations';raw.mkdir(exist_ok=True);bins={'control':w/'nov20-main-control/build/compiler','candidate':w/'twelve-candidate/build/compiler'};cases={'sqlite-release':['--tier1','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION','inputs/sqlite3.c'],'sqlite-debug':['--tier1','-g','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION','inputs/sqlite3.c'],'lua-vm-debug':['--tier1','-g','-std=gnu99','-DLUA_COMPAT_5_3','-DLUA_USE_LINUX','inputs/lua/lvm.c'],'lua-parser-release':['--tier1','-std=gnu99','-DLUA_COMPAT_5_3','-DLUA_USE_LINUX','inputs/lua/lparser.c']};metrics=['instructions:u','cycles:u','task-clock'];counts=[1,2,4];os.environ.update(SOURCE_DATE_EPOCH='1792454400',LC_ALL='C')
def tab(name,header,rows):
 with (p/name).open('w') as f:
  out=csv.writer(f,delimiter='\t',lineterminator='\n');out.writerow(header);out.writerows(rows)
if sys.argv[1]=='run':
 schedule=[(case,n) for case in cases for n in counts]
 for rep in range(8):
  for j in range(len(schedule)):
   case,n=schedule[(j+5*rep)%len(schedule)]
   if not all((raw/f'{rep}-{case}-{n}-{v}.json').exists() for v in bins):subprocess.run(['cores','-n',str(n),'--',sys.executable,__file__,'pair',str(rep),case,str(n)],check=True,env=dict(os.environ,CORES_TITLE=f'Compare combined compiler scaling on {case} at {n} lanes',CORES_LINK='https://github.com/buster14a/buster/pull/3130'))
  print('round',rep,'finished',flush=True)
elif sys.argv[1]=='pair':
 rep=int(sys.argv[2]);case=sys.argv[3];n=int(sys.argv[4]);cores={}
 for cpu in sorted(os.sched_getaffinity(0)):
  f=Path(f'/sys/devices/system/cpu/cpu{cpu}/topology');key=(int((f/'physical_package_id').read_text()),int((f/'core_id').read_text()));cores.setdefault(key,cpu)
 assert len(cores)>=n;cpus=list(cores.values())[:n];os.sched_setaffinity(0,cpus);order=list(bins);order=order[::-1] if (rep+list(cases).index(case)+counts.index(n))%2 else order
 for v in order:
  name=f'{rep}-{case}-{n}-{v}';done=raw/(name+'.json');stat=raw/(name+'.stat');log=raw/(name+'.log')
  if done.exists():continue
  with tempfile.TemporaryDirectory(dir='/dev/shm') as t,log.open('wb') as f:
   obj=Path(t)/'unit.o';cmd=['perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',str(stat),'--',str(bins[v]),'-O2','-march=znver5','--lanes',str(n),'--lane-cpus',','.join(map(str,cpus)),'-w',*cases[case],'-c','-o',str(obj)];t0=time.monotonic_ns();child=subprocess.Popen(cmd,stdout=f,stderr=f,cwd=src);pid,s,r=os.wait4(child.pid,0);elapsed=(time.monotonic_ns()-t0)*1e-6;child.returncode=os.waitstatus_to_exitcode(s);assert child.returncode==0,(name,log.read_text());a={z[2]:float(z[0]) for l in stat.read_text().splitlines() if len(z:=l.split(';'))>=3};data=dict(round=rep,case=case,lanes=n,variant=v,cpus=','.join(map(str,cpus)),elapsed_ms=elapsed,peak_kib=r.ru_maxrss,minor_faults=r.ru_minflt,object_sha=hashlib.file_digest(obj.open('rb'),'sha256').hexdigest(),**{m:a[m] for m in metrics});tmp=done.with_suffix('.tmp');tmp.write_text(json.dumps(data)+'\n');tmp.replace(done)
elif sys.argv[1]=='summary':
 rows=[json.loads(f.read_text()) for f in sorted(raw.glob('*.json'))];assert len(rows)==8*len(cases)*len(counts)*2;cols=['round','case','lanes','variant','cpus','elapsed_ms','peak_kib','minor_faults',*metrics,'object_sha'];tab('counters.tsv',cols,[[r[k] for k in cols] for r in rows]);result=[]
 for case in cases:
  for v in bins:assert len({x['object_sha'] for x in rows if x['case']==case and x['variant']==v})==1,(case,v)
  for n in counts:
   for metric in ['elapsed_ms','peak_kib','minor_faults',*metrics]:
    data={v:{r['round']:r[metric] for r in rows if r['round'] and r['case']==case and r['lanes']==n and r['variant']==v} for v in bins};paired=[100*(data['candidate'][i]/data['control'][i]-1) for i in range(1,8)];result.append([case,n,metric,7,statistics.median(data['control'].values()),statistics.median(data['candidate'].values()),statistics.median(paired),min(paired),max(paired)])
 tab('summary.tsv',['workload','physical_cores','metric','pairs','control','candidate','paired_percent','min_percent','max_percent'],result)
