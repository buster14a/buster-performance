from pathlib import Path
import csv,hashlib,os,subprocess,sys,tempfile
from measure import args,d,compile_one
cc=sys.argv[1]
configs={'plain':[], 'debug':['-g'], 'tier1':['--tier1'], 'scalar':['--scalar'], 'poison':['--poison-arenas'], 'verify':['--verify'], 'warnings':['-Wextra','-Wall'], 'dump':['--dump-static','--dump-typed'], 'deferred':['--deferred-bodies']}
if __name__=='__main__':
 with (d/(cc+'-focused.tsv')).open('w',buffering=1) as out,tempfile.TemporaryDirectory() as tmp:
  w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow('policy case status diagnostic_sha256 object_sha256'.split())
  for pol,opts in configs.items():
   for c in (('sqlite','lua','musl','clean','warnings','rejected','conditions') if os.getenv('BUSTER_CHECK_QUICK') else ('sqlite','lua','musl','self','clean','warnings','rejected','conditions')):
    if c in ('sqlite','self') and pol in ('dump',):continue
    aa=args(c) if c in ('sqlite','lua','musl','self') else [d/(c+'.c')]
    o=Path(tmp)/'result.o';e=compile_one(d/os.getenv('BUSTER_CHECK_QA_BASE','base'),[*opts,*aa],o,os.environ);r=compile_one(d/cc,[*opts,*aa],o,os.environ)
    assert e==r,(pol,c,e[0],r[0],e[1][:180],r[1][:180],e[2][:180],r[2][:180],e[3],r[3]);w.writerow([pol,c,r[0],hashlib.sha256(r[1]+r[2]).hexdigest(),r[3]])
  assert sum(1 for _ in (d/(cc+'-focused.tsv')).open())==(63 if os.getenv('BUSTER_CHECK_QUICK') else 71)
