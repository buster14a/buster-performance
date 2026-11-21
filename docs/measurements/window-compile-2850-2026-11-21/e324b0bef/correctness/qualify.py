from pathlib import Path
import csv,subprocess,shlex,sys,hashlib,tempfile,os
d=Path(__file__).resolve().parent;old=Path(sys.argv[1]).resolve();new=Path(sys.argv[2]).resolve();mode=sys.argv[3]
inp=Path(os.environ["BUSTER_CORPUS_ROOT"]).resolve()
def argv(c):
 if c=='fixture':return [str(d/'lifetime-reference-roots.c')]
 if c=='main':
  base=Path(os.environ["BUSTER_COMPILER_SOURCE"]).resolve()
  return ['-march=native','-I'+str(base/'src'),'-fwrapv','-funsigned-char','--predefines',str(d/'proof-predefines.h'),str(base/'src/buster/compiler/main.c')]
 return shlex.split(subprocess.check_output(['bash','-c','source '+shlex.quote(str(d/'corpora.sh'))+'; printf %s "$'+c+'_arguments"'],cwd=inp,text=True))
def sym(p):
 lines=subprocess.check_output(['nm','-a','--format=posix','--defined-only',p],text=True,stderr=subprocess.DEVNULL).splitlines()
 return {s.split()[0]+':'+s.split()[1] for s in lines if len(s.split())>1}
def digest(x):return hashlib.sha256(x).hexdigest()
with tempfile.TemporaryDirectory() as tmp,(d/(mode+'.tsv')).open('w',buffering=1) as f:
 t=Path(tmp);w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('corpus unit old_status new_status diag same_object old_sha new_sha earlier_only newer_only'.split())
 flags={'tier1':['--tier1'],'no-lifetimes':['--tier1','--tier1-no-lifetimes'],'default':[]}[mode]
 for c in ('fixture','sqlite','lua','musl','main'):
  a=argv(c);opt=[x for x in a if not x.endswith('.c')]
  for unit in [x for x in a if x.endswith('.c')]:
   s=[]
   for i,cc in enumerate((old,new)):
    obj=t/f'{i}.o';obj.unlink(missing_ok=True);p=subprocess.run([cc,'--lanes','1',*flags,'-c',*opt,unit,'-o',obj],capture_output=True)
    s.append((p.returncode,digest(p.stdout+p.stderr),digest(obj.read_bytes()) if obj.exists() else '-'))
   oo=t/'0.o';no=t/'1.o';dropped=set();added=set()
   if s[0][2]!=s[1][2] and oo.exists() and no.exists():
    prev=sym(oo);later=sym(no);dropped=prev-later;added=later-prev
   w.writerow([c,Path(unit).name,s[0][0],s[1][0],int(s[0][1]==s[1][1]),int(s[0][2]==s[1][2]),s[0][2],s[1][2],','.join(sorted(dropped)),','.join(sorted(added))])
