from pathlib import Path
import csv,hashlib,itertools,os,statistics,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];d=p/'timed';d.mkdir(exist_ok=True)
cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
names=['exp2l','expm1l','log10l','acosl','atan2l','powl','coshl','frexpl','exp10l','tgammal','erfl','sinl'];pads=[0,16,32,48]
libs={'before':w/'x87-pool-evidence/libm/out/candidate/libmath.a','narrow':p/'out/parent/libmath.a','pool':p/'out/candidate/libmath.a','clang':p/'out/clang/libmath.a'}
metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];variants=['before','narrow','pool'];rows=[];os.environ['LC_ALL']='C'
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def tab(f,head,rr):
 with (d/f).open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(rr)
def exe(name,v,pad):return d/f'{name}-{v}-{pad}'
if sys.argv[1]=='build':
 for k,name in enumerate(names):
  obj=d/(name+'.o');run(cc,'-O2','-fno-builtin','-ffp-model=strict','-D_GNU_SOURCE','-DCASE='+str(k),'-c',p/'timed.c','-o',obj)
  for v,pad in itertools.product(libs,pads):
   out=exe(name,v,pad);mp=d/(out.name+'.map');padding=w/'x87-pool-evidence/loops/programs'/f'pad{pad}.o'
   run(cc,'-no-pie',obj,padding,libs[v],'-Wl,-Map,'+str(mp),'-lm','-o',out)
   assert 'libmath.a('+name+'.o)' in mp.read_text();syms=run('nm','-S',out,capture_output=True,text=True).stdout
   a,size=next(t[:2] for l in syms.splitlines() if len(t:=l.split())==4 and t[-1]==name)
   oracle=run(out,1,capture_output=True,text=True).stdout.strip();rows.append([name,v,pad,h:=sha(out),a,int(size,16),sha(libs[v]),oracle])
  assert len({row[-1] for row in rows if row[0]==name and row[1]!='clang'})==1
 tab('programs.tsv',['function','variant','pad','sha256','symbol_address_hex','symbol_bytes','archive_sha256','oracle'],rows)
else:
 expected={(i['function'],i['variant'],int(i['pad'])):i['oracle'] for i in csv.DictReader((d/'programs.tsv').open(),delimiter='\t')};values={}
 cases=list(itertools.product(names,pads));orders=list(itertools.permutations(variants))
 for r in range(8):
  for j in range(len(cases)):
   name,pad=cases[(r*7+j)%len(cases)]
   for v in orders[(r+j)%6]:
    temp=d/'last.stat'
    oracle=run('perf','stat','-x',';','--no-big-num','-e',','.join(metrics),'-o',temp,'--',exe(name,v,pad),16,capture_output=True,text=True).stdout.strip()
    assert oracle==expected[name,v,pad]
    stat={t[2]:float(t[0]) for l in temp.read_text().splitlines() if len(t:=l.split(';'))>2 and t[2] in metrics};values[r,name,pad,v]=stat;rows.append([r,name,pad,v,*[stat[x] for x in metrics],oracle])
  print('round',r,flush=True)
 tab('counters.tsv',['round','function','pad','variant',*metrics,'oracle'],rows);groups=[]
 for name,pad in cases:
  for a,b in [('before','narrow'),('narrow','pool'),('before','pool')]:
   for metric in metrics:
    old=[values[r,name,pad,a][metric] for r in range(1,8)];new=[values[r,name,pad,b][metric] for r in range(1,8)];diff=[100*(y/x-1) for x,y in zip(old,new)]
    groups.append([name,pad,a,b,metric,len(diff),statistics.median(old),statistics.median(new),statistics.median(diff),min(diff),max(diff)])
 tab('paired.tsv',['function','pad','base','candidate','metric','pairs','base_median','candidate_median','paired_pct','min_pct','max_pct'],groups)
