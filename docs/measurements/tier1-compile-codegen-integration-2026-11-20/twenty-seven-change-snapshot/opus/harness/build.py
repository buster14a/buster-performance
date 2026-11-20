from pathlib import Path
import csv,hashlib,json,os,re,shlex,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];src=w/'independent-corpus/opus-1.5.2';cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';os.environ.update(SOURCE_DATE_EPOCH='1792454400',LC_ALL='C');exe={'clang':cc,'control':w/'tip-control/build/compiler','candidate':w/'tip-candidate/build/compiler'}
def run(*a,**kw):return subprocess.run(list(map(str,a)),**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def text_size(f):
 a=run('size','-A',f,capture_output=True,text=True,check=True);return sum(int(t[1]) for l in a.stdout.splitlines() if len(t:=l.split())>2 and t[0].startswith('.text'))
mode,v=sys.argv[1:3];arch=sys.argv[3] if len(sys.argv)>3 else 'znver5';cfg=p/mode;d=p/'compiled'/(mode if arch=='znver5' else mode+'-'+arch)/v;d.mkdir(parents=True,exist_ok=True);cmds=[r for r in json.loads((cfg/'compile_commands.json').read_text()) if 'CMakeFiles/opus.dir/' in r['command']];rows=[];files=[]
for k,r in enumerate(cmds):
 name=Path(r['file']).relative_to(src);f=d/('unit-%03d.o'%k);log=f.with_suffix('.log');args=shlex.split(r['command'])[1:];obj=args.index('-o');args[obj+1]=str(f);args=['-march='+arch,*args]
 if v!='clang':args=['--tier1','--lanes','1','-w',*args]
 with log.open('wb') as out: process=run(exe[v],*args,cwd=r['directory'],stdout=out,stderr=out)
 msg=' | '.join(l for l in log.read_text(errors='replace').splitlines() if 'error:' in l)[:580]
 rows.append([k,str(name),process.returncode,text_size(f) if process.returncode==0 else 0,sha(f) if process.returncode==0 else '-',msg])
 if process.returncode==0:files.append(f)
with (d/'units.tsv').open('w') as out:
 t=csv.writer(out,delimiter='\t',lineterminator='\n');t.writerow(['index','source','exit','text_bytes','sha256','diagnostic']);t.writerows(rows)
print(mode,v,len(files),'of',len(rows),'compiled')
if len(files)==len(rows):
 run('ar','rcsD',d/'libopus.a',*files,check=True)
