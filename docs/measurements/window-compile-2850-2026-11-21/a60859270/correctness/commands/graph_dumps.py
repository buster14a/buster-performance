"""Verify each row printed by the released --dump-typed driver after dense graph shortening."""
from pathlib import Path
import itertools,shlex,csv,sys,hashlib,subprocess,re,tempfile,json
d=Path(__file__).resolve().parent;w=d.parent;r=d/sys.argv[1];cc=r/'compiler';src=w/'switch-inputs';bs=w/'pregraph-warning-study/compiler-source';res=r/'typed-stream';res.mkdir(exist_ok=True)
typed=re.compile(rb'^(\d+) token=(\d+) op=(\d+) (.*)\n$')
def read(proc,acc):
 for line in proc.stdout:
  m=typed.fullmatch(line);assert m,line[:120];acc.update(line);yield(int(m[1]),int(m[2]),int(m[3]),m[4])
with tempfile.TemporaryDirectory(dir=res) as tmp,(res/'units.tsv').open('w') as f:
 wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(['corpus','source','ordinary','retained','removed','replaced','ordinary_dump','option_dump','object','errors','same'])
 for corpus in ['sqlite','self','lua','musl']:
  if corpus=='self': args=['-march=native','-I'+str(bs/'src'),'-fwrapv','-funsigned-char','--predefines',str(w/'proof-predefines.h'),str(bs/'src/buster/compiler/main.c')]
  else:args=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$'+corpus+'_arguments"'],text=True,cwd=src))
  flags=[a for a in args if not a.endswith('.c')]
  for source in (x for x in args if x.endswith('.c')):
   procs=[];hashes=[hashlib.sha256(),hashlib.sha256()];n=0;k=0;replaced=0
   for mode in [0,1]:
    o=Path(tmp)/(str(mode)+'.o');e=Path(tmp)/(str(mode)+'.err');o.unlink(missing_ok=True)
    with e.open('wb') as err:proc=subprocess.Popen([cc,'--lanes','1','-g','-c','--dump-typed',*(['--node-window-constants'] if mode else []),*flags,source,'-o',o],cwd=src,stdout=subprocess.PIPE,stderr=err)
    procs.append((proc,o,e))
   old=read(procs[0][0],hashes[0]);new=read(procs[1][0],hashes[1]);matched=True
   for ix,token,op,value in new:
    assert ix==k;k+=1;done=False
    for j,tok,ref,val in old:
     assert j==n;n+=1
     if tok==token and value==val and (op==ref or op==0 and 1<=ref<=20):
      done=True;replaced+=int(op!=ref);break
    if not done:
     matched=False;break
   for _ in old:n+=1
   if not matched:
    for _ in new:k+=1
   for proc,_,_ in procs:assert proc.wait()==0,source
   h=lambda f:hashlib.sha256(f.read_bytes()).hexdigest();elf=[h(z[1]) for z in procs];er=[h(z[2]) for z in procs]
   wr.writerow([corpus,source,n,k,n-k,replaced,*[a.hexdigest() for a in hashes],elf[0],er[0],matched and elf[0]==elf[1] and er[0]==er[1]]);f.flush()
