from pathlib import Path
import csv,hashlib,itertools,statistics,subprocess
p=Path(__file__).resolve().parent;v=p.parent;w=p.parents[2];src=w/'independent-corpus/vorbis-1.3.7';cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];variants=['addend','first'];pads=[0,16,32,48]
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def save(f,head,res):
 with (p/f).open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(res)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def exe(k,pad):return p/f'{k}-{pad}'
run(cc,'-O2','-march=x86-64-v3','-ffp-contract=off','-I'+str(src/'include'),'-I'+str(src/'lib'),'-c',p/'driver.c','-o',p/'driver.o')
ledger=[];checks=[];gold={};loc={}
for k in variants:
 lib=v/'out'/k;orig=lib/'floor1.c.o';copy=p/(k+'.o');run('objcopy','--globalize-symbol=accumulate_fit',orig,copy)
 assert run('objcopy','-O','binary','--only-section=.text',orig,'/dev/stdout',capture_output=True).stdout==run('objcopy','-O','binary','--only-section=.text',copy,'/dev/stdout',capture_output=True).stdout
 for pad in pads:
  f=exe(k,pad);run(cc,'-no-pie',p/'driver.o',lib/f'pad{pad}.o',copy,lib/'libvorbis.a','-logg','-lm','-o',f)
  line=next(l.split() for l in run('nm','-S',f,capture_output=True,text=True).stdout.splitlines() if l.endswith(' accumulate_fit'));addr=int(line[0],16);assert addr==loc.setdefault(pad,addr),(k,pad,addr)
  ledger.append([k,pad,sha(orig),sha(copy),sha(f),hex(addr),int(line[1],16)])
  for g in range(4):
   result=run(f,g,0,capture_output=True,text=True).stdout.strip();assert result==gold.setdefault((g,0),result);checks.append([k,pad,g,result]);result=run(f,g,1,capture_output=True,text=True).stdout.strip();assert result==gold.setdefault((g,1),result)
save('programs.tsv',['build','padding','library_object_sha256','promoted_symbol_object_sha256','exe_sha256','function_address','function_bytes'],ledger);save('checks.tsv',['build','padding','distribution','checked_rows_and_digest'],checks)
obs=[];vals={};cells=list(itertools.product(range(4),pads));stat=p/'last.stat'
for r in range(9):
 for j in range(len(cells)):
  g,pad=cells[(j+3*r)%len(cells)]
  for k in (variants if (r+j)%2 else variants[::-1]):
   h=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',stat,'--',exe(k,pad),g,1,capture_output=True,text=True).stdout.strip();assert h==gold[g,1]
   z={t[2]:float(t[0]) for l in stat.read_text().splitlines() if len(t:=l.split(';'))>2 and t[2] in metrics};vals[r,g,pad,k]=z;obs.append([r,g,pad,k,h,*[z[m] for m in metrics]])
 print('round',r,flush=True)
save('observations.tsv',['round','distribution','padding','build','oracle',*metrics],obs);scores=[]
for g,pad in cells:
 for m in metrics:
  a=[vals[r,g,pad,'addend'][m] for r in range(1,9)];b=[vals[r,g,pad,'first'][m] for r in range(1,9)];z=[100*(y/x-1) for x,y in zip(a,b) if x]
  if z:scores.append([g,pad,m,len(z),statistics.median(a),statistics.median(b),statistics.median(z),min(z),max(z)])
save('paired.tsv',['distribution','padding','metric','pairs','base','head','paired_percent','min_percent','max_percent'],scores);(p/'complete').touch()
