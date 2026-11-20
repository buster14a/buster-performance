from pathlib import Path
import csv,hashlib,os,statistics,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];d=p/'programs';d.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';variants={'clang':cc,'parent':w/'x87-double/build/compiler','narrow':w/'x87-rom/build/compiler'};names=['zero','one','choice','control'];pads=[0,16,32,48];metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400');args=['-O2','-march=znver5','-ffp-model=strict','-ffp-contract=off','-fno-unroll-loops']
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def tab(f,header,rows):
 with (p/f).open('w') as out:t=csv.writer(out,delimiter='\t',lineterminator='\n');t.writerow(header);t.writerows(rows)
def symbol(f):return [int(x,16) for x in next(l.split() for l in run('nm','-S',f,capture_output=True,text=True).stdout.splitlines() if l.endswith(' kernel'))[:2]]
if sys.argv[1]=='build':
 run(cc,*args,'-c',p/'driver.c','-o',d/'driver.o')
 for pad in pads:run(cc,'-x','assembler','-c','-','-o',d/f'pad{pad}.o',input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode())
 rows=[];objs=[];digests={};locations={}
 for i,name in enumerate(names):
  ref=d/(name+'-reference.o');run(cc,*args,'-DCASE='+str(i),'-DNAME=reference','-c',p/'kernel.c','-o',ref)
  for v,exe in variants.items():
   for a in ['x86-64','znver5']:
    obj=d/f'{name}-{v}-{a}.o';flags=args if v=='clang' else ['--tier1','--lanes','1','-O2'];run(exe,*flags,'-march='+a,'-DCASE='+str(i),'-c',p/'kernel.c','-o',obj);asm=run('objdump','-d','-Mintel','--no-show-raw-insn',obj,capture_output=True,text=True).stdout;(d/(obj.stem+'.asm')).write_text(asm);objs.append([name,v,a,sha(obj),symbol(obj)[1],asm.count('fld    DWORD PTR'),asm.count('fld    TBYTE PTR'),asm.count('fld    QWORD PTR'),asm.count('fldz'),asm.count('fld1')])
    if a!='znver5':continue
    for pad in pads:
     f=d/f'{name}-{v}-{pad}';run(cc,'-no-pie',d/'driver.o',ref,d/f'pad{pad}.o',obj,'-o',f);address,size=symbol(f);assert address%64==pad and locations.setdefault((name,pad),address)==address
     h=run(f,1536,capture_output=True,text=True).stdout.strip();assert digests.setdefault(name,h)==h;rows.append([name,v,pad,f.name,hex(address),size,sha(f),h])
 tab('programs.tsv',['case','variant','pad','exe','address','kernel_bytes','sha256','oracle'],rows);tab('objects.tsv',['case','variant','architecture','sha256','kernel_bytes','fld32','fld80','fld64','fldz','fld1'],objs)
elif sys.argv[1]=='time':
 cases=[(n,pad) for n in names for pad in pads];progs={(r['case'],r['variant'],int(r['pad'])):r for r in csv.DictReader((p/'programs.tsv').open(),delimiter='\t')};rows=[];idx={};raw=p/'raw';raw.mkdir(exist_ok=True)
 for r in range(9):
  for j in range(len(cases)):
   n,pad=cases[(j+3*r)%len(cases)]
   for v in (['parent','narrow'] if (j+r)%2==0 else ['narrow','parent']):
    k=progs[n,v,pad];s=raw/f'{r}-{n}-{pad}-{v}.stat';h=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',s,'--',d/k['exe'],1536,capture_output=True,text=True).stdout.strip();assert h==k['oracle'];a={t[2]:float(t[0]) for line in s.read_text().splitlines() if len(t:=line.split(';'))>=3};idx[r,n,pad,v]=a;rows.append([r,n,pad,v,*[a[m] for m in metrics],h])
  print('round',r,flush=True)
 tab('counters.tsv',['round','case','pad','variant',*metrics,'oracle'],rows);results=[]
 for n,pad in cases:
  for m in metrics:
   a=[idx[r,n,pad,'parent'][m] for r in range(1,9)];b=[idx[r,n,pad,'narrow'][m] for r in range(1,9)];ds=[100*(y/x-1) for x,y in zip(a,b)];results.append([n,pad,m,len(a),statistics.median(a),statistics.median(b),statistics.median(ds),min(ds),max(ds)])
 tab('paired.tsv',['case','pad','metric','pairs','base_median','candidate_median','paired_percent','min_percent','max_percent'],results)
