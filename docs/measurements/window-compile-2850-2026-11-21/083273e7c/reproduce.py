from pathlib import Path
import argparse,csv,gzip,hashlib,os,subprocess,tarfile
p=argparse.ArgumentParser(description='Compare complete native outputs and full-graph checked fingerprints with the prior source compiler.')
for k in ('base','candidate','sqlite','buster-source','predefines','out'):p.add_argument('--'+k,required=True,type=Path)
p.add_argument('--switch',default='BUSTER_SOURCE_ARITHMETIC');p.add_argument('--cases',type=Path)
a=p.parse_args();dest=a.out.absolute();dest.mkdir(parents=True,exist_ok=True);raw=dest/'streams';raw.mkdir(exist_ok=True)
if a.cases is None:
 cases=dest/'cases';cases.mkdir(exist_ok=True)
 with tarfile.open(Path(__file__).resolve().parent/'oracle/raw.tar.gz') as t:
  for m in t.getmembers():
   name=Path(m.name)
   if m.isfile() and name.parent==Path('cases') and name.suffix=='.c':(cases/name.name).write_bytes(t.extractfile(m).read())
else:cases=a.cases
data={'sqlite':['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(a.sqlite.absolute().parent),a.sqlite.absolute()],
      'buster':['-march=native','-I'+str(a.buster_source.absolute()/'src'),'-fwrapv','-funsigned-char','--predefines',a.predefines.absolute(),a.buster_source.absolute()/'src/buster/compiler/main.c']}
data.update({v.stem:['-std=c23','-nostdinc',v.absolute()] for v in sorted(cases.glob('*.c'))});env={k:v for k,v in os.environ.items() if not k.startswith(('BUSTER_SOURCE_','BUSTER_CONTROL_','BUSTER_BODY_','BUSTER_CHECK_BODY_','BUSTER_CHECK_SOURCE_DECLARATIONS'))}
def digest(b):return hashlib.sha256(b).hexdigest()
def capture(cc,flags,options,e,kind):
 obj=dest/'one.o';obj.unlink(missing_ok=True);r=subprocess.run([cc.absolute(),'--lanes','1','-c',*options,*flags,'-o',obj],env=env|e,capture_output=True,timeout=360);ids=[]
 for b in [r.stdout,r.stderr]:
  h=digest(b);z=raw/(h+'.gz')
  if not z.exists():z.write_bytes(gzip.compress(b,mtime=0))
  ids.append(h)
 fp=[]
 if kind!='native':fp=[line.split(b'\t',1)[1] for line in r.stderr.splitlines() if line.startswith(b'body-'+(b'whole' if e.get('BUSTER_CHECK_BODY_WHOLE_FINGERPRINT') else b'source')+b'-row\t')]
 return [r.returncode,*ids,digest(obj.read_bytes()) if obj.exists() else '-',len(fp),digest(b'\n'.join(sorted(fp)))]
native={'BUSTER_CONTROL_SOURCE_NATIVE':'1'};previous=a.base;new=a.candidate;enabled={a.switch:'1'};fail=0
with (dest/'comparisons.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['source','test','mode','equals-source-control','exit','stdout','stderr','ELF','checked-rows','checked-sha256'])
 for n,flags in data.items():
  real=n in ('sqlite','buster')
  for label,opts in [('default',[]),('warn',['-Wall','-Wextra']),('strict',['-Wall','-Wextra','-Werror'])]+([] if real else [('dumps',['--dump-typed','--dump-static'])]):
   modes=[('prior-source',previous,native),('current-source',new,native),('producer',new,native|enabled)];answers={k:capture(cc,flags,opts,e,'native') for k,cc,e in modes}
   for k,cc,e in modes:
    equal=answers[k]==answers['current-source'];fail+=not equal;t.writerow([n,label,k,int(equal),*answers[k]])
  local={'BUSTER_CHECK_BODY_SOURCE_ONLY':'1','BUSTER_CHECK_BODY_ADMIT_ALL':'1'}
  for scope,extra in [('functions',{})]+([('declarations',{'BUSTER_CHECK_SOURCE_DECLARATIONS':'1'})] if real else []):
   modes=[('prior-source',previous,local|extra),('current-source',new,local|extra),('producer',new,local|extra|enabled),('whole',new,{'BUSTER_CHECK_BODY_WHOLE_FINGERPRINT':'1'}|extra)]
   answers={k:capture(cc,flags,[],e,scope) for k,cc,e in modes}
   for k,cc,e in modes:
    x=answers[k];y=answers['current-source'];equal=x[0]==y[0] and x[4:]==y[4:];fail+=int(not equal and k!='whole');t.writerow([n,scope,k,int(equal),*x])
print(f'{fail} differences');raise SystemExit(bool(fail))
