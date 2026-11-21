"""Verify exact source behavior, retained rows, stage counts, and executable outputs."""
from pathlib import Path
import csv, hashlib, shlex, subprocess, tempfile, re
here=Path(__file__).resolve().parent
base=here/'clean-release'
head=here/'special-release'
files=['focused','bound','generated','physical-runtime','static','diagnostics','pragma','eligible','first-use']
policies={'default':[], 'all':['-Weverything'], 'error':['-Wall','-Wextra','-Werror'], 'debug':['-g'], 'scalar':['--scalar'], 'verify':['--verify'], 'transitions':['--check-transitions'], 'tier1':['--tier1'], 'tier1-no-lifetimes':['--tier1','--tier1-no-lifetimes'], 'combined':['--node-window-assignments'], 'poison':['--poison-arenas']}
modes={'default':[], 'window':['--node-window'], 'calls':['--node-window-calls']}
sql=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$sqlite_arguments"'],cwd=here.parent/'switch-inputs',text=True))
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else '-'
with tempfile.TemporaryDirectory() as tmp, (here/'special-qualification.tsv').open('w',buffering=1) as out:
 tmp=Path(tmp); a=tmp/'a.o'
 w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow(['unit','policy','mode','returncode','diag_sha256','object_sha256','taken','replaced','remaining','same'])
 for name, arg in [*[(f,[here/(f+'.c')]) for f in files],('sqlite',sql)]:
  for pol,opt in policies.items():
   if name=='sqlite' and pol not in ('default','scalar','transitions','error'):continue
   for m,flag in modes.items():
    pair=[]
    for cc in (base,head):
     a.unlink(missing_ok=True)
     cmd=[cc,'--lanes','1',*flag,*opt,'-c',*arg,'-o',a];p=subprocess.run(cmd,capture_output=True)
     plain_object=digest(a); counts=['-']*3
     if m!='default' and p.returncode==0:
      pr=subprocess.run([cc,'--time-stages',*cmd[1:]],capture_output=True)
      matches=re.search(rb'node-window: taken=(\d+) ordinary-nodes-replaced=(\d+) summary-nodes=\d+ graph-nodes=(\d+)',pr.stderr);counts=[x.decode() for x in matches.groups()] if matches else ['absent']*3
      assert pr.returncode==0 and digest(a)==plain_object
     pair.append((p.returncode,hashlib.sha256(p.stderr+p.stdout).hexdigest(),plain_object,*counts))
    w.writerow([name,pol,m,*pair[1],int(pair[0]==pair[1])]);assert pair[0]==pair[1],(name,pol,m,pair)
    if name=='sqlite' and pol=='default' and m=='calls':assert pair[1][3:]==('4551','16391','311783')
 for cc in (base,head):
  exe=tmp/'run'
  p=subprocess.run([cc,'--node-window-calls',here/'physical-runtime.c','-o',exe],capture_output=True);assert p.returncode==0,p.stderr
  assert subprocess.run([exe]).returncode==0
