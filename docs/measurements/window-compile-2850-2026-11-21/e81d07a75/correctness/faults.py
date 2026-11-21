from pathlib import Path
import csv,os,sys,subprocess,tempfile,hashlib
d=Path(__file__).resolve().parent;cc=Path(sys.argv[1]).resolve()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else '-'
with (d/'mutations.tsv').open('w') as f,tempfile.TemporaryDirectory() as td:
 t=Path(td);w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('fixture mutant compiler diagnostics native refs elf linker runtime admitted'.split())
 for unit,variants in [('physical-runtime',['clean','argument','target']),('static',['clean','reference']),('diagnostics',['clean','read'])]:
  for var in variants:
   o=t/'x.o';native=t/'n';refs=t/'r';ex=t/'exe'
   for p in (o,native,refs,ex):p.unlink(missing_ok=True)
   env=dict(os.environ,BUSTER_WINDOW_CALL_LOG='1',NODE_SOURCE_NATIVE_ORACLE=str(native),BUSTER_CALL_REFERENCES=str(refs));env.pop('BUSTER_CALL_MUTANT',None)
   if var!='clean':env['BUSTER_CALL_MUTANT']=var
   flags=['-Wall','-Wextra','-Werror'] if unit=='diagnostics' else []
   p=subprocess.run([cc,'--lanes','1','--node-window-calls',*flags,'-c',d/(unit+'.c'),'-o',o],env=env,capture_output=True)
   ds=[k for k in p.stderr.splitlines(keepends=True) if not k.startswith(b'plain-call:')];log=b''.join(ds)
   link=run='-'
   if o.exists() and unit!='diagnostics':
    link=subprocess.run(['cc','-no-pie',o,'-o',ex],capture_output=True).returncode
    if link==0:run=subprocess.run([ex],capture_output=True).returncode
   w.writerow([unit,var,p.returncode,hashlib.sha256(log).hexdigest(),sha(native),sha(refs),sha(o),link,run,p.stderr.count(b'plain-call:')])
