from pathlib import Path
from statistics import median
import csv,hashlib,itertools,os,subprocess,tempfile
p=Path(__file__).resolve().parent;w=p.parents[1];z=w/'independent-corpus/zstd';cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';arc=w/'integration-evidence/zstd/clang-static/lib/libzstd.a';helpers=[w/'unsigned64-evidence/real/util.o',w/'unsigned64-evidence/real/time.o'];f=z/'tests/decodecorpus.c';metrics=['instructions:u','cycles:u','branches:u','branch-misses:u','task-clock']
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def table(n,cols,rows):
 with (p/n).open('w') as h:q=csv.writer(h,delimiter='\t',lineterminator='\n');q.writerow(cols);q.writerows(rows)
flags=['-O2','-std=gnu11','-march=znver5','-DXXH_NAMESPACE=ZSTD_','-DZSTD_LEGACY_SUPPORT=5','-DNDEBUG','-w']+sum((['-I',z/d] for d in ['programs','lib','lib/common','lib/compress','lib/decompress','lib/dictBuilder']),[]);variants=['clang','parent','head'];pads=[0,16,32,48];seeds=[731,1709];programs=[];objects={};nmsets={};data=[];gold={}
for v in variants:
 c=cc if v=='clang' else w/('late-control' if v=='parent' else 'unsigned32')/'build/compiler';o=p/(v+'.o');extra=['--tier1','--lanes','1'] if v!='clang' else [];run(c,*extra,*flags,'-c',f,'-o',o);objects[v]=o
 nmsets[v]={a[-1]:int(a[1],16) for l in run('nm','-S','--defined-only',o,capture_output=True,text=True).stdout.splitlines() if len(a:=l.split())==4 and a[2] in ['t','T']}
 for pad in pads:
  po=p/f'pad{pad}.o';run(cc,'-x','assembler','-c','-','-o',po,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode());e=p/f'{v}-{pad}'
  run(cc,'-no-pie',po,o,*helpers,arc,'-lm','-pthread','-o',e);programs.append([v,pad,sha(o),sha(e),sha(f),sha(arc)])
  for seed in seeds:
   with tempfile.TemporaryDirectory(dir='/dev/shm') as td:
    t=Path(td);arguments=[f'-s{seed}','-n12','-o'+str(t),'-p'+str(t),'--block-type=2','--max-content-size-log=15'];run(e,*arguments,capture_output=True)
    frames=sorted(t.glob('*.zst'));assert len(frames)==12
    for frame in frames:
     raw=frame.with_suffix('');decoded=run('zstd','-dcq',frame,capture_output=True).stdout;assert decoded==raw.read_bytes();pair=(sha(frame),sha(raw))
     assert pair==gold.setdefault((seed,frame.name),pair);data.append([v,pad,seed,frame.name,frame.stat().st_size,raw.stat().st_size,*pair])
table('programs.tsv',['compiler','padding','object','executable','source','common_zstd_library'],programs)
table('frames.tsv',['compiler','padding','seed','frame','compressed_bytes','plain_bytes','compressed_sha256','plain_sha256'],data)
diffs=[[n,nmsets['parent'][n],nmsets['head'][n],nmsets['head'][n]-nmsets['parent'][n]] for n in sorted(set(nmsets['parent']) & set(nmsets['head'])) if nmsets['parent'][n]!=nmsets['head'][n]]
table('functions.tsv',['function','parent_bytes','head_bytes','delta'],diffs)
raw=[];vals={};cases=list(itertools.product(pads,seeds))
for r in range(8):
 for n in range(len(cases)):
  pad,seed=cases[(n+3*r)%len(cases)]
  for v in (['head','parent'] if (n+r)%2 else ['parent','head']):
   stat=p/'last.stat';e=p/f'{v}-{pad}';res=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',stat,'--',e,f'-s{seed}','-n128','-t','--block-type=2','--max-content-size-log=15',capture_output=True)
   m={a[2]:float(a[0]) for l in stat.read_text().splitlines() if len(a:=l.split(';'))>2 and a[2] in metrics};assert len(m)==len(metrics)
   raw.append([r,pad,seed,v,*[m[k] for k in metrics]]);vals[r,pad,seed,v]=m
 print('round',r,flush=True)
table('processes.tsv',['round','padding','seed','compiler',*metrics],raw);prs=[]
for pad,seed in cases:
 for m in metrics:
  a=[vals[r,pad,seed,'parent'][m] for r in range(1,8)];b=[vals[r,pad,seed,'head'][m] for r in range(1,8)];zv=[100*(y/x-1) for x,y in zip(a,b) if x];prs.append([pad,seed,m,len(zv),median(a),median(b),median(zv),min(zv),max(zv)])
table('paired.tsv',['padding','seed','metric','pairs','parent','head','paired_percent','minimum_percent','maximum_percent'],prs)
