from pathlib import Path
import csv,hashlib,itertools,os,shutil,statistics,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];up=w/'independent-corpus/musl-1.2.5';vend=Path('/home/david/dev/buster-corpus/libc/musl');d=p/'parsers';d.mkdir(exist_ok=True)
cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
vs={'parent':w/'x87-double/build/compiler','candidate':w/'x87-rom/build/compiler','clang':cc}
sysroot=p/'sysroot/usr';lib=sysroot/'lib'
casefiles=['src/stdlib/strtod.c','src/internal/floatscan.c','src/internal/shgetc.c','src/math/fmodl.c','src/math/scalbn.c','src/math/scalbnl.c']
metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];variants=['parent','candidate'];pads=[0,16,32,48];groups=['short','decimal','hex','special'];fmts=['float','double','long-double'];os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def write(name,columns,rows):
 with (d/name).open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(columns);t.writerows(rows)
def exe(v,pad):return d/(v+'-'+str(pad))
if sys.argv[1]=='build':
 main=d/'driver.o';run(cc,'--target=x86_64-linux-musl','-O2','-fno-builtin','-ffp-model=strict','-nostdinc','-I'+str(sysroot/'include'),'-c',p/'parser.c','-o',main);rows=[];units=[]
 flags=['-O2','-march=znver5','-w','-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700']
 for v,c in vs.items():
  objects=[];dr=d/v;dr.mkdir(exist_ok=True)
  for path in casefiles:
   f=up/path;out=dr/(f.stem+'.o');inc=[up/'arch/x86_64',up/'arch/generic',p/'build/obj/src/internal',up/'src/include',up/'src/internal',p/'build/obj/include',up/'include']
   run(c,*(['--tier1','--lanes','1'] if v!='clang' else []),*flags,*['-I'+str(t) for t in inc],'-c',f,'-o',out,capture_output=True)
   units.append([v,path,sha(f),f.read_bytes()==(vend/path).read_bytes(),sha(out)]);objects.append(out)
  ar=dr/'libscan.a';run('ar','rcsD',ar,*objects)
  for pad in pads:
   which=d/f'pad-{pad}.o';run(cc,'-c','-x','assembler','-','-o',which,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode())
   out=exe(v,pad);mp=d/(out.name+'.map')
   runtime=subprocess.check_output(['gcc','-print-libgcc-file-name'],text=True).strip()
   run(cc,'-nostdlib','-static','-fuse-ld=lld','-Wl,-Map,'+str(mp),lib/'crt1.o',lib/'crti.o',main,which,'-Wl,--start-group',ar,lib/'libc.a',runtime,'-Wl,--end-group',lib/'crtn.o','-o',out)
   m=mp.read_text(); assert all('libscan.a('+n+'.o)' in m for n in ['floatscan','strtod','shgetc','fmodl','scalbn','scalbnl']),(v,[n for n in casefiles if Path(n).stem+'.o' not in m]);info=run('readelf','-l',out,capture_output=True,text=True).stdout;assert 'INTERP' not in info
   nm={x[-1]:x[:2] for l in run('nm','-S',out,capture_output=True,text=True).stdout.splitlines() if len(x:=l.split())==4}
   rows.append([v,pad,sha(ar),sha(out),*[','.join(nm[s]) for s in ['__floatscan','strtold','strtod','strtof']]])
 write('units.tsv',['compiler','source','sha256','matches_frozen_source','object_sha256'],units)
 write('programs.tsv',['variant','pad','archive_sha256','executable_sha256','floatscan_addr_size','strtold_addr_size','strtod_addr_size','strtof_addr_size'],rows)
elif sys.argv[1]=='check':
 rows=[];cases=[]
 for g,fmt in itertools.product(groups,fmts):
  obs={}
  for v in vs:
   f=d/f'{g}-{fmt}-{v}.bin'
   with f.open('wb') as out:run(exe(v,0),g,fmt,4,'check',stdout=out)
   data=f.read_bytes();assert len(data)==4*768*24;obs[v]=data;rows.append([g,fmt,v,sha(f),len(data)//24])
  for a,b in [('parent','candidate'),('clang','parent'),('clang','candidate')]:
   attrs=[(0,12),(12,16),(16,20),(20,22),(22,24),(0,24)]
   nums=[sum(obs[a][i+lo:i+hi]!=obs[b][i+lo:i+hi] for i in range(0,len(obs[a]),24)) for lo,hi in attrs]
   cases.append([g,fmt,a,b,3072,*nums])
   assert nums==[0]*6,(g,fmt,a,b,nums)
 write('checks.tsv',['input','result','compiler','sha256','observations'],rows)
 write('comparison.tsv',['input','result','base','head','observations','result_bits','endptr','errno','x87_flags_top','mxcsr','any'],cases)
else:
 cases=list(itertools.product(groups,fmts,pads));orders=list(itertools.permutations(variants));rows=[];vals={};oracles={}
 for r in range(8):
  for j in range(len(cases)):
   g,fmt,pad=cases[(17*r+j)%len(cases)]
   for v in orders[(r+j)%2]:
    out=d/'last.stat';h=run('perf','stat','-e',','.join(metrics),'-x',';','--no-big-num','-o',out,'--',exe(v,pad),g,fmt,20,'time',capture_output=True,text=True).stdout.strip()
    assert h==oracles.setdefault((g,fmt),h)
    stat={t[2]:float(t[0]) for l in out.read_text().splitlines() if len(t:=l.split(';'))>2 and t[2] in metrics};vals[r,g,fmt,pad,v]=stat;rows.append([r,g,fmt,pad,v,h,*[stat[m] for m in metrics]])
  print('round',r,flush=True)
 write('counters.tsv',['round','input','format','pad','variant','hash',*metrics],rows);summary=[]
 for g,fmt,pad in cases:
  for a,b in [('parent','candidate')]:
   for m in metrics:
    x=[vals[r,g,fmt,pad,a][m] for r in range(1,8)];y=[vals[r,g,fmt,pad,b][m] for r in range(1,8)];z=[100*(j/i-1) for i,j in zip(x,y)]
    summary.append([g,fmt,pad,a,b,m,len(z),statistics.median(x),statistics.median(y),statistics.median(z),min(z),max(z)])
 write('paired.tsv',['input','format','pad','base','head','metric','pairs','base_median','head_median','paired_percent','min_percent','max_percent'],summary)
