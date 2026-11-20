from pathlib import Path
import csv,subprocess,itertools,statistics,hashlib
p=Path(__file__).resolve().parent;w=p.parents[1];cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';src=w/'independent-corpus/zstd/programs';musl=Path('/home/david/dev/buster-corpus/libc/musl');gen=Path('/home/david/dev/buster-corpus/musl-generated/obj');comp={'clang':cc,'parent':w/'eighteen-control/build/compiler','head':w/'unsigned64/build/compiler'};metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock']
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def save(name,head,rows):
 with (p/name).open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(rows)
def exe(case,v,pad):return p/f'{case}-{v}-{pad}'
base=['-O2','-march=znver5','-w'];defs=['-DNDEBUG','-I'+str(src),'-I'+str(src.parent/'lib'),'-I'+str(src.parent/'lib/common')];mus=['-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700']
for z in [musl/'arch/x86_64',musl/'arch/generic',gen/'src/internal',musl/'src/include',musl/'src/internal',gen/'include',musl/'include']:mus+=['-I',z]
run(cc,*base,*defs,'-c',src/'timefn.c','-o',p/'time.o');run(cc,*base,*defs,'-c',src/'util.c','-o',p/'util.o');rows=[];checks=[];gold={};pads=[0,16,32,48]
for pad in pads:run(cc,'-c','-x','assembler','-','-o',p/f'p{pad}.o',input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode())
for case,v in itertools.product(['load','clock'],comp):
 source=src/'benchfn.c' if case=='clock' else musl/'src/legacy/getloadavg.c';harness=p/('bench.c' if case=='clock' else 'getload.c');obj=p/f'{case}-{v}.o';extra=defs if case=='clock' else mus
 run(comp[v],*base,*(['-ffp-model=strict','-fno-vectorize','-fno-slp-vectorize'] if v=='clang' else ['--tier1','--lanes','1']),*extra,'-c',source,'-o',obj)
 run(cc,'-O2','-march=x86-64-v3','-ffp-model=strict','-fno-builtin',*defs,'-c',harness,'-o',p/f'{case}-driver.o');asm=run('objdump','-d','-Mintel',obj,capture_output=True,text=True).stdout;(p/f'{case}-{v}.asm').write_text(asm);extra=[p/'time.o',p/'util.o','-Wl,--wrap=UTIL_getTime,--wrap=UTIL_clockSpanNano'] if case=='clock' else ['-Wl,--wrap=sysinfo']
 for pad in pads:
  e=exe(case,v,pad);run(cc,'-no-pie',p/f'{case}-driver.o',p/f'p{pad}.o',obj,*extra,'-o',e)
  fn='BMK_benchFunction' if case=='clock' else 'getloadavg';n=next(z.split() for z in run('nm','-S',e,capture_output=True,text=True).stdout.splitlines() if z.endswith(' '+fn));rows.append([case,v,pad,sha(source),sha(obj),sha(e),n[0],int(n[1],16),asm.count('vcvtusi2s')])
  for key in ['0','1']:
   result=run(e,key,capture_output=True,text=True).stdout.strip();assert result==gold.setdefault((case,key),result);checks.append([case,v,pad,key,result])
save('identities.tsv',['application','compiler','pad','source','object','exe','address','function_bytes','object_unsigned_conversions'],rows);save('checks.tsv',['application','compiler','pad','workload','result'],checks)
cells=list(itertools.product(['load','clock'],pads));raw=[];data={}
for r in range(9):
 for i in range(len(cells)):
  case,pad=cells[(i+3*r)%len(cells)]
  for v in (['parent','head'] if (r+i)%2 else ['head','parent']):
   stat=p/'last.stat';res=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',stat,'--',exe(case,v,pad),1,capture_output=True,text=True).stdout.strip();assert res==gold[case,'1'];vls={a[2]:float(a[0]) for l in stat.read_text().splitlines() if len(a:=l.split(';'))>=3 and a[2] in metrics};data[r,case,pad,v]=vls;raw.append([r,case,pad,v,res,*[vls[m] for m in metrics]])
save('observations.tsv',['round','application','pad','compiler','result',*metrics],raw);out=[]
for case,pad in cells:
 for m in metrics:
  a=[data[r,case,pad,'parent'][m] for r in range(1,9)];b=[data[r,case,pad,'head'][m] for r in range(1,9)];z=[100*(y/x-1) for x,y in zip(a,b) if x];out.append([case,pad,m,len(z),statistics.median(a),statistics.median(b),statistics.median(z),min(z),max(z)])
save('paired.tsv',['application','pad','metric','pairs','parent','head','paired_percent','min_percent','max_percent'],out)
