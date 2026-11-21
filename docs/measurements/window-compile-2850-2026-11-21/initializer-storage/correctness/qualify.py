from pathlib import Path
import csv,hashlib,os,shlex,subprocess,sys,tempfile
r=Path(__file__).resolve().parent
cc=sys.argv[1];policy=sys.argv[2];groups=sys.argv[3:]
m={'dump':['--dump-static','--dump-typed'],'plain':[],'wall':['-Wall','-Wextra'],'debug':['-g'],'poison':['--poison-arenas'],'scalar':['--scalar'],'deferred':['--deferred-bodies'],'verify':['--verify'],'two':['--deferred-bodies'],'tier1':['--tier1'],'shared':['--shared-parts']}
def args(c):
 if c in ('sqlite','lua','musl'):
  return shlex.split(subprocess.check_output(['bash','-c','source ./corpora.sh; printf %s "$'+c+'_arguments"'],cwd=r,text=True))
 if c=='self':
  base=Path(os.environ['BUSTER_COMPILER_SOURCE']);return ['-march=native','-I'+str(base/'src'),'-fwrapv','-funsigned-char','--predefines',str(r/'proof-predefines.h'),str(base/'src/buster/compiler/main.c')]
 if c=='fixture':return [str(r/'initializer-stress.c'),str(r/'joined-finish.c')]
 if c=='inits':
  base=Path(os.environ['BUSTER_COMPILER_SOURCE'])/'tests';return [str(f) for f in sorted(base.rglob('*.c')) if any(x in str(f.relative_to(base)) for x in ('initializ','auto-type','compound-literal','constexpr','incomplete-array','auto-qualif','typeof'))]
 raise ValueError(c)
def sha(b):return hashlib.sha256(b).hexdigest()
with tempfile.TemporaryDirectory() as tmp,(r/f'{cc}-{policy}.tsv').open('w',buffering=1) as out:
 oe=Path(tmp)/'file.o';w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow('case unit status diff_status diff_diagnostic diff_elf diag_sha256 object_sha256'.split())
 for grp in groups:
  opts=args(grp);units=[a for a in opts if a.endswith('.c')];flags=[a for a in opts if not a.endswith('.c')];assert units,grp
  for unit in units:
   rows=[]
   for c in ('base-release',cc):
    oe.unlink(missing_ok=True);p=subprocess.run([r/c,'--lanes','2' if policy in ('two','shared') else '1',*m[policy],'-c',*flags,unit,'-o',oe],capture_output=True)
    rows.append((p.returncode,sha(p.stderr+p.stdout),sha(oe.read_bytes()) if oe.exists() else '-'))
   w.writerow([grp,Path(unit).name,rows[1][0],*[int(x!=y) for x,y in zip(*rows)],*rows[1][1:]])
   if rows[0]!=rows[1]:print('DIFF',grp,unit,policy,rows,flush=True)
