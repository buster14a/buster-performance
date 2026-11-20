from pathlib import Path
import csv,hashlib,itertools,os,statistics,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];d=p/'printing';d.mkdir(exist_ok=True)
up=w/'independent-corpus/musl-1.2.5';vend=Path('/home/david/dev/buster-corpus/libc/musl');root=p/'sysroot/usr';lib=root/'lib';cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
vs={'parent':w/'x87-double/build/compiler','candidate':w/'x87-rom/build/compiler','clang':cc};pads=(0,16,32,48);groups=['hex','fixed','scientific','general','mixed-double','positional'];metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock']
casefiles=['src/stdio/snprintf.c','src/stdio/vsnprintf.c','src/stdio/vfprintf.c','src/math/frexpl.c'];os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def save(name,head,rows):
 with (d/name).open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(rows)
def exe(v,pad):return d/f'{v}-{pad}'
if sys.argv[1]=='build':
 m=d/'driver.o';run(cc,'--target=x86_64-linux-musl','-O2','-fno-builtin','-ffp-model=strict','-nostdinc','-I'+str(root/'include'),'-c',p/'printing.c','-o',m);res=[];obj=[]
 flags=['-O2','-march=znver5','-w','-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700'];inc=[up/'arch/x86_64',up/'arch/generic',p/'build/obj/src/internal',up/'src/include',up/'src/internal',p/'build/obj/include',up/'include']
 for v,c in vs.items():
  dr=d/v;dr.mkdir(exist_ok=True);objects=[]
  for name in casefiles:
   src=up/name;o=dr/(src.stem+'.o');run(c,*([] if v=='clang' else ['--tier1','--lanes','1']),*flags,*['-I'+str(x) for x in inc],'-c',src,'-o',o,capture_output=True)
   objects.append(o);obj.append([v,name,sha(src),sha(o),src.read_bytes()==(vend/name).read_bytes()])
  ar=dr/'libprinting.a';run('ar','rcsD',ar,*objects)
  for pad in pads:
   out=exe(v,pad);mp=d/(out.name+'.map');runtime=subprocess.check_output(['gcc','-print-libgcc-file-name'],text=True).strip()
   run(cc,'-nostdlib','-static','-fuse-ld=lld','-Wl,-Map,'+str(mp),lib/'crt1.o',lib/'crti.o',m,p/'parsers'/f'pad-{pad}.o','-Wl,--start-group',ar,lib/'libc.a',runtime,'-Wl,--end-group',lib/'crtn.o','-o',out)
   assert all('libprinting.a('+o.name+')' in mp.read_text() for o in objects) and 'INTERP' not in run('readelf','-l',out,capture_output=True,text=True).stdout
   syms={z[-1]:z[:2] for l in run('nm','-S',out,capture_output=True,text=True).stdout.splitlines() if len(z:=l.split())==4}
   res.append([v,pad,sha(out),sha(ar),*[','.join(syms[s]) for s in ('snprintf','vfprintf','frexpl')]])
 save('programs.tsv',['variant','pad','exe_sha256','archive_sha256','snprintf_address_size','vfprintf_address_size','frexpl_address_size'],res);save('units.tsv',['variant','source','source_sha256','object_sha256','matches_frozen_musl'],obj)
elif sys.argv[1]=='check':
 rows=[];pairs=[]
 for g,name in enumerate(groups):
  obs={}
  for v in vs:
   f=d/f'{name}-{v}.bin'
   with f.open('wb') as h:run(exe(v,0),g,'check',1,stdout=h)
   data=f.read_bytes();assert len(data)==180*256*4*5;rows.append([name,v,sha(f),len(data)//180]);obs[v]=data
  for a,b in [('parent','candidate'),('clang','parent'),('clang','candidate')]:
   cols=[(0,4),(4,8),(8,12),(12,180),(0,180)];n=[sum(obs[a][i+s:i+e]!=obs[b][i+s:i+e] for i in range(0,len(obs[a]),180)) for s,e in cols]
   pairs.append([name,a,b,5120,*n]);assert n==[0]*5,(name,a,b,n)
 save('checks.tsv',['format','variant','output_sha256','records'],rows);save('comparisons.tsv',['format','control','candidate','observations','return','errno','fp_state','formatted_bytes','any'],pairs)
else:
 cells=list(itertools.product(range(6),pads));variants=['parent','candidate'];perms=list(itertools.permutations(variants));values={};rows=[];gold={};stat=d/'last.stat'
 for r in range(9):
  for j in range(len(cells)):
   g,pad=cells[(j+7*r)%len(cells)]
   for v in perms[(r+j)%2]:
    h=run('perf','stat','-e',','.join(metrics),'-x',';','--no-big-num','-o',stat,'--',exe(v,pad),g,'time',32,capture_output=True,text=True).stdout.strip();assert h==gold.setdefault(g,h),(g,v,h)
    c={t[2]:float(t[0]) for l in stat.read_text().splitlines() if len(t:=l.split(';'))>2 and t[2] in metrics};values[r,g,pad,v]=c;rows.append([r,groups[g],pad,v,h,*[c[m] for m in metrics]])
  print(r,flush=True)
 save('counters.tsv',['round','format','pad','variant','oracle',*metrics],rows);summ=[]
 for g,pad in cells:
  for a,b in [('parent','candidate')]:
   for m in metrics:
    x=[values[r,g,pad,a][m] for r in range(1,9)];y=[values[r,g,pad,b][m] for r in range(1,9)];z=[100*(v/u-1) for u,v in zip(x,y) if u]
    if z:summ.append([groups[g],pad,a,b,m,len(z),statistics.median(x),statistics.median(y),statistics.median(z),min(z),max(z)])
 save('paired.tsv',['format','pad','base','head','metric','pairs','base_median','head_median','paired_percent','min_percent','max_percent'],summ)
