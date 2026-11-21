from pathlib import Path
import subprocess,sys,os,csv,shlex,tempfile,hashlib
d=Path(__file__).resolve().parent;cc=Path(sys.argv[1]).resolve();prefix=sys.argv[2];inp=Path(os.environ["BUSTER_CORPUS_ROOT"]).resolve()
def args(c):
 if c in ('sqlite','lua','musl'):
  env=subprocess.check_output(['bash','-c','source '+shlex.quote(str(d/'corpora.sh'))+'; printf %s "$'+c+'_arguments"'],cwd=inp,text=True);return shlex.split(env)
 if c=='main':
  t=Path(os.environ["BUSTER_COMPILER_SOURCE"]).resolve();return ['-march=native','-I'+str(t/'src'),'-fwrapv','-funsigned-char','--predefines',str(d/'proof-predefines.h'),str(t/'src/buster/compiler/main.c')]
 return [str(d/(c+'.c'))]
def digest(x):return hashlib.sha256(x).hexdigest()
for p,flags in [('default',[]),('debug',['-g']),('wall',['-Wall','-Wextra']),('all',['-Weverything'])]:
 with (d/(prefix+'-'+p+'.tsv')).open('w',buffering=1) as f,tempfile.TemporaryDirectory() as t:
  w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['corpus','unit','status','diagnostic_sha256','object_sha256']);o=Path(t)/'unit.o'
  for corpus in ('focused','bound','generated','static','diagnostics','physical-runtime','sqlite','lua','musl','main'):
   a=args(corpus);opts=[x for x in a if not x.endswith('.c')]
   for s in [x for x in a if x.endswith('.c')]:
    o.unlink(missing_ok=True);r=subprocess.run([cc,'--lanes','1',*flags,'-c',*opts,s,'-o',o],capture_output=True)
    w.writerow([corpus,Path(s).name,r.returncode,digest(r.stdout+r.stderr),digest(o.read_bytes()) if o.exists() else '-'])
