from pathlib import Path
import csv,hashlib,os,re,statistics,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];d=p/'programs';d.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';compilers={'clang':cc,'base':w/'convert/build/compiler','head':w/'u32-memory/build/compiler'};kinds=[(32,o,1) for o in (32,64)];pads=[0,16,32,48];unrolls=[1,8];metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];rounds=8;os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
def run(*cmd,**kw):return subprocess.run(list(map(str,cmd)),check=True,**kw)
def tab(name,cols,rows):
 with (p/name).open('w') as f:
  t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(cols);t.writerows(rows)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def tag(i,o,u):return f'u{i}-f{o}'
if sys.argv[1]=='build':
 objects=[];exes=[];expected={};locations={}
 for pad in pads:
  run(cc,'-x','assembler','-c','-','-o',d/f'pad-{pad}.o',input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode())
 for i,o,u in kinds:
  k=tag(i,o,u);ds=[f'-DIN_WIDTH={i}',f'-DOUT_WIDTH={o}',f'-DUNSIGNED_OUTPUT={u}'];driver=d/(k+'-driver.o');run(cc,'-std=gnu11','-O2','-ffp-model=strict','-fno-vectorize','-fno-slp-vectorize','-march=x86-64',*ds,'-c',p/'driver.c','-o',driver)
  for n in unrolls:
   for v,c in compilers.items():
    for arch in ['x86-64','znver5']:
     f=d/f'{k}-{n}-{v}-{arch}.o';a=['--tier1','--lanes','1'] if v!='clang' else ['-fno-unroll-loops','-fno-vectorize','-fno-slp-vectorize'];run(c,*a,'-O2','-march='+arch,*ds,f'-DUNROLL={n}','-c',p/'stream.c','-o',f);nm=next(l.split() for l in run('nm','-S',f,capture_output=True,text=True).stdout.splitlines() if l.endswith(' stream'));objects.append([k,n,v,arch,sha(f),int(nm[1],16)]);(d/(f.stem+'.asm')).write_bytes(run('objdump','-d','-Mintel',f,capture_output=True).stdout)
     if arch!='znver5':continue
     for pad in pads:
      exe=d/f'{k}-{n}-{v}-{pad}';run(cc,'-no-pie',driver,d/f'pad-{pad}.o',f,'-o',exe);label=next(l for l in run('nm','-S',exe,capture_output=True,text=True).stdout.splitlines() if l.endswith(' stream')).split();addr,size=(int(x,16) for x in label[:2]);assert addr%64==pad and locations.setdefault((k,pad),addr)==addr
      for dirty in [0,1]:
       h=run(exe,1024,dirty,capture_output=True,text=True).stdout.strip();assert expected.setdefault(k,h)==h
      exes.append([k,n,v,pad,exe.name,hex(addr),size,sha(exe),h])
 tab('objects.tsv',['kind','unroll','compiler','architecture','sha256','stream_bytes'],objects);tab('programs.tsv',['kind','unroll','compiler','padding','program','address','stream_bytes','sha256','expected'],exes)
elif sys.argv[1]=='time':
 progs={(r['kind'],int(r['unroll']),r['compiler'],int(r['padding'])):r for r in csv.DictReader((p/'programs.tsv').open(),delimiter='\t')};cases=[(tag(*x),n,pad,state) for x in kinds for n in unrolls for pad in pads for state in [0,1]];raw=p/'raw';raw.mkdir(exist_ok=True);rows=[];vals={}
 for r in range(rounds):
  for pos in range(len(cases)):
   k,n,pad,state=cases[(pos+11*r)%len(cases)]
   for v in (['base','head'] if (r+pos)%2==0 else ['head','base']):
    prog=progs[k,n,v,pad];f=raw/f'{r}-{k}-{n}-{pad}-{state}-{v}.stat';ok=f.with_suffix('.ok')
    if not ok.exists():
     h=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',f,'--',d/prog['program'],1024,state,capture_output=True,text=True).stdout.strip();assert h==prog['expected'];ok.write_text(h+'\n')
    assert ok.read_text().strip()==prog['expected'];meas={x[2]:float(x[0]) for l in f.read_text().splitlines() if len(x:=l.split(';'))>=3};vals[r,k,n,pad,state,v]=meas;rows.append([r,k,n,pad,state,v,*[meas[t] for t in metrics],prog['expected']])
  print('round',r,'finished',flush=True)
 tab('counters.tsv',['round','kind','unroll','pad','dirty','compiler',*metrics,'verified'],rows);summ=[]
 for k,n,pad,state in cases:
  for met in metrics:
   a=[vals[r,k,n,pad,state,'base'][met] for r in range(1,rounds)];b=[vals[r,k,n,pad,state,'head'][met] for r in range(1,rounds)];ds=[100*(y/x-1) for x,y in zip(a,b)];summ.append([k,n,pad,state,met,len(a),statistics.median(a),statistics.median(b),statistics.median(ds),min(ds),max(ds)])
 tab('paired.tsv',['kind','unroll','pad','dirty','metric','pairs','base_median','head_median','paired_percent','minimum_percent','maximum_percent'],summ)
