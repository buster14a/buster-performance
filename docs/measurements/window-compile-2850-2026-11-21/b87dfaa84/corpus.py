from pathlib import Path
import csv,subprocess,os,hashlib,sys
d=Path(__file__).resolve().parent;out=Path(os.environ.get('CHAIN_CORPUS_OUTPUT',d/'real'));out.mkdir(exist_ok=True)
g=sys.argv[1];opts=[s for s in sys.argv[2:] if not s.endswith('.c')];files=[s for s in sys.argv[2:] if s.endswith('.c')]
ref=(d/'../main-fbef-clean/build/compiler').resolve();exe=Path(os.environ.get('CHAIN_COMPILER', d/'compiler-stage-a'))
sha=lambda s:hashlib.sha256(s).hexdigest()
with (out/(g+'.tsv')).open('w',buffering=1) as f:
 w=csv.writer(f,delimiter='\t');w.writerow('file policy ref-exit local-exit obj-equal stdout-equal stderr-equal bytes ref-sha source-sha'.split())
 for i,s in enumerate(files):
  for policy,flags in [('default',[]),('wall',['-Wall','-Wextra']),('strict',['-Wall','-Wextra','-Werror']),('quiet',['-w']),('everything',['-Weverything'])]:
   rr=[]
   for arm in ('clean','source'):
    obj=out/(g+'-unit.o');obj.unlink(missing_ok=True)
    r=subprocess.run([ref if arm=='clean' else exe,'--lanes','1','-c',*opts,*flags,s,'-o',obj],env=os.environ|({'BUSTER_CONTROL_MEMBER_OPERANDS':'1','BUSTER_CHAIN_POISON':'1'} if arm=='source' else {}),capture_output=True,timeout=90)
    rr.append((r.returncode,sha(obj.read_bytes()) if obj.exists() else '',r.stdout,r.stderr))
    if (g in ('main','sqlite')):(out/f'{g}-{policy}-{arm}.stderr').write_bytes(r.stderr)
   a,b=rr;w.writerow((s,policy,a[0],b[0],*(int(a[j]==b[j]) for j in range(1,4)),len(a[3]),sha(a[3]),sha(b[3])))
   if a!=b:
    for arm,row in zip(('clean','source'),rr):(out/f'{g}-{i}-{policy}-{arm}.stderr').write_bytes(row[3])
