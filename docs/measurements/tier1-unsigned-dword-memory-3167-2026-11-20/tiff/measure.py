from pathlib import Path
from statistics import median
import csv,hashlib,itertools,json,os,shlex,subprocess
p=Path(__file__).resolve().parent;w=p.parents[1];d=p/'programs';d.mkdir(exist_ok=True);src=p/'tiff-4.7.1';ref=p/'reference';cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
run=lambda *v,**k:subprocess.run(list(map(str,v)),check=True,**k);sha=lambda f:hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def table(n,cols,rows):
 with(p/n).open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(cols);t.writerows(rows)
cmd=next(x for x in json.loads((ref/'compile_commands.json').read_text()) if x['file'].endswith('/tif_dirread.c'));pargs=shlex.split(cmd['command'])[1:];i=pargs.index('-o');arc=next(ref.rglob('libtiff.a'));run(cc,'-std=gnu11','-O2','-I'+str(src/'libtiff'),'-I'+str(ref/'libtiff'),'-c',p/'read.c','-o',d/'driver.o');exes={};ds=[];ids=[];gold={};symbols={}
for v,c in [('clang',cc),('parent',w/'convert/build/compiler'),('candidate',w/'u32-memory/build/compiler')]:
 o=d/(v+'.o');args=pargs.copy();args[i+1]=str(o);args=['-O2' if x.startswith('-O') else x for x in args];run(c,*(['--tier1','--lanes','1','-w'] if v!='clang' else []),'-march='+('x86-64-v3' if v=='clang' else 'znver5'),*args,cwd=cmd['directory'])
 nm=run('nm','-S','--defined-only',o,capture_output=True,text=True).stdout;symbols[v]={x[3]:int(x[1],16) for l in nm.splitlines() if len(x:=l.split())==4 and x[2] in ['t','T']}
 asm=run('objdump','-d','-Mintel','--no-show-raw-insn',o,capture_output=True,text=True).stdout;symbol='';sites=[]
 for l in asm.splitlines():
  if l.endswith('>:'):symbol=l.split('<')[-1][:-2]
  elif 'vcvtusi2' in l and 'DWORD PTR' in l:sites.append([v,symbol,l.split(':',1)[-1].strip()])
 ds.extend(sites)
 for pad in [0,16,32,48]:
  po=d/f'pad-{pad}.o';run(cc,'-x','assembler','-c','-','-o',po,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode());e=d/f'{v}-{pad}';run(cc,'-no-pie',d/'driver.o',po,o,arc,'-lm','-o',e);exes[v,pad]=e
  for endian,n in itertools.product(['le','be'],[64,1024,4096]):
   fi=p/f'{endian}-{n}.tif';r=run(e,fi,n,1,capture_output=True,text=True).stdout.strip();assert gold.setdefault((endian,n),r)==r;ids.append([v,pad,endian,n,sha(o),sha(e),sha(fi),r])
table('programs.tsv',['compiler','placement','byte_order','samples','object_sha256','exe_sha256','image_sha256','verified'],ids);table('sites.tsv',['compiler','function','instruction'],ds)
table('functions.tsv',['function','parent','candidate','delta'],[[name,symbols['parent'][name],symbols['candidate'][name],symbols['candidate'][name]-symbols['parent'][name]] for name in sorted(symbols['parent'].keys()&symbols['candidate'].keys()) if symbols['parent'][name]!=symbols['candidate'][name]])
cases=list(itertools.product(['le','be'],[64,4096],[0,16,32,48]));data={};obs=[];metrics=['instructions:u','cycles:u','branches:u','branch-misses:u','task-clock'];outcheck={}
for r in range(8):
 for ncase in range(len(cases)):
  endian,n,pad=cases[(ncase+5*r)%len(cases)];reps=256 if n==4096 else 1024;image=p/f'{endian}-{n}.tif'
  for v in (['parent','candidate'] if (r+ncase)%2==0 else ['candidate','parent']):
   st=d/'last.stat';out=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',st,'--',exes[v,pad],image,n,reps,capture_output=True,text=True).stdout.strip();assert out==outcheck.setdefault((endian,n),out)
   vals={x[2]:float(x[0]) for z in st.read_text().splitlines() if len(x:=z.split(';'))>=3};data[r,endian,n,pad,v]=vals;obs.append([r,endian,n,pad,v,*[vals[m] for m in metrics],out])
 print('round',r,flush=True)
table('processes.tsv',['round','byte_order','samples','pad','compiler',*metrics,'validated'],obs);paired=[]
for en,n,pad in cases:
 for metric in metrics:
  a=[data[r,en,n,pad,'parent'][metric] for r in range(1,8)];b=[data[r,en,n,pad,'candidate'][metric] for r in range(1,8)];diff=[100*(y/x-1) for x,y in zip(a,b) if x];paired.append([en,n,pad,metric,median(a),median(b),median(diff),min(diff),max(diff)])
table('paired.tsv',['byte_order','samples','pad','metric','parent','candidate','paired_percent','min','max'],paired)
