from pathlib import Path
import csv,hashlib,os,re,statistics,struct,subprocess,sys,tempfile
p=Path(__file__).resolve().parent;w=p.parents[1];src=w/'integration-evidence/sqlite-tree/test/speedtest1.c';frozen=Path('/home/david/dev/buster-corpus/sqlite');cc=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang');progs=p/'programs';progs.mkdir(exist_ok=True);os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400');variants={'clang':cc,'control':w/'nov20-main-control/build/compiler','candidate':w/'twelve-candidate/build/compiler'};pads=[0,16,32,48]
workloads={'main':3,'cte':2,'fp':12,'json':3,'star':3,'orm':5,'rtree':5,'app':3,'parsenumber':3};metrics=['instructions:u','cycles:u','branches:u','branch-misses:u','task-clock']
def run(*cmd,**kw):return subprocess.run(list(map(str,cmd)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def table(name,cols,rows):
 with (p/name).open('w') as f:
  wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(cols);wr.writerows(rows)
def one(exe,case,statfile=None,keep=None):
 with tempfile.TemporaryDirectory(dir='/dev/shm',prefix='bstr-spd-') as t:
  options=['--size',str(workloads[case]),'--testset',case,'--verify','--nomemstat','--singlethread','--nosync']
  if case=='app':options+=[str(Path(t)/'fixture.db')]
  else:options+=['--memdb']
  args=[exe,*options];raw=run(*(['perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',statfile,'--'] if statfile else []),*args,cwd=t,capture_output=True,text=True,timeout=100)
 if keep:keep.write_text(raw.stdout+raw.stderr)
 lines=raw.stdout.splitlines();h=next(l for l in lines if l.startswith('Verification Hash:'))
 cases=len([l for l in lines if re.match(r'^\s*\d+\s+-',l)]);assert cases>0,(case,lines[:4]);return h,cases
if sys.argv[1]=='build':
 run(cc,'-O2','-DSQLITE_ENABLE_RTREE','-I',frozen,'-c',src,'-o',progs/'driver.o'); rows=[]
 for v,c in variants.items():
  obj=progs/(v+'.o');extra=[] if v=='clang' else ['--tier1','--lanes','1','-w'];run(c,*extra,'-O2','-march=znver5','-DSQLITE_ENABLE_RTREE','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION','-c',frozen/'sqlite3.c','-o',obj)
  for pad in pads:
   po=progs/f'pad{pad}.o';run(cc,'-x','assembler','-c','-','-o',po,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode());exe=progs/f'speed-{v}-{pad}';run(cc,'-no-pie',progs/'driver.o',po,obj,'-lm','-lpthread','-o',exe)
   nm=[l.split() for l in run('nm','-S','--defined-only',exe,capture_output=True,text=True).stdout.splitlines()];by={x[3]:x[:2] for x in nm if len(x)==4};rows.append([v,pad,sha(obj),sha(exe),*[int(x,16) for name in ['sqlite3VdbeExec','sqlite3_step','sqlite3_prepare_v2'] for x in by[name]]])
 table('programs.tsv',['variant','layout','amalgamation_sha256','executable_sha256','vdbe_address','vdbe_bytes','step_address','step_bytes','prepare_address','prepare_bytes'],rows)
 out=p/'verification';out.mkdir(exist_ok=True);eq={};rr=[]
 rejected=[]
 for v in variants:
  for pad in pads:
   x=subprocess.run([progs/f'speed-{v}-{pad}','--size','3','--testset','trigger','--verify','--nomemstat','--singlethread','--nosync','--memdb'],capture_output=True,text=True)
   assert x.returncode==1 and 'SQL error: no such table: t1' in x.stderr,(v,pad,x)
   rejected.append([v,pad,x.returncode,x.stderr.strip()])
 table('upstream-trigger.tsv',['compiler','layout','exit','diagnostic'],rejected)
 for case in workloads:
  for v in variants:
   for pad in pads:
    h,n=one(progs/f'speed-{v}-{pad}',case,keep=out/f'{case}-{v}-{pad}.txt');assert eq.setdefault(case,(h,n))==(h,n),(case,v,pad,h,n,eq[case]);rr.append([case,workloads[case],v,pad,n,h]);table('upstream-hashes.tsv',['testset','size','compiler','layout','subtests','upstream_verification'],rr)
  print(case,eq[case],flush=True)
elif sys.argv[1]=='time':
 raw=p/'counters';raw.mkdir(exist_ok=True);ref={r['testset']:r['upstream_verification'] for r in csv.DictReader((p/'upstream-hashes.tsv').open(),delimiter='\t')};assert set(ref)==set(workloads);settings=[(case,pad) for case in workloads for pad in pads];rows=[]
 for r in range(8):
  for pos in range(len(settings)):
   case,pad=settings[(pos+7*r)%len(settings)];vs=['control','candidate'] if (pos+r)%2==0 else ['candidate','control']
   for v in vs:
    name=f'{r}-{case}-{pad}-{v}';stat=raw/(name+'.stat');saved=raw/(name+'.ok');exe=progs/f'speed-{v}-{pad}'
    if saved.exists():h=saved.read_text().strip()
    else:h,n=one(exe,case,stat);saved.write_text(h+'\n')
    assert h==ref[case];vals={z[2]:float(z[0]) for l in stat.read_text().splitlines() if len(z:=l.split(';'))>=3};rows.append([r,case,pad,v,*[vals[m] for m in metrics],h])
  print('round',r,'complete',flush=True)
 table('counters.tsv',['round','testset','layout','compiler',*metrics,'upstream_verification'],rows);summary=[]
 for case,pad in settings:
  for i,m in enumerate(metrics):
   pairs={v:[x[4+i] for x in rows if x[0]>0 and x[1:4]==[case,pad,v]] for v in ['control','candidate']};ds=[100*(b/a-1) for a,b in zip(pairs['control'],pairs['candidate'])];assert len(ds)==7;summary.append([case,pad,m,len(ds),statistics.median(pairs['control']),statistics.median(pairs['candidate']),statistics.median(ds),min(ds),max(ds)])
 table('paired-summary.tsv',['testset','layout','metric','pairs','control_median','candidate_median','paired_percent','minimum_percent','maximum_percent'],summary)
