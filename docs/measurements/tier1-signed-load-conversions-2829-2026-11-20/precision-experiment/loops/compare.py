from pathlib import Path
import csv,hashlib,os,statistics,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];out=p/'programs';out.mkdir(exist_ok=True);cc=os.environ.get('CC','clang');variants={'clang':cc,'control':os.environ.get('PARENT',w/'convert/build/compiler'),'zero':os.environ.get('ZERO',w/'precision-load/build/compiler'),'nozero':os.environ.get('DIRECT',w/'precision-nozero/build/compiler')};metrics=['instructions:u','cycles:u','branches:u','branch-misses:u','task-clock'];pads=(0,16,32,48);widths=(32,64);styles=(1,8);os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
def run(*cmd,**kw):return subprocess.run(list(map(str,cmd)),check=True,**kw)
def tab(name,cols,rows):
 with (p/name).open('w') as f:
  wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(cols);wr.writerows(rows)
def digest(path):return hashlib.file_digest(path.open('rb'),'sha256').hexdigest()
if sys.argv[1]=='build':
 items=[];expected={};loc={}
 for width in widths:
  dr=out/f'driver{width}.o';run(cc,'-march=x86-64','-O2','-std=gnu11','-ffp-model=strict','-fno-vectorize','-fno-slp-vectorize',f'-DWIDTH={width}','-c',p/'driver.c','-o',dr)
  for style in styles:
   for v,c in variants.items():
    obj=out/f'{width}-{style}-{v}.o';a=['-fno-unroll-loops','-fno-vectorize','-fno-slp-vectorize'] if v=='clang' else ['--tier1','--lanes','1'];run(c,*a,'-O2','-march=znver5',f'-DUNROLL={style}',f'-DWIDTH={width}','-c',p/'cast.c','-o',obj);(out/(obj.stem+'.asm')).write_bytes(run('objdump','-d','-Mintel',obj,capture_output=True).stdout)
    for pad in pads:
     po=out/f'pad{pad}.o';run(cc,'-x','assembler','-c','-','-o',po,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode());exe=out/f'cast-{width}-{style}-{v}-{pad}';run(cc,'-no-pie',dr,po,obj,'-o',exe);nm=next(l.split() for l in run('nm','-S','--defined-only',exe,capture_output=True,text=True).stdout.splitlines() if l.split()[-1:]==['stream']);addr,size=int(nm[0],16),int(nm[1],16);assert addr%64==pad and loc.setdefault((width,pad),addr)==addr
     for dirty in [0,1]:
      h=run(exe,'1024',str(dirty),capture_output=True,text=True).stdout.strip();assert expected.setdefault(width,h)==h
     items.append([width,style,v,pad,exe.name,addr,size,digest(exe),h])
 tab('programs.tsv',['width','unroll','variant','padding','program','address','code_bytes','sha256','expected'],items)
elif sys.argv[1]=='time':
 progs={(int(r['width']),int(r['unroll']),r['variant'],int(r['padding'])):r for r in csv.DictReader((p/'programs.tsv').open(),delimiter='\t')};settings=[(width,style,pad,dirty) for width in widths for style in styles for pad in pads for dirty in [0,1]];raw=p/'counters';raw.mkdir(exist_ok=True);rows=[]
 for rep in range(8):
  for i in range(len(settings)):
   width,style,pad,dirty=settings[(i+7*rep)%len(settings)];vs=['control','zero','nozero']
   for j in range(3):
    v=vs[(i+rep+(j if rep%2==0 else -j))%3];pr=progs[width,style,v,pad];file=raw/f'{rep}-{width}-{style}-{pad}-{dirty}-{v}.stat';ok=file.with_suffix('.ok');exe=out/pr['program']
    if not ok.exists():
     h=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',file,'--',exe,'1024',str(dirty),capture_output=True,text=True).stdout.strip();assert h==pr['expected'];ok.write_text(h+'\n')
    assert ok.read_text().strip()==pr['expected'];vals={z[2]:float(z[0]) for l in file.read_text().splitlines() if len(z:=l.split(';'))>=3};rows.append([rep,width,style,pad,dirty,v,*[vals[m] for m in metrics],pr['expected']])
  print('round',rep,'complete',flush=True)
 tab('counters.tsv',['round','width','unroll','layout','dirty','variant',*metrics,'expected'],rows);ss=[]
 for k in settings:
  for before,after in [('control','zero'),('control','nozero'),('zero','nozero')]:
   for j,metric in enumerate(metrics[:2]):
    ys={v:[x[6+j] for x in rows if x[0] and x[1:5]==list(k) and x[5]==v] for v in [before,after]};ds=[100*(b/a-1) for a,b in zip(ys[before],ys[after])];assert len(ds)==7;ss.append([*k,before,after,metric,7,statistics.median(ys[before])/(2048*1024),statistics.median(ys[after])/(2048*1024),statistics.median(ds),min(ds),max(ds)])
 tab('paired.tsv',['width','unroll','layout','dirty','before','after','metric','pairs','base_per_element','candidate_per_element','paired_pct','min_pct','max_pct'],ss)
