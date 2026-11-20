from pathlib import Path
import csv,hashlib,os,statistics,subprocess
p=Path(__file__).resolve().parent;vm=p.parent/'vm';out=p/'programs';cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
def tab(name,header,rows):
 with (p/name).open('w') as f:
  w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(header);w.writerows(rows)
def digest(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
env=dict(os.environ,LC_ALL='C',SQLITE_TMPDIR='/dev/shm');variants=['default','sorter','sorter-kept','all16','all32','all64','full64-kept'];pads=[0,16,32,48];sizes=[4096,32768,131072];modes=['memory','spill'];rounds=7;markers=['instructions:u','cycles:u','task-clock'];oracles={(int(r['rows']),r['store']):r['expected'] for r in csv.DictReader((p/'oracles.tsv').open(),delimiter='\t')}
identities=[];programs={}
for v in variants:
 for pad in pads:
  f=out/f'sort-{v}-{pad}'
  if v.endswith('-kept'):
   run(cc,'-no-pie',out/'driver.o',out/f'pad{pad}.o',vm/(v+'.o'),'-lm','-lpthread','-o',f)
  nm=next(l.split() for l in run('nm','-S',f,capture_output=True,text=True).stdout.splitlines() if l.endswith(' sqlite3VdbeExec'));programs[v,pad]=f;identities.append([v,pad,f.name,digest(f),int(nm[0],16),int(nm[1],16)])
tab('measured-programs.tsv',['variant','padding','program','sha256','VM_address','VM_bytes'],identities)
cases=[(n,m,pad) for n in sizes for m in modes for pad in pads];raw=p/'counters';raw.mkdir(exist_ok=True);rows=[];data={}
for rep in range(rounds):
 for i in range(len(cases)):
  n,m,pad=cases[(i+7*rep)%len(cases)]
  for k in range(len(variants)):
   v=variants[(i+rep+(k if rep%2==0 else -k))%len(variants)];f=raw/f'{rep}-{n}-{m}-{pad}-{v}.stat';ok=f.with_suffix('.ok')
   if not ok.exists():
    q=run('perf','stat','--no-big-num','-x',';','-e',','.join(markers),'-o',f,'--',programs[v,pad],m,p/'input.db',n,env=env,capture_output=True,text=True);assert q.stdout.strip()==oracles[n,m];ok.write_text(q.stdout)
   assert ok.read_text().strip()==oracles[n,m];mvals={z[2]:float(z[0]) for l in f.read_text().splitlines() if len(z:=l.split(';'))>=3};rows.append([rep,n,m,pad,v,*[mvals[t] for t in markers],oracles[n,m]]);data[(rep,n,m,pad,v)]=mvals
 print('round',rep,'completed',flush=True)
tab('counters.tsv',['round','rows','store','padding','variant',*markers,'expected'],rows);summary=[]
for n,m,pad in cases:
 for v in variants[1:]:
  for t in markers:
   a=[data[r,n,m,pad,'default'][t] for r in range(1,rounds)];b=[data[r,n,m,pad,v][t] for r in range(1,rounds)];pc=[100*(y/x-1) for x,y in zip(a,b)];summary.append([n,m,pad,'default',v,t,len(a),statistics.median(a),statistics.median(b),statistics.median(pc),min(pc),max(pc)])
tab('paired.tsv',['rows','store','padding','base','candidate','metric','pairs','base_median','candidate_median','paired_percent','minimum_percent','maximum_percent'],summary)
