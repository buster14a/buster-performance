from pathlib import Path
import csv,hashlib,itertools,os,statistics,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];d=p/'programs';d.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';vs={'parent':w/'fma/build/compiler','candidate':w/'fma-addend/build/compiler'};names=['square-plus-bias','gain-plus-bias','integer-gain','dependent-filter','two-outputs'];widths=[32,64];pads=[0,16,32,48];metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];os.environ.update(SOURCE_DATE_EPOCH='1792454400',LC_ALL='C')
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def save(n,hd,rows):
 with (p/n).open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(hd);t.writerows(rows)
def exe(k,b,v,pad):return d/f'{k}-{b}-{v}-{pad}'
if sys.argv[1]=='build':
 rows=[];objs=[];loc={};gold={}
 for k,n in enumerate(names):
  for b in widths:
   ref=d/f'clang-{k}-{b}.o';main=d/f'main-{b}.o';flags=['-O2','-ffp-contract=on','-fno-vectorize','-fno-slp-vectorize','-fno-unroll-loops','-march=x86-64-v3','-DWIDTH='+str(b)]
   run(cc,*flags,'-c',p/'driver.c','-o',main);run(cc,*flags,'-DKIND='+str(k),'-DNAME=reference','-c',p/'kernel.c','-o',ref)
   for v,c in vs.items():
    obj=d/f'{k}-{b}-{v}.o';run(c,'--tier1','--verify','--lanes','1','-O2','-ffp-contract=on','-march=znver5','-DKIND='+str(k),'-DWIDTH='+str(b),'-c',p/'kernel.c','-o',obj)
    asm=run('objdump','-d','-Mintel','--no-show-raw-insn',obj,capture_output=True,text=True).stdout;obj.with_suffix('.asm').write_text(asm);objs.append([n,b,v,sha(obj),sum('vfmadd' in l for l in asm.splitlines()),sum('vfmadd213' in l and 'PTR' in l for l in asm.splitlines())])
    for pad in pads:
     out=exe(k,b,v,pad);run(cc,'-no-pie',main,ref,w/'x87-double-evidence/loops/programs'/f'pad{pad}.o',obj,'-o',out)
     addr,size=[int(z,16) for z in next(l.split() for l in run('nm','-S',out,capture_output=True,text=True).stdout.splitlines() if l.endswith(' kernel'))[:2]];assert addr%64==pad and addr==loc.setdefault((k,b,pad),addr)
     h=run(out,640,capture_output=True,text=True).stdout.strip();assert h==gold.setdefault((k,b),h);rows.append([n,b,v,pad,out.name,hex(addr),size,sha(out),h])
 save('programs.tsv',['case','bits','variant','pad','name','address','bytes','sha256','oracle'],rows);save('objects.tsv',['case','bits','variant','sha256','all_fma','memory_213'],objs)
else:
 cells=list(itertools.product(range(5),widths,pads));rows=[];values={};gold={};stat=p/'last.stat'
 for r in range(9):
  for j in range(len(cells)):
   k,b,pad=cells[(j+11*r)%len(cells)]
   for v in (list(vs) if (j+r)%2 else list(vs)[::-1]):
    h=run('perf','stat','-e',','.join(metrics),'-x',';','--no-big-num','-o',stat,'--',exe(k,b,v,pad),640,capture_output=True,text=True).stdout.strip();assert h==gold.setdefault((k,b),h)
    c={z[2]:float(z[0]) for l in stat.read_text().splitlines() if len(z:=l.split(';'))>2 and z[2] in metrics};values[r,k,b,pad,v]=c;rows.append([r,names[k],b,pad,v,h,*[c[m] for m in metrics]])
  print(r,flush=True)
 save('observations.tsv',['round','case','bits','pad','variant','oracle',*metrics],rows);out=[]
 for k,b,pad in cells:
  for m in metrics:
   a=[values[r,k,b,pad,'parent'][m] for r in range(1,9)];c=[values[r,k,b,pad,'candidate'][m] for r in range(1,9)];z=[100*(y/x-1) for x,y in zip(a,c) if x];out.append([names[k],b,pad,m,len(z),statistics.median(a),statistics.median(c),statistics.median(z),min(z),max(z)])
 save('paired.tsv',['case','bits','pad','metric','pairs','parent','candidate','paired_percent','min_percent','max_percent'],out)
