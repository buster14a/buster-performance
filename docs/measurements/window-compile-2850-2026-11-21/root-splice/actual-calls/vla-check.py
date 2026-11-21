from pathlib import Path
import csv,subprocess,tempfile,os,sys,hashlib
d=Path(__file__).resolve().parent; old=Path(sys.argv[1]);new=Path(sys.argv[2]);res=d/'vla-controls.tsv'
common=dict(NODE_SPLICE_FRONT='1',NODE_SOURCE_ROWS='1',NODE_SOURCE_ONLY='1',NODE_SOURCE_STRINGS='1',NODE_SOURCE_REFRESH_POINTERS='1',NODE_PROOF_NATIVE='1',NODE_PROOF_NO_FP='1',NODE_PROOF_CALLS='1',NODE_PROOF_POINTERS='1',NODE_SPLICE_ENABLE='1',NODE_SPLICE_CALLS='1',NODE_SPLICE_REPORT='1')
with res.open('w') as f,tempfile.TemporaryDirectory() as tmp:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('mode compile native_hash elf_hash taken link execute'.split())
 for mode,cc,e in [('ordinary',new,{}),('before',old,common),('registry',new,common),('view',new,dict(common,NODE_CROSS_TYPE_VIEW='1')),('clang',Path('/usr/bin/clang'),{})]:
  t=Path(tmp);o=t/'vla.o';nat=t/'native';exe=t/'exe'
  for file in o,nat,exe:file.unlink(missing_ok=True)
  args=[] if mode=='clang' else ['--lanes','1'];p=subprocess.run([cc,*args,'-g','-c',d/'vla.c','-o',o],capture_output=True,env=dict(os.environ,**e,NODE_SOURCE_NATIVE_ORACLE=str(nat)))
  takes=sum(n.startswith((b'splice-direct:',b'splice-taken:')) for n in p.stderr.splitlines())
  h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else '-'
  l=subprocess.run(['cc','-no-pie',d/'vla-main.c',o,'-o',exe],capture_output=True).returncode if o.exists() else '-'
  run=subprocess.run([exe],capture_output=True).returncode if l==0 and mode!='before' else '-'
  w.writerow((mode,p.returncode,h(nat),h(o),takes,l,run))
