"""Attribute generated object and checked audio changes to five independent PR steps."""
from pathlib import Path
from statistics import median
import csv, hashlib, itertools, json, os, shlex, subprocess, sys, tempfile
p=Path(__file__).resolve().parent
w=p.parents[1]; src=w/'independent-corpus/opus-1.5.2'; out=p/'attribution'; old=p/'audio-x86-64-v3'
cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
modes=['portable-nosp','dispatch-nosp']; pads=[0,16,32,48]; v3='-x86-64-v3'
metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock']
os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def read(f):return list(csv.DictReader(f.open(),delimiter='\t'))
def save(f,head,rows):
 with f.open('w') as h:
  t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(rows)
def size(f):
 s=run('size','-A',f,capture_output=True,text=True).stdout
 return sum(int(t[1]) for l in s.splitlines() if len(t:=l.split())>2 and t[0].startswith('.text'))
def program(m,k,pad):return out/m/f'step{k}'/f'audio-{pad}'
def gold(m,idx,action):
 name=m+v3+'-'+str(idx)+'-control'
 return old/(name+('.packets' if action=='encode' else '-'+action+'-control.pcm'))
def cmd(prog,m,idx,action,output):
 return [prog,action,str(idx),output,'unused'] if action=='encode' else [prog,action,str(idx),gold(m,idx,'encode'),output]
def build():
 ledger=[]; archives=[]; checks=[]
 for m in modes:
  records=[q for q in json.loads((p/m/'compile_commands.json').read_text()) if 'CMakeFiles/opus.dir/' in q['command']]
  prior=p/'compiled'/(m+v3)/'control';final=p/'compiled'/(m+v3)/'candidate'
  for k in range(6):
   dr=out/m/f'step{k}';dr.mkdir(exist_ok=True,parents=True);files=[]
   for i,q in enumerate(records):
    name=f'unit-{i:03d}.o';f=dr/name
    if k:
     args=shlex.split(q['command'])[1:];args[args.index('-o')+1]=str(f)
     if f.exists():f.unlink()
     run(out/f'step{k}','--tier1','--lanes','1','-w','-march=x86-64-v3',*args,cwd=q['directory'],capture_output=True)
    elif not f.exists():os.link(prior/name,f)
    digest=sha(f);pfile=prior/name
    if k==5:assert digest==sha(final/name),(m,k,i)
    pb=size(pfile);cb=size(f);same=digest==sha(pfile)
    if k and same:f.unlink();os.link(pfile,f)
    ledger.append([m,k,i,Path(q['file']).relative_to(src),digest,same,cb,cb-pb]);files.append(f)
   lib=dr/'libopus.a';run('ar','rcsD',lib,*files)
   for pad in pads:
    exe=program(m,k,pad);run(cc,'-no-pie',old/'main.o',old/f'pad{pad}.o',lib,'-lm','-o',exe)
    if k in (0,5):
     target='control' if k==0 else 'candidate'
     assert sha(exe)==sha(old/f'{m}{v3}-{target}-{pad}')
    archives.append([m,k,pad,sha(lib),sha(exe),size(exe)])
   with tempfile.TemporaryDirectory(dir='/dev/shm') as tmp:
    f=Path(tmp)/'audio'
    for idx,action in itertools.product(range(7),['encode','decode','loss']):
     run(*cmd(program(m,k,0),m,idx,action,f));digest=sha(f);assert digest==sha(gold(m,idx,action)),(m,k,idx,action)
     checks.append([m,k,idx,action,f.stat().st_size,digest])
   print(m,k,len(files),'objects and 21 audio checks',flush=True);prior=dr
 save(out/'units.tsv',['mode','step','index','source','sha256','identical_to_previous','text_bytes','text_delta_from_previous'],ledger)
 save(out/'programs.tsv',['mode','step','pad','archive_sha256','executable_sha256','text_bytes'],archives)
 save(out/'audio-checks.tsv',['mode','step','profile','action','bytes','sha256'],checks)
def measure():
 cases=list(itertools.product(modes,range(7),['encode','decode'],pads));variants=list(range(6))
 with tempfile.TemporaryDirectory(dir='/dev/shm') as tmp:
  tmp=Path(tmp);stat=tmp/'perf';f=tmp/'audio'
  for r in range(8):
   log=out/f'timing-{r}.tsv'
   if log.exists():continue
   rows=[]
   for j in range(len(cases)):
    m,idx,a,pad=cases[(j+17*r)%len(cases)];vs=variants[::-1] if (j+r)%2 else variants
    rot=(j+r//2)%6
    expected=sha(gold(m,idx,a))
    for k in vs[rot:]+vs[:rot]:
     run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',stat,'--',*cmd(program(m,k,pad),m,idx,a,f),capture_output=True)
     h=sha(f);assert h==expected
     obs={t[2]:float(t[0]) for l in stat.read_text().splitlines() if len(t:=l.split(';'))>2 and t[2] in metrics}
     rows.append([r,m,idx,a,pad,k,h,*[obs[z] for z in metrics]])
   save(log,['round','mode','profile','action','pad','step','verified_sha256',*metrics],rows);print('audio timing round',r,flush=True)
 allrows=[x for r in range(8) for x in read(out/f'timing-{r}.tsv')]
 idx={(int(x['round']),x['mode'],int(x['profile']),x['action'],int(x['pad']),int(x['step'])):x for x in allrows};summ=[]
 for m,i,a,pad in cases:
  for base,head in [(0,1),(1,2),(2,3),(3,4),(4,5),(0,5)]:
   for metric in metrics:
    aa=[float(idx[r,m,i,a,pad,base][metric]) for r in range(1,8)];bb=[float(idx[r,m,i,a,pad,head][metric]) for r in range(1,8)];rat=[100*(y/x-1) for x,y in zip(aa,bb)]
    summ.append([m,i,a,pad,base,head,metric,len(rat),median(aa),median(bb),median(rat),min(rat),max(rat)])
 save(out/'counters.tsv',list(allrows[0]),[list(x.values()) for x in allrows]);save(out/'paired.tsv',['mode','profile','action','pad','base_step','head_step','metric','pairs','base_median','head_median','paired_percent','min_percent','max_percent'],summ)
if sys.argv[1]=='build':build()
else:measure()
