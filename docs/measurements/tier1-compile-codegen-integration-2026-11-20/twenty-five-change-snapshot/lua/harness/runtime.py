from pathlib import Path
import csv,hashlib,itertools,os,random,statistics,subprocess
p=Path(__file__).resolve().parent;w=p.parents[1];b=p/'bench';b.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';scripts=sorted((w/'lua-layout-evidence/scripts').glob('*.lua'));metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];os.environ['LC_ALL']='C'
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def table(n,cols,rows):
 with (b/n).open('w') as h:q=csv.writer(h,delimiter='\t',lineterminator='\n');q.writerow(cols);q.writerows(rows)
objects=sorted(f.with_suffix('.o').name for f in (p/'lua-5.4.8/src').glob('*.c') if f.name not in ['luac.c','onelua.c']);assert len(objects)==33
cases=[];layouts=[];programs=[];expected={s.stem:(w/'lea-evidence/lua-clang'/(s.stem+'.result')).read_bytes() for s in scripts}
for layout in range(4):
 order=list(objects)
 if layout:random.Random(1680007+layout).shuffle(order)
 layouts.extend([[layout,i,o] for i,o in enumerate(order)])
 for v in ['clang','control','candidate']:
  d=p/('release-'+v);e=b/f'{v}-{layout}';run(cc,'-no-pie','-Wl,-E',*[d/f for f in order],'-lm','-ldl','-o',e)
  symbols=run('nm','-S','--defined-only',e,capture_output=True,text=True).stdout.splitlines();addr,n,*_=next(l.split() for l in symbols if l.endswith(' luaV_execute'));programs.append([v,layout,sha(e),e.stat().st_size,addr,int(n,16)])
  for s in scripts:
   result=run(e,s,capture_output=True).stdout;assert result==expected[s.stem];cases.append([layout,v,s.stem,result.decode().strip()])
table('programs.tsv',['compiler','layout','sha256','exe_bytes','luaV_execute_address','luaV_execute_bytes'],programs);table('checks.tsv',['layout','compiler','workload','expected'],cases);table('orders.tsv',['layout','index','object'],layouts)
obs=[];results={};cells=list(itertools.product(range(4),scripts))
for r in range(8):
 for n in range(len(cells)):
  pad,s=cells[(n+7*r)%len(cells)]
  for v in (['candidate','control'] if (r+n)%2 else ['control','candidate']):
   e=b/f'{v}-{pad}';f=b/'last.stat';o=run('perf','stat','-x',';','--no-big-num','-e',','.join(metrics),'-o',f,'--',e,s,capture_output=True).stdout;assert o==expected[s.stem]
   vals={z[2]:float(z[0]) for line in f.read_text().splitlines() if len(z:=line.split(';'))>=3 and z[2] in metrics};obs.append([r,pad,s.stem,v,*[vals[m] for m in metrics],hashlib.sha256(o).hexdigest()]);results[r,pad,s.stem,v]=vals
 print(r,flush=True)
table('processes.tsv',['round','layout','workload','compiler',*metrics,'output_sha256'],obs);zr=[]
for l,s in cells:
 for m in metrics:
  a=[results[r,l,s.stem,'control'][m] for r in range(1,8)];c=[results[r,l,s.stem,'candidate'][m] for r in range(1,8)];diff=[100*(y/x-1) for x,y in zip(a,c) if x];zr.append([l,s.stem,m,len(diff),statistics.median(a),statistics.median(c),statistics.median(diff),min(diff),max(diff)])
table('paired.tsv',['layout','workload','metric','pairs','parent','head','paired_percent','minimum_percent','maximum_percent'],zr)
