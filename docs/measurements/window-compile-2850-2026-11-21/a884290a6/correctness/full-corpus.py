from collections import Counter
from pathlib import Path
from measure import args,compile_one,d
import hashlib,os,shlex,subprocess,tempfile,csv,sys
def cases():
 yield 'sqlite','sqlite3.c',args('sqlite')
 for tag in ['lua','musl']:
  raw=shlex.split(subprocess.check_output(['bash','-c','source "$BUSTER_CHECK_DIR/corpora.sh"; printf %s "$'+tag+'_arguments"'],cwd=Path(os.environ['BUSTER_CORPUS_DIR']),text=True))
  opts=['--predefines',d/'proof-predefines.h',*[v for v in raw if not v.endswith('.c')]]
  for u in [Path(v) for v in raw if v.endswith('.c')]:yield tag,str(u.relative_to(Path(os.environ['BUSTER_CORPUS_DIR']))),[*opts,u]
 yield 'self','main.c',args('self')
 for c in ('clean','warnings','rejected','conditions'):yield 'generated',c,[d/(c+'.c')]
 t=Path(os.environ['BUSTER_COMPILER_SOURCE'])/'tests/checker'
 for u in sorted(t.rglob('*.c')):
  if any(k in str(u.relative_to(t)) for k in ['branch-conditions','constant-conversions','division-by-zero','float-constants','parse-recovery','source-digits','condition','predicate','scalar','logical','convert','conversion','side-effect','overload','fenv','floating-environment','bit-int','decimal','constexpr','null-pointer','volatile','conditional','elvis','short-circuit']):yield 'checker',str(u.relative_to(t)),[u]
def run(pol,opts,tag):
 with (d/(tag+'-'+pol+'.tsv')).open('w',buffering=1) as out,tempfile.TemporaryDirectory() as tmp:
  w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow('group unit compiler status diagnostic_sha256 object_sha256'.split());o=Path(tmp)/'r.o'
  for g,k,aa in cases():
   e=compile_one(d/'native-base',[*opts,*aa],o,os.environ)
   for cc in sys.argv[2:]:
    r=compile_one(d/('native-'+cc),[*opts,*aa],o,os.environ);assert e==r,(g,k,pol,cc,e[0],r[0],e[1][:120],r[1][:120],e[2][:120],r[2][:120],e[3],r[3]);w.writerow([g,k,cc,r[0],hashlib.sha256(r[1]+r[2]).hexdigest(),r[3]])
if __name__=='__main__':
 for p,opts in [('ordinary',[]),('warnings',['-Wall','-Wextra'])]:run(p,opts,sys.argv[1])
