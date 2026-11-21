from pathlib import Path
import sys,hashlib,subprocess,shlex,tempfile,os,csv
from measure import d
pol=sys.argv[1];case=sys.argv[2];flags={'plain':[],'warnings':['-Wall','-Wextra'],'poison':['--poison-arenas'],'parallel':['--deferred-bodies']}[pol]
aa=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$'+case+'_arguments"'],cwd=d.parent/'switch-inputs',text=True))
with tempfile.TemporaryDirectory() as temp,(d/('multitu-'+case+'-'+pol+'.tsv')).open('w') as out:
 work=Path(temp);w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow('policy case compiler exit diagnostics_sha256 member object_sha256'.split());reference=None
 for cc in ('base','condition'):
  run=work/cc;run.mkdir()
  p=subprocess.run([d/('native-'+cc),'--lanes','2' if pol=='parallel' else '1',*flags,'--predefines',d.parent/'proof-predefines.h','-c',*aa],cwd=run,capture_output=True)
  objs={f.name:hashlib.file_digest(f.open('rb'),'sha256').hexdigest() for f in sorted(run.glob('*.o'))};diag=hashlib.sha256(p.stdout+p.stderr).hexdigest()
  assert p.returncode==0,(case,pol,cc,p.stderr[:350]);assert len(objs)==sum(a.endswith('.c') for a in aa),(len(objs),len(aa))
  pair=(p.returncode,diag,objs);assert reference is None or pair==reference,(case,pol,cc);reference=pair
  w.writerows([pol,case,cc,p.returncode,diag,m,h] for m,h in objs.items())
