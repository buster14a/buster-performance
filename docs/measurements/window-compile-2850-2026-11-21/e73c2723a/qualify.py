from common import *
from probes import probes
import csv,gzip,hashlib,json,re,subprocess
folder=D/'oracle';folder.mkdir(exist_ok=True);streams=folder/'streams';streams.mkdir(exist_ok=True)
clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
def store(b):
 h=hashlib.sha256(b).hexdigest();f=streams/(h+'.gz')
 if not f.exists():f.write_bytes(gzip.compress(b,mtime=0))
 return h
def events(b):
 return [tuple(x) for x in re.findall(rb'^.*?:(\d+):(\d+): (fatal error|error|warning|note): (.*)$',b,re.M)]
def run(cmd,e):
 p=subprocess.run(cmd,cwd=ROOT,env=env|e,capture_output=True,timeout=200);return p.returncode,p.stdout,p.stderr
bad=[];obj=folder/'unit.o'
with (folder/'outcomes.tsv').open('w',buffering=1) as fp,(folder/'clang.tsv').open('w',buffering=1) as fc,(folder/'executions.tsv').open('w',buffering=1) as fe:
 t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['input','policy','mode','status','stdout','stderr','ELF','same-prior'])
 c=csv.writer(fc,delimiter='\t',lineterminator='\n');c.writerow(['input','mode','status','clang-status','events','clang-events','same-locations','same-messages','clang-stderr','compiler-stderr'])
 x=csv.writer(fe,delimiter='\t',lineterminator='\n');x.writerow(['input','mode','compile-status','link-status','return-value','stdout','stderr','link-stderr','compile-stderr'])
 for name,flags in [*probes.items(),*args.items()]:
  cret,_,cerr=run([clang,*flags,'-fsyntax-only'],{}) if name in probes else (0,b'',b'')
  if name.startswith('runtime'):
   for mode,b,e in [('clang',clang,{}),('prior',PRIOR,{}),('candidate',CC,{})]:
    obj.unlink(missing_ok=True);bopt=[] if mode=='clang' else ['--lanes','1'];ret,_,er=run([b,*bopt,'-c',*flags,'-o',obj],e)
    exe=folder/'app';exe.unlink(missing_ok=True);lr,_,le=run([clang,'-no-pie',obj,'-o',exe],{}) if ret==0 else (-99,b'',b'')
    rr,ro,runerr=run([exe],{}) if lr==0 else (-99,b'',b'')
    x.writerow([name,mode,ret,lr,rr,store(ro),store(runerr),store(le),store(er)])
  for policy,options in [('default',[]),('strict',['-Wall','-Wextra','-Werror']),('dumps',['--dump-typed','--dump-static'])]+([('scalar',['--scalar'])] if name in probes else []):
   seen={}
   for mode,b,e in [('prior',PRIOR,{}),('candidate',CC,{})]:
    obj.unlink(missing_ok=True);ret,so,se=run([b,'--lanes','1','-c',*options,*flags,'-o',obj],e);h=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '-';val=ret,store(so),store(se),h;seen[mode]=val
    same=val==seen[mode.replace('candidate','prior')];t.writerow([name,policy,mode,*val,int(same)])
    if not same:bad.append([name,policy,mode])
    if policy=='default' and name in probes and mode.startswith('candidate'):
     a,bb=events(se),events(cerr);c.writerow([name,mode,ret,cret,len(a),len(bb),int([v[:3] for v in a]==[v[:3] for v in bb]),int(a==bb),store(cerr),val[2]])
   if name in args and policy=='default':
    for mode,f in [('candidate',W/'source-typed-study'/(name+'.o'))]:
     if seen[mode][3]!=hashlib.sha256(f.read_bytes()).hexdigest():bad.append([name,policy,mode,'historical ELF'])
  print(name,len(bad),flush=True)
(folder/'differences.json').write_text(json.dumps(bad,indent=2))
