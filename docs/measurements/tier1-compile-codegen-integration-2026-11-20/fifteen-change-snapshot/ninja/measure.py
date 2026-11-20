from pathlib import Path
from statistics import median
import csv,hashlib,itertools,json,os,shlex,subprocess,sys,tempfile,time
p=Path(__file__).resolve().parent;w=p.parents[1];raw=p/'runs';raw.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';sourcesdir=w/'fifteen-control';previous=w/'integration-evidence';variants=['control','candidate'];modes=['buster-release','lua-release','lua-debug'];jobs=[1,2,4];rounds=7
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def nul(f):return [x.decode() for x in f.read_bytes().split(b'\0') if x]
def table(dest,header,rows):
 with (p/dest).open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(header);t.writerows(rows)
def ninja_name(s):return str(s).replace('$','$$').replace(' ','$ ').replace(':','$:')
def run_timed(cmd,cwd):
 start=time.monotonic_ns();r=run(*cmd,cwd=cwd,capture_output=True,text=True,timeout=350);return (time.monotonic_ns()-start)/1e6
if sys.argv[1]=='run':
 cases=list(itertools.product(modes,jobs))
 for r in range(rounds):
  for i in range(len(cases)):
   m,n=cases[(r+i)%len(cases)]
   if all((raw/f'{r}-{m}-{n}-{v}.json').exists() for v in variants):continue
   run('cores','-n',n,'--',sys.executable,__file__,'pair',r,m,n,env=dict(os.environ,CORES_TITLE=f'Clean {m} builds with Ninja and {n} physical cores',CORES_LINK='https://github.com/buster14a/buster/pull/3133'))
  print('round',r,flush=True)
 run(sys.executable,__file__,'sum')
elif sys.argv[1]=='pair':
 r=int(sys.argv[2]);mode=sys.argv[3];n=int(sys.argv[4]);physical={}
 for cpu in sorted(os.sched_getaffinity(0)):
  loc=Path(f'/sys/devices/system/cpu/cpu{cpu}/topology');physical.setdefault(((loc/'physical_package_id').read_text(),(loc/'core_id').read_text()),cpu)
 cpus=list(physical.values())[:n];assert len(cpus)==n;os.sched_setaffinity(0,cpus)
 os.environ.update(SOURCE_DATE_EPOCH='1792454400',BUSTER_TEST_HOST_BUSY='0',LC_ALL='C')
 cwd=sourcesdir
 if mode.startswith('lua-'):
  cwd=w/'compile-evidence';sources=[str(f.relative_to(cwd)) for f in sorted((cwd/'inputs/lua').glob('*.c')) if f.name not in ('luac.c','onelua.c')];flags=['--tier1','-O2','-march=znver5','-std=gnu99','-DLUA_COMPAT_5_3','-DLUA_USE_LINUX','-w']+(['-g'] if mode.endswith('debug') else [])
 else:sources=nul(previous/'sources.argv');flags=nul(previous/'tier1-flags.argv')
 order=variants[::-1] if (r+modes.index(mode)+jobs.index(n))%2 else variants
 for v in order:
  report=raw/f'{r}-{mode}-{n}-{v}.json'
  if report.exists():continue
  with tempfile.TemporaryDirectory(prefix='buster-ninja-',dir='/dev/shm') as t:
   tmp=Path(t);build=tmp/'build.ninja';objects=[tmp/f'unit-{i:04}.o' for i in range(len(sources))];compiler=w/('fifteen-'+v)/'build/compiler';out=tmp/'linked'
   text=['builddir = '+ninja_name(tmp), 'rule compile','  command = '+shlex.join([str(compiler),'--lanes','1',*flags])+' -c $in -o $out', 'rule link','  command = '+shlex.quote(cc)+' -no-pie $in -lm -ldl -lpthread -o $out']
   for o,f in zip(objects,sources):text.append('build '+ninja_name(o)+': compile '+ninja_name(f))
   inputs=' '.join(ninja_name(o) for o in objects);text.extend(['build objects: phony '+inputs,'build '+ninja_name(out)+': link '+inputs]);build.write_text('\n'.join(text)+'\n')
   command=['ninja','-f',build,'-j',n];compile_ms=run_timed(command+['objects'],cwd);link_ms=run_timed(command+[str(out)],cwd)
   hashes=[sha(o) for o in objects];digest=hashlib.sha256(('\n'.join(hashes)+'\n').encode()).hexdigest()
   if mode.startswith('lua-'):
    for script in ['calls','tables','strings','arithmetic','closures']:
     assert run(out,w/'lua-layout-evidence/scripts'/(script+'.lua'),capture_output=True).stdout==(w/'lea-evidence/lua-clang'/(script+'.result')).read_bytes()
   else:
    test=run(out,'test-tier1-select',cwd=cwd,capture_output=True,text=True,timeout=180);assert '0 failures' in test.stdout+test.stderr
   row=dict(round=r,project=mode,jobs=n,variant=v,cpus=cpus,units=len(sources),compile_ms=compile_ms,link_ms=link_ms,total_ms=compile_ms+link_ms,object_digest=digest,linked_sha256=sha(out),bytes=out.stat().st_size);report.write_text(json.dumps(row)+'\n')
   print(r,mode,n,v,round(compile_ms),'ms',flush=True)
else:
 data=[json.loads(f.read_text()) for f in sorted(raw.glob('*.json'))];assert len(data)==rounds*len(jobs)*len(modes)*len(variants);header=list(data[0]);table('builds.tsv',header,[[x[h] for h in header] for x in data]);summary=[]
 for mode,n in itertools.product(modes,jobs):
  by={(x['variant'],x['round']):x for x in data if x['project']==mode and x['jobs']==n}
  for v in variants:assert len({(x['object_digest'],x['linked_sha256']) for x in data if x['project']==mode and x['variant']==v})==1
  for m in ['compile_ms','link_ms','total_ms']:
   a=[by['control',i][m] for i in range(1,rounds)];b=[by['candidate',i][m] for i in range(1,rounds)];z=[100*(y/x-1) for x,y in zip(a,b)];summary.append([mode,n,m,len(a),median(a),median(b),median(z),min(z),max(z)])
 table('summary.tsv',['project','jobs','measurement','pairs','base_median_ms','head_median_ms','paired_percent','minimum_percent','maximum_percent'],summary)
