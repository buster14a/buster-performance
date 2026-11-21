from pathlib import Path
import csv,subprocess,shlex,sys,collections,re,hashlib
d=Path(__file__).resolve().parent;w=d.parent;cc=Path(sys.argv[1]).resolve();res=Path(sys.argv[2]).resolve();res.mkdir(exist_ok=True,parents=True);src=w/'switch-inputs';bs=w/'pregraph-warning-study/compiler-source';h=lambda x:hashlib.sha256(x).hexdigest()
with (res/'stage-counts.tsv').open('w') as f:
 out=csv.writer(f,delimiter='\t',lineterminator='\n');out.writerow(['corpus','unit','roots','removed','remaining_graph','elf_sha256','status'])
 for name in ['sqlite','lua','musl','self']:
  if name=='self':a=['-march=native','-I'+str(bs/'src'),'-fwrapv','-funsigned-char','--predefines',str(w/'proof-predefines.h'),str(bs/'src/buster/compiler/main.c')]
  else:a=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$'+name+'_arguments"'],text=True,cwd=src))
  flags=[w for w in a if not w.endswith('.c')]
  for file in [w for w in a if w.endswith('.c')]:
   o=res/'stage.o';o.unlink(missing_ok=True);p=subprocess.run([cc,'--lanes','1','--node-window-constants','--time-stages','-c',*flags,file,'-o',o],cwd=src,capture_output=True)
   m=re.search(rb'^constant-window: roots=(\d+) removed=(\d+) graph-nodes=(\d+)',p.stderr,re.M);n=list(map(int,m.groups())) if m else [0]*3
   assert not p.returncode and o.exists(),(name,file,p.stderr[-500:]);out.writerow([name,file,*n,h(o.read_bytes()),p.returncode])
  f.flush()
