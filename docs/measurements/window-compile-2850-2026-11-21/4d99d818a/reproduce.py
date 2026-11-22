"""Compare ordinary native compilers on the archived source, diagnostics, dumps and complete objects."""
import argparse,csv,gzip,hashlib,subprocess,tarfile
from pathlib import Path
here=Path(__file__).resolve().parent
p=argparse.ArgumentParser(description=__doc__)
for flag in ('base','candidate','sqlite','buster-source','out'):p.add_argument('--'+flag,type=Path,required=True)
p.add_argument('--cases',type=Path,default=here/'directed-cases.tar.gz')
p.add_argument('--predefines',type=Path,default=here.parent/'4bd73ecaf/predefines.h')
a=p.parse_args();a.out.mkdir(exist_ok=True,parents=True);case_dir=a.out/'cases';case_dir.mkdir(exist_ok=True);raw=a.out/'outputs';raw.mkdir(exist_ok=True)
for name in ('base','candidate','sqlite','buster_source','predefines'):
 setattr(a,name,getattr(a,name).resolve())
def sha(data):return hashlib.sha256(data).hexdigest()
if sha(a.sqlite.read_bytes())!='0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d':
 raise SystemExit('SQLite differs from the frozen amalgamation.')
with tarfile.open(a.cases,'r:gz') as src:
 for item in src:
  filename=Path(item.name)
  if item.isfile() and filename.name==item.name and filename.suffix=='.c':
   (case_dir/filename).write_bytes(src.extractfile(item).read())
sources={'sqlite':(['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(a.sqlite.parent),a.sqlite],True),'buster':(['-march=native','-I'+str(a.buster_source/'src'),'-fwrapv','-funsigned-char','--predefines',a.predefines,a.buster_source/'src/buster/compiler/main.c'],True)}
sources.update({v.stem:(['-std=c23','-nostdinc',v.absolute()],False) for v in sorted(case_dir.glob('*.c'))})
def run(exe,flags,opts):
 obj=a.out/'out.o';obj.unlink(missing_ok=True);z=subprocess.run([exe,'--lanes','1','-c',*opts,*flags,'-o',obj],capture_output=True,timeout=300)
 dig=[]
 for data in (z.stdout,z.stderr):
  h=sha(data);out=raw/(h+'.gz')
  if not out.exists():out.write_bytes(gzip.compress(data,mtime=0))
  dig.append(h)
 return [z.returncode,*dig,sha(obj.read_bytes()) if obj.is_file() else '-']
fail=0
with (a.out/'comparisons.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['input','policy','same','mode','exit','stdout','stderr','ELF'])
 for name,(flags,whole) in sources.items():
  opts=[('default',[]),('wall',['-Wall','-Wextra']),('strict',['-Wall','-Wextra','-Werror'])]
  if not whole:opts += [('dumps',['--dump-static','--dump-typed']),('strict-dumps',['-Wall','-Wextra','-Werror','--dump-static','--dump-typed'])]
  for label,policy in opts:
   base=run(a.base,flags,policy);test=run(a.candidate,flags,policy);same=base==test;fail+=not same
   t.writerow([name,label,int(same),'base',*base]);t.writerow([name,label,int(same),'candidate',*test])
print('differences',fail);raise SystemExit(bool(fail))
